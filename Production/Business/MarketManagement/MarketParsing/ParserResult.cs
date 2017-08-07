namespace LibertyPower.Business.MarketManagement.MarketParsing
{
    using System;
    using System.Collections.Generic;
    using System.Data;
    using System.Text;

    using LibertyPower.Business.CommonBusiness.CommonEntity;
    using LibertyPower.Business.CommonBusiness.CommonRules;
    using LibertyPower.Business.CommonBusiness.FileManager;
    using LibertyPower.Business.MarketManagement.UtilityManagement;
    using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;

    public class ParserResult
    {
        #region Fields

        protected bool acceptFile;
        protected BrokenRuleException brokenRuleException;
        protected FileContext fileContext;
        protected ParserFileType parserFileType;
        protected UtilityAccountList utilityAccounts;

        #endregion Fields

        #region Constructors

        /// <summary>
        /// create a minimal parser result type 
        /// </summary>
        /// <param name="type"></param>
        internal ParserResult(FileContext fileContext, ParserFileType type, bool acceptFile)
        {
            this.acceptFile = acceptFile;
            this.fileContext = fileContext;
            this.parserFileType = type;
        }

        /// <summary>
        /// Contains the results from the parsing of an uploaded file containing UtilityAccounts
        /// </summary>
        /// <param name="fileContext"></param>
        internal ParserResult(UtilityAccountList utilityAccounts, FileContext fileContext, ParserFileType parserFileType, BrokenRuleException brokenRuleException, bool acceptFile)
        {
            this.utilityAccounts = utilityAccounts;
            this.fileContext = fileContext;
            this.parserFileType = parserFileType;
            this.brokenRuleException = brokenRuleException;
            this.acceptFile = acceptFile;
        }

        #endregion Constructors

        #region Properties

        /// <summary>
        /// Utility Account Upload files will only be accepted without errors; this property will 
        /// determine if the file is to be accepted and ultimately saved to the database
        /// </summary>
        public bool AcceptFile
        {
            get
            {
                return acceptFile;
            }
        }

        /// <summary>
        /// Contains any BrokenRuleExceptions created in the Excel file format validation, before a list of prospectAccountCandidates is checked.  
        /// Check that this is null before attempting to look further at the ParserResults object
        /// </summary>
        public BrokenRuleException Exception
        {
            get
            {
                return brokenRuleException;
            }
        }

        /// <summary>
        /// FileContext of parser target file
        /// </summary>
        public FileContext FileContext
        {
            get { return fileContext; }
        }

        /// <summary>
        /// Format of target Xls file
        /// </summary>
        public ParserFileType FileType
        {
            get
            {
                return parserFileType;
            }
        }

        /// <summary>
        /// Describes the excel schema type that was parsed in this ParserResult
        /// </summary>
        public ParserFileType ParserType
        {
            get { return parserFileType; }
        }

        /// <summary>
        /// The FileContext for the uploaded UtilityAccount Excel file
        /// </summary>
        public LibertyPower.Business.CommonBusiness.FileManager.FileContext UploadFileContext
        {
            get
            {
                return fileContext;
            }
        }

        /// <summary>
        /// List of all UtilityAccounts created from the FileContext. The ValidationStatus of each represents a pass/fail result for each ProspectAccountCandidate
        /// </summary>
        public UtilityAccountList UtilityAccounts
        {
            get
            {
                return utilityAccounts;
            }
        }

        #endregion Properties

        /// <summary>
        /// Recurses the errors to data table.
        /// </summary>
        /// <returns></returns>
        public DataTable RecurseErrorsToDataTable()
        {
            DataTable dt = null;
            if (brokenRuleException != null)
            {
                dt = new DataTable();
                dt.Columns.Add(new DataColumn("Status"));
                dt.Columns.Add(new DataColumn("Description"));
                dt = RecurseErrors(brokenRuleException, dt);
            }
            return dt;
        }

        /// <summary>
        /// Recurses the errors to data table.
        /// </summary>
        /// <returns></returns>
        public string RecurseErrorsToLabelText()
        {
            DataTable dt = null;
            if (brokenRuleException != null)
            {
                dt = new DataTable();
                dt.Columns.Add(new DataColumn("Status"));
                dt.Columns.Add(new DataColumn("Description"));
                dt = RecurseErrors(brokenRuleException, dt);
            }
            var sb = new StringBuilder();
            if (dt != null)
            {
                foreach (DataRow row in dt.Rows)
                {
                    var item = string.Format("{0} : {1}</br>", row[0], row[1]);
                    sb.Append(item);
                }
            }
            return sb.ToString();
        }

        private DataTable RecurseErrors(BrokenRuleException brokenRule, DataTable dt)
        {
            if (brokenRule != null)
            {
                DataRow row = dt.NewRow();
                row["Description"] = brokenRule.Message;
                if (brokenRule.Severity == BrokenRuleSeverity.Error)
                    row["Status"] = "Error";
                else if (brokenRule.Severity == BrokenRuleSeverity.Warning)
                    row["Status"] = "Warning";
                else if (brokenRule.Severity == BrokenRuleSeverity.Information)
                    row["Status"] = "Information";
                dt.Rows.Add(row);
                if (brokenRule.DependentExceptions != null)
                {
                    foreach (BrokenRuleException br in brokenRule.DependentExceptions)
                    {
                        dt = RecurseErrors(br, dt);
                    }
                }
            }
            return dt;
        }

    }
}