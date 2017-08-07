namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Linq;
	using System.Runtime.InteropServices;

	using LibertyPower.Business.CommonBusiness.CommonRules;

	/// <summary>
	/// Class that ensures that utility zone mapping is unique
	/// </summary>
	[Guid( "0AB12404-BEBB-48f0-B8A4-22FF142D5669" )]
	public class UtilityZoneMappingValidRule : BusinessRule
	{
		#region Fields

		private UtilityZoneMappingList mappings;
		private int? identifier;
		private int utilityID;
		private string zoneCode;
		private string grid;
		private string lbmpZone;
		private string losses;

		#endregion

		#region Constructors

		/// <summary>
		/// Constructor that takes parameters for validation.
		/// </summary>
		/// <param name="identifier">Utility zone mapping record identifier</param>
		/// <param name="utilityID">Utility record identifier</param>
		/// <param name="zoneCode">Zone code</param>
		/// <param name="grid">Grid</param>
		/// <param name="lbmpZone">LBMP zone</param>
		/// <param name="losses">String representation of the loss factor</param>
		public UtilityZoneMappingValidRule( int? identifier, int utilityID, string zoneCode, string grid, string lbmpZone, string losses )
			: base( "Utility Zone Mapping Valid Rule", BrokenRuleSeverity.Error )
		{
			this.identifier = identifier;
			this.utilityID = utilityID;
			this.zoneCode = zoneCode;
			this.grid = grid.ToUpper();
			this.lbmpZone = lbmpZone.ToUpper();
			this.losses = losses;
		}

		#endregion

		#region Methods

		/// <summary>
		/// Validates data returning success or not as a boolean value.
		/// </summary>
		/// <returns>Returns success or not of data validation as a boolean value.</returns>
		public override bool Validate()
		{			
			var determinantList = UtilityMappingFactory.GetUtilityClassMappingDeterminants( utilityID );
			mappings = UtilityMappingFactory.GetUtilityZoneMapping( utilityID );

			#region Find Duplicates

			foreach( var determinant in determinantList )
			{
				if( IsZoneDeterminant( determinant.Driver ) )
				{
					var valueOfDeterminantAboutToBeUpdated = GetFieldValue( determinant.Driver );

					foreach( var mapping in mappings )
					{
						if( mapping.Identifier != identifier )
						{
							if( !string.IsNullOrEmpty( valueOfDeterminantAboutToBeUpdated ) )
							{
								if( valueOfDeterminantAboutToBeUpdated == GetFieldValueFromExistingStore( determinant.Driver, mapping ) )
								{
									AddException( new BrokenRuleException( this, "Dulicate record", BrokenRuleSeverity.Error ) );
								}
							}
						}
					}
				}
			}

			#endregion

			#region Match determinants and resultants

			bool determinantHasData = false;

			// Get the driver for the current utility			
			var commaSeparatedDeterminantList = "";
			var commaSeparatedResultantList = "";
			var atLeastOneResultantHasData = false;

			foreach( var determinant in determinantList )
			{
				if( IsZoneDeterminant( determinant.Driver ) )
				{
					commaSeparatedDeterminantList += determinant.Driver + ",";

					// Validate determinant has a value
					var driverValue = this.GetFieldValue( determinant.Driver );

					if( driverValue != null && !string.IsNullOrEmpty( driverValue.Trim().Replace( " ", "" ) ) )
					{
						determinantHasData = true;

						if( determinant.UtilityClassMappingResultantList.Count > 0 )
						{
							// At lease 1 resultant must exist							
							foreach( var resultant in determinant.UtilityClassMappingResultantList )
							{
								commaSeparatedResultantList += resultant.Result + ",";

								if( !string.IsNullOrEmpty( this.GetFieldValue( resultant.Result ) ) )
								{
									atLeastOneResultantHasData = true;
									break;
								}
							}
						}
						else
						{
							// There are no resultants
							atLeastOneResultantHasData = true;
							break;
						}
						break;
					}
				}
			}

			if( !determinantHasData )
			{
				AddException( new BrokenRuleException( this, "At least one of the following determinants is required: " + commaSeparatedDeterminantList.Trim().TrimEnd( ',' ), BrokenRuleSeverity.Error ) );
			}

			if( !atLeastOneResultantHasData )
			{
				AddException( new BrokenRuleException( this, "At least one of the following resultants are required: " + commaSeparatedResultantList.Trim().TrimEnd( ',' ), BrokenRuleSeverity.Error ) );
			}

			#endregion

			#region Loss Factor is valid

			// If loss factor exists and is not empty/null, verify that it is less than 10K
			if( !string.IsNullOrEmpty( losses ) )
			{
				if( Convert.ToDecimal( losses ) >= 10000m )
				{
					AddException( new BrokenRuleException( this, "Value for losses must be less than 10,000.", BrokenRuleSeverity.Error ) );
				}
			}

			#endregion

			#region Loss Factor/Zone are not mapped in Utility Zone

			// If loss factor has data
			if( !string.IsNullOrEmpty( this.losses ) )
			{
				// Check to see if it has data in utility zone mappings
				if( UtilityMappingFactory.IsLossFactorMappedInUtilityClassMappings( utilityID ) )
				{
					string mappedByDeterminant = DeterminantThatContainsMappedResultant( determinantList, "LossFactor" );
					AddException( new BrokenRuleException( this, "Loss factor is already mapped by determinant " + mappedByDeterminant + " in Utility Class Mappings", BrokenRuleSeverity.Error ) );
				}
			}

			if( !string.IsNullOrEmpty( this.zoneCode ) )
			{
				if( UtilityMappingFactory.IsZoneMappedInUtilityClassMappings( utilityID ) )
				{
					string mappedByDeterminant = DeterminantThatContainsMappedResultant( determinantList, "ZoneID" );
					AddException( new BrokenRuleException( this, "Zone is already mapped by determinant " + mappedByDeterminant + " in Utility Class Mappings", BrokenRuleSeverity.Error ) );
				}
			}

			#endregion

			return this.Exception == null;
		}

		private void AddException( BrokenRuleException exception )
		{
			if( this.Exception == null )
				this.SetException( "Duplicate utility zone mapping error." );

			this.DefaultSeverity = BrokenRuleSeverity.Error;

			this.AddDependentException( exception );
		}

		private string GetFieldValue( string fieldName )
		{
			switch( fieldName )
			{				
				case "LBMPZone":
					return this.lbmpZone;
				case "ZoneID":
					return this.zoneCode;
				case "Grid":
					return this.grid;				
				case "LossFactor":
					return this.losses;
				default:
					throw new Exception( fieldName + " not found" );
			}
		}

		private string GetFieldValueFromExistingStore( string fieldName, UtilityZoneMapping mapping )
		{
			switch( fieldName )
			{
				case "LBMPZone":
					return mapping.LBMPZone;
				case "ZoneID":
					return mapping.ZoneCode;
				case "Grid":
					return mapping.Grid;				
				case "LossFactor":
					return mapping.LossFactor.ToString();
				default:
					throw new Exception( fieldName + " not found" );
			}
		}

		/// <summary>
		/// Determines if we are dealing with Utility or Zone
		/// </summary>
		/// <param name="determinant"></param>
		/// <returns></returns>
		internal static bool IsZoneDeterminant( string determinant )
		{
			if( determinant == "LBMPZone" || determinant == "Zone" || determinant == "LossFactor" || determinant == "Grid" )
			{
				return true;
			}
			return false;
		}

		private string DeterminantThatContainsMappedResultant( UtilityClassMappingDeterminantList determinantList, string resultant )
		{
			foreach( var determinant in determinantList )
			{
				if( UtilityMappingValidRule.IsUtilityDeterminant( determinant.Driver ) )
				{
					foreach( var r in determinant.UtilityClassMappingResultantList )
					{
						if( r.Result == resultant )
						{
							return determinant.Driver;
						}
					}
				}
			}
			return "";
		}

		#endregion

	}
}
