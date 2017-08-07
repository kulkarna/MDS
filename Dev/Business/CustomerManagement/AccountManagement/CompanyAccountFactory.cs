using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Linq;
using System.Transactions;
using LibertyPower.Business.CustomerAcquisition.DailyPricing;
using LibertyPower.DataAccess.SqlAccess.AccountSql;
using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;
using LibertyPower.Business.MarketManagement.UsageManagement;
using LibertyPower.Business.MarketManagement.UtilityManagement;
using LibertyPower.Business.CustomerAcquisition.ProductManagement;
using LibertyPower.Business.MarketManagement.EdiManagement;
using LibertyPower.Business.CommonBusiness.CommonHelper;
using LibertyPower.Business.CustomerAcquisition.RateManagement;
using Common.Logging;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	/// <summary>
	/// Company account related methods
	/// </summary>
	public static class CompanyAccountFactory
	{

        public static string PerformScrappingAndCalculation(string utilityCode, string processName)
        {

            var exceptions = string.Empty;
            DataTable dt = null;
            string Rate = "";
            string strMsg = "";
            string ErrorMsg = string.Empty;

           
            try
            {
                dt = AccountSqlLP.GetEnrollmentAccounts(utilityCode, processName).Tables[0];

                foreach (DataRow row in dt.Rows)
                {
                    string AccountNumber = Convert.ToString(row["account_number"]);
                    string ContractNumber = Convert.ToString(row["contract_nbr"]);
                    string AccountId = Convert.ToString(row["account_id"]);

                    try
                    {
                        object result = ScraperFactory.RunScraper(AccountNumber, utilityCode, "", out strMsg);

                        if (utilityCode == "COMED")
                        {
                            if (!(strMsg.Contains("Account number is not valid.") || strMsg.Contains("Account has been blocked per customer request.")))
                            {
                                Rate = "x1.";
                                Comed comed = new Comed();

                                comed = (Comed)result;

                                foreach (ComedUsage usage in comed.WebUsageList)
                                {
                                    Rate = usage.Rate;
                                    break;
                                }
                            }
                        }
                    }

                    catch (Exception ex)
                    {
                        if (Rate == "x1.")
                            ErrorMsg += "An unhandled error ocurred while updating rate for " + AccountNumber + " described as " + ex.Message + " <br>";
                        else
                            ErrorMsg += "Please manually check account " + AccountNumber + " on " + utilityCode + "'s website <br>";

                        Rate = "";
                        strMsg = "keep going";
                    }

                    if (strMsg != "keep going")
                        ErrorMsg += HandleResponse(strMsg, utilityCode, AccountNumber, ContractNumber, AccountId, Rate);

                }

            }
            catch (Exception ex)
            {
                if(ex.Message.ToUpper().Contains("INVALID UTILITY"))
                ErrorMsg += Convert.ToString(ex.Message);
                else 
                ErrorMsg +=Convert.ToString(ex.InnerException);

            }

            return ErrorMsg;

        }

        private static string HandleResponse(string message, string utilityID, string accountNumber, string contractNumber, string accountId, string comedRate)
        {
            string ErrorMsg = "";
            string value = "";

            if (message.Contains("Missing data - Web Usage List Data"))
                ErrorMsg = "Account " + accountNumber + " is missing Historical Usage";
            else if (message == "Account number is not valid." | message == "Account has been blocked per customer request.")
                ErrorMsg = "Account " + accountNumber + message.Remove(0, 7);
            else if (message.Contains("Account number is not valid.") | message.Contains("Account has been blocked per customer request."))
                ErrorMsg = message.Substring(0, message.Length - 19).Remove(0, 27);
            else
                value = UpdateSystem(accountNumber, utilityID, accountId, comedRate);		//update annual usage..

            if (ErrorMsg != "")
            {
                AccountSqlLP.RejectAccount(contractNumber);
                return string.Format(" {0}<br>", ErrorMsg);
            }

            // ------------------------------------------
            if (value.Length > 0)
                ErrorMsg = string.Format(" {0}<br>", value);

            return ErrorMsg;
        }

        /// <summary>
        /// Extracted from the AcquireUsage project (Update annual usage++)
        /// </summary>
        /// <param name="accountNumber"></param>
        private static string UpdateSystem(string accountNumber, string utilityID, string accountId, string comedRate)
        {
            bool value = false;
            string message = "";
            string user = System.Security.Principal.WindowsIdentity.GetCurrent().Name;
            user = (string)user.Split('\\').GetValue(1);

            // ------------------------------------------
            // calculate annual usage
            value = CompanyAccountFactory.CalculateAnnualUsage(accountNumber, utilityID, user, "usage_acquire.ascx", false, accountId);

            if (!value)
            {
                // ------------------------------------------
                // update check_account status..
                AccountSqlLP.UpdateEnrollmentAccounts(accountNumber);

                //Ticket 1-5903271
                string strErrMsg = string.Empty;

                DataSet dsTemp = AccountSqlLP.GetCheckAuditUsageUsed(accountNumber);

                if (dsTemp != null)
                    if (dsTemp.Tables[0].Rows[0]["ErrorMessage"].ToString().Trim().Length > 0)
                        strErrMsg = dsTemp.Tables[0].Rows[0]["ErrorMessage"].ToString();

                if (strErrMsg != string.Empty)
                    message = "There was an error while calculating " + accountNumber + "'s annual usage, the error is described as: " + strErrMsg;
                else
                    message = "There was an error while calculating " + accountNumber + "'s annual usage; please have IT check the AuditUsageUsedLog log.";
            }
            else
            {
                // ------------------------------------------
                // record usage event..
                AccountEventType aet = AccountEventType.UsageUpdate;
                AccountEventType eventAssociate = AccountEventType.DealSubmission;

                AccountEventProcessor.ProcessEvent(eventAssociate, aet, accountNumber, utilityID, ResponseType.None, null);
            }

            // ------------------------------------------
            // update rate for COMED - 1-2176286
            if (utilityID == "COMED")
                CompanyAccountFactory.UpdateServiceRateClass(accountId, comedRate);

            return message;
        }

        // March 2010
        // ------------------------------------------------------------------------------------
        /// <summary>
        /// Given an account this method calculates the annual usage + updates the necessary tables
        /// </summary>
        /// <param name="account"></param>
        /// <param name="utility"></param>
        /// <param name="from"></param>
        /// <param name="to"></param>
        /// <param name="user"></param>
        /// <returns></returns>
        public static bool CalculateAnnualUsage(string account, string utility, string user, string process_id, bool isRenewal, string accountId)
        {
            DateTime from = DateTime.Today.AddDays(-730);						//make sure you get enough meter reads..
            DateTime to = DateTime.Now;
            bool returnValue = false;
            Int16 step = 1;
            string method, nameSpace;
            string renewal = (isRenewal == true ? " due to renewal process." : "");
            bool isIdrResults = false;
            bool multipleMeters = false;
            UsageList snapshot = new UsageList();
            UsageList rawList = null;
            double idrUsage = 0.00;
            int annualUsage = 0;
            try
            {
                rawList = UsageFactory.GetRawUsage(account, utility, from, to, user);
                step += 1;
                if (rawList.Count == 0)
                {
                    idrUsage = UsageFactory.GetIdrAnnualUsage(account, utility, from, to, out isIdrResults);
                    if (isIdrResults)
                    {
                        annualUsage = Convert.ToInt32(idrUsage);
                        step = 8;
                    }
                    else
                    {
                        UsageSql.InsertAuditUsageUsedLog("UsageFactory", "GetRawUsage", "Account has no usage available.", "Calculating Annual Usage of Account " + account, user);
                        return returnValue;
                    }
                }
                else
                {
                    step = processCalcualtionProcess(out snapshot, step, utility, out multipleMeters, rawList, out method, out nameSpace);
                    annualUsage = Convert.ToInt32(UsageFiller.ComputeAnnualUsage(snapshot));
                    step += 1;
                }
                CompanyAccount accountInfo = GetExistingAnnualUsage(account, utility, isRenewal, accountId);
                if (accountInfo.AnnualUsage != annualUsage)
                {
                    step += 1;
                    InsertComment(accountInfo.Identifier, process_id, "Usage updated from " + accountInfo.AnnualUsage + " to " + annualUsage + renewal, user);
                    step += 1;
                    UpdateAnnualUsage(accountInfo.Identifier, annualUsage, isRenewal);
                    step += 1;
                    if (!isIdrResults)
                        UsageFiller.AuditUsageUsed(snapshot, process_id, user);
                    step += 1;
                    AccountEventType aet = AccountEventType.UsageUpdate;
                    AccountEventType eventAssociate = AccountEventType.DealSubmission;

					if( isRenewal )
						eventAssociate = AccountEventType.RenewalSubmission;

					AccountEventProcessor.ProcessEvent( eventAssociate, aet, accountInfo.AccountNumber, utility, ResponseType.None, null );
				}
				else
				{
					UsageSql.InsertAuditUsageUsedLog( "UsageManagement", "CalculateAnnualUsage", "", "Account " + account + " already has an annual usage = " + annualUsage, user );
					step = 12;
				}
			}
			catch( Exception ex )
			{
				switch( step )
				{
					case 1:
						method = "GetRawUsage";
						nameSpace = "UsageFactory";
						break;
					case 2:
						method = "AnnualUsageValidTypes";
						nameSpace = "UsageFiller";
						break;
					case 3:
						method = "MultipleMeters";
						nameSpace = "UtilityFactory";
						break;
					case 4:
						method = "RemoveLingeringInactive";
						nameSpace = "UsageFiller";
						break;
					case 5:
						method = "Get364DateRange";
						nameSpace = "UsageFiller";
						break;
					case 6:
						method = "DeleteUsageNotInRange";
						nameSpace = "UsageFiller";
						break;
					case 7:
						method = "ComputeAnnualUsage";
						nameSpace = "UsageFiller";
						break;
					case 8:
						method = "GetExistingAnnualUsage";
						nameSpace = "CompanyAccountFactory";
						break;
					case 9:
						method = "InsertComment";
						nameSpace = "AccountSql";
						break;
					case 10:
						method = "UpdateAnnualUsage";
						nameSpace = "CompanyAccountFactory";
						break;
					case 11:
						method = "AuditUsageUsed";
						nameSpace = "UsageFiller";
						break;
					case 12:
						method = "ProcessEvent";
						nameSpace = "AccountEventProcessor";
						break;
					default:
						method = "CalculateAnnualUsage";
						nameSpace = "UsageManagement";
						break;
				}
				UsageSql.InsertAuditUsageUsedLog( nameSpace, method, ex.Message, "Calculating Annual Usage of Account " + account, user );
			}

			if( step == 12 )
				returnValue = true;

			return returnValue;
		}

        public static bool CalculateAnnualUsage(string account, string utility, out int AnnualUsage)
        {
            DateTime from = DateTime.Today.AddDays(-730);						//make sure you get enough meter reads..
            DateTime to = DateTime.Now;
            bool returnValue = false;
            Int16 step = 1;
            string method, nameSpace;
            int annualUsage = 0;
            UsageList snapshot = new UsageList();

            bool multipleMeters = false;
            UsageList rawList = null;
            double idrUsage = 0.00;
            bool isIdrResults = false;
            try
            {
                rawList = UsageFactory.GetRawUsage(account, utility, from, to, "Phoenix");
                step += 1;
                if (rawList.Count == 0)
                {
                    idrUsage = UsageFactory.GetIdrAnnualUsage(account, utility, from, to, out isIdrResults);
                    if (isIdrResults)
                    {
                        annualUsage = Convert.ToInt32(idrUsage);
                        step = 8;
                    }
                    else
                    {
                        UsageSql.InsertAuditUsageUsedLog("UsageFactory", "GetRawUsage", "Account has no usage available.", "Calculating Annual Usage of Account " + account, "Phoenix");
                        AnnualUsage = annualUsage;
                        return returnValue;
                    }
                }
                else
                {
                    step = processCalcualtionProcess(out snapshot, step, utility, out multipleMeters, rawList, out method, out nameSpace);
                    annualUsage = Convert.ToInt32(UsageFiller.ComputeAnnualUsage(snapshot));
                    step += 1;
                    UsageFiller.AuditUsageUsed(snapshot, "Phoenix WS", "Phoenix");

                }

            }
            catch (Exception ex)
            {
                switch (step)
                {
                    case 1:
                        method = "GetRawUsage"; 
                        nameSpace = "UsageFactory";
                        break;
                    case 2:
                        method = "AnnualUsageValidTypes";
                        nameSpace = "UsageFiller";
                        break;
                    case 3:
                        method = "MultipleMeters";
                        nameSpace = "UtilityFactory";
                        break;
                    case 4:
                        method = "RemoveLingeringInactive"; 
                        nameSpace = "UsageFiller";
                        break;
                    case 5:
                        method = "Get364DateRange"; 
                        nameSpace = "UsageFiller";
                        break;
                    case 6:
                        method = "DeleteUsageNotInRange"; 
                        nameSpace = "UsageFiller";
                        break;
                    case 7:
                        method = "ComputeAnnualUsage"; 
                        nameSpace = "UsageFiller";
                        break;
                    case 8:
                        method = "AuditUsageUsed"; 
                        nameSpace = "UsageFiller";
                        break;
                    default:
                        method = "CalculateAnnualUsage"; 
                        nameSpace = "UsageManagement";
                        break;
                }
                UsageSql.InsertAuditUsageUsedLog(nameSpace, method, ex.Message, "Calculating Annual Usage of Account " + account, "Phoenix");
            }

            if (step == 8)
                returnValue = true;

            AnnualUsage = annualUsage;
            return returnValue;
        }


        private static Int16 processCalcualtionProcess(out UsageList snapshot, Int16 step, string utility, out bool multipleMeters, UsageList rawList, out string method, out string nameSpace)
        {

            try
            {
                UsageList validList = UsageFiller.AnnualUsageValidTypes(rawList);
                step += 1;
                multipleMeters = UtilityFactory.GetUtilityByCode(utility).MultipleMeters;
                step += 1;
                UsageList cleanList = UsageFiller.removeLingeringInactive(validList);
                step += 1;
                DateRange range;
                //cleanList = UsageFactory.SortMeterReads(cleanList, true);
                cleanList = UsageFactory.SortMeterReadsEndDate(cleanList, true);
                range = UsageFiller.Get364DateRange(cleanList);				//get 364 date range (in order to calculate annual usage)..
                step += 1;
                snapshot = UsageFiller.DeleteUsageNotInRange(cleanList, range);
                step += 1;

            }
            catch (Exception ex)
            {
                switch (step)
                {
                    case 1:
                        method = "GetRawUsage"; 
                        nameSpace = "UsageFactory";
                        break;
                    case 2:
                        method = "AnnualUsageValidTypes";
                        nameSpace = "UsageFiller";
                        break;
                    case 3:
                        method = "MultipleMeters";
                        nameSpace = "UtilityFactory";
                        break;
                    case 4:
                        method = "RemoveLingeringInactive";
                        nameSpace = "UsageFiller";
                        break;
                    case 5:
                        method = "Get364DateRange";
                        nameSpace = "UsageFiller";
                        break;
                    case 6:
                        method = "DeleteUsageNotInRange"; 
                        nameSpace = "UsageFiller";
                        break;
                    case 7:
                        method = "ComputeAnnualUsage"; 
                        nameSpace = "UsageFiller";
                        break;
                    case 8:
                        method = "AuditUsageUsed";
                        nameSpace = "UsageFiller";
                        break;
                    default:
                        method = "CalculateAnnualUsage"; 
                        nameSpace = "UsageManagement";
                        break;
                }
                step = 0;
                snapshot = null;
                multipleMeters = false;

            }
            method = null;
            nameSpace = null;
            return step;
        }

        public static bool ConsolidateUsage(string account, string utility, string user)
        {
            DateTime from = DateTime.Today.AddDays(-730);						//make sure you get enough meter reads..
            DateTime to = DateTime.Now;
            bool returnValue = false;
            Int16 step = 1;
            string method = "", nameSpace = "";

			try
			{
				UsageList rawList = UsageFactory.GetRawUsage( account, utility, from, to, user );
				step += 1;

				if( rawList.Count == 0 )
				{
					UsageSql.InsertAuditUsageUsedLog( "UsageFactory", "GetRawUsage", "ConsolidateUsage - account has no usage available.", "Calculating Annual Usage of Account " + account, user );
					return false;
				}

				UsageList validList = UsageFiller.AnnualUsageValidTypes( rawList );
				step += 1;
				UsageList snapshot = UsageFactory.GetSnapshot( validList, account, utility, user );

			}
			catch( Exception ex )
			{
				switch( step )
				{
					case 1:
						method = "GetRawUsage";
						nameSpace = "UsageFactory";
						break;
					case 2:
						method = "AnnualUsageValidTypes";
						nameSpace = "UsageFiller";
						break;
					case 3:
						method = "GetSnapshot";
						nameSpace = "UsageFactory";
						break;
				}
				UsageSql.InsertAuditUsageUsedLog( nameSpace, method, ex.Message, "ConsolidateUsage - calculating Annual Usage of Account " + account, user );
			}

			if( step == 3 )
				returnValue = true;

			return returnValue;
		}

        // April 2010
        // ------------------------------------------------------------------------------------
        public static bool CalculateAnnualUsage(string contract_number, string user, string process_id, bool isRenewal)
        {
            bool returnValue = true;
            Contract contract;
            char renewal = isRenewal == true ? 'Y' : 'N';

			//get list of accounts
			contract = ContractFactory.GetContractWithAccounts( contract_number, renewal );

			//process each one
			foreach( CompanyAccount account in contract.Accounts )
			{
				//per eric, if an account is a renewal and the usage is not 0 then it has already been processed
				if( isRenewal && account.AnnualUsage != 0 )
					continue;
				else
					returnValue &= CalculateAnnualUsage( account.AccountNumber, account.UtilityCode, user, process_id, isRenewal, account.Identifier );
			}

			return returnValue;
		}

		/// <summary>
		/// added for 1-17232491 as the account class specifically excluded the loadprofile property (no documentation or notes as to why that
		/// was done). Load profile is needed to determine rate class for TOU meters for NSTAR 
		/// </summary>
		/// <param name="accountId"></param>
		/// <returns></returns>
        public static string  AccountLoadProfile(string accountId)
		{
			string loadProfile = string.Empty;

			DataSet ds = LibertyPowerSql.GetAccount( accountId );

			if( ds == null || ds.Tables.Count == 0 || ds.Tables[0].Rows.Count == 0 )
			{
                throw new AccountNotFoundException("Company Account record could not be found.");
			}
            loadProfile =  ds.Tables[0].Rows[0]["loadprofile"].ToString();
			return loadProfile;
		}


		// ------------------------------------------------------------------------------------
		public static CompanyAccount GetCompanyAccount( int Identity )
		{
			DataSet ds = LibertyPowerSql.GetAccount( Identity );

			if( ds == null || ds.Tables.Count == 0 || ds.Tables[0].Rows.Count == 0 )
			{
				throw new AccountNotFoundException( "Company Account record could not be found." );
			}
			CompanyAccount account = BuildCompanyAccountObject( ds.Tables[0].Rows[0] );
			return account;
		}

		// ------------------------------------------------------------------------------------
		public static CompanyAccount GetCompanyAccount( string accountId )
		{
			DataSet ds = LibertyPowerSql.GetAccount( accountId );

			if( ds == null || ds.Tables.Count == 0 || ds.Tables[0].Rows.Count == 0 )
			{
				throw new AccountNotFoundException( "Company Account record could not be found." );
			}
			CompanyAccount account = BuildCompanyAccountObject( ds.Tables[0].Rows[0] );
			return account;
		}

        // ------------------------------------------------------------------------------------
		public static CompanyAccount GetCompanyAccountByLegacyId( string accountIdLegacy )
        {
			DataSet ds = LibertyPowerSql.GetAccountByLegacyId( accountIdLegacy );

			if( ds == null || ds.Tables.Count == 0 || ds.Tables[0].Rows.Count == 0 )
            {
				throw new AccountNotFoundException( "Company Account record could not be found." );
            }
			CompanyAccount account = BuildCompanyAccountObject( ds.Tables[0].Rows[0] );
            return account;
        }

		// November 2010 - ticket 19421
		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Retrieves existing annual usage of an account
		/// </summary>
		/// <param name="accountId"></param>
		/// <returns></returns>
		public static CompanyAccount GetCompanyAccountDataRaw( string accountId )
		{
			DataSet ds = LibertyPowerSql.GetAccount( accountId );

			if( ds == null || ds.Tables.Count == 0 || ds.Tables[0].Rows.Count == 0 )
				throw new AccountNotFoundException( "Company Account record could not be found." );

			CompanyAccount account = BuildRawCompanyAccountObject( ds.Tables[0].Rows[0] );
			return account;
		}

		// ------------------------------------------------------------------------------------
		public static CompanyAccount GetCompanyAccountWithoutProxyUsage( string accountId )
		{
			DataSet ds = LibertyPowerSql.GetAccount( accountId );

			if( ds == null || ds.Tables.Count == 0 || ds.Tables[0].Rows.Count == 0 )
			{
				throw new AccountNotFoundException( "Company Account record could not be found." );
			}
			CompanyAccount account = BuildCompanyAccountObject( ds.Tables[0].Rows[0], false );
			return account;
		}

		public static CompanyAccount GetCompanyAccount( string accountNumber, string utilityCode )
		{
			DataSet ds = LibertyPowerSql.GetAccount( accountNumber, utilityCode );

			if( ds == null || ds.Tables.Count == 0 || ds.Tables[0].Rows.Count == 0 )
			{
				throw new AccountNotFoundException( "Company Account record could not be found." );
			}
			CompanyAccount account = BuildCompanyAccountObject( ds.Tables[0].Rows[0] );
			return account;
		}

		public static bool TryGetCompanyAccount( string accountNumber, string utilityCode, out CompanyAccount account )
		{
			DataSet ds = LibertyPowerSql.GetAccount( accountNumber, utilityCode );

			if( ds == null || ds.Tables.Count == 0 || ds.Tables[0].Rows.Count == 0 )
			{
				account = null;
				return false;
			}
			account = BuildCompanyAccountObject( ds.Tables[0].Rows[0] );
			return true;
		}

        public static bool IsAddOnAccount( string accountNumber, string utilityCode )
        {
            DataSet ds = LibertyPowerSql.GetAccount(accountNumber, utilityCode);

            return (ds == null || ds.Tables.Count == 0 || ds.Tables[0].Rows.Count == 0);
        }

		public static CompanyAccountCollection GetCompanyAccountCollection( List<string> accountNumbersCsvList, List<string> utilityCodesCsvList )
		{
			string accountsCsv = string.Empty, utilitiesCsv = string.Empty;
			accountNumbersCsvList.ForEach( a => accountsCsv += a + "," );
			utilityCodesCsvList.ForEach( u => utilitiesCsv += u + "," );
			return GetCompanyAccountCollection( accountsCsv, utilitiesCsv );
		}

		public static CompanyAccountCollection GetCompanyAccountCollection( string accountNumbersCsvList, string utilityCodesCsvList )
		{
			DataSet ds = LibertyPowerSql.GetAccounts( accountNumbersCsvList, utilityCodesCsvList );
			CompanyAccountCollection accounts = null;
			if( ds == null || ds.Tables.Count == 0 || ds.Tables[0].Rows.Count == 0 )
			{
				throw new AccountNotFoundException( "Company Account records could not be found." );
			}
			accounts = new CompanyAccountCollection();
			foreach( DataRow item in ds.Tables[0].Rows )
				accounts.Add( BuildCompanyAccountObject( item ) );

			return accounts;
		}

        public static CompanyAccountCollection GetUploadedCompanyAccountCollection(List<string> accountNumbersCsvList, List<string> utilityCodesCsvList)
        {
            string accountsCsv = string.Empty, utilitiesCsv = string.Empty;
            accountNumbersCsvList.ForEach(a => accountsCsv += a + ",");
            utilityCodesCsvList.ForEach(u => utilitiesCsv += u + ",");
            return GetUploadedCompanyAccountCollection(accountsCsv, utilitiesCsv);
        }

        public static CompanyAccountCollection GetUploadedCompanyAccountCollection(string accountNumbersCsvList, string utilityCodesCsvList)
        {
            DataSet ds = LibertyPowerSql.GetUploadedAccounts(accountNumbersCsvList, utilityCodesCsvList);
            CompanyAccountCollection accounts = null;
            if (ds == null || ds.Tables.Count == 0 || ds.Tables[0].Rows.Count == 0)
            {
                throw new AccountNotFoundException("Company Account records could not be found.");
            }
            accounts = new CompanyAccountCollection();
            foreach (DataRow item in ds.Tables[0].Rows)
                accounts.Add(BuildCompanyAccountObject(item));

            return accounts;
        }

		// March 2010
		// ------------------------------------------------------------------------------------
		/// <summary>
		/// This method returns account pertinent information based on the chosen source (from renewal or account table)
		/// </summary>
		/// <param name="account"></param>
		/// <param name="utility"></param>
		/// <param name="isRenewal"></param>
		/// <returns></returns>
		public static CompanyAccount GetExistingAnnualUsage( string account, string utility, bool isRenewal, string accountId )
		{
			CompanyAccount acct;

			if( isRenewal )
				acct = CompanyAccountFactory.GetCompanyAccountRenewalAnnualUsage( account, utility );
			else
				acct = CompanyAccountFactory.GetCompanyAccountDataRaw( accountId );

			return acct;
		}

		// November 2010 - ticket 19421
		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Copied from BuildCompanyAccountObject for CalculateAnnualUsage
		/// </summary>
		/// <param name="dr">Data row</param>
		/// <returns></returns>
		private static CompanyAccount BuildRawCompanyAccountObject( DataRow dr )
		{
			string legacyAccountId = dr["LegacyAccountId"].ToString();

			CompanyAccount account = new CompanyAccount( legacyAccountId );
			string productId = dr["ProductId"].ToString();
			decimal rate = Convert.ToDecimal( dr["Rate"] );
			int rateId = Convert.ToInt32( dr["RateId"] );

			account.Identity = Convert.ToInt32( dr["AccountId"] );
			account.AccountNumber = dr["AccountNumber"].ToString();
			account.AccountType = (CompanyAccountType) Enum.Parse( typeof( CompanyAccountType ), dr["AccountType"].ToString(), true );
			account.AnnualUsage = dr["AnnualUsage"] == DBNull.Value ? 0 : (int) dr["AnnualUsage"];

			account.ReadCycleId = dr["BillCycleId"].ToString();
			account.ContractNumber = dr["ContractNumber"].ToString();
			account.ContractEndDate = Convert.ToDateTime( dr["ContractEndDate"] );
			account.ContractStartDate = Convert.ToDateTime( dr["ContractStartDate"] );
			account.ContractType = dr["ContractType"].ToString();
			account.DateDeal = Convert.ToDateTime( dr["DateDeal"] );
			account.DateSubmit = Convert.ToDateTime( dr["DateSubmit"] );
			account.DeenrollmentDate = Convert.ToDateTime( dr["DeenrollmentDate"] );
			account.FlowStartDate = Convert.ToDateTime( dr["FlowStartDate"] );
			account.Rate = rate;
			account.Term = Convert.ToInt32( dr["Term"] );
			account.UtilityCode = dr["UtilityCode"].ToString();
			account.ProductId = dr["ProductID"].ToString();
			account.RetailMarketCode = dr["RetailMarketCode"].ToString();
			account.SalesChannelId = dr["SalesChannelId"].ToString();
			account.SalesRep = dr["SalesRep"].ToString();
			account.ZoneCode = dr["ZoneCode"].ToString();
			account.RateClass = dr["RateClass"].ToString();
			account.CurrentEtfID = Helper.ConvertFromDB<int?>( dr["CurrentEtfID"] );

			account.EnrollmentStatus = dr["EnrollmentStatus"].ToString();
			account.EnrollmentSubStatus = dr["EnrollmentSubStatus"].ToString();

			account.WaiveEtf = Convert.ToBoolean( dr["WaiveEtf"] );
			account.WaivedEtfReasonCodeID = Helper.ConvertFromDB<int?>( dr["WaivedEtfReasonCodeID"] );

			account.BusinessName = dr["BusinessName"].ToString();

			account.CreditScore = null;

			if( dr["credit_score"] != DBNull.Value )
				account.CreditScore = Convert.ToDecimal( dr["credit_score"] );

			account.CreditAgency = Convert.ToString( dr["credit_agency"] );

			return account;
		}

		/// <summary>
		/// Method for Phoenix that returs most recent meter read date
		/// </summary>
		/// <param name="accountNumber"></param>
		/// <param name="utilityCode"></param>
		/// <returns></returns>
		public static DateTime GetMostRecentMeterDate( string accountNumber, string utilityCode )
		{
			DateTime returnVal = DateTime.MinValue;
			DateTime from = DateTime.Today.AddDays( -730);		//Changed the number of days to 730.PBI_69505
			DateTime to = DateTime.Now;

			UsageList rawList = UsageFactory.GetRawUsage( accountNumber, utilityCode, from, to, "Phoenix" );

			bool multipleMeters = UtilityFactory.GetUtilityByCode( utilityCode ).MultipleMeters;

			UsageList cleanList = UsageFiller.removeLingeringInactive( rawList );
			cleanList = UsageFactory.SortMeterReads( cleanList, multipleMeters );

			if( cleanList.Count != 0 )
				returnVal = cleanList[0].EndDate;

            return returnVal;
        }
        /// <summary>
        /// This method was added for CRMServiceAccountUpdater
        /// </summary>
        /// <param name="accountNumber"></param>
        /// <param name="utilityCode"></param>
        /// <returns></returns>
        public static DateTime GetMostRecentMeterDateWithoutUsageConsolidation(string accountNumber, string utilityCode)
        {
            DateTime returnVal = DateTime.MinValue;

            // Obtain the already consolidated usage
            UsageList cleanList = UsageFactory.GetList(accountNumber, utilityCode, DateTime.Today.AddYears(-2), DateTime.Today);

            bool multipleMeters = UtilityFactory.GetUtilityByCode(utilityCode).MultipleMeters;

            cleanList = UsageFiller.removeLingeringInactive(cleanList);
            cleanList = UsageFactory.SortMeterReadsEndDate(cleanList, multipleMeters);

            if (cleanList.Count != 0)
                returnVal = cleanList[0].EndDate;

            return returnVal;

        }


		// ------------------------------------------------------------------------------------
		private static CompanyAccount BuildCompanyAccountObject( DataRow dr, bool UseProxyUsage )
		{
			string legacyAccountId = dr["LegacyAccountId"].ToString();

			CompanyAccount account = new CompanyAccount( legacyAccountId );
			if( dr.Table.Columns.Contains( "BillingType" ) == true )
				account.BillingType = dr["BillingType"].ToString();
			string productId = dr["ProductId"].ToString().Trim();
			decimal rate = Convert.ToDecimal( dr["Rate"] );
			int rateId = Convert.ToInt32( dr["RateId"] );

			account.Identity = Convert.ToInt32( dr["AccountId"] );
			account.AccountNumber = dr["AccountNumber"].ToString();
			account.AccountType = (CompanyAccountType) Enum.Parse( typeof( CompanyAccountType ), dr["AccountType"].ToString(), true );

			if( dr["AnnualUsage"] != DBNull.Value )
			{
				account.AnnualUsage = Convert.ToInt32( dr["AnnualUsage"] );
			}

			//TODO: Stored Procs are currently retrieving field_04_value instead of new field "Billing_Group" in account to populate ReadCycleId
			account.ReadCycleId = dr["BillCycleId"].ToString();
			account.ContractNumber = dr["ContractNumber"].ToString();
			account.ContractEndDate = Convert.ToDateTime( dr["ContractEndDate"] );
			account.ContractStartDate = Convert.ToDateTime( dr["ContractStartDate"] );
			account.ContractType = dr["ContractType"].ToString();
			account.DateDeal = Convert.ToDateTime( dr["DateDeal"] );
			account.DateSubmit = Convert.ToDateTime( dr["DateSubmit"] );
			account.DeenrollmentDate = Convert.ToDateTime( dr["DeenrollmentDate"] );
			account.FlowStartDate = Convert.ToDateTime( dr["FlowStartDate"] );
			account.Rate = rate;
			account.Term = Convert.ToInt32( dr["Term"] );
			account.UtilityCode = dr["UtilityCode"].ToString();
			account.ProductId = dr["ProductID"].ToString();
			account.RetailMarketCode = dr["RetailMarketCode"].ToString(); // retail_mkt_id
			account.SalesChannelId = dr["SalesChannelId"].ToString();
			account.SalesRep = dr["SalesRep"].ToString();
			account.ZoneCode = dr["ZoneCode"].ToString(); // zone 
			//account.LoadProfile = (dr["LoadProfile"] != null) ? dr["LoadProfile"].ToString() : string.Empty;
			account.RateClass = dr["RateClass"].ToString(); // service_rate_class
			account.CurrentEtfID = Helper.ConvertFromDB<int?>( dr["CurrentEtfID"] );

			account.EnrollmentStatus = dr["EnrollmentStatus"].ToString();
			account.EnrollmentSubStatus = dr["EnrollmentSubStatus"].ToString();

			account.WaiveEtf = Convert.ToBoolean( dr["WaiveEtf"] );
			account.WaivedEtfReasonCodeID = Helper.ConvertFromDB<int?>( dr["WaivedEtfReasonCodeID"] );
			//account.IsOutgoingDeenrollmentRequest = Convert.ToBoolean(dr["IsOutgoingDeenrollmentRequest"]);

			account.BusinessName = dr["BusinessName"].ToString();

			account.Product = ProductFactory.CreateProduct( productId.Trim(), false );

			ProductRate productRate = ProductRateFactory.CreateAccountProductRateReadOnly( productId, rateId, account.DateDeal );

			if( productRate == null || productRate.Product == null )
			{
				Int64 priceID = GetContractAccountPriceID( account.ContractNumber, account.AccountNumber );
				productRate = DailyPricingFactory.GetProductRate( productId, rateId, priceID, account.DateDeal );
				account.ProductRate = productRate;

				if( productRate == null || productRate.Product == null )
					account.Errors.Add( "ProductID [" + productId + "] not found while building CompanyAccount" );
			}
			else
			{
				account.ProductRate = productRate;
			}


			account.PricingZoneAndClass = Helper.ConvertFromDB<string>( dr["PricingZoneAndClass"] );

			if( account.AnnualUsage == 0 && UseProxyUsage )
			{
				// get proxy usage for new deal
				DataSet ds2 = GrossMarginSql.GetGrossMarginUsageProxy( account.AccountType.ToString() );

				if( ds2.Tables[0].Rows.Count == 0 )
					ds2 = GrossMarginSql.GetGrossMarginUsageProxy( CompanyAccountType.SMB.ToString() );

				account.AnnualUsage = Convert.ToInt32( ds2.Tables[0].Rows[0]["Usage"] );
			}

			account.CreditScore = null;
			if( dr["credit_score"] != DBNull.Value )
			{
				account.CreditScore = Convert.ToDecimal( dr["credit_score"] );
			}
			account.CreditAgency = Convert.ToString( dr["credit_agency"] );

			//INF82 Begin

			decimal capBuf;
			if( dr["Icap"] == System.DBNull.Value )
			{
				account.Icap = null;
			}
			else if( !Decimal.TryParse( dr["Icap"].ToString(), out capBuf ) )
				account.Icap = null;
			else
			{
				if( capBuf < 0 )
					account.Icap = null;
				else
					account.Icap = capBuf;
			}

			if( dr["Tcap"] == System.DBNull.Value )
			{
				account.Tcap = null;
			}
			else if( !Decimal.TryParse( dr["Tcap"].ToString(), out capBuf ) )
				account.Tcap = null;
			else
			{
				if( capBuf < 0 )
					account.Tcap = null;
				else
					account.Tcap = capBuf;
			}

			account.ContractType = dr["ContractType"].ToString();


			account.por_option = dr["por_option"].ToString();
			account.raw_tcap = dr["Tcap"].ToString();
			account.raw_icap = dr["Icap"].ToString();

			//INF82 END

			if( dr.Table.Columns.Contains( "DeliveryLocationRefID" ) )
				account.DeliveryLocationRefID = dr["DeliveryLocationRefID"] == System.DBNull.Value ? 0 : Convert.ToInt32( dr["DeliveryLocationRefID"] );

			if( dr.Table.Columns.Contains( "SettlementLocationRefID" ) )
				account.SettlementLocationRefID = dr["SettlementLocationRefID"] == System.DBNull.Value ? 0 : Convert.ToInt32( dr["SettlementLocationID"] );

			if( dr.Table.Columns.Contains( "LoadProfileRefID" ) )
				account.LoadProfileRefID = dr["LoadProfileRefID"] == System.DBNull.Value ? 0 : Convert.ToInt32( dr["LoadProfileRefID"] );

			//Added Enrollment Lead Days May 14 2014
				if( dr.Table.Columns.Contains( "EnrollmentLeadDays" ) )
					account.EnrollmentLeadDays = dr["EnrollmentLeadDays"] == System.DBNull.Value ? 0 : Convert.ToInt32( dr["EnrollmentLeadDays"] );

            if (dr.Table.Columns.Contains("IsCreditInsured"))
                account.CreditInsuranceFlag = dr["IsCreditInsured"] == System.DBNull.Value ? false : Convert.ToBoolean(dr["IsCreditInsured"]);

			return account;
		}

		private static CompanyAccount BuildCompanyAccountObject( DataRow dr )
		{
			return BuildCompanyAccountObject( dr, true );
		}

		// May 2010
		// GetCompanyAccountRenewal was returning more data than needed + had extra logic to retrieve proxy's /
		//	rate id's + was timing out..
		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Returns a renewal account's current annual usage
		/// </summary>
		/// <param name="accountNumber"></param>
		/// <param name="utilityCode"></param>
		/// <returns></returns>
		public static CompanyAccount GetCompanyAccountRenewalAnnualUsage( string accountNumber, string utilityCode )
		{
			DataSet ds = AccountSql.GetRenewalAccount( accountNumber, utilityCode );
			CompanyAccount account = null;

			if( ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0 )
			{
				string AccountID = ds.Tables[0].Rows[0]["LegacyAccountId"].ToString();
				account = new CompanyAccount( AccountID );
				account.AccountNumber = ds.Tables[0].Rows[0]["AccountNumber"].ToString();
				account.AnnualUsage = Convert.ToInt32( ds.Tables[0].Rows[0]["AnnualUsage"] );
			}

			return account;
		}

		// ------------------------------------------------------------------------------------
		public static CompanyAccount GetCompanyAccountRenewal( string accountNumber, string utilityCode, bool UseProxyUsage )
		{
			DataSet ds = AccountSql.GetRenewalAccount( accountNumber, utilityCode );
			string AccountID = ds.Tables[0].Rows[0]["LegacyAccountId"].ToString();
			CompanyAccount account = new CompanyAccount( AccountID );

			if( ds.Tables[0].Rows.Count > 0 )
			{
				string productId = ds.Tables[0].Rows[0]["ProductId"].ToString();
				decimal rate = Convert.ToDecimal( ds.Tables[0].Rows[0]["Rate"] );
				int rateId = Convert.ToInt32( ds.Tables[0].Rows[0]["RateId"] );
				if( ds.Tables[0].Columns.Contains( "billing_type" ) == true )
					account.BillingType = ds.Tables[0].Rows[0]["billing_type"].ToString();

				//account.AccountID = ds.Tables[0].Rows[0]["LegacyAccountId"].ToString();
				account.AccountNumber = ds.Tables[0].Rows[0]["AccountNumber"].ToString();
				account.AccountType = (CompanyAccountType) Enum.Parse( typeof( CompanyAccountType ), ds.Tables[0].Rows[0]["AccountType"].ToString(), true );
				account.AnnualUsage = Convert.ToInt32( ds.Tables[0].Rows[0]["AnnualUsage"] );
				account.ReadCycleId = ds.Tables[0].Rows[0]["BillCycleId"].ToString();
				account.ContractNumber = ds.Tables[0].Rows[0]["ContractNumber"].ToString();
				account.ContractEndDate = Convert.ToDateTime( ds.Tables[0].Rows[0]["ContractEndDate"] );
				account.ContractStartDate = Convert.ToDateTime( ds.Tables[0].Rows[0]["ContractStartDate"] );
				account.ContractType = ds.Tables[0].Rows[0]["ContractType"].ToString();
				account.DateDeal = Convert.ToDateTime( ds.Tables[0].Rows[0]["DateDeal"] );
				account.DateSubmit = Convert.ToDateTime( ds.Tables[0].Rows[0]["DateSubmit"] );
				account.DeenrollmentDate = Convert.ToDateTime( ds.Tables[0].Rows[0]["DeenrollmentDate"] );
				account.FlowStartDate = Convert.ToDateTime( ds.Tables[0].Rows[0]["FlowStartDate"] );
				account.Rate = rate;
				account.SalesChannelId = ds.Tables[0].Rows[0]["SalesChannelId"].ToString();
				account.SalesRep = ds.Tables[0].Rows[0]["SalesRep"].ToString();
				account.Term = Convert.ToInt32( ds.Tables[0].Rows[0]["Term"] );
				account.UtilityCode = ds.Tables[0].Rows[0]["UtilityCode"].ToString().Trim();

				account.Product = ProductFactory.CreateProduct( productId.Trim(), false );
				account.ProductRate = ProductRateFactory.CreateAccountProductRate( productId, rateId, account.DateDeal );

				if( ds.Tables[0].Rows[0]["ServiceClass"] != DBNull.Value )
					account.RateClass = ds.Tables[0].Rows[0]["ServiceClass"].ToString().Trim();
				if( ds.Tables[0].Rows[0]["Zone"] != DBNull.Value )
					account.ZoneCode = ds.Tables[0].Rows[0]["Zone"].ToString().Trim();
				if( account.AnnualUsage == 0 && UseProxyUsage )
				{
					// get proxy usage for new deal
					DataSet ds2 = GrossMarginSql.GetGrossMarginUsageProxy( account.AccountType.ToString() );

					if( ds2.Tables[0].Rows.Count == 0 )
						ds2 = GrossMarginSql.GetGrossMarginUsageProxy( CompanyAccountType.SMB.ToString() );

					account.AnnualUsage = Convert.ToInt32( ds2.Tables[0].Rows[0]["Usage"] );
				}
			}

			return account;
		}

		public static CompanyAccount GetCompanyAccountRenewalByContract( string accountNumber, string contractNumber, bool UseProxyUsage )
		{
			DataSet ds = AccountSql.GetRenewalAccountByContract( accountNumber, contractNumber );
			CompanyAccount account = null;

			if( DataSetHelper.HasRow( ds ) )
			{
				string AccountID = ds.Tables[0].Rows[0]["LegacyAccountId"].ToString();
				account = new CompanyAccount( AccountID );

				string productId = ds.Tables[0].Rows[0]["ProductId"].ToString();
				decimal rate = Convert.ToDecimal( ds.Tables[0].Rows[0]["Rate"] );
				int rateId = Convert.ToInt32( ds.Tables[0].Rows[0]["RateId"] );
				if( ds.Tables[0].Columns.Contains( "BillingType" ) == true )
					account.BillingType = ds.Tables[0].Rows[0]["BillingType"].ToString();


				account.AccountNumber = ds.Tables[0].Rows[0]["AccountNumber"].ToString();
				account.AccountType = (CompanyAccountType) Enum.Parse( typeof( CompanyAccountType ), ds.Tables[0].Rows[0]["AccountType"].ToString(), true );
				account.AnnualUsage = Convert.ToInt32( ds.Tables[0].Rows[0]["AnnualUsage"] );
				account.ReadCycleId = ds.Tables[0].Rows[0]["BillCycleId"].ToString();
				account.ContractNumber = ds.Tables[0].Rows[0]["ContractNumber"].ToString();
				account.ContractEndDate = Convert.ToDateTime( ds.Tables[0].Rows[0]["ContractEndDate"] );
				account.ContractStartDate = Convert.ToDateTime( ds.Tables[0].Rows[0]["ContractStartDate"] );
				account.ContractType = ds.Tables[0].Rows[0]["ContractType"].ToString();
				account.DateDeal = Convert.ToDateTime( ds.Tables[0].Rows[0]["DateDeal"] );
				account.DateSubmit = Convert.ToDateTime( ds.Tables[0].Rows[0]["DateSubmit"] );
				account.DeenrollmentDate = Convert.ToDateTime( ds.Tables[0].Rows[0]["DeenrollmentDate"] );
				account.FlowStartDate = Convert.ToDateTime( ds.Tables[0].Rows[0]["FlowStartDate"] );
				account.Rate = rate;
				account.SalesChannelId = ds.Tables[0].Rows[0]["SalesChannelId"].ToString();
				account.SalesRep = ds.Tables[0].Rows[0]["SalesRep"].ToString();
				account.Term = Convert.ToInt32( ds.Tables[0].Rows[0]["Term"] );
				account.UtilityCode = ds.Tables[0].Rows[0]["UtilityCode"].ToString();

				account.Product = ProductFactory.CreateProduct( productId.Trim(), false );
				account.ProductRate = ProductRateFactory.CreateAccountProductRate( productId, rateId, account.DateDeal );

				if( account.AnnualUsage == 0 && UseProxyUsage )
				{
					// get proxy usage for new deal
					DataSet ds2 = GrossMarginSql.GetGrossMarginUsageProxy( account.AccountType.ToString() );

					if( ds2.Tables[0].Rows.Count == 0 )
						ds2 = GrossMarginSql.GetGrossMarginUsageProxy( CompanyAccountType.SMB.ToString() );

					account.AnnualUsage = Convert.ToInt32( ds2.Tables[0].Rows[0]["Usage"] );
				}
			}
			return account;
		}

		/// <summary>
		/// Gets the account object by Id
		/// </summary>
		/// <param name="id">The Id of the account type</param>
		/// <returns>AccountType object</returns>
		public static AccountType GetAccountType( int id )
		{
			DataSet ds = new DataSet();
			AccountType accountType = null;
			ds = AccountSql.getAccountTypeById( id );
			if( ds != null )
			{
				accountType = new AccountType();
				accountType.Id = id;
				accountType.Description = ds.Tables[0].Rows[0]["account_type"].ToString();
			}
			return accountType;
		}

		/// <summary>
		/// Gets the account type enumerator and validates that the account type string is valid
		/// </summary>
		/// <param name="accountType">Account type</param>
		/// <returns>Returns CompanyAccountType enumerator</returns>
		public static CompanyAccountType GetCompanyAccountType( string accountType )
		{
			CompanyAccountType type;

			ValidAccountTypeRule rule = new ValidAccountTypeRule( accountType );

			if( rule.Validate() )
				type = (CompanyAccountType) Enum.Parse( typeof( CompanyAccountType ), accountType, true );
			else
				throw new InvalidAccountTypeException( rule.Exception.Message );

			return type;
		}

		public static AccountType GetAccountTypeByAccountNumber( string user, string accountNumber )
		{
			DataSet ds = new DataSet();

			ds = AccountSql.GetCompanyAccountByNumber( user, accountNumber );
			if( ds.Tables[0].Rows.Count > 0 )
			{
				List<AccountType> accountTypeList = GetAccountTypeList();
				foreach( AccountType accType in accountTypeList )
				{
					if( accType.Description.ToUpper() == ds.Tables[0].Rows[0]["account_type"].ToString() )
					{
						return accType;
					}
				}
			}
			return null;
		}

		public static List<AccountType> GetAccountTypeList()
		{
			DataSet ds = new DataSet();
			List<AccountType> accountTypeList = new List<AccountType>();

			ds = AccountSql.getAccountTypes();
			if( ds != null )
			{
				for( int i = 0; i <= ds.Tables[0].Rows.Count - 1; i++ )
				{
					DataRow row = ds.Tables[0].Rows[i];
					AccountType accountType = new AccountType();
					accountType.Id = Convert.ToInt32( row["account_type_id"] );
					accountType.Description = row["account_type"].ToString();
					accountTypeList.Add( accountType );
				}
			}
			return accountTypeList;
		}

		public static AccountTypeDictionary GetAccountTypes()
		{
			AccountTypeDictionary dict = new AccountTypeDictionary();

			DataSet ds = GeneralSql.GetAccountTypes();
			if( IsValidDataSet( ds ) )
			{
				foreach( DataRow dr in ds.Tables[0].Rows )
				{
					AccountType at = new AccountType();
					at.Id = Convert.ToInt32( dr["ID"] );
					at.Description = dr["AccountType"].ToString();
					at.DisplayDescription = dr["Description"].ToString();
					dict.Add( at.Id, at );
				}
			}

			return dict;
		}

		public static List<String> GetAccountTypeGroups()
		{
			DataSet ds = new DataSet();
			List<String> accountTypeGroupList = new List<String>();

			ds = AccountSql.GetAccountTypeGroups();
			if( ds != null )
			{
				for( int i = 0; i < ds.Tables[0].Rows.Count; i++ )
				{
					DataRow row = ds.Tables[0].Rows[i];
					accountTypeGroupList.Add( row["AccountGroup"].ToString() );
				}
			}
			return accountTypeGroupList;
		}

		public static void GetRenewalAccount()
		{
			throw new System.NotImplementedException();
		}

		public static void InsertComment( string accountID, string processID, string comment, string userName )
		{
			AccountSql.InsertComment( accountID, processID, comment, userName );
		}

		public static string GetAccountIDByNumberAndUtility( string accountNumber, string utilityID )
		{
			object obj = AccountSql.GetAccountIDByNumberAndUtility( accountNumber, utilityID );
			string accountID = Helper.ConvertFromDB<string>( obj );
			return accountID;
		}

		/// <summary>
		/// get the AccountID for the account number and utilitycode in question
		/// </summary>
		/// <param name="accountNumber">account number</param>
		/// <param name="utilityCode">utility code</param>
		/// <returns>INT: AccountID </returns>
		public static Int32 GetAccountIdentifier( string accountNumber, string utilityCode )
		{
			return AccountSqlLP.GetAccountIdentifier( accountNumber, utilityCode );
		}

		public static void UpdateEtfCorrespondence( CompanyAccount companyAccount )
		{
			AccountSqlLP.UpdateEtfCorrespondence( companyAccount.Identity, companyAccount.WaiveEtf, companyAccount.WaivedEtfReasonCodeID );
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Updates the annual usage depending on whether it is a renewal account or not
		/// </summary>
		/// <param name="accountId"></param>
		/// <param name="annualUsage"></param>
		/// <param name="isRenewal"></param>
		public static void UpdateAnnualUsage( string accountId, int annualUsage, bool isRenewal )
		{
			if( isRenewal )
				AccountSql.UpdateAnnualUsageRenewal( accountId, annualUsage );
			else
				AccountSql.UpdateAnnualUsage( accountId, annualUsage );
		}

		public static void UpdateServiceRateClass( string accountId, string serviceClass )
		{
			AccountSql.UpdateServiceRateClass( accountId, serviceClass );
		}

		// ------------------------------------------------------------------------------------
		public static void UpdateOutgoingDeenrollmentRequestFlag( CompanyAccount companyAccount )
		{
			AccountSql.UpdateOutgoingDeenrollmentRequestFlag( companyAccount.Identifier, companyAccount.IsOutgoingDeenrollmentRequest );
		}


		/// <summary>
		/// This function is run when Enrollment Specialist completes Deenrollment on
		/// Customer Account Detail Screen
		/// </summary>
		/// <param name="accountNumber"></param>
		/// <param name="userName"></param>
		public static DataSet FlagForDeenrollment( string userName, string accountId, string customerID,
			string contractNumber, string deenrollmentType, string retentionProcess, string reasonCode
			, string deenrollmentComments, string deenrollmentDays, string additionalReasonCodes,
			bool waiveEtf, int? waivedEtfReasonCodeID )
		{
			DataSet ds = null;
			using( TransactionScope scope = new TransactionScope( TransactionScopeOption.RequiresNew ) )
			{
				CompanyAccount companyAccount = CompanyAccountFactory.GetCompanyAccount( accountId );
				//Save ETF correspondence choice made by Enrollment specialist
				companyAccount.WaiveEtf = waiveEtf;
				companyAccount.WaivedEtfReasonCodeID = waivedEtfReasonCodeID;
				UpdateEtfCorrespondence( companyAccount );

				//if ETF was waived by Enrollment specialist, create comment
				if( waiveEtf )
				{
					InsertComment( companyAccount.Identifier, "ETF CORRESPONDENCE", "Customer de-enrollment requested without receipt of ETF correspondence.", userName );
				}

				// Call to legacy 
				ds = AccountSql.DeenrollAcount( userName, accountId, customerID,
				contractNumber, deenrollmentType, retentionProcess, reasonCode
				, deenrollmentComments, deenrollmentDays, additionalReasonCodes );

                // IT121 - Diogo Lima changes (PBI 20643) Commented it out, since DeenrollAccount function 
                //uses a proc which also updates the new status fields and this caused wrong updates.
                //CompanyAccountFactory.UpdateAccountContractStatus( accountId, 2, null, 2 );
                //CompanyAccountFactory.UpdateAccountSubmissionQueue( accountId, 2, 1 );

				// Only complete scope when legacy deenrollment call was successful
				if( DeenrollmentLegacyCallWasSuccessful( ds.Tables[0].Rows[0][0].ToString() ) )
				{
					scope.Complete();
				}

                
			}
			return ds;
		}

		private static bool DeenrollmentLegacyCallWasSuccessful( string s )
		{
			if( s == "E" )
			{
				return false;
			}
			else
			{
				return true;
			}
		}


		/// <summary>
		/// This function is run when the Deenrollment queue is processed,
		/// NOT when the deenrollment portion of the customer detail screen is filled out
		/// </summary>
		/// <param name="accountNumber"></param>
		/// <param name="userName"></param>
		public static void Deenroll( CompanyAccount companyAccount, string userName )
		{
			Deenroll( companyAccount, DateTime.Now, userName );
		}


		/// <summary>
		/// This function is run when the Deenrollment queue is processed,
		/// NOT when the deenrollment portion of the customer detail screen is filled out
		/// </summary>
		/// <param name="accountNumber"></param>
		/// <param name="userName"></param>
		public static void Deenroll( CompanyAccount companyAccount, DateTime requestDate, string userName )
		{
			AccountPendingDeenrollmentRequestRule accountPendingDeenrollmentRequestRule = new AccountPendingDeenrollmentRequestRule( companyAccount );
			if( accountPendingDeenrollmentRequestRule.Validate() )
			{
				EdiEnrollmentFactory.Deenroll( companyAccount.AccountNumber, requestDate, userName );

				// If Web Service Call was successfull, flip account status to 
				// Pending De-enrollment Confirmation 
				ChangeStatusToDeenrollmentConfirmation( companyAccount, userName );
			}
			else
			{
				throw accountPendingDeenrollmentRequestRule.Exception;
			}
		}

		public static void Reenroll( CompanyAccount companyAccount, string userName )
		{
			AccountPendingReenrollmentRequestRule accountPendingReenrollmentRequestRule = new AccountPendingReenrollmentRequestRule( companyAccount );
			if( accountPendingReenrollmentRequestRule.Validate() )
			{
				DateTime requestDate = DateTime.Now;
				EdiEnrollmentFactory.Reenroll( companyAccount.AccountNumber, requestDate, userName, companyAccount.ContractStartDate, companyAccount.ContractEndDate, companyAccount.CreditInsuranceFlag );

				//Status
				// If Web Service Call was successfull, flip account status to 
				// Pending Re-enrollment Confirmation 
				ChangeStatusToReenrollmentConfirmation( companyAccount, userName );
                
			}
			else
			{
				throw accountPendingReenrollmentRequestRule.Exception;
			}
		}

		public static void Enroll( CompanyAccount companyAccount, string userName, LpEnrollmentType enrollmentType, DateTime RequestedFlowDate )
		{

			AccountPendingEnrollmentRequestRule accountPendingEnrollmentRequestRule = new AccountPendingEnrollmentRequestRule( companyAccount );
			if( accountPendingEnrollmentRequestRule.Validate() )
			{
				DataSet ds = new DataSet();

				if( companyAccount.UtilityCode != "" && companyAccount.UtilityCode != null )
				{
					ds = AccountSql.GetISTAEnrollmentServiceDataByAccountNumberAndUtility( companyAccount.AccountNumber, companyAccount.UtilityCode.Trim() );
				}
				else
				{
					ds = AccountSql.GetISTAEnrollmentServiceDataByAccountNumber( companyAccount.AccountNumber );
				}

				DataRow accountData;

				if( ds.Tables[0].Rows.Count > 0 )
					accountData = ds.Tables[0].Rows[0];
				else
					throw new Exception( "There is no data for GetISTAEnrollmentServiceDataByAccountNumberAndUtility" );

				string rateCode = RateCodeValidation( companyAccount, accountData["ServiceClass"].ToString(), accountData["zone"].ToString().Trim(), Convert.ToDecimal( accountData["rate"] ), accountData["ProductCategory"].ToString().Trim() );
				string defaultRateCode = RateCodeValidation( companyAccount, accountData["ServiceClass"].ToString(), accountData["zone"].ToString().Trim(), Convert.ToDecimal( 0.1 ), accountData["ProductCategory"].ToString().Trim() );

				accountData["ratecode"] = rateCode;
				accountData["defaultratecode"] = defaultRateCode;

				EdiEnrollmentFactory.Enroll( accountData, RequestedFlowDate, enrollmentType.ToString() );

				//Status
				// If Web Service Call was successfull, flip account status to 
				// Pending Enrollment Confirmation 

                //Rafael Vasques IT 121
				//CompanyAccountFactory.UpdateAccountSubmissionQueue( companyAccount.Identifier, 1, 2 );
				ChangeStatusToEnrollmentConfirmation( companyAccount, userName );

			}
			else
			{
				throw accountPendingEnrollmentRequestRule.Exception;
			}


		}

		public static void RequestAccountUsage(string accountNumber, string domainUser, string appName, string utility)
		{
			string error;
			RequestAccountUsage(accountNumber, domainUser, appName, utility, out error);
		}

		public static void RequestAccountUsage( string accountNumber, string domainUser, string appName, string utility, out string errorMessage )
		{
			try
			{
				errorMessage = string.Empty;
				DataSet ds;

			CompanyAccount companyAccount = CompanyAccountFactory.GetCompanyAccount( accountNumber, utility );

				if( !string.IsNullOrEmpty( companyAccount.UtilityCode ) )
				ds = AccountSql.GetISTAEnrollmentServiceDataByAccountNumberAndUtility( companyAccount.AccountNumber, companyAccount.UtilityCode.Trim() );
			else
				ds = AccountSql.GetISTAEnrollmentServiceDataByAccountNumber( companyAccount.AccountNumber );

			DataRow accountData;

			if( ds.Tables[0].Rows.Count > 0 )
				accountData = ds.Tables[0].Rows[0];
			else
				throw new Exception( "There is no data for GetISTAEnrollmentServiceDataByAccountNumberAndUtility" );

				string rateCode;
				string defaultRateCode;

				var sc = accountData["ServiceClass"] == DBNull.Value ? string.Empty : accountData["ServiceClass"].ToString().Trim();
				var zn = accountData["zone"] == DBNull.Value ? string.Empty : accountData["zone"].ToString().Trim();
				var rt = accountData["rate"] == DBNull.Value ? Convert.ToDecimal("0.0") : Convert.ToDecimal( accountData["rate"] );
				var pc = accountData["ProductCategory"] == DBNull.Value ? string.Empty : accountData["ProductCategory"].ToString().Trim();
				if( UpdateRateCode( companyAccount, sc, zn, rt, pc, out rateCode, out defaultRateCode ) )
				{
				accountData["ratecode"] = rateCode;
				accountData["defaultratecode"] = defaultRateCode;
				}
				DataAccess.WebServiceAccess.IstaWebService.UsageService.SubmitHistoricalUsageRequest( accountData, domainUser, appName );
			}
			catch( Exception ex )
			{
				errorMessage = ex.Message;
			}
		}


		private static bool UpdateRateCode( CompanyAccount companyAccount, string serviceClass, string zone, decimal rate, string productCategory, out string rateCode, out string defaultRateCode )
		{
			try
			{
				rateCode = RateCodeValidation( companyAccount, serviceClass, zone, rate, productCategory );
				defaultRateCode = RateCodeValidation( companyAccount, serviceClass, zone, Convert.ToDecimal( 0.1 ), productCategory );

				companyAccount.RateCode = rateCode;
				bool isRenewalAccount = companyAccount.ContractType.Contains( "Renewal" );
				CompanyAccountFactory.UpdateRateCode( companyAccount, isRenewalAccount );
				return true;
			}
			catch( Exception )
			{
				rateCode = string.Empty;
				defaultRateCode = string.Empty;
				return false;
		}
		}

		public static DataSet ReturnsAccountsValues( CompanyAccount companyAccount, string userName, LpEnrollmentType enrollmentType, DateTime RequestedFlowDate )
		{
			DataSet ds = new DataSet();

			if( companyAccount.UtilityCode != "" && companyAccount.UtilityCode != null )
			{
				ds = AccountSql.GetISTAEnrollmentServiceDataByAccountNumberAndUtility( companyAccount.AccountNumber, companyAccount.UtilityCode.Trim() );
			}
			else
			{
				ds = AccountSql.GetISTAEnrollmentServiceDataByAccountNumber( companyAccount.AccountNumber );
			}
			return ds;
		}

		public static string RateCodeValidation( CompanyAccount companyAccount, string serviceClass, string zone, decimal rate, string productCategory )
		{
			AccountBillingType billingType = RateCodeFactory.GetAccountBillingType( companyAccount.UtilityCode, companyAccount.AccountNumber );
			RateCodePreference rateCodePreference = RateCodeFactory.GetUtilityRateCodePreference( companyAccount.UtilityCode, serviceClass, zone, "" );
			string fullServiceClass = serviceClass;
			string rateCode = "";


			if( billingType == AccountBillingType.RateReady && ((rateCodePreference == RateCodePreference.RateCodePreferred) || (rateCodePreference == RateCodePreference.RateCodeRequired)) )
			{
				if( RateCodeFactory.UtilityRateCodeFormatFields( companyAccount.UtilityCode.Trim() ) == RateCodeFormatFields.ServiceClassAndZone || RateCodeFactory.UtilityRateCodeFormatFields( companyAccount.UtilityCode.Trim() ) == RateCodeFormatFields.ServiceClass || RateCodeFactory.UtilityRateCodeFormatFields( companyAccount.UtilityCode ) == RateCodeFormatFields.Zone )
				{
                    RateCodeCollection rateCodes;
                    //bill type is rate ready so look for the utility
      

					if( companyAccount.UtilityCode.Trim() == "NIMO" )
					{
						fullServiceClass = RateCodeFactory.GetFullNimoServiceClass( companyAccount.AccountNumber );
						if( fullServiceClass.Length == 0 )
							fullServiceClass = serviceClass;

						RateCodeFactory.RateCodeAlertStatus( companyAccount.UtilityCode, DateTime.Now, fullServiceClass, zone, "", rate, true );

						rateCodes = new RateCodeCollection();

						if( productCategory.Trim() == "FIXED" )
						{
							try
							{
								rateCodes = RateCodeFactory.GetRateCodeRange( companyAccount.UtilityCode, rate, rate, true, DateTime.Now, fullServiceClass, zone, "" );
							}
							catch
							{
								throw new Exception( "Rate code does not exist" );
							}

							if( rateCodes.Count == 0 )
								throw new Exception( "Rate code does not exist" );
							else
								rateCode = rateCodes[0].Code;
						}
						else if( productCategory.Trim() == "VARIABLE" )
						{
							string varRateCode = RateCodeFactory.GetNimoVariableRateCode( "V1", fullServiceClass, zone );
							rateCode = varRateCode;
						}
					}
				}
				else if( RateCodeFactory.UtilityRateCodeFormatFields( companyAccount.UtilityCode ) == RateCodeFormatFields.None || RateCodeFactory.UtilityRateCodeFormatFields( companyAccount.UtilityCode ) == RateCodeFormatFields.Unknown )
				{
					RateCodeCollection rateCodes = new RateCodeCollection();
					RateCodeFactory.RateCodeAlertStatus( companyAccount.UtilityCode, DateTime.Now, serviceClass, zone, "", rate, true );
                    string loadProfile = AccountLoadProfile(companyAccount.AccountId ?? companyAccount.Identifier.ToString()); // previously companyAccount.AccountId was passed here, but this property is never filled when the control is passed from RequestAccountUsage method.

					try
					{
						rateCodes = RateCodeFactory.GetRateCodeRange( companyAccount.UtilityCode, rate, rate, true, DateTime.Now, "", "", "" );
					}
					catch
					{
						throw new Exception( "Rate code does not exist" );
					}

					if( rateCodes == null || rateCodes.Count == 0 )
						throw new Exception( "Rate code does not exist" );
					else
                        if (companyAccount.UtilityCode.Contains("NSTAR"))
                        {
                    //begin 1-17232491
						    //Updated 12/3/2013 by user to be utility specific with different rules for each utility
                            if (UseTOURateCode(companyAccount.UtilityCode, serviceClass, loadProfile))
                    {

                                //if (fullServiceClass.Substring(0, 1).ToLowerInvariant() == "t")
                                //{
                                foreach (RateCode rd in rateCodes)
                                {
                                    if (rd.Code.StartsWith("T"))
                                    {
                                        rateCode = rd.Code;
                                        return rateCode;
                                    }
                                }
                                //}
                            }
                            else
                        {
                            foreach (RateCode rd in rateCodes)
                            {
                                    if (rd.Code.StartsWith("L"))
                                {
                                    rateCode = rd.Code;
                                    return rateCode;
                                }
                            }
                        }
                    }
                    //end 1-17232491

						rateCode = rateCodes[0].Code;
				}
			}


			return rateCode;
		}

		/// <summary>
		/// Encompass rules defined for TOU meters as part of 1-17232491
		/// </summary>
		/// <param name="UtilityName"></param>
		/// <param name="FullServiceClass"></param>
		/// <returns>Bool indicating if TOU rate code should be used or not.</returns>
        private static bool UseTOURateCode(string UtilityName,string FullServiceClass,string loadprofile)
		{
			bool bUseTOURateCode = false;
            string sc = FullServiceClass.ToLower();
			string lp = loadprofile.ToLower();
            
			//some values may or may have have a dash or space according to Suzanne.
			lp = lp.Replace("-", "" );
			sc = sc.Replace("-", "" );
            lp = lp.Replace(" ", "");
            sc = sc.Replace(" ", "");

            if (FullServiceClass.Length < 2 && loadprofile.Length < 2)
			{
				return bUseTOURateCode;
				}

            switch (UtilityName)
			{
				case "NSTAR-BOS":
					{
                        if ((sc == "g3") && (lp == "g3"))
							bUseTOURateCode = true;

                        if((sc == "r4") && (lp == "r4"))
							bUseTOURateCode = true;

						if( (sc == "t1") && (lp == "t1") )
							bUseTOURateCode = true;

						if( (sc == "t2") && (lp == "t2") )
							bUseTOURateCode = true;

						break;
			}
				case "NSTAR-CAMB":
					{
                        if ((sc == "g2") && (lp == "g2"))
							bUseTOURateCode = true;

                        if ((sc == "g3") && (lp == "g3"))
							bUseTOURateCode = true;

                        if ((sc == "g4") && (lp == "g4"))
							bUseTOURateCode = true;

                        if ((sc == "g6") && (lp == "g1"))//confirmed this is g1/g6 w user.Not a typo
							bUseTOURateCode = true;

						if( (sc == "r5") && (lp == "r5") )
							bUseTOURateCode = true;

                        if ((sc == "r6") && (lp == "r6"))
							bUseTOURateCode = true;

						break;
		}
				case "NSTAR-COMM":
					{
                        if ((sc == "g2") && (lp == "g2"))
							bUseTOURateCode = true;

                        if ((sc == "g3") && (lp == "g3"))
							bUseTOURateCode = true;

                        if ((sc == "g7") && (lp == "g7"))
							bUseTOURateCode = true;

                        if ((sc == "r6") && (lp == "r6"))
							bUseTOURateCode = true;

						break;
					}
				default:
					break;
			}
			return bUseTOURateCode;
		}

		public static void ChangeStatusToDeenrollmentConfirmation( CompanyAccount account, string userName )
		{
			// Pending De-enrollment Confirmation (Status: 11000, Sub Status: 40)
			string processId = "DEENROLLMENT SUBMIT";
			string comment = "Account sent to EDI Provider for De-enrollment";

            if (account.EnrollmentStatus == EnrollmentStatus.GetValue(EnrollmentStatus.Status.EnrollmentCancellation))
            {

                CompanyAccount.UpdateStatus(account.Identifier, EnrollmentStatus.GetValue(EnrollmentStatus.Status.EnrollmentCancellation), "20", userName, processId, comment);
            }

            else if (account.EnrollmentStatus == EnrollmentStatus.GetValue(EnrollmentStatus.Status.PendingDeenrollment))
            {
                CompanyAccount.UpdateStatus(account.Identifier, EnrollmentStatus.GetValue(EnrollmentStatus.Status.PendingDeenrollment), "40", userName, processId, comment);
            }
            
            //IT 121 - Diogo Lima 
           // CompanyAccountFactory.UpdateAccountContractStatus(account.Identifier, 2, null, 1); 
           // CompanyAccountFactory.UpdateAccountSubmissionQueue(account.Identifier, 2, 2);
		}

		public static void ChangeStatusToReenrollmentConfirmation( CompanyAccount account, string userName )
		{
			// Pending Re-enrollment Confirmation (Status: 13000, Sub Status: 70)
			string processId = "REENROLLMENT SUBMIT";
			string comment = "Account sent to EDI Provider for Re-enrollment";

			CompanyAccount.UpdateStatus( account.Identifier, EnrollmentStatus.GetValue( EnrollmentStatus.Status.PendingReenrollment ), "70", userName, processId, comment );

            //IT 121 - Diogo Lima 
            //CompanyAccountFactory.UpdateAccountContractStatus(account.Identifier, 2, null, 1); Commented out - UpdateStatus uses a sp which updates the new status fields.
            //CompanyAccountFactory.UpdateAccountSubmissionQueue(account.Identifier, 1, 2);
		}

		public static void ChangeStatusToEnrollmentConfirmation( CompanyAccount account, string userName )
		{
			// Pending Enrollment Confirmation (Status: 05000, Sub Status: 20)
			string processId = "ENROLLMENT SUBMIT";
			string comment = "Account sent to EDI Provider for Enrollment";

			CompanyAccount.UpdateStatus( account.Identifier, EnrollmentStatus.GetValue( EnrollmentStatus.Status.PendingEnrollment ), "20", userName, processId, comment );
		}

		public static void InsertEtfEstimationComment( CompanyAccount companyAccount, string userName )
		{

			string comment;

			if( !companyAccount.Etf.HasError )
			{
				comment = "ETF estimation on " + companyAccount.Etf.EtfCalculator.DateCalculated + ": $" + companyAccount.Etf.EtfCalculator.CalculatedEtfAmount;
				InsertComment( companyAccount.Identifier, "ETF ESTIMATION", comment, userName );
			}
		}

		public static void InsertInvoiceCreationComment( CompanyAccount companyAccount )
		{
			string comment;

			if( companyAccount.Etf.EtfInvoice != null )
			{
				if( (companyAccount.Etf.EtfCalculator.CalculatedEtfAmount == null) && (companyAccount.Etf.EtfCalculator.EtfCalculatorType != EtfCalculatorType.Manual) )
				{
					comment = "ETF invoice created on " + companyAccount.Etf.EtfInvoice.DateInserted +
						": Manual calculation was required - Final ETF Amt: $" + companyAccount.Etf.EtfCalculator.EtfFinalAmount;
				}
				else if( companyAccount.Etf.EtfCalculator.EtfCalculatorType == EtfCalculatorType.Manual )
				{
					comment = "ETF manually calculated on " + companyAccount.Etf.EtfInvoice.DateInserted +
						": Final ETF Amt: $" + companyAccount.Etf.EtfCalculator.EtfFinalAmount;
				}
				else
				{
					comment = "ETF invoice created on " + companyAccount.Etf.EtfInvoice.DateInserted + ": Estimated ETF Amount $" + companyAccount.Etf.EtfCalculator.CalculatedEtfAmount +
								" - Final ETF Amt: $" + companyAccount.Etf.EtfCalculator.EtfFinalAmount;
				}
				InsertComment( companyAccount.Identifier, "ETF INVOICE CREATED", comment, companyAccount.Etf.LastUpdatedBy );
			}
		}

		public static void InsertInvoicePaidComment( CompanyAccount companyAccount )
		{
			string comment;

			if( companyAccount.Etf.EtfInvoice.IsPaid )
			{
				comment = "ETF of $" + companyAccount.Etf.EtfCalculator.EtfFinalAmount + " paid on " + DateTime.Now;
				InsertComment( companyAccount.Identifier, "ETF INVOICE PAID", comment, companyAccount.Etf.LastUpdatedBy );
			}
		}



		/// <summary>
		/// Verifies that the dataset contains at least one table and at least one record
		/// </summary>
		/// <param name="ds">DataSet object</param>
		/// <returns>Returns a true or false indicating whether the dataset contains at least one table and at least one record</returns>
		private static bool IsValidDataSet( DataSet ds )
		{
			return (ds != null && ds.Tables != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0);
		}

		public static string GetAccountTypeGroup( string accountType )
		{
			DataSet ds = AccountSql.GetAccountTypeGroup( accountType );
			if( ds != null )
			{
				if( ds.Tables[0].Rows.Count > 0 )
				{
					DataRow row = ds.Tables[0].Rows[0];
					return (row["AccountGroup"]).ToString();
				}
			}
			return null;
		}

		/// <summary>
		/// Updates the account status and substatus
		/// </summary>
		/// <param name="accountId"></param>
		/// <param name="comment"></param>
		/// <param name="processId"></param>
		/// <param name="username"></param>
		/// <param name="status"></param>
		/// <param name="substatus"></param>
		public static void UpdateAccountStatus( string accountId, string comment, string processId, string username, string status, string substatus, bool isRenewalAccount )
		{
			if( isRenewalAccount )
				AccountSql.UpdateRenewalStatus( accountId, comment, processId, username, status, substatus );
			else
				AccountSql.UpdateStatus( accountId, comment, processId, username, status, substatus );
		}


		internal static decimal GetMeterCharge( CompanyAccount account, string MarketCode )
		{
			double MeterCharge = 0;
			if( MarketCode.ToUpper().Trim() == "TX" && !account.Product.Description.Contains( "NOMC" ) )
				MeterCharge = 8.95;

			return Convert.ToDecimal( MeterCharge );
		}

		/// <summary>
		/// Cancels the renewal of one account
		/// </summary>
		/// <param name="accountId"></param>
		/// <param name="comment"></param>
		/// <param name="username"></param>
		public static void CancelRenewalAccount( string accountId, string comment, string username )
		{
			CompanyAccountFactory.UpdateAccountContractStatus( accountId, 3, 1, 3 );
			CompanyAccountFactory.UpdateAccountStatus( accountId, comment, "ENROLLMENT", username, "07000", "90", true );
            
		}

		/// <summary>
		/// Updates the rate code of an account
		/// </summary>
		/// <param name="account"></param>
		/// <param name="isRenewalAccount"></param>
		internal static void UpdateRateCode( CompanyAccount account, bool isRenewalAccount )
		{
			AccountSql.UpdateRateCode( account.Identifier, account.RateCode, isRenewalAccount );
		}

		//Ticket SR1-3343150
		/// <summary>
		/// Updates annual usages of 
		/// </summary>
		/// <param name="accountId"></param>
		/// <param name="isRenewal"></param>
		public static string UpdateContractAnnualUsage( string contractNumber, bool isRenewal )
		{
			string message = AccountSql.UpdateContractAnnualUsage( contractNumber, isRenewal );
			return message;

		}
		//--------

		private static Int64 GetContractAccountPriceID( string contractNumber, string accountNumber )
		{
			Int64 priceID = 0;
			DataSet ds = DealCaptureSql.GetContractAccount( contractNumber, accountNumber );
			if( DataSetHelper.HasRow( ds ) )
			{
				priceID = ds.Tables[0].Rows[0]["PriceID"] != DBNull.Value ? Convert.ToInt64( ds.Tables[0].Rows[0]["PriceID"] ) : 0;
			}
			else
			{
				//try to find price id in libertrypower
				ds = LibertyPower.DataAccess.SqlAccess.LibertyPowerSql.CRMLibertyPowerSql.GetAccountContractRatesByAccountContractNumber( accountNumber, contractNumber );
				if( DataSetHelper.HasRow( ds ) )
				{
					priceID = ds.Tables[0].Rows[0]["PriceID"] != DBNull.Value ? Convert.ToInt64( ds.Tables[0].Rows[0]["PriceID"] ) : 0;
				}
			}
			return priceID;
		}

		public static decimal GetMultiTermGrossMargin( string accountIdLegacy )
		{
			decimal weightedAvgGrossMargin = 0m;
			decimal numerator = 0m;
			decimal totalTerm = 0m;

			MultiTermList list = GetMultiTermsByAccountIdLegacy( accountIdLegacy );
			if( CollectionHelper.HasItem( list ) )
			{
				foreach( MultiTerm t in list )
				{
					totalTerm += t.Term;
					numerator += (t.Term * t.MarkupRate);
				}
				weightedAvgGrossMargin = (numerator / totalTerm);
			}
			return weightedAvgGrossMargin;
		}

		public static decimal GetMultiTermRateWeightedAverage( string accountIdLegacy )
		{
			decimal weightedAvgRate = 0m;
			decimal numerator = 0m;
			decimal totalTerm = 0m;

			MultiTermList list = GetMultiTermsByAccountIdLegacy( accountIdLegacy );
			if( CollectionHelper.HasItem( list ) )
			{
				foreach( MultiTerm t in list )
				{
					totalTerm += t.Term;
					numerator += (t.Term * t.Price);
				}
				weightedAvgRate = (numerator / totalTerm);
			}
			return weightedAvgRate;
		}

		public static MultiTermList GetMultiTermsByAccountIdLegacy( string accountIdLegacy )
		{
			MultiTermList list = new MultiTermList();

			DataSet ds = LibertyPowerSql.GetMultiTermByAccountIdLegacy( accountIdLegacy );
			if( DataSetHelper.HasRow( ds ) )
			{
				list.AddRange( from DataRow dr in ds.Tables[0].Rows select CrossProductPriceFactory.BuildMultiTerm( dr ) );
			}
			return list;
		}
        //IT 121 Rafael Changes.
		public static void UpdateAccountSubmissionQueue( string accountId, int EdiType, int EdiStatus )
        {
			AccountSql.UpdateAccountSubmissionStatus( accountId, EdiType, EdiStatus );
        }
		public static void UpdateAccountContractStatus( string accountId, int Status, int? ReasonRejected, int EdiType )
        {
			AccountSql.UpdateAccountContractStatus( accountId, Status, ReasonRejected, EdiType );
        }

        //IT 121 - Diogo Lima (PBI 25862)
        public static string ReenrollmentAccount(string userLogin, string accountId)
        {
            string returnMessage = "";
            using (TransactionScope scope = new TransactionScope(TransactionScopeOption.RequiresNew))
            {
                var account = GetCompanyAccountByLegacyId(accountId);

                DataSet dsVal = AccountSql.ReenrollmentAccount(userLogin, accountId);

                switch (Convert.ToString(dsVal.Tables[0].Rows[0][0]))
                {
                    case "E":
                        returnMessage = dsVal.Tables[0].Rows[0][2].ToString();
                        break;
                    default:
                        returnMessage = dsVal.Tables[0].Rows[0][2].ToString();
                        scope.Complete();
                        break;
                }

            }

            return returnMessage;
        }


    }
}

