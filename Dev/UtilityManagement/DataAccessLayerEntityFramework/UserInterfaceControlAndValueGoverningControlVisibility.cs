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
    
    public partial class UserInterfaceControlAndValueGoverningControlVisibility
    {
        public UserInterfaceControlAndValueGoverningControlVisibility()
        {
            this.UserInterfaceControlVisibilities = new HashSet<UserInterfaceControlVisibility>();
        }
    
        public System.Guid Id { get; set; }
        public System.Guid UserInterfaceFormId { get; set; }
        public System.Guid UserInterfaceFormControlGoverningVisibilityId { get; set; }
        public string ControlValueGoverningVisibiltiy { get; set; }
        public bool Inactive { get; set; }
        public string CreatedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public string LastModifiedBy { get; set; }
        public System.DateTime LastModifiedDate { get; set; }
    
        public virtual UserInterfaceForm UserInterfaceForm { get; set; }
        public virtual UserInterfaceFormControl UserInterfaceFormControl { get; set; }
        public virtual ICollection<UserInterfaceControlVisibility> UserInterfaceControlVisibilities { get; set; }
    }
}