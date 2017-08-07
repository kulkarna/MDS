using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace UtilityManagement.Models
{
    public class TopZipCodesActiveRenewedAccountsItem
    {
        public string Description { get; set; }
        public string ZipCode { get; set; }
        public int ResidentialAccountCount { get; set; }
        public int SohoAccountCount { get; set; }
        public int CommercialAccountCount { get; set; }
        public int LciAccountCount { get; set; }
        public int ResidentialAndSohoAccountCount { get; set; }
        public int MassMarketAccountCount { get; set; }
        public int CommercialAndLciAccountCount { get; set; }
        public int TotalAccountCount { get; set; }
        public string DateTime { get; set; }
    }
}