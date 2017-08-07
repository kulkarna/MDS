using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
    public class DoubleMonthlyEtfCalculator : EtfCalculator
    {

        private const int ResidentialFee1 = 100;

        public DoubleMonthlyEtfCalculator(CompanyAccount companyAccount, DateTime deenrollmentDate, EtfCalculationType calculationType)
            : base(EtfCalculatorType.DoubleMonthlyCalculator, companyAccount, deenrollmentDate, calculationType)
        {


        }

        public override EtfCalculator Calculate()
        {
            decimal ResidentialFee2 = Math.Round(2 * this.CompanyAccount.GetAverageInvoice(), 2);
            this.CalculatedEtfAmount = Math.Min(ResidentialFee1, ResidentialFee2);

            return this;
        }
    }
}
