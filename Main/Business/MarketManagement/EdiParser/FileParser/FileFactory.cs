namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Data;
	using System.Collections.Generic;
	using System.IO;
	using System.Configuration;
	using LibertyPower.Business.CommonBusiness.CommonEntity;
	using LibertyPower.Business.CommonBusiness.CommonHelper;
	using LibertyPower.Business.CommonBusiness.FileManager;
	using LibertyPower.DataAccess.SqlAccess.TransactionsSql;
    using LibertyPower.Business.MarketManagement.UtilityManagement;
    using LibertyPower.DataAccess.SqlAccess.OfferEngineSql;
    using LibertyPower.DataAccess.WorkbookAccess;

	/// <summary>
	/// Factory for creating file and log objects
	/// </summary>
	public static class FileFactory
	{
		/// <summary>
		/// Place file in managed storage with app config flag for determining whether to delete original.
		/// </summary>
		/// <param name="file">file</param>
		/// <returns>Returnd a file context object of file in managed storage.</returns>
		public static FileContext CreateManagedFile( string file )
		{
			bool deleteOriginal = Convert.ToBoolean( ConfigurationManager.AppSettings["FileManagerDeleteOriginal"] );

			//set up managed storage for file
			FileManager fileManager = FileManagerFactory.GetFileManager( ConfigurationManager.AppSettings["FileManagerContextKey"], ConfigurationManager.AppSettings["FileManagerBusinessPurpose"], ConfigurationManager.AppSettings["FileManagerRoot"], 0 );

			//adds the file to managed storage, returns a file context object
			return fileManager.AddFile( file, deleteOriginal, 0 );
		}

		/// <summary>
		/// Get file contents from managed storage
		/// </summary>
		/// <param name="context">File context object</param>
		/// <returns>the file content in one string</returns>
		public static string GetFileContents( FileContext context )
		{
			/*byte[] finalBuffer;
			using( FileStream fileStream = new FileStream( context.FullFilePath, FileMode.Open, FileAccess.Read ) )
			{
				int numBytesToRead = (int) fileStream.Length; 

				byte[] buffer = new byte[numBytesToRead];
				int n = fileStream.Read( buffer, 0, numBytesToRead );

				finalBuffer = new byte[numBytesToRead];
				int i=0;
				foreach( byte bb in buffer )
		{
					//remove "&" | "(" - ")" |  "-" | "," |  "."
					if( bb == 38 || bb == 40 || bb == 41 || bb == 45 | bb == 46 )
						continue;
					Buffer.SetByte( finalBuffer, i, bb );
					i++;
				}
			}
			return Encoding.ASCII.GetString( finalBuffer );*/

			using( StreamReader streamReader = new StreamReader( context.FullFilePath ) )
			{
				return streamReader.ReadToEnd();
			}
		}

		/// <summary>
		/// Gets a managed file by file guid
		/// </summary>
		/// <param name="fileGuid">Identifier in managed storage</param>
		/// <returns>Returns a file context object of the file.</returns>
		public static FileContext GetManagedFileByFileGuid( string fileGuid )
		{
			Guid guid = new Guid( fileGuid );
			return FileManagerFactory.GetFileContextByGuid( guid );
		}

		/// <summary>
		/// Copies files from managed storage to specified directory
		/// </summary>
		/// <param name="fileGuids">File identifier in managed storage</param>
		/// <param name="copyToDirectory">Destination directory for copied files.</param>
		public static void CopyFilesFromManagedStorage( string[] fileGuids, string copyToDirectory )
		{
			foreach( string fileGuid in fileGuids )
			{
				Guid guid = new Guid( fileGuid );
				FileContext context = FileManagerFactory.GetFileContextByGuid( guid );

				string originalFileName = context.OriginalFilename;
				string managedFileName = context.FileName;
				string managedFile = context.FullFilePath;
				string copyFile = String.Concat( copyToDirectory, originalFileName );

				File.Copy( managedFile, copyFile, true );
			}
		}

		/// <summary>
		/// Gets edi file log records from database and builds list
		/// </summary>
		/// <param name="date">Date filter for log records returned</param>
		/// <param name="logType">Log type to filter on (errors, warnings, all)</param>
		/// <param name="fileType">File type to filter on (814, 867, status update files)</param>
		/// <returns>Returns an edi file log list</returns>
		public static EdiFileLogList GetEdiFileLogs( DateTime date, string logType, string fileType )
		{
			EdiFileLogList list = new EdiFileLogList();

			DataSet ds = TransactionsSql.SelectEdiFileLogs( date, logType, fileType );

			if( DataSetHelper.HasRow( ds ) )
			{
				foreach( DataRow dr in ds.Tables[0].Rows )
					list.Add( CreateEdiFileLog( dr ) );
			}

			return list;
		}

		/// <summary>
		/// Gets edi file log records from database and builds list
		/// </summary>
		/// <param name="field">Date filter for log records returned</param>
		/// <param name="searchText">Log type to filter on (errors, warnins, all)</param>
		/// <returns>Returns an edi file log list</returns>
		public static EdiFileLogList SearchEdiFileLogs( string field, string searchText )
		{
			EdiFileLogList list = new EdiFileLogList();

			DataSet ds = TransactionsSql.SearchEdiFileLogs( field, searchText );

			if( DataSetHelper.HasRow( ds ) )
			{
				foreach( DataRow dr in ds.Tables[0].Rows )
					list.Add( CreateEdiFileLog( dr ) );
			}

			return list;
		}

		/// <summary>
		/// Gets edi account log records from database and builds list
		/// </summary>
		/// <param name="fileGuid">File identifier in managed storage</param>
		/// <param name="severity">Severity level of logs</param>
		/// <returns>Returns an edi account log list</returns>
		public static EdiAccountLogList GetEdiAccountLogs( string fileGuid, string severity )
		{
			EdiAccountLogList list = new EdiAccountLogList();

			DataSet ds = TransactionsSql.SelectEdiAccountLogs( fileGuid, severity );

			if( DataSetHelper.HasRow( ds ) )
			{
				foreach( DataRow dr in ds.Tables[0].Rows )
					list.Add( CreateEdiAccountLog( dr ) );
			}


			return list;
		}

		/// <summary>
		/// Creates an edi file log object from data row
		/// </summary>
		/// <param name="dr">Data row</param>
		/// <returns>Returns an edi file log object</returns>
		public static EdiFileLog CreateEdiFileLog( DataRow dr )
		{
			int id = Convert.ToInt32( dr["ID"] );
			string fileGuid = dr["FileGuid"].ToString();
			string fileName = dr["FileName"].ToString();
			string utilityCode = dr["UtilityCode"].ToString();
			int attempts = Convert.ToInt32( dr["Attempts"] );
			string info = dr["Information"].ToString();
			bool isProcessed = Convert.ToBoolean( dr["IsProcessed"] );
			DateTime timeStamp = Convert.ToDateTime( dr["Timestamp"] );
			EdiFileType fileType = (EdiFileType) Enum.Parse( typeof( EdiFileType ), dr["FileType"].ToString() );

			return new EdiFileLog( id, fileGuid, fileName, utilityCode, attempts, info, isProcessed, timeStamp, fileType );
		}

		/// <summary>
		/// Creates an edi account log object from data row
		/// </summary>
		/// <param name="dr">Data row</param>
		/// <returns>Returns an account file log object</returns>
		private static EdiAccountLog CreateEdiAccountLog( DataRow dr )
		{
			int ediFileLogID = Convert.ToInt32( dr["EdiFileLogID"] );
			int ediProcessLogID = Convert.ToInt32( dr["EdiProcessLogID"] );
			string accountNumber = dr["AccountNumber"].ToString();
			string utilityCode = dr["UtilityCode"].ToString();
			string dunsNumber = dr["DunsNumber"].ToString();
			string info = dr["Information"].ToString();

			return new EdiAccountLog( ediFileLogID, ediProcessLogID, accountNumber, utilityCode, dunsNumber, info );
		}

		/// <summary>
		/// Gets an account managed file object for specified account number, utility code, and file type.
		/// </summary>
		/// <param name="accountNumber">Account number</param>
		/// <param name="utilityCode">Utility code</param>
		/// <param name="fileType">File type</param>
		/// <returns>Returns an account managed file object for specified account number, utility code, and file type.</returns>
		public static AccountManagedFile GetAccountManagedFile( string accountNumber, string utilityCode, AccountManagedFileType fileType )
		{
			AccountManagedFile amf = null;

			DataSet ds = OfferSql.GetAccountManagedFile( accountNumber, utilityCode, Convert.ToInt16( fileType ) );
			if( DataSetHelper.HasRow( ds ) )
			{
				amf = BuildAccountManagedFile( ds.Tables[0].Rows[0] );
			}
			return amf;
		}

		/// <summary>
		/// Inserts an account managed file record.
		/// </summary>
		/// <param name="accountNumber">Account number</param>
		/// <param name="utilityCode">Utility code</param>
		/// <param name="fileType">Managed file type enum</param>
		/// <param name="fileGuid">Managed file guid</param>
		/// <returns>Returns an account managed file object from inserted data with record identifier.</returns>
		public static AccountManagedFile InsertAccountManagedFile( string accountNumber, string utilityCode,
			AccountManagedFileType fileType, Guid fileGuid )
		{
			AccountManagedFile amf = null;

			DataSet ds = OfferSql.InsertAccountManagedFile( accountNumber, utilityCode, Convert.ToInt16( fileType ), fileGuid.ToString() );
			if( DataSetHelper.HasRow( ds ) )
			{
				amf = BuildAccountManagedFile( ds.Tables[0].Rows[0] );
			}
			return amf;
		}

		private static AccountManagedFile BuildAccountManagedFile( DataRow dr )
		{
			int identity = Convert.ToInt32( dr["ID"] );
			string accountNumber = dr["AccountNumber"].ToString();
			string utilityCode = dr["UtilityCode"].ToString();
			AccountManagedFileType fileType = (AccountManagedFileType) Enum.Parse( typeof( AccountManagedFileType ), dr["FileType"].ToString() );
			Guid fileGuid = new Guid( dr["FileGuid"].ToString() );

			return new AccountManagedFile( identity, accountNumber, utilityCode, fileType, fileGuid );
		}

		/// <summary>
		/// Adds file to managed files using file manager
		/// </summary>
		/// <param name="filePath">File path</param>
		public static FileContext AddManagedFile( string filePath )
		{
			FileContext context = null;
			string contextKey = ConfigurationManager.AppSettings["FileManagerContextKey"];
			string businessPurpose = ConfigurationManager.AppSettings["FileManagerBusinessPurpose"];
			string rootDirectory = ConfigurationManager.AppSettings["FileManagerRoot"];
			bool deleteOriginal = ConfigurationManager.AppSettings["FileManagerDeleteOriginal"] == null
				? false : Convert.ToBoolean( ConfigurationManager.AppSettings["FileManagerDeleteOriginal"] );

			if( contextKey != null && businessPurpose != null && rootDirectory != null )
			{
				FileManager fm = FileManagerFactory.GetFileManager( contextKey, businessPurpose, rootDirectory, 0 );
				context = fm.AddFile( filePath, deleteOriginal, 0 );
			}
			else
				throw new EdiFileException( "App key(s) not found for file manager in config file." );

			return context;
		}

		/// <summary>
		/// Gets web account object and associated usage for specified account number and utility code.
		/// </summary>
		/// <param name="accountNumber">Account number</param>
		/// <param name="utilityCode">Utility code</param>
		/// <returns>Returns a web account object and associated usage for specified account number and utility code.</returns>
		public static WebAccountList GetWebAccountList( string accountNumber, string utilityCode )
		{
			WebAccountList accounts = new WebAccountList();
			FileAccount account = null;

			AccountManagedFile amf = GetAccountManagedFile( accountNumber, utilityCode, AccountManagedFileType.AccountData );
			if( amf != null )
			{
				Guid fileGuid = amf.FileGuid;
				FileContext context = FileManagerFactory.GetFileContextByGuid( fileGuid );
				string filePath = context.FullFilePath;

				DataSet ds = ExcelAccess.GetWorkbook( filePath );
				if( DataSetHelper.HasRow( ds ) )
				{
					DataView dv = ds.Tables[0].DefaultView;
					dv.RowFilter = "[0] = '" + accountNumber + "' AND [2] = '" + utilityCode + "'";

					DataTable dt = dv.ToTable();

					foreach( DataRow dr in dt.Rows )
					{
						account = new FileAccount();
						account.AccountNumber = dr[0] == DBNull.Value ? String.Empty : dr[0].ToString();
						account.Icap = dr[12] == DBNull.Value ? -1m : Convert.ToDecimal( dr[12] );
						account.Grid = dr[21] == DBNull.Value ? String.Empty : dr[21].ToString();
						account.LbmpZone = dr[22] == DBNull.Value ? String.Empty : dr[22].ToString();
						account.LoadProfile = dr[20] == DBNull.Value ? String.Empty : dr[20].ToString();
						account.LoadShapeId = dr[15] == DBNull.Value ? String.Empty : dr[15].ToString();
						account.LossFactor = dr[14] == DBNull.Value ? String.Empty : dr[14].ToString();
						account.MeterNumber = dr[4] == DBNull.Value ? String.Empty : dr[4].ToString();
						account.RateClass = dr[16] == DBNull.Value ? String.Empty : dr[16].ToString();
						account.TariffCode = dr[19] == DBNull.Value ? String.Empty : dr[19].ToString();
						account.Tcap = dr[13] == DBNull.Value ? -1m : Convert.ToDecimal( dr[13] );
						account.UtilityCode = dr[2] == DBNull.Value ? String.Empty : dr[2].ToString();
						account.Voltage = dr[5] == DBNull.Value ? String.Empty : dr[5].ToString();
						account.WebUsageList = GetWebUsageList( accountNumber, utilityCode );
						account.ZoneCode = dr[11] == DBNull.Value ? String.Empty : dr[11].ToString();

						accounts.Add( account );
					}
				}
			}
			return accounts;
		}

		/// <summary>
		/// Gets web usage list for specified account number and utility code.
		/// </summary>
		/// <param name="accountNumber">Account number</param>
		/// <param name="utilityCode">Utility code</param>
		/// <returns>Returns a web usage list for specified account number and utility code.</returns>
		public static WebUsageList GetWebUsageList( string accountNumber, string utilityCode )
		{
			WebUsageList usages = new WebUsageList();

			AccountManagedFile amf = GetAccountManagedFile( accountNumber, utilityCode, AccountManagedFileType.UsageData );
			if( amf != null )
			{
				Guid fileGuid = amf.FileGuid;
				FileContext context = FileManagerFactory.GetFileContextByGuid( fileGuid );
				string filePath = context.FullFilePath;

				DataSet ds = ExcelAccess.GetWorkbook( filePath );
				if( DataSetHelper.HasRow( ds ) )
				{
					DataView dv = ds.Tables[0].DefaultView;
					dv.RowFilter = "[0] = '" + accountNumber + "' AND [2] = '" + utilityCode + "'";

					DataTable dt = dv.ToTable();

					foreach( DataRow dr in dt.Rows )
					{
						WebUsage usage = new WebUsage();

						DateTime from = dr[7] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime( dr[7] );
						DateTime to = dr[8] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime( dr[8] );
						TimeSpan span = to.Subtract( from );

						usage.AccountNumber = dr[3] == DBNull.Value ? String.Empty : dr[3].ToString();
						usage.BeginDate = from;
						usage.EndDate = to;
						usage.Days = span.Days;
						usage.Icap = dr[10] == DBNull.Value ? -1m : Convert.ToDecimal( dr[10] );
						usage.MeterNumber = dr[4] == DBNull.Value ? String.Empty : dr[4].ToString();
						usage.Tcap = dr[11] == DBNull.Value ? -1m : Convert.ToDecimal( dr[11] );
						usage.TotalKwh = dr[9] == DBNull.Value ? 0 : Convert.ToInt32( dr[9] );
						usage.UtilityCode = dr[1] == DBNull.Value ? String.Empty : dr[1].ToString();

						usages.Add( usage );
					}
				}
			}
			return usages;
		}

		/// <summary>
		/// Gets a file account list from utility account list
		/// </summary>
		/// <param name="utilityAccounts">Utility account list</param>
		/// <returns>Returns a file account list from utility account list.</returns>
		public static FileAccountList GetFileAccountList( List<UtilityAccount> utilityAccounts )
		{
			FileAccountList fileAccountList = new FileAccountList();

			foreach( UtilityAccount utilityAccount in utilityAccounts )
				fileAccountList.Add( GetFileAccount( utilityAccount ) );

			return fileAccountList;
		}

		/// <summary>
		/// Gets a file account from utility account list
		/// </summary>
		/// <param name="utilityAccount">Utility account</param>
		/// <returns>Returns a file account from utility account list.</returns>
		public static FileAccount GetFileAccount( UtilityAccount utilityAccount )
		{
			FileAccount account = new FileAccount();
			account.AccountNumber = utilityAccount.AccountNumber;
			account.Icap = utilityAccount.Icap == null ? -1m : Convert.ToDecimal( utilityAccount.Icap );
			account.LoadProfile = utilityAccount.LoadProfile;
			account.LoadShapeId = utilityAccount.LoadShapeId;
			account.RateClass = utilityAccount.RateClass;
			account.Tcap = utilityAccount.Tcap == null ? -1m : Convert.ToDecimal( utilityAccount.Tcap );
			account.UtilityCode = utilityAccount.UtilityCode;
			account.Voltage = utilityAccount.Voltage;
			account.WebUsageList = GetWebUsageList( utilityAccount.Usages );
			account.ZoneCode = utilityAccount.ZoneCode;
            account.MeterType = utilityAccount.MeterOption;
            account.BillGroup = utilityAccount.BillGroup;
			return account;
		}

		/// <summary>
		/// Gets a web usage list from a usage dictionary
		/// </summary>
		/// <param name="usages">Usage dictionary</param>
		/// <returns>Returns a web usage list from a usage dictionary.</returns>
		public static WebUsageList GetWebUsageList( UsageDictionary usages )
		{
			WebUsageList webUsageList = new WebUsageList();

			foreach( Usage usage in usages.Values )
				webUsageList.Add( GetWebUsage( usage ) );

			return webUsageList;
		}

		/// <summary>
		/// Gets a web usage object from a usage object
		/// </summary>
		/// <param name="usage">Usage object</param>
		/// <returns>Returns a web usage object from a usage object.</returns>
		public static WebUsage GetWebUsage( Usage usage )
		{
			DateTime from = usage.BeginDate;
			DateTime to = usage.EndDate;
			TimeSpan span = to.Subtract( from );

			WebUsage webUsage = new WebUsage();
			webUsage.BeginDate = usage.BeginDate;
			webUsage.EndDate = usage.EndDate;
			webUsage.Days = span.Days;
			webUsage.TotalKwh = usage.TotalKwh;

			return webUsage;
		}
	}
}
