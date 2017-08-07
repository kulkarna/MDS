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
    
    public partial class usp_IdrRule_Conglomeration_Result
    {
        public System.Guid Id { get; set; }
        public string RateClassCode { get; set; }
        public string LoadProfileCode { get; set; }
        public bool IsOnEligibleCustomerList { get; set; }
        public bool IsHistoricalArchiveAvailable { get; set; }
        public Nullable<int> MinUsageMWh { get; set; }
        public Nullable<int> MaxUsageMWh { get; set; }
        public System.Guid Id1 { get; set; }
        public System.Guid UtilityCompanyId { get; set; }
        public Nullable<System.Guid> RateClassId { get; set; }
        public Nullable<System.Guid> LoadProfileId { get; set; }
        public Nullable<int> MinUsageMWh1 { get; set; }
        public Nullable<int> MaxUsageMWh1 { get; set; }
        public bool IsOnEligibleCustomerList1 { get; set; }
        public bool IsHistoricalArchiveAvailable1 { get; set; }
        public bool Inactive { get; set; }
        public string CreatedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public string LastModifiedBy { get; set; }
        public System.DateTime LastModifiedDate { get; set; }
        public Nullable<System.Guid> RequestModeIdrId { get; set; }
        public Nullable<System.Guid> RequestModeTypeId { get; set; }
        public Nullable<System.Guid> TariffCodeId { get; set; }
        public Nullable<System.Guid> Id2 { get; set; }
        public Nullable<System.Guid> UtilityCompanyId1 { get; set; }
        public string RateClassCode1 { get; set; }
        public string Description { get; set; }
        public Nullable<System.Guid> AccountTypeId { get; set; }
        public Nullable<bool> Inactive1 { get; set; }
        public string CreatedBy1 { get; set; }
        public Nullable<System.DateTime> CreatedDate1 { get; set; }
        public string LastModifiedBy1 { get; set; }
        public Nullable<System.DateTime> LastModifiedDate1 { get; set; }
        public Nullable<int> RateClassId1 { get; set; }
        public Nullable<System.Guid> LpStandardRateClassId { get; set; }
        public Nullable<System.Guid> Id3 { get; set; }
        public Nullable<System.Guid> UtilityCompanyId2 { get; set; }
        public Nullable<System.Guid> LpStandardLoadProfileId { get; set; }
        public string LoadProfileCode1 { get; set; }
        public string Description1 { get; set; }
        public Nullable<System.Guid> AccountTypeId1 { get; set; }
        public Nullable<bool> Inactive2 { get; set; }
        public string CreatedBy2 { get; set; }
        public Nullable<System.DateTime> CreatedDate2 { get; set; }
        public string LastModifiedBy2 { get; set; }
        public Nullable<System.DateTime> LastModifiedDate2 { get; set; }
        public Nullable<int> LoadProfileId1 { get; set; }
        public System.Guid Id4 { get; set; }
        public string UtilityCode { get; set; }
        public bool Inactive3 { get; set; }
        public string CreatedBy3 { get; set; }
        public System.DateTime CreatedDate3 { get; set; }
        public string LastModifiedBy3 { get; set; }
        public System.DateTime LastModifiedDate3 { get; set; }
        public int UtilityIdInt { get; set; }
        public string FullName { get; set; }
        public System.Guid IsoId { get; set; }
        public System.Guid MarketId { get; set; }
        public string PrimaryDunsNumber { get; set; }
        public string LpEntityId { get; set; }
        public string SalesForceId { get; set; }
        public string ParentCompany { get; set; }
        public System.Guid UtilityStatusId { get; set; }
        public Nullable<int> EnrollmentLeadDays { get; set; }
        public Nullable<int> AccountLength { get; set; }
        public string AccountNumberPrefix { get; set; }
        public bool PorOption { get; set; }
        public bool MeterNumberRequired { get; set; }
        public Nullable<short> MeterNumberLength { get; set; }
        public bool EdiCapabale { get; set; }
        public string UtilityPhoneNumber { get; set; }
        public Nullable<System.Guid> BillingTypeId { get; set; }
    }
}
