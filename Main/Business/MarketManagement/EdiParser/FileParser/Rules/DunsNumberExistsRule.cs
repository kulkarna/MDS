namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;
	using System.Runtime.InteropServices;
	using LibertyPower.Business.CommonBusiness.CommonRules;

	/// <summary>
	/// Business rule that ensures that the DUNS number exists
	/// </summary>
	[Guid( "2517A19F-99A1-40d8-AD7B-C0143EC8E667" )]
	public class DunsNumberExistsRule : BusinessRule
	{
		private string dunsNumber;

		/// <summary>
		/// Constructor that takes a DUNS number
		/// </summary>
		/// <param name="dunsNumber">DUNS number</param>
		public DunsNumberExistsRule( string dunsNumber )
			: base( "Duns Number Exists Rule", BrokenRuleSeverity.Information )
		{
			this.dunsNumber = dunsNumber;
		}

		/// <summary>
		/// Validates the parameter(s) passed in to the constructor returning a boolean indicating success or failure.
		/// </summary>
		/// <returns>Returns a boolean indicating success or failure.</returns>
		public override bool Validate()
		{
			if( dunsNumber.Trim().Length.Equals( 0 ) )
			{
				this.DefaultSeverity = BrokenRuleSeverity.Error;
				this.SetException( "No DUNS number found." );
			}

			return this.Exception == null;
		}
	}
}
