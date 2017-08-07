using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	/// <summary>
	/// Container for icap factor exemption (calculation not required)
	/// </summary>
	public class CapsMarketExemption
	{
		private string retailMarketId;
		private bool icapExempt;
		private bool tcapExempt;
		private bool zeroIcap;
		private bool zeroTcap;

		/// <summary>
		/// Constructor taking utility code and retail market id
		/// </summary>
		/// <param name="retailMarketId">Identifier for retail market</param>
		/// <param name="icapExempt">Boolean indicating if ICAP is exempt from calculations</param>
		/// <param name="tcapExempt">Boolean indicating if TCAP is exempt from calculations</param>
		/// <param name="zeroIcap">Boolean indicating if ICAP should be zero</param>
		/// <param name="zeroTcap">Boolean indicating if TCAP should be zero</param>
		public CapsMarketExemption( string retailMarketId, bool icapExempt, 
			bool tcapExempt, bool zeroIcap, bool zeroTcap )
		{
			this.retailMarketId = retailMarketId;
			this.icapExempt = icapExempt;
			this.tcapExempt = tcapExempt;
			this.zeroIcap = zeroIcap;
			this.zeroTcap = zeroTcap;
		}

		/// <summary>
		/// Identifier for retail market
		/// </summary>
		public string RetailMarketId
		{
			get{return retailMarketId;}
			set{retailMarketId = value;}
		}

		/// <summary>
		/// Is Icap Exempt
		/// </summary>
		public bool IcapExempt
		{
			get { return icapExempt; }
			set { icapExempt = value; }
		}

		/// <summary>
		/// Is Tcap Exempt
		/// </summary>
		public bool TcapExempt
		{
			get { return tcapExempt; }
			set { tcapExempt = value; }
		}

		/// <summary>
		/// Icap should be zero
		/// </summary>
		public bool ZeroIcap
		{
			get { return zeroIcap; }
			set { zeroIcap = value; }
		}

		/// <summary>
		/// Tcap should be zero
		/// </summary>
		public bool ZeroTcap
		{
			get { return zeroTcap; }
			set { zeroTcap = value; }
		}
	}
}
