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
    
    public partial class usp_CapacityThresholdRuleGetByUtilityCode_Result
    {
        public long Id { get; set; }
        public System.Guid UtilityCompanyId { get; set; }
        public string UtilityCode { get; set; }
        public int CustomerAccountTypeId { get; set; }
        public string AccountType { get; set; }
        public bool IgnoreCapacityFactor { get; set; }
        public int CapacityThreshold { get; set; }
        public Nullable<int> CapacityThresholdMax { get; set; }
        public bool Inactive { get; set; }
        public string CreatedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public string LastModifiedBy { get; set; }
        public System.DateTime LastModifiedDate { get; set; }
    }
}
