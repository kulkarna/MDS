namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Runtime.InteropServices;

	using LibertyPower.Business.CommonBusiness.CommonRules;
	using LibertyPower.Business.CommonBusiness.CommonEntity;


	[Guid( "E2EB3ACB-4CE6-4302-B998-75CBCCC93E60" )]
	public class NimoAccountDataExistsRule : BusinessRule
	{
		private Nimo account;

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Constructor that takes a Nimo account
		/// </summary>
		/// <param name="account">Nimo account</param>
		public NimoAccountDataExistsRule( Nimo account )
			: base( "Account Data Exists Rule", BrokenRuleSeverity.Information )
		{
			this.account = account;
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Validates the parameter(s) passed in to the constructor returning a boolean indicating success or failure.
		/// </summary>
		/// <returns>Returns a boolean indicating success or failure.</returns>
		public override bool Validate()
		{
			DataExistsRule customerNameRule;
			DataExistsRule streetRule;
			DataExistsRule zipCodeRule;
			DataExistsRule stateCodeRule;
			DataExistsRule cityRule;
			DataExistsRule rateClassRule;
			DataExistsRule rateCodeRule;
			DataExistsRule taxDistrictRule;
			DataExistsRule voltageRule;
			DataExistsRule zoneCodeRule;
			DataExistsRule accountNumberRule;

			customerNameRule = new DataExistsRule( account.AccountNumber, "Customer Name", account.CustomerName );
			streetRule = new DataExistsRule( account.AccountNumber, "Street", account.Address.Street );
			zipCodeRule = new DataExistsRule( account.AccountNumber, "Zip Code", (account.Address as UsGeographicalAddress).ZipCode );
			stateCodeRule = new DataExistsRule( account.AccountNumber, "State Code", (account.Address as UsGeographicalAddress).StateCode );
			cityRule = new DataExistsRule( account.AccountNumber, "City Name", account.Address.CityName );
			rateClassRule = new DataExistsRule( account.AccountNumber, "Rate Class", account.RateClass );
			rateCodeRule = new DataExistsRule( account.AccountNumber, "Rate Code", account.RateCode );
			taxDistrictRule = new DataExistsRule( account.AccountNumber, "Tax District", account.TaxDistrict );
			voltageRule = new DataExistsRule( account.AccountNumber, "Voltage", account.Voltage );
			zoneCodeRule = new DataExistsRule( account.AccountNumber, "Zone Code", account.ZoneCode );
			accountNumberRule = new DataExistsRule( account.AccountNumber, "Account Number", account.AccountNumber );

			if( !customerNameRule.Validate() )
				AddException( customerNameRule.Exception );

			if( !streetRule.Validate() )
				AddException( streetRule.Exception );

			if( !zipCodeRule.Validate() )
				AddException( zipCodeRule.Exception );

			if( !stateCodeRule.Validate() )
				AddException( stateCodeRule.Exception );

			if( !cityRule.Validate() )
				AddException( cityRule.Exception );

			if( !rateClassRule.Validate() )
				AddException( rateClassRule.Exception );

			if( !rateCodeRule.Validate() )
				AddException( rateCodeRule.Exception );

			if( !taxDistrictRule.Validate() )
				AddException( taxDistrictRule.Exception );

			if( !voltageRule.ValidateNumber() )
				AddException( voltageRule.Exception );

			if( !zoneCodeRule.Validate() )
				AddException( zoneCodeRule.Exception );

			if( !accountNumberRule.Validate() )
				AddException( accountNumberRule.Exception );

			NimoUsageListDataExistsRule usageRule = new NimoUsageListDataExistsRule( account.AccountNumber, account.WebUsageList );

			if( !usageRule.Validate() )
				AddException( usageRule.Exception );

			account.AccountDataExistsRule = this;

			return this.Exception == null;
		}

		// ------------------------------------------------------------------------------------
		private void AddException( BrokenRuleException exception )
		{
			if( this.Exception == null )
				this.SetException( "Missing account data." );

			exception.Severity = BrokenRuleSeverity.Warning;
			this.DefaultSeverity = BrokenRuleSeverity.Error;

			this.AddDependentException( exception );
		}
	}
}
