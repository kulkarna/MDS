namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;
	using System.Text.RegularExpressions;
	using System.Runtime.InteropServices;
	using LibertyPower.Business.CommonBusiness.CommonRules;

	/// <summary>
	/// Business rule that ensures that the utility file is not truncated.
	/// </summary>
	[Guid( "F7A8BCA4-A4AC-4047-B3BF-B79F6E192B98" )]
	public class FileNotTruncatedRule : BusinessRule
	{
		private string fileContent;
		private char delimiter;

		/// <summary>
		/// Constructor that takes the file content and character delimiter
		/// </summary>
		/// <param name="fileContent">Contents of file</param>
		/// <param name="delimiter">Character delimiter</param>
		public FileNotTruncatedRule( ref string fileContent, char delimiter )
			: base( "File Not Truncated Rule", BrokenRuleSeverity.Information )
		{
			this.fileContent = fileContent;
			this.delimiter = delimiter;
		}

		/// <summary>
		/// Validates the parameter(s) passed in to the constructor returning a boolean indicating success or failure.
		/// </summary>
		/// <returns>Returns a boolean indicating success or failure.</returns>
		public override bool Validate()
		{
			string pattern = @"IEA\" + delimiter + @"1\" + delimiter + @"\d+";

			Regex r = new Regex( pattern );

			// Match the pattern within the file content.
			Match m = r.Match( fileContent );

			if( m.Value.Length.Equals(0) )
			{
				this.DefaultSeverity = BrokenRuleSeverity.Error;
				this.SetException( "File truncated, no end tag found." );
			}

			return this.Exception == null;
		}
	}
}
