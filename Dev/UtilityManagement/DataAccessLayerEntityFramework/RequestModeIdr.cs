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
    
    public partial class RequestModeIdr
    {
        public RequestModeIdr()
        {
            this.IdrRules = new HashSet<IdrRule>();
        }
    
        public System.Guid Id { get; set; }
        public System.Guid UtilityCompanyId { get; set; }
        public System.Guid RequestModeEnrollmentTypeId { get; set; }
        public System.Guid RequestModeTypeId { get; set; }
        public string AddressForPreEnrollment { get; set; }
        public string EmailTemplate { get; set; }
        public string Instructions { get; set; }
        public int UtilitysSlaIdrResponseInDays { get; set; }
        public int LibertyPowersSlaFollowUpIdrResponseInDays { get; set; }
        public bool IsLoaRequired { get; set; }
        public decimal RequestCostAccount { get; set; }
        public bool Inactive { get; set; }
        public string CreatedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public string LastModifiedBy { get; set; }
        public System.DateTime LastModifiedDate { get; set; }
        public Nullable<bool> AlwaysRequest { get; set; }
    
        public virtual RequestModeEnrollmentType RequestModeEnrollmentType { get; set; }
        public virtual RequestModeType RequestModeType { get; set; }
        public virtual UtilityCompany UtilityCompany { get; set; }
        public virtual ICollection<IdrRule> IdrRules { get; set; }
    }
}
