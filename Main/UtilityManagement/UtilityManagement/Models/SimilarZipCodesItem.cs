using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace UtilityManagement.Models
{
    public class SimilarZipCodesItem
    {
        public string ZipCode { get; set; }
        public decimal PopulationDensity { get; set; }
        public decimal MedianAge { get; set; }
        public decimal MedianNetWorth { get; set; }
        public decimal MedianHouseholdIncome { get; set; }
        public string Description { get; set; }
        //public int ResidentialAccountCount { get; set; }
        //public int SohoAccountCount { get; set; }
        //public int CommericalAccountCount { get; set; }
        //public int LciAccountCount { get; set; }
        //public int ResidentialAndSohoAccountCount { get; set; }
        //public int MassMarketAccountCount { get; set; }
        //public int CommericalAndLciAccountCount { get; set; }
        //public int TotalAccountCount { get; set; }
    }
}