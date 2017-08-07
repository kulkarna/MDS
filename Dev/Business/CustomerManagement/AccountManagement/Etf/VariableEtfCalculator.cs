using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
    public class VariableEtfCalculator : EtfCalculator
    {

		private const int Tier1Fee = 750;
		private const int Tier2Fee = 1500;
		private const int Tier3Fee = 2500;

		public int AccountCount { get; set; }

		public Int64 AverageAnnualConsumption
		{
			get;
			set;
		}

		public VariableEtfCalculator( CompanyAccount companyAccount, DateTime deenrollmentDate, EtfCalculationType calculationType )
			: base( EtfCalculatorType.Variable, companyAccount, deenrollmentDate, calculationType )
        {


        }

		public override EtfCalculator Calculate()
		{
			Contract contract = ContractFactory.GetContractWithAccounts( CompanyAccount.ContractNumber );
			foreach ( CompanyAccount companyAccount in contract.Accounts )
			{
				AverageAnnualConsumption += companyAccount.AnnualUsage;
			}

			AccountCount = contract.Accounts.Count;

			int etfContractFee = 0;
			if ( AverageAnnualConsumption <= 75000 )
			{
				etfContractFee = Tier1Fee;
			}
			else if ( AverageAnnualConsumption > 75000 && AverageAnnualConsumption <= 200000 )
			{
				etfContractFee = Tier2Fee;
			}
			else
        {
				etfContractFee = Tier3Fee;
			}

			this.CalculatedEtfAmount = Convert.ToDecimal( etfContractFee ) / AccountCount;

			return this;
        }

    }
}
