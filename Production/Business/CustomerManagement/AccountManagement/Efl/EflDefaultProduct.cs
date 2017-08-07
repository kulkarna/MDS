using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public class EflDefaultProduct
	{
		public EflDefaultProduct() { }

		public EflDefaultProduct( string marketCode, int month, int year,
			decimal mcpe, decimal adder, string username, DateTime dateCreated )
		{
			this.MarketCode = marketCode;
			this.Month = month;
			this.Year = year;
			this.Mcpe = mcpe;
			this.Adder = adder;
			this.Username = username;
			this.DateCreated = dateCreated;
		}

		public EflDefaultProduct( int id, string marketCode, int month, int year,
			decimal mcpe, decimal adder, string username, DateTime dateCreated )
		{
			this.ID = id;
			this.MarketCode = marketCode;
			this.Month = month;
			this.Year = year;
			this.Mcpe = mcpe;
			this.Adder = adder;
			this.Username = username;
			this.DateCreated = dateCreated;
		}

		public int ID
		{
			get;
			set;
		}

		public string MarketCode
		{
			get;
			set;
		}

		public int Month
		{
			get;
			set;
		}

		public int Year
		{
			get;
			set;
		}

		public decimal Mcpe
		{
			get;
			set;
		}

		public decimal Adder
		{
			get;
			set;
		}

		public string Username
		{
			get;
			set;
		}

		public DateTime DateCreated
		{
			get;
			set;
		}
	}
}
