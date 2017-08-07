namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;

	public class Nimo : WebAccount
	{
		public Nimo()
		{
			UtilityCode = "NIMO";
		}

		/// <summary>
		/// Tax district
		/// </summary>
		public string TaxDistrict
		{
			get;
			set;
		}

		/// <summary>
		/// Rate code
		/// </summary>
		public string RateCode
		{
			get;
			set;
		}

	}
}
