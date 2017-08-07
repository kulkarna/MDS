using System;
using LibertyPower.Business.CommonBusiness.CommonRules;

namespace UsageFileProcessor.Entities.Validation
{
    public class CustomAccountCandidateValidationRule : BusinessRule
    {
        private ParserAccount _account;

        public CustomAccountCandidateValidationRule(ParserAccount account)
            : base("CustomAccountCandidateValidationRule", BrokenRuleSeverity.Error)
        {
            _account = account;
        }

        public override bool Validate()
        {
            var accountNumberExists = new ValueExistsRule(_account.AccountNumber, "Account Number", _account.ExcelRow);
            if (accountNumberExists.Validate() == false)
                AddDependentException(accountNumberExists.Exception);


            var marketExists = new ValueExistsRule(_account.RetailMarketCode, "Market", _account.ExcelRow);
            if (marketExists.Validate() == false)
                AddDependentException(marketExists.Exception);

            var utilityExists = new ValueExistsRule(_account.UtilityCode, "Utility", _account.ExcelRow);
            if (utilityExists.Validate() == false)
            {
                AddDependentException(utilityExists.Exception);
            }

            var icapNumeric = new NumericValueRule(_account.Icap, "ICAP", _account.ExcelRow);
            if (icapNumeric.Validate() == false)
            {
                AddDependentException(icapNumeric.Exception);
            }

            var tcapNumeric = new NumericValueRule(_account.Tcap, "TCAP", _account.ExcelRow);
            if (tcapNumeric.Validate() == false)
            {
                AddDependentException(tcapNumeric.Exception);
            }

            

            return Exception == null;
        }
    }
}