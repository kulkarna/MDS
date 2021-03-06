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
    
    public partial class AccountType
    {
        public AccountType()
        {
            this.MeterTypes = new HashSet<MeterType>();
            this.RateClasses = new HashSet<RateClass>();
            this.LoadProfiles = new HashSet<LoadProfile>();
            this.TariffCodes = new HashSet<TariffCode>();
            this.BusinessAccountTypes = new HashSet<BusinessAccountType>();
        }
    
        public System.Guid Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public bool Inactive { get; set; }
        public string CreatedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public string LastModifiedBy { get; set; }
        public System.DateTime LastModifiedDate { get; set; }
    
        public virtual ICollection<MeterType> MeterTypes { get; set; }
        public virtual ICollection<RateClass> RateClasses { get; set; }
        public virtual ICollection<LoadProfile> LoadProfiles { get; set; }
        public virtual ICollection<TariffCode> TariffCodes { get; set; }
        public virtual ICollection<BusinessAccountType> BusinessAccountTypes { get; set; }
    }
}
