namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;
	using LibertyPower.Business.CommonBusiness.CommonRules;


	/// <summary>
	/// Data missing exception that inherits from BrokenRuleException
	/// </summary>
	public class DataMissingException : BrokenRuleException
	{
		/// <summary>
		/// 
		/// </summary>
		public DataMissingException( BusinessRule brokenRule ) : base( brokenRule ) { }
		/// <summary>
		/// 
		/// </summary>
		/// <param name="brokenRule"></param>
		/// <param name="message"></param>
		public DataMissingException( BusinessRule brokenRule, string message ) : base( brokenRule, message ) { }
		/// <summary>
		/// 
		/// </summary>
		/// <param name="brokenRule"></param>
		/// <param name="message"></param>
		/// <param name="severity"></param>
		public DataMissingException( BusinessRule brokenRule, string message, BrokenRuleSeverity severity ) : base( brokenRule, message, severity ) { }
	}
}
