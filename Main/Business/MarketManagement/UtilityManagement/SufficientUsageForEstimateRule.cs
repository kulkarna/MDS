using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;
using LibertyPower.Business.CommonBusiness.CommonRules;

namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
    
    [Guid("C9DFD0C7-B505-44B5-9A31-EC134559ECC9")]
    public class SufficientUsageForEstimateRule : BusinessRule
    {
        private UsageList _meterReads;
        private string _utilityCode;
        private string _accountNumber;
        public Int32 EstimatedAnnualUsage { get; set; }
        
        public SufficientUsageForEstimateRule(string accountNumber, string utilityCode, UsageList meterReads)
            : base ( "Sufficient Meter Reads To Estimate Annual Usage", BrokenRuleSeverity.Information)
        {
            _meterReads = meterReads;
            _utilityCode = utilityCode;
            _accountNumber = accountNumber;
        }

        public override bool Validate()
        {

            
            var totalDays = 0M;
            var totalUsage = 0M;
            foreach (var item in _meterReads)
            {
                //totalDays += item.Days;
                totalUsage += item.TotalKwh;
            }

            totalDays = GetTotalDays(_meterReads);
            
            
            if (totalDays <= 300)
            {
                EstimatedAnnualUsage = 0;
                var message = string.Format("Account {0} ({1}) has no valid profile and less than 300 days of usage.  No estimation of usage is performed.", _accountNumber, _utilityCode);
                SetException(message);
                return false;
            }
            else
            {
                var dailyUsage = totalUsage / totalDays;
                EstimatedAnnualUsage = Convert.ToInt32(totalDays > 300 ? dailyUsage * 365 : 0); 
                return true;
            }
        }

        private Int32 GetTotalDays(UsageList meterReads)
        {
            var days = new List<string>();
            foreach (var item in meterReads)
            {
                for (DateTime d = item.BeginDate; d <= item.EndDate; d = d.AddDays(1))
                {
                    var date = d.ToShortDateString();
                    if (days.Contains(date) == false)
                        days.Add(date);
                }

            }
            return days.Count;

        }
    }
}
