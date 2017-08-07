namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Runtime.InteropServices;

	using LibertyPower.Business.CommonBusiness.CommonRules;
	using LibertyPower.Business.CommonBusiness.CommonEntity;

	[Guid( "2BAA2C59-BDE1-4e36-9EBF-649204C02A9C" )]
	public class RgeAccountDataExistsRule : BusinessRule
	{
		private Rge account;

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Constructor that takes a Rge account list
		/// </summary>
		/// <param name="account">Rge account list</param>
		public RgeAccountDataExistsRule( Rge account )
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
			DataExistsRule currentRateRule;
			DataExistsRule futureRateRule;
			DataExistsRule revenueClassRule;
			DataExistsRule loadShapeIDRule;
			DataExistsRule gridRule;
			DataExistsRule taxJurisdictionRule;
			DataExistsRule taxDistrictRule;
			DataExistsRule mailingAddresStreetRule;
			DataExistsRule mailingAddresZipCodeRule;
			DataExistsRule mailingAddresCityRule;
			DataExistsRule serviceAddressStreetRule;
			DataExistsRule serviceAddressZipCodeRule;
			DataExistsRule serviceAddressCityRule;

            //currentRateRule = new DataExistsRule( account.AccountNumber, "Current Rate Category", account.CurrentRateCategory );
            //futureRateRule = new DataExistsRule( account.AccountNumber, "Future Rate Category", account.FutureRateCategory );
            //revenueClassRule = new DataExistsRule( account.AccountNumber, "Revenue Class", account.RevenueClass );
			loadShapeIDRule = new DataExistsRule( account.AccountNumber, "Load Shape ID", account.LoadShapeId );
            //gridRule = new DataExistsRule( account.AccountNumber, "Grid", account.Grid );
            //taxJurisdictionRule = new DataExistsRule( account.TaxJurisdiction, "Tax Jurisdiction", account.TaxJurisdiction );
            //taxDistrictRule = new DataExistsRule( account.AccountNumber, "Tax District", account.TaxDistrict );

            //mailingAddresStreetRule = new DataExistsRule( account.AccountNumber, "Mailing Address - Street", account.Address.Street );
            //mailingAddresCityRule = new DataExistsRule( account.AccountNumber, "Mailing Address - City", account.Address.CityName );
            //mailingAddresZipCodeRule = new DataExistsRule( account.AccountNumber, "Mailing Address - ZipCode",
            //    (account.Address as UsGeographicalAddress).ZipCode );

            //serviceAddressCityRule = new DataExistsRule( account.AccountNumber, "Service Address - City", account.ServiceAddress.CityName );
            //serviceAddressStreetRule = new DataExistsRule( account.AccountNumber, "Service Address - Street", account.ServiceAddress.Street );
            //serviceAddressZipCodeRule = new DataExistsRule( account.AccountNumber, "Service Address - ZipCode",
            //    (account.ServiceAddress as UsGeographicalAddress).ZipCode );

			string accountNumber = account.AccountNumber;

            //if( !currentRateRule.Validate() )
            //    AddException( currentRateRule.Exception );

            //if( !futureRateRule.Validate() )
            //    AddException( futureRateRule.Exception );

            //if( !revenueClassRule.Validate() )
            //    AddException( revenueClassRule.Exception );

			if( !loadShapeIDRule.Validate() )
				AddException( loadShapeIDRule.Exception );

            //if( !gridRule.Validate() )
            //    AddException( gridRule.Exception );

            //if( !taxJurisdictionRule.Validate() )
            //    AddException( taxJurisdictionRule.Exception );

            //if( !taxDistrictRule.Validate() )
            //    AddException( taxDistrictRule.Exception );

            //if( !mailingAddresCityRule.Validate() )
            //    AddException( mailingAddresCityRule.Exception );

            //if( !mailingAddresStreetRule.Validate() )
            //    AddException( mailingAddresStreetRule.Exception );

            //if( !mailingAddresZipCodeRule.Validate() )
            //    AddException( mailingAddresZipCodeRule.Exception );

            //if( !serviceAddressCityRule.Validate() )
            //    AddException( serviceAddressCityRule.Exception );

            //if( !serviceAddressStreetRule.Validate() )
            //    AddException( serviceAddressStreetRule.Exception );

            //if( !serviceAddressZipCodeRule.Validate() )
            //    AddException( serviceAddressZipCodeRule.Exception );

			RgeUsageListDataExistsRule usageRule = new RgeUsageListDataExistsRule( accountNumber, account.WebUsageList );
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
