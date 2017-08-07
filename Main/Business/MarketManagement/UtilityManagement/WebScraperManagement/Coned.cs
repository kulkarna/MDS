namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using LibertyPower.Business.CommonBusiness.CommonEntity;

	public class Coned : WebAccount
	{
/*
		private string seasonalTurnOff;
		private DateTime nextScheduledReadDate;
		private string tensionCode;
		private Int16 residential;
		private string previousAccountNumber;
		private string taxable;
		private string profile;
*/
		/// <summary>
		/// Public constructor.
		/// </summary>
		/// <param name="accountNumber"></param>
		/// <param name="utilityCode"></param>
		/// <param name="serviceAddress"></param>
		public Coned( string accountNumber, string utilityCode, GeographicalAddress serviceAddress )
		{
			base.AccountNumber = accountNumber;
			base.UtilityCode = "CONED";
			base.Address = serviceAddress;
		}

		/// <summary>
		/// Public constructor.
		/// </summary>
		public Coned()
		{
		}

		/// <summary>
		/// Public constructor.
		/// </summary>
		public Coned( string accountNumber )
		{
			base.AccountNumber = accountNumber;
			base.UtilityCode = "CONED";
			this.BillGroup = "-1";
			this.Icap = -1;
		}

		public string SeasonalTurnOff
		{
			get;
			set;
		}

		/// <summary>
		/// When CONED has scheduled the next meter read date
		/// </summary>
		public DateTime NextScheduledReadDate
		{
			get;
			set;
		}

		public string TensionCode
		{
			get;
			set;
		}

		/// <summary>
		/// Percentage value that indicates whether residential customer or not
		/// </summary>
		public Int16 Residential
		{
			get;
			set;
		}

		/// <summary>
		/// Previous (legacy) account number
		/// </summary>
		public string PreviousAccountNumber
		{
			get;
			set;
		}

		/// <summary>
		/// Is the account fully taxable or not
		/// </summary>
		public string Taxable
		{
			get;
			set;
		}

		/// <summary>
		/// Single character that indicates whether an account is IDR or not
		/// </summary>
		public string Profile
		{
            get { return LoadProfile; }
            set { LoadProfile = value; }
		}

		/// <summary>
		/// Account data exists business rule
		/// </summary>
        //public ConedAccountDataExistsRule AccountDataExistsRule
        //{
        //    get;
        //    set;
        //}

		/// <summary>
		/// Whether an account is IDR or not
		/// </summary>
		public string MeterType
		{
			get;
			set;
		}

		public string PfjIcap
		{
			get;
			set;
		}

		public Int16 MinMonthlyDemand
		{
			get;
			set;
		}

		public string TodCode
		{
			get;
			set;
		}

		public string Muni
		{
			get;
			set;
		}

	    public string TripNumber
	    {
            get { return BillGroup; }
	    }

	    public string ServiceClass
	    {
            get { return RateClass; }
	    }

	    public string LbmpZone
	    {
            get { return ZoneCode; }   
		}

	}
}
