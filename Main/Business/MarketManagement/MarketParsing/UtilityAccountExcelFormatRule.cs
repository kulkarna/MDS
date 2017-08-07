namespace LibertyPower.Business.MarketManagement.MarketParsing
{
	using System;
	using System.Data;
	using System.Runtime.InteropServices;

	using LibertyPower.Business.CommonBusiness.CommonRules;
	using LibertyPower.Business.CommonBusiness.FileManager;
	using LibertyPower.DataAccess.WorkbookAccess;

	/// <summary>
	/// Checks that the required worksheet exists in the Excel File
	/// </summary>
	[Guid( "FAF5FB70-9FD9-49bd-BF53-203244B394B9" )]
	public class UtilityAccountExcelSchemaRule : BusinessRule
	{
		#region Fields

		private readonly string WorksheetName = "ERCOT_AccountListing";
		private FileContext context;
		private DataSet importFileDataSet;

		#endregion Fields

		#region Constructors

		public UtilityAccountExcelSchemaRule( FileContext context )
			: base( "UtilityAccountExcelFormatRule", BrokenRuleSeverity.Error )
		{
			this.context = context;
		}

		#endregion Constructors

		#region Properties

		public DataSet ImportFileDataSet
		{
			get { return this.importFileDataSet; }
		}

		public DataTable Accounts
		{
			get { return this.importFileDataSet.Tables[WorksheetName]; }
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

			DataTable dataTable = importFileDataSet.Tables[this.WorksheetName];

			VerifyColumnsExist( dataTable, "Account Number" );
			VerifyColumnsExist( dataTable, "Market" );
			VerifyColumnsExist( dataTable, "Utility" );
			VerifyColumnsExist( dataTable, "Meter Number" );
			VerifyColumnsExist( dataTable, "Zip" );
			VerifyColumnsExist( dataTable, "Name Key" );
			VerifyColumnsExist( dataTable, "Street" );
			VerifyColumnsExist( dataTable, "City" );
			VerifyColumnsExist( dataTable, "State" );
			VerifyColumnsExist( dataTable, "Country" );
			VerifyColumnsExist( dataTable, "Billing Account" );
			VerifyColumnsExist( dataTable, "Billing Street" );
			VerifyColumnsExist( dataTable, "Billing City" );
			VerifyColumnsExist( dataTable, "Billing State" );
			VerifyColumnsExist( dataTable, "Billing Zip" );
			VerifyColumnsExist( dataTable, "Billing Country" );

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