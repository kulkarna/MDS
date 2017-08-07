namespace LibertyPower.Business.MarketManagement.MarketParsing
{
	using System;
	using System.Data;
	using System.Data.SqlClient;
	using System.IO;
	using System.Runtime.InteropServices;

	using LibertyPower.Business.CommonBusiness.CommonExcel;
	using LibertyPower.Business.CommonBusiness.CommonRules;
	using LibertyPower.Business.CommonBusiness.FileManager;
	using LibertyPower.DataAccess.ExcelAccess;
	using LibertyPower.DataAccess.WorkbookAccess;

	[Guid( "16AF2583-EDD5-4364-B300-A0F845DFB47D" )]
	internal class UsageTxnmpExcelSchemaRule : BusinessRule
	{
		#region Fields

		private readonly string WorksheetName = "LOA_Detail_Rpt";
		private FileContext context;
		private DataSet importFileDataSet;

		#endregion Fields

		#region Constructors

		internal UsageTxnmpExcelSchemaRule( FileContext context )
			: base( "UsageTxnmpExcelSchemaRule", BrokenRuleSeverity.Error )
		{
			this.context = context;
		}

		#endregion Constructors

		#region Properties

		public DataSet ImportFileDataSet
		{
			get { return this.importFileDataSet; }
		}

		#endregion Properties

		#region Methods

		public override bool Validate()
		{
			// Validation: make sure the context specifies an Excel file.
			if( context.FileName.EndsWith( ".xls" ) == false )
			{
				string actualExtension = System.IO.Path.GetExtension( this.context.FullFilePath );
				string format = "Invalid file type '{0}' when only '.xls' can be parsed";
				string message = string.Format( format, actualExtension );
				this.SetException( message );
				return false;
			}

			importFileDataSet = ExcelAccess.GetWorkbookEx( context.FullFilePath, false, false );

			if( importFileDataSet == null )
			{
				string message = string.Format( "Unable to read from the '{0}' Excel file", this.context.OriginalFilename );
				this.SetException( message );
				return false;
			}

			if( !importFileDataSet.Tables.Contains( this.WorksheetName ) )
			{
				this.SetException( this.WorksheetName + " is a required sheet" );
				return false;
			}

			importFileDataSet = NormalizeWorkbookData( importFileDataSet, this.WorksheetName );

			foreach( DataTable dataTable in importFileDataSet.Tables )
			{
				VerifyColumnsExist( dataTable, "ESI_ID" );
				VerifyColumnsExist( dataTable, "CUSTOMER_NAME" );
				VerifyColumnsExist( dataTable, "RATE_CODE" );
				VerifyColumnsExist( dataTable, "ZIPCODE" );
				VerifyColumnsExist( dataTable, "METERED_KW" );
				VerifyColumnsExist( dataTable, "ACTUAL_KWH" );
				VerifyColumnsExist( dataTable, "BILLED_KW" );
				VerifyColumnsExist( dataTable, "TDSPCHARGES" );
				VerifyColumnsExist( dataTable, "START_DATE" );
				VerifyColumnsExist( dataTable, "END_DATE" );
				VerifyColumnsExist( dataTable, "METERREADCYCLE" );
				VerifyColumnsExist( dataTable, "STREETADDRESS1" );
				VerifyColumnsExist( dataTable, "STREETADDRESS2" );
				VerifyColumnsExist( dataTable, "STREETADDRESS3" );
				VerifyColumnsExist( dataTable, "LOAD_PROFILE" );
				VerifyColumnsExist( dataTable, "POWER_FACTOR" );
				VerifyColumnsExist( dataTable, "ERCOT_REGION" );
				VerifyColumnsExist( dataTable, "METEREDKVA" );

			}

			return this.Exception == null;
		}

		private DataTable CreateHeaders( DataTable dt )
		{
			int i = 0;

			foreach( DataColumn column in dt.Columns )
			{
				if( column.ColumnName != "Excel Row" )
					column.ColumnName = dt.Rows[0][i++].ToString();

			}
			dt.Rows.RemoveAt( 0 );

			return dt;
		}

		private int FindLastRowOfGroup( DataTable dt, int start )
		{
			bool empty = true;

			if( start > dt.Rows.Count - 1 )
				return -1;

			for( int i = start; i < dt.Rows.Count; i++ )
			{
				empty = OfferEngineUploadsParserFactory.IsRowEmpty( dt.Rows[i], true );

				if( empty )
					return i - 1;
			}

			return dt.Rows.Count;
		}

		private int FindNextHeaderRow( DataTable dt, int start )
		{
			if( start > dt.Rows.Count - 1 )
				return -1;

			for( int i = start; i < dt.Rows.Count; i++ )
			{

				if( dt.Rows[i][0].ToString().Trim().StartsWith( "ESI_ID" ) )
					return i;

			}

			return -1;
		}

		private DataTable GetTable( DataTable dt, int header, int last )
		{
			DataTable dtCopy = dt.Copy();

			//Add original excel row
			dtCopy.Columns.Add( new DataColumn( "Excel Row" ) );

			for( int i = 0; i < dtCopy.Rows.Count; i++ )
			{
				dtCopy.Rows[i]["Excel Row"] = i + 1;
			}

			for( int i = 0; i < header; i++ )
			{
				dtCopy.Rows.RemoveAt( 0 );
			}

			int targetSize = last - header;

			while( dtCopy.Rows.Count > targetSize + 1 )
			{
				dtCopy.Rows.RemoveAt( dtCopy.Rows.Count - 1 );
			}

			//dtCopy = CreateHeaders( dtCopy );

			return dtCopy;
		}

		/// <summary>
		/// Parses worksheet LOA_DetailRpt to create 1 worksheet with headers from each group
		/// </summary>
		/// <param name="importFileDataSet"></param>
		/// <param name="originalSheetName"></param>
		/// <returns></returns>
		private DataSet NormalizeWorkbookData( DataSet importFileDataSet, string originalSheetName )
		{
			bool done = false;

			// This is the original sheet to parse on
			DataTable dt = importFileDataSet.Tables[originalSheetName];

			int header = 0, last = 0;
			int groupsFound = 0;

			// Try to find first group if any
			//header = FindNextHeaderRow( dt, last );
            header = 0;
			last = FindLastRowOfGroup( dt, header );

			// Used for newly created sheets
			string sheetName;

			while( !done )
			{

				if( header >= 0 && last > header )
				{
					// Parse 1st group to its own table
					DataTable normalTable = this.GetTable( dt, header, last );

					normalTable.TableName = string.Format( "Group: {0}", (++groupsFound).ToString() );

					sheetName = normalTable.TableName;
                    
                    var topLeftRowIndex = 0;
                    var topLeftColumnIndex = 0;
                    var bottomRightRowIndex = normalTable.Rows.Count - 1;
                    var bottomRightColumnIndex = normalTable.Columns.Count - 1;

                    normalTable = LibertyPower.DataAccess.WorkbookAccess.ExcelAccess.ExtractRegion(true, topLeftRowIndex, topLeftColumnIndex, bottomRightRowIndex, bottomRightColumnIndex, normalTable);
                    normalTable.Columns[18].ColumnName = "Excel Row";
                    importFileDataSet.Tables.Add(normalTable);

					// Check if this was the last group
					if( last == dt.Rows.Count )
					{
						done = true;
					}
					else // Attempt to find the next group ( might just be blank lines )
					{
						header = FindNextHeaderRow( dt, last );
						last = FindLastRowOfGroup( dt, header );
					}
				}
				else
				{
					done = true;
				}

			}

			importFileDataSet.Tables.Remove( originalSheetName );

			return importFileDataSet;
		}

		private void VerifyColumnsExist( DataTable dataTable, string requiredColumn )
		{
			if( !dataTable.Columns.Contains( requiredColumn ) )
			{
				SetException( requiredColumn + " is a required column" );
			}
		}

		#endregion Methods
	}
}