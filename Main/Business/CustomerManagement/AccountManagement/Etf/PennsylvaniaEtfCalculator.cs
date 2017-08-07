using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
    public class PennsylvaniaEtfCalculator : EtfCalculator
    {
        private const int MonthlyFee = 10;

        public PennsylvaniaEtfCalculator(CompanyAccount companyAccount, DateTime deenrollmentDate, EtfCalculationType calculationType)
            : base(EtfCalculatorType.MonthScaler, companyAccount, deenrollmentDate, calculationType)
        {


        }

        public override EtfCalculator Calculate()
        {
            int totalContractDays = GetTotalContractDays(CompanyAccount.Term);
            DateTime contractEndDate = GetContractEndDate(CompanyAccount.ContractStartDate, totalContractDays);
            int lostTermDays = GetContractDaysLeft(contractEndDate, DeenrollmentDate);
            double lostTermMonths = Math.Floor(lostTermDays / (365.0 / 12));

            if (lostTermMonths < 0)
            {
                this.ErrorMessage = "Cannot calculate ETF. Deenrollment date is on or after Contract End Date.";
                return this;
            }
            else
            {
                this.CalculatedEtfAmount = Math.Round(MonthlyFee * Convert.ToDecimal(lostTermMonths), 2);
            }
             
            return this;
        }
    }
}
