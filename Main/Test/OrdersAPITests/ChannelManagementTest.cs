using System;
using System.Text;
using System.Collections.Generic;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace OrdersAPITests
{
    /// <summary>
    /// Summary description for ChannelManagementTest
    /// </summary>
    [TestClass]
    public class ChannelManagementTest
    {

        [TestMethod]
        public void GetTabletCacheDetailsTest()
        {
            ChannelManagementAPI.ChannelManagementServiceClient client = new ChannelManagementAPI.ChannelManagementServiceClient();


            // find out details of a user that has no relationship to any channel:
            ChannelManagementAPI.TabletDataCache response = client.GetTabletCacheDetails( 883, "Pricing" );
            Assert.IsNull( response );
            // Now get a user that's supposed to belong to a channel:
            response = client.GetTabletCacheDetails( 1987, "Pricing" );
            Assert.IsNotNull( response );



        }

        [TestMethod]
        public void GetSalesChannelDetailsByDeviceIDTest()
        {
            ChannelManagementAPI.ChannelManagementServiceClient client = new ChannelManagementAPI.ChannelManagementServiceClient();
            // find out details of a user that has no relationship to any channel:
            var response = client.GetSalesChannelDetailsByDeviceID( "invaliddeviceid" );
            Assert.IsNull( response );
            response = client.GetSalesChannelDetailsByDeviceID( "VALIDTABLETID" );
            Assert.IsNotNull( response );
        }



    }
}
