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
    
    public partial class usp_zAuditRequestModeIcap_SELECT_Result
    {
        public System.Guid Id { get; set; }
        public Nullable<System.Guid> IdPrevious { get; set; }
        public Nullable<System.Guid> UtilityCompanyId { get; set; }
        public Nullable<System.Guid> UtilityCompanyIdPrevious { get; set; }
        public string UtilityCode { get; set; }
        public string UtilityCode1 { get; set; }
        public Nullable<System.Guid> RequestModeEnrollmentTypeId { get; set; }
        public Nullable<System.Guid> RequestModeEnrollmentTypeIdPrevious { get; set; }
        public string RequestModeEnrollmentType { get; set; }
        public string RequestModeEnrollmentTypePrevious { get; set; }
        public Nullable<System.Guid> RequestModeTypeId { get; set; }
        public Nullable<System.Guid> RequestModeTypeIdPrevious { get; set; }
        public string RequestModeType { get; set; }
        public string RequestModeTypePrevious { get; set; }
        public string AddressForPreEnrollment { get; set; }
        public string AddressForPreEnrollmentPrevious { get; set; }
        public string EmailTemplate { get; set; }
        public string EmailTemplatePrevious { get; set; }
        public string Instructions { get; set; }
        public string InstructionsPrevious { get; set; }
        public int UtilitysSlaIcapResponseInDays { get; set; }
        public Nullable<int> UtilitysSlaIcapResponseInDaysPrevious { get; set; }
        public int LibertyPowersSlaFollowUpIcapResponseInDays { get; set; }
        public Nullable<int> LibertyPowersSlaFollowUpIcapResponseInDaysPrevious { get; set; }
        public bool IsLoaRequired { get; set; }
        public Nullable<bool> IsLoaRequiredPrevious { get; set; }
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
