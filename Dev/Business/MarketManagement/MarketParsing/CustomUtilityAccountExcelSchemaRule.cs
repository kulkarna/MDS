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
    [Guid("647F3699-1548-4EFC-A04C-2E79A7ACABDE")]
    public class CustomUtilityAccountExcelSchemaRule : BusinessRule
    {
        #region Fields

        private readonly string WorksheetName = "AccountListing";
        private FileContext context;
        private DataSet importFileDataSet;

        #endregion Fields

        #region Constructors

        public CustomUtilityAccountExcelSchemaRule(FileContext context)
            : base("CustomUtilityAccountExcelFormatRule", BrokenRuleSeverity.Error)
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
            if (!context.FileName.EndsWith(".xls"))
            {
                string actualExtension = System.IO.Path.GetExtension(this.context.FullFilePath);
                string format = "Invalid file type '{0}'. Only '.xls' can be parsed";
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

            VerifyColumnsExist(dataTable, "Account Number");
            VerifyColumnsExist(dataTable, "Market");
            VerifyColumnsExist(dataTable, "Utility");
            VerifyColumnsExist(dataTable, "Meter Type");
            VerifyColumnsExist(dataTable, "Meter Number");

            VerifyColumnsExist(dataTable, "Voltage");
            VerifyColumnsExist(dataTable, "Address");
            VerifyColumnsExist(dataTable, "Suite");
            VerifyColumnsExist(dataTable, "City");
            VerifyColumnsExist(dataTable, "State");

            VerifyColumnsExist(dataTable, "Zip");
            VerifyColumnsExist(dataTable, "Congestion Zone");
            VerifyColumnsExist(dataTable, "ICAP");
            VerifyColumnsExist(dataTable, "TCAP");
            VerifyColumnsExist(dataTable, "Loss Factor ID");
            VerifyColumnsExist(dataTable, "Load Shape ID");
            VerifyColumnsExist(dataTable, "Rate Class");
            VerifyColumnsExist(dataTable, "Name Key");

            VerifyColumnsExist(dataTable, "Billing Account");
            VerifyColumnsExist(dataTable, "Tariff Code");
            VerifyColumnsExist(dataTable, "Load Profile");
            VerifyColumnsExist(dataTable, "Grid");
            VerifyColumnsExist(dataTable, "LBMP Zone");
            VerifyColumnsExist(dataTable, "Service Class");

            if (AccountsFileHasExtendedFormat(dataTable))
            {

                VerifyOptionalColumnsExist(dataTable, "Future ICAP");
                VerifyOptionalColumnsExist(dataTable, "Future ICAP Effective Date");
                VerifyOptionalColumnsExist(dataTable, "Future TCAP");
                VerifyOptionalColumnsExist(dataTable, "Future TCAP Effective Date");
                VerifyOptionalColumnsExist(dataTable, "Lock Meter Type");
                VerifyOptionalColumnsExist(dataTable, "Lock Voltage");
                VerifyOptionalColumnsExist(dataTable, "Lock Congestion Zone");
                VerifyOptionalColumnsExist(dataTable, "Lock ICAP");
                VerifyOptionalColumnsExist(dataTable, "Lock Future ICAP");
                VerifyOptionalColumnsExist(dataTable, "Lock TCAP");
                VerifyOptionalColumnsExist(dataTable, "Lock Future TCAP");
                VerifyOptionalColumnsExist(dataTable, "Lock Loss Factor ID");
                VerifyOptionalColumnsExist(dataTable, "Lock Load Shape ID");
                VerifyOptionalColumnsExist(dataTable, "Lock Rate Class");
                VerifyOptionalColumnsExist(dataTable, "Lock Tariff Code");
                VerifyOptionalColumnsExist(dataTable, "Lock Profile");
                VerifyOptionalColumnsExist(dataTable, "Lock Grid");
                VerifyOptionalColumnsExist(dataTable, "Lock LBMP Zone");
                VerifyOptionalColumnsExist(dataTable, "Lock Service Class");
            }


          
            
            return this.Exception == null;
        }

        private void VerifyColumnsExist(DataTable dataTable, string requiredColumn)
        {
            if (!dataTable.Columns.Contains(requiredColumn))
            {
                SetException(requiredColumn + " is a required column");
            }
        }

        private bool AccountsFileHasExtendedFormat(DataTable accountsList)
        {
            var optionalColumns = new[]
                                          {
                                              "Future ICAP", "Future ICAP Effective Date", "Future TCAP", "Future TCAP Effective Date", "Lock Meter Type",
                                               "Lock Voltage", "Lock Congestion Zone", "Lock ICAP", "Lock Future ICAP", 
                                               "Lock TCAP", "Lock Future TCAP", "Lock Loss Factor ID", "Lock Load Shape ID", "Lock Rate Class", "Lock Tariff Code", 
                                               "Lock Profile","Lock Grid", "Lock LBMP Zone","Lock Service Class"
                                          };

            foreach (var header in optionalColumns)
            {
                if (accountsList.Columns.Contains(header) == true)
                    return true;
            }
            return false;
        }
        private void VerifyOptionalColumnsExist(DataTable dataTable, string requiredColumn)
        {

            if (!dataTable.Columns.Contains(requiredColumn))
            {
                SetException(requiredColumn + " is a required column when using the locking functionality.");
            }
        }
        #endregion Methods
    }
}