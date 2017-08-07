namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	/// <summary>
	/// Wholesale market object
	/// </summary>
	public class WholesaleMarket
	{
		public WholesaleMarket() { }

		public WholesaleMarket( int identity, string wholesaleMarketID, string description, DateTime dateCreated,
			string username, string inactiveInd, DateTime activeDate, int changeStamp ) 
		{
			this.Identity = identity;
			this.WholesaleMarketID = wholesaleMarketID;
			this.Description = description;
			this.DateCreated = dateCreated;
			this.Username = username;
			this.InactiveInd = inactiveInd;
			this.ActiveDate = activeDate;
			this.ChangeStamp = changeStamp;
		}

		public int Identity
		{
			get;
			set;
		}

		public string WholesaleMarketID
		{
			get;
			set;
		}

		public string Description
		{
			get;
			set;
		}

		public DateTime DateCreated
		{
			get;
			set;
		}

		public string Username
		{
			get;
			set;
		}

		public string InactiveInd
		{
			get;
			set;
		}

		public DateTime ActiveDate
		{
			get;
			set;
		}

		public int ChangeStamp
		{
			get;
			set;
		}
	}
}
