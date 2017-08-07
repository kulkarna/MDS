using DataAccessLayerEntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace UtilityManagement.Models
{
    public class LoadProfileModel
    {
        public List<LoadProfile> LoadProfileList { get; set; }
        public List<LoadProfileAlia> LoadProfileAliasList { get; set; }
        public List<LpStandardLoadProfile> LpStandardRateList { get; set; }
        public string SelectedUtilityCompanyId { get; set; }
        public List<string> ResultData { get; set; }
    }
}