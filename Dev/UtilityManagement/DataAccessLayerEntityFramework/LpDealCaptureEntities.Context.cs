﻿//------------------------------------------------------------------------------
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
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    using System.Data.Objects;
    using System.Data.Objects.DataClasses;
    using System.Linq;
    
    public partial class Lp_deal_captureEntities : DbContext
    {
        public Lp_deal_captureEntities()
            : base("name=Lp_deal_captureEntities")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
    
        public virtual ObjectResult<usp_zip_to_zone_lookup_sel_Result> usp_zip_to_zone_lookup_sel(string utility, string zip_code)
        {
            var utilityParameter = utility != null ?
                new ObjectParameter("utility", utility) :
                new ObjectParameter("utility", typeof(string));
    
            var zip_codeParameter = zip_code != null ?
                new ObjectParameter("zip_code", zip_code) :
                new ObjectParameter("zip_code", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<usp_zip_to_zone_lookup_sel_Result>("usp_zip_to_zone_lookup_sel", utilityParameter, zip_codeParameter);
        }
    }
}
