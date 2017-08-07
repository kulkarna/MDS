using LibertyPower.Business.CommonBusiness.CommonRules;
using LibertyPower.Business.MarketManagement.UtilityManagement;
using UsageFileProcessor.Entities.Enums;
using UsageFileProcessor.Entities.Validation;

namespace UsageFileProcessor.Entities
{
    public class ParserUsage : Usage
    {
            #region Fields

        private int excelRowNumber;
        private string excelSheetName;
        private ValidationResult validationResult;

        #endregion Fields

        #region Constructors

        internal ParserUsage(int excelRowNumber, string sheetName)
        {
            this.excelRowNumber = excelRowNumber;
            this.excelSheetName = sheetName;
            this.validationResult = ValidationResult.Untested;
        }

        internal ParserUsage(int excelRowNumber)
        {
            this.excelRowNumber = excelRowNumber;
            this.excelSheetName = ""; //unused
            this.validationResult = ValidationResult.Untested;
        }

        #endregion Constructors

        #region Properties

        public int ExcelRowNumber
        {
            get { return excelRowNumber; }
        }

        public string ExcelSheetName
        {
            get { return excelSheetName; }
        }

        public ValidationResult ValidationStatus
        {
            get
            {
                return validationResult;
            }
        }

        #endregion Properties

        #region Methods

        internal BrokenRuleException Validate( ParserAccount account, ParserUtility utility )
        {
            var usageRule = new ValidateUsageRule( this, account, utility );
            if( !usageRule.Validate() )
            {
                this.validationResult = ValidationResult.Invalid;
            }
            else
            {
                this.validationResult = ValidationResult.Valid;
            }
            return usageRule.Exception;
        }

        #endregion Methods
    }
}