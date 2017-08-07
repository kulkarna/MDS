namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	/// <summary>
	/// Class that contains utility mapping data
	/// </summary>
	public class UtilityMapping
	{
		/// <summary>
		/// Utility class mapping objects
		/// </summary>
		public UtilityClassMappingList UtilityClassMappingList
		{
			get;
			set;
		}

		/// <summary>
		/// Utility zone mapping objects
		/// </summary>
		public UtilityZoneMappingList UtilityZoneMappingList
		{
			get;
			set;
		}

		/// <summary>
		/// Utility class determinants objects
		/// </summary>
		public UtilityClassMappingDeterminantList UtilityClassMappingDeterminantList
		{
			get;
			set;
		}
	}
}
