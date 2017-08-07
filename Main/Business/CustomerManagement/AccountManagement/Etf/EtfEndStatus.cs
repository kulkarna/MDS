using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public enum EtfEndStatus
	{
		IncorrectAccountStatus = 1,
		InvalidCustomerType = 2,
		IneligibleCustomProduct = 3,
		IneligibleProduct = 12,
		EtfWaived = 4,
		FailedEtfCalculation = 5,
		CompletedSalesPitchLetter = 6,
		CancelledSalesPitchLetter = 7,
		NoEtfActionRequired = 8,
		CompletedEtfInvoice = 9,
		CancelledEtfInvoice = 10,
		AccountRefundEligible = 11,
		Undefined = 0

	}
}
