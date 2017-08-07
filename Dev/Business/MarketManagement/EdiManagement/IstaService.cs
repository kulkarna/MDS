using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.MarketManagement.EdiManagement
{
	public class Ista814Service
	{
		public string AccountNumber
		{
			get;
			set;
		}

		public string ServiceType2
		{
			get;
			set;
		}

		public string TransactionStatus
		{
			get;
			set;
		}

		public System.DateTime SpecialReadSwitchDate
		{
			get;
			set;
		}

		public System.DateTime FlowStartDate
		{
			get;
			set;
		}

		public DateTime DeEnrollmentDate
		{
			get;
			set;
		}

		public string PreviousAccountNumber
		{
			get;
			set;
		}

		public string CapacityObligation
		{
			get;
			set;
		}

		public string TransmissionObligation
		{
			get;
			set;
		}

		public string LBMPZone
		{
			get;
			set;
		}

		public string PowerRegion
		{
			get;
			set;
		}

		public string StationId
		{
			get;
			set;
		}

		public string DistributionLossFactorCode
		{
			get;
			set;
		}

		public string LDCBillingCycle
		{
			get;
			set;
		}

		public string ESPCommodityPrice
		{
			get;
			set;
		}

		public string PremiseType
		{
			get;
			set;
		}

		public string BillType
		{
			get;
			set;
		}

		public string BillCalculator
		{
			get;
			set;
		}

		public string NotificationWaiver
		{
			get;
			set;
		}

		public int Key814
		{
			get;
			set;
		}

		public int ServiceKey
		{
			get;
			set;
		}

		public List<Ista814ServiceMeter> ServiceMeterList
		{
			get;
			set;
		}

		public List<Ista814ServiceReject> ServiceRejectList
		{
			get;
			set;
		}

		public List<Ista814ServiceAccountChange> ServiceAccountChangeList
		{
			get;
			set;
		}

		public void AddIsta814ServiceMeter()
		{
			throw new System.NotImplementedException();
		}

		public void AddIsta814ServiceReject()
		{
			throw new System.NotImplementedException();
		}

		public void AddIsta814ServiceAccountChange()
		{
			throw new System.NotImplementedException();
		}
	}
}
