namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System.Text;

	using LibertyPower.Business.CommonBusiness.CommonRules;

	public class MessageFormatter
	{
		private BrokenRuleException brokenRuleException;

		public MessageFormatter( BrokenRuleException exception )
		{
			brokenRuleException = exception;
		}

		public string Format()
		{
			StringBuilder messageBuilder = new StringBuilder();

			if( brokenRuleException != null )
			{
				messageBuilder.Append( brokenRuleException.Message + " " );

				if( brokenRuleException.DependentExceptions != null &&
					brokenRuleException.DependentExceptions.Count > 0 )
				{
					foreach( BrokenRuleException exception in brokenRuleException.DependentExceptions )
					{
						MessageFormatter formatter = 
							new MessageFormatter( exception );

						messageBuilder.Append( formatter.Format() + " " );
					}
				}
			}

			return messageBuilder.ToString().Trim();
		}
	}
}
