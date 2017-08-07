namespace LibertyPower.Business.MarketManagement.MarketParsing
{
    using System;
    using System.Collections.Generic;
    using System.Data;
    using System.Runtime.InteropServices;
    using System.Text;

    using LibertyPower.Business.CommonBusiness.CommonRules;
    using LibertyPower.Business.MarketManagement.UtilityManagement;

    [Guid("8A363B68-38C4-4a04-B869-89843906F9C6")]
    class ValidateUtilityAccountRule : BusinessRule
    {
        #region Fields

        private ProspectAccountCandidate account;
        private UtilityStandIn utility;

        #endregion Fields

        #region Constructors

        public ValidateUtilityAccountRule(ProspectAccountCandidate account, UtilityStandIn utility)
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

            string prefix = this.utility.AccountNumberPrefix;
            int exactLength = this.utility.AccountNumberLength;

            // Check account number length and prefix
            UtilityManagement.AccountNumberRule accountNumberRule = new UtilityManagement.AccountNumberRule(this.account.AccountNumber, prefix, exactLength);
            if (!accountNumberRule.Validate())
            {
                if (this.Exception == null)
                    this.SetException("Required fields empty or incorrect format for Excel row " + account.ExcelRow.ToString());

                this.AddDependentException(accountNumberRule.Exception);

            }

            // Check that required fields have values

            UtilityAccountRequiredValuesRule requiredFieldsRule = new UtilityAccountRequiredValuesRule(this.account, this.utility);
            if (!requiredFieldsRule.Validate())
            {
                if (this.Exception == null)
                    this.SetException("Required fields empty or incorrect format for Excel row " + account.ExcelRow.ToString());

                this.AddDependentException(requiredFieldsRule.Exception);

            }

            // Validate any usages that this account may have

            foreach (UsageCandidate usage in this.account.Usages.Values)
            {

                BrokenRuleException exception = usage.Validate(this.account, this.utility);
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