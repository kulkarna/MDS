using System;

namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using LibertyPower.Business.CommonBusiness.CommonEntity;

	public class Bge : WebAccount
	{
		private decimal capPLC;
		private decimal transPLC;
		private int tariffCode;


		public Bge()
			: base( "BGE" )
		{
			capPLC = -1;
			transPLC = -1;
			tariffCode = -1;
		}

		public string AccountName
		{
			get { return CustomerName; }
		}

		public GeographicalAddress BillingAddress
		{
			get;
			set;
		}

		public string CustomerSegment
		{
			get;
			set;
		}

		public int TariffCode
		{
			get { return tariffCode; }
			set { tariffCode = value; }
		}

		public decimal CapPLC
		{
			get { return capPLC; }
			set { capPLC = value; }
		}

		public decimal TransPLC
		{
			get { return transPLC; }
			set { transPLC = value; }
		}

		public decimal CapPlcPrev { get; set; }

		public decimal TransPlcPre { get; set; }

		public DateTime CapPlcEffectiveDate
		{
			get;
			set;
		}

		public DateTime TransPlcEffectiveDate
		{
			get;
			set;
		}
		public DateTime CapPlcPrevEffectiveDate
		{
			get;
			set;
		}
		public DateTime TransPlcPrevEffectiveDate
		{
			get;
			set;
		}
		public string POLRType
		{
			get;
			set;
		}

		public string SpecialBilling
		{
			get;
			set;
		}

		public string MultipleMeters
		{
			get;
			set;
		}
	}
}
