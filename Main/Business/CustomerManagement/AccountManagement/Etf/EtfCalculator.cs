using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
    public abstract class EtfCalculator
    {

        #region "Properties"

		public int? EtfCalculationID { get; set; }

        private CompanyAccount companyAccount = null;
        public CompanyAccount CompanyAccount
        {
            get
            {
                return companyAccount;
            }
        }

		public decimal? CalculatedEtfAmount
		{
			get;
			set;
		}

		private decimal? etfFinalAmount;
		public decimal? EtfFinalAmount
		{
			get
			{
				if( !etfFinalAmount.HasValue )
					return CalculatedEtfAmount;

				return etfFinalAmount;
			}
			set
			{
				etfFinalAmount = value;
			}
		}


		public EtfCalculationType CalculationType { get; set; }


		public DateTime DateCalculated { get; set; }

		private EtfCalculatorType etfCalculatorType;
		public EtfCalculatorType EtfCalculatorType
		{
			get
			{
				return etfCalculatorType;
			}

		}

		public string ErrorMessage { get; set; }

		public bool HasError
		{
			get
			{
				if ( this.ErrorMessage == null || this.ErrorMessage == string.Empty )
				{
					return false;
				}
				else
				{
					return true;
				}
			}
		}

		private DateTime deenrollmentDate;
		public DateTime DeenrollmentDate
		{
			get
			{
				return deenrollmentDate;
			}
		}

        //#endregion

        //#region "Constructor"


        #endregion

		protected EtfCalculator( EtfCalculatorType etfCalculatorType, CompanyAccount companyAccount, DateTime deenrollmentDate, EtfCalculationType calculationType )
        {
			this.DateCalculated = DateTime.Now;
			this.etfCalculatorType = etfCalculatorType;
            this.companyAccount = companyAccount;
			this.deenrollmentDate = deenrollmentDate;
			this.ErrorMessage = String.Empty;
			this.CalculationType = calculationType;
        }

        
        public int GetContractDaysLeft(DateTime contractEndDate, DateTime deenrollmentDate)
        {
            int contractDaysLeft = (contractEndDate - deenrollmentDate).Days;
            return contractDaysLeft;
        }

        public int GetTotalContractDays(int term)
        {
            int totalContractDays = Convert.ToInt32(Math.Round(term * 365.0 / 12)) - 1;
            return totalContractDays;
        }

        public DateTime GetContractEndDate(DateTime contractEffectiveDate, int totalContractDays)
        {
            return contractEffectiveDate.AddDays(totalContractDays);
        }

        public abstract EtfCalculator Calculate();

    }
}
