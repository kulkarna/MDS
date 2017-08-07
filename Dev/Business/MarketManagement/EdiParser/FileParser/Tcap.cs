namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;

	public class Tcap
	{
		public Tcap() { }

		public Tcap( decimal value )
		{
			Value = value;
			BeginDate = DateTime.Today;
			EndDate = DateTime.Today;
		}

		public Tcap( decimal value, DateTime? beginDate, DateTime? endDate )
		{
			Value = value;
			BeginDate = beginDate;
			EndDate = endDate;
		}

		public decimal Value
		{
			get;
			set;
		}

		public DateTime? BeginDate
		{
			get;
			set;
		}

		public DateTime? EndDate
		{
			get;
			set;
		}
	}
}
