namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Runtime.InteropServices;
	using LibertyPower.Business.CommonBusiness.CommonRules;

	[Guid( "249E9D21-D962-4e17-9CEF-E86BC20F8576" )]
	public class ConedUsageDataExistsRule : BusinessRule
	{
		private string accountNumber;
		private ConedUsage usage;

		/// <summary>
		/// Constructor that takes an account number and a edi usage object
		/// </summary>
		/// <param name="accountNumber">Account identifier</param>
		/// <param name="usage">Edi usage object</param>
		public ConedUsageDataExistsRule( string accountNumber, ConedUsage usage )
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
			DataExistsRule rule = new DataExistsRule( accountNumber, "Begin Date", Convert.ToDateTime( usage.BeginDate ) );
			if( !rule.ValidateDate() )
				AddException( rule.Exception );

			rule = new DataExistsRule( accountNumber, "End Date", Convert.ToDateTime( usage.EndDate ));
			if( !rule.ValidateDate() )
				AddException( rule.Exception );

            //rule = new DataExistsRule( accountNumber, "Bill Amount", Convert.ToInt32( usage.BillAmount ) );
            //if( !rule.ValidateNumber() )
            //    AddException( rule.Exception );

			rule = new DataExistsRule( accountNumber, "Total Kwh", Convert.ToInt32( usage.TotalKwh ) );
			if( !rule.ValidateNumber() )
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

	}
}
