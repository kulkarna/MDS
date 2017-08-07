namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	[Serializable]
	public class StatusTransition
	{
		public StatusTransition() { }

		public StatusTransition( int ID, string oldStatus, string oldSubStatus, string newStatus, string newSubStatus,
			string newStatusDescription, string newSubStatusDescription, bool requiresStartDate, bool requiresEndDate, DateTime dateCreated )
		{
			this.ID = ID;
			this.OldStatus = oldStatus;
			this.OldSubStatus = oldSubStatus;
			this.NewStatus = newStatus;
			this.NewSubStatus = newSubStatus;
			this.NewStatusDescription = newStatusDescription;
			this.NewSubStatusDescription = newSubStatusDescription;
			this.RequiresStartDate = requiresStartDate;
			this.RequiresEndDate = requiresEndDate;
			this.DateCreated = dateCreated;
		}

		public int ID
		{
			get;
			set;
		}

		public string NewStatusDescription
		{
			get;
			set;
		}

		public string NewSubStatusDescription
		{
			get;
			set;
		}

		public string Description
		{
			get
			{
				return String.Format( "{0} : {1}", NewStatusDescription, NewSubStatusDescription );
			}
		}

		public string OldStatus
		{
			get;
			set;
		}

		public string OldSubStatus
		{
			get;
			set;
		}

		public string NewStatus
		{
			get;
			set;
		}

		public string NewSubStatus
		{
			get;
			set;
		}

		public bool RequiresStartDate
		{
			get;
			set;
		}

		public bool RequiresEndDate
		{
			get;
			set;
		}

		public DateTime DateCreated
		{
			get;
			set;
		}
	}
}
