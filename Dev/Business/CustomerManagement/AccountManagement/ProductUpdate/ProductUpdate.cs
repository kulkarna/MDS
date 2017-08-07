using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using LibertyPower.DataAccess.WebServiceAccess.IstaWebService;
using LibertyPower.DataAccess.SqlAccess.AccountSql;
using LibertyPower.Business.MarketManagement.UtilityManagement;
using LibertyPower.Business.CustomerAcquisition.ProductManagement;
using System.Data;
using LibertyPower.Business.CommonBusiness.CommonHelper;
using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;

namespace LibertyPower.Business.CustomerManagement.AccountManagement.ProductUpdate
{
	/// <summary>
	/// Product update for company account related methods
	/// </summary>
	public static class ProductUpdate
	{
        public static bool Use814C
        {
            get
            {
                if (System.Configuration.ConfigurationManager.AppSettings["Use814C"] != null)
                {
                    return Convert.ToBoolean(System.Configuration.ConfigurationManager.AppSettings["Use814C"]);
                }
                else
                {
                    return false;
                }
            }
        }

		public static void UpdateProduct( string accountId, ProductUpdateType updateType )
		{
			CompanyAccount account = CompanyAccountFactory.GetCompanyAccount( accountId );

			if( updateType == ProductUpdateType.Renewal )
			{
				SubmitUnprocessedReenrollment( account );

				//if the account is not new (new accounts have the rate sent in enrollment submission queue) we send the renewal
                if (account.EnrollmentStatus.Trim() != EnrollmentStatus.GetValue(EnrollmentStatus.Status.PendingEnrollment))
                {
                    //Get the renewal account information to send to ISTA
                    account = CompanyAccountFactory.GetCompanyAccountRenewal(account.AccountNumber, account.UtilityCode, false);
                    SendRateToISTA(account, updateType, true, account.ContractStartDate);
                    CompanyAccountFactory.UpdateAccountStatus(accountId, "Renewal account submitted to ISTA", "ENROLLMENT", "SYSTEM", "07000", "20", true);
                    //CompanyAccountFactory.UpdateAccountSubmissionQueue(accountId, 3, 2);
                }
                else
                {
                    //SR1-19853366
                    throw new Exception("Account is in Pending Enrollment - Create Utility File status. Please, submit the enrollment request before submitting the renewal rate change.");
                }
				
			}
			else if( updateType == ProductUpdateType.Rollover )
			{
				//Calculate the rollover information (product, rate and dates) and change it in the 
				//account object to send it to ISTA
				decimal Rate = 0;
				int RateId = 0;
                string utilityid;
				DateTime oldContractEndDate = account.ContractEndDate;
				account.Term = 12;
                account.Product = GetExpiredProduct(account, out Rate, out RateId, out utilityid);
				account.ProductRate.Rate = Rate;
				account.ProductRate.RateId = RateId;
				account.ContractStartDate = account.ContractEndDate.AddDays(1);
                account.ContractEndDate = account.ContractStartDate.AddMonths(account.Term);
                // Ticket - 1-166369340  ********** Start By Brahmaiah Chowdary Murakonda  *****************//
                if (account.ContractEndDate > System.DateTime.Today)
                {
                    if (!( IsCtPura()) || !((utilityid.Trim().ToUpper() == "CL&P" || utilityid.Trim().ToUpper() == "UI") &&
                          (account.AccountType == CompanyAccountType.RESIDENTIAL || account.AccountType == CompanyAccountType.SOHO)))
                    {
                    SendRateToISTA(account, updateType, true, account.ContractStartDate);
                    }

                    if (String.IsNullOrEmpty(account.ReadCycleId))
                        AccountSql.LogExpiredProductError(account.Identifier, oldContractEndDate, oldContractEndDate.AddYears(1), 2);
                    AccountSql.UpdateProductAndRates(accountId, account.Product.ProductId, RateId, Rate, account.Term, account.ContractStartDate, account.ContractEndDate);

                }
                else
                {
                    while (account.ContractEndDate <= System.DateTime.Today) 
                    {

                        oldContractEndDate = account.ContractEndDate;
                        if (String.IsNullOrEmpty(account.ReadCycleId))
                            AccountSql.LogExpiredProductError(account.Identifier, oldContractEndDate, oldContractEndDate.AddYears(1), 2);
                        AccountSql.UpdateProductAndRates(accountId, account.Product.ProductId, RateId, Rate, account.Term, account.ContractStartDate, account.ContractEndDate);
                        account.Term = 12;
                        account.Product = GetExpiredProduct(account, out Rate, out RateId, out utilityid);
                        account.ProductRate.Rate = Rate;
                        account.ProductRate.RateId = RateId;
                        account.ContractStartDate = account.ContractEndDate.AddDays(1);
                        account.ContractEndDate = account.ContractStartDate.AddMonths(account.Term);

                    }
                  
                    if (!(IsCtPura()) || !((utilityid.Trim().ToUpper() == "CL&P" || utilityid.Trim().ToUpper() == "UI") &&
                          (account.AccountType == CompanyAccountType.RESIDENTIAL || account.AccountType == CompanyAccountType.SOHO)))
                    {
                    SendRateToISTA(account, updateType, true, account.ContractStartDate);                   
                    }
                    if (String.IsNullOrEmpty(account.ReadCycleId))
                        AccountSql.LogExpiredProductError(account.Identifier, oldContractEndDate, oldContractEndDate.AddYears(1), 2);
                    AccountSql.UpdateProductAndRates(accountId, account.Product.ProductId, RateId, Rate, account.Term, account.ContractStartDate, account.ContractEndDate);
                }
                // Ticket - 1-166369340  ********** End By Brahmaiah Chowdary Murakonda  *****************//
			}
            else if (updateType == ProductUpdateType.DateChange)
            {
                SendRateToISTA(account, updateType, true, account.ContractStartDate);
                LibertyPowerSql.UpdateEnrollmentAcceptLog(account.Identity);
            }
		}

