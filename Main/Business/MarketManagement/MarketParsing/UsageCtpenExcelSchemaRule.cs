namespace LibertyPower.Business.MarketManagement.MarketParsing
{
	using System;
	using System.Data;
	using System.Runtime.InteropServices;

	using LibertyPower.Business.CommonBusiness.CommonRules;
	using LibertyPower.Business.CommonBusiness.FileManager;
	using LibertyPower.DataAccess.WorkbookAccess;

	[Guid( "E515BD08-26F8-4492-B43D-6AA0A1A33931" )]
	public class UsageCtpenExcelSchemaRule : BusinessRule
	{
		#region Fields

		private readonly string WorksheetName = "Accounts"; //This worksheet is always present; additional worksheets are required for each ESI ID in this worksheet
		private FileContext context;
		private DataSet importFileDataSet;

		#endregion Fields

		#region Constructors

		public UsageCtpenExcelSchemaRule( FileContext context )
			: base( "UsageCtpenExcelSchemaRule", BrokenRuleSeverity.Error )
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
			if( context.FileName.EndsWith( ".xls" ) == false )
			{
				string actualExtension = System.IO.Path.GetExtension( this.context.FullFilePath );
				string format = "Invalid file type '{0}' when only '.xls' can be parsed";
				string message = string.Format( format, actualExtension );
				this.SetException( message );
				return false;
			}

			importFileDataSet = ExcelAccess.GetWorkbookEx( context.FullFilePath, true, false );

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

			DataTable accounts = importFileDataSet.Tables[this.WorksheetName];

			VerifyColumnsExist( accounts, "#" );
			VerifyColumnsExist( accounts, "ESI ID" );
			VerifyColumnsExist( accounts, "Account Number" );
			VerifyColumnsExist( accounts, "Service Address 1" );
			VerifyColumnsExist( accounts, "Service Address 3" );

			CheckEachDependentWorksheet( importFileDataSet );

			return this.Exception == null;
		}

		private void CheckEachDependentWorksheet( DataSet importFileDataSet )
		{
			DataTable accounts = importFileDataSet.Tables[this.WorksheetName];

			int excelRow;

			for( int i = 0; i < accounts.Rows.Count; i++ )
			{
				excelRow = i + 1;

				string prefix = accounts.Rows[i]["#"].ToString();
				string ESIID = accounts.Rows[i]["ESI ID"].ToString();
				string sheetName = string.Format( "{0} - {1}", prefix, ESIID );

				if( !importFileDataSet.Tables.Contains( sheetName ) )
				{
					this.SetException( sheetName + " is a required sheet Excel file" );
				}
				else
				{
					DataTable dt = importFileDataSet.Tables[sheetName];

					VerifyColumnsExist( dt, "ESI ID" );
					VerifyColumnsExist( dt, "Customer Name" );
					VerifyColumnsExist( dt, "Rate Class/Code" );
					VerifyColumnsExist( dt, "Zip Code" );
					VerifyColumnsExist( dt, "Metered KW" );
					VerifyColumnsExist( dt, "Actual KWH" );
					VerifyColumnsExist( dt, "Billed KW" );
					VerifyColumnsExist( dt, "TDSP Charges" );
					VerifyColumnsExist( dt, "Start Date" );
					VerifyColumnsExist( dt, "End Date" );
					VerifyColumnsExist( dt, "Meter Read Cycle" );
					VerifyColumnsExist( dt, "Service Address 1" );
					VerifyColumnsExist( dt, "Service Address 2" );
					VerifyColumnsExist( dt, "Service Address 3" );
					VerifyColumnsExist( dt, "Load Profile" );
					VerifyColumnsExist( dt, "Power Factor" );
					VerifyColumnsExist( dt, "ERCOT Region" );
					VerifyColumnsExist( dt, "Metered KVA" );
					VerifyColumnsExist( dt, "Billed KVA" );

				}
			}
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