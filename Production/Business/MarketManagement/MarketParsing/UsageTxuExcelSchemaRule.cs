namespace LibertyPower.Business.MarketManagement.MarketParsing
{
	using System;
	using System.Data;
	using System.Runtime.InteropServices;

	using LibertyPower.Business.CommonBusiness.CommonRules;
	using LibertyPower.Business.CommonBusiness.FileManager;
	using LibertyPower.DataAccess.WorkbookAccess;

	[Guid( "3F4738A3-9452-4c71-8456-63FB431C6D53" )]
	public class UsageTxuExcelSchemaRule : BusinessRule
	{
		#region Fields

		private readonly string WorksheetName = "qry_Usage_History";
		private FileContext context;
		private DataSet importFileDataSet;

		#endregion Fields

		#region Constructors

		public UsageTxuExcelSchemaRule( FileContext context )
			: base( "UsageTxuExcelSchemaRule", BrokenRuleSeverity.Error )
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

			DataTable DataTable = importFileDataSet.Tables[this.WorksheetName];

			VerifyColumnsExist( DataTable, "ESI ID" );
			VerifyColumnsExist( DataTable, "Customer Name" );
			VerifyColumnsExist( DataTable, "Rate Class/Code" );
			VerifyColumnsExist( DataTable, "Zip Code" );
			VerifyColumnsExist( DataTable, "Metered KW" );
			VerifyColumnsExist( DataTable, "Actual KWH" );
			VerifyColumnsExist( DataTable, "Billed KW" );
			VerifyColumnsExist( DataTable, "TDSP Charges" );
			VerifyColumnsExist( DataTable, "Start Date" );
			VerifyColumnsExist( DataTable, "End Date" );
			VerifyColumnsExist( DataTable, "Meter Read Cycle" );
			VerifyColumnsExist( DataTable, "Service Address 1" );
			VerifyColumnsExist( DataTable, "Service Address 2" );
			VerifyColumnsExist( DataTable, "Service Address 3" );
			VerifyColumnsExist( DataTable, "Load Profile" );
			VerifyColumnsExist( DataTable, "Power Factor" );
			VerifyColumnsExist( DataTable, "ERCOT Region" );
			VerifyColumnsExist( DataTable, "Metered KVA" );
			VerifyColumnsExist( DataTable, "Billed KVA" );

			return this.Exception == null;
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