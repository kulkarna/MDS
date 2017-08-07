using System;
using System.Collections.Generic;
using System.Text;
using LibertyPower.Business.CommonBusiness.CommonRules;
using System.Runtime.InteropServices;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{

    [Guid("8ADD4F3C-815D-408e-B363-1DAEC336CB7C")]
    class AccountPendingEnrollmentRequestRule : BusinessRule
    {
        private CompanyAccount companyAccount;
        private const string PendingEnrollmentSubStatusRequest = "10";

        public AccountPendingEnrollmentRequestRule(CompanyAccount companyAccount)
            : base("Pending Enrollment Request Rule", BrokenRuleSeverity.Error)
        {
            this.companyAccount = companyAccount;
        }

        public override bool Validate()
        {
            bool isValid = false;

            if (((companyAccount.EnrollmentStatus.Trim() == EnrollmentStatus.GetValue(EnrollmentStatus.Status.PendingEnrollment)) || (companyAccount.EnrollmentStatus.Trim() == EnrollmentStatus.GetValue(EnrollmentStatus.Status.PendingEnrollmentLegacy))) && companyAccount.EnrollmentSubStatus.Trim() == PendingEnrollmentSubStatusRequest)
            {
                isValid = true;
            }

            if (!isValid)
            {
                this.SetException("Account has to be in status 0500010-Pending Enrollment Create Utility File.");
            }
            return isValid;
        }
    }
}
