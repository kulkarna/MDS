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
    
    public partial class IdrRule
    {
        public System.Guid Id { get; set; }
        public System.Guid UtilityCompanyId { get; set; }
        public Nullable<System.Guid> RateClassId { get; set; }
        public Nullable<System.Guid> LoadProfileId { get; set; }
        public Nullable<int> MinUsageMWh { get; set; }
        public Nullable<int> MaxUsageMWh { get; set; }
        public bool IsOnEligibleCustomerList { get; set; }
        public bool IsHistoricalArchiveAvailable { get; set; }
        public bool Inactive { get; set; }
        public string CreatedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public string LastModifiedBy { get; set; }
        public System.DateTime LastModifiedDate { get; set; }
        public Nullable<System.Guid> RequestModeIdrId { get; set; }
        public Nullable<System.Guid> RequestModeTypeId { get; set; }
        public Nullable<System.Guid> TariffCodeId { get; set; }
    
        public virtual LoadProfile LoadProfile { get; set; }
        public virtual RateClass RateClass { get; set; }
        public virtual RequestModeIdr RequestModeIdr { get; set; }
        public virtual UtilityCompany UtilityCompany { get; set; }
        public virtual LoadProfile LoadProfile1 { get; set; }
        public virtual TariffCode TariffCode { get; set; }
    }
}