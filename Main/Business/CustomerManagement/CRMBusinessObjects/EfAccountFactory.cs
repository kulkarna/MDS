using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BALEntity = LibertyPower.Business.CustomerManagement.CRMBusinessObjects;
using DALEntity = LibertyPower.DataAccess.SqlAccess.CustomerManagementEF;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
    public class EfAccountFactory : IAccountFactory
    {
        public BALEntity.AccountDetail GetAccountDetail( DALEntity.AccountDetail accountDetail )
        {
            BALEntity.AccountDetail ad = new BALEntity.AccountDetail();
            ad.AccountDetailId = accountDetail.AccountDetailID;
            ad.AccountId = accountDetail.AccountID;
            ad.CreatedBy = accountDetail.CreatedBy;
            ad.DateCreated = accountDetail.DateCreated;
            ad.EnrollmentTypeId = accountDetail.EnrollmentTypeID;
            ad.Modified = accountDetail.Modified;
            ad.ModifiedBy = accountDetail.ModifiedBy;
            ad.OriginalTaxDesignation = accountDetail.OriginalTaxDesignation;
            return ad;
        }

        public DALEntity.AccountDetail GetAccountDetail( BALEntity.AccountDetail accountDetail )
        {
            DALEntity.AccountDetail ad = new DALEntity.AccountDetail();
            if( accountDetail.AccountDetailId.HasValue )
                ad.AccountDetailID = accountDetail.AccountDetailId.Value;
            if( accountDetail.AccountId.HasValue )
                ad.AccountID = accountDetail.AccountId.Value;
            ad.CreatedBy = accountDetail.CreatedBy;
            ad.DateCreated = accountDetail.DateCreated;
            ad.EnrollmentTypeID = accountDetail.EnrollmentTypeId;
            ad.Modified = accountDetail.Modified;
            ad.ModifiedBy = accountDetail.ModifiedBy;
            ad.OriginalTaxDesignation = accountDetail.OriginalTaxDesignation;
            return ad;
        }

        public BALEntity.Account GetAccount( DALEntity.Account account )
        {
            BALEntity.Account newAccount = new BALEntity.Account();
            newAccount.AccountId = account.AccountID;
            newAccount.AccountIdLegacy = account.AccountIdLegacy;

            //if( account.AccountNameID.HasValue )
            //{
            //    account.AccountName = DALEntity.CommonDal.GetName( account.AccountNameID.Value );
            //    if( account.AccountName != null )
            //    {
            //        newAccount.AccountName = account.AccountName.full_name;
            //    }
            //}
            if( account.Name != null )
                newAccount.AccountName = account.Name.FullName;

            newAccount.AccountNameId = account.AccountNameID.Value;
            newAccount.AccountNumber = account.AccountNumber;
            if( account.AccountTypeID.HasValue )
                newAccount.AccountTypeId = account.AccountTypeID.Value;

            newAccount.BillingAddressId = account.BillingAddressID;

            newAccount.BillingContactId = account.BillingContactID;

            newAccount.CreatedBy = account.CreatedBy.Value;
            newAccount.CurrentContractId = account.CurrentContractID;
            newAccount.CurrentRenewalContractId = account.CurrentRenewalContractID;
            if( account.CustomerID.HasValue )
                newAccount.CustomerId = account.CustomerID.Value;

            newAccount.CustomerIdLegacy = account.CustomerIdLegacy;
            newAccount.DateCreated = account.DateCreated;
            newAccount.EntityId = account.EntityID;
            newAccount.Icap = account.Icap;
            newAccount.LoadProfile = account.LoadProfile;
            newAccount.LossCode = account.LossCode;
            newAccount.MeterTypeId = account.MeterTypeID;
            newAccount.Modified = account.Modified;
            newAccount.ModifiedBy = account.ModifiedBy.Value;
            newAccount.Origin = account.Origin;

            if( account.PorOption.HasValue )
                newAccount.PorOption = account.PorOption.Value;

            newAccount.RetailMktId = account.RetailMktID.Value;

            newAccount.ServiceAddressId = account.ServiceAddressID.Value;

            newAccount.ServiceRateClass = account.ServiceRateClass;
            newAccount.StratumVariable = account.StratumVariable;

            if( account.TaxStatusID.HasValue )
                newAccount.TaxStatusId = account.TaxStatusID;

            newAccount.Tcap = account.Tcap;

            newAccount.UtilityId = account.UtilityID;
            newAccount.Zone = account.Zone;

            return newAccount;
        }

        public DALEntity.Account GetAccount( BALEntity.Account account )
        {
            DALEntity.Account newAccount = new DALEntity.Account();
            if( account.AccountId.HasValue )
                newAccount.AccountID = account.AccountId.Value;
            newAccount.AccountIdLegacy = account.AccountIdLegacy;
            newAccount.AccountNameID = account.AccountNameId;

            newAccount.AccountNumber = account.AccountNumber;
            newAccount.AccountTypeID = account.AccountTypeId;

            newAccount.BillingTypeID = account.BillingTypeId;

            newAccount.BillingAddressID = account.BillingAddressId;
            newAccount.BillingContactID = account.BillingContactId;
            newAccount.CreatedBy = account.CreatedBy;
            newAccount.CurrentContractID = account.CurrentContractId;
            newAccount.CurrentRenewalContractID = account.CurrentRenewalContractId;
            if( account.CustomerId.HasValue )
                newAccount.CustomerID = account.CustomerId.Value;

            newAccount.CustomerIdLegacy = account.CustomerIdLegacy;
            newAccount.DateCreated = account.DateCreated;
            newAccount.EntityID = account.EntityId;
            newAccount.Icap = account.Icap;
            newAccount.LoadProfile = account.LoadProfile;
            newAccount.LossCode = account.LossCode;
            newAccount.MeterTypeID = account.MeterTypeId;
            newAccount.Modified = account.Modified;
            newAccount.ModifiedBy = account.ModifiedBy;
            newAccount.Origin = account.Origin;

            newAccount.PorOption = account.PorOption;
            newAccount.RetailMktID = account.RetailMktId;

            newAccount.ServiceAddressID = account.ServiceAddressId;
            newAccount.ServiceRateClass = account.ServiceRateClass;
            newAccount.StratumVariable = account.StratumVariable;
            newAccount.TaxStatusID = account.TaxStatusId;
            newAccount.Tcap = account.Tcap;
            newAccount.UtilityID = account.UtilityId;
            newAccount.Zone = account.Zone;
            return newAccount;

        }

        public DALEntity.AccountUsage GetAccountUsage( BALEntity.AccountUsage balUsage )
        {
            DALEntity.AccountUsage dalUsage = new DALEntity.AccountUsage();
            if( balUsage.AccountId.HasValue )
                dalUsage.AccountID = balUsage.AccountId.Value;

            if( balUsage.AccountUsageId.HasValue )
                dalUsage.AccountUsageID = balUsage.AccountUsageId.Value;

            dalUsage.AnnualUsage = balUsage.AnnualUsage;
            dalUsage.CreatedBy = balUsage.CreatedBy;
            dalUsage.DateCreated = balUsage.DateCreated;
            dalUsage.EffectiveDate = balUsage.EffectiveDate;
            dalUsage.Modified = balUsage.Modified;
            dalUsage.ModifiedBy = balUsage.ModifiedBy;
            dalUsage.UsageReqStatusID = balUsage.UsageReqStatusId;
            return dalUsage;
        }

        public BALEntity.AccountUsage GetAccountUsage( DALEntity.AccountUsage dalUsage )
        {
            BALEntity.AccountUsage balUsage = new BALEntity.AccountUsage();
            balUsage.AccountId = dalUsage.AccountID;
            balUsage.AccountUsageId = dalUsage.AccountUsageID;
            balUsage.AnnualUsage = dalUsage.AnnualUsage;
            balUsage.CreatedBy = dalUsage.CreatedBy;
            balUsage.DateCreated = dalUsage.DateCreated;
            balUsage.EffectiveDate = dalUsage.EffectiveDate;
            balUsage.Modified = dalUsage.Modified;
            balUsage.ModifiedBy = dalUsage.ModifiedBy;
            balUsage.UsageReqStatusId = dalUsage.UsageReqStatusID;
            return balUsage;
        }

    }
}
