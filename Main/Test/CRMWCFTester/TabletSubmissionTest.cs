using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace CRMWCFTester
{
    [TestClass]
    public class TabletSubmissionTest
    {
        [TestMethod]
        public void ContractsSubmissionTest()
        {
            LibertyPower.Business.CustomerManagement.OnlineDataSynchronization.OnlineDataSynchronization genie = new LibertyPower.Business.CustomerManagement.OnlineDataSynchronization.OnlineDataSynchronization();
            genie.ProcessContractsQueue();
        }

        [TestMethod]
        public void PriceUpdateTest()
        {
            LibertyPower.Business.CustomerManagement.OnlineDataSynchronization.OnlineDataSynchronization genie = new LibertyPower.Business.CustomerManagement.OnlineDataSynchronization.OnlineDataSynchronization();
            genie.ProcessPriceUpdate();
        }

        [TestMethod]
        public void EmailSendTest()
        {
            LibertyPower.Business.CustomerManagement.OnlineDataSynchronization.EmailClient.Test();
           
        }

        [TestMethod]
        public void EnrollmentNotificationTest()
        {
            LibertyPower.Business.CustomerManagement.OnlineDataSynchronization.OnlineDataSynchronization genie = new LibertyPower.Business.CustomerManagement.OnlineDataSynchronization.OnlineDataSynchronization();
            genie.SendEnrollmentNotification();
        }

        [TestMethod]
        public void PromotionCodeandQualifierUpdateTest()
        {
            LibertyPower.Business.CustomerManagement.OnlineDataSynchronization.OnlineDataSynchronization genie = new LibertyPower.Business.CustomerManagement.OnlineDataSynchronization.OnlineDataSynchronization();
            genie.ProcessPromotionCodeandQualifierUpdate();
        }
    }
}
