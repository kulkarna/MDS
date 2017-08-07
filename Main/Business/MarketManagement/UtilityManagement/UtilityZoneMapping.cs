namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	/// <summary>
	/// Utility zone mapping class that contains zone mapping data
	/// </summary>
	[Serializable]
	public class UtilityZoneMapping
	{
		/// <summary>
		/// Zone mapping record identifier
		/// </summary>
		public int Identifier
		{
			get;
			set;
		}

		/// <summary>
		/// Market record identifier
		/// </summary>
		public int? MarketID
		{
			get;
			set;
		}

		/// <summary>
		/// Utility record identifier
		/// </summary>
		public int? UtilityID
		{
			get;
			set;
		}

		/// <summary>
		/// Zone record identifier
		/// </summary>
		public int? ZoneID
		{
			get;
			set;
		}

		/// <summary>
		/// Market code
		/// </summary>
		public string MarketCode
		{
			get;
			set;
		}

		/// <summary>
		/// Utility code
		/// </summary>
		public string UtilityCode
		{
			get;
			set;
		}

		/// <summary>
		/// Zone code
		/// </summary>
		public string ZoneCode
		{
			get;
			set;
		}

		/// <summary>
		/// Grid string
		/// </summary>
		public string Grid
		{
			get;
			set;
		}

		/// <summary>
		/// LBMP zone string
		/// </summary>
		public string LBMPZone
		{
			get;
			set;
		}

		/// <summary>
		/// Loss factor
		/// </summary>
		public decimal? LossFactor
		{
			get;
			set;
		}

		public string Profile
		{
			get;
			set;
		}

		/// <summary>
		/// Active indicator
		/// </summary>
		public bool IsActive
		{
			get;
			set;
		}

        public MappingRuleType MappingStyle
        {
            get;
            set;
        }

	}
}
