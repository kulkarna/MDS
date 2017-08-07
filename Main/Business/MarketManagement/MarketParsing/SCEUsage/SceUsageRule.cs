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

    [Guid("3C220559-EBC9-4c4a-9EBE-08F6A64CA089")]
    public class SceUsageAccountRule : BusinessRule
    {

        SceUsageAccount account;
        public SceUsageAccountRule(SceUsageAccount account)
            : base("SceUsageAccountRule", BrokenRuleSeverity.Warning)
        {
            this.account = account;
        }

        public override bool Validate()
        {
            string[] accountFields = new string[]{"CustomerAccountNumber", "CurrentRate", "CustomerName", "CustomerAddress1A", "CustomerAddress1B", "CustomerAddress1C", 
                "CustomerAddress2A",  "CustomerAddress2B", "CustomerAddress2C", "MeterNumber", "Phase", "ServiceAccountNumber", "Utility", "Voltage" };

            string[] usageFields = new string[] { "Days", "MaximumKw", "ReadDate", "StartDate", "TotalKWh" };

            foreach (string accountField in accountFields)
            {
                PropertyExistsAndHasValueRule rule1 = new PropertyExistsAndHasValueRule(account, accountField);
                if (rule1.Validate() == false)
                {

                    if (Exception == null)
                    {
                        string error = string.Format("Missing fields in SCE usage file for account beginning at Excel Row: {0}", account.ExcelRow.ToString());
                        SetException(error);
                    }
                    AddDependentException(rule1.Exception);
                }
            }

            if (account.UsageItems != null) //Added for Ticket 16453
            {
                foreach (SceUsageItem item in account.UsageItems)
                {
                    foreach (string usageField in usageFields)
                    {
                        PropertyExistsAndHasValueRule rule2 = new PropertyExistsAndHasValueRule(item, usageField);
                        if (rule2.Validate() == false)
                        {

                            if (Exception == null)
                            {
                                string error = string.Format("Missing fields in SCE usage file for account at Excel Row: {0}", account.ExcelRow.ToString());
                                SetException(error);
                            }
                            AddDependentException(rule2.Exception);

                        }
                    }
                }
            }

            return Exception == null; 
        }
    }
}