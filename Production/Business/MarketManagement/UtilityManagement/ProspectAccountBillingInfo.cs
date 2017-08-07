using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	/// <summary>
	/// Holds data for a single meter read for one account.
	/// </summary>
	public class ProspectAccountBillingInfo : Usage
	{
		private string meterNumber;
		private decimal? currentCharges;

		/// <summary>
		/// Constructor.
		/// </summary>
		public ProspectAccountBillingInfo( string accountNumber, string utilityCode, DateTime fromDate,
			DateTime toDate, int totalKwh, int daysUsed, string meterNumber, decimal? onPeakKwh,
			decimal? offPeakKwh, decimal? billingDemandKw, decimal? monthlyPeakDemandKw,
			decimal? currentCharges, DateTime created, string createdBy, DateTime modified, string modifiedBy )
		{
			base.accountNumber = accountNumber;
			base.utilityCode = utilityCode;
			base.beginDate = fromDate;
			base.endDate = toDate;
			base.totalKwh = totalKwh;
			base.days = daysUsed;
			this.meterNumber = meterNumber;
			base.onPeakKwh = onPeakKwh;
			base.offPeakKwh = offPeakKwh;
			base.billingDemandKw = billingDemandKw;
			base.monthlyPeakDemandKw = monthlyPeakDemandKw;
			this.currentCharges = currentCharges;
			base.dateCreated = created;
			base.createdBy = createdBy;
			base.dateModified = modified;
			base.modifiedBy = modifiedBy;
		}

		/// <summary>
		/// Meter number.
		/// </summary>
		public new string MeterNumber
		{
			get
			{
				return meterNumber;
			}
			set
			{
				meterNumber = value;
			}
		}

		/// <summary>
		/// Current charges.
		/// </summary>
		public decimal? CurrentCharges
		{
			get
			{
				return currentCharges;
			}
			set
			{
				currentCharges = value;
			}
		}

	}
}
