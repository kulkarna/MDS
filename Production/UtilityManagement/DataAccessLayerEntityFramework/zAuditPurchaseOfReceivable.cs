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
    
    public partial class zAuditPurchaseOfReceivable
    {
        public System.Guid IdPrimary { get; set; }
        public System.Guid Id { get; set; }
        public System.Guid UtilityCompanyId { get; set; }
        public System.Guid PorDriverId { get; set; }
        public Nullable<System.Guid> RateClassId { get; set; }
        public Nullable<System.Guid> LoadProfileId { get; set; }
        public Nullable<System.Guid> TariffCodeId { get; set; }
        public bool IsPorOffered { get; set; }
        public bool IsPorParticipated { get; set; }
        public System.Guid PorRecourseId { get; set; }
        public bool IsPorAssurance { get; set; }
        public decimal PorDiscountRate { get; set; }
        public decimal PorFlatFee { get; set; }
        public System.DateTime PorDiscountEffectiveDate { get; set; }
        public Nullable<System.DateTime> PorDiscountExpirationDate { get; set; }
        public bool Inactive { get; set; }
        public string CreatedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public string LastModifiedBy { get; set; }
        public System.DateTime LastModifiedDate { get; set; }
        public Nullable<System.Guid> IdPrevious { get; set; }
        public Nullable<System.Guid> UtilityCompanyIdPrevious { get; set; }
        public Nullable<System.Guid> PorDriverIdPrevious { get; set; }
        public Nullable<System.Guid> RateClassIdPrevious { get; set; }
        public Nullable<System.Guid> LoadProfileIdPrevious { get; set; }
        public Nullable<System.Guid> TariffCodeIdPrevious { get; set; }
        public Nullable<bool> IsPorOfferedPrevious { get; set; }
        public Nullable<bool> IsPorParticipatedPrevious { get; set; }
        public Nullable<System.Guid> PorRecourseIdPrevious { get; set; }
        public Nullable<bool> IsPorAssurancePrevious { get; set; }
        public Nullable<decimal> PorDiscountRatePrevious { get; set; }
        public Nullable<decimal> PorFlatFeePrevious { get; set; }
        public Nullable<System.DateTime> PorDiscountEffectiveDatePrevious { get; set; }
        public Nullable<System.DateTime> PorDiscountExpirationDatePrevious { get; set; }
        public Nullable<bool> InactivePrevious { get; set; }
        public string CreatedByPrevious { get; set; }
        public Nullable<System.DateTime> CreatedDatePrevious { get; set; }
        public string LastModifiedByPrevious { get; set; }
        public Nullable<System.DateTime> LastModifiedDatePrevious { get; set; }
        public Nullable<long> SYS_CHANGE_VERSION { get; set; }
        public Nullable<long> SYS_CHANGE_CREATION_VERSION { get; set; }
        public string SYS_CHANGE_OPERATION { get; set; }
        public string SYS_CHANGE_COLUMNS { get; set; }
    }
}
