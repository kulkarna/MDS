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
    
    public partial class Market
    {
        public Market()
        {
            this.UtilityCompanies = new HashSet<UtilityCompany>();
            this.UtilityPermissions = new HashSet<UtilityPermission>();
            this.PaymentTerms = new HashSet<PaymentTerm>();
        }
    
        public System.Guid Id { get; set; }
        public string Market1 { get; set; }
        public string Description { get; set; }
        public bool Inactive { get; set; }
        public string CreatedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public string LastModifiedBy { get; set; }
        public System.DateTime LastModifiedDate { get; set; }
        public Nullable<int> MarketIdInt { get; set; }
        public Nullable<System.Guid> IsoId { get; set; }
    
        public virtual ICollection<UtilityCompany> UtilityCompanies { get; set; }
        public virtual ICollection<UtilityPermission> UtilityPermissions { get; set; }
        public virtual ICollection<PaymentTerm> PaymentTerms { get; set; }
    }
}
