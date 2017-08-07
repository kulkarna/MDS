using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace UtilityManagement.Models
{
    public class DemographicDataByZipCodeItem
    {
        public string ZipCode { get; set; }
        public string Segment1 { get; set; }
        public string Segment1Percent { get; set; }
        public string Segment1Count { get; set; }
        public string Segment2 { get; set; }
        public string Segment2Percent { get; set; }
        public string Segment2Count { get; set; }
        public string Segment3 { get; set; }
        public string Segment3Percent { get; set; }
        public string Segment3Count { get; set; }
        public string CustomerCountInZipCode { get; set; }
        public string Date { get; set; }
    }
}