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
    
    public partial class usp_zAuditRateClass_SELECT_Result
    {
        public System.Guid Id { get; set; }
        public Nullable<System.Guid> IdPrevious { get; set; }
        public Nullable<System.Guid> UtilityCompanyId { get; set; }
        public Nullable<System.Guid> UtilityCompanyIdPrevious { get; set; }
        public string UtilityCode { get; set; }
        public string UtilityCodePrevious { get; set; }
        public string RateClassCode { get; set; }
        public string RateClassCodePrevious { get; set; }
        public string Description { get; set; }
        public string DescriptionPrevious { get; set; }
        public System.Guid AccountTypeId { get; set; }
        public Nullable<System.Guid> AccountTypeIdPrevious { get; set; }
        public string AccountTypeName { get; set; }
        public string AccountTypeNamePrevious { get; set; }
        public string LpStandardRateClass { get; set; }
        public string LpStandardRateClassPrevious { get; set; }
        public bool Inactive { get; set; }
        public Nullable<bool> InactivePrevious { get; set; }
        public string CreatedBy { get; set; }
        public string CreatedByPrevious { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public Nullable<System.DateTime> CreatedDatePrevious { get; set; }
        public string LastModifiedBy { get; set; }
        public string LastModifiedByPrevious { get; set; }
        public System.DateTime LastModifiedDate { get; set; }
        public Nullable<System.DateTime> LastModifiedDatePrevious { get; set; }
        public string SYS_CHANGE_COLUMNS { get; set; }
        public Nullable<long> SYS_CHANGE_CREATION_VERSION { get; set; }
        public string SYS_CHANGE_OPERATION { get; set; }
        public Nullable<long> SYS_CHANGE_VERSION { get; set; }
    }
}
