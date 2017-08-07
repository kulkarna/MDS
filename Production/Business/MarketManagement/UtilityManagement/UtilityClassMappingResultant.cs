namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Runtime.Serialization;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	/// <summary>
	/// Class that contains utility class mapping resultant
	/// </summary>
	[DataContractAttribute]
	public class UtilityClassMappingResultant
	{
		/// <summary>
		/// Constructor that takes parameters for all properties
		/// </summary>
		/// <param name="identifier">Record identifier</param>
		/// <param name="determinantsID">Determinants record identifier</param>
		/// <param name="result">Result</param>
		public UtilityClassMappingResultant( int identifier, int determinantsID, string result )
		{
			this.Identifier = identifier;
			this.DeterminantsID = determinantsID;
			this.Result = result;
		}

		/// <summary>
		/// Record identifier
		/// </summary>
		public int Identifier
		{
			get;
			set;
		}

		/// <summary>
		/// Determinants record identifier
		/// </summary>
		public int DeterminantsID
		{
			get;
			set;
		}

		/// <summary>
		/// Result
		/// </summary>
		public string Result
		{
			get;
			set;
		}
	}
}
