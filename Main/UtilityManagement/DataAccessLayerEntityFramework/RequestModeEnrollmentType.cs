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
    
    public partial class RequestModeEnrollmentType
    {
        public RequestModeEnrollmentType()
        {
            this.RequestModeHistoricalUsages = new HashSet<RequestModeHistoricalUsage>();
            this.RequestModeTypeToRequestModeEnrollmentTypes = new HashSet<RequestModeTypeToRequestModeEnrollmentType>();
            this.RequestModeIcaps = new HashSet<RequestModeIcap>();
            this.RequestModeIdrs = new HashSet<RequestModeIdr>();
        }
    
        public System.Guid Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public bool Inactive { get; set; }
        public string CreatedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public string LastModifiedBy { get; set; }
        public System.DateTime LastModifiedDate { get; set; }
        public int EnumValue { get; set; }
    
        public virtual ICollection<RequestModeHistoricalUsage> RequestModeHistoricalUsages { get; set; }
        public virtual ICollection<RequestModeTypeToRequestModeEnrollmentType> RequestModeTypeToRequestModeEnrollmentTypes { get; set; }
        public virtual ICollection<RequestModeIcap> RequestModeIcaps { get; set; }
        public virtual ICollection<RequestModeIdr> RequestModeIdrs { get; set; }
    }
}
