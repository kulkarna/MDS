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
    
    public partial class usp_UtilityCompany_Detail_Result
    {
        public System.Guid Id { get; set; }
        public int UtilityIdInt { get; set; }
        public string UtilityCode { get; set; }
        public string FullName { get; set; }
        public string ParentCompany { get; set; }
        public string ISO { get; set; }
        public Nullable<System.Guid> IsoId { get; set; }
        public string Market { get; set; }
        public Nullable<System.Guid> MarketId { get; set; }
        public Nullable<int> MarketIdInt { get; set; }
        public string PrimaryDunsNumber { get; set; }
        public string LpEntityId { get; set; }
        public Nullable<System.Guid> UtilityStatusId { get; set; }
        public string UtilityStatus { get; set; }
        public Nullable<int> UtilityStatusIdInt { get; set; }
        public bool Inactive { get; set; }
        public string CreatedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public string LastModifiedBy { get; set; }
        public System.DateTime LastModifiedDate { get; set; }
    }
}