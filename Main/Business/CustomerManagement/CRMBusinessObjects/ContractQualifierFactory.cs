using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using LibertyPower.DataAccess.SqlAccess.CustomerManagementEF;
using LibertyPower.Business.CustomerManagement.AccountManagement;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
    public class ContractQualifierFactory
    {
        private static void MapDataRowToContractQualifier(DataRow dataRow, ContractQualifier contractQualifier)
        {
            contractQualifier.ContractQualifierId = dataRow.Field<int>("ContractQualifierId");
            contractQualifier.ContractId = dataRow.Field<int>("ContractId");
            contractQualifier.AccountId = dataRow.Field<int?>("AccountId");
            contractQualifier.QualifierId = dataRow.Field<int>("QualifierId");
            contractQualifier.PromotionStatusID = dataRow.Field<int>("PromotionStatusID");
            contractQualifier.Comment = dataRow.Field<string>("Comment");
            contractQualifier.CreatedBy = dataRow.Field<int>("CreatedBy");
            contractQualifier.CreatedDate = dataRow.Field<DateTime>("CreatedDate");
            contractQualifier.ModifiedBy = dataRow.Field<int>("ModifiedBy");
            contractQualifier.ModifiedDate = dataRow.Field<DateTime>("ModifiedDate");
        }
        private static void MapDataRowToQualifierFulfillment(DataRow dataRow, QualifierFulfillment QualifierFulfillment)
        {
            QualifierFulfillment.PromoCampaignCode = dataRow.Field<string>("PromoCampaignCode");
            QualifierFulfillment.PromotionCode = dataRow.Field<string>("PromotionCode");
            QualifierFulfillment.PromotionType = dataRow.Field<string>("PromotionType");
            QualifierFulfillment.SalesChannel = dataRow.Field<string>("SalesChannel");
            QualifierFulfillment.SalesRep = dataRow.Field<string>("SalesRep");
            QualifierFulfillment.Market = dataRow.Field<string>("Market");
            QualifierFulfillment.ContractNumber = dataRow.Field<string>("ContractNumber");
            QualifierFulfillment.AccountNumber = dataRow.Field<string>("AccountNumber");
            QualifierFulfillment.Customer = dataRow.Field<string>("Customer");
            QualifierFulfillment.ContactName = dataRow.Field<string>("ContactName");
            QualifierFulfillment.ContactPhone = dataRow.Field<string>("ContactPhone");
            QualifierFulfillment.EmailAddress = dataRow.Field<string>("EmailAddress");
            QualifierFulfillment.BillingStreet = dataRow.Field<string>("BillingStreet");
            QualifierFulfillment.BillingStreet2 = dataRow.Field<string>("BillingStreet2");
            QualifierFulfillment.BillingState = dataRow.Field<string>("BillingState");
            QualifierFulfillment.BillingZip = dataRow.Field<string>("BillingZip");
            QualifierFulfillment.SignDate = dataRow.Field<DateTime>("SignDate");
            QualifierFulfillment.ContractStartDate = dataRow.Field<DateTime>("ContractStartDate");
            QualifierFulfillment.AccountStatus = dataRow.Field<string>("AccountStatus");
            QualifierFulfillment.DaystoQualify = dataRow.Field<int>("DaystoQualify");
            QualifierFulfillment.QualifyDate = dataRow.Field<DateTime>("QualifyDate");
            QualifierFulfillment.FulfillmentStatus = dataRow.Field<string>("FulfillmentStatus");
            QualifierFulfillment.Comments = dataRow.Field<string>("Comments");
        }
        public static bool InsertContractQualifier(ContractQualifier contractQualifier, out List<GenericError> errors)
        {
            errors = new List<GenericError>();

            if (!contractQualifier.IsStructureValidForInsert())
            {
                throw new InvalidOperationException("The structure of the ContractQualifier Object is not valid");
            }

            errors = contractQualifier.IsValidForInsert();

            if (errors.Count > 0)
            {
                return false;
            }

            DataSet ds = PromotionQualifierSQL.InsertContractQualifier(contractQualifier.ContractId, contractQualifier.AccountId, contractQualifier.QualifierId, contractQualifier.PromotionStatusID,
                contractQualifier.Comment, contractQualifier.CreatedBy, contractQualifier.CreatedDate, contractQualifier.ModifiedBy, contractQualifier.ModifiedDate);

            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                MapDataRowToContractQualifier(ds.Tables[0].Rows[0], contractQualifier);

            return true;
        }

        /// <summary>
        /// Creates a new contract/qualifier relationship in ContractQualifiers table if and only if a qualifier exists for the condidate contract.
        /// </summary>
        /// <returns>
        /// If the Contract/Qualifier association was created based in a valid qualifier for any of the contract accounts.
        /// </returns>
        public static bool InsertContractQualifiers(string contractNumber, int? priceTierId, int? productBrandId, int? term, string promoCode, int? userId)
        {
            // TODO: Cross-table/multi-stored procedure calls, like the implementation in this method, can/should be refactored/made transactional to avoid transporting rare but sometimes insconsitent state from one stored procedure to another.

            Contract contract = ContractFactory.GetContractByContractNumber(contractNumber, true);
            bool existsAnyQualifiedAccount = false;
            List<GenericError> errors;

            if (contract != null && contract.AccountContracts != null)
                foreach (AccountContract accountContract in contract.AccountContracts)
                {
                    Account account = accountContract.Account;

                    CompanyAccount CAccount = CompanyAccountFactory.GetCompanyAccount(account.AccountId.Value);
                    int accountAnnualUsage = 0;

                    if (CAccount.AnnualUsage != null)
                    {
                        accountAnnualUsage = Convert.ToInt32(CAccount.AnnualUsage);
                    }

                    int? productAccountTypeID = account.AccountTypeId != null ?
                        AccountTypeFactory.GetAccountType(account.AccountTypeId.Value).ProductAccountTypeID : null;

                    QualifierResultSet qualifiersResultSet = QualifierFactory.ValidatePromotionCodeandQualifiers(
                        promoCode, contract.SignedDate, contract.SalesChannelId, account.RetailMktId, account.UtilityId,
                        productAccountTypeID, term, productBrandId, priceTierId, contract.StartDate, accountAnnualUsage);

                    if (qualifiersResultSet.IsValid)
                    {
                        Qualifier qualifierMatched = qualifiersResultSet.QualifiersMatch.First();

                        ContractQualifierFactory.InsertContractQualifier(new ContractQualifier
                        {
                            ContractId = contract.ContractId.Value,
                            AccountId = account.AccountId,
                            QualifierId = qualifierMatched.QualifierId,
                            PromotionStatusID = (int)LibertyPower.Business.CustomerManagement.CRMBusinessObjects.Enums.PromotionStatus.Pending,
                            ModifiedDate = System.DateTime.Now,
                            CreatedDate = System.DateTime.Now,
                            ModifiedBy = userId != null ? userId.Value : 0,
                            CreatedBy = userId != null ? userId.Value : 0
                        }, out errors);

                        if (errors != null && errors.Count > 0)
                        {
                            var ex = new Exception();
                            ex.Data.Add("errors", errors);
                            throw ex;
                        }

                        existsAnyQualifiedAccount = true;
                    }
                    else
                    {
                        InvalidOperationException qualifiersException = new InvalidOperationException();
                        qualifiersException.Data.Add("promoErrorMessage", qualifiersResultSet.Info);

                        throw qualifiersException;
                    }
                }

            return existsAnyQualifiedAccount;
        }

        /// <summary>
        /// Delete last contract-qualifier by contractNumber/promotionCode and possibly by accountNumber.
        /// </summary>
        public static bool DeleteContractQualifier(int contractQualifierId)
        {
            var ds = PromotionQualifierSQL.DeleteContractQualifier(contractQualifierId);

            if (ds != null && ds.Tables.Count > 0)
            {
                return true;
            }

            return false;
        }
        // Added to get the list of COntract Qualifiers and their fulfillment status Feb 12 2014
        /*  
           Created on:     17 Aug 2015
           Modified by:    Manish Pandey
           Discription:    Added new parameter ChannelId.
      */
        public static DataSet GetAllContractQualifierFulfillmentDetails(string CampaignID, string marketId,
            string contractNumber, string accountnumber, string promotionCode,
            string Customername, string fulfillmentStatus, string accountstatus, string orderby, int gridPageSize,
            int gridCurrentPageIndex, string ChannelIds, string UtilityId, out int totalCount)
        {
            DataSet ds = new DataSet();
            ds = PromotionQualifierSQL.GetAllContractQualifierFulfillmentDetails(CampaignID, marketId, contractNumber,
                accountnumber, promotionCode, Customername, fulfillmentStatus, accountstatus, orderby, gridPageSize,
                gridCurrentPageIndex, ChannelIds, UtilityId);
            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                totalCount = ds.Tables[0].Rows[0].Field<int>("TotalRecords");
            }
            else
                totalCount = 0;
            return ds;
        }
        //Get the Account details for a given contract - (Master details grid)
        public static DataSet GetAllAccountDetailsforFulfillment(string ContractID)
        {
            DataSet ds = new DataSet();
            ds = PromotionQualifierSQL.GetAllAccountDetailsforFulfillment(ContractID);
            return ds;
        }

        public static List<QualifierFulfillment> GetQualifierFulfillmentList(string AccountNumber, string ContractNumber, string CustomerName, string AccountStatusId, int? FulfillmentStatusId, int? CampaignId, int? PromotionCodeId, int? MarketId, string orderby)
        {
            List<QualifierFulfillment> QualifierFulfillmentResultset = new List<QualifierFulfillment>();
            DataSet ds = PromotionQualifierSQL.GetQualifierFulfillmentList(AccountNumber, ContractNumber, CustomerName, AccountStatusId, FulfillmentStatusId, CampaignId, PromotionCodeId, MarketId, orderby);

            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    QualifierFulfillment QualifierFulfillment = new QualifierFulfillment();

                    MapDataRowToQualifierFulfillment(dr, QualifierFulfillment);
                    QualifierFulfillmentResultset.Add(QualifierFulfillment);
                }
            }
            return QualifierFulfillmentResultset;
        }

        public static bool UpdateContractQualifierFulfillmentStatus(string ContractIdList, string Status, string Comment, int UserID)
        {
            DataSet ds = new DataSet();
            ds = PromotionQualifierSQL.UpdateContractQualifierFulfillmentStatus(ContractIdList, Status, Comment, UserID);

            if (ds != null && ds.Tables.Count > 0)
            {
                return true;
            }

            return false;
        }

        #region Email Template methods

        public static bool EmailContractQualifierInsertUpdate(string ContractNumber, bool EmailSent, string EmailErrorMessage, int EmailPromoCodeStatusId, int SentBy)
        {
            DataSet ds = new DataSet();
            ds = PromotionQualifierSQL.EmailContractQualifierInsertUpdate(ContractNumber, EmailSent, EmailErrorMessage, EmailPromoCodeStatusId, SentBy);

            if (ds != null && ds.Tables.Count > 0)
            {
                return true;
            }

            return false;

        }

        #endregion
        #region Import Excel
        /*  
            Created on  :   19 Oct 2015
            Created by  :   Manish Pandey
            Discription :   Get Fulfillment Status Details from Database and export quilifier into excel.
            PBI         :   54503
       */
        public static DataSet GetFulFillmentStatusDetails(DataTable FulfillmentStatusDetails, string CampaignId, out int totalCount)
        {
            DataSet ds = new DataSet();
            ds = PromotionQualifierSQL.GetFulFillmentStatusDetails(FulfillmentStatusDetails, CampaignId);
            if (ds != null && ds.Tables.Count > 0 && ds.Tables[1].Rows.Count > 0)
            {
                totalCount = ds.Tables[1].Rows[0].Field<int>("TotalRecords");
            }
            else
                totalCount = 0;

            return ds;
        }
        /*  
            Created on  :   19 Oct 2015
            Created by  :   Manish Pandey
            Discription :   Get Fulfillment Status Details from Database and export quilifier into excel.
            PBI         :   54503
       */
        public static bool UpdateFulFillmentStatusDetails(List<QualifierFulfillment_ImportExcel> FulfillmentStatusDetails, string CampaignId, string Comment, int UserID)
        {
            DataTable FulfillmentStatusDetailsDt = new DataTable();
            FulfillmentStatusDetailsDt = ConvertListIntoDataset(FulfillmentStatusDetails);
            bool ret = PromotionQualifierSQL.UpdateFulFillmentStatusDetails(FulfillmentStatusDetailsDt, CampaignId, Comment, UserID);
            return ret;
        }

        public static DataTable ConvertListIntoDataset(List<QualifierFulfillment_ImportExcel> FulfillmentStatusDetails)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("ContractID", typeof(int));
            dt.Columns.Add("FulfillmentStatusID", typeof(int));
            dt.Columns.Add("UtilityID", typeof(int));

            foreach (QualifierFulfillment_ImportExcel record in FulfillmentStatusDetails)
            {
                dt.Rows.Add(record.ContractID, record.FulfillmentStatusID, record.UtilityID);
            }
            return dt;
        }
        #endregion
        #region Fulfillment Status History
        /*  
            Created on  :   4 Nov 2015
            Created by  :   Manish Pandey
            Discription :   Get Fulfillment Status History.
            PBI         :   84517
       */
        public static DataSet GetFulfillmentStatusHistory(string CampaignId, string ContractId, out int totalCount)
        {
            DataSet ds = new DataSet();
            ds = PromotionQualifierSQL.GetFulfillmentStatusHistory(CampaignId, ContractId);
            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                totalCount = ds.Tables[0].Rows.Count;
            }
            else
                totalCount = 0;

            return ds;
        }
        #endregion
    }


    public class QualifierFulfillment_ImportExcel
    {
        public int? ContractID { get; set; }
        public int? AccountNumberID { get; set; }
        public int? FulfillmentStatusID { get; set; }
        public int? UtilityID { get; set; }

    }
    public class QualifierFulfillment
    {
        public System.String PromoCampaignCode { get; set; }
        public System.String PromotionCode { get; set; }
        public System.String PromotionType { get; set; }
        public System.String SalesChannel { get; set; }
        public System.String SalesRep { get; set; }
        public System.String Market { get; set; }
        public System.String ContractNumber { get; set; }
        public System.String AccountNumber { get; set; }
        public System.String Customer { get; set; }
        public System.String ContactName { get; set; }
        public System.String ContactPhone { get; set; }
        public System.String EmailAddress { get; set; }
        public System.String BillingStreet { get; set; }
        public System.String BillingStreet2 { get; set; }
        public System.String BillingState { get; set; }
        public System.String BillingZip { get; set; }
        public System.DateTime SignDate { get; set; }
        public System.DateTime ContractStartDate { get; set; }
        public System.String AccountStatus { get; set; }
        public System.Int32 DaystoQualify { get; set; }
        public System.DateTime QualifyDate { get; set; }
        public System.String FulfillmentStatus { get; set; }
        public System.String Comments { get; set; }

    }
}
