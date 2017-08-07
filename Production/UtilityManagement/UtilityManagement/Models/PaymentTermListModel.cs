using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace UtilityManagement.Models
{
    public class PaymentTermListModel
    {
        #region public variables and constants
        public const string NAMESPACE = "UtilityManagement.Models";
        public const string CLASS = "PaymentTermListModel";

        public string SelectedUtilityCompanyId { get; set; }
        public string UtilityCode { get; set; }
        public System.Guid MarketId { get; set; }
        public string Market { get; set; }
        public System.Guid BusinessAccountTypeId { get; set; }
        public string BusinessAccountType { get; set; }
        public System.Guid BillingTypeId { get; set; }
        public string BillingType { get; set; }
        public string PaymentTerm { get; set; }
        public System.Guid Id { get; set; }
        public bool Inactive { get; set; }
        public string CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public string LastModifiedBy { get; set; }
        public DateTime LastModifiedDate { get; set; }
        #endregion

        #region public constructors
        public PaymentTermListModel()
        { }

        public PaymentTermListModel(DataAccessLayerEntityFramework.PaymentTerm paymentTerm)
        {
            Id = paymentTerm.Id;
            Inactive = paymentTerm.Inactive;
            CreatedBy = paymentTerm.CreatedBy;
            CreatedDate = paymentTerm.CreatedDate;
            LastModifiedBy = paymentTerm.LastModifiedBy;
            LastModifiedDate = paymentTerm.LastModifiedDate;
            UtilityCode = paymentTerm.UtilityCompany.UtilityCode;
            SelectedUtilityCompanyId = paymentTerm.UtilityCompanyId.ToString();
            MarketId = paymentTerm.MarketId;
            Market = paymentTerm.Market.Market1;
            BusinessAccountTypeId = paymentTerm.BusinessAccountTypeId;
            BusinessAccountType = paymentTerm.BusinessAccountType.Description;
            BillingTypeId = paymentTerm.BillingTypeId;
            BillingType = paymentTerm.BillingType.Name;
            PaymentTerm = paymentTerm.PaymentTerm1;
        }
        #endregion
    }
}