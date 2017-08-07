using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DALEntity = LibertyPower.DataAccess.SqlAccess.CustomerManagementEF;
using System.Data;
using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;
using PricingBal = LibertyPower.Business.CustomerAcquisition.DailyPricing;
using ProductBal = LibertyPower.Business.CustomerAcquisition.ProductManagement;
using LibertyPower.Business.CommonBusiness.CommonHelper;
using LibertyPower.Business.CustomerAcquisition.SalesChannel;
using LibertyPower.Business.MarketManagement.UtilityManagement;
using System.Globalization;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
    public class ContractFactory
    {
        #region Contract

        public static Contract GetContract(int contractId)
        {
            return GetContract(contractId, false);
        }

        public static Contract GetContract(int contractId, bool loadSubTypes)
        {
            DataSet ds = CRMLibertyPowerSql.GetContract(contractId);

            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                Contract contract = new Contract();
                MapDataRowToContract(ds.Tables[0].Rows[0], contract);

                if (loadSubTypes && contract != null)
                {
                    //Get Account Contracts
                    if (contract.ContractId != null)
                    {
                        contract.AccountContracts = GetAccountContractsByContractId(contract.ContractId.Value);
                        //For each AccountContract get the Account Contract rate Information
                        foreach (AccountContract AccContr in contract.AccountContracts)
                        {
                            //Get Account Contract rates,Account Status,Account Contract Commision
                            if (AccContr.AccountContractId != null)
                            { 
                                AccContr.AccountContractRates = AccountContractRateFactory.GetAccountContractRates(AccContr.AccountContractId.Value);
                                AccContr.AccountStatus = GetAccountStatusByAccountContractId(AccContr.AccountContractId.Value);
                                AccContr.AccountContractCommission = GetAccountContractCommission(AccContr.AccountContractId.Value);
                    }
                            if (AccContr.AccountId != null)
                    {
                                //get Accounts and their corresponding Billing Address,Service Address and Billing Contact
                                AccContr.Account = AccountFactory.GetAccount(AccContr.AccountId.Value);
                                if (AccContr.Account != null)
                                {
                                    if (AccContr.Account.BillingAddressId != null)
                                    {
                                        AccContr.Account.BillingAddress = AddressFactory.GetAddress(AccContr.Account.BillingAddressId.Value);
                    }
                                    if (AccContr.Account.ServiceAddressId != null)
                                    {
                                        AccContr.Account.ServiceAddress = AddressFactory.GetAddress(AccContr.Account.ServiceAddressId.Value);
                                    }
                                    if (AccContr.Account.BillingContactId != null)
                                    {
                                        AccContr.Account.BillingContact = ContactFactory.GetContact(AccContr.Account.BillingContactId.Value);
                                    }

                }
                            }
                        }
                    }

                }

                return contract;
            }

            return null;
        }

      /// <summary>
      /// Get the Contract Object, and its Account related objects from the contract number passed
      /// </summary>
      /// <param name="contractNumber">The contract number </param>
      /// <param name="loadSubTypes"> If account contract objects needs to be loaded or not</param>
      /// <returns></returns>
        public static Contract GetContractByContractNumber(string contractNumber, bool loadSubTypes=false)
        {
            DataSet ds = CRMLibertyPowerSql.GetContractByContractNumber(contractNumber);

            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                Contract contract = new Contract();
                MapDataRowToContract(ds.Tables[0].Rows[0], contract);
                if (loadSubTypes && contract != null)
                {
                    //Get Account Contracts
                    contract.AccountContracts = GetAccountContractsByContractId(contract.ContractId.Value);
                    //For each AccountContract get the Account Contract rate Information
                    foreach (AccountContract AccContr in contract.AccountContracts)
                    {
                        //Get Account Contract rates,Account Status,Account Contract Commision
                        if (AccContr.AccountContractId != null)
                        {
                            AccContr.AccountContractRates = AccountContractRateFactory.GetAccountContractRates(AccContr.AccountContractId.Value);
                            AccContr.AccountStatus = GetAccountStatusByAccountContractId(AccContr.AccountContractId.Value);
                            AccContr.AccountContractCommission = GetAccountContractCommission(AccContr.AccountContractId.Value);
                        }
                        if (AccContr.AccountId != null)
                        {
                            //get Accounts and their corresponding Billing Address,Service Address and Billing Contact
                            AccContr.Account = AccountFactory.GetAccount(AccContr.AccountId.Value);
                            AccContr.Account.Utility = UtilityFactory.GetUtilityById(Convert.ToInt32(AccContr.Account.UtilityId));
                           if (AccContr.Account != null)
                            {
                                if (AccContr.Account.BillingAddressId != null)
                                {
                                    AccContr.Account.BillingAddress = AddressFactory.GetAddress(AccContr.Account.BillingAddressId.Value);
                                }
                                if (AccContr.Account.ServiceAddressId != null)
                                {
                                    AccContr.Account.ServiceAddress = AddressFactory.GetAddress(AccContr.Account.ServiceAddressId.Value);
                                }
                                if (AccContr.Account.BillingContactId != null)
                                {
                                    AccContr.Account.BillingContact = ContactFactory.GetContact(AccContr.Account.BillingContactId.Value);
                                }
                           

                            }
                        }
                    }
		
                }

                return contract;
            }

            return null;
        }

        /// <summary>
        /// Get the COntract object and the related account object for the account number passed
        /// </summary>
        /// <param name="accountNumber"> The account number</param>
        /// <param name="loadSubTypes">need to load the account objects or not</param>
        /// <returns></returns>
        public static Contract GetContractByAccountNumber(string accountNumber, int? utilityId, bool loadSubTypes = false)
        {
            //ProspectManagementBAL.ProspectContractFactory.GetContractNumberfromAccountNumber(txt_curr_contract_nbr.Text);
            // return EFDAL.ContractDal.GetContractNumberfromAccountNumber(ContractNumber);
            string contractNumber;
            contractNumber = DALEntity.ContractDal.GetContractNumberfromAccountNumber(accountNumber, utilityId);
            if (contractNumber != null)
            {          
                DataSet ds = CRMLibertyPowerSql.GetContractByContractNumber(contractNumber);

                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    Contract contract = new Contract();
                    MapDataRowToContract(ds.Tables[0].Rows[0], contract);
                    if (loadSubTypes && contract != null)
                    {
                        //Get Account Contracts for the given account number
                        contract.AccountContracts = GetAccountContractsByContractIdandAccountNumber(contract.ContractId.Value, accountNumber);
                        //For each AccountContract get the Account Contract rate Information
                        foreach (AccountContract AccContr in contract.AccountContracts)
                        {
                            //Get Account Contract rates,Account Status,Account Contract Commision
                            if (AccContr.AccountContractId != null)
                            {
                                AccContr.AccountContractRates = AccountContractRateFactory.GetAccountContractRates(AccContr.AccountContractId.Value);
                                AccContr.AccountStatus = GetAccountStatusByAccountContractId(AccContr.AccountContractId.Value);
                                AccContr.AccountContractCommission = GetAccountContractCommission(AccContr.AccountContractId.Value);
                            }
                            if (AccContr.AccountId != null)
                            {
                                //get Accounts and their corresponding Billing Address,Service Address and Billing Contact
                                AccContr.Account = AccountFactory.GetAccount(AccContr.AccountId.Value);
                                AccContr.Account.Utility = UtilityFactory.GetUtilityById(Convert.ToInt32(AccContr.Account.UtilityId));
                                if (AccContr.Account != null)
                                {
                                    if (AccContr.Account.BillingAddressId != null)
                                    {
                                        AccContr.Account.BillingAddress = AddressFactory.GetAddress(AccContr.Account.BillingAddressId.Value);
                                    }
                                    if (AccContr.Account.ServiceAddressId != null)
                                    {
                                        AccContr.Account.ServiceAddress = AddressFactory.GetAddress(AccContr.Account.ServiceAddressId.Value);
                                    }
                                    if (AccContr.Account.BillingContactId != null)
                                    {
                                        AccContr.Account.BillingContact = ContactFactory.GetContact(AccContr.Account.BillingContactId.Value);
                                    }


                                }
                            }
                        }

                    }

                    return contract;
                }
            }
            return null;
        }

        /// <summary>
        /// Gets the contracts approved on deal screening for a specific sales channel and period
        /// </summary>
        /// <param name="salesChannel"></param>
        /// <param name="dateFrom"></param>
        /// <param name="dateTo"></param>
        /// <returns></returns>
        public static List<Contract> GetEnrollmentApprovedContracts(string salesChannel, DateTime dateFrom, DateTime dateTo)
        {
            List<Contract> contracts = new List<Contract>();

            DataSet ds = CRMLibertyPowerSql.GetEnrollmentApprovedContracts(salesChannel, dateFrom, dateTo);

            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    if (!contracts.Select(s => s.Number).Contains(dr["ContractNumber"].ToString()))
                    {
                        Contract contract = ContractFactory.GetContractByContractNumber(dr["ContractNumber"].ToString(), true);

                        contracts.Add(contract);
                    }
                }
            }

            return contracts;
        }

        /// <summary>
        /// Gets the contracts rejected on deal screening for a specific sales channel and period
        /// </summary>
        /// <param name="salesChannel"></param>
        /// <param name="dateFrom"></param>
        /// <param name="dateTo"></param>
        /// <returns></returns>
        public static List<Contract> GetEnrollmentRejectedContracts(string salesChannel, DateTime dateFrom, DateTime dateTo)
        {
            List<Contract> contracts = new List<Contract>();

            DataSet ds = CRMLibertyPowerSql.GetEnrollmentRejectedContracts(salesChannel, dateFrom, dateTo);

            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    if (!contracts.Select(s => s.Number).Contains(dr["contract_nbr"].ToString()))
                    {
                        Contract contract = ContractFactory.GetContractByContractNumber(dr["contract_nbr"].ToString(), true);

                        contracts.Add(contract);
                    }
                }
            }

            return contracts;
        }

        public static List<ContractCurrentStatus> GetContractsCurrentStatus(int userId, int dayRange)
        {
            DataSet ds = CRMLibertyPowerSql.GetContractsCurrentStatus(userId, dayRange);

            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                List<ContractCurrentStatus> list = new List<ContractCurrentStatus>();

                foreach (DataRow row in ds.Tables[0].Rows)
                {
                    ContractCurrentStatus contractStatus = new ContractCurrentStatus();
                    MapDataRowToContractCurrentStatus(row, contractStatus);
                    list.Add(contractStatus);
                }

                return list;
            }

            return null;
        }

        public static bool InsertContract(Contract contract, out List<GenericError> errors)
        {
            errors = new List<GenericError>();

            if (!contract.IsStructureValidForInsert())
            {
                throw new InvalidOperationException("The structure of the Contract Object is not valid");
            }

            errors = contract.IsValidForInsert();

            if (errors.Count > 0)
            {
                return false;
            }

            if (string.IsNullOrEmpty(contract.Number))
            {
                // get the contract number if is not submitted
                contract.Number = CustomerAcquisition.ProspectManagement.ProspectContractFactory.GenerateContractNumber("");
            }
            else
            {
                //TODO: Consider moving this to a class level method, would need to wrap the DAL into BAL call
                // check if contract number already exists:
                if (ContractFactory.ContractNumberExists(contract.Number))
                {
                    errors.Add(new GenericError() { Code = 1, Message = "Contract Number: " + contract.Number + " is already in the system, cannot submit a contract with the same contract number" });
                    return false;
                }
            }

            if (contract.SalesRep == null)
            {
                contract.SalesRep = "";
            }

			//ClientSubmitApplicationKeyId added on jan 31 2014
            DataSet ds = CRMLibertyPowerSql.InsertContract(contract.Number, contract.ContractTypeId, contract.ContractDealTypeId, contract.ContractStatusId, contract.ContractTemplateId, contract.ReceiptDate, contract.StartDate, contract.EndDate, contract.SignedDate, contract.SubmitDate, contract.SalesChannelId, contract.SalesRep, contract.SalesManagerId, contract.PricingTypeId, contract.EstimatedAnnualUsage, contract.ModifiedBy, contract.CreatedBy,contract.AffinityCode,contract.ClientSubmitApplicationKeyId);

            MapDataRowToContract(ds.Tables[0].Rows[0], contract);

            return true;
        }

        public static bool UpdateContract(Contract contract, out List<GenericError> errors)
        {
            errors = new List<GenericError>();

            if (!contract.IsStructureValidForUpdate())
            {
                throw new InvalidOperationException("The structure of the Contract Object is not valid");
            }

            errors = contract.IsValidForUpdate();

            if (errors.Count > 0)
            {
                return false;
            }

			//ClientSubmitApplicationKeyId added on Jan 31 2014
            DataSet ds = CRMLibertyPowerSql.UpdateContract(contract.ContractId, contract.Number, contract.ContractTypeId, 
                contract.ContractDealTypeId, contract.ContractStatusId, contract.ContractTemplateId, 
                contract.ReceiptDate, contract.StartDate, contract.EndDate, contract.SignedDate, 
                contract.SubmitDate, contract.SalesChannelId, contract.SalesRep, contract.SalesManagerId,
                contract.PricingTypeId, contract.EstimatedAnnualUsage, contract.ModifiedBy,contract.AffinityCode);

            MapDataRowToContract(ds.Tables[0].Rows[0], contract);

            return true;
        }

        public static bool ContractNumberExists(string contractNumber)
        {
            bool result = false;
            Contract contract = GetContractByContractNumber(contractNumber);
            if (contract != null)
            {
                result = true;// it exists
            }
            return result;
        }

        private static void MapDataRowToContract(DataRow dataRow, Contract contract)
        {
            contract.ContractId = dataRow.Field<int?>("ContractID");
            contract.Number = dataRow.Field<string>("Number");
            contract.ContractTypeId = dataRow.Field<int?>("ContractTypeID");
            contract.ContractDealTypeId = dataRow.Field<int?>("ContractDealTypeID");
            contract.ContractStatusId = dataRow.Field<int?>("ContractStatusID");
            contract.ContractTemplateId = dataRow.Field<int?>("ContractTemplateID");
            contract.ReceiptDate = dataRow.Field<DateTime?>("ReceiptDate");
            contract.StartDate = dataRow.Field<DateTime>("StartDate");
            contract.EndDate = dataRow.Field<DateTime>("EndDate");
            contract.SignedDate = dataRow.Field<DateTime>("SignedDate");
            contract.SubmitDate = dataRow.Field<DateTime>("SubmitDate");
            contract.SalesChannelId = dataRow.Field<int?>("SalesChannelID");
            contract.SalesRep = dataRow.Field<string>("SalesRep");
            contract.SalesManagerId = dataRow.Field<int?>("SalesManagerID");
            contract.DateCreated = dataRow.Field<DateTime>("DateCreated");
            contract.PricingTypeId = dataRow.Field<int?>("PricingTypeID");
            contract.DigitalSignature = dataRow.Field<string>("DigitalSignature");
            contract.EstimatedAnnualUsage = dataRow.Field<int?>("EstimatedAnnualUsage");
            contract.Modified = dataRow.Field<DateTime>("Modified");
            contract.ModifiedBy = dataRow.Field<int>("ModifiedBy");
            contract.CreatedBy = dataRow.Field<int>("CreatedBy");
            contract.AffinityCode = dataRow.Field<string>("AffinityCode");
			contract.ClientSubmitApplicationKeyId = dataRow.Field<int?>( "ClientSubmitApplicationKeyId" );
        }
		//Added march 12 2014-PBI: 35278:  Add Sales Channel Renewal validation to ContractAPI
		public static ContractAccountDetails GetCurrentContractforaGivenAccountNumber( string accountNumber )
		{
			ContractAccountDetails currentContract = new ContractAccountDetails();
			DataTable dtContract = new DataTable();
			dtContract = DALEntity.ContractDal.GetCurrentContractAccountInformationforagivenAccountNumber( accountNumber );
			if( dtContract !=null && dtContract.Rows.Count>0)
				MapDataRowToContractAccountDetails( dtContract.Rows[0], currentContract );
			return currentContract;
		}
		//Added march 12 2014-PBI: 35278:  Add Sales Channel Renewal validation to ContractAPI
		private static void MapDataRowToContractAccountDetails( DataRow dataRow, ContractAccountDetails contractAccountInfo )
		{
			contractAccountInfo.ContractID = dataRow.Field<int>( "ContractID" );
			contractAccountInfo.Number = dataRow.Field<string>( "Number" );
			contractAccountInfo.StartDate = dataRow.Field<DateTime>( "StartDate" );
			contractAccountInfo.EndDate = dataRow.Field<DateTime>( "EndDate" );
			contractAccountInfo.SalesChannelId = dataRow.Field<int>( "SalesChannelID" );
			contractAccountInfo.AccountID = dataRow.Field<int>( "AccountID" );
			contractAccountInfo.AccountIdLegacy = dataRow.Field<string>( "AccountIdLegacy" );		
			contractAccountInfo.AccountNumber = dataRow.Field<string>( "AccountNumber" );
			contractAccountInfo.CurrentContractID = dataRow.Field<int>( "CurrentContractID" );
			contractAccountInfo.LegacyProductID = dataRow.Field<string>( "LegacyProductID" );
			contractAccountInfo.IsDefault = dataRow.Field<System.Byte>( "IsDefault" );
		}

        private static void MapDataRowToContractCurrentStatus(DataRow dataRow, ContractCurrentStatus contractStatus)
        {
            contractStatus.ContractNumber = dataRow.Field<string>("ContractNumber");
            contractStatus.SignedDate = dataRow.Field<DateTime?>("SignedDate");
            contractStatus.CustomerName = dataRow.Field<string>("CustomerName");
            contractStatus.Status = dataRow.Field<string>("Status");
            contractStatus.ContractType = dataRow.Field<string>("Type");
            contractStatus.Notes = dataRow.Field<string>("Notes");
        }

        #endregion

        #region Account Contract

        public static AccountContract GetAccountContract(int accountContractId)
        {
            DataSet ds = CRMLibertyPowerSql.GetAccountContract(accountContractId);

            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                AccountContract accountContract = new AccountContract();
                MapDataRowToAccountContract(ds.Tables[0].Rows[0], accountContract);
                return accountContract;
            }

            return null;
        }

        //Added to get the list of Account Contracts for a give ContractID
        public static List<AccountContract> GetAccountContractsByContractId(int contractId)
        {
            DataSet ds = CRMLibertyPowerSql.GetAccountContractByContractId(contractId);

            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                List<AccountContract> AccountContractList= new List<AccountContract>();

                foreach (DataRow row in ds.Tables[0].Rows)
                {
                    AccountContract accountContract = new AccountContract();
                    MapDataRowToAccountContract(row, accountContract);
                    AccountContractList.Add(accountContract);
                }
                return AccountContractList;
            }

            return null;
        }

        //GetAccountContractByContractIdandAccountNumber
        //Added to get the list of Account Contracts for a given ContractID and AccountNumber
        public static List<AccountContract> GetAccountContractsByContractIdandAccountNumber(int contractId, string accountNumber)
        {
            DataSet ds = CRMLibertyPowerSql.GetAccountContractByContractIdandAccountNumber(contractId, accountNumber);

            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                List<AccountContract> AccountContractList = new List<AccountContract>();

                foreach (DataRow row in ds.Tables[0].Rows)
                {
                    AccountContract accountContract = new AccountContract();
                    MapDataRowToAccountContract(row, accountContract);
                    AccountContractList.Add(accountContract);
                }
                return AccountContractList;
            }

            return null;
        }

        public static bool InsertAccountContract(AccountContract accountContract, out List<GenericError> errors)
        {
            errors = new List<GenericError>();

            #region Validation

            if (!accountContract.IsStructureValidForInsert())
            {
                throw new InvalidOperationException("The structure of the Account Contract Object is not valid for Insert");
            }

            if (!accountContract.AccountStatus.IsStructureValidForInsert())
            {
                throw new InvalidOperationException("The structure of the AccountStatus Object is not valid for Insert");
            }

            if (!accountContract.AccountContractCommission.IsStructureValidForInsert())
            {
                throw new InvalidOperationException("The structure of the AccountContractCommission Object is not valid for Insert");
            }

            foreach (var item in accountContract.AccountContractRates)
            {
                if (!item.IsStructureValidForInsert())
                {
                    throw new InvalidOperationException("The structure of the AccountContractRate Object is not valid for Insert");
                }
            }

            errors = accountContract.IsValidForInsert();
            errors.AddRange(accountContract.AccountContractCommission.IsValidForInsert());
            errors.AddRange(accountContract.AccountStatus.IsValidForInsert());

            foreach (var item in accountContract.AccountContractRates)
            {
                errors.AddRange(item.IsValidForInsert());
            }

            if (errors.Count > 0)
            {
                return false;
            }

            #endregion Validation

            using (System.Transactions.TransactionScope transactionScope = new System.Transactions.TransactionScope(System.Transactions.TransactionScopeOption.Required, CRMBaseFactory.GetStandardTransactionOptions(1)))
            {
                // Insert Account Contract
                DataSet accountContractDataSet = CRMLibertyPowerSql.InsertAccountContract(accountContract.AccountId, accountContract.ContractId, accountContract.RequestedStartDate, accountContract.SendEnrollmentDate, accountContract.ModifiedBy, accountContract.CreatedBy);
                MapDataRowToAccountContract(accountContractDataSet.Tables[0].Rows[0], accountContract);

                accountContract.AccountContractCommission.AccountContractId = accountContract.AccountContractId;
                accountContract.AccountStatus.AccountContractId = accountContract.AccountContractId;

                // Insert Commission records
                InsertAccountContractCommission(accountContract.AccountContractCommission, out errors);

                // Insert accountrate records:
                foreach (AccountContractRate accountContractRate in accountContract.AccountContractRates)
                {
                    accountContractRate.AccountContractId = accountContract.AccountContractId;
                    AccountContractRateFactory.InsertAccountContractRate(accountContractRate, out errors);
                }

                // Insert Status records
                InsertAccountStatus(accountContract.AccountStatus, out errors);

                if (errors.Count > 0)
                {
                    transactionScope.Dispose();
                    return false;
                }
                else
                {
                    transactionScope.Complete();
                }


            }

            return true;
        }

        public static bool UpdateLccInfo(string contractNumber, string accountNumber, decimal lccCapacityFactor, out List<GenericError> errors)
        {
            errors = new List<GenericError>();

            Contract contract = GetContractByContractNumber(contractNumber);
            if (contract == null )
            {
                errors.Add(new GenericError() { Code = 0, Message = "Contract not found." });
                return false;
            }

            List<AccountContract> listAccountContract = GetAccountContractsByContractIdandAccountNumber((int)contract.ContractId, accountNumber);
            if (listAccountContract == null || listAccountContract.Count == 0)
            {
                errors.Add(new GenericError() { Code = 0, Message = "Account not found." });
                return false;
            }
            AccountContract accountContract = listAccountContract.FirstOrDefault();
            accountContract.LccCapacityFactor = lccCapacityFactor;

            List<GenericError> errors2 = new List<GenericError>();
            bool flagReturn = UpdateAccountContract(accountContract, out errors2);

            foreach(GenericError err in errors2)
            {
                errors.Add(err);
            }
            return flagReturn;
        }

        public static bool UpdateAccountContract(AccountContract accountContract, out List<GenericError> errors)
        {
            errors = new List<GenericError>();

            if (!accountContract.IsStructureValidForUpdate())
            {
                throw new InvalidOperationException("The structure of the AccountContract Object is not valid");
            }

            errors = accountContract.IsValidForUpdate();

            if (errors.Count > 0)
            {
                return false;
            }

            DataSet ds = CRMLibertyPowerSql.UpdateAccountContract(accountContract.AccountContractId, accountContract.AccountId, accountContract.ContractId, accountContract.RequestedStartDate, accountContract.SendEnrollmentDate, accountContract.ModifiedBy, accountContract.LccCapacityFactor);

            MapDataRowToAccountContract(ds.Tables[0].Rows[0], accountContract);

            return true;
        }

        private static void MapDataRowToAccountContract(DataRow dataRow, AccountContract accountContract)
        {
            accountContract.AccountContractId = dataRow.Field<int>("AccountContractID");
            accountContract.AccountId = dataRow.Field<int?>("AccountID");
            accountContract.ContractId = dataRow.Field<int>("ContractID");
            accountContract.RequestedStartDate = dataRow.Field<DateTime?>("RequestedStartDate");
            accountContract.SendEnrollmentDate = dataRow.Field<DateTime?>("SendEnrollmentDate");
            accountContract.Modified = dataRow.Field<DateTime>("Modified");
            accountContract.ModifiedBy = dataRow.Field<int>("ModifiedBy");
            accountContract.DateCreated = dataRow.Field<DateTime>("DateCreated");
            accountContract.CreatedBy = dataRow.Field<int>("CreatedBy");
        }

        #endregion

        #region Account Contract Commission

        public static AccountContractCommission GetAccountContractCommission(int accountContractId)
        {
            DataSet ds = CRMLibertyPowerSql.GetAccountContractCommission(accountContractId);

            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                AccountContractCommission accountContract = new AccountContractCommission();
                MapDataRowToAccountContractCommission(ds.Tables[0].Rows[0], accountContract);
                return accountContract;
            }

            return null;
        }

        public static bool UpdateAccountContractCommission(AccountContractCommission accountContractCommission, out List<GenericError> errors)
        {
            errors = new List<GenericError>();

            if (!accountContractCommission.IsStructureValidForUpdate())
            {
                throw new InvalidOperationException("The structure of the AccountContractCommission Object is not valid");
            }

            errors = accountContractCommission.IsValidForUpdate();

            if (errors.Count > 0)
            {
                return false;
            }

            DataSet ds = CRMLibertyPowerSql.UpdateAccountContractCommission(accountContractCommission.AccountContractCommissionId, accountContractCommission.AccountContractId, accountContractCommission.EvergreenOptionId, accountContractCommission.EvergreenCommissionEnd, accountContractCommission.EvergreenCommissionRate, accountContractCommission.ResidualOptionId, accountContractCommission.ResidualCommissionEnd, accountContractCommission.InitialPymtOptionId, accountContractCommission.ModifiedBy);

            MapDataRowToAccountContractCommission(ds.Tables[0].Rows[0], accountContractCommission);

            return true;
        }

        public static bool InsertAccountContractCommission(AccountContractCommission accountContractCommission, out List<GenericError> errors)
        {
            errors = new List<GenericError>();

            if (!accountContractCommission.IsStructureValidForInsert())
            {
                throw new InvalidOperationException("The structure of the AccountContractCommission Object is not valid");
            }

            errors = accountContractCommission.IsValidForInsert();

            if (errors.Count > 0)
            {
                return false;
            }

            DataSet ds = CRMLibertyPowerSql.InsertAccountContractCommission(accountContractCommission.AccountContractId, accountContractCommission.EvergreenOptionId, accountContractCommission.EvergreenCommissionEnd, accountContractCommission.EvergreenCommissionRate, accountContractCommission.ResidualOptionId, accountContractCommission.ResidualCommissionEnd, accountContractCommission.InitialPymtOptionId, accountContractCommission.ModifiedBy, accountContractCommission.CreatedBy);

            MapDataRowToAccountContractCommission(ds.Tables[0].Rows[0], accountContractCommission);

            return true;
        }

        private static void MapDataRowToAccountContractCommission(DataRow dataRow, AccountContractCommission accountContractCommission)
        {
            accountContractCommission.AccountContractCommissionId = dataRow.Field<int?>("AccountContractCommissionID");
            accountContractCommission.AccountContractId = dataRow.Field<int?>("AccountContractID");
            accountContractCommission.EvergreenOptionId = dataRow.Field<int?>("EvergreenOptionID");
            accountContractCommission.EvergreenCommissionEnd = dataRow.Field<DateTime?>("EvergreenCommissionEnd");
            accountContractCommission.EvergreenCommissionRate = dataRow.Field<Double?>("EvergreenCommissionRate");
            accountContractCommission.ResidualOptionId = dataRow.Field<int?>("ResidualOptionID");
            accountContractCommission.ResidualCommissionEnd = dataRow.Field<DateTime?>("ResidualCommissionEnd");
            accountContractCommission.InitialPymtOptionId = dataRow.Field<int?>("InitialPymtOptionID");
            accountContractCommission.Modified = dataRow.Field<DateTime>("Modified");
            accountContractCommission.ModifiedBy = dataRow.Field<int>("ModifiedBy");
            accountContractCommission.DateCreated = dataRow.Field<DateTime>("DateCreated");
            accountContractCommission.CreatedBy = dataRow.Field<int>("CreatedBy");
        }

        #endregion

        #region Account Status

        public static AccountStatus GetAccountStatus(int accountStatusId)
        {
            DataSet ds = CRMLibertyPowerSql.GetAccountStatus(accountStatusId);

            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                AccountStatus accountStatus = new AccountStatus();
                MapDataRowToAccountStatus(ds.Tables[0].Rows[0], accountStatus);
                return accountStatus;
            }

            return null;
        }
        //Added to get Account Status by AccountContractId
        public static AccountStatus GetAccountStatusByAccountContractId(int accountContractId)
        {
            DataSet ds = CRMLibertyPowerSql.GetAccountStatusByAccountContractId(accountContractId);

            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                AccountStatus accountStatus = new AccountStatus();
                MapDataRowToAccountStatus(ds.Tables[0].Rows[0], accountStatus);
                return accountStatus;
            }

            return null;
        }

        public static bool InsertAccountStatus(AccountStatus accountStatus, out List<GenericError> errors)
        {
            errors = new List<GenericError>();

            if (!accountStatus.IsStructureValidForInsert())
            {
                throw new InvalidOperationException("The structure of the AccountStatus Object is not valid");
            }

            errors = accountStatus.IsValidForInsert();

            if (errors.Count > 0)
            {
                return false;
            }

            DataSet ds = CRMLibertyPowerSql.InsertAccountStatus(accountStatus.AccountContractId, accountStatus.Status, accountStatus.SubStatus, accountStatus.ModifiedBy, accountStatus.CreatedBy);

            MapDataRowToAccountStatus(ds.Tables[0].Rows[0], accountStatus);

            return true;
        }

        public static bool UpdateAccountStatus(AccountStatus accountStatus, out List<GenericError> errors)
        {
            errors = new List<GenericError>();

            if (!accountStatus.IsStructureValidForUpdate())
            {
                throw new InvalidOperationException("The structure of the AccountStatus Object is not valid");
            }

            errors = accountStatus.IsValidForUpdate();

            if (errors.Count > 0)
            {
                return false;
            }

            DataSet ds = CRMLibertyPowerSql.UpdateAccountStatus(accountStatus.AccountStatusId, accountStatus.AccountContractId, accountStatus.Status, accountStatus.SubStatus, accountStatus.ModifiedBy);

            MapDataRowToAccountStatus(ds.Tables[0].Rows[0], accountStatus);

            return true;
        }

        private static void MapDataRowToAccountStatus(DataRow dataRow, AccountStatus accountStatus)
        {
            accountStatus.AccountStatusId = dataRow.Field<int?>("AccountStatusID");
            accountStatus.AccountContractId = dataRow.Field<int?>("AccountContractID");
            accountStatus.Status = dataRow.Field<String>("Status");
            accountStatus.SubStatus = dataRow.Field<String>("SubStatus");
            accountStatus.Modified = dataRow.Field<DateTime>("Modified");
            accountStatus.ModifiedBy = dataRow.Field<int>("ModifiedBy");
            accountStatus.DateCreated = dataRow.Field<DateTime>("DateCreated");
            accountStatus.CreatedBy = dataRow.Field<int>("CreatedBy");
        }

        #endregion

        #region Helper Functions

        public static string GetProductIdForResidential(string utilityCode)
        {
            return LibertyPower.DataAccess.SqlAccess.CustomerManagementEF.AccountDal.GetProductIdForResidential(utilityCode);
        }

        public static void UpdateContractVersion(string contractNumber, int templateVersionId)
        {
            LibertyPower.DataAccess.SqlAccess.DocumentsSql.DocumentsSql.UpdateContractVersion(contractNumber, templateVersionId);
        }

        public static void UpdateAccountLanguagePreference(string contractNumber, int templateVersionId)
        {
            LibertyPower.DataAccess.SqlAccess.AccountSql.DealCaptureSql.UpdateAccountLanguagePreference(contractNumber, templateVersionId);
        }

        #endregion Helper Functions

    }

	//Added march 12 2014-PBI: 35278:  Add Sales Channel Renewal validation to ContractAPI
	public class ContractAccountDetails
	{

		public System.Int32 ContractID { get; set; }
		public System.String Number { get; set; }
		public System.DateTime StartDate { get; set; }
		public System.DateTime EndDate { get; set; }
		public System.Int32 SalesChannelId { get; set; }
		public System.Int32 AccountID { get; set; }
		public System.String AccountIdLegacy { get; set; }
		public System.String AccountNumber { get; set; }
		public System.Int32 CurrentContractID { get; set; }
		public System.String LegacyProductID { get; set; }
		public System.Byte IsDefault { get; set; }

	}
}
