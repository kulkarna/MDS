using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public enum AccountEventType
	{
        DealSubmission = 1,
		RenewalSubmission = 2,
        UsageUpdate = 3,
		Enrollment = 4,
        Rollover = 5,
		RateChange = 6,
        CheckAccountEvent = 7,
		DeEnrollment = 8,
		ContractConversion = 9,
		Commission = 10,
		RateChangeManual = 11,
		UsageUpdateManual = 12,
		ContractMerge = 13,
        SalesRepChange = 19,
		None = 99
    }
}
