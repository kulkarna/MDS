using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using Microsoft.VisualStudio.TestTools.UnitTesting.Web;

using OrdersAPITests.CRMService;

namespace OrdersAPITests
{
    
    
    /// <summary>
    ///This is a test class for CRMServiceTest and is intended
    ///to contain all CRMServiceTest Unit Tests
    ///</summary>
    [TestClass()]
    public class CRMServiceTest
    {


        private TestContext testContextInstance;

        /// <summary>
        ///Gets or sets the test context which provides
        ///information about and functionality for the current test run.
        ///</summary>
        public TestContext TestContext
        {
            get
            {
                return testContextInstance;
            }
            set
            {
                testContextInstance = value;
            }
        }

        /// <summary>
        ///   Happy path unit test for AddAccountContractRate
        ///</summary>
        [TestMethod]
        public void AddAccountContractRateTest()
        {
            CRMService.CRMServiceClient client = new CRMService.CRMServiceClient();
            int accountID = 242807;
            int contractID = 104168;
            int term = 1; 
            DateTime rateStartDate = DateTime.Now; 
            DateTime rateEndDate = DateTime.Now.AddDays(30); 
            double rate = .09123F;
            string legacyProductID = "CL&P-VAR-12"; 
            int creatingUserID = 1029; 

            WSResult expected = new WSResult();
            WSResult actual;
            actual = client.AddAccountContractVariableRate(accountID, contractID, term, rateStartDate, rateEndDate, rate, legacyProductID, creatingUserID);
            
            Assert.AreEqual(expected.HasErrors, actual.HasErrors);
        }

        /// <summary>
        ///   Test for a begin date after the end date.  Should return an error
        ///</summary>
        [TestMethod]
        public void AddACRStartDateAfterEndErrorTestTest()
        {
            CRMService.CRMServiceClient client = new CRMService.CRMServiceClient();
            int accountID = 242807;
            int contractID = 104168;
            int term = 1;
            DateTime rateStartDate = DateTime.Now.AddDays(30);
            DateTime rateEndDate = DateTime.Now;
            double rate = .09123F;
            string legacyProductID = "CL&P-VAR-12";
            int creatingUserID = 1029;

            WSResult actual;

            actual = client.AddAccountContractVariableRate(accountID, contractID, term, rateStartDate, rateEndDate, rate, legacyProductID, creatingUserID);

            Assert.IsTrue(actual.HasErrors);
        }
    }
}
