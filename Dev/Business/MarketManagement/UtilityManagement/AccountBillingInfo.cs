using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	public class AccountBillingInfo : Usage
	{
		//private string myAccountNumber;
		//private string myUtilityCode;
		//private DateTime myFromDate;
		//private DateTime myToDate;
		//private int? myTotalKwh;
		//private int? myDaysUsed;
		private string meterNumber;
		//private decimal? onPeakKwh;				-- 12/01/2008
		//private decimal? offPeakKwh;
		//private decimal? billingDemandKw;
		//private decimal? monthlyPeakDemandKw;
		private decimal? currentCharges;
		//private DateTime myCreated;
		//private string myCreatedBy;
		//private DateTime? modified;				-- 12-01-2008
		//private string modifiedBy;

		////////////////////////////////////////////////////////////////////////////////////////////////////////// 
		#region " ClassEvents"

		public AccountBillingInfo( string accountNumber, string utilityCode, DateTime fromDate,
			DateTime toDate, int totalKwh, int daysUsed, string meterNumber, decimal? onPeakKwh,
			decimal? offPeakKwh, decimal? billingDemandKw, decimal? monthlyPeakDemandKw,
			decimal? currentCharges, DateTime created, string createdBy, DateTime? modified, string modifiedBy )
		{
			base.accountNumber = accountNumber;
			base.utilityCode = utilityCode;
			base.beginDate = fromDate;
			base.endDate = toDate;
			base.totalKwh = totalKwh;
			base.days = daysUsed;
			this.meterNumber = meterNumber;			//not part of usage
			base.onPeakKwh = onPeakKwh;				//12-01-2008
			base.offPeakKwh = offPeakKwh;
			base.billingDemandKw = billingDemandKw;
			base.monthlyPeakDemandKw = monthlyPeakDemandKw;
			this.currentCharges = currentCharges;	//not part of usage
			base.dateCreated = created;
			base.createdBy = createdBy;
			base.dateModified = modified;
			base.modifiedBy = modifiedBy;
		}

		#endregion

		////////////////////////////////////////////////////////////////////////////////////////////////////////// 
		#region " Properties"

		//public string AccountNumber
		//{
		//    get
		//    {
		//        return myAccountNumber;
		//    }
		//    set
		//    {
		//        myAccountNumber = value;
		//    }
		//}

		//public string UtilityCode
		//{
		//    get
		//    {
		//        return myUtilityCode;
		//    }
		//    set
		//    {
		//        myUtilityCode = value;
		//    }
		//}

		//public DateTime FromDate
		//{
		//    get
		//    {
		//        return myFromDate;
		//    }
		//    set
		//    {
		//        myFromDate = value;
		//    }
		//}

		//public DateTime ToDate
		//{
		//    get
		//    {
		//        return myToDate;
		//    }
		//    set
		//    {
		//        myToDate = value;
		//    }
		//}

		//public int? TotalKwh
		//{
		//    get
		//    {
		//        return myTotalKwh;
		//    }
		//    set
		//    {
		//        myTotalKwh = value;
		//    }
		//}

		//public int? DaysUsed
		//{
		//    get
		//    {
		//        return myDaysUsed;
		//    }
		//    set
		//    {
		//        myDaysUsed = value;
		//    }
		//}

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

		//public decimal? OnPeakKwh					-- 12-01-2008
		//{
		//    get
		//    {
		//        return onPeakKwh;
		//    }
		//    set
		//    {
		//        onPeakKwh = value;
		//    }
		//}

		//public decimal? OffPeakKwh
		//{
		//    get
		//    {
		//        return offPeakKwh;
		//    }
		//    set
		//    {
		//        offPeakKwh = value;
		//    }
		//}

		//public decimal? BillingDemandKw
		//{
		//    get
		//    {
		//        return billingDemandKw;
		//    }
		//    set
		//    {
		//        billingDemandKw = value;
		//    }
		//}

		//public decimal? MonthlyPeakDemandKw
		//{
		//    get
		//    {
		//        return monthlyPeakDemandKw;
		//    }
		//    set
		//    {
		//        monthlyPeakDemandKw = value;
		//    }
		//}

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

		//public DateTime Created
		//{
		//    get
		//    {
		//        return myCreated;
		//    }
		//    set
		//    {
		//        myCreated = value;
		//    }
		//}

		//public string CreatedBy
		//{
		//    get
		//    {
		//        return myCreatedBy;
		//    }
		//    set
		//    {
		//        myCreatedBy = value;
		//    }
		//}

		//public DateTime? Modified	-- 12/01/2008
		//{
		//    get
		//    {
		//        return modified;
		//    }
		//    set
		//    {
		//        modified = value;
		//    }
		//}

		//public string ModifiedBy
		//{
		//    get
		//    {
		//        return modifiedBy;
		//    }
		//    set
		//    {
		//        modifiedBy = value;
		//    }
		//}

		#endregion

	}
}
