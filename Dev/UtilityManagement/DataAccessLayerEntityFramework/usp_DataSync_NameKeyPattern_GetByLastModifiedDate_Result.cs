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
    
    public partial class usp_DataSync_NameKeyPattern_GetByLastModifiedDate_Result
    {
        public System.Guid Id { get; set; }
        public int UtilityId { get; set; }
        public string NameKeyPattern { get; set; }
        public string NameKeyPatternDescription { get; set; }
        public Nullable<int> NameKeyAddLeadingZero { get; set; }
        public Nullable<int> NameKeyTruncateLast { get; set; }
        public bool NameKeyRequiredForEDIRequest { get; set; }
        public bool Inactive { get; set; }
        public string CreatedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public string LastModifiedBy { get; set; }
        public System.DateTime LastModifiedDate { get; set; }
    }
}
