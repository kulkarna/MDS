namespace LibertyPower.Business.MarketManagement.MarketParsing
{
	using System;
	using System.Data;
	using System.Runtime.InteropServices;

	using LibertyPower.Business.CommonBusiness.CommonRules;
	using LibertyPower.Business.CommonBusiness.FileManager;
	using LibertyPower.DataAccess.WorkbookAccess;

	[Guid( "B3E70B7D-354A-4dfa-9478-CC5526FEA473" )]
	public class UsageAepExcelSchemaRule : BusinessRule
	{
		#region Fields

		private readonly string WorksheetName = "USAGE HIST DATA";
		private FileContext context;
		private DataSet importFileDataSet;

		#endregion Fields

		#region Constructors

		public UsageAepExcelSchemaRule( FileContext context )
			: base( "UsageAecpeExcelSchemaRule", BrokenRuleSeverity.Error )
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

			VerifyColumnsExist( dataTable, "ESI ID" );
			VerifyColumnsExist( dataTable, "Customer Name" );
			VerifyColumnsExist( dataTable, "Rate Class/Code" );
			VerifyColumnsExist( dataTable, "Zip Code" );
			VerifyColumnsExist( dataTable, "Metered KW" );
			VerifyColumnsExist( dataTable, "Actual KWH" );
			VerifyColumnsExist( dataTable, "Billed KW" );
			VerifyColumnsExist( dataTable, "TDSP Charges" );
			VerifyColumnsExist( dataTable, "Start Date" );
			VerifyColumnsExist( dataTable, "End Date" );
			VerifyColumnsExist( dataTable, "Meter Read Cycle" );
			VerifyColumnsExist( dataTable, "Service Address 1" );
			VerifyColumnsExist( dataTable, "Service Address 2" );
			VerifyColumnsExist( dataTable, "Service Address 3" );
			VerifyColumnsExist( dataTable, "Load Profile" );
			VerifyColumnsExist( dataTable, "Power Factor" );
			VerifyColumnsExist( dataTable, "ERCOT Region" );

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

    [Guid("D5C1A4C1-1B48-40DA-BACD-0088980C3798")]
    public class UsageOncorExcelSchemaRule : BusinessRule
    {
        #region Fields

        private readonly string WorksheetName = "Page1_1";
        private FileContext context;
        private DataSet importFileDataSet;

        #endregion Fields

        #region Constructors

        public UsageOncorExcelSchemaRule(FileContext context)
            : base("UsageOncorExcelSchemaRule", BrokenRuleSeverity.Error)
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
            if (context.FileName.EndsWith(".xls") == false)
            {
                string actualExtension = System.IO.Path.GetExtension(this.context.FullFilePath);
                string format = "Invalid file type '{0}' when only '.xls' can be parsed";
                string message = string.Format(format, actualExtension);
                this.SetException(message);
                return false;
            }

            importFileDataSet = ExcelAccess.GetWorkbookEx(context.FullFilePath, true, false);

            if (importFileDataSet == null)
            {
                string message = string.Format("Unable to read from the '{0}' Excel file", this.context.OriginalFilename);
                this.SetException(message);
                return false;
            }

            if (!importFileDataSet.Tables.Contains(this.WorksheetName))
            {
                this.SetException(this.WorksheetName + " is a required sheet");
                return false;
            }

            DataTable dataTable = importFileDataSet.Tables[this.WorksheetName];

            VerifyColumnsExist(dataTable, "ESI ID");
            VerifyColumnsExist(dataTable, "Customer Name");
            VerifyColumnsExist(dataTable, "Rate Class/Code");
            VerifyColumnsExist(dataTable, "Zip Code");
            VerifyColumnsExist(dataTable, "Metered KW");
            VerifyColumnsExist(dataTable, "Actual KWH");
            VerifyColumnsExist(dataTable, "Billed KW");
            VerifyColumnsExist(dataTable, "TDSP Charges");
            VerifyColumnsExist(dataTable, "Start Date");
            VerifyColumnsExist(dataTable, "End Date");
            VerifyColumnsExist(dataTable, "Meter Read Cycle");
            VerifyColumnsExist(dataTable, "Service Address 1");
            VerifyColumnsExist(dataTable, "Service Address 2");
            VerifyColumnsExist(dataTable, "Service Address 3");
            VerifyColumnsExist(dataTable, "Load Profile");
            VerifyColumnsExist(dataTable, "Power Factor");
            VerifyColumnsExist(dataTable, "ERCOT Region");

            return this.Exception == null;

        }

        private void VerifyColumnsExist(DataTable dataTable, string requiredColumn)
        {
            if (!dataTable.Columns.Contains(requiredColumn))
            {
                SetException(requiredColumn + " is a required column");
            }
        }

        #endregion Methods
    }
}