		public static void UpdateProduct( string accountId, ProductUpdateType updateType, DateTime RateEffectiveDate )
		{
			CompanyAccount account = CompanyAccountFactory.GetCompanyAccount( accountId );

			if( updateType == ProductUpdateType.ProductChange )
			{
				if( (account.EnrollmentStatus.Trim() == EnrollmentStatus.GetValue( EnrollmentStatus.Status.NotEnrolled )) ||
					 (account.EnrollmentStatus.Trim() == EnrollmentStatus.GetValue( EnrollmentStatus.Status.EnrollmentCancelled )) ||
					 (account.EnrollmentStatus.Trim() == EnrollmentStatus.GetValue( EnrollmentStatus.Status.Deenrolled )) )
					throw new Exception( "Status " + account.EnrollmentStatus.Trim() + " is invalid for submitting product changes to the billing provider" );
				//Get the account information with the already modified product and rate to send it to ISTA
				SendRateToISTA( account, updateType, false, RateEffectiveDate );
			}
		}

		/// <summary>
		/// Tryes to send a reenrollment request if the account is in pending deenrollment  
		/// in account table and the deenroll date has already passed
		/// </summary>
		/// <param name="account"></param>
		private static void SubmitUnprocessedReenrollment( CompanyAccount account )
		{
			if( account.EnrollmentStatus.Trim() == EnrollmentStatus.GetValue( EnrollmentStatus.Status.PendingReenrollment )
				&& account.EnrollmentSubStatus.Trim() == "60" && account.DeenrollmentDate <= DateTime.Today )
			{
				try
				{
					CompanyAccountFactory.Reenroll( account, "SYSTEM" );
				}
				catch( Exception )
				{
					throw new Exception( "Account needs to be reenrolled. Please try sending the reenrollment before sending the renewal." );
				}
			}
		}

