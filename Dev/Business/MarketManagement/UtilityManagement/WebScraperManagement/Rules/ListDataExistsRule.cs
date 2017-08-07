namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Collections;
	using System.Runtime.InteropServices;

	using LibertyPower.Business.CommonBusiness.CommonRules;

	/// <summary>
	/// Validates if a list(IList) has content or not.
	/// </summary>
	[Guid( "82B452AE-1BD8-4f86-A7EC-FE25803BE27C" )]
	public class ListDataExistsRule : GenericDataExistsRule<IList>
	{
		/// <summary>
		/// Constructor that receives the name of the rule, its severity, the data to be validated and its description
		/// </summary>
		/// <param name="ruleName">The name of the rule</param>
		/// <param name="severity">Te severity of the rule</param>
		/// <param name="list">The data to be validated</param>
		/// <param name="dataDescription">The description of the data</param>
		public ListDataExistsRule( string ruleName, BrokenRuleSeverity severity, IList list, string dataDescription )
			: base( ruleName, severity, list, dataDescription )
		{
		}

		/// <summary>
		/// Validate if a list is null or empty.
		/// </summary>
		/// <returns>Returns false if the list is null or empty and true if it is not.</returns>
		public override bool Validate()
		{
			if( target == null || target.Count == 0 )
				SetException( BrokenRuleMessage );

			return this.Exception == null;
		}
	}
}
