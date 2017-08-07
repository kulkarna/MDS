using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace UtilityManagement.Models
{
    public class ZipCodesWithSimilarDemographicDataItem
    {
        public string ZipCode { get; set; }
        public string CityState { get; set; }
        public string MedianAge { get; set; }
        public string MedianIncome { get; set; }
        public string MedianNetWorth { get; set; }
    }
}