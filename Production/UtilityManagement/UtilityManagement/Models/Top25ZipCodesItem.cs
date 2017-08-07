using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace UtilityManagement.Models
{
    public class Top25ZipCodesItem
    {
        public string Description { get; set; }
        public string ZipCode { get; set; }
        public string NumberOfAccounts { get; set; }
        public string PercentOfTotalAccounts { get; set; }
        public string RunningPercent { get; set; }
        public string DateTime { get; set; }
    }
}