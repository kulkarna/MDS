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
    
    public partial class RequestModeHistoricalUsageParameter
    {
        public System.Guid Id { get; set; }
        public System.Guid IsBillingAccountNumberRequiredId { get; set; }
        public System.Guid IsZipCodeRequiredId { get; set; }
        public System.Guid IsNameKeyRequiredId { get; set; }
        public System.Guid IsMdmaId { get; set; }
        public System.Guid IsServiceProviderId { get; set; }
        public System.Guid IsMeterInstallerId { get; set; }
        public System.Guid IsMeterReaderId { get; set; }
        public System.Guid IsMeterOwnerId { get; set; }
        public System.Guid IsSchedulingCoordinatorId { get; set; }
        public System.Guid HasReferenceNumberId { get; set; }
        public System.Guid HasCustomerNumberId { get; set; }
        public System.Guid HasPodIdNumberId { get; set; }
        public System.Guid HasMeterTypeId { get; set; }
        public System.Guid IsMeterNumberRequiredId { get; set; }
        public bool Inactive { get; set; }
        public string CreatedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public string LastModifiedBy { get; set; }
        public System.DateTime LastModifiedDate { get; set; }
        public System.Guid UtilityCompanyId { get; set; }
    
        public virtual TriStateValue TriStateValue { get; set; }
        public virtual TriStateValue TriStateValue1 { get; set; }
        public virtual TriStateValue TriStateValue2 { get; set; }
        public virtual TriStateValue TriStateValue3 { get; set; }
        public virtual TriStateValue TriStateValue4 { get; set; }
        public virtual TriStateValue TriStateValue5 { get; set; }
        public virtual TriStateValue TriStateValue6 { get; set; }
        public virtual TriStateValue TriStateValue7 { get; set; }
        public virtual TriStateValue TriStateValue8 { get; set; }
        public virtual TriStateValue TriStateValue9 { get; set; }
        public virtual TriStateValue TriStateValue10 { get; set; }
        public virtual TriStateValue TriStateValue11 { get; set; }
        public virtual TriStateValue TriStateValue12 { get; set; }
        public virtual TriStateValue TriStateValue121 { get; set; }
        public virtual UtilityCompany UtilityCompany { get; set; }
    }
}
