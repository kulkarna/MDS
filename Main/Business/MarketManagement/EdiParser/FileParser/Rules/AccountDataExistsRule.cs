namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;
	using System.Runtime.InteropServices;
	using LibertyPower.Business.CommonBusiness.CommonRules;

	/// <summary>
	/// Business rule that ensures that account data exists
	/// </summary>
	[Guid( "6C4A0D9D-8BC4-4b2e-97A8-A7347B766417" )]
	public class AccountDataExistsRule : BusinessRule
	{
		private EdiAccount account;
		private EdiFileType ediFileType;

		/// <summary>
		/// Constructor that takes an edi account list + file type
		/// </summary>
		/// <param name="account">Edi account list</param>
		/// <param name="fileType">867/814, etc.</param>
		public AccountDataExistsRule( ref EdiAccount account, EdiFileType fileType )
			: base( "Account Data Exists Rule", BrokenRuleSeverity.Information )
		{
			this.account = account;
			ediFileType = fileType;
		}

		/// <summary>
		/// Validates the parameter(s) passed in to the constructor returning a boolean indicating success or failure.
		/// </summary>
		/// <returns>Returns a boolean indicating success or failure.</returns>
		public override bool Validate()
		{
			string accountNumber = account.AccountNumber;

			DataExistsRule rule = new DataExistsRule( accountNumber, "Bill Group", account.BillGroup.ToString() );
			if( !rule.ValidateByType( account.BillGroup ) )
				AddException( rule.Exception );

			rule = new DataExistsRule( accountNumber, "DUNS Number", account.DunsNumber );
			if( !rule.ValidateByType( account.DunsNumber ) )
				AddException( rule.Exception );

			rule = new DataExistsRule( accountNumber, "ICAP", account.Icap.ToString() );
			if( !rule.ValidateByType( account.Icap ) )
				AddException( rule.Exception );

			rule = new DataExistsRule( accountNumber, "Load Profile", account.LoadProfile );
			if( !rule.ValidateByType( account.LoadProfile ) )
				AddException( rule.Exception );

			if( ediFileType == EdiFileType.EightSixSeven )
			{
				rule = new DataExistsRule( accountNumber, "Name Key", account.NameKey );
				if( !rule.ValidateByType( account.NameKey ) )
					AddException( rule.Exception );
			}

			rule = new DataExistsRule( accountNumber, "Rate Class", account.RateClass );
			if( !rule.ValidateByType( account.RateClass ) )
				AddException( rule.Exception );

			rule = new DataExistsRule( accountNumber, "TCAP", account.Tcap.ToString() );
			if( !rule.ValidateByType( account.Tcap ) )
				AddException( rule.Exception );

			rule = new DataExistsRule( accountNumber, "Zone", account.ZoneCode );
			if( !rule.ValidateByType( account.ZoneCode ) )
				AddException( rule.Exception );

			if( ediFileType == EdiFileType.EightOneFour )
			{	// extra fields to validate..

				rule = new DataExistsRule( accountNumber, "Account Status", account.AccountStatus );
				if( !rule.ValidateByType( account.AccountStatus ) )
					AddException( rule.Exception );

				rule = new DataExistsRule( accountNumber, "Billing Account", account.BillingAccount );
				if( !rule.ValidateByType( account.BillingAccount ) )
					AddException( rule.Exception );

				rule = new DataExistsRule( accountNumber, "Billing Type", account.BillingType );
				if( !rule.ValidateByType( account.BillingType ) )
					AddException( rule.Exception );

				rule = new DataExistsRule( accountNumber, "Bill Calculation", account.BillCalculation );
				if( !rule.ValidateByType( account.BillCalculation ) )
					AddException( rule.Exception );

				rule = new DataExistsRule( accountNumber, "Service Period Start", account.ServicePeriodStart.ToString() );
				if( !rule.ValidateByType( account.ServicePeriodStart ) )
					AddException( rule.Exception );

				rule = new DataExistsRule( accountNumber, "Street Service Address", account.ServiceAddress.Street );
				if( !rule.ValidateByType( account.ServiceAddress.Street ) )
					AddException( rule.Exception );

				rule = new DataExistsRule( accountNumber, "Street Billing Address", account.BillingAddress.Street );
				if( !rule.ValidateByType( account.BillingAddress.Street ) )
					AddException( rule.Exception );

				rule = new DataExistsRule( accountNumber, "State", account.BillingAddress.State );
				if( !rule.ValidateByType( account.BillingAddress.State ) )
					AddException( rule.Exception );

				rule = new DataExistsRule( accountNumber, "Zip Code", account.BillingAddress.PostalCode );
				if( !rule.ValidateByType( account.BillingAddress.PostalCode ) )
					AddException( rule.Exception );

				rule = new DataExistsRule( accountNumber, "Anuual account", account.AnnualUsage.ToString() );
				if( !rule.ValidateByType( account.AnnualUsage ) )
					AddException( rule.Exception );

				rule = new DataExistsRule( accountNumber, "Months To Compute Kwh", account.MonthsToComputeKwh.ToString() );
				if( !rule.ValidateByType( account.MonthsToComputeKwh ) )
					AddException( rule.Exception );

				rule = new DataExistsRule( accountNumber, "Meter Type", account.MeterType );
				if( !rule.ValidateByType( account.MeterType ) )
					AddException( rule.Exception );

				rule = new DataExistsRule( accountNumber, "Meter Multiplier", account.MeterMultiplier.ToString() );
				if( !rule.ValidateByType( account.MeterMultiplier ) )
					AddException( rule.Exception );

				rule = new DataExistsRule( accountNumber, "Transaction Type", account.TransactionType );
				if( !rule.ValidateByType( account.TransactionType ) )
					AddException( rule.Exception );

				rule = new DataExistsRule( accountNumber, "Service Type", account.ServiceType );
				if( !rule.ValidateByType( account.ServiceType ) )
					AddException( rule.Exception );

				rule = new DataExistsRule( accountNumber, "Product Type", account.ProductType );
				if( !rule.ValidateByType( account.ProductType ) )
					AddException( rule.Exception );

			}

			account.AccountDataExistsRule = this;

			return this.Exception == null;
		}

		private void AddException( BrokenRuleException exception )
		{
			if( this.Exception == null )
				this.SetException( "Missing account data." );

			exception.Severity = BrokenRuleSeverity.Warning;
			this.DefaultSeverity = BrokenRuleSeverity.Warning;

			this.AddDependentException( exception );
			//Logger.LogAccountInfo( ediProcessLogID, account.AccountNumber, account.DunsNumber, exception.Message, exception.Severity );
		}
	}
}
