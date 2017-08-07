using System;
using System.Data;
using System.Collections.Generic;
using System.Text;
using LibertyPower.DataAccess.SqlAccess.CommonSql;


namespace LibertyPower.Business.MarketManagement.EdiManagement
{
	public class Ista814Header
	{
		public int Key814
		{
			get;
			set;
		}

		public string UtilityDuns
		{
			get;
			set;
		}

		public string UtilityCode
		{
			get;
			set;
		}

		public string LibertyPowerEntityDuns
		{
			get;
			set;
		}

		public string TransactionNbr
		{
			get;
			set;
		}

		public string ReferenceNbr
		{
			get;
			set;
		}

		public string TransactionSetId
		{
			get;
			set;
		}

		public string TransactionSetPurposeCode
		{
			get;
			set;
		}

		public int Direction
		{
			get;
			set;
		}

		public string TransactionType
		{
			get;
			set;
		}

		public string TransactionDate
		{
			get;
			set;
		}

		public Ista814ServiceList Ista814ServiceList
		{
			get;
			set;
		}

		public List<Ista814Name> Ista814NameList
		{
			get;
			set;
		}

		public ResponseType ResponseType
		{
			get;
			set;
		}

		public List<Ista814Name> AddIsta814Name()
		{
			throw new System.NotImplementedException();
		}

		public string LibertyPowerReasonCode { get; set; }

		public void AddIsta814Service( Ista814Service service )
		{
			if( Ista814ServiceList == null )
				Ista814ServiceList = new Ista814ServiceList();
			Ista814ServiceList.Add( service );
		}
	}
}
