using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
    public class NewYorkEtfCalculator: EtfCalculator
    {

		private const int ResidentialFee1 = 100;
        private const int ResidentialFee2 = 200;

        public NewYorkEtfCalculator(CompanyAccount companyAccount, DateTime deenrollmentDate, EtfCalculationType calculationType)
            : base( EtfCalculatorType.DoorToDoorCalculator, companyAccount, deenrollmentDate, calculationType )
        {


        }

		public override EtfCalculator Calculate()
		{
            //There is no ETF for Freedom to Save products (term = 3)
            if (CompanyAccount.Term == 3)
            {
                this.CalculatedEtfAmount = 0;
            }
            else
            {
                if (CompanyAccount.AccountType == CompanyAccountType.RESIDENTIAL)
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
                }
                else
                {
                    this.CalculatedEtfAmount = Math.Round(2 * this.CompanyAccount.GetAverageInvoice(), 2);
                }
            }

			return this;
        }
    }
}
