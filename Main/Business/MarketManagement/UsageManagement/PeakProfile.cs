using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.MarketManagement.UsageManagement
{
	/// <summary>
	/// Container for profile data
	/// </summary>
	public class PeakProfile
	{
		// //////////////////////////////////////////////////////////////////////////////////////////////////////
		#region " Form events"

		/// <summary>
		/// Overloaded constructor where peakValue and offPeakValue 
		/// are derived from constructor parameters.
		/// </summary>
		/// <param name="dailyValue">Daily value</param>
		/// <param name="profileDate">Profile date</param>
		/// <param name="peakRatio">Peak ratio</param>
		public PeakProfile( decimal dailyValue, DateTime profileDate, decimal peakRatio )
		{
			this.dailyValue = dailyValue;
			this.profileDate = profileDate;
			this.peakRatio = peakRatio;

			this.peakValue = this.peakRatio * this.dailyValue;
			this.offPeakValue = this.dailyValue - this.peakValue;
		}

		// added 11/17/2008
		/// <summary>
		/// 
		/// </summary>
		/// <param name="dailyValue">Daily value</param>
		/// <param name="profileDate">Profile date</param>
		/// <param name="peakRatio">Peak ratio</param>
		/// <param name="peakValue">Peak Value</param>
		/// <param name="offPeakValue">Off Peak Value</param>
		public PeakProfile( decimal dailyValue, DateTime profileDate, decimal peakRatio, decimal peakValue, decimal offPeakValue )
		{
			this.dailyValue = dailyValue;
			this.profileDate = profileDate;
			this.peakRatio = peakRatio;
			this.peakValue = peakValue;
			this.offPeakValue = offPeakValue;
		}

		#endregion

		// //////////////////////////////////////////////////////////////////////////////////////////////////////
		#region " Properties & Fields"

		private Int32 dailyProfileId;
		/// <summary>
		/// Daily Profile ID
		/// </summary>
		public Int32 DailyProfileId
		{
			get { return dailyProfileId; }
			set { dailyProfileId = value; }
		}

		private decimal peakValue;
		/// <summary>
		/// Profile date
		/// </summary>
		protected System.DateTime profileDate;
		private decimal offPeakValue;
		private decimal peakRatio;
		private decimal dailyValue;

		/// <summary>
		/// Peak Value
		/// </summary>
		public decimal PeakValue
		{
			get { return peakValue; }
			set { peakValue = value; }

		}

		/// <summary>
		/// Profile date
		/// </summary>
		public System.DateTime ProfileDate
		{
			get { return profileDate; }
			set { profileDate = value; }
		}

		/// <summary>
		/// Off Peak Value
		/// </summary>
		public decimal OffPeakValue
		{
			get { return offPeakValue; }
			set { offPeakValue = value; }

		}

		/// <summary>
		/// Peak Ratio
		/// </summary>
		public decimal PeakRatio
		{
			get { return peakRatio; }
			set { peakRatio = value; }

		}

		/// <summary>
		/// Daily Value
		/// </summary>
		public decimal DailyValue
		{
			get { return dailyValue; }
			set { dailyValue = value; }

		}
		#endregion

	}
}