		/// <summary>
		/// Sends the account new billing information to ISTA
		/// This method has a flag to represent if it is allowed to change the eff date to send to ISTA. If this needs to be done, 
		/// and AccountDateErrorLog will be recorded.
		/// </summary>
		/// <param name="account"></param>
		/// <param name="productUpdateType">Date that change will apply</param>
		/// <param name="allowChangeStartDate">If it is allowed to change the eff date for sending purposes only</param>
		private static void SendRateToISTA( CompanyAccount account, ProductUpdateType productUpdateType, bool allowChangeStartDate, DateTime RateEffectiveDate )
		{
			string MarketCode = MarketFactory.GetRetailMarketByUtility( account.UtilityCode );
			decimal MeterCharge = CompanyAccountFactory.GetMeterCharge( account, MarketCode );
            ProductPlanType oldPlanType = GetPlanType(MarketCode, account.Product);
            RateServiceWCF.ProductPlanType PlanType = GetRateServicePlanType(MarketCode, account.Product);
            RateServiceWCF.BillingType BillingType = GetRateServiceBillingType(account.BillingType);

			int VariableTypeID = 1;
           

			if( account.Product.ProductBrandID == 4 )
			{
				VariableTypeID = 2;
			}
           
            //Old 814C logic: now on RateServiceWCF
            bool Send814CFlag = false;
            if (((productUpdateType == ProductUpdateType.Renewal || SendWith814Option(account.UtilityCode)) && (account.BillingType == "RateReady" || account.BillingType == "RR")) && account.UtilityCode.ToUpper() != "CONED")
                Send814CFlag = true;

            if (String.IsNullOrEmpty(account.RateCode))
            {
                account.RateCode = CompanyAccountFactory.RateCodeValidation(account, account.RateClass, account.ZoneCode, account.ProductRate.Rate, account.Product.Category.ToString());
                bool isRenewalAccount = (productUpdateType == ProductUpdateType.Renewal);
                CompanyAccountFactory.UpdateRateCode(account, isRenewalAccount);
            }

            RateServiceWCF.CustomerRate customerRate = new RateServiceWCF.CustomerRate();
            customerRate.AccountNumber = account.AccountNumber;
            customerRate.UtilityCode = account.UtilityCode;
            customerRate.ProductType = PlanType;
            customerRate.Rate1 = account.Rate;
            customerRate.Rate2 = 0;
            customerRate.Rate3 = 0;
            customerRate.MeterCharge = MeterCharge;
            customerRate.RateEffectiveDate = RateEffectiveDate;
            customerRate.RateEndDate = account.ContractEndDate;
            customerRate.RateCode = account.RateCode;
            customerRate.VariableTypeID = VariableTypeID;
            customerRate.BillingType = BillingType;
            customerRate.CreditInsuranceFlag = account.CreditInsuranceFlag;

            RateServiceWCF.RateServiceClient rateServiceClient = new RateServiceWCF.RateServiceClient();

            try
            {
                if (Use814C)
                {
                    rateServiceClient.UpdateCustomerRate(customerRate);
                }
                else
                {
                    RateService.UpdateCustomerRate(account.AccountNumber, account.UtilityCode, oldPlanType, account.Rate, MeterCharge, RateEffectiveDate, account.ContractEndDate, account.RateCode, VariableTypeID, Send814CFlag);
                }
                LibertyPowerSql.LogRenewalSubmission(account.AccountNumber, account.UtilityCode, account.Rate, MeterCharge, RateEffectiveDate, account.ContractEndDate, account.RateCode, Send814CFlag, string.Empty);
            }
            catch (Exception ex)
            {
                
                LibertyPowerSql.LogRenewalSubmission(account.AccountNumber, account.UtilityCode, account.Rate, MeterCharge, RateEffectiveDate, account.ContractEndDate, account.RateCode, Send814CFlag, ex.Message);

                if (allowChangeStartDate && ex.Message.Contains("The earliest Switch Date for this rollover can be"))
                {
                    //Switch Date is not within 7 days of the Next Scheduled Read Date 5/18/2011. The earliest Switch Date for this rollover can be 5/19/2011
                    string date = ex.Message.Substring(ex.Message.LastIndexOf(" ") + 1, ex.Message.Length - (ex.Message.LastIndexOf(" ") + 1));
                    DateTime startDate = Convert.ToDateTime(date.Trim());
                    customerRate.RateEffectiveDate = startDate;
                    if (Use814C)
                    {
                        rateServiceClient.UpdateCustomerRate(customerRate);
                    }
                    else
                    {
                        RateService.UpdateCustomerRate(account.AccountNumber, account.UtilityCode, oldPlanType, account.Rate, MeterCharge, startDate, account.ContractEndDate, account.RateCode, Send814CFlag);
                    }
                    LibertyPowerSql.LogAccountDateError(account.Identifier, productUpdateType.ToString(), account.ContractStartDate, startDate);
                    
                }
                else
                {
                    throw ex;
                }

            }
            finally
            {
                if (rateServiceClient != null)
                {
                    rateServiceClient.Close();
                }
            }
		}

