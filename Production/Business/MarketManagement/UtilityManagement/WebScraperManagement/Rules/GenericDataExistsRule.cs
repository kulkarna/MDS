namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;
	using System.Runtime.InteropServices;

	using LibertyPower.Business.CommonBusiness.CommonRules;

	/// <summary>
	///This class is part of the implementation of Composite design pattern.
	///It represents a single validation rule. It can be a rule for validation of string data,
	///numerical data validation, etc.
	/// </summary>
	/// <typeparam name="TData">The type of the data wich is going to be validated</typeparam>
	[Guid( "FD0D8626-802E-4746-B1F8-E0731E47AD40" )]
	public abstract class GenericDataExistsRule<TData> : BusinessRule
	{
		private   string dataDescription;
		protected TData  target;

		/// <summary>
		/// Message for a broken rule
		/// </summary>
		public virtual string BrokenRuleMessage
		{
			get { return "Missing data - " + dataDescription + "."; }
		}

		/// <summary>
		/// Contructor that receives the data to be validated
		/// and its description.
		/// </summary>
		/// <param name="target">Data to be validated</param>
		/// <param name="dataDescription">The description of the data to be validated</param>
		public GenericDataExistsRule( TData target, string dataDescription )
			: this( "Data Exists Rule", BrokenRuleSeverity.Error, target, dataDescription )
		{
		}

		/// <summary>
		/// Constructor that receives the severity of the rule,
		/// the data to be validated and its description
		/// </summary>
		/// <param name="defaultSeverity">Default severity of the rule</param>
		/// <param name="target">Data to be validated</param>
		/// <param name="dataDescription">The description of tedata to be validated</param>
		public GenericDataExistsRule( BrokenRuleSeverity defaultSeverity, TData target, string dataDescription )
			: this( "Data Exists Rule", defaultSeverity, target, dataDescription )
		{
		}

		/// <summary>
		/// Constructor that receives the name of the rule, its severity,
		/// the data to be validated and its description
		/// </summary>
		/// <param name="ruleName">The name of the rule</param>
		/// <param name="defaultSeverity">Te severity of the rule</param>
		/// <param name="target">The data to be validated</param>
		/// <param name="dataDescription">The description of the data</param>
		public GenericDataExistsRule( string ruleName, BrokenRuleSeverity defaultSeverity, TData target, string dataDescription )
			: base( ruleName, defaultSeverity )
		{
			this.target = target;
			this.dataDescription = dataDescription;
		}
	}
}
