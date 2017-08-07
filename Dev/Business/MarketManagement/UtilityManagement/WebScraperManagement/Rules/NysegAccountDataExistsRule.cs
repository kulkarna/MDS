namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Runtime.InteropServices;
	using LibertyPower.Business.CommonBusiness.CommonRules;
	using LibertyPower.Business.CommonBusiness.CommonEntity;

	[Guid( "3B085147-49F2-4560-851B-40FC2A7706D9" )]
	public class NysegAccountDataExistsRule : BusinessRule
	{
		private Nyseg account;

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Constructor that takes a Nyseg account list
		/// </summary>
		/// <param name="account">Nyseg account list</param>
		public NysegAccountDataExistsRule( Nyseg account )
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
			string accountNumber = account.AccountNumber;

            //DataExistsRule currentRateRule = new DataExistsRule( account.AccountNumber, "Current Rate Category", account.CurrentRateCategory );
            //DataExistsRule MeterRule = new DataExistsRule( account.AccountNumber, "Meter Number", account.WebUsageList.Count == 0 ? String.Empty : account.WebUsageList[0].MeterNumber );
            //DataExistsRule revenueClassRule = new DataExistsRule( account.AccountNumber, "Revenue Class", account.RevenueClass );
            DataExistsRule loadShapeIDRule = new DataExistsRule(account.AccountNumber, "Load Shape ID", account.LoadShapeId);
            //DataExistsRule gridRule = new DataExistsRule( account.AccountNumber, "Grid", account.Grid );
            //DataExistsRule taxJurisdictionRule = new DataExistsRule( account.TaxJurisdiction, "Tax Jurisdiction", account.TaxJurisdiction );
            //DataExistsRule taxDistrictRule = new DataExistsRule( account.AccountNumber, "Tax District", account.TaxDistrict );

            //DataExistsRule mailingAddresStreetRule = new DataExistsRule( account.AccountNumber, "Mailing Address - Street", account.Address.Street );
            //DataExistsRule mailingAddresCityRule = new DataExistsRule( account.AccountNumber, "Mailing Address - City", account.Address.CityName );
            //DataExistsRule mailingAddresZipCodeRule = new DataExistsRule( account.AccountNumber, "Mailing Address - ZipCode",
            //    (account.Address as UsGeographicalAddress).ZipCode );

            //DataExistsRule serviceAddressStreetRule = new DataExistsRule( account.AccountNumber, "Service Address - Street", account.ServiceAddress.Street );
            //DataExistsRule serviceAddressCityRule = new DataExistsRule( account.AccountNumber, "Service Address - City", account.ServiceAddress.CityName );
            //DataExistsRule serviceAddressZipCodeRule = new DataExistsRule( account.AccountNumber, "Service Address - ZipCode",
            //    (account.ServiceAddress as UsGeographicalAddress).ZipCode );

            //if( !currentRateRule.Validate() )
            //    AddException( currentRateRule.Exception );

            //if( !MeterRule.Validate() )
            //    AddException( MeterRule.Exception );

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

			NysegUsageListDataExistsRule usageRule = new NysegUsageListDataExistsRule( accountNumber, account.WebUsageList );
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
