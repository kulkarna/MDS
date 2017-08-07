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
    using System.ComponentModel.DataAnnotations;
    
    public partial class CapacityThresholdRule
    {
        public long Id { get; set; }
        public System.Guid UtilityCompanyId { get; set; }
        public int CustomerAccountTypeId { get; set; }
        public bool IgnoreCapacityFactor { get; set; }
        [Required]
        public Nullable<int> CapacityThreshold { get; set; }
        public bool Inactive { get; set; }
        public string CreatedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public string LastModifiedBy { get; set; }
        public System.DateTime LastModifiedDate { get; set; }
        [Required]
        public Nullable<int> CapacityThresholdMax { get; set; }
    
        public virtual CustomerAccountType CustomerAccountType { get; set; }
        public virtual UtilityCompany UtilityCompany { get; set; }
    }
}