        private static RateServiceWCF.BillingType GetRateServiceBillingType(string billingType)
        {
            billingType = billingType.ToUpper();
           
            switch (billingType)
            {
                case "DUAL":
                case "DUALBILLING":
                    return RateServiceWCF.BillingType.Dual;
                    break;
                case "RR":
                case "RATEREADY":
                    return RateServiceWCF.BillingType.RateReady;
                    break;
                case "BR":
                case "BILLREADY":
                    return RateServiceWCF.BillingType.BillReady;
                    break;
                case "SC":
                case "SUPPLIERCONSOLIDATED":
                    return RateServiceWCF.BillingType.SupplierConsolidated;
                    break;
                case "NONE":
                case "":
                    return RateServiceWCF.BillingType.None;
                    break;
                default:
                    return RateServiceWCF.BillingType.Unknown;
                    break;
            }
        }
		/// <summary>
		/// Gets the expired default product for the product specified in the account object
		/// </summary>
		/// <param name="account"></param>
		/// <param name="Rate"></param>
		/// <param name="RateId"></param>
		/// <returns></returns>
		public static Product GetExpiredProduct( CompanyAccount account, out decimal Rate, out int RateId, out string UtilityID )
		{
			Product Product = null;
			Rate = 0;
			RateId = 0;
            UtilityID = string.Empty;
			bool informationRetrieved = false;
			DataSet ds = LibertyPower.DataAccess.SqlAccess.CommonSql.ProductSql.GetDefaultExpiredProduct( account.Product.ProductId );

			if( DataSetHelper.HasRow( ds ) )
			{
				DataRow DefaultExpiredProduct = ds.Tables[0].Rows[0];
				string ExpiredProductId;

				if( DefaultExpiredProduct["ProductId"] != DBNull.Value )
				{
					ExpiredProductId = DefaultExpiredProduct["ProductId"].ToString();
					Product = ProductFactory.CreateProduct( ExpiredProductId );

                    if (DefaultExpiredProduct["UtilityID"] != DBNull.Value)
                    {
                        UtilityID = DefaultExpiredProduct["UtilityID"].ToString();
                    }

					if( DefaultExpiredProduct["RateId"] != DBNull.Value )
					{
						Rate = Convert.ToDecimal( DefaultExpiredProduct["Rate"].ToString() );
						RateId = Convert.ToInt32( DefaultExpiredProduct["RateId"].ToString() );
						informationRetrieved = true;
					}
				}
			}

			if( !informationRetrieved )
			{
				short errorCode = 3;
				AccountSql.LogExpiredProductError( account.Identifier, account.ContractEndDate, account.ContractEndDate, errorCode );
				throw new Exception( "Product " + account.Product.ProductId + " either has no default expire product, is not active, or does not have a rate " );
			}

			return Product;
		}

        /// <summary>
        /// Gets the expired default product for the product specified in the account object
        /// </summary>
        /// <param name="account"></param>
        /// <param name="Rate"></param>
        /// <param name="RateId"></param>
        /// <returns></returns>
        public static void GetProductByProductId(string currentProductId, out bool isVariable, out decimal Rate, out int RateId)
        {
            Rate = 0;
            RateId = 0;
            isVariable = false;
            bool informationRetrieved = false;
            DataSet ds = LibertyPower.DataAccess.SqlAccess.CommonSql.ProductSql.GetProductRateInformation(currentProductId);

            if (DataSetHelper.HasRow(ds))
            {
                DataRow productdr = ds.Tables[0].Rows[0];

                if (productdr["ProductId"] != DBNull.Value)
                {
                    if (productdr["ProductCategory"] != DBNull.Value && productdr["ProductCategory"].ToString().ToUpper().Contains("VARIABLE"))
                    {
                        isVariable = true;
                    }

                    if (productdr["RateId"] != DBNull.Value)
        {
                        Rate = Convert.ToDecimal(productdr["Rate"].ToString());
                        RateId = Convert.ToInt32(productdr["RateId"].ToString());
                        informationRetrieved = true;
                    }
                }
            }

            if (!informationRetrieved)
            {
                throw new Exception("Product " + currentProductId + " either has no default expire product, is not active, or does not have a rate ");
            }

        }


