namespace LibertyPower.Business.MarketManagement.MarketParsing
{
    using System;
    using System.Collections.Generic;
    using System.Text;
    using System.Data;

    using LibertyPower.Business.CommonBusiness.CommonEntity;
    using LibertyPower.Business.CommonBusiness.CommonRules;
    using LibertyPower.Business.CommonBusiness.FileManager;
    using LibertyPower.Business.MarketManagement.UtilityManagement;
    using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;

    public abstract class Parser
    {
        #region Fields

        protected bool acceptFile;
        protected BrokenRuleException brokenRuleException;
        protected FileContext fileContext;
        protected ParserFileType parserFileType;
        protected UtilityAccountList utilityAccounts;
        protected UtilityDictionary utilityDictionary;

        #endregion Fields

        #region Constructors

        internal Parser(FileContext fileContext)
        {
            this.parserFileType = ParserFileType.Unknown;
            this.fileContext = fileContext;
            this.acceptFile = false;
        }

        #endregion Constructors

        #region Properties

        internal BrokenRuleException Exception
        {
            get
            {
                return brokenRuleException;
            }
            set
            {
                if (brokenRuleException == null)
                    brokenRuleException = value;
            }
        }

        internal ParserFileType FileType
        {
            get { return parserFileType; }
            set { parserFileType = value; }
        }

        internal UtilityAccountList UtilityAccounts
        {
            get
            {
                return utilityAccounts;
            }
        }

        #endregion Properties

        #region Methods

        internal virtual ParserResult GetResult(UtilityAccountList utilityAccounts, FileContext fileContext, ParserFileType parserFileType, BrokenRuleException brokenRuleException, bool acceptFile)
        {
            return OfferEngineUploadsParserFactory.PackageParserResult(utilityAccounts, fileContext, parserFileType, brokenRuleException, acceptFile);
        }

        internal virtual ParserResult PackageParserResult()
        {

            acceptFile = true;
            if (utilityAccounts == null || utilityAccounts.Count < 1)
                acceptFile = false;
            else
                foreach (ProspectAccountCandidate candidate in this.utilityAccounts)
                {
                    if (candidate.ValidationStatus == ValidationResult.Invalid)
                        acceptFile = false;
                }
            ParserResult parserResult = this.GetResult(this.utilityAccounts, this.fileContext, this.parserFileType, this.brokenRuleException, this.acceptFile);

            return parserResult;
        }

        internal virtual ParserResult PackageParserResult(bool validateAccounts)
        {

            acceptFile = true;

            if (validateAccounts  && utilityAccounts != null )
            {
                var collection = new ProspectAccountCandidateCollection();
                foreach (var prospect in utilityAccounts)
                    collection.Add((ProspectAccountCandidate)prospect);

                CustomAccountCandidateCollectionValidationRule rule = new CustomAccountCandidateCollectionValidationRule(collection);

                if (rule.Validate() == false)
                    this.Exception = rule.Exception;


            }
            if (utilityAccounts == null || utilityAccounts.Count < 1)
                acceptFile = false;
            else
                foreach (ProspectAccountCandidate candidate in this.utilityAccounts)
                    if (candidate.ValidationStatus != ValidationResult.Valid)
                        acceptFile = false;

            ParserResult parserResult = this.GetResult(this.utilityAccounts, this.fileContext, this.parserFileType, this.brokenRuleException, this.acceptFile);

            return parserResult;
        }

        protected DataSet RemoveEmptyRows(DataSet ds, bool trailingOnly)
        {
            if (ds == null)
                return ds;

            if (trailingOnly == false)
            {
                for (int i = 0; i < ds.Tables.Count; i++)
                {
                    DataTable dt = ds.Tables[0];
                    dt = RemoveEmptyRows(dt, false);
                }
            }
            else
            {
                for (int i = 0; i < ds.Tables.Count; i++)
                {
                    DataTable dt = ds.Tables[0];
                    dt = RemoveEmptyRows(dt, true);
                }
            }
            return ds;
        }

        protected DataSet RemoveEmptyRows(DataSet ds)
        {
            return RemoveEmptyRows(ds, false);
        }

        private bool HasEmptyRows(DataTable dt, out Int32 hint)
        {
            Int32 i = -1;
            foreach (DataRow row in dt.Rows)
            {
                i++;
                if (IsRowEmpty(row) == true)
                {
                    hint = i;
                    return true;
                }
            }
            hint = -1;
            return false;
        }

        private DataTable RemoveEmptyRows(DataTable dt, bool trailingOnly)
        {
            if (trailingOnly == false)
            {
                Int32 hint = -1;
                bool hasEmpties = true;
                while (hasEmpties)
                {
                    hasEmpties = HasEmptyRows(dt, out hint);
                    if (hasEmpties && hint > 0 && hint < dt.Rows.Count)
                        dt.Rows.RemoveAt(hint);
                }
            }
            else
            {
                bool hasEmpties = true;
                while (hasEmpties)
                {
                    hasEmpties = HasEmptyRowsTrailing(dt);
                    if (hasEmpties)
                        dt = RemoveEmptyRowTrailing(dt);
                }
            }
            return dt;
        }

        private bool HasEmptyRowsTrailing(DataTable dt)
        {
            if (dt.Rows.Count < 1)
                return false;
            else
            {
                Int32 lastRowIndex = dt.Rows.Count - 1;
                return IsRowEmpty(dt.Rows[lastRowIndex]);
            }
        }

        private DataTable RemoveEmptyRowTrailing(DataTable dt)
        {
            if (dt == null || dt.Rows.Count < 1)
                return dt;
            else
            {
                Int32 lastRowIndex = dt.Rows.Count - 1;
                dt.Rows.RemoveAt(lastRowIndex);
                return dt;
            }
        }

        private bool IsRowEmpty(DataRow row)
        {
            foreach (object o in row.ItemArray)
            {
                string buf = o.ToString().Trim();
                if (buf.Length > 0)
                    return false;
            }
            return true;
        }

        #endregion Methods
    }
}