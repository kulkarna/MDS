namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;
	using System.Runtime.Serialization;
	using PricingBal = LibertyPower.Business.CustomerAcquisition.DailyPricing;
	using ProductBal = LibertyPower.Business.CustomerAcquisition.ProductManagement;

	[Serializable]
	public class AccountContractRateList : List<AccountContractRate>
	{
	}
}