		private static ProductPlanType GetPlanType( string MarketId, Product Product )
		{
            if (Product is VariableProduct)
            {
                if (Product is BlockIndexProduct)
                    return ProductPlanType.BlockIndexed;
                else if (Product is IndexedProduct)
                {
                    if (Product.IsCustom)
                        return ProductPlanType.Index;
                    else if (MarketId.ToUpper() != "TX")
                        return ProductPlanType.Index;
                    else
                        return ProductPlanType.IndexTexas;
                }
                else if (((VariableProduct)Product).SubCategory == ProductSubCategory.Custom)
                    return ProductPlanType.CustomVariable;
                else if (((VariableProduct)Product).SubCategory == ProductSubCategory.Portfolio)
                    return ProductPlanType.PortfolioVarialble;
                else
                    return ProductPlanType.Hybrid;
            }
            else
                return ProductPlanType.Fixed;
        }

        private static RateServiceWCF.ProductPlanType GetRateServicePlanType(string MarketId, Product Product)
		{
			if( Product is VariableProduct )
			{
				if( Product is BlockIndexProduct )
                    return RateServiceWCF.ProductPlanType.BlockIndexed;
				else if( Product is IndexedProduct )
				{
                    if (Product.IsCustom)
                        return RateServiceWCF.ProductPlanType.Index;
                    else if (MarketId.ToUpper() != "TX")
                        return RateServiceWCF.ProductPlanType.Index;
                    else
                        return RateServiceWCF.ProductPlanType.IndexTexas;
				}
				else if( ((VariableProduct) Product).SubCategory == ProductSubCategory.Custom )
                    return RateServiceWCF.ProductPlanType.CustomVariable;
				else if( ((VariableProduct) Product).SubCategory == ProductSubCategory.Portfolio )
                    return RateServiceWCF.ProductPlanType.PortfolioVarialble;
				else
                    return RateServiceWCF.ProductPlanType.Hybrid;
			}
			else
                return RateServiceWCF.ProductPlanType.Fixed;
		}

		private static bool SendWith814Option( string utilityCode )
		{
			utilityCode = utilityCode.ToUpper();

            return (utilityCode == ("CL&P"));// || utilityCode == ("CENHUD") || utilityCode == ("NSTAR-BOS") || utilityCode == ("NSTAR-CAMB") || utilityCode == ("NSTAR-COMM"));
		}

        public static string ProductMethod(string accountId, ProductUpdateType updateType)
        {
            string rtn = "";
            try
            {
                CompanyAccount account = CompanyAccountFactory.GetCompanyAccount(accountId);

                if (updateType == ProductUpdateType.Rollover)
                {
                    //Calculate the rollover information (product, rate and dates) and change it in the 
                    //account object to send it to ISTA
                    decimal Rate = 0;
                    int RateId = 0;
                    string utilityId;
                    DateTime oldContractEndDate = account.ContractEndDate;
                    account.Term = 12;
                    account.Product = GetExpiredProduct(account, out Rate, out RateId, out utilityId);
                    account.ProductRate.Rate = Rate;
                    account.ProductRate.RateId = RateId;
                    account.ContractStartDate = account.ContractEndDate.AddDays(1);
                    account.ContractEndDate = account.ContractStartDate.AddMonths(account.Term);
                }

                string MarketCode = MarketFactory.GetRetailMarketByUtility(account.UtilityCode);
                decimal MeterCharge = CompanyAccountFactory.GetMeterCharge(account, MarketCode);
                ProductPlanType PlanType = GetPlanType(MarketCode, account.Product);

                int VariableTypeID = 1;


                if (account.Product.ProductBrandID == 4)
                {
                    VariableTypeID = 2;
                }

                bool Send814CFlag = false;
                if (((updateType == ProductUpdateType.Renewal || SendWith814Option(account.UtilityCode)) && (account.BillingType == "RateReady" || account.BillingType == "RR")) && account.UtilityCode.ToUpper() != "CONED")
                    Send814CFlag = true;

                if (Send814CFlag)
                    rtn = "814c";
                else
                    rtn = "Not 814c";
            }
            catch (Exception)
            {


            }
            return rtn;
        }


		private static bool IsCtPura()
		{

			try
			{
				DataSet ds = LibertyPowerSql.GetOrdersAPIConfiguration();
				if( ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0 )
				{
					if( ds.Tables[0].Columns.Contains( "ISCTPURA" ) )
					{
						Boolean result;
						Boolean.TryParse( ds.Tables[0].Rows[0]["ISCTPURA"].ToString(), out result );
						return result;
					}
				}
			}
			catch( Exception )
			{
				
			}
			return false;
		}

	}
}
