using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace CRMWCFTester
{
	[TestClass]
	public class TabletDataCacheUpdateProcessTest
	{


		[TestMethod]
		public void StartUpdateprocesQuartztest()
		{
			LibertyPower.Business.CustomerManagement.TabletDataCacheUpdateProcess.TabletDataCacheUpdateProcessQuartz Startprocess = new LibertyPower.Business.CustomerManagement.TabletDataCacheUpdateProcess.TabletDataCacheUpdateProcessQuartz();
			Startprocess.StartUpdateProcess();
			System.Threading.Thread.Sleep( 60000 * 6 );
		}

		[TestMethod]
		public void ProcessUpdateTest()
		{
			LibertyPower.Business.CustomerManagement.TabletDataCacheUpdateProcess.TabletDataCacheUpdate process = new LibertyPower.Business.CustomerManagement.TabletDataCacheUpdateProcess.TabletDataCacheUpdate();
			bool result = false;

			int TabletCacheItemId;
			bool IsItAdHoc;
			int? salesChannelId;

			////Pricing All salesChannel
			//TabletCacheItemId = 1;
			//IsItAdHoc = false;
			//salesChannelId = null;

			////MarketProducts All salesChannel
			//TabletCacheItemId = 3;
			//IsItAdHoc = false;
			//salesChannelId = null;


			////Pricing - One salesChannel
			//TabletCacheItemId = 1;
			//IsItAdHoc = true;
			//salesChannelId = 1218;

			//MarketProducts - One salesChannel
			TabletCacheItemId = 3;
			IsItAdHoc = true;
			salesChannelId = 1218;

			LibertyPower.Business.CustomerManagement.TabletDataCacheUpdateProcess.TabletDataCache TabletDataCache = new LibertyPower.Business.CustomerManagement.TabletDataCacheUpdateProcess.TabletDataCache();
			TabletDataCache.TabletCacheItemId = TabletCacheItemId;
			TabletDataCache.SalesChannelId = salesChannelId;
			TabletDataCache.IsItAdhoc = IsItAdHoc;
			TabletDataCache.UserID = 1982;


			result = process.ProcessUpdate( TabletDataCache );
		}


	}
}
