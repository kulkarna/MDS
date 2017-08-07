namespace LibertyPower.Business.MarketManagement.MarketParsing
{

    using System;
    using System.Data;
    using System.Runtime.InteropServices;
    using LibertyPower.Business.CommonBusiness.CommonRules;

    [Guid("C29B687F-5DE4-46CA-B84A-0BACCC442417")]
    public class CustomAccountCandidateCollectionValidationRule : BusinessRule
    {
        private ProspectAccountCandidateCollection _accounts = null;
        public CustomAccountCandidateCollectionValidationRule(ProspectAccountCandidateCollection accounts)
            : base("CustomAccountCandidateCollectionValidationRule", BrokenRuleSeverity.Error)
        {
            _accounts = accounts;
        }

        public override bool Validate()
        {
            for (var i = 0; i < _accounts.Count; i++)
            {
                var rule = new CustomAccountCandidateValidationRule(_accounts[i]);
                if (rule.Validate() == false)
                {
                     _accounts[i].ValidationStatus = ValidationResult.Invalid;
                    AddDependentException(rule.Exception);
                }
                else
                {
                    _accounts[i].ValidationStatus = ValidationResult.Valid;
                }
            }
            return Exception == null;
        }
    }
}
