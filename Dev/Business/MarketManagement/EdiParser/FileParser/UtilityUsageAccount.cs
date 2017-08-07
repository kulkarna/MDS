namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;
	using LibertyPower.Business.MarketManagement.UtilityManagement;

	/// <summary>
	/// Utility usage account object that inherits from utility account object
	/// </summary>
	public class UtilityUsageAccount : UtilityAccount
	{
		/// <summary>
		/// Utility usage list
		/// </summary>
		public UtilityUsageList UtilityUsageList
		{
			get;
			set;
		}

		/// <summary>
		/// DUNS number
		/// </summary>
		public string DunsNumber
		{
			get;
			set;
		}

		/// <summary>
		/// Previous account number
		/// </summary>
		public string PreviousAccountNumber
		{
			get;
			set;
		}

		/// <summary>
		/// Identifies the party that is to calculate the charges on the bill (LDC/ESP/Dual).
		/// </summary>
		public string BillCalculation
		{
			get;
			set;
		}

		/// <summary>
		/// Identifies whether the bill is consolidated by the Utility (LDC), by LP (ESP), or whether each party will render their own bill (DUAL).
		/// </summary>
		public string BillingType
		{
			get;
			set;
		}

		/// <summary>
		/// Meter constant or meter multiplier. Billed Usage = (Ending Meter Reading - Beginning Meter Reading) * Meter Multiplier
		/// </summary>
		public Int16 MeterMultiplier
		{
			get;
			set;
		}

		/// <summary>
		/// Meter type used to identify the type of consumption measured by this meter and the interval between measurements
		/// </summary>
		public string MeterType
		{
			get;
			set;
		}

		/// <summary>
		/// Number of months over which Total kWh are calculated.
		/// </summary>
		public Int16 MonthsToComputeKwh
		{
			get;
			set;
		}

		/// <summary>
		/// Beginning Segment: 06-Confirmation; 11-Response; 13-Request; etc.
		/// </summary>
		public string TransactionType
		{
			get;
			set;
		}

		/// <summary>
		/// Electric Service (EL), Gas Service (GAS), Water Service (WA), etc.
		/// </summary>
		public string ServiceType
		{
			get;
			set;
		}

		/// <summary>
		/// Customer Enrollment (CE), Historical Usage (HU), Historical Interval (HI), etc.
		/// </summary>
		public string ProductType
		{
			get;
			set;
		}

		/// <summary>
		/// Product (Alternate) Type
		/// </summary>
		public string ProductAltType
		{
			get;
			set;
		}

		/// <summary>
		/// Enrollment Status
		/// </summary>
		public string EnrollmentStatus
		{
			get;
			set;
		}

		/// <summary>
		/// Contract Start Date
		/// </summary>
		public DateTime ContractStartDate
		{
			get;
			set;
		}

		/// <summary>
		/// Contract End Date
		/// </summary>
		public DateTime ContractEndDate
		{
			get;
			set;
		}

		/// <summary>
		/// Annual Usage
		/// </summary>
		public int AnnualUsage
		{
			get;
			set;
		}

		/// <summary>
		/// Esp account number
		/// </summary>
		public string EspAccount
		{
			get;
			set;
		}

		/// <summary>
		/// Contact name information
		/// </summary>
		public string ContactName
		{
			get;
			set;
		}

		/// <summary>
		/// Contact email address information
		/// </summary>
		public string EmailAddress
		{
			get;
			set;
		}

		/// <summary>
		/// Contact telephone information
		/// </summary>
		public string Telephone
		{
			get;
			set;
		}

		/// <summary>
		/// Contact home phone information
		/// </summary>
		public string HomePhone
		{
			get;
			set;
		}

		/// <summary>
		/// Contact work phone information
		/// </summary>
		public string WorkPhone
		{
			get;
			set;
		}

		/// <summary>
		/// Contact fax information
		/// </summary>
		public string Fax
		{
			get;
			set;
		}

		/// <summary>
		/// IDR usage list
		/// </summary>
		public UtilityIdrUsageList IdrUsageList
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
		/// Service delivery point, also called location number (MISO)
		/// </summary>
		public string ServiceDeliveryPoint
		{
			get;
			set;
		}
	}
}
