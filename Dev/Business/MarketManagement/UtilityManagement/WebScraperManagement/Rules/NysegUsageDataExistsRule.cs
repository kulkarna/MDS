namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Runtime.InteropServices;
	using LibertyPower.Business.CommonBusiness.CommonRules;

	[Guid( "EB35B98D-B493-47af-AC18-2AA95D171EEA" )]
	public class NysegUsageDataExistsRule : BusinessRule
	{
		private string accountNumber;
		private NysegUsage usage;

		/// <summary>
		/// Constructor that takes an account number and a web usage object
		/// </summary>
		/// <param name="accountNumber">Account identifier</param>
		/// <param name="usage">Web usage object</param>
		public NysegUsageDataExistsRule( string accountNumber, NysegUsage usage )
			: base( "Data Exists Rule", BrokenRuleSeverity.Information )
		{
			this.accountNumber = accountNumber;
			this.usage = usage;
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Validates the parameter(s) passed in to the constructor returning a boolean indicating success or failure.
		/// </summary>
		/// <returns>Returns a boolean indicating success or failure.</returns>
		public override bool Validate()
		{
			DataExistsRule beginDateRule = new DataExistsRule( accountNumber, "Begin Date", Convert.ToDateTime( usage.BeginDate ) );
			DataExistsRule endDateRule = new DataExistsRule( accountNumber, "End Date", Convert.ToDateTime( usage.EndDate ) );
			DataExistsRule kwhOnRule = new DataExistsRule( accountNumber, "Kwh On", (int) Convert.ToInt32( usage.KwhOn ) );
			//DataExistsRule kw = new DataExistsRule( accountNumber, "Kw", (int) Convert.ToInt32( usage.Kw ) );
			DataExistsRule kwh = new DataExistsRule( accountNumber, "Kwh", (int) Convert.ToInt32( usage.Kwh ) );
			DataExistsRule totalRule = new DataExistsRule( accountNumber, "Total", (int) Convert.ToInt32( usage.Total ) );

			if( !beginDateRule.ValidateDate() )
				AddException( beginDateRule.Exception );

			if( !endDateRule.ValidateDate() )
				AddException( endDateRule.Exception );

			if( !kwhOnRule.ValidateNumber() )
				AddException( kwhOnRule.Exception );

            //if( !kw.ValidateNumber() )
            //    AddException( kw.Exception );

			if( !kwh.ValidateNumber() )
				AddException( kwh.Exception );

			if( !totalRule.ValidateNumber() )
				AddException( totalRule.Exception );

			usage.UsageDataExistsRule = this;

			return this.Exception == null;
		}

		// ------------------------------------------------------------------------------------
		private void AddException( BrokenRuleException exception )
		{
			if( this.Exception == null )
				this.SetException( "Missing data." );

			this.DefaultSeverity = BrokenRuleSeverity.Error;

			this.AddDependentException( exception );
		}
	}
}
