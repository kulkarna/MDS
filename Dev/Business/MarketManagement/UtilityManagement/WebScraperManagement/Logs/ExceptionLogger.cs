namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Collections.Generic;
	using System.Text;
	using LibertyPower.Business.CommonBusiness.CommonRules;

	public static class ExceptionLogger
	{
		public static void LogAccountExceptions( WebAccount account )
		{
			BusinessRule accountRule = account.AccountDataExistsRule;

			//foreach( BrokenRuleException ex in accountRule.Exception.DependentExceptions )
			//{
			//    if( ex.DependentExceptions == null )
			//        Logger.LogAccountInfo( account.AccountNumber, account.UtilityCode, ex );
			//    else
			//    {
			//        for( int i = 0; i < ex.DependentExceptions.Count; i++ )
			//            Logger.LogAccountInfo( account.AccountNumber, account.UtilityCode, ex.DependentExceptions[i] );

			//    }
			//}

			LogException( account, account.AccountDataExistsRule.Exception );
		}

		private static void LogException( WebAccount account, BrokenRuleException brokenRuleException )
		{
			if( brokenRuleException != null )
			{
				Logger.LogAccountInfo( account.AccountNumber, account.UtilityCode, brokenRuleException );

				if( brokenRuleException.DependentExceptions != null &&
					brokenRuleException.DependentExceptions.Count > 0 )
				{
					foreach( BrokenRuleException exception in brokenRuleException.DependentExceptions )
						ExceptionLogger.LogException( account, exception );
				}
			}
		}
	}
}
