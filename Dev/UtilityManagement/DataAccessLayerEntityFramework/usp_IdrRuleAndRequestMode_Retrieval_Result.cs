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
    
    public partial class usp_IdrRuleAndRequestMode_Retrieval_Result
    {
        public System.Guid Id { get; set; }
        public System.Guid RequestModeTypeId { get; set; }
        public Nullable<System.Guid> RateClassIdGuid { get; set; }
        public Nullable<System.Guid> LoadProfileIdGuid { get; set; }
        public Nullable<int> MinUsageMWh { get; set; }
        public Nullable<int> MaxUsageMWh { get; set; }
        public bool IsOnEligibleCustomerList { get; set; }
        public bool IsHistoricalArchiveAvailable { get; set; }
        public bool Inactive { get; set; }
        public string CreatedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public string LastModifiedBy { get; set; }
        public System.DateTime LastModifiedDate { get; set; }
        public System.Guid UtilityCompanyId { get; set; }
        public string UtilityCode { get; set; }
        public int UtilityIdInt { get; set; }
        public Nullable<int> LoadProfileId { get; set; }
        public string LoadProfileCode { get; set; }
        public string RateClassCode { get; set; }
        public Nullable<int> RateClassId { get; set; }
        public System.Guid RequestModeIdrId { get; set; }
        public System.Guid RequestModeTypeId1 { get; set; }
        public System.Guid RequestModeEnrollmentTypeId { get; set; }
        public string AddressForPreEnrollment { get; set; }
        public string EmailTemplate { get; set; }
        public string Instructions { get; set; }
        public int UtilitysSlaIdrResponseInDays { get; set; }
        public int LibertyPowersSlaFollowUpIdrResponseInDays { get; set; }
        public bool IsLoaRequired { get; set; }
        public decimal RequestCostAccount { get; set; }
    }
}
