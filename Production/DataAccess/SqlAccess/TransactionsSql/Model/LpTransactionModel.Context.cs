﻿//------------------------------------------------------------------------------
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
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    using System.Data.Objects;
    using System.Data.Objects.DataClasses;
    using System.Linq;
    
    public partial class LpTransactionsContainer : DbContext
    {
        public LpTransactionsContainer()
            : base("name=LpTransactionsContainer")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
        public DbSet<IdrFileLogDetail> IdrFileLogDetails { get; set; }
        public DbSet<IdrFileLogHeader> IdrFileLogHeaders { get; set; }
        public DbSet<IdrNonEdiHeader> IdrNonEdiHeaders { get; set; }
        public DbSet<IdrAccountStageInfo> IdrAccountStageInfoes { get; set; }
        public DbSet<Utility> Utilities { get; set; }
        public DbSet<IdrUtilityRawParser> IdrUtilityRawParsers { get; set; }
        public DbSet<IdrFileVsHuDiscrepancy> IdrFileVsHuDiscrepancies { get; set; }
        public DbSet<IdrNonEdiDetail> IdrNonEdiDetails { get; set; }
        public DbSet<IdrAccountDetail> IdrAccountDetails { get; set; }
        public DbSet<DataShift> DataShift { get; set; }
        public DbSet<vw_Holidays_Calendar> vw_Holidays_Calendar { get; set; }
        public DbSet<IdrAccountVsHuDiscrepancy> IdrAccountVsHuDiscrepancies { get; set; }
    
        public virtual ObjectResult<usp_EdiGetAccountAgregatedData_Result> usp_EdiGetAccountAgregatedData(string utilityCode, string accountNumber)
        {
            var utilityCodeParameter = utilityCode != null ?
                new ObjectParameter("UtilityCode", utilityCode) :
                new ObjectParameter("UtilityCode", typeof(string));
    
            var accountNumberParameter = accountNumber != null ?
                new ObjectParameter("AccountNumber", accountNumber) :
                new ObjectParameter("AccountNumber", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<usp_EdiGetAccountAgregatedData_Result>("usp_EdiGetAccountAgregatedData", utilityCodeParameter, accountNumberParameter);
        }
    
        public virtual int usp_DeleteIDRData(string utilityCode, Nullable<int> idrFileLogHeaderId, string userName)
        {
            var utilityCodeParameter = utilityCode != null ?
                new ObjectParameter("UtilityCode", utilityCode) :
                new ObjectParameter("UtilityCode", typeof(string));
    
            var idrFileLogHeaderIdParameter = idrFileLogHeaderId.HasValue ?
                new ObjectParameter("IdrFileLogHeaderId", idrFileLogHeaderId) :
                new ObjectParameter("IdrFileLogHeaderId", typeof(int));
    
            var userNameParameter = userName != null ?
                new ObjectParameter("UserName", userName) :
                new ObjectParameter("UserName", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_DeleteIDRData", utilityCodeParameter, idrFileLogHeaderIdParameter, userNameParameter);
        }
    
        public virtual int usp_DeleteAccountData(string accountNumber, string utilityCode, string userName)
        {
            var accountNumberParameter = accountNumber != null ?
                new ObjectParameter("AccountNumber", accountNumber) :
                new ObjectParameter("AccountNumber", typeof(string));
    
            var utilityCodeParameter = utilityCode != null ?
                new ObjectParameter("UtilityCode", utilityCode) :
                new ObjectParameter("UtilityCode", typeof(string));
    
            var userNameParameter = userName != null ?
                new ObjectParameter("UserName", userName) :
                new ObjectParameter("UserName", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_DeleteAccountData", accountNumberParameter, utilityCodeParameter, userNameParameter);
        }
    
        public virtual ObjectResult<string> usp_GetZoneInformation(string accountNumber, string utilityCode)
        {
            var accountNumberParameter = accountNumber != null ?
                new ObjectParameter("AccountNumber", accountNumber) :
                new ObjectParameter("AccountNumber", typeof(string));
    
            var utilityCodeParameter = utilityCode != null ?
                new ObjectParameter("UtilityCode", utilityCode) :
                new ObjectParameter("UtilityCode", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<string>("usp_GetZoneInformation", accountNumberParameter, utilityCodeParameter);
        }
    }
}
