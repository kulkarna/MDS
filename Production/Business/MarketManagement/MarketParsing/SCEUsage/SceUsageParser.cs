namespace LibertyPower.Business.MarketManagement.MarketParsing
{
	using System;
	using System.Collections.Generic;
	using System.Data;
	using System.IO;
	using System.Linq;
	using System.Text;

	using LibertyPower.Business.CommonBusiness.CommonEntity;
	using LibertyPower.Business.CommonBusiness.CommonRules;
	using LibertyPower.Business.CommonBusiness.FileManager;
	using LibertyPower.Business.MarketManagement.UtilityManagement;
	using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;
	using LibertyPower.DataAccess.CsvAccess.GenericCsv;
	using LibertyPower.DataAccess.WorkbookAccess;
	using LibertyPower.DataAccess.ExcelAccess;


	public class SceUsageParser : Parser
	{
		#region Fields

		private DataSet dsAccounts;
		private DataSet dsWorkbook;
		private SceUsageAccountCollection sceUsageAccounts;

		#endregion Fields

		#region Constructors

		public SceUsageParser( FileContext context )
			: base( context )
		{
			// Validate excel schema and create unvalidated list of accounts with usages
			try
			{
				ParseSceUsage( context );
				Validate();
				//need to convert SceUsageAccounts to standard utilityAccounts
				foreach( SceUsageAccount account in sceUsageAccounts )
				{
					ProspectAccountCandidate accountCandidate = new ProspectAccountCandidate( account );
					if( accountCandidate != null )
					{
						if( utilityAccounts == null )
							utilityAccounts = new UtilityAccountList();
						utilityAccounts.Add( accountCandidate );
					}
				}
				this.parserFileType = ParserFileType.UsageSce;

			}
			catch( BrokenRuleException e )
			{
				brokenRuleException = e;
				return;
			}
		}

		#endregion Constructors

		public SceUsageAccountCollection SceUsageAccounts
		{
			get { return sceUsageAccounts; }
			set { sceUsageAccounts = value; }
		}

		#region Methods
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

		public void ParseDataSetToAccounts()
		{
			if( DoesDataSetHaveData() )
			{
				ExtractRegions();
				CompressAccounts();
				foreach( DataTable dt in this.dsAccounts.Tables )
				{
					SceUsageAccount acct = this.ParseAccount( dt );
					if( acct != null )
					{
						if( sceUsageAccounts == null )
							sceUsageAccounts = new SceUsageAccountCollection();

						sceUsageAccounts.Add( acct );
					}
				}
			}
		}

		/// <summary>
		/// Compresses the accounts.
		/// </summary>
		private void CompressAccounts()
		{
			if( dsAccounts == null )
				return;

			string[] rowHeaders = new string[] { "Date Run:", "Account Number:", "Meter Number:", "CSS Cust Acct No:", "CSS Serv Acct No:", "Bill Period", "Rate", "Read Date", "Days", "Total kWh", "Maximum kW", "Voltage & Phase:" };
			List<string> headers = new List<string>( rowHeaders );

			for( Int16 i = 0; i < dsAccounts.Tables.Count; i++ )
			{
				DataTable dt = this.dsAccounts.Tables[i];

				int rowCount = dt.Rows.Count;

				for( Int16 ii = 0; ii < rowCount; ii++ )
				{
					string item = "";
					object o = dt.Rows[ii][0];

					if( o != null )
						item = o.ToString().Trim();

					if( headers.Contains( item ) == false )
					{
						dt.Rows.RemoveAt( ii );
						ii--;
						rowCount--;
					}
				}
			}
		}

		/// <summary>
		/// Does the dataset have data.
		/// </summary>
		/// <returns></returns>
		private bool DoesDataSetHaveData()
		{
			if( dsWorkbook != null )
			{
				foreach( DataTable dt in this.dsWorkbook.Tables )
				{
					for( int i = 1; i < dt.Rows.Count; i++ )
					{
						string buf = this.ParseCell( dt, i, 0 );
						if( IsMatch( buf, "Date Run:" ) )
							return true;
					}
				}
			}
			return false;
		}

		/// <summary>
		/// Extracts the regions.
		/// </summary>
		private void ExtractRegions()
		{
			if( dsWorkbook != null )
			{
				foreach( DataTable dt in this.dsWorkbook.Tables )
				{
					Int32 startRow = 0;
					while( startRow > -1 )
					{
						startRow = FindNextRegion( dt, startRow );
					}
				}
			}
		}

		/// <summary>
		/// Finds the last row in region.
		/// </summary>
		/// <param name="rowIndex">Index of the row.</param>
		/// <param name="dt">The dt.</param>
		/// <returns></returns>
		private Int32 FindLastRowInRegion( Int32 rowIndex, DataTable dt )
		{
			bool found1 = false;
			bool found2 = false;
			string match1 = "Meter Information:";
			string match2 = "";

			if( dt.Columns.Count < 2 )
				return -1;

			while( !found1 && rowIndex < dt.Rows.Count )
			{
				string target = this.ParseCell( dt, rowIndex++, 0 );

				if( IsMatch( match1, target ) )
				{
					while( !found2 )
					{
						target = ParseCell( dt, ++rowIndex, 1 );
						if( IsMatch( target, match2 ) || rowIndex == dt.Rows.Count - 1 )
							return rowIndex;
					}
				}
			}

			return -1;
		}

		/// <summary>
		/// Finds the next region.
		/// </summary>
		/// <param name="dt">The dt.</param>
		/// <param name="rowIndex">Index of the row.</param>
		/// <returns></returns>
		private Int32 FindNextRegion( DataTable dt, int rowIndex )
		{
			int topLeftRowIndex = this.FindNextTopRow( rowIndex, dt );

			if( topLeftRowIndex > -1 )
			{

				int rightmostColumnIndex = this.FindRightmostColumn( topLeftRowIndex, dt );

				int lastRowIndex = this.FindLastRowInRegion( topLeftRowIndex, dt );

				DataTable dtAccount = LibertyPower.DataAccess.WorkbookAccess.ExcelAccess.ExtractRegion( false, topLeftRowIndex, 0, lastRowIndex, rightmostColumnIndex, dt );

				if( dtAccount != null )
				{
					if( dsAccounts == null )
						dsAccounts = new DataSet( "Accounts" );

					dtAccount.TableName = GetUniqueTableName( dsAccounts );

					dsAccounts.Tables.Add( dtAccount );
				}
			}

			return FindNextTopRow( topLeftRowIndex + 1, dt );
		}

		private string GetUniqueTableName( DataSet ds )
		{
			if( ds == null || ds.Tables == null )
				return "Table1";
			else
			{
				Int32 i = 1;

				while( true && i < Int32.MaxValue )
				{
					string candidateName = string.Format( "Table{0}", i );
					if( ds.Tables.Contains( candidateName ) == false )
						return candidateName;
					i++;
				}
			}
			return "Table1";
		}
		/// <summary>
		/// Finds the next top row.
		/// </summary>
		/// <param name="rowIndex">Index of the row.</param>
		/// <param name="dt">The dt.</param>
		/// <returns></returns>
		private Int32 FindNextTopRow( Int32 rowIndex, DataTable dt )
		{
			for( Int32 i = rowIndex; i < dt.Rows.Count; i++ )
			{
				string target = "Date Run:";
				string match = "";
				match = ParseCell( dt, i, 0 );
				if( IsMatch( match, target ) )
					return i;
			}
			return -1;
		}

		/// <summary>
		/// Given the regions to row; returns the right most column index
		/// </summary>
		/// <param name="rowIndex"></param>
		/// <param name="dt"></param>
		/// <returns></returns>
		private Int32 FindRightmostColumn( Int32 rowIndex, DataTable dt )
		{

			for( int i = 0; i < dt.Columns.Count; i++ )
				if( dt.Columns[i].ColumnName == "ExcelRow" )
					return i;

			return dt.Columns.Count;

		}

		/// <summary>
		/// Determines whether the specified a is match.
		/// </summary>
		/// <param name="a">A.</param>
		/// <param name="b">The b.</param>
		/// <returns>
		/// 	<c>true</c> if the specified a is match; otherwise, <c>false</c>.
		/// </returns>
		private bool IsMatch( string a, string b )
		{
			a = a.Trim().ToLower();
			b = b.Trim().ToLower();
			if( string.Compare( a, b ) == 0 )
				return true;
			else
				return false;
		}

		private SceUsageAccount ParseAccount( DataTable dt )
		{
			string utility = "SCE";
			string customerAccountNumber = this.ParseCustomerAccountNumber( dt );
			string serviceAccountNumber = this.ParseServiceAccountNumber( dt );
			string meterNumber = this.ParseMeterNumber( dt );
			string currentRate = this.ParseCurrentRate( dt );
			string customerName = this.ParseCustomerName( dt );
			string customerAddress1A = this.ParseCustomerAddress1A( dt );
			string customerAddress1B = this.ParseCustomerAddress1B( dt );
			string customerAddress1C = this.ParseCustomerAddress1C( dt );
			string customerAddress2A = this.ParseCustomerAddress2A( dt );
			string customerAddress2B = this.ParseCustomerAddress2B( dt );
			string customerAddress2C = this.ParseCustomerAddress2C( dt );
			string phase = this.ParsePhase( dt );
			string voltage = this.ParseVoltage( dt );
            string lossFactorId = this.ParseLossFactorId(dt);

			SceUsageItemCollection items = this.ParseUsageItems( dt );

			SceUsageAccount account = OfferEngineUploadsParserFactory.CreateSceUsageAccount( utility, customerAccountNumber, serviceAccountNumber, customerName,
				customerAddress1A, customerAddress1B, customerAddress1C,
				customerAddress2A, customerAddress2B, customerAddress2C,
				currentRate, meterNumber, phase, voltage, items,lossFactorId );

			try
			{
				int lastCol = dt.Columns.Count - 1;
				string excelRowBuf = dt.Rows[0][lastCol].ToString();
				account.ExcelRow = Convert.ToInt32( excelRowBuf );
				account.ExcelSheet = dt.TableName;
				foreach( SceUsageItem item in items )
				{
					item.ExcelSheet = account.ExcelSheet;
					item.ExcelRow = account.ExcelRow;
				}
			}
			catch { }

			return account;
		}

		/// <summary>
		/// Parses the cell.
		/// </summary>
		/// <param name="dt">The dt.</param>
		/// <param name="rowIndex">Index of the row.</param>
		/// <param name="columnIndex">Index of the column.</param>
		/// <returns></returns>
		private string ParseCell( DataTable dt, Int32 rowIndex, Int32 columnIndex )
		{
			string answer = "";
			if( dt != null && dt.Rows.Count > rowIndex && dt.Columns.Count > columnIndex )
			{
				Object o = dt.Rows[rowIndex][columnIndex];
				if( o != null )
					return o.ToString();
			}
			return answer;
		}

		private string ParseCurrentRate( DataTable dt )
		{
			string answer = "";
			if( dt.Rows.Count > 0 && dt.Columns.Count > 8 )
				if( dt.Rows[4][7].ToString().Trim().ToLower() == "current rate:" )
				{
					answer = dt.Rows[4][8].ToString().Trim();
				}
			return answer;
		}

		private string ParseCustomerAccountNumber( DataTable dt )
		{
			string answer = "";
			if( dt.Rows.Count > 0 && dt.Columns.Count > 1 )
				if( dt.Rows[3][0].ToString().Trim().ToLower() == "css cust acct no:" )
					answer = dt.Rows[3][1].ToString().Trim();
			return answer;
		}

		private string ParseCustomerAddress1A( DataTable dt )
		{
			string answer = "";
			if( dt.Rows.Count > 0 && dt.Columns.Count > 8 )
				if( dt.Rows[1][3].ToString().Trim().ToLower() == "customer & address" )
				{
					answer = dt.Rows[2][3].ToString().Trim();
				}
			return answer;
		}

		private string ParseCustomerAddress1B( DataTable dt )
		{
			string answer = "";
			if( dt.Rows.Count > 0 && dt.Columns.Count > 8 )
				if( dt.Rows[1][3].ToString().Trim().ToLower() == "customer & address" )
				{
					answer = dt.Rows[3][3].ToString().Trim();
				}
			return answer;
		}

		private string ParseCustomerAddress1C( DataTable dt )
		{
			string answer = "";
			if( dt.Rows.Count > 0 && dt.Columns.Count > 8 )
				if( dt.Rows[1][3].ToString().Trim().ToLower() == "customer & address" )
				{
					answer = dt.Rows[4][3].ToString().Trim();
				}
			return answer;
		}

		private string ParseCustomerAddress2A( DataTable dt )
		{
			string answer = "";
			if( dt.Rows.Count > 0 && dt.Columns.Count > 8 )
				if( dt.Rows[1][5].ToString().Trim().ToLower() == "mail address" )
				{
					answer = dt.Rows[2][5].ToString().Trim();
				}
			return answer;
		}

		private string ParseCustomerAddress2B( DataTable dt )
		{
			string answer = "";
			if( dt.Rows.Count > 0 && dt.Columns.Count > 8 )
				if( dt.Rows[1][5].ToString().Trim().ToLower() == "mail address" )
				{
					answer = dt.Rows[3][5].ToString().Trim();
				}
			return answer;
		}

		private string ParseCustomerAddress2C( DataTable dt )
		{
			string answer = "";
			if( dt.Rows.Count > 0 && dt.Columns.Count > 8 )
				if( dt.Rows[1][5].ToString().Trim().ToLower() == "mail address" )
				{
					answer = dt.Rows[4][5].ToString().Trim();
				}
			return answer;
		}

		private string ParseCustomerName( DataTable dt )
		{
			string answer = "";
			if( dt.Rows.Count > 0 && dt.Columns.Count > 8 )
				if( dt.Rows[1][3].ToString().Trim().ToLower() == "customer & address" )
				{
					answer = dt.Rows[2][3].ToString().Trim();
				}
			return answer;
		}
        private string ParseLossFactorId(DataTable dt)
        {
            string answer = "";
            if (dt.Rows.Count > 0 && dt.Columns.Count > 8)
                if (dt.Rows[1][3].ToString().Trim().ToLower() == "Loss Factor ID")
                {
                    answer = dt.Rows[2][3].ToString().Trim();
                }
            return answer;
        }
		private string ParseMeterNumber( DataTable dt )
		{
			string answer = "";
			if( dt.Rows.Count > 0 && dt.Columns.Count > 1 )
				if( dt.Rows[2][0].ToString().Trim().ToLower() == "meter number:" )
					answer = dt.Rows[2][1].ToString().Trim();
			return answer;
		}

		private string ParsePhase( DataTable dt )
		{
			string answer = "";
			if( dt.Rows.Count > 0 && dt.Columns.Count > 1 )
			{
				for( int i = 0; i < dt.Rows.Count; i++ )
				{
					if( dt.Rows[i][0].ToString().Trim().ToLower() == "voltage & phase:" )
					{
						string item = dt.Rows[i][1].ToString();
						string[] parts = item.Split( (@"/").ToCharArray() );
						if( parts.Length > 1 )
							answer = parts[1].Trim();
					}
				}
			}
			return answer;
		}

		private string ParseServiceAccountNumber( DataTable dt )
		{
			string answer = "";
			if( dt.Rows.Count > 0 && dt.Columns.Count > 1 )
				if( dt.Rows[4][0].ToString().Trim().ToLower() == "css serv acct no:" )
					answer = dt.Rows[4][1].ToString().Trim();
			return answer;
		}

		private SceUsageItemCollection ParseUsageItems( DataTable dt )
		{
			SceUsageItemCollection items = null;
			//find "Bill Period"
			if( dt != null && dt.Columns.Count > 0 )
			{
				for( int r = 0; r < dt.Rows.Count; r++ )
				{
					string marker1 = dt.Rows[r][0].ToString().Trim().ToLower();
					if( string.Compare( marker1, "bill period" ) == 0 )
					{
						//find "Total"
						for( int c = 1; c < dt.Columns.Count; c++ )
						{
							string marker2 = dt.Rows[r][c].ToString().Trim().ToLower();
							if( string.Compare( marker2, "total" ) == 0 )
							{
								for( int i = 1; i < c; i++ )
								{
									string days = this.ParseCell( dt, r + 3, i );
									string totalKwH = this.ParseCell( dt, r + 4, i );
									string maximumKwH = this.ParseCell( dt, r + 5, i );
									string readDate = this.ParseCell( dt, r + 2, i );

									Int16 nDays = 0;
									decimal kwh = 0, maxKw = 0;
									DateTime read = DateTime.Now;

									if( OfferEngineUploadsParserFactory.ParseDate( readDate, out read ) == true )
									{
										Int16.TryParse( days, out nDays );
										decimal.TryParse( totalKwH, out kwh );
										decimal.TryParse( maximumKwH, out maxKw );
										SceUsageItem item = new SceUsageItem( read, nDays, kwh, maxKw );
										if( item != null )
										{
											if( items == null )
												items = new SceUsageItemCollection();

											items.Add( item );
										}
									}

								}
								return items;
							}
						}
					}
				}
			}
			return null;
		}

		private string ParseVoltage( DataTable dt )
		{
			string answer = "";
			if( dt.Rows.Count > 0 && dt.Columns.Count > 1 )
			{
				for( int i = 0; i < dt.Rows.Count; i++ )
				{
					if( dt.Rows[i][0].ToString().Trim().ToLower() == "voltage & phase:" )
					{
						string item = dt.Rows[i][1].ToString();
						string[] parts = item.Split( (@"/").ToCharArray() );
						if( parts.Length > 0 )
							answer = parts[0].Trim();
					}
				}
			}
			return answer;
		}

		public void ParseSceUsage( FileContext fileContext )
		{
			ParseSceUsage( fileContext.FullFilePath );
		}

		public void ParseSceUsage( string path )
		{
			if( File.Exists( path ) == false )
			{
				throw new UsageParserException( "Target file does not exist" );
			}

			string fileExtension = System.IO.Path.GetExtension( path ).ToLower();

			if( fileExtension == ".csv" )
			{
				dsWorkbook = GenericCsv.GetDataEx( path, true );
				dsWorkbook = FilterFields( dsWorkbook );//Added for Ticket 16453
			}
			else
			{
				try
				{
					dsWorkbook = ExcelAccess.GetWorkbook( path );
				}
				catch( Exception ex )
				{
					throw new Exception( ex.Message + " (Note: Excel 95 and older not supported)" );
				}
			}

			dsWorkbook = RemoveEmptyRows( dsWorkbook, true );
			dsWorkbook = AddRowNumbers( dsWorkbook );
			ParseDataSetToAccounts();

		}

		private DataSet FilterFields( DataSet ds )//Added for Ticket 16453
		{
			try
			{
				if( ds != null && ds.Tables.Count > 0 )
				{
					for( int r = 0; r < ds.Tables[0].Rows.Count; r++ )
					{
						for( int c = 0; c < ds.Tables[0].Columns.Count; c++ )
						{
							string buf = ds.Tables[0].Rows[r][c].ToString();
							buf = buf.Trim();
							if( buf == "." )
								buf = "";
							ds.Tables[0].Rows[r][c] = buf;
						}
					}
				}
			}
			catch( Exception ) { }
			return ds;
		}

		private void Validate()
		{
			ValidateCaliforniaUsageFileRule rule = new ValidateCaliforniaUsageFileRule( sceUsageAccounts );
			if( rule.Validate() == false )
				base.Exception = rule.Exception;
		}

		#endregion Methods
	}
}