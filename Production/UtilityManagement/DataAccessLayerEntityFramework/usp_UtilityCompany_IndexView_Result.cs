//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace DataAccessLayerEntityFramework
{
    using System;
    
    public partial class usp_UtilityCompany_IndexView_Result
    {
        public System.Guid Id { get; set; }
        public int UtilityIdInt { get; set; }
        public string UtilityCode { get; set; }
        public string FullName { get; set; }
        public string ParentCompany { get; set; }
        public string ISO { get; set; }
        public System.Guid IsoId { get; set; }
        public string Market { get; set; }
        public System.Guid MarketId { get; set; }
        public Nullable<int> MarketIdInt { get; set; }
        public string PrimaryDunsNumber { get; set; }
        public string LpEntityId { get; set; }
        public System.Guid UtilityStatusId { get; set; }
        public string UtilityStatus { get; set; }
        public Nullable<int> UtilityStatusIdInt { get; set; }
        public Nullable<int> EnrollmentLeadDays { get; set; }
        public Nullable<int> AccountLength { get; set; }
        public string AccountNumberPrefix { get; set; }
        public Nullable<bool> PorOption { get; set; }
        public Nullable<bool> MeterNumberRequired { get; set; }
        public Nullable<short> MeterNumberLength { get; set; }
        public Nullable<bool> EdiCapable { get; set; }
        public string UtilityPhoneNumber { get; set; }
        public string BillingType { get; set; }
        public bool Inactive { get; set; }
        public string CreatedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public string LastModifiedBy { get; set; }
        public System.DateTime LastModifiedDate { get; set; }
    }
}
