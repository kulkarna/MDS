using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Diagnostics;
namespace CRMWCFTester
{
    [TestClass]
    public class CRMTestingAPITests
    {
        [TestMethod]
        public void TestCRMTestingAPI()
        {
            CRMTestingClient testAPI = new CRMTestingClient();
            ContractSubmissionClient submissionClient = new ContractSubmissionClient();

            LibertyPower.Business.CustomerManagement.CRMBusinessObjects.Account account = testAPI.GenerateRandomAccount();
            LibertyPower.Business.CustomerManagement.CRMBusinessObjects.Contract newContract = testAPI.GenerateRandomBasicContract();
            LibertyPower.Business.CustomerManagement.CRMBusinessObjects.Customer newCustomer = testAPI.GetTestCustomer();
            LibertyPower.Business.CommonBusiness.SecurityManager.User user = testAPI.GetRandomUser();

            Assert.IsNotNull( account );
            Assert.IsNotNull( newContract );
            Assert.IsNotNull( newCustomer );
            Assert.IsNotNull( user );
            Assert.IsNotNull( newContract );

        }

    }
}
