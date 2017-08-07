using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
    public class FlatEtfCalculator : EtfCalculator
    {

        private const int ResidentialFee1 = 100;
        private const int ResidentialFee2 = 200;

        public FlatEtfCalculator(CompanyAccount companyAccount, DateTime deenrollmentDate, EtfCalculationType calculationType)
            : base(EtfCalculatorType.FlatCalculator, companyAccount, deenrollmentDate, calculationType)
        {


        }

        public override EtfCalculator Calculate()
        {
            int totalContractDays = GetTotalContractDays(CompanyAccount.Term);
            DateTime contractEndDate = GetContractEndDate(CompanyAccount.ContractStartDate, totalContractDays);
            int lostTermDays = GetContractDaysLeft(contractEndDate, DeenrollmentDate);
            double lostTermMonths = lostTermDays / (365.0 / 12);

            if (lostTermMonths < 0)
            {
                this.ErrorMessage = "Cannot calculate ETF. Deenrollment date is on or after Contract End Date.";
                return this;
            }
            if (lostTermMonths < 12)
                this.CalculatedEtfAmount = ResidentialFee1;
            else
                this.CalculatedEtfAmount = ResidentialFee2;

            return this;
        }
    }
}
