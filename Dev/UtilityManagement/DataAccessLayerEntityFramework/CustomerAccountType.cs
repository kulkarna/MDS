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
    
    public partial class CustomerAccountType
    {
        public CustomerAccountType()
        {
            this.CapacityThresholdRules = new HashSet<CapacityThresholdRule>();
        }
    
        public int ID { get; set; }
        public string AccountType { get; set; }
        public string Description { get; set; }
        public string AccountGroup { get; set; }
        public Nullable<int> ProductAccountTypeId { get; set; }
        public bool Inactive { get; set; }
        public string CreatedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public string LastModifiedBy { get; set; }
        public System.DateTime LastModifiedDate { get; set; }
    
        public virtual ICollection<CapacityThresholdRule> CapacityThresholdRules { get; set; }
    }
}
