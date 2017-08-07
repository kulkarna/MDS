//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace LibertyPower.DataAccess.SqlAccess.TransactionsSql.Model
{
    using System;
    using System.Collections.Generic;
    
    public partial class IdrNonEdiHeader
    {
        public IdrNonEdiHeader()
        {
            this.IdrNonEdiDetails = new HashSet<IdrNonEdiDetail>();
        }
    
        public int ID { get; set; }
        public string UtilityCode { get; set; }
        public string AccountNumber { get; set; }
        public string MeterNumber { get; set; }
        public string RecorderNumber { get; set; }
        public short UsageSource { get; set; }
        public short UsageType { get; set; }
        public Nullable<decimal> AverageDifference { get; set; }
        public Nullable<short> Intervals { get; set; }
        public string OriginalUnit { get; set; }
        public string CreatedBy { get; set; }
        public System.DateTime TimeStamp { get; set; }
    
        public virtual ICollection<IdrNonEdiDetail> IdrNonEdiDetails { get; set; }
    }
}
