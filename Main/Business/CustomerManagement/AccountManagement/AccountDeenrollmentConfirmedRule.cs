using System;
using System.Collections.Generic;
using System.Text;
using LibertyPower.Business.CommonBusiness.CommonRules;
using System.Runtime.InteropServices;


namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
    [Guid("98CA04F7-B296-4cb8-ADA2-D0C5B0DF0CC5")]
    class AccountDeenrollmentConfirmedRule : BusinessRule
    {
		private const string EnrollmentSubStatusConfirmed = "50";

        private CompanyAccount companyAccount;

        public AccountDeenrollmentConfirmedRule(CompanyAccount companyAccount)
            : base("Account Deenroll Rule", BrokenRuleSeverity.Error)
        {
            this.companyAccount = companyAccount;
        }

        public override bool Validate()
        {
            bool isValid = false;

			if ( companyAccount.EnrollmentStatus == EnrollmentStatus.GetValue( EnrollmentStatus.Status.PendingDeenrollment ) && companyAccount.EnrollmentSubStatus == EnrollmentSubStatusConfirmed )  
            {
                isValid = true;
            }

            if (!isValid)
            {
                this.SetException("Account has to be in status 1100050-Pending Deenrollment Confirmed.");
            }
            return isValid;
        }

    }
}
