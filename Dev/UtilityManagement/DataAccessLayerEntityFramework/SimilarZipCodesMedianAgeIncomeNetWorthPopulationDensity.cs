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
    
    public partial class SimilarZipCodesMedianAgeIncomeNetWorthPopulationDensity
    {
        public string ZIP_Codes { get; set; }
        public string C2014_Population_Density { get; set; }
        public string C2014_Median_Age { get; set; }
        public string C2014_Median_Net_Worth { get; set; }
        public string C2014_Median_Household_Income { get; set; }
        public System.Guid Id { get; set; }
        public string ZipCode5 { get; set; }
        public Nullable<System.Guid> ZipCodeId { get; set; }
    
        public virtual ZipCode ZipCode { get; set; }
    }
}
