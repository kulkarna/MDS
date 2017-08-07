namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System.Runtime.InteropServices;

	using LibertyPower.Business.CommonBusiness.CommonRules;

	/// <summary>
	/// Validates if a numerical data is not -1. It applies to
	/// int and decimal data types.
	/// </summary>
	[Guid( "202EC28D-EF41-4baf-AA0A-E6C8429C5B14" )]
	public class NumericalDataExistsRule : GenericDataExistsRule<int>
	{
		/// <summary>
		/// Constructor that receives the name of the rule, its severity,
		/// the data to be validated and its description
		/// </summary>
		/// <param name="ruleName">The name of the rule</param>
		/// <param name="severity">Te severity of the rule</param>
		/// <param name="target">The data to be validated</param>
		/// <param name="dataDescription">The description of the data</param>
		public NumericalDataExistsRule( string ruleName, BrokenRuleSeverity severity, int target, string dataDescription )
			: base( ruleName, severity, target, dataDescription )
		{
		}

		/// <summary>
		/// Constructor that receives severity,
		/// the data to be validated and its description
		/// </summary>
		/// <param name="severity">Te severity of the rule</param>
		/// <param name="target">The data to be validated</param>
		/// <param name="dataDescription">The description of the data</param>
		public NumericalDataExistsRule( BrokenRuleSeverity severity, int target, string dataDescription )
			: this( "Numerical Data Rule", severity, target, dataDescription )
		{
		}

		/// <summary>
		/// Constructor that receives severity,
		/// the data to be validated and its description
		/// </summary>
		/// <param name="severity">Te severity of the rule</param>
		/// <param name="target">The data to be validated</param>
		/// <param name="dataDescription">The description of the data</param>
		public NumericalDataExistsRule( BrokenRuleSeverity severity, decimal target, string dataDescription )
			: this( "Numerical Data Rule", severity, ( int ) target, dataDescription )
		{
		}

		public override bool Validate()
		{
			if( !( target != -1 ) )
				SetException( BrokenRuleMessage );

			return Exception == null;
		}
	}
}
