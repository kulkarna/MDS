namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	public class StatusTransitionsReasonCode
	{
		public StatusTransitionsReasonCode() { }

		public StatusTransitionsReasonCode(int ID, string reason)
		{
			this.ID = ID;
			this.Reason = reason;
		}

		public int ID
		{
			get;
			set;
		}

		public string Reason
		{
			get;
			set;
		}
	}
}
