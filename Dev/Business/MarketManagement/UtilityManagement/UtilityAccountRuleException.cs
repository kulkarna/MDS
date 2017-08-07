using System;
using LibertyPower.Business.CommonBusiness.CommonRules;

namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	[Serializable]
	public class UtilityAccountRuleException : BrokenRuleException
	{
		private UtilityAccount utilityAccount;

		public UtilityAccountRuleException( UtilityAccount account, BusinessRule brokenRule )
			: base( brokenRule )
		{
			this.utilityAccount = account;
		}

		public UtilityAccountRuleException( UtilityAccount account, BusinessRule brokenRule, string message )
			: base( brokenRule, message )
		{
			this.utilityAccount = account;
		}

		public UtilityAccountRuleException( UtilityAccount account, BusinessRule brokenRule, string message, BrokenRuleSeverity severity )
			: base( brokenRule, message, severity )
		{
			this.utilityAccount = account;
		}

		public UtilityAccount UtilityAccount
		{
			get { return this.utilityAccount; }
		}
	}
}
