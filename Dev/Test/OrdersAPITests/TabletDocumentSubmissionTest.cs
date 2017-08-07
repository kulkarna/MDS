using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using DocAPI = OrdersAPITests.DocumentServiceAPI;

namespace OrdersAPITests
{
    [TestClass]
    public class TabletDocumentSubmissionTest
    {
        [TestMethod]
        [DeploymentItem("SampleFiles\\SampleContract.pdf")]
        public void GetDocumentSubmissionStatusForGoodContractTest()
        {
            //Create a new contract and submit itto LP
            OrderEntryAPI.CRMTestingClient testingClient = new OrderEntryAPI.CRMTestingClient();
            DocumentServiceAPI.DocumentServiceClient testingClientDocuments = new DocumentServiceAPI.DocumentServiceClient();

            OrderEntryAPI.OrderEntryClient orderEntryClient = new OrderEntryAPI.OrderEntryClient();
            OrderEntryAPI.ContractPackage package = testingClient.GenerateRandomContractSubmissionPackage();
            package.UserId = 883;
            package.Contract.Number = orderEntryClient.GetNewContractNumber();

            //Record on ClientSubmitApplicationKey table should be so that the ClientApplicationTypeId is 5, which is Tablet
            package.Contract.ClientSubmitApplicationKey = new Guid("52041024-588F-4276-9129-79E3DC63BAC6");

            //Add document based on sample file
            OrderEntryAPI.Document document = CreateContract(package.Contract.Number);
            package.Contract.Documents = new List<OrderEntryAPI.Document>();
            package.Contract.Documents.Add(document);

            package.Contract.TabletDocuments = new List<OrderEntryAPI.TabletDocument>();
            package.Contract.TabletDocuments.Add(new OrderEntryAPI.TabletDocument()
            {
                ContractNumber = package.Contract.Number,
                DocumentTypeID = document.DocumentTypeId,
                FileName = document.Name,
                SalesAgentID = 883
            });

            OrderEntryAPI.WSContractSubmissionResult result = orderEntryClient.SubmitContract(package.Contract, package.Customer, package.UserId);

            //Checks if all documents have been received
            DocumentServiceAPI.WSDocumentSubmissionStatus status = testingClientDocuments.GetDocumentSubmissionStatus(package.Contract.Number);

            Assert.IsTrue(status.HaveAllFilesBeenSubmitted);
            Assert.IsTrue(status.IncomingDocuments.Count() == status.ReceivedDocuments.Count());
        }

        private OrderEntryAPI.Document CreateContract(string contractNumber)
        {
            DocumentServiceAPI.DocumentServiceClient testingClientDocuments = new DocumentServiceAPI.DocumentServiceClient();

            string filename = @"SampleContract.pdf";
            byte[] fileBytes;
            FileStream fs = null;
            try
            {
                fs = File.OpenRead(filename);
                fileBytes = new byte[fs.Length];
                fs.Read(fileBytes, 0, Convert.ToInt32(fs.Length));
                fs.Close();
            }
            catch (Exception ex)
            {
                if (fs != null)
                    fs.Close();

                throw new ApplicationException("Could not read file in path " + filename + ". " + ex.StackTrace);
            }

            OrderEntryAPI.Document document = new OrderEntryAPI.Document()
            {
                FileBytes = fileBytes,
                Name = "SampleContract.pdf",
                DocumentTypeId = 1
            };

            return document;
        }

        [TestMethod]
        public void GetDocumentSubmissionStatusForBadContractTest()
        {
            //Create a new contract and submit itto LP
            OrderEntryAPI.CRMTestingClient testingClient = new OrderEntryAPI.CRMTestingClient();
            DocumentServiceAPI.DocumentServiceClient testingClientDocuments = new DocumentServiceAPI.DocumentServiceClient();

            OrderEntryAPI.OrderEntryClient orderEntryClient = new OrderEntryAPI.OrderEntryClient();
            OrderEntryAPI.ContractPackage package = testingClient.GenerateRandomContractSubmissionPackage();
            package.UserId = 883;
            package.Contract.Number = orderEntryClient.GetNewContractNumber();

            //Record on ClientSubmitApplicationKey table should be so that the ClientApplicationTypeId is 5, which is Tablet
            package.Contract.ClientSubmitApplicationKey = new Guid("85ACA976-487A-4CD7-8DF4-42C7C9EA2396");

            //For a test that fails, we dont add the documents
            //OrderEntryAPI.Document document = CreateContract(package.Contract.Number);
            //package.Contract.Documents = new List<OrderEntryAPI.Document>();
            //package.Contract.Documents.Add(document);

            package.Contract.TabletDocuments = new List<OrderEntryAPI.TabletDocument>();
            package.Contract.TabletDocuments.Add(new OrderEntryAPI.TabletDocument()
            {
                ContractNumber = package.Contract.Number,
                DocumentTypeID = 1,
                FileName = "SampleContract.pdf",
                SalesAgentID = 883
            });

            OrderEntryAPI.WSContractSubmissionResult result = orderEntryClient.SubmitContract(package.Contract, package.Customer, package.UserId);

            //Checks if all documents have been received
            DocumentServiceAPI.WSDocumentSubmissionStatus status = testingClientDocuments.GetDocumentSubmissionStatus(package.Contract.Number);

            Assert.IsFalse(status.HaveAllFilesBeenSubmitted);
            Assert.IsFalse(status.IncomingDocuments.Count() == status.ReceivedDocuments.Count());
        }
        [TestMethod]
        public void GetDocumentByMarketProductTest()
        {
            using (DocumentServiceAPI.DocumentServiceClient testingClientDocuments = new DocumentServiceAPI.DocumentServiceClient())
            {

                testingClientDocuments.InnerChannel.OperationTimeout = TimeSpan.FromSeconds(600);


                List<DocAPI.TabletDocumentInputParams> serviceInput = new List<DocumentServiceAPI.TabletDocumentInputParams>() { 
                new DocAPI.TabletDocumentInputParams(){ BrandID=1, MarketID=0},
                null,
                null,
                new DocumentServiceAPI.TabletDocumentInputParams(){ BrandID=1, MarketID=13},
                new DocumentServiceAPI.TabletDocumentInputParams(){ BrandID=8, MarketID=13},
                new DocumentServiceAPI.TabletDocumentInputParams(){ BrandID=-2, MarketID=-3},
                };
                List<OrdersAPITests.DocumentServiceAPI.TabletDocumentMappingData> result =
                                  testingClientDocuments.GetDocumentMasterData(serviceInput);
                Assert.IsNull(result[1]);
                Assert.IsNull(result[2]);
                Assert.IsTrue(result.Count == serviceInput.Count, "The returned array does not contain expected number of details. Expected {0} Actual {1}", serviceInput.Count, result.Count);
                //We know that the last input will bring null as the inputs are invalid.
                Assert.IsNull(result[5]);
            }
        }
    }
}
