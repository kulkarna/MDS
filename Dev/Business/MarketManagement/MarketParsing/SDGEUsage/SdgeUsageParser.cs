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

	public class SdgeUsageParser : Parser
	{
		#region Fields

		private SdgeUsageAccountCollection sdgeAccountCollection;

		#endregion

		#region Properties

		public SdgeUsageAccountCollection SdgeAccountCollection
		{
			get { return sdgeAccountCollection; }
		}

		#endregion

		#region Methods

		private SdgeUsageAccountCollection ParseSdgeUsage( FileContext fileContext )
		{
			return ParseSdgeUsage( fileContext.FullFilePath );
		}

		private SdgeUsageAccountCollection ParseSdgeUsage( string path )
		{
			if( File.Exists( path ) == false )
			{
				throw new UsageParserException( "Target file does not exist" );
			}

			DataSet ds = null;

			try
			{
				ds = ExcelAccess.GetWorkbook( path );
			}
			catch( Exception ex )
			{
				throw new Exception( ex.Message + " (Note: Excel 95 and older not supported)" );
			}

			ds = RemoveEmptyRows( ds, true );
			ds = AddRowNumbers( ds );

			SdgeUsageAccountCollection accounts = GetUtilityAccountsWithUsagesFromSdge( ds );
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

		private Int32 FindStartRow( DataTable dt )
		{
			int answer = -1;
			for( int i = 0; i < dt.Rows.Count; i++ )
			{
				string buf = dt.Rows[i][0].ToString().Trim();
				if( string.Compare( buf, "Service" ) == 0 )
					return i;
			}
			return answer;
		}

		private SdgeUsageAccountCollection GetUtilityAccountsWithUsagesFromSdge( DataSet ds )
		{
			SdgeUsageAccountCollection accounts = new SdgeUsageAccountCollection();
			if( ds != null && ds.Tables.Count > 0 )
			{
				Int32 ncols = ds.Tables[0].Columns.Count;
				Int32 nrows = ds.Tables[0].Rows.Count;
				Int32 startRow = FindStartRow( ds.Tables[0] );
				if( startRow == -1 )
					return accounts;

				DataTable dt = LibertyPower.DataAccess.WorkbookAccess.ExcelAccess.ExtractRegion( true, startRow, 0, nrows - 1, ncols - 1, ds.Tables[0] );

				dt.Columns[ncols - 1].ColumnName = "ExcelRow";

				foreach( DataRow row in dt.Rows )
				{
					if( OfferEngineUploadsParserFactory.IsRowEmpty( row, true ) == false )
					{

						#region get fields
						string Acct = "";
						if( row.Table.Columns.Contains( "Acct" ) == true )
						{
							Acct = row["Acct"].ToString().Trim();
						}
						else if( row.Table.Columns.Contains( "Account" ) == true )
						{
							Acct = row["Account"].ToString().Trim();
						}
                        string LossFactorId = "";
                        if (row.Table.Columns.Contains("Loss Factor ID") == true)
                        {
                            LossFactorId = row["Loss Factor ID"].ToString().Trim();
                        }
                        else if (row.Table.Columns.Contains("Account") == true)
                        {
                            Acct = row["Account"].ToString().Trim();
                        }
						string Meter = "";
						if( row.Table.Columns.Contains( "Meter" ) == true )
						{
							Meter = row["Meter"].ToString().Trim();
						}

						string Cycle = "";
						if( row.Table.Columns.Contains( "Cycle" ) == true )
						{
							Cycle = row["Cycle"].ToString().Trim();
						}

						string Meter_Own = "";
						if( row.Table.Columns.Contains( "Meter Own" ) == true )
						{
							Meter_Own = row["Meter Own"].ToString().Trim();
						}
						else if( row.Table.Columns.Contains( "MeterOwn" ) == true )
						{
							Meter_Own = row["MeterOwn"].ToString().Trim();
						}

						string Meter_Read = "";
						if( row.Table.Columns.Contains( "Meter Read" ) == true )
						{
							Meter_Read = row["Meter Read"].ToString().Trim();
						}
						else if( row.Table.Columns.Contains( "MeterRead" ) == true )
						{
							Meter_Read = row["MeterRead"].ToString().Trim();
						}

						string Meter_Install = "";
						if( row.Table.Columns.Contains( "Meter_Install" ) == true )
						{
							Meter_Install = row["Meter_Install"].ToString().Trim();
						}

						string Meter_Maintain = "";
						if( row.Table.Columns.Contains( "Meter Maintain" ) == true )
						{
							Meter_Maintain = row["Meter Maintain"].ToString().Trim();
						}
						else if( row.Table.Columns.Contains( "MeterMaintain" ) == true )
						{
							Meter_Maintain = row["MeterMaintain"].ToString().Trim();
						}

						string Meter_Option = "";
						if( row.Table.Columns.Contains( "Meter Option" ) == true )
						{
							Meter_Option = row["Meter Option"].ToString().Trim();
						}
						else if( row.Table.Columns.Contains( "MeterOption" ) == true )
						{
							Meter_Option = row["MeterOption"].ToString().Trim();
						}

						string Serv_Voltage = "";
						if( row.Table.Columns.Contains( "Serv Voltage" ) == true )
						{
							Serv_Voltage = row["Serv Voltage"].ToString().Trim();
						}
						else if( row.Table.Columns.Contains( "ServVoltage" ) == true )
						{
							Serv_Voltage = row["ServVoltage"].ToString().Trim();
						}

						string Acct_Name = "";
						if( row.Table.Columns.Contains( "Acct Name" ) == true )
						{
							Acct_Name = row["Acct Name"].ToString().Trim();
						}
						else if( row.Table.Columns.Contains( "AcctName" ) == true )
						{
							Acct_Name = row["AcctName"].ToString().Trim();
						}

						string Cust_Name = "";
						if( row.Table.Columns.Contains( "Cust Name" ) == true )
						{
							Cust_Name = row["Cust Name"].ToString().Trim();
						}
						else if( row.Table.Columns.Contains( "CustName" ) == true )
						{
							Cust_Name = row["CustName"].ToString().Trim();
						}

						string Address = "";
						if( row.Table.Columns.Contains( "Address" ) == true )
						{
							Address = row["Address"].ToString().Trim();
						}

						string CityStateZip = "";
						if( row.Table.Columns.Contains( "City, State  Zip" ) == true )
						{
							CityStateZip = row["City, State  Zip"].ToString().Trim();
						}
						else if( row.Table.Columns.Contains( "City,StateZip" ) == true )
						{
							CityStateZip = row["City,StateZip"].ToString().Trim();
						}

						string Rate = "";
						if( row.Table.Columns.Contains( "Rate" ) == true )
						{
							Rate = row["Rate"].ToString().Trim();
						}

						string Cons_End_Dt = "";
						if( row.Table.Columns.Contains( "Cons End Dt" ) == true )
						{
							Cons_End_Dt = row["Cons End Dt"].ToString().Trim();
						}
						else if( row.Table.Columns.Contains( "ConsEndDt" ) == true )
						{
							Cons_End_Dt = row["ConsEndDt"].ToString().Trim();
						}

						string Days_Used = "";
						if( row.Table.Columns.Contains( "Days Used" ) == true )
						{
							Days_Used = row["Days Used"].ToString().Trim();
						}
						else if( row.Table.Columns.Contains( "DaysUsed" ) == true )
						{
							Days_Used = row["DaysUsed"].ToString().Trim();
						}

						string On_kWh = "";
						if( row.Table.Columns.Contains( "On kWh" ) == true )
						{
							On_kWh = row["On kWh"].ToString().Trim();
						}
						else if( row.Table.Columns.Contains( "OnkWh" ) == true )
						{
							On_kWh = row["OnkWh"].ToString().Trim();
						}

						string Off_kWh = "";
						if( row.Table.Columns.Contains( "Off kWh" ) == true )
						{
							Off_kWh = row["Off kWh"].ToString().Trim();
						}
						else if( row.Table.Columns.Contains( "OffkWh" ) == true )
						{
							Off_kWh = row["OffkWh"].ToString().Trim();
						}

						string Total_kWh = "";
						if( row.Table.Columns.Contains( "Total kWh" ) == true )
						{
							Total_kWh = row["Total kWh"].ToString().Trim();
						}
						else if( row.Table.Columns.Contains( "TotalkWh" ) == true )
						{
							Total_kWh = row["TotalkWh"].ToString().Trim();
						}

						string On_kW = "";
						if( row.Table.Columns.Contains( "On kW" ) == true )
						{
							On_kW = row["On kW"].ToString().Trim();
						}
						else if( row.Table.Columns.Contains( "OnkW" ) == true )
						{
							On_kW = row["OnkW"].ToString().Trim();
						}

						string Off_kW = "";
						if( row.Table.Columns.Contains( "Off kW" ) == true )
						{
							Off_kW = row["Off kW"].ToString().Trim();
						}
						else if( row.Table.Columns.Contains( "OffkW" ) == true )
						{
							Off_kW = row["OffkW"].ToString().Trim();
						}

						string Max_kW = "";
						if( row.Table.Columns.Contains( "Max kW" ) == true )
						{
							Max_kW = row["Max kW"].ToString().Trim();
						}
						else if( row.Table.Columns.Contains( "MaxkW" ) == true )
						{
							Max_kW = row["MaxkW"].ToString().Trim();
						}

						string Max_kW_NC = "";
						if( row.Table.Columns.Contains( "Max kW NC" ) == true )
						{
							Max_kW_NC = row["Max kW NC"].ToString().Trim();
						}
						else if( row.Table.Columns.Contains( "MaxkWNC" ) == true )
						{
							Max_kW_NC = row["MaxkWNC"].ToString().Trim();
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

						SdgeUsageAccount candidate = FindAccount( Acct, accounts );
						if( candidate == null )
						{
							candidate = OfferEngineUploadsParserFactory.CreateSdgeUsageAccount( "SDGE", Acct, Address, CityStateZip, Cust_Name, Cycle, Meter, Meter_Maintain, Meter_Option, Meter_Own,
								Meter_Read, Meter_Install, Rate, Serv_Voltage,LossFactorId );
							accounts.Add( candidate );
							candidate.ExcelRow = excel_row_number;
							candidate.ExcelSheet = row.Table.TableName;
						}

						#endregion

						#region add usages

						SdgeUsageItem item = OfferEngineUploadsParserFactory.CreateSdgeUsageItem( Cons_End_Dt, Days_Used, Max_kW, Max_kW_NC, Off_kW, Off_kWh, On_kW, On_kWh, Total_kWh );
						candidate.AddUsageItem( item );
						item.ExcelRow = excel_row_number;
						item.ExcelSheet = row.Table.TableName;
						#endregion

					}
				}
			}
			return accounts;
		}

		private SdgeUsageAccount FindAccount( string accountNumber, SdgeUsageAccountCollection accounts )
		{
			foreach( SdgeUsageAccount candidate in accounts )
				if( string.Compare( accountNumber, candidate.Acct ) == 0 )
					return candidate;
			return null;
		}

		private void Validate()
		{
			ValidateCaliforniaUsageFileRule rule = new ValidateCaliforniaUsageFileRule( sdgeAccountCollection );
			if( rule.Validate() == false )
				base.Exception = rule.Exception;
		}
		#endregion

		#region Constructors

		public SdgeUsageParser( FileContext context )
			: base( context )
		{
			// Validate excel schema and create unvalidated list of accounts
			try
			{
				sdgeAccountCollection = ParseSdgeUsage( context );
				Validate();
				//need to convert PgeUsageAccounts to standard utilityAccounts
				foreach( SdgeUsageAccount account in sdgeAccountCollection )
				{
					ProspectAccountCandidate accountCandidate = new ProspectAccountCandidate( account );
					if( accountCandidate != null )
					{
						if( utilityAccounts == null )
							utilityAccounts = new UtilityAccountList();
						utilityAccounts.Add( accountCandidate );
					}
				}

				this.parserFileType = ParserFileType.UsageSdge;
			}
			catch( BrokenRuleException e )
			{
				this.brokenRuleException = e;
			}
		}

		#endregion Constructors
	}
}