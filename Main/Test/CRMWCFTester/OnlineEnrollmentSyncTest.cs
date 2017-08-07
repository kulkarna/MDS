using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using oeSync = LibertyPower.Business.CustomerManagement.OnlineEnrollmentSynchronization;
using oeDomain = LibertyPower.Business.CustomerAcquisition.OnlineEnrollment;

namespace CRMWCFTester
{
    [TestClass]
    public class OnlineEnrollmentSyncTest
    {
        [TestMethod]
        public void PriceUpdateTest()
        {
            oeSync.DataSynchronization dataSync = new oeSync.DataSynchronization();
            dataSync.ProcessPriceUpdate();
        }

        [TestMethod]
        public void EmailTest()
        {
            oeDomain.Domain.EmailClient.Test();
        }

        [TestMethod]
        public void ContractSubmissionTest()
        {
            oeSync.DataSynchronization dataSync = new oeSync.DataSynchronization();
            dataSync.ProcessContractsQueue();
        }

        [TestMethod]
        public void EmailListsTest()
        {
            oeSync.Helper.SendEmail(oeDomain.Domain.Enums.EmailType.Error, "Test error message");

            oeSync.Helper.SendEmail(oeDomain.Domain.Enums.EmailType.Price, "Test price email"); 
        }
    }
}
