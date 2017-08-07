using LibertyPower.Business.CommonBusiness.CommonRules;

namespace UsageFileProcessor.Entities.Validation
{
    public class ValidateUsageRule : BusinessRule
    {
        #region Fields

        private ParserAccount account;
        private ParserUsage usage;
        private ParserUtility utility;

        #endregion Fields

        #region Constructors

        public ValidateUsageRule(ParserUsage usage, ParserAccount account, ParserUtility utility)
            : base("ValidateUsageRule", BrokenRuleSeverity.Error)
        {
            this.account = account;
            this.utility = utility;
            this.usage = usage;
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

            // Check that required fields have values

            var requiredFieldsRule = new UsageRequiredValuesRule(this.usage, this.account, this.utility);
            if (!requiredFieldsRule.Validate())
            {
                if (this.Exception == null)
                    this.SetException("Required fields empty or incorrect format for Usages in account " + account.AccountNumber.ToString());

                this.AddDependentException(requiredFieldsRule.Exception);
            }

            return this.Exception == null;
        }

        #endregion Methods
    }
}