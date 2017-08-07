namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using LibertyPower.Business.CommonBusiness.CommonRules;

	using System.Runtime.InteropServices;

	/// <summary>
	/// Validates if a string is null or empty.
	/// </summary>
	[Guid( "5558CCBC-C3D1-42a3-B60E-AEB27C441CAC" )]
	public class StringDataExistsRule : GenericDataExistsRule<string>
	{
		/// <summary>
		/// Constructor that receives the name of the rule, its severity,
		/// the data to be validated and its description
		/// </summary>
		/// <param name="ruleName">The name of the rule</param>
		/// <param name="severity">Te severity of the rule</param>
		/// <param name="target">The data to be validated</param>
		/// <param name="dataDescription">The description of the data</param>
		public StringDataExistsRule( string ruleName, BrokenRuleSeverity severity, string target, string dataDescription )
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
		public StringDataExistsRule( BrokenRuleSeverity severity, string target, string dataDescription )
			: this( "String Data Rule", severity, target, dataDescription )
		{
		}

		/// <summary>
		/// Validates if a string is null or empty.
		/// </summary>
		/// <returns>Returns false if the string is null or empty and true if it is not</returns>
		public override bool Validate()
		{
			if( !( ( target != null ) && ( target.Trim().Length > 0 ) ) )
				SetException( BrokenRuleMessage );

			return Exception == null;
		}
	}
}
