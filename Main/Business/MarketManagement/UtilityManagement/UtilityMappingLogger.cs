namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Data;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	using LibertyPower.Business.CommonBusiness.CommonHelper;
	using LibertyPower.Business.CommonBusiness.CommonRules;
	using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;

	/// <summary>
	/// Class for utility mapping log methods
	/// </summary>
	public static class UtilityMappingLogger
	{
		/// <summary>
		/// Inserts utility mapping record
		/// </summary>
		/// <param name="accountNumber">Account number</param>
		/// <param name="utilityId">Utility record identifier</param>
		/// <param name="message">Message</param>
		/// <param name="severityLevel">Severity level (Enum)</param>
		/// <param name="lpcApplication">LPC application (Enum)</param>
		/// <param name="dateCreated">Date created</param>
		public static void LogMessage( string accountNumber, int utilityId, string message,
			BrokenRuleSeverity severityLevel, LpcApplication lpcApplication, DateTime dateCreated )
		{
			LibertyPowerSql.InsertUtilityMappingLog( accountNumber, utilityId, message,
				Convert.ToInt16( severityLevel ), Convert.ToInt16( lpcApplication ), dateCreated );
		}

		/// <summary>
		/// Inserts utility mapping record
		/// </summary>
		/// <param name="accountNumber">Account number</param>
		/// <param name="utilityCode">Utility code</param>
		/// <param name="message">Message</param>
		/// <param name="severityLevel">Severity level (Enum)</param>
		/// <param name="lpcApplication">LPC application (Enum)</param>
		/// <param name="dateCreated">Date created</param>
		public static void LogMessage( string accountNumber, string utilityCode, string message,
			BrokenRuleSeverity severityLevel, LpcApplication lpcApplication, DateTime dateCreated )
		{
			int utilityId = UtilityFactory.GetUtilityByCode( utilityCode ).Identity;
			LogMessage( accountNumber, utilityId, message, severityLevel, lpcApplication, dateCreated );
		}

		/// <summary>
		/// Gets utility mapping log objects for LPC application from date specified.
		/// </summary>
		/// <param name="lpcApplication">LPC application</param>
		/// <param name="dateFrom">Date from</param>
		/// <returns>Returns a list utility mapping log objects for LPC application from date specified.</returns>
		public static UtilityMappingLogList GetUtilityMappingLogs( LpcApplication lpcApplication, DateTime dateFrom )
		{
			UtilityMappingLogList logs = new UtilityMappingLogList();
			DataSet ds = LibertyPowerSql.GetUtilityMappingLogs( Convert.ToInt16( lpcApplication ), dateFrom );
			if( DataSetHelper.HasRow( ds ) )
			{
				foreach( DataRow dr in ds.Tables[0].Rows )
					logs.Add( BuildUtilityMappingLog( dr ) );
			}
			return logs;
		}

		/// <summary>
		/// Gets utility mapping log object for specified record identity.
		/// </summary>
		/// <param name="identity">Record identifier</param>
		/// <returns>Returns a utility mapping log object for specified record identity.</returns>
		public static UtilityMappingLog GetUtilityMappingLog( int identity )
		{
			UtilityMappingLog log = null;
			DataSet ds = LibertyPowerSql.GetUtilityMappingLog( identity );
			if( DataSetHelper.HasRow( ds ) )
			{
				log = BuildUtilityMappingLog( ds.Tables[0].Rows[0] );
			}
			return log;
		}

		private static UtilityMappingLog BuildUtilityMappingLog( DataRow dr )
		{
			UtilityMappingLog log = new UtilityMappingLog();
			log.AccountNumber = dr["AccountNumber"] == DBNull.Value ? String.Empty : dr["AccountNumber"].ToString();
			log.DateCreated = dr["DateCreated"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime( dr["DateCreated"] );
			log.Identity = Convert.ToInt32( dr["ID"] );
			log.LpcApplication = dr["LpcApplication"] == DBNull.Value ? LpcApplication.Unknown : (LpcApplication) Enum.Parse( typeof( LpcApplication ), dr["LpcApplication"].ToString() );
			log.Message = dr["Message"] == DBNull.Value ? String.Empty : dr["Message"].ToString();
			log.SeverityLevel = dr["SeverityLevel"] == DBNull.Value ? BrokenRuleSeverity.Information : (BrokenRuleSeverity) Enum.Parse( typeof( BrokenRuleSeverity ), dr["SeverityLevel"].ToString() );
			log.UtilityID = dr["UtilityID"] == DBNull.Value ? 0 : Convert.ToInt32( dr["UtilityID"] );
			return log;
		}
	}
}
