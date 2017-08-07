using DataAccessLayerEntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace UtilityManagement.Models
{
    public class RateClassModel
    {
        public List<RateClass> RateClassList { get; set; }
        public List<RateClassAlia> RateClassAliasList { get; set; }
        public List<LpStandardRateClass> LpStandardRateList { get; set; }
        public string SelectedUtilityCompanyId { get; set; }
        public List<string> ResultData { get; set; }
    }
}