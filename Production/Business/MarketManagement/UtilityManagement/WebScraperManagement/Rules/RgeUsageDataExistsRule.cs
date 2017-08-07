namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;
	using System.Runtime.InteropServices;

	using LibertyPower.Business.CommonBusiness.CommonRules;

	[Guid( "3E2E27AA-F844-45f5-949E-30E50E4B08CD" )]
	public class RgeUsageDataExistsRule : BusinessRule
	{
		private string accountNumber;
		private RgeUsage usage;

		/// <summary>
		/// Constructor that takes an account number and a edi usage object
		/// </summary>
		/// <param name="accountNumber">Account identifier</param>
		/// <param name="usage">Edi usage object</param>
		public RgeUsageDataExistsRule( string accountNumber, RgeUsage usage )
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
			DataExistsRule beginDateRule;
			DataExistsRule endDateRule;
			DataExistsRule kwhOnRule;
			DataExistsRule kwhOffRule;
			DataExistsRule kwhMidRule;
			DataExistsRule kwOnRule;
			DataExistsRule kwOffRule;
			DataExistsRule meterNumberRule;
			DataExistsRule totalRule;
			DataExistsRule totalTaxRule;

			beginDateRule = new DataExistsRule( accountNumber, "Begin Date", usage.BeginDate );
			endDateRule = new DataExistsRule( accountNumber, "End Date", usage.EndDate );
            //kwhOnRule = new DataExistsRule( accountNumber, "Kwh On", (int) usage.KwhOn );
            //kwhOffRule = new DataExistsRule( accountNumber, "Kwh Off", (int) usage.KwhOff );
            //kwhMidRule = new DataExistsRule( accountNumber, "Kwh Mid", (int) usage.KwhMid );
            //kwOnRule = new DataExistsRule( accountNumber, "Kw On", (int) usage.KwOn );
            //kwOffRule = new DataExistsRule( accountNumber, "Kw Off", (int) usage.KwOff );
            //meterNumberRule = new DataExistsRule( accountNumber, "Meter Number", usage.MeterNumber );
			totalRule = new DataExistsRule( accountNumber, "Total", (int) usage.Total );
			//totalTaxRule = new DataExistsRule( accountNumber, "Total Tax", (int) usage.TotalTax );

			if( !beginDateRule.ValidateDate() )
				AddException( beginDateRule.Exception );

			if( !endDateRule.ValidateDate() )
				AddException( endDateRule.Exception );

            //if( !kwhOnRule.ValidateNumber() )
            //    AddException( kwhOnRule.Exception );

            //if( !kwhOffRule.ValidateNumber() )
            //    AddException( kwhOffRule.Exception );

            //if( !kwhMidRule.ValidateNumber() )
            //    AddException( kwhMidRule.Exception );

            //if( !kwOnRule.ValidateNumber() )
            //    AddException( kwOnRule.Exception );

            //if( !kwOffRule.ValidateNumber() )
            //    AddException( kwOffRule.Exception );

            //if( !meterNumberRule.Validate() )
            //    AddException( meterNumberRule.Exception );

			if( !totalRule.ValidateNumber() )
				AddException( totalRule.Exception );

            //if( !totalTaxRule.ValidateNumber() )
            //    AddException( totalTaxRule.Exception );

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
	}
}
