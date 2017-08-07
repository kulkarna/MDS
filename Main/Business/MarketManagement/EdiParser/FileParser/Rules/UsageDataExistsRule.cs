namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;
	using System.Runtime.InteropServices;
	using LibertyPower.Business.CommonBusiness.CommonRules;

	/// <summary>
	/// Business rule that ensures that usage data exists.
	/// </summary>
	[Guid( "C07091E6-8C93-4ec7-A152-A654365A964D" )]
	public class UsageDataExistsRule : BusinessRule
	{
		private string accountNumber;
		private EdiUsage usage;

		/// <summary>
		/// Constructor that takes an account number and a edi usage object
		/// </summary>
		/// <param name="accountNumber">Account identifier</param>
		/// <param name="usage">Edi usage object</param>
		public UsageDataExistsRule( string accountNumber, EdiUsage usage )
			: base( "Data Exists Rule", BrokenRuleSeverity.Information )
		{
			this.accountNumber = accountNumber;
			this.usage = usage;
		}

		/// <summary>
		/// Validates the parameter(s) passed in to the constructor returning a boolean indicating success or failure.
		/// </summary>
		/// <returns>Returns a boolean indicating success or failure.</returns>
		public override bool Validate()
		{
			string transactionSetPurposeCode = usage.TransactionSetPurposeCode;

			DataExistsRule rule = new DataExistsRule( accountNumber, "Begin Date", usage.BeginDate.ToString());
			if( !rule.ValidateByType( usage.BeginDate ) )
				AddException( rule.Exception );

			rule = new DataExistsRule( accountNumber, "End Date", usage.EndDate.ToString() );
			if( !rule.ValidateByType( usage.EndDate ) )
				AddException( rule.Exception );

			rule = new DataExistsRule( accountNumber, "Quantity", usage.Quantity.ToString() );
			if( !rule.ValidateByType( usage.Quantity ) )
				AddException( rule.Exception );

			rule = new DataExistsRule( accountNumber, "Measurement Significance Code", usage.MeasurementSignificanceCode );
			if( !rule.ValidateByType( usage.MeasurementSignificanceCode ) )
				AddException( rule.Exception, transactionSetPurposeCode );

			rule = new DataExistsRule( accountNumber, "Unit Of Measurement", usage.UnitOfMeasurement );
			if( !rule.ValidateByType( usage.UnitOfMeasurement ) )
				AddException( rule.Exception, transactionSetPurposeCode );

			rule = new DataExistsRule( accountNumber, "Transaction Set Purpose Code", usage.TransactionSetPurposeCode );
			if( !rule.ValidateByType( usage.TransactionSetPurposeCode ) )
				AddException( rule.Exception );

			usage.UsageDataExistsRule = this;

			return this.Exception == null;
		}

		private void AddException( BrokenRuleException exception )
		{
			if( this.Exception == null )
				this.SetException( "Missing data." );

			this.DefaultSeverity = BrokenRuleSeverity.Error;

			this.AddDependentException( exception );
		}

		private void AddException( BrokenRuleException exception, string transactionSetPurposeCode )
		{
			if( this.Exception == null )
				this.SetException( "Missing data." );

			// if historical usage, must have data
			if( transactionSetPurposeCode.Equals( "52" ) )
			{
				if( exception.Message.Contains( "Unit Of Measurement" ) )
				{
					exception.Severity = BrokenRuleSeverity.Warning;
					this.DefaultSeverity = BrokenRuleSeverity.Warning;
				}
				else
				{
					exception.Severity = BrokenRuleSeverity.Error;
					this.DefaultSeverity = BrokenRuleSeverity.Error;
				}
			}
			else // if not historical usage, then just a warning
			{
				exception.Severity = BrokenRuleSeverity.Warning;
				this.DefaultSeverity = BrokenRuleSeverity.Warning;
			}

			this.AddDependentException( exception );
		}
	}
}
