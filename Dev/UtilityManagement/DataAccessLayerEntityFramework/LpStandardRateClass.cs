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
    
    public partial class LpStandardRateClass
    {
        public LpStandardRateClass()
        {
            this.RateClasses = new HashSet<RateClass>();
        }
    
        public System.Guid Id { get; set; }
        public string LpStandardRateClassCode { get; set; }
        public bool Inactive { get; set; }
        public string CreatedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public string LastModifiedBy { get; set; }
        public System.DateTime LastModifiedDate { get; set; }
        public System.Guid UtilityCompanyId { get; set; }
    
        public virtual ICollection<RateClass> RateClasses { get; set; }
        public virtual UtilityCompany UtilityCompany { get; set; }
    }
}