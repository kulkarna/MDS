using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
	public class AccountContractRateQueue : AccountContractRate
	{
		public int AccountContractRateQueueID { get; set; }

		public AcrQueueUpdateStatus Status { get; set; }

		public string StatusNotes { get; set; }

		public DateTime SendDate { get; set; }
	}
}
