namespace LibertyPower.Business.MarketManagement.MarketParsing
{
    using System;
    using System.Collections.Generic;
    using System.Data;
    using System.Text;

    using LibertyPower.Business.CommonBusiness.CommonEntity;
    using LibertyPower.Business.CommonBusiness.CommonExceptions;
    using LibertyPower.Business.CommonBusiness.CommonRules;
    using LibertyPower.Business.MarketManagement.UtilityManagement;
    using LibertyPower.DataAccess.SqlAccess.CommonSql;
    using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;

    public class UsageCandidate : Usage
    {
        #region Fields

        private int excelRowNumber;
        private string excelSheetName;
        private ValidationResult validationResult;

        #endregion Fields

        #region Constructors

        internal UsageCandidate(int excelRowNumber, string sheetName)
        {
            this.excelRowNumber = excelRowNumber;
            this.excelSheetName = sheetName;
            this.validationResult = ValidationResult.Untested;
        }

        internal UsageCandidate( int excelRowNumber )
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

        internal BrokenRuleException Validate( ProspectAccountCandidate account, UtilityStandIn utility )
        {
            ValidateUsageRule usageRule = new ValidateUsageRule( this, account, utility );
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