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
    
    public partial class MeterReadSchedule
    {
        public System.Guid Id { get; set; }
        public System.Guid UtilityCompanyId { get; set; }
        public System.Guid UtilityTripId { get; set; }
        public System.Guid YearId { get; set; }
        public System.Guid MonthId { get; set; }
        public System.DateTime ReadDate { get; set; }
        public bool Inactive { get; set; }
        public string CreatedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public string LastModifiedBy { get; set; }
        public System.DateTime LastModifiedDate { get; set; }
    
        public virtual Month Month { get; set; }
        public virtual UtilityTrip UtilityTrip { get; set; }
        public virtual Year Year { get; set; }
        public virtual UtilityCompany UtilityCompany { get; set; }
    }
}
