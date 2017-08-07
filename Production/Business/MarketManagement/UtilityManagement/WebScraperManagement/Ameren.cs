namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	public class Ameren : WebAccount
	{
		private decimal effectivePLC;

		public Ameren()
			: base( "AMEREN" )
		{
			effectivePLC = -1;
		}

		public string ServiceClass
		{
			get;
			set;
		}

		public string OperatingCompany
		{
			get;
			set;
		}

		public string ServicePoint
		{
			get;
			set;
		}

		public string DeliveryVoltage
		{
			get;
			set;
		}

		public string SupplyVoltage
		{
			get;
			set;
		}

		public string MeterVoltage
		{
			get;
			set;
		}

		public string CurrentSupplyGoupAndType
		{
			get;
			set;
		}

		public string FutureSupplyGroupAndType
		{
			get;
			set;
		}

		public DateTime EligibleSwitchDate
		{
			get;
			set;
		}

		public string TransformationCharge
		{
			get;
			set;
		}

		public decimal EffectivePLC
		{
			get { return effectivePLC; }
			set { effectivePLC = value; }
		}

		/// <summary>
		/// Meter Number
		/// </summary>
		public string Meter
		{
			get;
			set;
		}

	    public string ProfileClass
	    {
	       get { return LoadProfile; }
		}
	}
}
