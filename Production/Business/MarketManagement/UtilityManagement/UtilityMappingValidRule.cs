using LibertyPower.Business.CommonBusiness.FieldHistory;

namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Runtime.InteropServices;

	using LibertyPower.Business.CommonBusiness.CommonRules;
	using LibertyPower.Business.CommonBusiness.CommonHelper;

	/// <summary>
	/// Class that ensures that utility mapping is unique and losses are valid
	/// </summary>
	[Guid( "D023968B-249D-4dc4-B13C-FA89D66E2A6F" )]
	public class UtilityMappingValidRule : BusinessRule
	{
		#region Fields

		private List<FieldMap> fieldMapList;
		private FieldMap _fieldMap;
		private UtilityClassMappingList mappings;
		private int? identifier;
		private int utilityID;
		private int accountTypeID;
		private int meterTypeID;
		private int voltageID;
		private string rateClassCode;
		private string serviceClassCode;
		private string loadProfileCode;
		private string loadShapeCode;
		private string tariffCode;
		private string losses;
		private string accountType;
		private string meterType;
		private string voltage;
		private string zone;
		private decimal? icap;
		private decimal? tcap;


		#endregion

		#region Constructors

		/// <summary>
		/// Constructor that takes parameters for validation.
		/// </summary>
		/// <param name="identifier">Utility class mapping record identifier</param>
		/// <param name="utilityID">Utility record identifier</param>
		/// <param name="accountTypeID">Account type record identifier</param>
		/// <param name="meterTypeID">Meter type record identifier</param>
		/// <param name="voltageID">Voltage record identifier</param>
		/// <param name="rateClassCode">Rate class</param>
		/// <param name="serviceClassCode">Service class</param>
		/// <param name="loadProfileCode">Load profile</param>
		/// <param name="loadShapeCode">Load shape</param>
		/// <param name="tariffCode">Tariff code</param>
		/// <param name="losses">String representation of the loss factor</param>				
		[Obsolete()]
		public UtilityMappingValidRule( int? identifier, int utilityID, int accountTypeID, int meterTypeID, int voltageID,
			string rateClassCode, string serviceClassCode, string loadProfileCode, string loadShapeCode, string tariffCode, string losses )
			: base( "Utility Mapping Valid Rule", BrokenRuleSeverity.Error )
		{
			this.identifier = identifier;
			this.utilityID = utilityID;
			this.accountTypeID = accountTypeID;
			this.meterTypeID = meterTypeID;
			this.voltageID = voltageID;
			this.rateClassCode = rateClassCode.ToUpper();
			this.serviceClassCode = serviceClassCode.ToUpper();
			this.loadProfileCode = loadProfileCode.ToUpper();
			this.loadShapeCode = loadShapeCode.ToUpper();
			this.tariffCode = tariffCode.ToUpper();
			this.losses = losses;

		}

		/// <summary>
		/// Constructor that takes parameters for validation.
		/// </summary>
		/// <param name="identifier"></param>
		/// <param name="utilityID"></param>
		/// <param name="accountTypeID"></param>
		/// <param name="meterTypeID"></param>
		/// <param name="voltageID"></param>
		/// <param name="rateClassCode"></param>
		/// <param name="serviceClassCode"></param>
		/// <param name="loadProfileCode"></param>
		/// <param name="loadShapeCode"></param>
		/// <param name="tariffCode"></param>
		/// <param name="losses"></param>
		/// <param name="accountType"></param>
		/// <param name="voltageType"></param>
		/// <param name="meterType"></param>
		/// <param name="zone"></param>
		public UtilityMappingValidRule( int? identifier, int utilityID, int accountTypeID, int meterTypeID, int voltageID,
			string rateClassCode, string serviceClassCode, string loadProfileCode, string loadShapeCode, string tariffCode, string losses, string accountType, string voltageType, string meterType, string zone, decimal? icap = null, decimal? tcap = null )
			: base( "Utility Mapping Valid Rule", BrokenRuleSeverity.Error )
		{
			this.identifier = identifier;
			this.utilityID = utilityID;
			this.accountTypeID = accountTypeID;
			this.meterTypeID = meterTypeID;
			this.voltageID = voltageID;
			this.rateClassCode = rateClassCode.ToUpper();
			this.serviceClassCode = serviceClassCode.ToUpper();
			this.loadProfileCode = loadProfileCode.ToUpper();
			this.loadShapeCode = loadShapeCode.ToUpper();
			this.tariffCode = tariffCode.ToUpper();
			this.losses = losses;
			this.accountType = accountType;
			this.voltage = voltageType;
			this.meterType = meterType;
			this.zone = zone;
			this.icap = icap;
			this.tcap = tcap;
		}

		public UtilityMappingValidRule( FieldMap fieldMap )
		{
			_fieldMap = fieldMap;
		}

		public UtilityMappingValidRule( string utilityCode, string fieldValue, MappingRuleType ruleType, TrackedField field )
		{
			_fieldMap = new FieldMap( utilityCode, ruleType, field, fieldValue );
		}

		public UtilityMappingValidRule( List<FieldMap> fieldMapList )
		{
			this.fieldMapList = fieldMapList;
		}


		#endregion

		public override bool Validate()
		{
			if( string.IsNullOrEmpty( _fieldMap.UtilityCode ) )
				AddException( new BrokenRuleException( this, "Field mapping must specify a utility", BrokenRuleSeverity.Error ) );
			if( _fieldMap.DeterminantField == TrackedField.Unknown || string.IsNullOrEmpty( _fieldMap.DeterminantValue ) )
				AddException( new BrokenRuleException( this, "Field mapping must define a determinant and provide a value", BrokenRuleSeverity.Error ) );
			if( _fieldMap.Resultants == null || _fieldMap.Resultants.Count < 1 )
				AddException( new BrokenRuleException( this, "Field mapping must specify at least one resultant", BrokenRuleSeverity.Error ) );
			else
			{
				bool found = false;
				foreach( var resultant in _fieldMap.Resultants )
				{
					if( resultant.ResultantField != TrackedField.Unknown && !string.IsNullOrEmpty( resultant.ResultantValue ) )
					{
						found = true;
						break;
					}
				}
				if( !found )
					AddException( new BrokenRuleException( this, "Field mapping must specify at least one resultant", BrokenRuleSeverity.Error ) );

			}

			// If loss factor exists and is not empty/null, verify that it is less than 10K
			var losses = _fieldMap.GetValue( TrackedField.LossFactor );
			if( !string.IsNullOrEmpty( losses ) )
			{
				if( Convert.ToDecimal( losses ) >= 10000m )
				{
					AddException( new BrokenRuleException( this, "Value for losses must be less than 10,000.", BrokenRuleSeverity.Error ) );
				}
			}


			return Exception == null;
		}

		private bool ValidateDeterminant( string fieldName )
		{
			switch( fieldName.Trim().ToLower() )
			{
				case "serviceclass":
				case "loadShapeid":
				case "voltage":
				case "accounttype":
				case "zonecode":
				case "lossfactor":
				case "loadprofile":
				case "metertype":
				case "rateclass":
				case "tariffcode":
				case "lbmpzone":
				case "zone":
				case "grid":
				case "icap":
				case "tcap":
				case "utility":
					return true;
				default:
					{
						AddException( new BrokenRuleException( this, string.Format( "Invalid determinant type ({0}).", fieldName ), BrokenRuleSeverity.Error ) );
						break;
					}
			}
			return Exception == null;
		}

		public bool ValidateDeterminant()
		{
			if( this._fieldMap != null )
			{
				return ValidateDeterminant( this._fieldMap.DeterminantField.ToString() );
			}
			else
			{
				AddException( new BrokenRuleException( this, "No determinant found.", BrokenRuleSeverity.Error ) );
			}
			return Exception == null;
		}

		public bool ValidateDeterminants()
		{
			if( CollectionHelper.HasItem( this.fieldMapList ) )
			{
				foreach( FieldMap fm in this.fieldMapList )
				{
					if( !ValidateDeterminant( fm.DeterminantField.ToString() ) )
						return false;
				}
			}
			else
			{
				AddException( new BrokenRuleException( this, "No determinants found.", BrokenRuleSeverity.Error ) );
			}
			return Exception == null;
		}

		#region obsolete

		/// <summary>
		/// Validates data returning success or not as a boolean value.
		/// </summary>
		/// <returns>Returns success or not of data validation as a boolean value.</returns>
		//public override bool Validate()
		//{

		//    var determinantList = UtilityMappingFactory.GetUtilityClassMappingDeterminants( utilityID );
		//    mappings = UtilityMappingFactory.GetUtilityMapping( utilityID );

		//    #region Match determinants and resultants

		//    bool determinantHasData = false;

		//    // Get the driver for the current utility
		//    var commaSeparatedDeterminantList = "";
		//    var commaSeparatedResultantList = "";
		//    var atLeastOneResultantHasData = false;

		//    foreach( var determinant in determinantList )
		//    {
		//        if( IsUtilityDeterminant( determinant.Driver ) )
		//        {
		//            commaSeparatedDeterminantList += determinant.Driver + ",";

		//            // Validate determinant has a value
		//            var driverValue = this.GetFieldValue( determinant.Driver );

		//            if( driverValue != null && !string.IsNullOrEmpty( driverValue.Trim().Replace( " ", "" ) ) )
		//            {
		//                determinantHasData = true;

		//                if( determinant.UtilityClassMappingResultantList.Count > 0 )
		//                {
		//                    // At lease 1 resultant must exist							
		//                    foreach( var resultant in determinant.UtilityClassMappingResultantList )
		//                    {
		//                        commaSeparatedResultantList += resultant.Result + ",";

		//                        if( !string.IsNullOrEmpty( this.GetFieldValue( resultant.Result ) ) )
		//                        {
		//                            atLeastOneResultantHasData = true;
		//                            break;
		//                        }
		//                    }
		//                }
		//                else
		//                {
		//                    // There are no resultants
		//                    atLeastOneResultantHasData = true;
		//                    break;
		//                }
		//                break;
		//            }
		//        }
		//    }

		//    #region manage all else case
		//    // here we will allow a map that includes only resultants where none are determinants; in this case the map wil serve as an 'ALL ELSE' case where no other mapping exists
		//    // this case must be 'Fill If Blank' only - IT059 PBI 2280
		//    if (IsAllElseMappingAndHasResultant(determinantList))
		//        atLeastOneResultantHasData = true;

		//    #endregion


		//    if ( !determinantHasData )
		//    {
		//        //NO longer a rule since Utility serves as default determinant for ALLELSE case when no determinant has a value - IT059 PBI 2280
		//        //AddException( new BrokenRuleException( this, "At least one of the following determinants is required: " + commaSeparatedDeterminantList.Trim().TrimEnd( ',' ), BrokenRuleSeverity.Error ) );
		//    }

		//    if( !atLeastOneResultantHasData )
		//    {
		//        AddException( new BrokenRuleException( this, "At least one of the following resultants are required: " + commaSeparatedResultantList.Trim().TrimEnd( ',' ), BrokenRuleSeverity.Error ) );
		//    }

		//    #endregion

		//    #region Loss Factor is valid

		//    // If loss factor exists and is not empty/null, verify that it is less than 10K
		//    if( !string.IsNullOrEmpty( losses ) )
		//    {
		//        if( Convert.ToDecimal( losses ) >= 10000m )
		//        {
		//            AddException( new BrokenRuleException( this, "Value for losses must be less than 10,000.", BrokenRuleSeverity.Error ) );
		//        }
		//    }

		//    #endregion			

		//    #region Loss Factor/Zone are not mapped in Utility Zone

		//    // If loss factor has data
		//    if( !string.IsNullOrEmpty( this.losses ) )
		//    {
		//        // Check to see if it has data in utility zone mappings
		//        if( UtilityMappingFactory.IsLossFactorMappedInUtilityZoneMappings( utilityID ) )
		//        {
		//            string mappedByDeterminant = DeterminantThatContainsMappedResultant( determinantList, "LossFactor" );
		//            AddException( new BrokenRuleException( this, "Loss factor is already mapped by determinant " + mappedByDeterminant + " in Utility Zone Mappings", BrokenRuleSeverity.Error ) );
		//        }
		//    }

		//    if( !string.IsNullOrEmpty( this.zone ) )
		//    {
		//        if( UtilityMappingFactory.IsZoneMappedInUtilityZoneMappings( utilityID ) )
		//        {
		//            string mappedByDeterminant = DeterminantThatContainsMappedResultant( determinantList, "ZoneID" );
		//            AddException( new BrokenRuleException( this, "Zone is already mapped by determinant " + mappedByDeterminant + " in Utility Zone Mappings", BrokenRuleSeverity.Error ) );
		//        }
		//    }

		//    #endregion

		//    return this.Exception == null;
		//}

		[Obsolete()]
		private bool IsAllElseMappingAndHasResultant( UtilityClassMappingDeterminantList determinantList )
		{
			bool hasResultant = (accountTypeID > -1 || meterTypeID > 0 || voltageID > 0 || !string.IsNullOrEmpty( rateClassCode ) || !string.IsNullOrEmpty( serviceClassCode )
								 || !string.IsNullOrEmpty( loadProfileCode ) || !string.IsNullOrEmpty( loadShapeCode ) || !string.IsNullOrEmpty( tariffCode ) || !string.IsNullOrEmpty( losses )
								 || !string.IsNullOrEmpty( accountType ) || !string.IsNullOrEmpty( voltage ) || !string.IsNullOrEmpty( meterType ) || !string.IsNullOrEmpty( zone ) || icap.HasValue || tcap.HasValue);

			foreach( var determinant in determinantList )
			{
				switch( determinant.Driver )
				{
					case "ServiceClassID":
						if( !string.IsNullOrEmpty( serviceClassCode ) )
							return false;
						break;
					case "LoadShapeID":
						if( !string.IsNullOrEmpty( loadShapeCode ) )
							return false;
						break;
					case "VoltageID":
						if( !string.IsNullOrEmpty( voltage ) )
							return false;
						break;
					case "CustomerType":
						if( !string.IsNullOrEmpty( accountType ) )
							return false;
						break;
					case "ZoneID":
						if( !string.IsNullOrEmpty( zone ) )
							return false;
						break;
					case "LossFactor":
						if( !string.IsNullOrEmpty( losses ) )
							return false;
						break;
					case "LoadProfileID":
						if( !string.IsNullOrEmpty( loadProfileCode ) )
							return false;
						break;
					case "MeterType":
						if( !string.IsNullOrEmpty( meterType ) )
							return false;
						break;
					case "RateClassID":
						if( !string.IsNullOrEmpty( rateClassCode ) )
							return false;
						break;
					case "TariffCodeID":
						if( !string.IsNullOrEmpty( tariffCode ) )
							return false;
						break;
				}
			}
			return hasResultant;
		}

		private void AddException( BrokenRuleException exception )
		{
			if( this.Exception == null )
				this.SetException( "Utility mapping error." );

			this.DefaultSeverity = BrokenRuleSeverity.Error;

			this.AddDependentException( exception );
		}

		[Obsolete()]
		private string GetFieldValue( string fieldName )
		{
			switch( fieldName )
			{
				case "AccountTypeID":
					return this.accountType;
				case "CustomerType":
					return this.accountType;
				case "LoadProfileID":
					return this.loadProfileCode;
				case "LoadShapeID":
					return this.loadShapeCode;
				case "MeterTypeID":
					return this.meterType;
				case "RateClassID":
					return this.rateClassCode;
				case "ServiceClassID":
					return this.serviceClassCode;
				case "TariffCodeID":
					return this.tariffCode;
				case "VoltageID":
					return this.voltage;
				case "ZoneID":
					return this.zone;
				case "LossFactor":
					return this.losses;
				case "ICap":
				case "Icap":
					return this.icap.HasValue ? icap.Value.ToString() : "";
				case "TCap":
				case "Tcap":
					return this.tcap.HasValue ? tcap.Value.ToString() : "";
				default:
					throw new Exception( fieldName + " not found" );
			}
		}

		[Obsolete()]
		private string GetFieldValueFromMapping( string fieldName, UtilityClassMapping mapping )
		{
			switch( fieldName )
			{
				case "AccountTypeID":
					return mapping.AccountTypeDescription;
				case "CustomerType":
					return mapping.AccountTypeDescription;
				case "LoadProfileID":
					return mapping.LoadProfileCode;
				case "LoadShapeID":
					return mapping.LoadShapeCode;
				case "MeterTypeID":
					return mapping.MeterTypeCode;
				case "RateClassID":
					return mapping.RateClassCode;
				case "ServiceClassID":
					return mapping.ServiceClassCode;
				case "TariffCodeID":
					return mapping.TariffCode;
				case "VoltageID":
					return mapping.VoltageCode;
				case "ZoneID":
					return mapping.ZoneCode;
				case "LossFactor":
					return mapping.LossFactor.ToString();
				default:
					throw new Exception( fieldName + " not found" );
			}
		}

		[Obsolete()]
		internal static bool IsUtilityDeterminant( string determinant )
		{
			if( determinant == "ServiceClassID" || determinant == "LoadShapeID" || determinant == "VoltageID" || determinant == "CustomerType" || determinant == "ZoneID" || determinant == "LossFactor" || determinant == "LoadProfileID" || determinant == "MeterType" || determinant == "RateClassID" || determinant == "TariffCodeID" )
			{
				return true;
			}
			return false;
		}

		[Obsolete()]
		private string DeterminantThatContainsMappedResultant( UtilityClassMappingDeterminantList determinantList, string resultant )
		{
			foreach( var determinant in determinantList )
			{
				if( UtilityZoneMappingValidRule.IsZoneDeterminant( determinant.Driver ) )
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
