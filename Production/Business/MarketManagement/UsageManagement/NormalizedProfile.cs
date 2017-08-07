using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.MarketManagement.UsageManagement
{
	/// <summary>
	/// Container for normalized profile
	/// </summary>
	public class NormalizedProfile
	{
		private DateTime normalizedDate;
		private Decimal normalizedValue;

		/// <summary>
		/// Constructor which sets property values upon instantiation 
		/// </summary>
		/// <param name="date">Profile date</param>
		/// <param name="value">Decimal value</param>
		public NormalizedProfile( DateTime date, Decimal value )
		{
			this.normalizedDate = date;
			this.normalizedValue = value;
		}
	
		/// <summary>
		/// Profile date
		/// </summary>
		public DateTime Date
		{
			get{return normalizedDate;}
			set{normalizedDate = value;}
		}

		/// <summary>
		/// Decimal value
		/// </summary>
		public Decimal NormalizedValue
		{
			get{return normalizedValue;}
			set{normalizedValue = value;}
		}
	}
}
