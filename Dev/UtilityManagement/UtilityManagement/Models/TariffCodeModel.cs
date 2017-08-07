using DataAccessLayerEntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace UtilityManagement.Models
{
    public class TariffCodeModel
    {
        public List<TariffCode> TariffCodeList { get; set; }
        public List<TariffCodeAlia> TariffCodeAliasList { get; set; }
        public List<LpStandardTariffCode> LpStandardTariffCodeList { get; set; }
        public string SelectedUtilityCompanyId { get; set; }
        public List<string> ResultData { get; set; }
    }
}