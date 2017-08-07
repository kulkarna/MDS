namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	public enum AcrQueueUpdateStatus
	{
		/// <summary>
		///  The rate update is ready to be processed by the queue.
		/// </summary>
		Unsent = 0,

		/// <summary>
		/// The rate update operation was successful.
		/// </summary>
		Accepted = 1,

		/// <summary>
		/// The rate update operation failed.
		/// </summary>
		Failed = 2,

		/// <summary>
		/// The current rate update is being processed by a thread.
		/// </summary>
		Processing = 3,

		/// <summary>
		/// The rate update has a future send date.
		/// </summary>
		NotReady = 4,

		/// <summary>
		/// Contract has been renewed or account de-enrolled.
		/// </summary>
		RateUpdateCancelled = 5,

		/// <summary>
		/// The rate has been inserted into the ACR table.
		/// </summary>
		RateUpdated = 6
	}
}
