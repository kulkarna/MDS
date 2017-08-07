using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using LibertyPower.DataAccess.SqlAccess.AccountSql;
using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;
using LibertyPower.Business.CustomerAcquisition.ProductManagement;
using LibertyPower.Business.CommonBusiness.CommonEntity;
using LibertyPower.Business.CustomerAcquisition.ProspectManagement;
using LibertyPower.Business.CustomerAcquisition.Prospects;
using LibertyPower.Business.CustomerAcquisition.SalesChannel;
using LibertyPower.Business.PartnerManagement.Commissions;
using LibertyPower.Business.CommonBusiness.SecurityManager;
using System.Transactions;
using LibertyPower.Business.CommonBusiness.CommonHelper;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	/// <summary>
	/// Factory for contract related methods
	/// </summary>
	/// 

	public static class ContractFactory
	{

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// GetRenewalAccount for retrieving a contract containing an account list
		/// </summary>
		/// <param name="contractNumber">Contract number</param>
		/// <returns>Contract object</returns>
		public static Contract GetContractWithAccounts( string contractNumber )
		{
			return GetContractWithAccounts( contractNumber, 'Y' );
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Get the contract info along with the all the accounts that belongs to the contract
		/// </summary>
		/// <param name="contractNumber">Contract number</param>
		/// <returns>Contract object</returns>
		public static Contract GetContractAccountInfo( string contractNumber )
		{
			var contract = new Contract( contractNumber );
			contract.Accounts = GetAccounts( contract );
			return contract;
		}


		// April 2010
		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Retrieves a contract containing an account list depending on whether it is a renewal contract or not..
		/// </summary>
		/// <param name="contractNumber">Contract number</param>
		/// <returns>Contract object</returns>
		public static Contract GetContractWithAccounts( string contractNumber, char isRenewal )
		{
			Contract contract = new Contract( contractNumber );

			contract.Accounts = GetAccountInfo( contract, isRenewal );


			return contract;
		}

		/// <summary>
		/// GetRenewalAccount for retrieving a contract.
		/// </summary>
		/// <param name="contractNumber">contract number</param>
		/// <returns>Contract object.</returns>
		public static Contract GetContract( string contractNumber )
		{
			DataSet ds = AccountSql.GetContractInfo( contractNumber );
			Contract con = new Contract( contractNumber );
			if( (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0) )
			{
				con.Market = ds.Tables[0].Rows[0]["Market"].ToString();
				con.ContractType = ds.Tables[0].Rows[0]["ContractType"].ToString();
				con.UserName = ds.Tables[0].Rows[0]["UserName"].ToString();
				if( ds.Tables[0].Rows[0]["VersionCode"] != DBNull.Value )
				{
					ContractTemplateVersion ctv = new ContractTemplateVersion();
					ctv.Code = ds.Tables[0].Rows[0]["VersionCode"].ToString();
					ctv.ETFFormulaId = Convert.ToInt32( ds.Tables[0].Rows[0]["EtfId"] );
					con.Version = ctv;
				}
			}
			return con;
		}

		/// <summary>
		/// get the list of accounts that belongs to the contract passed
		/// </summary>
		/// <param name="contract">contract object which the accounts will be attached to</param>
		/// <param name="isRenewal">indicates if we should the account info based on the fact if the account is a renewal or not</param>
		/// <returns>account list object</returns>
		private static List<CompanyAccount> GetAccountInfo( Contract contract, char isRenewal )
		{
			List<CompanyAccount> accountList = new List<CompanyAccount>();

			DataSet ds = AccountSql.GetAccountsByContractNumber( contract.ContractNumber, isRenewal );

			if( ds != null )
			{
				if( ds.Tables[0] != null )
				{
					if( ds.Tables[0].Rows.Count == 0 )
						throw CreateContractNotFoundException( contract.ContractNumber );

					foreach( DataRow dr in ds.Tables[0].Rows )
					{
						CompanyAccount account = new CompanyAccount( dr["account_id"].ToString(),
						dr["product_id"].ToString(), Convert.ToDateTime( dr["contract_eff_start_date"] ),
						Convert.ToDateTime( dr["date_end"] ), dr["billing_group"].ToString() );

						account.Identity = int.Parse( dr["AccountID"].ToString() );

						//get the ID of the contract: To Be removed once Contract+Account have been refactored
						if( contract.ContractID.Equals( 0 ) )
							contract.ContractID = int.Parse( dr["ContractID"].ToString() );

						account.ContractNumber = contract.ContractNumber;
						account.AccountNumber = dr["account_number"].ToString();
						account.AnnualUsage = Convert.ToInt32( dr["annual_usage"] );
						account.UtilityCode = dr["utility_id"].ToString().Trim();
						account.FlowStartDate = Convert.ToDateTime( dr["date_flow_start"] );
						account.EnrollmentStatus = dr["status"].ToString();
						account.EnrollmentSubStatus = dr["sub_status"].ToString();
						account.DateDeal = DateTime.Parse( dr["date_deal"].ToString() );
						account.Term = int.Parse( dr["term_months"].ToString() );
						account.CreditScore = null;
						if( dr["credit_score"] != DBNull.Value )
						{
							account.CreditScore = Convert.ToDecimal( dr["credit_score"] );
						}
						account.CreditAgency = Convert.ToString( dr["credit_agency"] );
						account.AccountType = (CompanyAccountType) Enum.Parse( typeof( CompanyAccountType ), dr["account_type"].ToString(), true );

						if( dr.Table.Columns.Contains( "zone" ) && dr["zone"] != null )
							account.ZoneCode = dr["zone"].ToString();
						if( dr.Table.Columns.Contains( "LoadProfile" ) && dr["LoadProfile"] != null )
							account.LoadProfile = dr["LoadProfile"].ToString();
						if( dr.Table.Columns.Contains( "BusinessName" ) && dr["BusinessName"] != null )
							account.BusinessName = dr["BusinessName"].ToString();
						if( dr.Table.Columns.Contains( "RateClass" ) && dr["RateClass"] != null )
							account.RateClass = dr["RateClass"].ToString();
						if( dr.Table.Columns.Contains( "RateCode" ) && dr["RateCode"] != null )
							account.RateCode = dr["RateCode"].ToString();
						if( dr.Table.Columns.Contains( "StratumVariable" ) && dr["StratumVariable"] != null )
							account.StratumVariable = dr["StratumVariable"].ToString();
						accountList.Add( account );
					}
				}
				else
					throw CreateContractNotFoundException( contract.ContractNumber );
			}
			else
				throw CreateContractNotFoundException( contract.ContractNumber );

			return accountList;

		}

		private static List<CompanyAccount> GetAccounts( Contract contract )
		{
			var accountList = new List<CompanyAccount>();
			DataSet ds = LibertyPowerSql.GetAccountsByContractNumber( contract.ContractNumber );
			if( DataSetHelper.HasRow( ds ) )
			{
				foreach( DataRow dr in ds.Tables[0].Rows )
				{
					var account = new CompanyAccount( dr["AccountID"].ToString(), dr["ProductId"].ToString(), Convert.ToDateTime( dr["ContractStartDate"] ), Convert.ToDateTime( dr["ContractEndDate"] ), dr["BillingGroup"].ToString() )
						{
							Identity = int.Parse( dr["AccountID"].ToString() )
						};

					contract.ContractID = int.Parse( dr["ContractID"].ToString() );
					account.ContractNumber = contract.ContractNumber;
					account.AccountNumber = dr["AccountNumber"].ToString();
					account.UtilityCode = dr["UtilityCode"].ToString().Trim();
					account.FlowStartDate = Convert.ToDateTime( dr["FlowStartDate"] );
					account.DateDeal = DateTime.Parse( dr["SignedDate"].ToString() );
					account.Term = int.Parse( dr["Term"].ToString() );
					account.ZoneCode = dr["zone"].ToString().Trim();
					account.LoadProfile = dr["LoadProfile"].ToString().Trim();
					account.BusinessName = dr["BusinessName"].ToString();
					account.RateClass = dr["RateClass"].ToString().Trim();
					account.RateCode = dr["RateCode"].ToString().Trim();
					account.StratumVariable = dr["StratumVariable"].ToString();
					account.RateId = int.Parse( dr["RateId"].ToString() );
					account.DeliveryLocationRefID = int.Parse( dr["DeliveryLocationRefID"].ToString() );
					account.LoadProfileRefID = int.Parse( dr["LoadProfileRefID"].ToString() );
					account.ServiceClassRefID = int.Parse( dr["ServiceClassRefID"].ToString() );
					account.AccountTypeId = int.Parse( dr["AccountTypeID"].ToString() );
					accountList.Add( account );
				}
			}
			//else
			//    throw CreateContractNotFoundException( contract.ContractNumber );

			return accountList;

		}

		/// <summary>
		/// Get the contract/account information that relates to the contract/account in question
		/// </summary>
		/// <param name="contractId">contract id</param>
		/// <param name="accountId">account id</param>
		/// <returns>CompanyAccount object</returns>
		public static CompanyAccount GetAccountInfoByContractId( int contractId, int accountId )
		{
			try
			{
				DataSet ds = LibertyPowerSql.GetAccountInfoByContractId( contractId, accountId );
				if( DataSetHelper.HasRow( ds ) )
				{
					DataRow dr = ds.Tables[0].Rows[0];

					var account = new CompanyAccount( dr["AccountID"].ToString(), dr["ProductId"].ToString(), Convert.ToDateTime( dr["ContractStartDate"] ), Convert.ToDateTime( dr["ContractEndDate"] ), dr["BillingGroup"].ToString() )
						{
							Identity = int.Parse( dr["AccountID"].ToString() )
						};
					account.ContractID = int.Parse( dr["ContractID"].ToString() );
					account.ContractNumber = dr["ContractNumber"].ToString().Trim();
					account.AccountNumber = dr["AccountNumber"].ToString();
					account.UtilityCode = dr["UtilityCode"].ToString().Trim();
					account.FlowStartDate = Convert.ToDateTime( dr["FlowStartDate"] );
					account.DateDeal = DateTime.Parse( dr["SignedDate"].ToString() );
					account.Term = int.Parse( dr["Term"].ToString() );
					account.ZoneCode = dr["zone"].ToString().Trim();
					account.LoadProfile = dr["LoadProfile"].ToString().Trim();
					account.BusinessName = dr["BusinessName"].ToString();
					account.RateClass = dr["RateClass"].ToString().Trim();
					account.RateCode = dr["RateCode"].ToString().Trim();
					account.StratumVariable = dr["StratumVariable"].ToString();
					account.RateId = int.Parse( dr["RateId"].ToString() );
					account.DeliveryLocationRefID = int.Parse( dr["DeliveryLocationRefID"].ToString() );
					account.LoadProfileRefID = int.Parse( dr["LoadProfileRefID"].ToString() );
					account.ServiceClassRefID = int.Parse( dr["ServiceClassRefID"].ToString() );
                    // 02/10/2015-Abhi Kulkarni: Bringing in the AccountTypeId needed for reforecasting
                    account.AccountTypeId = int.Parse(dr["AccountTypeID"].ToString());

					return account;
				}
				return null;
			}
			catch( Exception ex)
			{
				return null;
			}

		}

		internal static ContractNotFoundException CreateContractNotFoundException( string contractNumber )
		{
			string format = "Contract {0} not found.";
			return new ContractNotFoundException( string.Format( format, contractNumber ) );
		}

		public static Contract GetContractWithAccountsAndAddresses( string user, string contractNumber )
		{
			Contract contract = new Contract( contractNumber );
			DataSet dsAccounts = AccountSql.GetAccountNumbersByContractNumber( contractNumber );

			if( dsAccounts.Tables[0].Rows.Count == 0 )
				throw CreateContractNotFoundException( contractNumber );

			List<CompanyAccount> listOfAccounts = new List<CompanyAccount>();
			BuildListOfAccounts( dsAccounts.Tables[0], listOfAccounts );


			foreach( CompanyAccount account in listOfAccounts )
			{
				DataSet ds = AccountSql.GetCompanyAccountByNumber( user, account.AccountNumber );
				CompleteAccountFields( account, ds.Tables[0].Rows[0] );
				contract.AddAccount( account );
			}
			return contract;
		}


		private static void CompleteAccountFields( CompanyAccount account, DataRow row )
		{
			//account.AccountID = row["Account_id"].ToString();
			account.Identifier = row["Account_id"].ToString();
			account.ContractNumber = row["contract_nbr"].ToString();
			account.AnnualUsage = Convert.ToInt32( row["annual_usage"] );
			account.AccountType = (CompanyAccountType) Enum.Parse( typeof( CompanyAccountType ), row["account_type"].ToString().ToUpper() );
			account.CreditAgency = row["credit_agency"].ToString();
			account.BusinessName = row["account_name"].ToString();
			account.CreditAgency = row["credit_agency"].ToString();
			account.ProductId = row["Product_id"].ToString();
			account.RetailMarketCode = row["retail_mkt_id"].ToString();
			account.UtilityCode = row["utility_id"].ToString();
			account.Rate = Convert.ToDecimal( row["rate"] );

			account.CreditScore = null;
			if( row["credit_score"] != DBNull.Value )
				account.CreditScore = Convert.ToDecimal( row["credit_score"] );

			account.ServiceAddress = new UsGeographicalAddress()
			{
				Street = row["service_address"].ToString(),
				CityName = row["service_city"].ToString(),
				State = row["service_state"].ToString(),
				ZipCode = row["service_zip"].ToString()
			};

		}

		private static void BuildListOfAccounts( DataTable tableReturned, List<CompanyAccount> listOfAccounts )
		{
			foreach( DataRow row in tableReturned.Rows )
			{
				CompanyAccount account = new CompanyAccount();
				account.AccountNumber = row["account_number"].ToString().Trim();

				if( !listOfAccounts.Contains( account ) )
				{
					listOfAccounts.Add( account );
				}

			}
		}


		//TODO: Implement the business rule to ckeck if the contract is custom pricing
		public static bool IsCustomPricing( Contract contract )
		{
			return false;
		}

		public static void Create( string username, ProspectContract contract )
		{
			if( ApplicationFeatureHelper.IsFeatureInUse( "IT043", "EnrollmentApp" ) )
			{
				CreateCotractForWorkflow( username, contract );
			}
			else
			{
				CreateContractForCheckAccount( username, contract );
			}
		}

		public static void CreateContractForCheckAccount( string username, ProspectContract contract )
		{
			System.Transactions.TransactionOptions txOptions = new System.Transactions.TransactionOptions();
			txOptions.IsolationLevel = System.Transactions.IsolationLevel.ReadCommitted;
			txOptions.Timeout = new TimeSpan( 0, 40, 0 ); // transactionMinutes minute(s) to do the transaction

			using( TransactionScope scope = new TransactionScope( System.Transactions.TransactionScopeOption.Required, txOptions ) )
			{
				//[usp_contract_submit_val]

				//usp_contract_submit_ins

				AccountSql.DeleteCheckAccount( contract.ContractNumber );

				string checkType = "";
				string checkTypeNewContract = "";
				string accountNumber = "";
				string EntityId;
				string PorOption;
				string BillingType;
				int EnrollmentLeadDays;
				DataSet dsutility = AccountSql.SelectUtilityInfo( contract.Utility.Code );
				EntityId = dsutility.Tables[0].Rows[0]["entity_id"].ToString().Trim();
				PorOption = dsutility.Tables[0].Rows[0]["por_option"].ToString().Trim();
				BillingType = dsutility.Tables[0].Rows[0]["billing_type"].ToString().Trim();
				EnrollmentLeadDays = Convert.ToInt32( dsutility.Tables[0].Rows[0]["enrollment_lead_days"].ToString().Trim() );

				contract.SalesManager = LoadSalesManager( contract.SalesChannelRole );

				foreach( ProspectAccount account in contract.Accounts )
				{
					if( CheckIfAccountExists( username, account.AccountNumber, account.Utility.Code ) )
					{
						string accountID = GetOldAccountID( account.AccountNumber, account.Utility.Code );
						if( accountID != null )
							account.AccountId = accountID;
					}

					accountNumber = account.AccountNumber;

					string contractTypeAmend = "";
					string status = "";
					string subStatus = "";
					string processId;
					string contractNumber;

					checkType = GetFirstCheckType( account.Utility.Code, account.ContractType );
					account.TaxFloat = 0;
					account.CreditScore = 0;
					account.CreditAgency = "NONE";
					account.SalesManager = contract.SalesManager;

					account.DatePorEnrollment = account.RequestedFlowStartDate.AddDays( -EnrollmentLeadDays );
					account.EntityId = EntityId;
					account.PorOption = PorOption;
					account.BillingType = BillingType;
					account.DateDeEnrollment = new DateTime( 1900, 01, 01 );
					account.DateReEnrollment = new DateTime( 1900, 01, 01 );
					account.EvergreenCommisionRate = contract.EvergreenCommisionRate;
					account.EvergreenCommissionEnd = contract.EvergreenCommissionEnd;
					account.EvergreenOptionId = contract.EvergreenOptionId;
					account.ResidualCommisionEnd = contract.ResidualCommisionEnd;
					account.ResidualOptionId = contract.ResidualOptionId;
					account.InitialPymtOptionId = contract.InitialPymtOptionId;
					if( account.ContractType == "POWER MOVE" )
						account.DateFlowStart = account.DateEnd;
					else
						account.DateFlowStart = new DateTime( 1900, 01, 01 );
					if( account.ContractType == "AMENDMENT" )
					{
						string contractAmendNumber = account.ContractAmendNumber;
						if( string.IsNullOrEmpty( contractAmendNumber ) )
						{
							throw new Exception( AccountSql.SelectMessage( "DEAL", "00000049" ) );
						}

						DataSet ds = GetContractAmendInfo( contractAmendNumber );
						if( ds.Tables[0].Rows.Count == 0 )
						{
							throw new Exception( AccountSql.SelectMessage( "DEAL", "00000049" ) );
						}
						contractTypeAmend = ds.Tables[0].Rows[0]["contract_type"].ToString().Trim();
						status = ds.Tables[0].Rows[0]["status"].ToString().Trim();
						subStatus = ds.Tables[0].Rows[0]["sub_status"].ToString().Trim();
						string porOption = ds.Tables[0].Rows[0]["por_option"].ToString().Trim();
						if( status == "05000" || status == "06000" || status == "07000" || status == "08000"
							|| status == "09000" || status == "905000" || status == "906000" )
						{
							if( porOption == "NO" )
								status = "05000";
							else
								status = "06000";
							subStatus = "10";
						}
						processId = "CONTRACT AMENDMENT";
						contractNumber = contractAmendNumber;
					}
					else
					{
						processId = "DEAL CAPTURE";
						contractNumber = account.ContractNumber;
						DataSet ds = GetUtilityCheckType( account.Utility.Code, account.ContractType, checkType );
						if( ds.Tables[0].Rows.Count > 0 )
						{
							if( ds.Tables[0].Rows[0]["wait_status"] != DBNull.Value )
								status = ds.Tables[0].Rows[0]["wait_status"].ToString().Trim();
							else
								status = "01000";
							if( checkType == "SCRAPER RESPONSE" )
								subStatus = "20";
							else if( ds.Tables[0].Rows[0]["wait_sub_status"] != DBNull.Value )
								subStatus = ds.Tables[0].Rows[0]["wait_sub_status"].ToString().Trim();
							else
								subStatus = "10";
						}
					}
					contract.ContractNumber = contractNumber;
					account.ContractNumber = contractNumber;

					if( !CheckIfAccountCommentExists( account.AccountId, processId ) )
					{
						if( !String.IsNullOrEmpty( account.Comment ) )
						{
							InsertAccountComment( account.AccountId, account.DateComment, processId, account.Comment, username );
						}
					}
					InsertAccountStatusHistory( username, account.AccountId, status, subStatus, account.DateSubmit, processId, account.Utility.Code );

					//--------------------------------------

					DateTime dateFlowStart;
					DateTime dateEnd;
					string entityId = "";
					string contractType = "";
					string accountType = "";

					CompanyAccount acc = null;

					if( account.ContractType == "POWER MOVE" )
					{
						dateFlowStart = account.DateEnd;
						dateEnd = dateFlowStart.AddMonths( account.TermMonths );
						entityId = GetEntityId( account.AccountNumber );
						account.EntityId = entityId;
					}

					if( account.ContractType == "AMENDMENT" )
					{
						contractType = contractTypeAmend;
					}
					else
					{
						contractType = account.ContractType;
					}
					accountType = AccountSql.GetAccountTypeByProduct( account.Product.ProductId ); //GetAccountTypeByProduct( account.Product.ProductId );
					account.AccountType = accountType;
					account.ContractType = contractType;
					if( account.Status == "911000" && account.SubStatus == "10" )
					{
						status = "01000";
					}

					if( !CheckIfExistsAccountIdInAccountTable( username, account.AccountId ) )
					{
						DataSet ds = GetCheckTypeNewContract( account.Utility.Code, contractType );
						status = ds.Tables[0].Rows[0]["wait_status"].ToString().Trim();
						subStatus = ds.Tables[0].Rows[0]["wait_sub_status"].ToString().Trim();
						checkTypeNewContract = ds.Tables[0].Rows[0]["Check_Type"].ToString().Trim();
					}
					else
					{
						acc = CompanyAccountFactory.GetCompanyAccount( account.AccountId );
						if( acc.EnrollmentStatus == "911000" || acc.EnrollmentStatus == "999998" || acc.EnrollmentStatus == "999999" )
						{
							status = acc.EnrollmentStatus;
							subStatus = acc.EnrollmentSubStatus;
						}
					}

					account.Status = status;
					account.SubStatus = subStatus;


					string statusOld = status;
					string subStatusOld = subStatus;
					if( acc != null )
					{
						statusOld = acc.EnrollmentStatus;
						subStatusOld = acc.EnrollmentSubStatus;
					}

					if( CheckIfExistsAccountByUsername( username, statusOld, subStatusOld ) && account.ContractType != "AMENDMENT" )
					{
						if( !CheckIfExistsAccountIdInAccountTable( username, account.AccountId ) )
						{
							DataSet ds = GetCheckTypeNewContract( account.Utility.Code, account.ContractType );
							checkTypeNewContract = ds.Tables[0].Rows[0]["Check_Type"].ToString().Trim();
						}
						else
						{
							checkTypeNewContract = "CHECK ACCOUNT";
						}
						if( !CheckIfExistsStepsOnCheckAccountTable( account.ContractNumber, checkTypeNewContract ) )
						{
							InsertSalesChannelHist( username, account.AccountId, account.DateSubmit, account.SalesChannelRole, checkTypeNewContract );
							InsertCheckAccount( username, account.ContractNumber, checkTypeNewContract, account.DateSubmit );
						}

					}

					if( CheckIfAccountExists( username, account.AccountNumber, account.Utility.Code ) )
					{
						//never delete account info, do a update when  necessary
						AccountSql.DeleteAccountInfo( account.AccountNumber, account.Utility.Code );
					}
					else
					{
						InsertAccountAdditionalInfo( username, account.AccountId );
					}

					account.AccountNameLink = InsertAccountName( account.AccountId, account.AccountName );
					account.CustomerNameLink = InsertAccountName( account.AccountId, account.CustomerName );
					account.OwnerNameLink = InsertAccountName( account.AccountId, account.OwnerName );
					account.CustomerAddressLink = InsertAccountAddress( account.AccountId, account.CustomerAddress, account.CustomerSuite, account.CustomerCity, account.CustomerState, account.CustomerZip );
					account.BillingAddressLink = InsertAccountAddress( account.AccountId, account.BillingAddressStreet, account.BillingSuite, account.BillingCity, account.BillingState, account.BillingZip );
					account.ServiceAddressLink = InsertAccountAddress( account.AccountId, account.ServiceAddressStreet, account.ServiceSuite, account.ServiceCity, account.ServiceState, account.ServiceZip );
					account.CustomerContactLink = InsertAccountContact( account.AccountId, account.CustomerFirstName, account.CustomerLastName, account.CustomerTitle, account.CustomerPhone, account.CustomerFax, account.CustomerEmail, "01/01" );
					account.BillingContactLink = InsertAccountContact( account.AccountId, account.BillingFirstName, account.BillingLastName, account.BillingTitle, account.BillingPhone, account.BillingFax, account.BillingEmail, "01/01" );


					if( CheckIfAccountExists( username, account.AccountNumber, account.Utility.Code ) )
					{
						UpdateAccount( username, account );
					}
					else
					{
						InsertAccount( username, account );
					}

					if( (!String.IsNullOrEmpty( account.CustomerCode )) || (!String.IsNullOrEmpty( account.BillingAccount )) )
					{
						if( CheckIfAccountExistsInInfoTable( account.AccountId ) )
						{
							AccountSql.UpdateAccountinfo( account.AccountId, account.Utility.Code, account.CustomerCode, account.BillingAccount );
						}
						else
						{
							InsertAccountInfo( account.AccountId, account.Utility.Code, account.CustomerCode, account.BillingAccount, account.DateCreated );
						}
					}
					//InsertContractTrackingDetails( account );
					InsertAccountMeters( account.AccountId, account.MeterNumber );

					AccountEventProcessor.ProcessEvent( AccountEventType.DealSubmission, account.AccountNumber, account.Utility.Code );
				}// END FOR EACH ACCOUNT

				if( !CheckIfExistsStepsOnCheckAccountTable( contract.ContractNumber, checkType ) )
				{
					checkType = GetFirstCheckType( contract.Utility.Code, contract.ContractType );

					if( string.IsNullOrEmpty( checkType ) || !CheckIfExistsStepsOnCheckAccountTable( contract.ContractNumber, checkType ) )
					{
						if( checkType == "PROFITABILITY" && contract.ContractType != "AMENDMENT" )
						{
							DateTime day = DateTime.Today;
							string riskRequestId = "";
							string hour;
							string requestDateTime;
							DateTime headerEnrollment1 = Convert.ToDateTime( DateTime.Today.ToShortDateString() + " " + contract.HeaderEnrollment1 );
							DateTime headerEnrollment2 = Convert.ToDateTime( DateTime.Today.ToShortDateString() + " " + contract.HeaderEnrollment2 );

							if( DateTime.Now > headerEnrollment2 )
							{
								hour = contract.HeaderEnrollment1;
								day = DateTime.Today.AddDays( 1 );
							}
							if( DateTime.Now <= headerEnrollment1 )
							{
								requestDateTime = day.ToString( "yyyyMMdd" ) + " " + contract.HeaderEnrollment1;
								riskRequestId = "DEAL-CAPTURE-" + requestDateTime.ToString();
							}
							else
							{
								requestDateTime = day.ToString( "yyyyMMdd" ) + " " + contract.HeaderEnrollment2;
								riskRequestId = "DEAL-CAPTURE-" + requestDateTime.ToString();
							}
							if( !CheckIfRiskExists( riskRequestId ) )
							{
								AccountSql.InsertWebHeaderEnrollment( username, riskRequestId, requestDateTime );
								AccountSql.InsertWebDetail( riskRequestId, accountNumber );
								AccountSql.InsertCheckAccount( username, contract.ContractNumber, " ", "PROFITABILITY", "ENROLLMENT", "AWSCR", contract.DateSubmit, " ", new DateTime( 1900, 01, 01 ),
									"ONLINE", " ", riskRequestId, new DateTime( 1900, 01, 01 ), " ", new DateTime( 1900, 01, 01 ), new DateTime( 1900, 01, 01 ), 0 );

							}
						}
						else
						{
							if( contract.ContractType != "AMENDMENT" )
							{
								if( String.IsNullOrEmpty( checkTypeNewContract ) )
									checkTypeNewContract = checkType;
								AccountSql.InsertCheckAccount( username, contract.ContractNumber, " ", checkTypeNewContract, "ENROLLMENT", "PENDING", contract.DateSubmit, " ", new DateTime( 1900, 01, 01 ),
									"ONLINE", " ", " ", new DateTime( 1900, 01, 01 ), " ", new DateTime( 1900, 01, 01 ), new DateTime( 1900, 01, 01 ), 0 );
							}
						}
					}
				}
				ExecuteFinalUpdates( contract );

				//end of usp_contract_submit_ins
				//delete errors from deal_contract_error
				scope.Complete();
			}
		}

		public static void CreateCotractForWorkflow( string username, ProspectContract contract )
		{
			System.Transactions.TransactionOptions txOptions = new System.Transactions.TransactionOptions();
			txOptions.IsolationLevel = System.Transactions.IsolationLevel.ReadCommitted;
			txOptions.Timeout = new TimeSpan( 0, 40, 0 ); // transactionMinutes minute(s) to do the transaction
			bool accountExists;

			using( TransactionScope scope = new TransactionScope( System.Transactions.TransactionScopeOption.Required, txOptions ) )
			{
				//[usp_contract_submit_val]

				//usp_contract_submit_ins

				string accountNumber = "";
				string EntityId;
				string PorOption;
				string BillingType;
				int EnrollmentLeadDays;
				DataSet dsutility = AccountSql.SelectUtilityInfo( contract.Utility.Code );
				EntityId = dsutility.Tables[0].Rows[0]["entity_id"].ToString().Trim();
				PorOption = dsutility.Tables[0].Rows[0]["por_option"].ToString().Trim();
				BillingType = dsutility.Tables[0].Rows[0]["billing_type"].ToString().Trim();
				EnrollmentLeadDays = Convert.ToInt32( dsutility.Tables[0].Rows[0]["enrollment_lead_days"].ToString().Trim() );

				contract.SalesManager = LoadSalesManager( contract.SalesChannelRole );

				foreach( ProspectAccount account in contract.Accounts )
				{
					accountExists = CheckIfAccountExists( username, account.AccountNumber, account.Utility.Code );
					if( accountExists )
					{
						string accountID = GetOldAccountID( account.AccountNumber, account.Utility.Code );
						if( accountID != null )
							account.AccountId = accountID;
					}

					accountNumber = account.AccountNumber;

					string contractTypeAmend = "";

					//New contracts should start as 01000/10
					//Tasks will be inserted by WorkflowStartItem
					//IT043
					string status = "01000";
					string subStatus = "10";

					string processId;
					string contractNumber;

					account.TaxFloat = 0;
					account.CreditScore = 0;
					account.CreditAgency = "NONE";
					account.SalesManager = contract.SalesManager;

					account.DatePorEnrollment = account.RequestedFlowStartDate.AddDays( -EnrollmentLeadDays );
					account.EntityId = EntityId;
					account.PorOption = PorOption;
					account.BillingType = BillingType;
					account.DateDeEnrollment = new DateTime( 1900, 01, 01 );
					account.DateReEnrollment = new DateTime( 1900, 01, 01 );
					account.EvergreenCommisionRate = contract.EvergreenCommisionRate;
					account.EvergreenCommissionEnd = contract.EvergreenCommissionEnd;
					account.EvergreenOptionId = contract.EvergreenOptionId;
					account.ResidualCommisionEnd = contract.ResidualCommisionEnd;
					account.ResidualOptionId = contract.ResidualOptionId;
					account.InitialPymtOptionId = contract.InitialPymtOptionId;
					if( account.ContractType == "POWER MOVE" )
						account.DateFlowStart = account.DateEnd;
					else
						account.DateFlowStart = new DateTime( 1900, 01, 01 );
					if( account.ContractType == "AMENDMENT" )
					{
						string contractAmendNumber = account.ContractAmendNumber;
						if( string.IsNullOrEmpty( contractAmendNumber ) )
						{
							throw new Exception( AccountSql.SelectMessage( "DEAL", "00000049" ) );
						}

						DataSet ds = GetContractAmendInfo( contractAmendNumber );
						if( ds.Tables[0].Rows.Count == 0 )
						{
							throw new Exception( AccountSql.SelectMessage( "DEAL", "00000049" ) );
						}
						contractTypeAmend = ds.Tables[0].Rows[0]["contract_type"].ToString().Trim();
						status = ds.Tables[0].Rows[0]["status"].ToString().Trim();
						subStatus = ds.Tables[0].Rows[0]["sub_status"].ToString().Trim();
						string porOption = ds.Tables[0].Rows[0]["por_option"].ToString().Trim();
						if( status == "05000" || status == "06000" || status == "07000" || status == "08000"
							|| status == "09000" || status == "905000" || status == "906000" )
						{
							if( porOption == "NO" )
								status = "05000";
							else
								status = "06000";
							subStatus = "10";
						}
						processId = "CONTRACT AMENDMENT";
						contractNumber = contractAmendNumber;
					}
					else
					{
						processId = "DEAL CAPTURE";
						contractNumber = account.ContractNumber;
					}
					contract.ContractNumber = contractNumber;
					account.ContractNumber = contractNumber;

					if( !CheckIfAccountCommentExists( account.AccountId, processId ) )
					{
						if( !String.IsNullOrEmpty( account.Comment ) )
						{
							InsertAccountComment( account.AccountId, account.DateComment, processId, account.Comment, username );
						}
					}
					InsertAccountStatusHistory( username, account.AccountId, status, subStatus, account.DateSubmit, processId, account.Utility.Code );

					//--------------------------------------

					DateTime dateFlowStart;
					DateTime dateEnd;
					string entityId = "";
					string contractType = "";
					string accountType = "";



					CompanyAccount acc = null;

					if( account.ContractType == "POWER MOVE" )
					{
						dateFlowStart = account.DateEnd;
						dateEnd = dateFlowStart.AddMonths( account.TermMonths );
						entityId = GetEntityId( account.AccountNumber );
						account.EntityId = entityId;
					}

					if( account.ContractType == "AMENDMENT" )
					{
						contractType = contractTypeAmend;
					}
					else
					{
						contractType = account.ContractType;
					}
					accountType = AccountSql.GetAccountTypeByProduct( account.Product.ProductId ); //GetAccountTypeByProduct( account.Product.ProductId );
					account.AccountType = accountType;
					account.ContractType = contractType;

					//SR1-43764006
					//if (CheckIfExistsAccountIdInAccountTable(username, account.AccountId))
					//{
					//    acc = CompanyAccountFactory.GetCompanyAccount(account.AccountId);
					//    if (acc.EnrollmentStatus == "911000" || acc.EnrollmentStatus == "999998" || acc.EnrollmentStatus == "999999")
					//    {
					//        status = acc.EnrollmentStatus;
					//        subStatus = acc.EnrollmentSubStatus;
					//    }
					//}

					account.Status = status;
					account.SubStatus = subStatus;


					string statusOld = status;
					string subStatusOld = subStatus;
					if( acc != null )
					{
						statusOld = acc.EnrollmentStatus;
						subStatusOld = acc.EnrollmentSubStatus;
					}

					if( accountExists )
					{
						//never delete account info, do a update when  necessary
						AccountSql.DeleteAccountInfo( account.AccountNumber, account.Utility.Code );
					}
					else
					{
						InsertAccountAdditionalInfo( username, account.AccountId );
					}

					account.AccountNameLink = InsertAccountName( account.AccountId, account.AccountName );
					account.CustomerNameLink = InsertAccountName( account.AccountId, account.CustomerName );
					account.OwnerNameLink = InsertAccountName( account.AccountId, account.OwnerName );
					account.CustomerAddressLink = InsertAccountAddress( account.AccountId, account.CustomerAddress, account.CustomerSuite, account.CustomerCity, account.CustomerState, account.CustomerZip );
					account.BillingAddressLink = InsertAccountAddress( account.AccountId, account.BillingAddressStreet, account.BillingSuite, account.BillingCity, account.BillingState, account.BillingZip );
					account.ServiceAddressLink = InsertAccountAddress( account.AccountId, account.ServiceAddressStreet, account.ServiceSuite, account.ServiceCity, account.ServiceState, account.ServiceZip );
					account.CustomerContactLink = InsertAccountContact( account.AccountId, account.CustomerFirstName, account.CustomerLastName, account.CustomerTitle, account.CustomerPhone, account.CustomerFax, account.CustomerEmail, "01/01" );
					account.BillingContactLink = InsertAccountContact( account.AccountId, account.BillingFirstName, account.BillingLastName, account.BillingTitle, account.BillingPhone, account.BillingFax, account.BillingEmail, "01/01" );

					if( accountExists )
					{
						UpdateAccount( username, account );
					}
					else
					{
						InsertAccount( username, account );
					}

					if( (!String.IsNullOrEmpty( account.CustomerCode )) || (!String.IsNullOrEmpty( account.BillingAccount )) )
					{
						if( CheckIfAccountExistsInInfoTable( account.AccountId ) )
						{
							AccountSql.UpdateAccountinfo( account.AccountId, account.Utility.Code, account.CustomerCode, account.BillingAccount );
						}
						else
						{
							InsertAccountInfo( account.AccountId, account.Utility.Code, account.CustomerCode, account.BillingAccount, account.DateCreated );
						}
					}
					//InsertContractTrackingDetails( account );
					InsertAccountMeters( account.AccountId, account.MeterNumber );

					AccountEventProcessor.ProcessEvent( AccountEventType.DealSubmission, account.AccountNumber, account.Utility.Code );
				}// END FOR EACH ACCOUNT

				if( contract.ContractType != "AMENDMENT" )
				{
					LibertyPowerSql.InsertWIPTasks( contract.ContractNumber, username );
				}

				ExecuteFinalUpdates( contract );

				//end of usp_contract_submit_ins
				//delete errors from deal_contract_error
				scope.Complete();
			}
		}

		private static void ExecuteFinalUpdates( ProspectContract contract )
		{
			if( contract != null )
			{
				foreach( ProspectAccount account in contract.Accounts )
					UpdateAccountContractRatePriceID( account.AccountNumber, account.PriceID );
			}
		}

		public static string GetOldAccountID( string accountNumber, string utilityCode )
		{
			object accountID = AccountSql.GetAccountIDByNumberAndUtility( accountNumber, utilityCode );
			if( accountID != null )
				return Convert.ToString( accountID );
			else
				return null;
		}

		private static string LoadSalesManager( string salesChannelRole )
		{
			Vendor scVendor = VendorFactory.GetVendor( salesChannelRole );
			if( scVendor != null )
			{
				if( scVendor.ChannelDevelopmentManagerID != null )
				{
					LibertyPower.Business.CommonBusiness.SecurityManager.User salesManagerUser = UserFactory.GetUser( (int) scVendor.ChannelDevelopmentManagerID );
					return salesManagerUser.DisplayName;
				}
				else
				{
					return null;
				}
			}
			else
			{
				return null;
			}

		}

		public static string GetFirstCheckType( string utilityId, string contractType )
		{
			DataSet ds = AccountSql.GetFirstCheckType( utilityId, contractType );
			string checkType = "";

			if( ds.Tables[0].Rows.Count > 0 && ds.Tables[0].Rows[0]["check_type"] != DBNull.Value )
				checkType = ds.Tables[0].Rows[0]["check_type"].ToString();
			return checkType;
		}

		public static DataSet GetContractAmendInfo( string contractAmendNumber )
		{
			DataSet ds = AccountSql.GetAccountByContract( contractAmendNumber, "ALL" );
			return ds;
		}

		public static DataSet GetUtilityCheckType( string utilityId, string contractType, string checkType )
		{
			DataSet ds = AccountSql.GetUtilityCheckType( utilityId, contractType, checkType );
			return ds;
		}

		public static bool CheckIfAccountExistsInInfoTable( string accountId )
		{
			bool flag = false;

			DataSet ds = AccountSql.GetAccountInfoById( accountId );
			if( ds.Tables[0].Rows.Count > 0 )
			{
				flag = true;
			}

			return flag;
		}

		public static bool CheckIfAccountExists( string username, string accountNumber, string utilityId )
		{
			bool flag = AccountSql.CheckIfAccountExists( username, accountNumber, utilityId );

			return flag;
		}

		public static void InsertAccountAdditionalInfo( string username, string accountId )
		{
			AccountSql.InsertAccountAdditionalInfo( username, accountId );
		}

		public static bool CheckIfAccountNameExists( string username, string accountId, int nameLink )
		{
			bool flag = false;
			DataSet ds = AccountSql.GetAccountName( username, accountId, "NONE", nameLink );

			if( ds.Tables[0].Rows.Count > 0 )
			{
				flag = true;
			}

			return flag;
		}

		public static void InsertAccountName( string accountId, int nameLink, string name )
		{
			AccountSql.InsertName( accountId, nameLink, name );
		}

		public static int InsertAccountName( string accountId, string name )
		{
			int nameLink = AccountSql.InsertName( accountId, name );

			return nameLink;
		}

		public static bool CheckIfAccountAddressExists( string username, string accountId, int addressLink )
		{
			bool flag = false;
			DataSet ds = AccountSql.GetAccountAddress( username, accountId, "NONE", addressLink );

			if( ds.Tables[0].Rows.Count > 0 )
			{
				flag = true;
			}

			return flag;
		}

		public static void InsertAccountAddress( string accountId, int addressLink, string address, string suite, string city, string state, string zip )
		{
			AccountSql.InsertAddress( accountId, addressLink, address, suite, city, state, zip );
		}

		public static int InsertAccountAddress( string accountId, string address, string suite, string city, string state, string zip )
		{
			int addressLink = AccountSql.InsertAddress( accountId, address, suite, city, state, zip );
			return addressLink;
		}

		public static bool CheckIfAccountContactExists( string username, string accountId, int contactLink )
		{
			bool flag = false;
			DataSet ds = AccountSql.GetAccountContact( username, accountId, "NONE", contactLink );

			if( ds.Tables[0].Rows.Count > 0 )
			{
				flag = true;
			}

			return flag;
		}

		public static void InsertAccountContact( string accountId, int contactLink, string firstName, string lastName, string title, string phone, string fax, string email, string birthday )
		{
			AccountSql.InsertContact( accountId, contactLink, firstName, lastName, title, phone, fax, email, birthday );
		}

		public static int InsertAccountContact( string accountId, string firstName, string lastName, string title, string phone, string fax, string email, string birthday )
		{
			int contactLink = AccountSql.InsertContact( accountId, firstName, lastName, title, phone, fax, email, birthday );
			return contactLink;
		}

		public static bool CheckIfAccountCommentExists( string accountId, string processId )
		{
			bool flag = false;
			DataSet ds = AccountSql.SelectComment( accountId, processId );
			if( ds.Tables[0].Rows.Count > 0 )
			{
				flag = true;
			}
			return flag;
		}

		public static void InsertAccountComment( string accountId, DateTime dateComment, string processId, string comment, string username )
		{
			AccountSql.InsertComment( accountId, processId, comment, username );
		}

		public static void InsertAccountStatusHistory( string username, string accountId, string status, string subStatus, DateTime dateSubmit, string processId, string utilityId )
		{
			AccountSql.InsertAccountStatusHistory( username, accountId, status, subStatus, dateSubmit, processId, utilityId );
		}

		public static bool CheckIfExistsAccountByUsername( string username, string status, string subStatus )
		{
			bool flag = AccountSql.CheckIfExistsAccountByUsername( username, status, subStatus );

			return flag;
		}

		public static bool CheckIfExistsAccountIdInAccountTable( string username, string accountId )
		{
			bool flag = false;
			DataSet ds = AccountSql.GetCompanyAccount( username, accountId );

			if( ds.Tables[0].Rows.Count > 0 )
			{
				flag = true;
			}

			return flag;
		}

		public static DataSet GetCheckTypeNewContract( string utilityId, string contractType )
		{
			DataSet ds = AccountSql.GetCheckTypeNewContract( utilityId, contractType );

			return ds;
		}

		public static bool CheckIfExistsStepsOnCheckAccountTable( string contractNbr, string checkType )
		{
			bool flag = false;
			DataSet ds = AccountSql.GetCheckAccountByContractAndCheckType( contractNbr, checkType );

			if( ds.Tables[0].Rows.Count > 0 )
			{
				flag = true;
			}

			return flag;
		}

		public static void InsertSalesChannelHist( string username, string accountId, DateTime dateSubmit, string salesChannelRole, string checkTypeNewContract )
		{
			AccountSql.InsertSalesChannelHist( username, accountId, dateSubmit, salesChannelRole, checkTypeNewContract );
		}

		public static void InsertCheckAccount( string username, string contractNumber, string checkTypeNewContract, DateTime dateSubmit )
		{
			AccountSql.InsertCheckAccount( username, contractNumber, "", checkTypeNewContract, "ENROLLMENT", "PENDING", dateSubmit, "", new DateTime( 1900, 01, 01 ), "ONLINE", "", "", new DateTime( 1900, 01, 01 ), "",
				new DateTime( 1900, 01, 01 ), new DateTime( 1900, 01, 01 ), 1 );
		}

		public static string GetEntityId( string accountNumber )
		{
			DataSet ds = AccountSql.SelectEntityByAccountNumber( accountNumber );
			string entity = "";
			if( ds.Tables[0].Rows[0]["entity_id"] != DBNull.Value )
				entity = ds.Tables[0].Rows[0]["entity_id"].ToString().Trim();
			return entity;
		}

		public static void InsertAccount( string username, ProspectAccount account )
		{
			AccountSql.InsertAccount( username, account.AccountId, account.AccountNumber, account.AccountType, account.Status, account.SubStatus, account.EntityId,
				account.ContractNumber, account.ContractType, account.Market.Code, account.Utility.Code, account.Product.ProductId, account.RateId, account.Rate,
				account.AccountNameLink, account.CustomerNameLink, account.CustomerAddressLink, account.CustomerContactLink, account.BillingAddressLink, account.BillingContactLink, account.OwnerNameLink,
				account.ServiceAddressLink, account.BusinessType, account.BusinessActivity, account.AdditionalIdNumber, account.AdditionalIdNumberType,
				account.EffStartDate, account.TermMonths, account.DateEnd, account.DateDeal, account.DateCreated, account.DateSubmit,
				account.SalesChannelRole, account.SalesRep, account.Origin, account.AnnualUsage, account.DateFlowStart, account.DatePorEnrollment,
				account.DateDeEnrollment, account.DateReEnrollment, account.TaxStatus, account.TaxFloat, account.CreditScore, account.CreditAgency,
				account.PorOption, account.BillingType, account.RequestedFlowStartDate, account.DealType, account.EnrollmentType, account.CustomerCode,
				account.CustomerGroup, account.SSNEncrypted, account.HeatIndexSourceId, account.HeatRate, account.SalesManager, account.EvergreenOptionId,
				account.EvergreenCommissionEnd, account.EvergreenCommisionRate, account.ResidualOptionId, account.ResidualCommisionEnd,
				account.InitialPymtOptionId, account.OriginalTaxDesignation, account.EstimatedAnnualUsage, account.PriceID );
		}

		public static void UpdateAccount( string username, ProspectAccount account )
		{
			AccountSql.UpdateAccount( username, account.AccountId, account.AccountNumber, account.AccountType, account.Status, account.SubStatus, account.EntityId,
				account.ContractNumber, account.ContractType, account.Market.Code, account.Utility.Code, account.Product.ProductId, account.RateId, account.Rate,
				account.AccountNameLink, account.CustomerNameLink, account.CustomerAddressLink, account.CustomerContactLink, account.BillingAddressLink, account.BillingContactLink, account.OwnerNameLink,
				account.ServiceAddressLink, account.BusinessType, account.BusinessActivity, account.AdditionalIdNumber, account.AdditionalIdNumberType,
				account.EffStartDate, account.TermMonths, account.DateEnd, account.DateDeal, account.DateCreated, account.DateSubmit,
				account.SalesChannelRole, account.SalesRep, account.Origin, account.AnnualUsage, account.DateFlowStart, account.DatePorEnrollment,
				account.DateDeEnrollment, account.DateReEnrollment, account.TaxStatus, account.TaxFloat, account.CreditScore, account.CreditAgency,
				account.PorOption, account.BillingType, account.RequestedFlowStartDate, account.DealType, account.EnrollmentType, account.CustomerCode,
				account.CustomerGroup, account.SSNEncrypted, account.HeatIndexSourceId, account.HeatRate, account.SalesManager, account.EvergreenOptionId,
				account.EvergreenCommissionEnd, account.EvergreenCommisionRate, account.ResidualOptionId, account.ResidualCommisionEnd,
				account.InitialPymtOptionId, account.OriginalTaxDesignation );
		}

		public static void InsertAccountInfo( string accountId, string utilityId, string customerCode, string billingAccount, DateTime dateCreated )
		{
			AccountSql.insertAccountinfo( accountId, utilityId, customerCode, billingAccount, dateCreated );
		}

		public static void InsertAccountMeters( string accountId, string meterNumber )
		{
			AccountSql.insertAccountMeters( accountId, meterNumber );
		}

		public static bool CheckIfRiskExists( string riskRequestId )
		{
			return AccountSql.CheckIfRiskExists( riskRequestId );
		}

		public static void UpdateContractEstimatedAnnualUsage( string contractNumber, int estimatedAnnualUsage )
		{
			LibertyPowerSql.UpdateContractEstimatedAnnualUsage( contractNumber, estimatedAnnualUsage );
		}

		public static void UpdateAccountContractRatePriceID( string accountNumber, Int64 priceID )
		{
			LibertyPowerSql.UpdateAccountContractRatePriceID( accountNumber, priceID );
		}

		public static void UpdateAccountContractRatePriceData( string contractNumber, string accountNumber, string productId, Int64 rateID, decimal rate, Int64 priceID )
		{
			LibertyPowerSql.UpdateAccountContractRatePriceData( contractNumber, accountNumber, productId, rateID, rate, priceID );
		}

		public static bool ValidateAccountNumberByUtility( string accountNumber, int utilityId )
		{
			bool isValid = false;

			DataSet utilityResult = LibertyPower.DataAccess.SqlAccess.LibertyPowerSql.UtilitySql.GetUtility( utilityId );

			int accountLenght = (int) utilityResult.Tables[0].Rows[0]["AccountLength"];
			string accountPrefix = (string) utilityResult.Tables[0].Rows[0]["AccountNumberPrefix"];

			if( accountNumber.Length == accountLenght && accountNumber.StartsWith( accountPrefix ) )
			{
				isValid = true;
			}

			return isValid;
		}

        public static DataSet GetCapacityFactor(int? contractId, int? accountId, bool isRenewal)
        {
            DataSet ds = AccountSql.GetCapacityFactor(contractId, accountId, isRenewal);

            return ds;
        }

        public static void CalculateCapacityFactor(int contractId, bool isRenewal, string lstrUser)
        {
            AccountSql.CalculateCapacityFactor(contractId, isRenewal, lstrUser);
        }
	}
}
