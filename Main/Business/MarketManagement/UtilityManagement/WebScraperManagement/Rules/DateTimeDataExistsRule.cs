namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Runtime.InteropServices;

	using LibertyPower.Business.CommonBusiness.CommonRules;

	/// <summary>
	/// Validates if a date is not DateTime.MinValue.
	/// </summary>
	[Guid( "98F57CD7-2055-4e26-A211-7C58C0FD4742" )]
	public class DateTimeDataExistsRule : GenericDataExistsRule<DateTime>
	{
		/// <summary>
		/// Constructor that receives the name of the rule, its severity, the data to be validated and its description
		/// </summary>
		/// <param name="ruleName">The name of the rule</param>
		/// <param name="severity">Te severity of the rule</param>
		/// <param name="target">The data to be validated</param>
		/// <param name="dataDescription">The description of the data</param>
		public DateTimeDataExistsRule( string ruleName, BrokenRuleSeverity severity, DateTime target, string dataDescription )
			: base( ruleName, severity, target, dataDescription )
		{
		}

		/// <summary>
		/// Constructor that receives severity, the data to be validated and its description
		/// </summary>
		/// <param name="severity">Te severity of the rule</param>
		/// <param name="target">The data to be validated</param>
		/// <param name="dataDescription">The description of the data</param>
		public DateTimeDataExistsRule( BrokenRuleSeverity severity, DateTime target, string dataDescription )
			: this( "DateTime Data Rule", severity, target, dataDescription )
		{
		}

		public override bool Validate()
		{
			if( !( target != DateTime.MinValue ) )
				SetException( BrokenRuleMessage );

			return Exception == null;
		}
	}
}
