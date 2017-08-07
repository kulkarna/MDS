namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;
	using System.Runtime.InteropServices;

	using LibertyPower.Business.CommonBusiness.CommonRules;

	[Guid( "29447EE2-7734-4f70-AAAB-9EE96C07BEB8" )]
	public class NimoUsageDataExistsRule : BusinessRule
	{
		private string accountNumber;
		private NimoUsage usage;

		/// <summary>
		/// Constructor that takes an account number and a nimo usage object
		/// </summary>
		/// <param name="accountNumber">Account identifier</param>
		/// <param name="usage">nimo usage object</param>
		public NimoUsageDataExistsRule( string accountNumber, NimoUsage usage )
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
			DataExistsRule billCodeRule;
			DataExistsRule daysRule;
			DataExistsRule billedKwhTotal;
			DataExistsRule meteredPeakKw;
			DataExistsRule meteredOnPeakKw;
			DataExistsRule billedPeakKw;
			DataExistsRule billedOnPeakKw;
			DataExistsRule billDetailAmtRule;
			DataExistsRule billedRkvaRule;
			DataExistsRule onPeakKwhRule;
			DataExistsRule offPeakKwhRule;
			DataExistsRule shoulderKwhRule;
			DataExistsRule offSeasonKwhRule;

			beginDateRule = new DataExistsRule( accountNumber, "Begin Date", usage.BeginDate );
			endDateRule = new DataExistsRule( accountNumber, "End Date", usage.EndDate );
			billCodeRule = new DataExistsRule( accountNumber, "Bill Code", usage.BillCode );
			daysRule = new DataExistsRule( accountNumber, "Days", usage.Days );
			billedKwhTotal = new DataExistsRule( accountNumber, "Billed Kwh Total", (int) usage.BilledKwhTotal );
			meteredPeakKw = new DataExistsRule( accountNumber, "Metered Peak Kw", (int) usage.MeteredPeakKw );
			meteredOnPeakKw = new DataExistsRule( accountNumber, "Metered On Peak Kw", (int) usage.MeteredOnPeakKw );
			billedPeakKw = new DataExistsRule( accountNumber, "Billed Peak Kw", (int) usage.BilledPeakKw );
			billedOnPeakKw = new DataExistsRule( accountNumber, "Billed On Peak Kw", (int) usage.BilledOnPeakKw );
			billDetailAmtRule = new DataExistsRule( accountNumber, "Bill Detail Amt", (int) usage.BillDetailAmt );
			billedRkvaRule = new DataExistsRule( accountNumber, "Billed Rkva", (int) usage.BilledRkva );
			onPeakKwhRule = new DataExistsRule( accountNumber, "On Peak Kwh", (int) usage.OnPeakKwh );
			offPeakKwhRule = new DataExistsRule( accountNumber, "Off Peak Kwh", (int) usage.OffPeakKwh );
			shoulderKwhRule = new DataExistsRule( accountNumber, "Shoulder Kwh", (int) usage.ShoulderKwh );
			offSeasonKwhRule = new DataExistsRule( accountNumber, "Off Season Kwh", (int) usage.OffSeasonKwh );

			if( !beginDateRule.ValidateDate() )
				AddException( beginDateRule.Exception );

			if( !endDateRule.ValidateDate() )
				AddException( endDateRule.Exception );

			if( !billCodeRule.Validate() )
				AddException( billCodeRule.Exception );

			if( !daysRule.ValidateNumber() )
				AddException( daysRule.Exception );

			if( !billedKwhTotal.ValidateNumber() )
				AddException( billedKwhTotal.Exception );

			if( !meteredPeakKw.ValidateNumber() )
				AddException( meteredPeakKw.Exception );

			if( !meteredOnPeakKw.ValidateNumber() )
				AddException( meteredOnPeakKw.Exception );

			if( !billedPeakKw.ValidateNumber() )
				AddException( billedPeakKw.Exception );

			if( !billedOnPeakKw.ValidateNumber() )
				AddException( billedOnPeakKw.Exception );

			if( !billDetailAmtRule.ValidateNumber() )
				AddException( billDetailAmtRule.Exception );

			if( !billedRkvaRule.ValidateNumber() )
				AddException( billedRkvaRule.Exception );

			if( !onPeakKwhRule.ValidateNumber() )
				AddException( onPeakKwhRule.Exception );

			if( !offPeakKwhRule.ValidateNumber() )
				AddException( offPeakKwhRule.Exception );

			if( !shoulderKwhRule.ValidateNumber() )
				AddException( shoulderKwhRule.Exception );

			if( !offSeasonKwhRule.ValidateNumber() )
				AddException( offSeasonKwhRule.Exception );

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
