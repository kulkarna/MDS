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
    
    public partial class IdrAccountDetail
    {
        public int Id { get; set; }
        public System.DateTime Date { get; set; }
        public string Intervals { get; set; }
    
        public virtual IdrAccountStageInfo IdrAccountStageInfo { get; set; }
    }
}
