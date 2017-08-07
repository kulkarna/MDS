namespace LibertyPower.Business.MarketManagement.MarketParsing
{
    using System;
    using System.Collections.Generic;
    using System.Data;
    using System.Runtime.InteropServices;
    using System.Text;

    using LibertyPower.Business.CommonBusiness.CommonRules;
    using LibertyPower.Business.MarketManagement.UtilityManagement;

    [Guid("966DC1BD-E5FC-4a63-89A6-F93828947E12")]
    class ValidateUsageRule : BusinessRule
    {
        #region Fields

        private ProspectAccountCandidate account;
        private UsageCandidate usage;
        private UtilityStandIn utility;

        #endregion Fields

        #region Constructors

        public ValidateUsageRule(UsageCandidate usage, ProspectAccountCandidate account, UtilityStandIn utility)
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

            UsageRequiredValuesRule requiredFieldsRule = new UsageRequiredValuesRule(this.usage, this.account, this.utility);
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