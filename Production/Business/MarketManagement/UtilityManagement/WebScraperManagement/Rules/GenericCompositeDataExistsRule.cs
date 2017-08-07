namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System.Collections.Generic;
	using System.Text;
	using System.Runtime.InteropServices;

	using LibertyPower.Business.CommonBusiness.CommonRules;

	/// <summary>
	/// This class is part of the implementation of Composite design pattern.
	/// It represents a composition of validation rules. It can be a rule for validation of complex data like WebUsage, WebAccount, etc.
	/// </summary>
	/// <typeparam name="TData">The type of the data wich is going to be validated</typeparam>
	[Guid( "A9B3DF9B-FFE8-44b4-873C-77AF797908BD" )]
	public abstract class GenericCompositeDataExistsRule<TData> : GenericDataExistsRule<TData>
	{
		private bool               isBroken;
		private List<BusinessRule> dataValidationRules;

		/// <summary>
		/// Contructor that receives the data to be validated and its description.
		/// </summary>
		/// <param name="target">Data to be validated</param>
		/// <param name="dataDescription">The description of the data to be validated</param>
		public GenericCompositeDataExistsRule( TData target, string dataDescription )
			: this( "Composite Data Exists Rule", BrokenRuleSeverity.Error, target, dataDescription )
		{
		}

		/// <summary>
		/// Constructor that receives the severity of the rule, the data to be validated and its description
		/// </summary>
		/// <param name="defaultSeverity">Default severity of the rule</param>
		/// <param name="target">Data to be validated</param>
		/// <param name="dataDescription">The description of tedata to be validated</param>
		public GenericCompositeDataExistsRule( BrokenRuleSeverity defaultSeverity, TData target, string dataDescription )
			: this( "Composite Data Exists Rule", defaultSeverity, target, dataDescription )
		{
		}

		/// <summary>
		/// Constructor that receives the name of the rule, its severity, the data to be validated and its description
		/// </summary>
		/// <param name="ruleName">The name of the rule</param>
		/// <param name="defaultSeverity">Te severity of the rule</param>
		/// <param name="target">The data to be validated</param>
		/// <param name="dataDescription">The description of the data</param>
		public GenericCompositeDataExistsRule( string ruleName, BrokenRuleSeverity defaultSeverity, TData target, string dataDescription ) :
			base( ruleName, defaultSeverity, target, dataDescription )
		{
			dataValidationRules = new List<BusinessRule>();
		}

		protected void AddDataValidationRule( BusinessRule rule )
		{
			dataValidationRules.Add( rule );
		}

		/// <summary>
		/// Validates all the rules in this composition. If one of the rules in the composition is broken then it add's a new dependent exception.
		/// </summary>
		/// <returns>Returns true if the data is valid(exists) and false if it is not.</returns>
		public override bool Validate()
		{
			foreach( BusinessRule rule in dataValidationRules )
			{
				if( !rule.Validate() )
				{
					if( !isBroken )
					{
						isBroken = true;
						SetException( BrokenRuleMessage );
					}

					AddDependentException( rule.Exception );
				}
			}

			return this.Exception == null;
		}
	}
}
