namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	/// <summary>
	/// Meter type for utility mapping
	/// </summary>
	[Serializable]
	public class MeterMapType
	{
		/// <summary>
		/// Record identity
		/// </summary>
		public int Identifier
		{
			get;
			set;
		}

		/// <summary>
		/// Meter type
		/// </summary>
		public string MeterTypeCode
		{
			get;
			set;
		}
	}
}
