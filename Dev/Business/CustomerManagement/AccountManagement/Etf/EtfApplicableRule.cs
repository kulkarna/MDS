using System;
using System.Collections.Generic;
using System.Text;
using System.Runtime.InteropServices;
using LibertyPower.Business.CommonBusiness.CommonRules;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
    /// <summary>
    /// Rule for determining if ETF should be charged for a given account
    /// </summary>
    [Guid("EBF9B63E-093A-4646-8757-080A68D7749F")]
    public class EtfApplicableRule : BusinessRule
    {
        private CompanyAccount companyAccount;

        public EtfApplicableRule(CompanyAccount companyAccount)
            : base("ETF Applicable Rule", BrokenRuleSeverity.Information)
        {
            this.companyAccount = companyAccount;
        }

        public override bool Validate()
        {
            bool isValid = true;
            string err = "Account will not be charged ETF due to the following reason(s): ";

            if (this.companyAccount.Product.IsCustom)
            {
                err += "Account belongs to a custom Product. ";
                isValid = false;
            }
            if (!this.companyAccount.IsSmbOrResidential)
            {
                err += "Account is an LCI account. ";
                isValid = false;
            }
            if (this.companyAccount.WaiveEtf)
            {
                err += "ETF was waived by Enrollment specialist. ";
                isValid = false;
            }

            if (!isValid)
            {
                this.SetException(err);
            }
            return isValid;
        }

    }
}
