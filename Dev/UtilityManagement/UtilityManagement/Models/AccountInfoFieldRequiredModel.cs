using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Web;

namespace UtilityManagement.Models
{
    public class AccountInfoFieldRequiredModel
    {
        public Guid UtilityCompanyId { get; set; }
        public string UtilityCode { get; set; }
        public bool Grid { get; set; }
        public bool ICap { get; set; }
        public bool LbmpZone { get; set; }
        public bool LoadProfile { get; set; }
        public bool MeterOwner { get; set; }
        public bool MeterType { get; set; }
        public bool RateClass { get; set; }
        public bool TariffCode { get; set; }
        public bool TCap { get; set; }
        public bool Voltage { get; set; }
        public bool Zone { get; set; }
        public List<string> ResultData { get; set; }

    }
}