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

    [Guid("AF2B4952-E3E4-47a1-AF22-77383A96436B")]
    public class SdgeUsageAccountRule : BusinessRule
    {

        SdgeUsageAccount account;
        public SdgeUsageAccountRule(SdgeUsageAccount account)
            : base("SdgeUsageAccountRule", BrokenRuleSeverity.Warning)
        {
            this.account = account;
        }

        public override bool Validate()
        {
            //string[] accountFields = new string[]{"AccountName", "Acct", "Address", "CityStateZip", "CustomerName", "Cycle", 
            //    "Meter",  "MeterMaintainer", "MeterOption", "Rate", "ServiceVoltage"};

            string[] accountFields = new string[]{"AccountName", "Acct", "Address", "CityStateZip", "CustomerName", "Cycle", 
                "Meter",  "MeterMaintainer", "Rate"};


            string[] usageFields = new string[] { "ConsEdDate", "DaysUsed", "MaxKw", "MaxKwNC", "OffKw", "OnKw", "OnKwh", "TotalKwh" };

            foreach (string accountField in accountFields)
            {
                PropertyExistsAndHasValueRule rule1 = new PropertyExistsAndHasValueRule(account, accountField);
                if (rule1.Validate() == false)
                {

                    if (Exception == null)
                    {
                        string error = string.Format("Missing fields in SDGE usage file for account beginning at Excel Row: {0}", account.ExcelRow.ToString());
                        SetException(error);
                    }
                    AddDependentException(rule1.Exception);
                }
            }
            
            if (account.UsageItems != null) //Added for Ticket 16453
            {
                foreach (SdgeUsageItem item in account.UsageItems)
                {
                    foreach (string usageField in usageFields)
                    {
                        PropertyExistsAndHasValueRule rule2 = new PropertyExistsAndHasValueRule(item, usageField);
                        if (rule2.Validate() == false)
                        {
                            if (Exception == null)
                            {
                                string error = string.Format("Missing fields in SDGE usage file for account beginning at Excel Row: {0}", account.ExcelRow.ToString());
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