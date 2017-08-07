using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
    class ManualEntryCalculator :  EtfCalculator
    {
        public ManualEntryCalculator( CompanyAccount companyAccount)
            : base ( EtfCalculatorType.Manual, companyAccount, companyAccount.DeenrollmentDate, EtfCalculationType.Actual )
        {
        }

        public override EtfCalculator Calculate() 
        {
            return this;
        }
    }
}
