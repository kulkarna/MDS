namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System.Collections.Generic;

	using LibertyPower.Business.MarketManagement.EdiParser.FormatParser;

	/// <summary>
	/// Represents a mapping between a edi file and a EdiAccount instance
	/// </summary>
	public abstract class ClassMap
	{
		private Dictionary<string, List<IPropertySetter>> fieldMappings;
		private MarkerBase marker;

		/// <summary>
		/// Default constructor. Sets the cell marker.
		/// </summary>
		public ClassMap( MarkerBase marker )
		{
			this.fieldMappings = new Dictionary<string, List<IPropertySetter>>();
			this.marker = marker;
		}

		/// <summary>
		/// Cel marker.
		/// </summary>
		protected MarkerBase Marker
		{
			get { return marker; }
		}

		/// <summary>
		/// Adds a new field in the map.
		/// </summary>
		/// <param name="fieldName">The name of the field in the edi file</param>
		/// <param name="parser">The property parser used to parse data from the edi file</param>
		protected void AddFieldMap( string fieldName, IPropertySetter parser )
		{
			if( fieldMappings.ContainsKey( fieldName ) )
				fieldMappings[fieldName].Add( parser );
			else
				fieldMappings.Add( fieldName, new List<IPropertySetter>() { parser } );
		}

		/// <summary>
		/// Removes a field map
		/// </summary>
		/// <param name="fieldName">Name of the field to be removed</param>
		protected void RemoveFieldMap( string fieldName )
		{
			if( fieldMappings.ContainsKey( fieldName ) )
				fieldMappings.Remove( fieldName );
		}

		/// <summary>
		/// Maps an field in a edi file to a property of an EdiAccount instance
		/// </summary>
		/// <param name="target">EdiAccount being mapped</param>
		/// <param name="fieldName">Name of the field in the edi file</param>
		/// <param name="fileCellContent">File row Cell wich contains the data that will be parsed</param>
		/// <param name="fieldDelimiter">field delimiter</param>
		public void Map( EdiAccount target, string fieldName, string fileCellContent, char fieldDelimiter )
		{
			if( fieldMappings.ContainsKey( fieldName ) )
			{
				foreach( IPropertySetter property in fieldMappings[fieldName] )
					property.SetValue( target, ref fileCellContent, fieldDelimiter );
			}
		}

		/// <summary>
		/// If there are ICAP / TCAP values then we need to add them to their lists
		/// </summary>
		/// <param name="account">EDI acccount</param>
		public void MapIcapTcap( EdiAccount account )
		{
			bool needsIcapList = account.Icap > -1 && account.IcapList.Count == 0;
			bool needsTcapList = account.Tcap > -1 && account.TcapList.Count == 0;

            if (needsIcapList)
                account.IcapList.Add(new Icap(account.Icap, account.EffectiveDate, account.EffectiveDate.AddMonths(12)));
            
			if( needsTcapList )
				account.TcapList.Add( new Tcap( account.Tcap, account.EffectiveDate, account.EffectiveDate.AddMonths( 12 ) ) );
		}

        /// <summary>
        /// Maps the existence of incorrect Icap data 999 to zero.
        /// </summary>
        /// 
        /// <param name="account">EDI acccoun</param>
        public void MapNullIcapValue(EdiAccount account)
        {
            if (account.Icap == 999 && account.UtilityCode == UtilitiesCodes.CodeOf.Coned)
            {
                account.Icap = 0;
            }
        }
	}
}
