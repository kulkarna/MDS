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
    
    public partial class UserInterfaceForm
    {
        public UserInterfaceForm()
        {
            this.UserInterfaceControlAndValueGoverningControlVisibilities = new HashSet<UserInterfaceControlAndValueGoverningControlVisibility>();
            this.UserInterfaceControlVisibilities = new HashSet<UserInterfaceControlVisibility>();
            this.UserInterfaceFormControls = new HashSet<UserInterfaceFormControl>();
        }
    
        public System.Guid Id { get; set; }
        public string UserInterfaceFormName { get; set; }
        public bool Inactive { get; set; }
        public string CreatedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public string LastModifiedBy { get; set; }
        public System.DateTime LastModifiedDate { get; set; }
    
        public virtual ICollection<UserInterfaceControlAndValueGoverningControlVisibility> UserInterfaceControlAndValueGoverningControlVisibilities { get; set; }
        public virtual ICollection<UserInterfaceControlVisibility> UserInterfaceControlVisibilities { get; set; }
        public virtual ICollection<UserInterfaceFormControl> UserInterfaceFormControls { get; set; }
    }
}
