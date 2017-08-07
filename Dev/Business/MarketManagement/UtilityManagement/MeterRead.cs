using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	/// <summary>
	/// The MeterRead class represents an instance of a meter read
	/// by the utility.
	/// </summary>
	[Serializable]
	public class MeterRead : Meter
	{
		/// <summary>
		/// The meter read value.
		/// </summary>
		private decimal readValue;

		/// <summary>
		/// The date in which the meter was read.
		/// </summary>
		private DateTime? readDate;

		/// <summary>
		/// Constructor taking a meter type object parameter
		/// </summary>
		/// <param name="meterType">Meter type object</param>
		public MeterRead( MeterType meterType )
			: base( meterType )
		{
		}

		/// <summary>
		/// The meter read value.
		/// </summary>
		public decimal ReadValue
		{
			get { return this.readValue; }
			set { this.readValue = value; }
		}

		/// <summary>
		/// The date in which the meter was read.
		/// </summary>
		public DateTime? ReadDate
		{
			get { return this.readDate; }
			set { this.readDate = value; }
		}

		/// <summary>
		/// The description of the unit associated with the ReadValue.
		/// </summary>
		public string UnitDescription
		{
			get { return "KWh"; }
		}
	}
}
