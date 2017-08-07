namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;
	using System.Runtime.InteropServices;
	using LibertyPower.Business.CommonBusiness.CommonRules;

	/// <summary>
	/// Business rule that ensures that the config data needed for utility exists.
	/// </summary>
	[Guid( "612C7E13-9441-4691-BDA4-54658A1710EE" )]
	public class FileConfigDataExistsRule : BusinessRule
	{
		private string dunsNumber;
		private string fileContent;
		private char delimiter;
		private UtilityConfig config;

		/// <summary>
		/// Constructor that takes a DUNS number, file content, character delimiter 
		/// and utility configuration object.
		/// </summary>
		/// <param name="dunsNumber">DUNS number</param>
		/// <param name="fileContent">Contents of file</param>
		/// <param name="delimiter">Character delimiter</param>
		/// <param name="config">Utility configuration object</param>
		public FileConfigDataExistsRule( string dunsNumber, ref string fileContent, char delimiter, UtilityConfig config )
			: base( "File Config Data Exists Rule", BrokenRuleSeverity.Information )
		{
			this.dunsNumber = dunsNumber;
			this.fileContent = fileContent;
			this.delimiter = delimiter;
			this.config = config;
		}

		/// <summary>
		/// Validates the parameter(s) passed in to the constructor returning a boolean indicating success or failure.
		/// </summary>
		/// <returns>Returns a boolean indicating success or failure.</returns>
		public override bool Validate()
		{
			UtilityConfigExistsRule ruleConfig = new UtilityConfigExistsRule( config );
			if( !ruleConfig.Validate() ) // if no config, then can't determine the rest.
				AddException( ruleConfig.Exception );
			else 
			{
				FileNotTruncatedRule ruleTruncated = new FileNotTruncatedRule( ref fileContent, delimiter );
				if( !ruleTruncated.Validate() )
					AddException( ruleTruncated.Exception );

				DunsNumberExistsRule ruleDuns = new DunsNumberExistsRule( dunsNumber );
				if( !ruleDuns.Validate() )
					AddException( ruleDuns.Exception );

				FieldDelimiterExistsRule ruleDelimiter = new FieldDelimiterExistsRule( config, delimiter );
				if( !ruleDelimiter.Validate() )
					AddException( ruleDelimiter.Exception );
			}


			return this.Exception == null;
		}

		private void AddException( BrokenRuleException exception )
		{
			if( this.Exception == null )
				this.SetException( "Missing file configuration data" );

			this.DefaultSeverity = BrokenRuleSeverity.Error;

			this.AddDependentException( exception );
		}
	}
}
