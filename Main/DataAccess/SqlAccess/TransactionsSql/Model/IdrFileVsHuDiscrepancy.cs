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
    
    public partial class IdrFileVsHuDiscrepancy
    {
        public long ID { get; set; }
        public System.DateTime FromDate { get; set; }
        public System.DateTime ToDate { get; set; }
        public int HUKwh { get; set; }
        public Nullable<decimal> IDRKwh { get; set; }
        public Nullable<decimal> Difference { get; set; }
        public Nullable<System.DateTime> Created { get; set; }
        public Nullable<System.DateTime> EffectiveToDate { get; set; }
    
        public virtual IdrFileLogDetail IdrFileLogDetail { get; set; }
    }
}
