namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;
	using System.Runtime.InteropServices;
	using LibertyPower.Business.CommonBusiness.CommonRules;

	/// <summary>
	/// Business rule that ensures that the field delimiter exists.
	/// </summary>
	[Guid( "05E8715A-189B-4a05-B061-EC119DC73747" )]
	public class FieldDelimiterExistsRule : BusinessRule
	{
		private UtilityConfig config;
		private char delimiter;

		/// <summary>
		/// Constructor that takes a utility configuration object and delimiter
		/// </summary>
		/// <param name="config">Utility configuration object</param>
		/// <param name="delimiter">Character delimiter</param>
		public FieldDelimiterExistsRule( UtilityConfig config, char delimiter )
			: base( "Field Delimiter Exists Rule", BrokenRuleSeverity.Information )
		{
			this.config = config;
			this.delimiter = delimiter;
		}

		/// <summary>
		/// Validates the parameter(s) passed in to the constructor returning a boolean indicating success or failure.
		/// </summary>
		/// <returns>Returns a boolean indicating success or failure.</returns>
		public override bool Validate()
		{
			if( !delimiter.Equals( config.FieldDelimiter ) )
			{
				this.DefaultSeverity = BrokenRuleSeverity.Error;
				this.SetException( "Field delimiter for utility configuration not found in file." );
			}

			return this.Exception == null;
		}
	}
}
