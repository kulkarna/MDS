namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;
	using System.Runtime.InteropServices;
	using LibertyPower.Business.CommonBusiness.CommonRules;

	/// <summary>
	/// Business rule that ensures that the utility configuration object exists.
	/// </summary>
	[Guid( "9F304811-FEEA-4962-99B8-4CED3FB4CB19" )]
	public class UtilityConfigExistsRule : BusinessRule
	{
		private UtilityConfig config;

		/// <summary>
		/// Constructor that takes a utility configuration object
		/// </summary>
		/// <param name="config">Utility configuration object</param>
		public UtilityConfigExistsRule( UtilityConfig config )
			: base( "Utility Config Exists Rule", BrokenRuleSeverity.Information )
		{
			this.config = config;
		}

		/// <summary>
		/// Validates the parameter(s) passed in to the constructor returning a boolean indicating success or failure.
		/// </summary>
		/// <returns>Returns a boolean indicating success or failure.</returns>
		public override bool Validate()
		{
			if( config == null )
			{
				this.DefaultSeverity = BrokenRuleSeverity.Error;
				this.SetException( "Utility configuration not found." );
			}
			return this.Exception == null;
		}
	}
}
