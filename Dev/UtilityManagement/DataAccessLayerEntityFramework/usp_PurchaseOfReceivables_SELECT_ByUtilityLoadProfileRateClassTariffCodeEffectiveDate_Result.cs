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
    
    public partial class usp_PurchaseOfReceivables_SELECT_ByUtilityLoadProfileRateClassTariffCodeEffectiveDate_Result
    {
        public System.Guid Id { get; set; }
        public System.Guid UtilityCompanyId { get; set; }
        public string UtilityCode { get; set; }
        public System.Guid PorDriverId { get; set; }
        public string PorDriverName { get; set; }
        public string RateClassCode { get; set; }
        public Nullable<int> RateClassId { get; set; }
        public string LoadProfileCode { get; set; }
        public Nullable<int> LoadProfileId { get; set; }
        public string TariffCodeCode { get; set; }
        public Nullable<int> TariffCodeId { get; set; }
        public bool IsPorOffered { get; set; }
        public bool IsPorParticipated { get; set; }
        public System.Guid PorRecourseId { get; set; }
        public string PorRecourseName { get; set; }
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
    }
}
