using System;
using System.Collections.Generic;
using System.Text;
using LibertyPower.Business.CommonBusiness.CommonRules;
using System.Runtime.InteropServices;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
    [Guid("E7BA29F5-81AB-4bca-9E53-98639CF776EE")]
    class AccountPendingDeenrollmentRequestRule : BusinessRule
    {
        private CompanyAccount companyAccount;
		private const string EnrollmentSubStatusRequest = "30";
        private const string EnrollmentSubStatusReadyToSend = "10";

        public AccountPendingDeenrollmentRequestRule(CompanyAccount companyAccount)
            : base("Pending Deenrollment Request Rule", BrokenRuleSeverity.Error)
        {
            this.companyAccount = companyAccount;
        }

        public override bool Validate()
        {
            bool isValid = false;

			if ( (companyAccount.EnrollmentStatus == EnrollmentStatus.GetValue( EnrollmentStatus.Status.PendingDeenrollment ) && companyAccount.EnrollmentSubStatus == EnrollmentSubStatusRequest) ||
                 (companyAccount.EnrollmentStatus == EnrollmentStatus.GetValue(EnrollmentStatus.Status.EnrollmentCancellation) && companyAccount.EnrollmentSubStatus == EnrollmentSubStatusReadyToSend))  
            {
                isValid = true;
            }

            if (!isValid)
            {
                this.SetException("Account has to be in status Pending Deenrollment - Request or Enrollment Cancellation - Ready To Send.");
            }
            return isValid;
        }
    }
}
