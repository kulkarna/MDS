using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace CRMWCFTester
{
    [TestClass]
    public class CommonServicesTests
    {
        [TestMethod]
        public void TestGetActiveUtilities()
        {
            CommonServicesClient commonClient = new CommonServicesClient();

            CRMWebServices.WSUtility[] activeUtilities = commonClient.GetActiveUtilities();

            Assert.IsNotNull( activeUtilities );

            Assert.IsTrue( activeUtilities.Count() > 10 );

            CRMWebServices.WSUtilityResult utilResult = commonClient.GetUtilitiesByUserGuidAndZipcode( "3387FDE8-0D9F-4DF4-88FC-1A3B2DAF3496", "10103" );

            Assert.IsFalse( utilResult.HasErrors );
            Assert.IsNotNull( utilResult );
            Assert.IsNotNull( utilResult.Utilities );
            Assert.IsTrue( utilResult.Utilities.Count() > 1 );

            foreach( var util in utilResult.Utilities )
            {
                CRMWebServices.WSUtilityResult utilResult2 = null;
                utilResult2 = commonClient.GetUtilityById( util.Identity );
                Assert.IsFalse( utilResult2.HasErrors );
                Assert.IsNotNull( utilResult2 );
                Assert.IsNotNull( utilResult2.Utilities );
                Assert.IsTrue( utilResult2.Utilities.Count() == 1 );

            }

            CRMWebServices.WSUtility[] utilitiesPerMarketAndSalesChannel = commonClient.GetUtilitiesByMarketAndSalesChannel( "NY", "libertypower\\IRE" );

            Assert.IsNotNull( utilitiesPerMarketAndSalesChannel );
            Assert.IsTrue( utilitiesPerMarketAndSalesChannel.Count() > 0 );

            foreach( var util2 in activeUtilities )
            {
                CRMWebServices.WSUtility util3 = commonClient.GetUtilityByUtilityCode( util2.Code );
                Assert.IsNotNull( util3 );
            }

        }

        [TestMethod]
        public void TestUtilityNegative()
        {
            //This doesnt work because the utility API is a POS, but in theory the utility API should just not find a match and return gracefully
            CommonServicesClient commonClient = new CommonServicesClient();
            CRMWebServices.WSUtilityResult utilRes = commonClient.GetUtilityById( 2314 );
            Assert.IsNotNull( utilRes );
            Assert.IsFalse( utilRes.HasErrors );
            Assert.IsNull( utilRes.Utilities );
            Assert.IsTrue( utilRes.Utilities.Length == 0 );
            Assert.IsNull( utilRes.Utilities[0] );
        }

        [TestMethod]
        public void TestMiscCommonServices()
        {
            CommonServicesClient commonClient = new CommonServicesClient();
            CRMWebServices.WSAccountType[] accTypes = commonClient.GetAccountTypes();

            Assert.IsNotNull( accTypes );
            Assert.IsTrue( accTypes.Length > 1 );

            LibertyPower.Business.CustomerManagement.CRMBusinessObjects.BusinessActivity[] bussAct = commonClient.GetBusinessActivities();
            Assert.IsNotNull( bussAct );
            Assert.IsTrue( bussAct.Length > 1 );

            LibertyPower.Business.CustomerManagement.CRMBusinessObjects.BusinessType[] bussTypes = commonClient.GetBusinessTypes();
            Assert.IsNotNull( bussTypes );
            Assert.IsTrue( bussTypes.Length > 1 );

            string number = commonClient.GetNewContractNumber();

            Assert.IsFalse( string.IsNullOrEmpty( number ) );

            CRMWebServices.WSDocumentType[] docTypes = commonClient.GetDocumentTypes();

            Assert.IsNotNull( docTypes );
            Assert.IsTrue( docTypes.Length > 1 );

            int uid = commonClient.GetUserIdByUsername( "libertypower\\jforero" );
            Assert.IsTrue( uid > 0 );

            CRMWebServices.WSResult res = commonClient.IsAccountNumberInSystem( "0254372014", 34 );
            Assert.IsTrue( !res.HasErrors );


            res = commonClient.IsAccountNumberInSystem( "999877656", 15 );
            Assert.IsTrue( res.HasErrors );


            res = commonClient.IsAccountNumberValid( "0254372014", 34 );
            Assert.IsTrue( !res.HasErrors );


            res = commonClient.IsAccountNumberValid( "GFADRE999877656", 15 );
            Assert.IsTrue( res.HasErrors );


        }

        [TestMethod]
        public void TestCommonMarketFunctions()
        {
            CommonServicesClient commonClient = new CommonServicesClient();
            CRMWebServices.WSRetailMarket[] markets = null;
            markets = commonClient.GetMarketsBySalesChannelCode( "IRE" );

            Assert.IsNotNull( markets );
            Assert.IsTrue( markets.Length > 1 );




        }

    }
}
