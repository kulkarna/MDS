using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRMWCFTester
{
    [TestClass]
    public class TabletDocumentTest
    {
        [TestMethod]
        public void TabletDocumentInsertTest()
        {
            LibertyPower.Business.CustomerManagement.CRMBusinessObjects.TabletDocument tabletDocument = new LibertyPower.Business.CustomerManagement.CRMBusinessObjects.TabletDocument();
            tabletDocument.ContractNumber = "TEST_1234";
            tabletDocument.FileName = "TEST_1234_new.pdf";
            tabletDocument.DocumentTypeID = 3;
            tabletDocument.SalesAgentID = 161;

            List<LibertyPower.Business.CustomerManagement.CRMBusinessObjects.GenericError> errors = null;

            bool result = LibertyPower.Business.CustomerManagement.CRMBusinessObjects.TabletDocumentFactory.InsertTabletDocument(tabletDocument, out errors);

            Assert.IsFalse(errors.Count>0);
            Assert.IsTrue(result);
        }

        [TestMethod]
        public void TabletDocumentInsertFailTest()
        {
            LibertyPower.Business.CustomerManagement.CRMBusinessObjects.TabletDocument tabletDocument = new LibertyPower.Business.CustomerManagement.CRMBusinessObjects.TabletDocument();
            tabletDocument.ContractNumber = "TEST_123";
            //tabletDocument.FileName = "TEST_123_new.pdf";
            tabletDocument.DocumentTypeID = 7;
            tabletDocument.SalesAgentID = 161;

            List<LibertyPower.Business.CustomerManagement.CRMBusinessObjects.GenericError> errors = null;

            bool result = LibertyPower.Business.CustomerManagement.CRMBusinessObjects.TabletDocumentFactory.InsertTabletDocument(tabletDocument, out errors);

            foreach(LibertyPower.Business.CustomerManagement.CRMBusinessObjects.GenericError error in errors)
            {
                Debug.WriteLine("Error: " + error.Message);
            }

            Debug.WriteLine("==============================================");

            Assert.IsFalse(errors.Count > 0);
            Assert.IsTrue(result);
        }

        [TestMethod]
        public void TabletDocumentSelectTest()
        {
            string contractNumber = "TEST_123";

            List<LibertyPower.Business.CustomerManagement.CRMBusinessObjects.TabletDocument> tabletDocuments;
            tabletDocuments = LibertyPower.Business.CustomerManagement.CRMBusinessObjects.TabletDocumentFactory.GetTabletDocuments(contractNumber);

            Assert.IsTrue(tabletDocuments.Count > 0);
            Assert.IsTrue(tabletDocuments[0].ContractNumber == contractNumber);
        }

        [TestMethod]
        public void HaveAllTabletDocumentsBeenSubmittedTest()
        {
            string contractNumber = "TEST_123";

            bool result = LibertyPower.Business.CustomerManagement.CRMBusinessObjects.TabletDocumentFactory.HaveAllTabletDocumentsBeenSubmitted(contractNumber);

            Assert.IsFalse(result);

            contractNumber = "TEST_1234";

            result = LibertyPower.Business.CustomerManagement.CRMBusinessObjects.TabletDocumentFactory.HaveAllTabletDocumentsBeenSubmitted(contractNumber);

            Assert.IsTrue(result);
        }

    }
}
