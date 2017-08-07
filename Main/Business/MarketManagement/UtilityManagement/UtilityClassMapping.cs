namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	/// <summary>
	/// Utility mapping class
	/// </summary>
	[Serializable]
	public class UtilityClassMapping
	{
		/// <summary>
		/// Utility mapping record identifier
		/// </summary>
		public int Identifier
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
		/// Market record identifier
		/// </summary>
		public int? MarketID
		{
			get;
			set;
		}

		/// <summary>
		/// Rate class record identifier
		/// </summary>
		public int? RateClassID
		{
			get;
			set;
		}

		/// <summary>
		/// Service class record identifier
		/// </summary>
		public int? ServiceClassID
		{
			get;
			set;
		}

		/// <summary>
		/// Load profile record identifier
		/// </summary>
		public int? LoadProfileID
		{
			get;
			set;
		}

		/// <summary>
		/// Load shape record identifier
		/// </summary>
		public int? LoadShapeID
		{
			get;
			set;
		}

		/// <summary>
		/// Tariff code record identifier
		/// </summary>
		public int? TariffCodeID
		{
			get;
			set;
		}

		/// <summary>
		/// Voltage record identifier
		/// </summary>
		public int? VoltageID
		{
			get;
			set;
		}

		/// <summary>
		/// Meter type record identifier
		/// </summary>
		public int? MeterTypeID
		{
			get;
			set;
		}

		/// <summary>
		/// Account type record identifier
		/// </summary>
		public int? AccountTypeID
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

		/// <summary>
		/// Utility code
		/// </summary>
		public string UtilityCode
		{
			get;
			set;
		}

		/// <summary>
		/// Utility full name
		/// </summary>
		public string UtilityFullName
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
		/// Rate class code
		/// </summary>
		public string RateClassCode
		{
			get;
			set;
		}

		/// <summary>
		/// Service class code
		/// </summary>
		public string ServiceClassCode
		{
			get;
			set;
		}

		/// <summary>
		/// Load profile code
		/// </summary>
		public string LoadProfileCode
		{
			get;
			set;
		}

		/// <summary>
		/// Load shape code
		/// </summary>
		public string LoadShapeCode
		{
			get;
			set;
		}

		/// <summary>
		/// Tariff code
		/// </summary>
		public string TariffCode
		{
			get;
			set;
		}

		/// <summary>
		/// Voltage code
		/// </summary>
		public string VoltageCode
		{
			get;
			set;
		}

		/// <summary>
		/// Meter type code
		/// </summary>
		public string MeterTypeCode
		{
			get;
			set;
		}

		/// <summary>
		/// Account type description
		/// </summary>
		public string AccountTypeDescription
		{
			get;
			set;
		}
		
		public string ZoneCode
		{
			get;
			set;
		}

		public int ZoneId
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

	    public decimal ? Icap { get; set; }
        public decimal ? Tcap { get; set; }
	}
}
