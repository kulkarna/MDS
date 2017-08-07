using System;
using System.Collections.Generic;
using System.Text;
using LibertyPower.Business.CommonBusiness.CommonRules;
using System.Runtime.InteropServices;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
    [Guid("6C7A6E81-88F4-444e-B50D-1871E666C08C")]
    public class AccountEnrolledRule : BusinessRule
    {
        private CompanyAccount companyAccount;

        public AccountEnrolledRule(CompanyAccount companyAccount)
            : base("Account Deenroll Rule", BrokenRuleSeverity.Error)
        {
            this.companyAccount = companyAccount;
        }

        public override bool Validate()
        {
            bool isValid = true;

            if (companyAccount.EnrollmentStatus != EnrollmentStatus.GetValue(EnrollmentStatus.Status.Enrolled) && companyAccount.EnrollmentStatus != EnrollmentStatus.GetValue(EnrollmentStatus.Status.EnrolledLegacy))
            {
                isValid = false;
            }

            if (!isValid)
            {
                this.SetException("Account has to be in Enrolled status.");
            }
            return isValid;
        }

    }
}
