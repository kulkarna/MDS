namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
using System;
using System.Collections.Generic;
using System.Text;
	using System.ComponentModel;

	/// <summary>
	/// Meter type enum
	/// </summary>
	[Serializable]
	public enum MeterType
	{
		/// <summary>
		/// Non-IDR
		/// </summary>
		[Description( "NON-IDR" )]
		NonIdr,
		/// <summary>
		/// IDR
		/// </summary>
		[Description( "IDR" )]
		Idr,
		/// <summary>
		/// Unmetered
		/// </summary>
		[Description( "UNMETERED" )]
		Unmetered, 
		/// <summary>
		/// Unknown
		/// </summary>
		[Description( "UNKNOWN" )]
        Unknown
	}
}
