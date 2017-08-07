using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.MarketManagement.AccountInfo
{
	/// <summary>
	/// AccountInfoProperties object that reflect the account info 
	/// </summary>
	public class AccountInfoProperties
	{
		/// <summary>
		/// file log ID
		/// </summary>
		public int FileLogID;

		/// <summary>
		/// ESIID which matches our account numbers
		/// </summary>
		public string ESIID;

		/// <summary>
		/// address line
		/// </summary>
		public string Address;

		/// <summary>
		/// address 2 line
		/// </summary>
		public string AddressOverflow;

		/// <summary>
		/// city
		/// </summary>
		public string City;

		/// <summary>
		/// state
		/// </summary>
		public string State;

		/// <summary>
		/// zip code
		/// </summary>
		public string ZipCode;

		/// <summary>
		/// +4 zipcode
		/// </summary>
		public string ZipCode4;

		/// <summary>
		/// duns numbers
		/// </summary>
		public string DUNS;

		/// <summary>
		/// meter read
		/// </summary>
		public string MeterReadCycle;

		/// <summary>
		/// status: Active - De-Energized
		/// </summary>
		public string Status;

		/// <summary>
		/// premise type: Residential - Small Non-Residential
		/// </summary>
		public string PremiseType;

		/// <summary>
		/// power region: ERCOT
		/// </summary>
		public string PowerRegion;

		/// <summary>
		/// station code: BZ - AF ...
		/// </summary>
		public string StationCode;

		/// <summary>
		/// station name: BRAZOSPORT - ALIEF  ...
		/// </summary>
		public string StationName;

		/// <summary>
		/// metered: Y - N
		/// </summary>
		public string Metered;

		/// <summary>
		/// open service orders
		/// </summary>
		public string OpenServiceOrders;

		/// <summary>
		/// customer class
		/// </summary>
		public string PolrCustomerClass;

		/// <summary>
		/// AMS meter flag: Y - N
		/// </summary>
		public string AMSMeterFlag;

		/// <summary>
		/// AMSM = TDSP provisioned AMS meter without remote connect and disconnect capability
		/// AMSR = TDSP provisioned AMS meter with remote connect and disconnect capability.
		///NULL = either a Non AMS meter, a non-provisioned AMS meter or unmetered
		/// </summary>
		public string TdpAMS;

		/// <summary>
		/// Y-N
		/// </summary>
		public string SwitchHoldFlag;

		/// <summary>
		/// Zone: LZ_NORTH - LZ_HOUSTON ...
		/// </summary>
		public string SettlementLoadZone;

	}
}

