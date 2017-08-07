namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;
	using System.Runtime.InteropServices;

	using LibertyPower.Business.CommonBusiness.CommonRules;

	[Guid( "29447EE2-7734-4f70-AAAB-9EE96C07BEB8" )]
	public class ComedUsageDataExistsRule : BusinessRule
	{
		private string accountNumber;
		private ComedUsage usage;

		/// <summary>
		/// Constructor that takes an account number and a Comed usage object
		/// </summary>
		/// <param name="accountNumber">Account identifier</param>
		/// <param name="usage">Comed usage object</param>
		public ComedUsageDataExistsRule( string accountNumber, ComedUsage usage )
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
			DataExistsRule rateRule;
			DataExistsRule daysRule;
			DataExistsRule totalKwhRule;
			DataExistsRule onPeakKwhRule;
			DataExistsRule offPeakKwhRule;
			DataExistsRule billingDemandKwRule;
			DataExistsRule monthlyPeakDemandKw;

			beginDateRule = new DataExistsRule( accountNumber, "Begin Date", usage.BeginDate );
			endDateRule = new DataExistsRule( accountNumber, "End Date", usage.EndDate );
			rateRule = new DataExistsRule( accountNumber, "Rate", usage.Rate );
			daysRule = new DataExistsRule( accountNumber, "Days", usage.Days );
			totalKwhRule = new DataExistsRule( accountNumber, "Total Kwh", usage.TotalKwh );
			onPeakKwhRule = new DataExistsRule( accountNumber, "On Peak Kwh", (int) usage.OnPeakKwh );
			offPeakKwhRule = new DataExistsRule( accountNumber, "Off Peak Kwh", (int) usage.OffPeakKwh );
			billingDemandKwRule = new DataExistsRule( accountNumber, "Billing Demand Kw", (int) usage.BillingDemandKw );
			monthlyPeakDemandKw = new DataExistsRule( accountNumber, "Monthly Peak Demand Kw", (int) usage.MonthlyPeakDemandKw );

			if( !beginDateRule.ValidateDate() )
				AddException( beginDateRule.Exception );

			if( !endDateRule.ValidateDate() )
				AddException( endDateRule.Exception );

			if( !rateRule.Validate() )
				AddException( rateRule.Exception );

			//if( !daysRule.ValidateNumber() )
			//    AddException( daysRule.Exception );

			if( !totalKwhRule.ValidateNumber() )
				AddException( totalKwhRule.Exception );

			//if( !onPeakKwhRule.ValidateNumber() )
			//    AddException( onPeakKwhRule.Exception );

			//if( !offPeakKwhRule.ValidateNumber() )
			//    AddException( offPeakKwhRule.Exception );

			//if( !billingDemandKwRule.ValidateNumber() )
			//    AddException( billingDemandKwRule.Exception );

			//if( !monthlyPeakDemandKw.ValidateNumber() )
			//    AddException( monthlyPeakDemandKw.Exception );

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
