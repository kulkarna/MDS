using System;
using System.Collections.Generic;
using System.Text;
using LibertyPower.Business.CommonBusiness.CommonRules;
using System.Runtime.InteropServices;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{

    [Guid("752613F6-F458-4aa4-B092-423290ABCB78")]
    class AccountPendingReenrollmentRequestRule : BusinessRule
    {
		private const string PendingReenrollmentSubStatusRequest = "60";
		private const string PendingEnrollmentReSubmitSubStatusRequest = "27";
        private CompanyAccount companyAccount;

        public AccountPendingReenrollmentRequestRule(CompanyAccount companyAccount)
            : base("Pending Reenrollment Request Rule", BrokenRuleSeverity.Error)
        {
            this.companyAccount = companyAccount;
        }

        public override bool Validate()
        {
            bool isValid = false;

			if (( companyAccount.EnrollmentStatus == EnrollmentStatus.GetValue( EnrollmentStatus.Status.PendingReenrollment ) && companyAccount.EnrollmentSubStatus == PendingReenrollmentSubStatusRequest ) ||
			   (companyAccount.EnrollmentStatus == EnrollmentStatus.GetValue( EnrollmentStatus.Status.PendingEnrollment ) && companyAccount.EnrollmentSubStatus == PendingEnrollmentReSubmitSubStatusRequest) )
            {
                isValid = true;
            }

            if (!isValid)
            {
				this.SetException( "Account has to be in status 1300060-Pending Reenrollment Request or 0500027-Pending Enrollment Re-submit." );
            }
            return isValid;
        }
    }
}
