using LibertyPower.Business.CommonBusiness.CommonRules;
using LibertyPower.Business.MarketManagement.UtilityManagement;

namespace UsageFileProcessor.Entities.Validation
{
    public class ValidateUtilityAccountRule : BusinessRule
    {
        #region Fields

        private ParserAccount account;
        private ParserUtility utility;

        #endregion Fields

        #region Constructors

        public ValidateUtilityAccountRule(ParserAccount account, ParserUtility utility)
            : base("ValidateUtilityAccountRule", BrokenRuleSeverity.Error)
        {
            this.account = account;
            this.utility = utility;
        }

        #endregion Constructors

        #region Methods

        public override bool Validate()
        {
            if (utility == null)
            {
                this.SetException("Utility not found in Excel row " + account.ExcelRow.ToString());
                return false;
            }

            var prefix = this.utility.AccountNumberPrefix;
            var exactLength = this.utility.AccountNumberLength;

            // Check account number length and prefix
            var accountNumberRule = new AccountNumberRule(this.account.AccountNumber, prefix, exactLength);
            if (!accountNumberRule.Validate())
            {
                if (this.Exception == null)
                    this.SetException("Required fields empty or incorrect format for Excel row " + account.ExcelRow.ToString());

                this.AddDependentException(accountNumberRule.Exception);

            }

            // Check that required fields have values

            var requiredFieldsRule = new UtilityAccountRequiredValuesRule(this.account, this.utility);
            if (!requiredFieldsRule.Validate())
            {
                if (this.Exception == null)
                    this.SetException("Required fields empty or incorrect format for Excel row " + account.ExcelRow.ToString());

                this.AddDependentException(requiredFieldsRule.Exception);

            }

            // Validate any usages that this account may have

            foreach (ParserUsage usage in this.account.Usages.Values)
            {

                var exception = usage.Validate(this.account, this.utility);
                if (exception != null)
                {
                    if (this.Exception == null)
                        this.SetException("Required fields empty or incorrect format for Excel row " + account.ExcelRow.ToString());

                    this.AddDependentException(exception);
                }
            }

            return this.Exception == null;
        }

        #endregion Methods
    }
}