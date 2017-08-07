using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using DocAPI = OrdersAPITests.DocumentServiceAPI;
namespace OrdersAPITests
{
    [TestClass]
    public class DocumentServiceTest
    {
        [TestMethod]
        public void TestAPKProcess()
        {
            DocAPI.DocumentServiceClient client = new DocAPI.DocumentServiceClient();

            var response = client.GetTabletDocumentByDocumentId( 1, "123123" );

            Assert.IsFalse( response == null );
        }

        [TestMethod]
        public void Test()
        {
            DocAPI.DocumentServiceClient client = new DocAPI.DocumentServiceClient();

            var response = client.GetTabletDocumentByDocumentId( 1, "123123" );

            Assert.IsFalse( response == null );
        }


    }
}
