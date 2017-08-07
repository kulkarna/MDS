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

    [Guid("8D2F6D68-3EFB-4829-9C96-9F12C52F9DEA")]
    public class ValidateCaliforniaUsageFileRule : BusinessRule
    {
        private SdgeUsageAccountCollection sdgeAccounts;
        private SceUsageAccountCollection sceAccounts;
        private PgeUsageAccountCollection pgeAccounts;

        public ValidateCaliforniaUsageFileRule(SdgeUsageAccountCollection sdgeAccounts)
            : base ("ValidateCaliforniaUsageRule", BrokenRuleSeverity.Warning)
        {
            this.sdgeAccounts = sdgeAccounts;
        }
        public ValidateCaliforniaUsageFileRule(SceUsageAccountCollection sceAccounts)
            : base("ValidateCaliforniaUsageRule", BrokenRuleSeverity.Warning)
        {
            this.sceAccounts = sceAccounts;
        }
        public ValidateCaliforniaUsageFileRule(PgeUsageAccountCollection pgeAccounts)
            : base("ValidateCaliforniaUsageRule", BrokenRuleSeverity.Warning)
        {
            this.pgeAccounts = pgeAccounts;
        }

        public override bool Validate()
        {
            if (sdgeAccounts != null && sdgeAccounts.Count  > 0)
            {
                foreach (SdgeUsageAccount acct in sdgeAccounts)
                {
                    SdgeUsageAccountRule rule = new SdgeUsageAccountRule(acct);
                    if (rule.Validate() == false)
                    {
                        if (Exception == null)
                            SetException("Missing fields parsing CA usage file");
                        AddDependentException(rule.Exception);
                    }
                }
            }
            else if (sceAccounts != null && sceAccounts.Count > 0)
            {
                foreach (SceUsageAccount acct in sceAccounts)
                {
                    SceUsageAccountRule rule = new SceUsageAccountRule(acct);
                    if (rule.Validate() == false)
                    {
                        if (Exception == null)
                            SetException("Missing fields parsing CA usage file"); AddDependentException(rule.Exception);
                    }
                }
            }
            else if (pgeAccounts != null && pgeAccounts.Count > 0)
            {
                foreach (PgeUsageAccount acct in pgeAccounts)
                {
                    PgeUsageAccountRule rule = new PgeUsageAccountRule(acct);
                    if (rule.Validate() == false)
                    {
                        if (Exception == null)
                            SetException("Missing fields parsing CA usage file"); AddDependentException(rule.Exception);
                    }
                }
            }
            else
            {
                SetException("No accounts provided");
            }
            
            return Exception == null;
        }

    }
}