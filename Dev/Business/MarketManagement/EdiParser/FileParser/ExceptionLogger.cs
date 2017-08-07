namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Data;
	using System.Text;
	using LibertyPower.Business.CommonBusiness.CommonRules;
	using LibertyPower.Business.CommonBusiness.CommonHelper;
	using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;
	using LibertyPower.DataAccess.SqlAccess.TransactionsSql;

	/// <summary>
	/// Class for logging exxceptions
	/// </summary>
	public static class ExceptionLogger
	{
		/// <summary>
		/// Logs edi file exceptions
		/// </summary>
		/// <param name="ediFileLog">Edi file log object</param>
		/// <param name="configRule">File configuration data exists business rule</param>
		/// <returns>Returns an edi file log object that conatins record id and timestamp.</returns>
		public static EdiFileLog LogFileExceptions( EdiFileLog ediFileLog,
			FileConfigDataExistsRule configRule )
		{
			EdiFileLog log;
			int ediFileLogID = ediFileLog.ID;
			string fileGuid = ediFileLog.FileGuid;
			string fileName = ediFileLog.FileName;
			string utilityCode = ediFileLog.UtilityCode;
			int attempts = ediFileLog.Attempts;
			string info = EnumHelper.GetEnumDescription( FileStatusInfo.FileHasOneOrMoreErrors );
			int fileType = Convert.ToInt16( ediFileLog.EdiFileType );
			int success = 0; // false

			// build error message
			foreach( BrokenRuleException ex in configRule.Exception.DependentExceptions )
				info = String.Concat( info, " : ", ex.Message );

			DataSet ds = TransactionsSql.InsertEdiFileLog( ediFileLogID, fileGuid, fileName, utilityCode,
				attempts, info, success, fileType );

			if( DataSetHelper.HasRow( ds ) )
				log = FileFactory.CreateEdiFileLog( ds.Tables[0].Rows[0] );
			else
			{
				string format = "Edi file log insert failed for file guid {0}.";
				throw new LogInsertException( String.Format( format, fileGuid ) );
			}
			return log;
		}

		/// <summary>
		/// Logs edi file exceptions
		/// </summary>
		/// <param name="ediFileLog">Edi file log object</param>
		/// <param name="info">Exception message</param>
		/// <returns>Returns an edi file log object that conatins record id and timestamp.</returns>
		public static EdiFileLog LogFileExceptions( EdiFileLog ediFileLog, string info )
		{
			EdiFileLog log;
			int ediFileLogID = ediFileLog.ID;
			string fileGuid = ediFileLog.FileGuid;
			string fileName = ediFileLog.FileName;
			string utilityCode = ediFileLog.UtilityCode;
			int attempts = ediFileLog.Attempts;
			int success = 0; // false
			int fileType = Convert.ToInt16( ediFileLog.EdiFileType );

			DataSet ds = TransactionsSql.InsertEdiFileLog( ediFileLogID, fileGuid, fileName, utilityCode,
				attempts, info, success, fileType );

			if( DataSetHelper.HasRow( ds ) )
				log = FileFactory.CreateEdiFileLog( ds.Tables[0].Rows[0] );
			else
			{
				string format = "Edi file log insert failed for file guid {0}.";
				throw new LogInsertException( String.Format( format, fileGuid ) );
			}
			return log;
		}

		/// <summary>
		/// Logs edi account exceptions
		/// </summary>
		/// <param name="ediFile">Edi file log object</param>
		public static void LogAccountExceptions( ref EdiFile ediFile )
		{
			string fileGuid = ediFile.FileGuid;
			EdiAccountList accountList = ediFile.EdiAccountList;

			foreach( EdiAccount account in accountList )
			{
				string accountNumber = account.AccountNumber;
				string dunsNumber = account.DunsNumber;
				int ediProcessLogID = ediFile.EdiProcessLog.ID;

				AccountDataExistsRule accountRule = account.AccountDataExistsRule;

				// log warnings and errors
				if( !accountRule.DefaultSeverity.Equals( BrokenRuleSeverity.Information ) )
				{
					foreach( BrokenRuleException ex in accountRule.Exception.DependentExceptions )
						ediFile.AddEdiAccountLog( Logger.LogAccountInfo( ediProcessLogID, accountNumber, dunsNumber, ex.Message, ex.Severity ) );
				}

				if( ediFile.FileType != EdiFileType.EightOneFour )
				{
					UsageListDataExistsRule usageListRule = account.UsageListDataExistsRule;

					// log warnings and errors
					if( !usageListRule.DefaultSeverity.Equals( BrokenRuleSeverity.Information ) )
					{
						foreach( BrokenRuleException ex in usageListRule.Exception.DependentExceptions )
							ediFile.AddEdiAccountLog( Logger.LogAccountInfo( ediProcessLogID, accountNumber, dunsNumber, ex.Message, ex.Severity ) );
					}
				}
			}
		}

		/// <summary>
		/// we
		/// </summary>
		/// <param name="fileGuid"></param>
		/// <param name="ediProcessLogID"></param>
		/// <param name="fileType"></param>
		/// <param name="account"></param>
		public static void LogAccountExceptions( string fileGuid, int ediProcessLogID, EdiFileType fileType, ref EdiAccount account )
		{
			AccountDataExistsRule accountRule = account.AccountDataExistsRule;

			// log warnings and errors
			if( !accountRule.DefaultSeverity.Equals( BrokenRuleSeverity.Information ) )
			{
				foreach( BrokenRuleException ex in accountRule.Exception.DependentExceptions )
					Logger.LogAccountInfo( ediProcessLogID, account.AccountNumber, account.DunsNumber, ex.Message, ex.Severity );
			}
			if( fileType != EdiFileType.EightOneFour )
			{
				UsageListDataExistsRule usageListRule = account.UsageListDataExistsRule;

				// log warnings and errors
				if( !usageListRule.DefaultSeverity.Equals( BrokenRuleSeverity.Information ) )
				{
					foreach( BrokenRuleException ex in usageListRule.Exception.DependentExceptions )
						Logger.LogAccountInfo( ediProcessLogID, account.AccountNumber, account.DunsNumber, ex.Message, ex.Severity );
				}
			}
		}

		public static void LogAccountExceptions( DataTable dtErrors, string fileGuid, int ediProcessLogID, EdiFileType fileType, ref EdiAccount account )
		{
			AccountDataExistsRule accountRule = account.AccountDataExistsRule;

			// log warnings and errors
			if( !accountRule.DefaultSeverity.Equals( BrokenRuleSeverity.Information ) )
			{
				foreach( BrokenRuleException ex in accountRule.Exception.DependentExceptions )
					AddErrorToDataTable( dtErrors, ediProcessLogID, account.AccountNumber, account.DunsNumber, ex.Message, ex.Severity );
			}
			if( fileType != EdiFileType.EightOneFour )
			{
				UsageListDataExistsRule usageListRule = account.UsageListDataExistsRule;

				// log warnings and errors
				if( !usageListRule.DefaultSeverity.Equals( BrokenRuleSeverity.Information ) )
				{
					foreach( BrokenRuleException ex in usageListRule.Exception.DependentExceptions )
						AddErrorToDataTable( dtErrors, ediProcessLogID, account.AccountNumber, account.DunsNumber, ex.Message, ex.Severity );
				}
			}
		}

		private static void AddErrorToDataTable( DataTable dtErrors, int ediProcessLogID, string accountNumber,
			string dunsNumber, string info, BrokenRuleSeverity severity )
		{
			int severityLevel = severity.Equals( BrokenRuleSeverity.Error ) ? 0 : 1;

			DataRow dr = dtErrors.NewRow();
			dr["EdiProcessLogID"] = ediProcessLogID;
			dr["AccountNumber"] = accountNumber;
			dr["DunsNumber"] = dunsNumber;
			dr["Information"] = info;
			dr["Severity"] = severityLevel;
			dr["TimeStamp"] = DateTime.Now;

			dtErrors.Rows.Add( dr );
		}

		/// <summary>
		/// Logs edi exceptions
		/// </summary>
		/// <param name="fileGuid">File identifier in managed storgae</param>
		/// <param name="fileName">File name</param>
		/// <param name="info">Exception information</param>
		public static void LogEdiException( string fileGuid, string fileName, string info )
		{
			TransactionsSql.InsertEdiException( fileGuid, fileName, info );
		}
	}
}
