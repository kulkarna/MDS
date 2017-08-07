namespace LibertyPower.Business.MarketManagement.MarketParsing
{

	using System;
	using System.Data;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;
	using System.IO;

	using LibertyPower.Business.CommonBusiness.CommonEntity;
	using LibertyPower.Business.CommonBusiness.CommonRules;
	using LibertyPower.Business.CommonBusiness.FileManager;
	using LibertyPower.Business.MarketManagement.UtilityManagement;
	using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;
	using LibertyPower.DataAccess.CsvAccess.GenericCsv;
	using LibertyPower.DataAccess.WorkbookAccess;
	using LibertyPower.DataAccess.ExcelAccess;


	public class PgeUsageParser : Parser
	{
		#region Fields

		private PgeUsageAccountCollection pgeAccountCollection;

		#endregion Fields

		#region Constructors

		public PgeUsageParser( FileContext context )
			: base( context )
		{
			// Validate excel schema and create unvalidated list of accounts
			try
			{
				pgeAccountCollection = ParsePgeUsage( context );
				Validate();
				//need to convert PgeUsageAccounts to standard utilityAccounts
				foreach( PgeUsageAccount account in pgeAccountCollection )
				{
					ProspectAccountCandidate accountCandidate = new ProspectAccountCandidate( account );
					if( accountCandidate != null )
					{
						if( utilityAccounts == null )
							utilityAccounts = new UtilityAccountList();
						utilityAccounts.Add( accountCandidate );
					}
				}

				this.parserFileType = ParserFileType.UsagePge;
			}
			catch( BrokenRuleException e )
			{
				this.brokenRuleException = e;
			}
		}

		#endregion Constructors

		#region Properties

		public PgeUsageAccountCollection PgeAccountCollection
		{
			get { return pgeAccountCollection; }
			set { pgeAccountCollection = value; }
		}

		#endregion Properties

		#region Methods

		private PgeUsageAccountCollection ParsePgeUsage( FileContext fileContext )
		{
			return ParsePgeUsage( fileContext.FullFilePath );
		}

		private DataSet NormalizePgeColumnNames( DataSet ds )
		{
			if( ds != null && ds.Tables.Count > 0 )
			{
				DataTable dt = ds.Tables[0];
				if( dt.Columns.Contains( "said" ) )
					dt.Columns["said"].ColumnName = "SA_ID";
				if( dt.Columns.Contains( "entity_name" ) )
					dt.Columns["entity_name"].ColumnName = "CUSTOMER";
				if( dt.Columns.Contains( "service_address" ) )
					dt.Columns["service_address"].ColumnName = "SERVICE_ADDRESS";
				if( dt.Columns.Contains( "service_city" ) )
					dt.Columns["service_city"].ColumnName = "SERVICE_CITY";
				if( dt.Columns.Contains( "service_state" ) )
					dt.Columns["service_state"].ColumnName = "SERVICE_STATE";
				if( dt.Columns.Contains( "service_postal" ) )
					dt.Columns["service_postal"].ColumnName = "SERVICE_POSTAL";
				if( dt.Columns.Contains( "mail_address" ) )
					dt.Columns["mail_address"].ColumnName = "MAIL_ADDRESS";
				if( dt.Columns.Contains( "mail_city" ) )
					dt.Columns["mail_city"].ColumnName = "MAIL_CITY";
				if( dt.Columns.Contains( "mail_state" ) )
					dt.Columns["mail_state"].ColumnName = "MAIL_STATE";
				if( dt.Columns.Contains( "mail_postal" ) )
					dt.Columns["mail_postal"].ColumnName = "MAIL_POSTAL";
				if( dt.Columns.Contains( "rateschedule" ) )
					dt.Columns["rateschedule"].ColumnName = "RATESCH";
				if( dt.Columns.Contains( "prior_read_date" ) )
					dt.Columns["prior_read_date"].ColumnName = "PRIOR_READ_DATE";
				if( dt.Columns.Contains( "current_read_date" ) )
					dt.Columns["current_read_date"].ColumnName = "CURRENT_READ_DATE";
				if( dt.Columns.Contains( "numberofdays" ) )
					dt.Columns["numberofdays"].ColumnName = "NUMBEROFDAYS";
				if( dt.Columns.Contains( "kwh" ) )
					dt.Columns["kwh"].ColumnName = "USAGE";
				if( dt.Columns.Contains( "demand" ) )
					dt.Columns["demand"].ColumnName = "DEMAND";
				if( dt.Columns.Contains( "off_peak_kwh" ) )
					dt.Columns["off_peak_kwh"].ColumnName = "OFF_PEAK_KWH";
				if( dt.Columns.Contains( "part_peak_kwh" ) )
					dt.Columns["part_peak_kwh"].ColumnName = "PART_PEAK_KWH";
				if( dt.Columns.Contains( "on_peak_kwh" ) )
					dt.Columns["on_peak_kwh"].ColumnName = "ON_PEAK_KWH";
				if( dt.Columns.Contains( "meter_number" ) )
					dt.Columns["meter_number"].ColumnName = "METER_NUM";
                
			}
			return ds;
		}

		private PgeUsageAccountCollection ParsePgeUsage( string path )
		{
			if( File.Exists( path ) == false )
				throw new UsageParserException( "Target file does not exist" );

			DataSet ds = null;

			string fileExtension = System.IO.Path.GetExtension( path ).ToLower();
			if( fileExtension == ".csv" )
			{
				ds = GenericCsv.GetDataEx( path, true );
				if( ds != null && ds.Tables.Count > 0 )
				{
					DataTable dt = ds.Tables[0];
					dt = LibertyPower.DataAccess.WorkbookAccess.ExcelAccess.ExtractRegion( true, 0, 0, dt.Rows.Count - 1, dt.Columns.Count - 1, dt );
					ds.Tables.Clear();
					ds.Tables.Add( dt );
					ds = NormalizePgeColumnNames( ds );
				}
			}
			else
			{
				try
				{
					ds = LibertyPower.DataAccess.WorkbookAccess.ExcelAccess.GetWorkbook( path );
				}
				catch( Exception ex )
				{
					throw new Exception( ex.Message + " (Note: Excel 95 and older not supported)" );
				}

				if( ds != null && ds.Tables.Count > 0 )
				{
					Int32 ncols = ds.Tables[0].Columns.Count;
					Int32 nrows = ds.Tables[0].Rows.Count;
					DataTable dt = ExcelAccess.ExtractRegion( true, 0, 0, nrows - 1, ncols - 1, ds.Tables[0] );
					ds.Tables.Clear();
					ds.Tables.Add( dt );
                    ds = NormalizePgeColumnNames(ds);
				}
			}

			ds = RemoveEmptyRows( ds, true );
			ds = AddRowNumbers( ds );

			PgeUsageAccountCollection accounts = GetUtilityAccountsWithUsagesFromPge( ds );

			return accounts;
		}

		private DataSet AddRowNumbers( DataSet ds )
		{

			foreach( DataTable table in ds.Tables )
			{
				int i = 1;
				table.Columns.Add( new DataColumn( "ExcelRow" ) );
				foreach( DataRow row in ds.Tables[0].Rows )
				{
					row["ExcelRow"] = i++;
				}
			}
			return ds;
		}

		private PgeUsageAccountCollection GetUtilityAccountsWithUsagesFromPge( DataSet ds )
		{
			PgeUsageAccountCollection accounts = new PgeUsageAccountCollection();
			if( ds != null && ds.Tables.Count > 0 )
			{
				Int32 ncols = ds.Tables[0].Columns.Count;
				Int32 nrows = ds.Tables[0].Rows.Count;
				DataTable dt = ds.Tables[0];

				foreach( DataRow row in dt.Rows )
				{
					if( OfferEngineUploadsParserFactory.IsRowEmpty( row, true ) == false )
					{

						#region get fields
						string SA_ID = "";
						if( row.Table.Columns.Contains( "SA_ID" ) == true )
						{
							SA_ID = row["SA_ID"].ToString().Trim();
						}

						string CUSTOMER = "";
						if( row.Table.Columns.Contains( "CUSTOMER" ) == true )
						{
							CUSTOMER = row["CUSTOMER"].ToString().Trim();
						}

						string SERVICE_ADDRESS = "";
						if( row.Table.Columns.Contains( "SERVICE_ADDRESS" ) == true )
						{
							SERVICE_ADDRESS = row["SERVICE_ADDRESS"].ToString().Trim();
						}

						string SERVICE_CITY = "";
						if( row.Table.Columns.Contains( "SERVICE_CITY" ) == true )
						{
							SERVICE_CITY = row["SERVICE_CITY"].ToString().Trim();
						}

						string SERVICE_STATE = "";
						if( row.Table.Columns.Contains( "SERVICE_STATE" ) == true )
						{
							SERVICE_STATE = row["SERVICE_STATE"].ToString().Trim();
						}

						string SERVICE_POSTAL = "SERVICE_POSTAL";
						if( row.Table.Columns.Contains( "SERVICE_POSTAL" ) == true )
						{
							SERVICE_POSTAL = row["SERVICE_POSTAL"].ToString().Trim();
							if( SERVICE_POSTAL.Length > 5 )
								SERVICE_POSTAL = SERVICE_POSTAL.Substring( 0, 5 );
						}

						string MAIL_ADDRESS = "";
						if( row.Table.Columns.Contains( "MAIL_ADDRESS" ) == true )
						{
							MAIL_ADDRESS = row["MAIL_ADDRESS"].ToString().Trim();
						}

						string MAIL_CITY = "";
						if( row.Table.Columns.Contains( "MAIL_CITY" ) == true )
						{
							MAIL_CITY = row["MAIL_CITY"].ToString().Trim();
						}

						string MAIL_STATE = "";
						if( row.Table.Columns.Contains( "MAIL_STATE" ) == true )
						{
							MAIL_STATE = row["MAIL_STATE"].ToString().Trim();
						}

						string MAIL_POSTAL = "";
						if( row.Table.Columns.Contains( "MAIL_POSTAL" ) == true )
						{
							MAIL_POSTAL = row["MAIL_POSTAL"].ToString().Trim();
							if( MAIL_POSTAL.Length > 5 )
								MAIL_POSTAL = MAIL_POSTAL.Substring( 0, 5 );
						}

						string RATESCH = "";
						if( row.Table.Columns.Contains( "RATESCH" ) == true )
						{
							RATESCH = row["RATESCH"].ToString().Trim();
						}

						string PRIOR_READ_DATE = "";
						if( row.Table.Columns.Contains( "PRIOR_READ_DATE" ) == true )
						{
							PRIOR_READ_DATE = row["PRIOR_READ_DATE"].ToString().Trim();
						}

						string CURRENT_READ_DATE = "";
						if( row.Table.Columns.Contains( "CURRENT_READ_DATE" ) == true )
						{
							CURRENT_READ_DATE = row["CURRENT_READ_DATE"].ToString().Trim();
						}

						string NUMBEROFDAYS = "";
						if( row.Table.Columns.Contains( "NUMBEROFDAYS" ) == true )
						{
							NUMBEROFDAYS = row["NUMBEROFDAYS"].ToString().Trim();
						}

						string USAGE = "";
						if( row.Table.Columns.Contains( "USAGE" ) == true )
						{
							USAGE = row["USAGE"].ToString().Trim();
						}
                        string LossFactorId = "";
                        if (row.Table.Columns.Contains("Loss Factor ID") == true)
                        {
                            LossFactorId = row["Loss Factor ID"].ToString().Trim();
                        }
						string DEMAND = "";
						if( row.Table.Columns.Contains( "DEMAND" ) == true )
						{
							DEMAND = row["DEMAND"].ToString().Trim();
						}

						string OFF_PEAK_KWH = "";
						if( row.Table.Columns.Contains( "OFF_PEAK_KWH" ) == true )
						{
							OFF_PEAK_KWH = row["OFF_PEAK_KWH"].ToString().Trim();
						}

						string PART_PEAK_KWH = "";
						if( row.Table.Columns.Contains( "PART_PEAK_KWH" ) == true )
						{
							PART_PEAK_KWH = row["PART_PEAK_KWH"].ToString().Trim();
						}

						string ON_PEAK_KWH = "";
						if( row.Table.Columns.Contains( "ON_PEAK_KWH" ) == true )
						{
							ON_PEAK_KWH = row["ON_PEAK_KWH"].ToString().Trim();
						}

						string METER_NUM = "";
						if( row.Table.Columns.Contains( "METER_NUM" ) == true )
						{
							METER_NUM = row["METER_NUM"].ToString().Trim();
						}

						string VOLTAGE = "";
						if( row.Table.Columns.Contains( "VOLTAGE" ) == true )
						{
							VOLTAGE = row["VOLTAGE"].ToString().Trim();
						}

						string METER_TYPE = "";
						if( row.Table.Columns.Contains( "METER_TYPE" ) == true )
						{
							METER_TYPE = row["METER_TYPE"].ToString().Trim();
						}

						string ENERGY_SVC_PROVIDER = "";
						if( row.Table.Columns.Contains( "ENERGY_SVC_PROVIDER" ) == true )
						{
							ENERGY_SVC_PROVIDER = row["ENERGY_SVC_PROVIDER"].ToString().Trim();
						}

						string MDMA = "";
						if( row.Table.Columns.Contains( "MDMA" ) == true )
						{
							MDMA = row["MDMA"].ToString().Trim();
						}

						string METER_INSTALLER = "";
						if( row.Table.Columns.Contains( "METER_INSTALLER" ) == true )
						{
							METER_INSTALLER = row["METER_INSTALLER"].ToString().Trim();
						}

						string METER_MAINTAINER = "";
						if( row.Table.Columns.Contains( "METER_MAINTAINER" ) == true )
						{
							METER_MAINTAINER = row["METER_MAINTAINER"].ToString().Trim();
						}

						string METER_OWNER = "";
						if( row.Table.Columns.Contains( "METER_OWNER" ) == true )
						{
							METER_OWNER = row["METER_OWNER"].ToString().Trim();
						}

						#endregion

						#region get accounts

						Int32 excel_row_number = -1;
						try
						{
							string excel_row = row["ExcelRow"].ToString();
							excel_row_number = Convert.ToInt32( excel_row );
						}
						catch { }

						PgeUsageAccount candidate = FindAccount( SA_ID, accounts );
						if( candidate == null )
						{
							candidate = OfferEngineUploadsParserFactory.CreatePgeUsageAccount( "PGE", SA_ID, CUSTOMER, SERVICE_ADDRESS, SERVICE_CITY, SERVICE_STATE, SERVICE_POSTAL,
								MAIL_ADDRESS, MAIL_CITY, MAIL_STATE, MAIL_POSTAL, RATESCH, METER_NUM, VOLTAGE, ENERGY_SVC_PROVIDER, MDMA, METER_INSTALLER, METER_MAINTAINER, METER_OWNER, null,LossFactorId );
							accounts.Add( candidate );
							candidate.ExcelRow = excel_row_number;
							candidate.ExcelSheet = row.Table.TableName;

						}

						#endregion

						#region add usages

						PgeUsageItem item = OfferEngineUploadsParserFactory.CreatePgeUsageItem( CURRENT_READ_DATE, PRIOR_READ_DATE, NUMBEROFDAYS, USAGE, DEMAND, OFF_PEAK_KWH, PART_PEAK_KWH, ON_PEAK_KWH );
						candidate.AddUsageItem( item );
						item.ExcelRow = excel_row_number;
						item.ExcelSheet = row.Table.TableName;
						#endregion

					}
				}
			}
			return accounts;
		}

		private PgeUsageAccount FindAccount( string accountNumber, PgeUsageAccountCollection accounts )
		{
			foreach( PgeUsageAccount candidate in accounts )
				if( string.Compare( accountNumber, candidate.AccountNumber ) == 0 )
					return candidate;
			return null;
		}

		private void Validate()
		{
			ValidateCaliforniaUsageFileRule rule = new ValidateCaliforniaUsageFileRule( pgeAccountCollection );
			if( rule.Validate() == false )
				base.Exception = rule.Exception;
		}

		#endregion
	}
}