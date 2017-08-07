using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public enum EtfProcessingAction
	{
		CalculateEstimatedEtf,
		ProcessActualEtf,
		ProcessSalesPitchLetter,
		ProcessSalesPitchLetterManually,
		CancelSalesPitchLetter,
		CreateInvoice,
		SendInvoice,
		CancelInvoice,
        WaiveInvoice,
		PayEtf,
		None
	}
}
