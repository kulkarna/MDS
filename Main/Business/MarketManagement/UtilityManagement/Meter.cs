namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
using System;
using System.Collections.Generic;
using System.Text;

	/// <summary>
	/// Meter class
	/// </summary>
	[Serializable]
	public class Meter
	{
		/// <summary>
		/// The meter type.
		/// </summary>
		private MeterType meterType;

		/// <summary>
		/// The meter number.
		/// </summary>
		private string meterNumber;

		/// <summary>
		/// Constructor taking meter number and type parameters
		/// </summary>
		/// <param name="meterNumber">Meter number</param>
		/// <param name="meterType">Meter type object</param>
		public Meter( string meterNumber, MeterType meterType )
		{
			this.meterNumber = meterNumber;
			this.meterType = meterType;
		}

		/// <summary>
		/// Instantiates a new instance of the Meter class.
		/// </summary>
		/// <param name="meterType">The type of meter.</param>
		/// <remarks>Not all utilities have a meter number.</remarks>
		public Meter( MeterType meterType )
		{
			this.meterType = meterType;
		}

		/// <summary>
		/// The meter type.
		/// </summary>
		public MeterType MeterType
		{
			get { return this.meterType; }
			set { this.meterType = value; }
		}

		/// <summary>
		/// The meter number.
		/// </summary>
		public string MeterNumber
		{
			get { return this.meterNumber; }
			set { this.meterNumber = value; }
		}
	}
}
