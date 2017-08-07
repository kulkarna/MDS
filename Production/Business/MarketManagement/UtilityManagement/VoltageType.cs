namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	/// <summary>
	/// Class for voltage types
	/// </summary>
	[Serializable]
	public class VoltageType
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
		/// Voltage type
		/// </summary>
		public string VoltageCode
		{
			get;
			set;
		}

        public override string ToString()
        {
            return VoltageCode;
        }
	}
}
