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
    using System.Collections.Generic;
    
    public partial class zAuditMeterNumberPattern
    {
        public System.Guid Id { get; set; }
        public System.Guid UtilityCompanyId { get; set; }
        public string MeterNumberPattern { get; set; }
        public string MeterNumberPatternDescription { get; set; }
        public Nullable<int> MeterNumberAddLeadingZero { get; set; }
        public Nullable<int> MeterNumberTruncateLast { get; set; }
        public bool MeterNumberRequiredForEDIRequest { get; set; }
        public bool Inactive { get; set; }
        public string CreatedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public string LastModifiedBy { get; set; }
        public System.DateTime LastModifiedDate { get; set; }
        public Nullable<System.Guid> IdPrevious { get; set; }
        public Nullable<System.Guid> UtilityCompanyIdPrevious { get; set; }
        public string MeterNumberPatternPrevious { get; set; }
        public string MeterNumberPatternDescriptionPrevious { get; set; }
        public Nullable<int> MeterNumberAddLeadingZeroPrevious { get; set; }
        public Nullable<int> MeterNumberTruncateLastPrevious { get; set; }
        public Nullable<bool> MeterNumberRequiredForEDIRequestPrevious { get; set; }
        public Nullable<bool> InactivePrevious { get; set; }
        public string CreatedByPrevious { get; set; }
        public Nullable<System.DateTime> CreatedDatePrevious { get; set; }
        public string LastModifiedByPrevious { get; set; }
        public Nullable<System.DateTime> LastModifiedDatePrevious { get; set; }
        public Nullable<long> SYS_CHANGE_VERSION { get; set; }
        public Nullable<long> SYS_CHANGE_CREATION_VERSION { get; set; }
        public string SYS_CHANGE_OPERATION { get; set; }
        public string SYS_CHANGE_COLUMNS { get; set; }
        public System.Guid IdPrimary { get; set; }
    }
}
