namespace LibertyPower.Business.MarketManagement.MarketParsing
{
    using System;
    using System.Data;
    using System.Runtime.InteropServices;

    using LibertyPower.Business.CommonBusiness.CommonRules;

    [Guid("C928F2E1-74FF-406a-B15C-51944037A4B4")]
    public class UtilityCodeIsKnownValueRule : BusinessRule
    {
        #region Fields

        private ProspectAccountCandidate account;
        private string[] allUtilityCodes;

        #endregion Fields

        #region Constructors

        public UtilityCodeIsKnownValueRule(ProspectAccountCandidate account, string[] allUtilityCodes)
            : base("UtilityCodeIsKnownValueRule", BrokenRuleSeverity.Error)
        {
            this.account = account;
            this.allUtilityCodes = allUtilityCodes;
        }

        #endregion Constructors

        #region Methods

        public override bool Validate()
        {
            bool found = this.UtilityCodeKnown();

            if (found == false)
            {
                string format = "The utility code [{0}]  is unknown for item in excel row {1}.";
                string reason = string.Format(format, this.account.UtilityCode, this.account.ExcelRow);
                this.SetException(reason);
            }

            return this.Exception == null;
        }

        private bool UtilityCodeKnown()
        {
            if (account.UtilityCode == null || account.UtilityCode.Trim().Length == 0)
                return false;

            foreach (string uc in this.allUtilityCodes)
            {

                if (string.Compare(account.UtilityCode, uc) == 0)
                    return true;
            }

            return false;
        }

        #endregion Methods
    }
}