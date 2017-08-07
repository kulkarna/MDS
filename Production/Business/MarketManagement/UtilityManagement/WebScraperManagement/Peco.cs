namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Collections.Generic;
	using System.Text;

	public class Peco : WebAccount
	{
		public Peco()
			: base( "PECO" )
		{ 
		}

		public DateTime IcapStartDate
		{
			get;
			set;
		}

		public DateTime IcapEndDate
		{
			get;
			set;
		}

		public DateTime TcapBeginDate
		{
			get;
			set;
		}

		public DateTime TcapEndDate
		{
			get;
			set;
		}

		/// <summary>
		/// Customer's rate code
		/// </summary>
		public string RateCode
		{
			get;
			set;
		}
	}
}
