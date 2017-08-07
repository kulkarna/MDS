using System;
using System.Collections.Generic;
using System.Text;
using LibertyPower.Business.CommonBusiness.CommonRules;
using System.Runtime.InteropServices;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
    [Guid("6C7A6E81-88F4-444e-B50D-1871E666C08C")]
    public class AccountDeenrollRule : BusinessRule
    {
        private string accountStatus;
        public string AccountStatus
        {
            get { return this.accountStatus; }
        }

        public AccountDeenrollRule(string accountStatus)
            : base("Account Deenroll Rule", BrokenRuleSeverity.Error)
        {
            this.accountStatus = accountStatus;
        }

        public override bool Validate()
        {
            bool isValid = true;

            if (accountStatus != "905000" && accountStatus != "906000")
            {
                isValid = false;
            }

            if (!isValid)
            {
                this.SetException("Only accounts that are in status 905000-Enrolled or 906000-Enrollment Consolidated can be de-enrolled.");
            }
            return isValid;
        }

    }
}
