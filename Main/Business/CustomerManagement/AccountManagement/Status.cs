namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	[Serializable]
	public class Status
	{
		public Status() { }

		public Status( string status, string statusDesc, string subStatus, string subStatusDesc )
		{
			this.StatusNum = status;
			this.StatusDesc = statusDesc;
			this.SubStatusNum = subStatus;
			this.SubStatusDesc = subStatusDesc;
		}

		public string StatusNum
		{
			get;
			set;
		}

		public string StatusDesc
		{
			get;
			set;
		}

		public string SubStatusNum
		{
			get;
			set;
		}

		public string SubStatusDesc
		{
			get;
			set;
		}

		public string StatusFullDesc
		{
			get
			{
				return String.Format( "{0}-{1} : {2}-{3}", StatusNum, StatusDesc, SubStatusNum, SubStatusDesc );
			}
		}
	}
}
