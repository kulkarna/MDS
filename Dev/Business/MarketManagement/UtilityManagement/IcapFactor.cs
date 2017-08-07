using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	/// <summary>
	/// Container for holding Icap factor data
	/// </summary>
	public class IcapFactor
	{
		private string utilityCode;
		private string loadShapeId;
		private DateTime icapDate;
		private decimal icapFactor;
		private Int32 id;

		/// <summary>
		/// Constructor
		/// </summary>
		public IcapFactor()
		{
		}

		/// <summary>
		/// Constructor
		/// </summary>
		/// <param name="utilityCode">Identifier for utility</param>
		/// <param name="loadShapeId">Load Shape ID</param>
		/// <param name="icapDate">Icap date</param>
		/// <param name="icapFactor">Icap factor</param>
		public IcapFactor( string utilityCode, string loadShapeId, 
			DateTime icapDate, decimal icapFactor ) 
		{
			this.utilityCode = utilityCode;
			this.loadShapeId = loadShapeId;
			this.icapDate = icapDate;
			this.icapFactor = icapFactor;
		}

		/// <summary>
		/// Identifier for utility
		/// </summary>
		public string UtilityCode
		{
			get{return utilityCode;}
			set { utilityCode = value; }
		}

		/// <summary>
		/// Load Shape ID
		/// </summary>
		public string LoadShapeId
		{
			get{return loadShapeId;}
			set { loadShapeId = value; }
		}

		/// <summary>
		/// ICAP Date
		/// </summary>
		public DateTime IcapDate
		{
			get{return icapDate;}
			set { icapDate = value; }
		}

		/// <summary>
		/// ICAP Factor
		/// </summary>
		public decimal Factor
		{
			get{return icapFactor;}
			set { icapFactor = value; }
		}

		public Int32 ID
		{
			get { return id; }
			set { id = value; }
		}
	}
}
