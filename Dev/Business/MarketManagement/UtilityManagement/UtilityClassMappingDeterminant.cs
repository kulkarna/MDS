namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Runtime.Serialization;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;
	using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;

	/// <summary>
	/// Class that conatins utility class determinant
	/// </summary>
	[DataContractAttribute]
	public class UtilityClassMappingDeterminant
	{
		/// <summary>
		/// Constructor that takes parameters for all properties
		/// </summary>
		/// <param name="identifier">Record identifier</param>
		/// <param name="utilityID">Utility record identifier</param>
		/// <param name="driver">Determinant driver</param>
		public UtilityClassMappingDeterminant( int identifier, int utilityID, string driver )
		{
			this.Identifier = identifier;
			this.Driver = driver;
			this.UtilityID = utilityID;
			this.UtilityClassMappingResultantList = UtilityMappingFactory.GetUtilityClassMappingResultants( identifier );
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
		/// Determinant driver
		/// </summary>
		public string Driver
		{
			get;
			set;
		}

		/// <summary>
		/// Utility record identifier
		/// </summary>
		public int UtilityID
		{
			get;
			set;
		}

		/// <summary>
		/// Utility class mapping resultants for determinant
		/// </summary>
		[DataMemberAttribute]
		public UtilityClassMappingResultantList UtilityClassMappingResultantList
		{
			get;
			set;
		}
	}
}
