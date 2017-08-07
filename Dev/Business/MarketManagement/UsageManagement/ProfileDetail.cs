using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.MarketManagement.UsageManagement
{
	/// <summary>
	/// Container for profile data
	/// </summary>
	public class ProfileDetail
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public ProfileDetail() { }

		/// <summary>
		/// Overloaded constructor which sets property values upon instantiation 
		/// </summary>
		/// <param name="dateProfile">Profile date</param>
		/// <param name="dailyProfileId">ID used for relationship with DailyProfileHeader</param>
		/// <param name="peakValue">Peak Value</param>
		/// <param name="offPeakValue">Off Peak Value</param>
		/// <param name="dailyValue">Daily value</param>/// 
		/// <param name="peakRatio">Peak ratio</param>
		public ProfileDetail( DateTime dateProfile, Int64 dailyProfileId,
			decimal peakValue, decimal offPeakValue, decimal dailyValue, decimal peakRatio )
		{
			this.dateProfile = dateProfile;
			this.dailyProfileId = dailyProfileId;
			this.peakValue = peakValue;
			this.offPeakValue = offPeakValue;
			this.dailyValue = dailyValue;
			this.peakRatio = peakRatio;
		}

		private DateTime dateProfile;
		private Int64 dailyProfileId;
		private decimal peakValue;
		private decimal offPeakValue;
		private decimal dailyValue;
		private decimal peakRatio;

		/// <summary>
		/// Profile date
		/// </summary>
		public DateTime DateProfile
		{
			get { return dateProfile; }
			set { dateProfile = value; }
		}

		/// <summary>
		/// ID used for relationship with DailyProfileHeader
		/// </summary>
		public Int64 DailyProfileId
		{
			get { return dailyProfileId; }
			set { dailyProfileId = value; }
		}

		/// <summary>
		/// Peak Kwh
		/// </summary>
		public decimal PeakValue
		{
			get { return peakValue; }
			set { peakValue = value; }
		}

		/// <summary>
		/// Off Peak Kwh
		/// </summary>
		public decimal OffPeakValue
		{
			get { return offPeakValue; }
			set { offPeakValue = value; }
		}

		/// <summary>
		/// Daily Value
		/// </summary>
		public decimal DailyValue
		{
			get { return dailyValue; }
			set { dailyValue = value; }
		}

		/// <summary>
		/// Peak Ratio
		/// </summary>
		public decimal PeakRatio
		{
			get { return peakRatio; }
			set { peakRatio = value; }
		}
	}
}
