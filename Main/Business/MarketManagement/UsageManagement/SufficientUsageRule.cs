namespace LibertyPower.Business.MarketManagement.UsageManagement
{
	using System;
	using System.Runtime.InteropServices;
	using LibertyPower.Business.CommonBusiness.CommonRules;
	using LibertyPower.Business.MarketManagement.UtilityManagement;

	/// <summary>
	/// Rule that ensures usage is available for profiling
	/// </summary>
	[Guid( "E720E79A-BBDA-424f-ABF3-5C28A8EB4957" )]
	public class SufficientUsageRule : BusinessRule
	{
		private string accountNumber;
		private string utilityCode;
		private UsageList legacyUsage;
		private UsageList consolidatedUsage;

		/// <summary>
		/// Verify that there are at least 364 consecutive days of profiles
		/// </summary>
		/// <param name="fileName">File name</param>
		/// <param name="dates">List of dates to validate</param>
		public SufficientUsageRule( string accountNumber, string utilityCode,
			UsageList legacyUsage, UsageList consolidatedUsage )
			: base( "Sufficient Usage Rule", BrokenRuleSeverity.Error )
		{
			this.accountNumber = accountNumber;
			this.utilityCode = utilityCode;
			this.legacyUsage = legacyUsage;
			this.consolidatedUsage = consolidatedUsage;
		}

		public override bool Validate()
		{
			if( legacyUsage == null & consolidatedUsage == null )
			{
				string format = "{0} ({1}) has no usage available.";
				this.SetException( String.Format( format, accountNumber, utilityCode ) );
			}

			return this.Exception == null;
		}
	}
}
