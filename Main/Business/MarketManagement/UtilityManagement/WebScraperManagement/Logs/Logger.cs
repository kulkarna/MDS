namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Collections.Generic;
	using System.Text;
	using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;
	using LibertyPower.DataAccess.SqlAccess.TransactionsSql;
	using LibertyPower.Business.CommonBusiness.CommonRules;
	using System.Data;

	public static class Logger
	{
		public static WebAccountLog LogAccountInfo( string account, string utility, BrokenRuleException err )
		{
			WebAccountLog log = new WebAccountLog();
			int severityLevel = err.Equals( BrokenRuleSeverity.Error ) ? 0 : 1;	// todo, add #'s to BrokenRuleSeverity object

			if( err.Severity == BrokenRuleSeverity.Error )
			{
				DataSet ds = TransactionsSql.InsertWebAccountLog( account, utility, err.Message, severityLevel );

				if( ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0 )
				{
					int id = Convert.ToInt32( ds.Tables[0].Rows[0]["ID"] );
					string accountNumber = ds.Tables[0].Rows[0]["AccountNumber"].ToString();
					string info = ds.Tables[0].Rows[0]["Information"].ToString();

					log = new WebAccountLog( id, utility, accountNumber, info, err.Severity );
				}
				else
				{
					string format = "Web account log insert failed for process log ID {0}.";
					throw new WebManagerException( String.Format( format, account ) );
				}
			}
			return log;
		}

		public static void LogIDRInfo( string utility, string msg, DateTime createDate)
		{
			IDRSQL.IDRLogsInsert( utility, msg, createDate );
		}

		/// <summary>
		/// Delete the logs that are a month old
		/// </summary>
		public static void LogIDRDelete( )
		{
			DateTime dt = DateTime.Now.AddMonths( -1 );
			IDRSQL.IDRLogsDelete( dt );
		}
	}
}
