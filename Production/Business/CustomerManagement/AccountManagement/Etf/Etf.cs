using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public class Etf
	{

		public int? EtfID { get; set; }

		private EtfState etfState = EtfState.EtfStart;
		public EtfState EtfState
		{
			get
			{
				return etfState;
			}
			set
			{
				etfState = value;
			}
		}

		public decimal? DisplayEtfAmount
		{
			get
			{
				if ( EtfCalculator != null )
				{
					if ( EtfEndStatus == EtfEndStatus.IneligibleProduct || EtfEndStatus == EtfEndStatus.EtfWaived )
					{
						return 0;
					}
					else
					{
						if ( EtfCalculator.CalculatedEtfAmount.Value < 0 )
						{
							return 0;
						}
						else
						{
							return EtfCalculator.CalculatedEtfAmount;
						}
					}
				}
				else
				{
					return null;
				}
			}
		}

		public decimal? DisplayEtfFinalAmount
		{
			get
			{
				if( EtfCalculator != null )
				{
					if( EtfEndStatus == EtfEndStatus.IneligibleProduct || EtfEndStatus == EtfEndStatus.EtfWaived )
					{
						return 0;
					}
					else
					{
						if( EtfCalculator.EtfFinalAmount.Value < 0 )
						{
							return 0;
						}
						else
						{
							return EtfCalculator.EtfFinalAmount;
						}
					}
				}
				else
				{
					return null;
				}
			}
		}

		private EtfEndStatus etfEndStatus = EtfEndStatus.Undefined;
		public EtfEndStatus EtfEndStatus
		{
			get
			{
				return etfEndStatus;
			}
			set
			{
				etfEndStatus = value;
			}
		}

		/// <summary>
		/// Indicates if the Calculation Type is estimated or actual
		/// </summary>
		public EtfCalculationType EtfCalculationType { get; set; }

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

        // This property was reinstated for backwards compatibility.
        // It is not part of the permanent solution.
        public bool IsPaid //{ get; set; }
        {
            get
            {
                return false;
            }
            set
            {
                IsPaid = value;
            }
        }

		private EtfCalculator etfCalculator;
		public EtfCalculator EtfCalculator
		{
			get
			{
				return etfCalculator;
			}
			set
			{
				etfCalculator = value;
			}
		}

		public EtfInvoice EtfInvoice
		{
			get;
			set;
		}

		public string LastUpdatedBy
		{
			get;
			set;
		}

	}
}
