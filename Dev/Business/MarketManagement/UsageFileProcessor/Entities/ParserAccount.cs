using System;
using LibertyPower.Business.CommonBusiness.CommonEntity;
using LibertyPower.Business.CommonBusiness.CommonRules;
using LibertyPower.Business.MarketManagement.UtilityManagement;
using UsageFileProcessor.Entities.Enums;
using UsageFileProcessor.Entities.Validation;

namespace UsageFileProcessor.Entities
{
    public class ParserAccount : UtilityAccount
    {
                 #region Fields

        private BrokenRuleException brokenRuleException;
        private int excelRow;
        private string sheetName;
        private ValidationResult validationResult;
        private string _meterType;

        #endregion Fields

        #region Constructors

        internal ParserAccount(long id, string accountNumber, string utilityCode)
            : base(id, accountNumber, utilityCode)
        {
        }

        internal ParserAccount(int excelRow)
        {
            this.excelRow = excelRow;
            this.validationResult = ValidationResult.Untested;
        }

        internal ParserAccount(int excelRow, string sheetName)
        {
            this.excelRow = excelRow;
            this.sheetName = sheetName;
            this.validationResult = ValidationResult.Untested;
        }

        #endregion Constructors

        #region Properties

        /// <summary>
        /// Identifies the row from the excel file that this ProspectAccountCandidate was parsed from
        /// </summary>
        public int ExcelRow
        {
            get
            {
                return excelRow;
            }
        }

        /// <summary>
        /// contains any BrokenRuleExceptions triggered in this ProspectAccountCandidate
        /// </summary>
        public new BrokenRuleException Exception
        {
            get
            {
                return brokenRuleException;
            }
        }


        /// <summary>
        /// specifies the sheetname, if more than one exists, of the excel upload file this ProspectAccount was parsed from
        /// </summary>
        public string SheetName
        {
            get { return sheetName; }
        }

        public ValidationResult ValidationStatus
        {
            get
            {
                return validationResult;
            }
            set
            {
                if (validationResult == ValidationResult.Untested)
                    validationResult = value;
            }
        }

        public string MeterType
        {
            get { return _meterType ?? string.Empty; }
            set { _meterType = value; }
        }

        public decimal? FutureICap { get; set; }
        public decimal? FutureTCap { get; set; }
        public string FutureICapEffectiveDate { get; set; }
        public string FutureTCapEffectiveDate { get; set; }

        public string Error { get; set; }

        public bool HasError { get { return !string.IsNullOrWhiteSpace(Error); } }
     
        #endregion Properties

        #region Methods

        internal void AddUsage(ParserUsage usage)
        {
            base.Usages.Add(usage.EndDate, usage);
        }

        internal bool Validate(ParserUtility utility)
        {
            bool result = false;
            var validateUtilityAccountRule = new ValidateUtilityAccountRule(this, utility);
            if (validateUtilityAccountRule.Validate() != true)
            {
                this.brokenRuleException = (BrokenRuleException)validateUtilityAccountRule.Exception;
                validationResult = ValidationResult.Invalid;
                return false;
            }
            else
            {
                validationResult = ValidationResult.Valid;
                result = true;
            }

            return result;
        }

        internal bool Validate()
        {
            var result = false;
            var validateUtilityAccountRule = new CustomAccountCandidateValidationRule(this);
            if (validateUtilityAccountRule.Validate() != true)
            {
                this.brokenRuleException = (BrokenRuleException)validateUtilityAccountRule.Exception;
                validationResult = ValidationResult.Invalid;
                return false;
            }
            else
            {
                validationResult = ValidationResult.Valid;
                result = true;
            }

            return result;
        }
        #endregion Methods
    }
}