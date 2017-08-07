



namespace LibertyPower.Business.MarketManagement.MarketParsing
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using System.Data;
    using System.Runtime.InteropServices;

    using LibertyPower.Business.CommonBusiness.CommonRules;
    using LibertyPower.Business.MarketManagement.UtilityManagement;

    [Guid("299BA067-C66B-48D1-8E72-186AADF8CCC3")]
    public class CustomAccountCandidateValidationRule : BusinessRule
    {
        private ProspectAccountCandidate _account;
        
        public CustomAccountCandidateValidationRule(ProspectAccountCandidate account)
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

            var futureIcapNumeric = new NumericValueRule(_account.FutureIcap, "Future ICAP", _account.ExcelRow);
            if (futureIcapNumeric.Validate() == false)
            {
                AddDependentException(futureIcapNumeric.Exception);
            }

            if(_account.FutureIcap.HasValue)
            {
                var futureIcapEffectiveDateExists = new ValueExistsRule(_account.FutureIcapEffectiveDate, "Future ICAP Effective Date", _account.ExcelRow);
                
                if(futureIcapEffectiveDateExists.Validate()==false)
                {
                    AddDependentException(futureIcapEffectiveDateExists.Exception);
                }
                else if(_account.FutureIcapEffectiveDate.HasValue)
                {
                    var futureIcapEffectiveDateIsDate = new ValueExistsRule(_account.FutureIcapEffectiveDate, "Future ICAP Effective Date", _account.ExcelRow);
                    if (futureIcapEffectiveDateIsDate.Validate() == false)
                    {
                        AddDependentException(futureIcapEffectiveDateIsDate.Exception);
                    }
                    else
                    {
                        var futureIcapEffectiveDateInFuture = new MinimumDateRule(_account.FutureIcapEffectiveDate, "Future ICAP Effective Date", _account.ExcelRow);
                        if (futureIcapEffectiveDateInFuture.Validate() == false)
                        {
                            AddDependentException(futureIcapEffectiveDateInFuture.Exception);
                        }
                    }
                }

            }

            var futureTcapNumeric = new NumericValueRule(_account.FutureTcap, "Future TCAP", _account.ExcelRow);
            if (futureTcapNumeric.Validate() == false)
            {
                AddDependentException(futureTcapNumeric.Exception);
            }

            if (_account.FutureTcap.HasValue)
            {
                var futureTcapEffectiveDateExists = new ValueExistsRule(_account.FutureTcapEffectiveDate, "Future TCAP Effective Date", _account.ExcelRow);

                if (futureTcapEffectiveDateExists.Validate() == false)
                {
                    AddDependentException(futureTcapEffectiveDateExists.Exception);
                }
                else if (_account.FutureTcapEffectiveDate.HasValue)
                {
                    var futureTcapEffectiveDateIsDate = new ValueExistsRule(_account.FutureTcapEffectiveDate, "Future TCAP Effective Date", _account.ExcelRow);
                    if (futureTcapEffectiveDateIsDate.Validate() == false)
                    {
                        AddDependentException(futureTcapEffectiveDateIsDate.Exception);
                    }
                    else
                    {
                        var futureTcapEffectiveDateInFuture = new MinimumDateRule(_account.FutureTcapEffectiveDate, "Future TCAP Effective Date", _account.ExcelRow);
                        if (futureTcapEffectiveDateInFuture.Validate() == false)
                        {
                            AddDependentException(futureTcapEffectiveDateInFuture.Exception);
                        }
                    }
                }

            }

            return Exception == null;
        }
    }
}
