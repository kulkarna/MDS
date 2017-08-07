namespace LibertyPower.Business.MarketManagement.MarketParsing
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using System.Data;
    using System.IO;
    using System.Runtime.InteropServices;

    using LibertyPower.Business.CommonBusiness.CommonExcel;
    using LibertyPower.Business.CommonBusiness.CommonRules;
    using LibertyPower.Business.CommonBusiness.FileManager;
    using LibertyPower.DataAccess.ExcelAccess;

    [Guid("C19FF9D6-DA1B-4bcb-8B7D-E9B051B871FC")]
    public class PgeUsageAccountRule : BusinessRule
    {
        PgeUsageAccount account;

        public PgeUsageAccountRule(PgeUsageAccount account)
            : base("PgeUsageAccountRule", BrokenRuleSeverity.Warning)
        {
            this.account = account;
        }

        public override bool Validate()
        {
            string[] accountFields = new string[]{"AccountNumber", "CurrentRate", "CustomerName", "Energy_service_provider", "MailAddress", "MailCity", "MailPostal",  "MailState", 
                "Mdma", "MeterNumber", "Meter_installer", "Meter_maintainer", "Meter_owner", "ServiceAddress", "ServiceCity", "ServicePostal", "ServiceState", "UsageItems" };

            string[] usageFields = new string[] { "DaysRead", "Demand", "Off_peak_kwh", "On_peak_kwk", "Part_peak_kwh", "PreviousReadDate", "ReadDate", "Usage" };

            foreach (string accountField in accountFields)
            {
                PropertyExistsAndHasValueRule rule1 = new PropertyExistsAndHasValueRule(account, accountField);
                if (rule1.Validate() == false)
                {
                    AddDependentException(rule1.Exception);
                    if (Exception == null)
                    {
                        string error = string.Format("Missing fields in PGE usage file for account at Excel Row: {0}", account.ExcelRow.ToString());
                        SetException(error);
                    }

                }
            }
            if (account.UsageItems != null) //Added for Ticket 16453
            {
                foreach (PgeUsageItem item in account.UsageItems)
                {
                    foreach (string usageField in usageFields)
                    {
                        PropertyExistsAndHasValueRule rule2 = new PropertyExistsAndHasValueRule(item, usageField);
                        if (rule2.Validate() == false)
                        {
                            AddDependentException(rule2.Exception);
                            if (Exception == null)
                            {
                                string error = string.Format("Missing fields in PGE usage file for account at Excel Row: {0}", account.ExcelRow.ToString());
                                SetException(error);
                            }

                        }
                    }
                }
            }
            return Exception == null;
        }
    }
}