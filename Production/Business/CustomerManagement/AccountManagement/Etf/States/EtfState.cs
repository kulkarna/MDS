using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public enum EtfState
	{
		EtfStart = 1,
		ValidAccountStatus = 2,
		ValidCustomerType = 3,
		ValidCustomType = 4,
		EtfCalculating = 5,
		SuccessfulEtfCalculation = 6,
		EtfEstimated = 7,
		EtfPaid = 8,
		PendingInvoice = 9,
		PendingSalesPitchLetter = 10,
		EtfCompleted = 11,
		ProductEligibilityCheck = 12

	}
}
