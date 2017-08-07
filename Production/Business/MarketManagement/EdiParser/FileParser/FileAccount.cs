//using LibertyPower.Business.CommonBusiness.CommonEntity;
using LibertyPower.Business.MarketManagement.UtilityManagement;

namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	/// <summary>
	/// Class for file account data that is derived from WebAccount
	/// </summary>
	public class FileAccount : WebAccount
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public FileAccount() { }

		/// <summary>
		/// Tariff code
		/// </summary>
		public string TariffCode
		{
			get;
			set;
		}

		/// <summary>
		/// Grid
		/// </summary>
		public string Grid
		{
			get;
			set;
		}

		/// <summary>
		/// LBMP Zone
		/// </summary>
		public string LbmpZone
		{
			get;
			set;
		}

		/// <summary>
		/// Loss factor
		/// </summary>
		public string LossFactor
		{
			get;
			set;
		}

		/// <summary>
		/// Meter number
		/// </summary>
		public string MeterNumber
		{
			get;
			set;
		}

        /// <summary>
        /// Meter Type
        /// </summary>
        public string MeterType
        {
            get;
            set;
        }
	}
}
