using System;
using System.Collections.Generic;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.IO;
using System.Net;
using System.Text;

namespace OrdersAPITests
{
    [TestClass]
    public class OrderEntryTest
    {
        [TestMethod]
        public void SubmitRandomBasicContract()
        {
            OrderEntryAPI.CRMTestingClient testingClient = new OrderEntryAPI.CRMTestingClient();
            OrderEntryAPI.OrderEntryClient orderEntryClient = new OrderEntryAPI.OrderEntryClient();
            OrderEntryAPI.ContractPackage package = testingClient.GenerateRandomContractSubmissionPackage();
            package.UserId = 883;
            OrderEntryAPI.WSContractSubmissionResult result = orderEntryClient.SubmitContract(package.Contract, package.Customer, package.UserId);
            Assert.IsFalse(result.HasErrors);
            Assert.IsTrue(!string.IsNullOrWhiteSpace(result.ContractNumber));
        }

        [TestMethod]
        public void SubmitRandomTabletContract()
        {
            OrderEntryAPI.CRMTestingClient testingClient = new OrderEntryAPI.CRMTestingClient();
            OrderEntryAPI.OrderEntryClient orderEntryClient = new OrderEntryAPI.OrderEntryClient();
            OrderEntryAPI.ContractPackage package = testingClient.GenerateRandomContractSubmissionPackage();
            package.UserId = 883;

            //Record on ClientSubmitApplicationKey table should be so that the ClientApplicationTypeId is 5, which is Tablet
            package.Contract.ClientSubmitApplicationKey = new Guid("52041024-588F-4276-9129-79E3DC63BAC6");

            OrderEntryAPI.WSContractSubmissionResult result = orderEntryClient.SubmitContract(package.Contract, package.Customer, package.UserId);
            Assert.IsFalse(result.HasErrors);
            Assert.IsTrue(!string.IsNullOrWhiteSpace(result.ContractNumber));
        }

        [TestMethod]
        public void SubmitRandomBadTabletContract()
        {
            OrderEntryAPI.CRMTestingClient testingClient = new OrderEntryAPI.CRMTestingClient();
            OrderEntryAPI.OrderEntryClient orderEntryClient = new OrderEntryAPI.OrderEntryClient();
            OrderEntryAPI.ContractPackage package = testingClient.GenerateRandomContractSubmissionPackage();
            package.UserId = 883;

            //Record on ClientSubmitApplicationKey table should be so that the ClientApplicationTypeId is 5, which is Tablet
            package.Contract.ClientSubmitApplicationKey = new Guid("4617F7F1-DCDB-B11C-1D30-90924D75F4A4");
            package.Contract.AccountContracts[0].Account.Origin = "";

            OrderEntryAPI.WSContractSubmissionResult result = orderEntryClient.SubmitContract(package.Contract, package.Customer, package.UserId);
            Assert.IsTrue(result.HasErrors);
        }

        [TestMethod]
        public void FileMetaDataTestInvalidContractNumber()
        {
            OrderEntryAPI.CRMTestingClient testingClient = new OrderEntryAPI.CRMTestingClient();
            OrderEntryAPI.OrderEntryClient orderEntryClient = new OrderEntryAPI.OrderEntryClient();
            OrderEntryAPI.ContractPackage package = testingClient.GenerateRandomContractSubmissionPackage();
            package.UserId = 883;

            // file metadata
            package.Contract.TabletDocuments = new List<OrderEntryAPI.TabletDocument>();

            package.Contract.TabletDocuments.Add(new OrderEntryAPI.TabletDocument()
            {
                ContractNumber = "", // purposely set empty contract number so that it should validate this
                DocumentTypeID = 1,
                FileName = "test.pdf",
                SalesAgentID = 883
            });


            OrderEntryAPI.WSContractSubmissionResult result = orderEntryClient.SubmitContract(package.Contract, package.Customer, package.UserId);
            Assert.IsTrue(result.HasErrors);
            Assert.IsTrue(string.IsNullOrWhiteSpace(result.ContractNumber));
        }

        [TestMethod]
        public void FileMetaDataTest()
        {
            OrderEntryAPI.CRMTestingClient testingClient = new OrderEntryAPI.CRMTestingClient();
            OrderEntryAPI.OrderEntryClient orderEntryClient = new OrderEntryAPI.OrderEntryClient();
            OrderEntryAPI.ContractPackage package = testingClient.GenerateRandomContractSubmissionPackage();
            package.UserId = 883;
            package.Contract.Number = orderEntryClient.GetNewContractNumber();
            // file metadata
            package.Contract.TabletDocuments = new List<OrderEntryAPI.TabletDocument>();

            package.Contract.TabletDocuments.Add(new OrderEntryAPI.TabletDocument()
            {
                ContractNumber = package.Contract.Number,
                DocumentTypeID = 1,
                FileName = "test.pdf",
                SalesAgentID = 883
            });


            OrderEntryAPI.WSContractSubmissionResult result = orderEntryClient.SubmitContract(package.Contract, package.Customer, package.UserId);
            Assert.IsFalse(result.HasErrors);
            Assert.IsTrue(!string.IsNullOrWhiteSpace(result.ContractNumber));
        }

        #region Test Methods to Validate the Origin field of Accounts
        [TestMethod]
        public void SubmitRandomTabletContractForOriginTest()
        {
            OrderEntryAPI.CRMTestingClient testingClient = new OrderEntryAPI.CRMTestingClient();
            OrderEntryAPI.OrderEntryClient orderEntryClient = new OrderEntryAPI.OrderEntryClient();
            OrderEntryAPI.ContractPackage package = testingClient.GenerateRandomContractSubmissionPackage();
            package.UserId = 883;

            //Record on ClientSubmitApplicationKey table should be so that the ClientApplicationTypeId is 5, which is Tablet
            package.Contract.ClientSubmitApplicationKey = new Guid("52041024-588F-4276-9129-79E3DC63BAC6");

            OrderEntryAPI.WSContractSubmissionResult result = orderEntryClient.SubmitContract(package.Contract, package.Customer, package.UserId);
            Assert.IsFalse(result.HasErrors);
            Assert.IsTrue(!string.IsNullOrWhiteSpace(result.ContractNumber));

            OrdersAPITests.OrderEntryAPI.Contract contract = testingClient.GetContractWithLoadedSubtypes(result.ContractId);
            foreach (OrdersAPITests.OrderEntryAPI.AccountContract ac in contract.AccountContracts)
            {
                Assert.IsTrue(ac.Account.Origin == "GENIE");
            }
        }

        [TestMethod]
        public void SubmitRandomOnlineEnrollmentContractForOriginTest()
        {
            OrderEntryAPI.CRMTestingClient testingClient = new OrderEntryAPI.CRMTestingClient();
            OrderEntryAPI.OrderEntryClient orderEntryClient = new OrderEntryAPI.OrderEntryClient();
            OrderEntryAPI.ContractPackage package = testingClient.GenerateRandomContractSubmissionPackage();
            package.UserId = 883;

            //Record on ClientSubmitApplicationKey table should be so that the ClientApplicationTypeId is 4, which is OnlineEnrollment
            package.Contract.ClientSubmitApplicationKey = new Guid("BDA11D91-7ADE-4DA1-855D-24ADFE39D174");

            OrderEntryAPI.WSContractSubmissionResult result = orderEntryClient.SubmitContract(package.Contract, package.Customer, package.UserId);
            Assert.IsFalse(result.HasErrors);
            Assert.IsTrue(!string.IsNullOrWhiteSpace(result.ContractNumber));

            OrdersAPITests.OrderEntryAPI.Contract contract = testingClient.GetContractWithLoadedSubtypes(result.ContractId);
            foreach (OrdersAPITests.OrderEntryAPI.AccountContract ac in contract.AccountContracts)
            {
                Assert.IsTrue(ac.Account.Origin == "WEB");
            }
        }

        [TestMethod]
        public void SubmitRandomInvalidGuidContractForOriginTest()
        {
            OrderEntryAPI.CRMTestingClient testingClient = new OrderEntryAPI.CRMTestingClient();
            OrderEntryAPI.OrderEntryClient orderEntryClient = new OrderEntryAPI.OrderEntryClient();
            OrderEntryAPI.ContractPackage package = testingClient.GenerateRandomContractSubmissionPackage();
            package.UserId = 883;

            //Setting this to an invalid Guid so we can test if the validation is working
            package.Contract.ClientSubmitApplicationKey = new Guid("ADA11D91-7ADE-4DA1-855D-24ADFE39D174");

            OrderEntryAPI.WSContractSubmissionResult result = orderEntryClient.SubmitContract(package.Contract, package.Customer, package.UserId);
            Assert.IsTrue(result.HasErrors);
        }

        [TestMethod]
        public void SubmitRandomDealCaptureContractForOriginTest()
        {
            OrderEntryAPI.CRMTestingClient testingClient = new OrderEntryAPI.CRMTestingClient();
            OrderEntryAPI.OrderEntryClient orderEntryClient = new OrderEntryAPI.OrderEntryClient();
            OrderEntryAPI.ContractPackage package = testingClient.GenerateRandomContractSubmissionPackage();
            package.UserId = 883;

            //Record on ClientSubmitApplicationKey table should be so that the ClientApplicationTypeId is 1, which is PartnerPortal
            package.Contract.ClientSubmitApplicationKey = new Guid("05553978-8EE9-46FE-9E9E-F3071B6C5556");

            //for PartnerPortal, we need to set the origin manually, since it can be either Online or Excel
            foreach (OrdersAPITests.OrderEntryAPI.AccountContract ac in package.Contract.AccountContracts)
            {
                ac.Account.Origin = "ONLINE";
            }

            OrderEntryAPI.WSContractSubmissionResult result = orderEntryClient.SubmitContract(package.Contract, package.Customer, package.UserId);
            Assert.IsFalse(result.HasErrors);
            Assert.IsTrue(!string.IsNullOrWhiteSpace(result.ContractNumber));

            OrdersAPITests.OrderEntryAPI.Contract contract = testingClient.GetContractWithLoadedSubtypes(result.ContractId);
            foreach (OrdersAPITests.OrderEntryAPI.AccountContract ac in contract.AccountContracts)
            {
                Assert.IsTrue(ac.Account.Origin == "ONLINE");
            }
        }

        [TestMethod]
        public void SubmitRandomPartnerPortalContractWithWrongOriginForOriginTest()
        {
            OrderEntryAPI.CRMTestingClient testingClient = new OrderEntryAPI.CRMTestingClient();
            OrderEntryAPI.OrderEntryClient orderEntryClient = new OrderEntryAPI.OrderEntryClient();
            OrderEntryAPI.ContractPackage package = testingClient.GenerateRandomContractSubmissionPackage();
            package.UserId = 883;

            //Record on ClientSubmitApplicationKey table should be so that the ClientApplicationTypeId is 1, which is PartnerPortal
            package.Contract.ClientSubmitApplicationKey = new Guid("05553978-8EE9-46FE-9E9E-F3071B6C5556");

            //for PartnerPortal, we need to set the origin manually, since it can be either Online or Excel
            //this should throw an error and notify that the origin is invalid
            foreach (OrdersAPITests.OrderEntryAPI.AccountContract ac in package.Contract.AccountContracts)
            {
                ac.Account.Origin = "WEB";
            }

            OrderEntryAPI.WSContractSubmissionResult result = orderEntryClient.SubmitContract(package.Contract, package.Customer, package.UserId);
            Assert.IsTrue(result.HasErrors);
        }

        [TestMethod]
        public void SubmitRandomThirdPartyContractWithWrongOriginForOriginTest()
        {
            OrderEntryAPI.CRMTestingClient testingClient = new OrderEntryAPI.CRMTestingClient();
            OrderEntryAPI.OrderEntryClient orderEntryClient = new OrderEntryAPI.OrderEntryClient();
            OrderEntryAPI.ContractPackage package = testingClient.GenerateRandomContractSubmissionPackage();
            package.UserId = 883;

            //Record on ClientSubmitApplicationKey table should be so that the ClientApplicationTypeId is 6, which is ThirdParty
            package.Contract.ClientSubmitApplicationKey = new Guid("24A10E6E-51F3-4F9E-A5FF-40110DB3DDB9");

            //for ThirdParty, we need to set the origin manually
            foreach (OrdersAPITests.OrderEntryAPI.AccountContract ac in package.Contract.AccountContracts)
            {
                ac.Account.Origin = "BATCH";
            }

            OrderEntryAPI.WSContractSubmissionResult result = orderEntryClient.SubmitContract(package.Contract, package.Customer, package.UserId);
            Assert.IsFalse(result.HasErrors);
            Assert.IsTrue(!string.IsNullOrWhiteSpace(result.ContractNumber));

            OrdersAPITests.OrderEntryAPI.Contract contract = testingClient.GetContractWithLoadedSubtypes(result.ContractId);
            foreach (OrdersAPITests.OrderEntryAPI.AccountContract ac in contract.AccountContracts)
            {
                Assert.IsTrue(ac.Account.Origin == "BATCH");
            }
        }
        #endregion

        /// <summary>
        /// Validated the tablet email send functionality.
        /// -SETUP-
        /// 1-Create Local document repository and upated the location in the DB tables
        /// ManagerRoot,DocumentsSetup.
        /// 2-Updated the OAPI config to use the local repository.
        /// 3-Update the OAPI config to set the Flag SendEmail = false to send all email to the 
        /// Test Email.
        /// 4-Set the test emails in the OAPIconfig file as below.
        ///<add key="SendEmails" value="false"/>
        ///<add key="TestCustomerEmail" value="sjena@libertypowercorp.com"/>
        ///<add key="TestSalesChannelEmail" value="sjena@libertypowercorp.com"/>
        ///<add key="TestECMEmail" value="sjena@libertypowercorp.com"/>
        ///<add key="ExchangeUserEmail" value="sjena@libertypowercorp.com"/>
        ///<add key="ExchangeUserName" value="xxxxxx"/>
        ///<add key="ExchangeUserPassword" value="xxxxxxxxxxx"/>
        /// 
        /// 5-Set the priceID,hostAddress,CLIENT_SUBMIT_APP_KEY as per the environment.
        /// </summary>
        [TestMethod]
        public void ValidateTabletEmail()
        {
            /*
         *1- Saves the contract
         *2- SaveContract Suporting file
         *3- Send Email
            */
            string hostAddress = "http://localhost:57873/";
            System.Net.HttpWebRequest request = System.Net.WebRequest.CreateHttp(
                hostAddress + @"orderentry.svc/json/GetNewContractNumber?apikey=2194fc4e-efc5-4c87-b571-bbd02dd54e6c");

            request.ContentType = "Application/JSON";
            request.Method = "GET";
            string contractNumber = GetResponseText(request.GetResponse());

            //PriceId which is valid in the environment.
            string priceId = "11173198801";
            contractNumber = contractNumber.Replace("\"", "");
            //Get a client submit application key from db (select * from LibertyPower..ClientSubmitApplicationKey 
            //    where ClientApplicationTypeId=5)
            string CLIENT_SUBMIT_APP_KEY = "6D7751D5-90E8-4DC1-9658-41E95BDA3A4F";

            request = CreateWebRequest(hostAddress, "OrderEntry.svc", "SubmitContract", "POST");
            //Save Contract
            string requestJSON = string.Format(Helper.REQUEST_SAVECONTRACT, contractNumber, priceId, CLIENT_SUBMIT_APP_KEY);
            WritePostData(request, requestJSON);
            string submitContractJSON = GetResponseText(request.GetResponse());
            //Save Contract Supporting File - Contract
            request = CreateWebRequest(hostAddress, "DocumentService.svc", "SaveContractSupportingFile", "POST");
            requestJSON = string.Format(Helper.REQUEST_SAVECONTRACTSUPPORTINGFILE, contractNumber);
            WritePostData(request, requestJSON);
            string submitContractFileResponse = GetResponseText(request.GetResponse());
            //Save Contract Supporting File - Audio File
            request = CreateWebRequest(hostAddress, "DocumentService.svc", "SaveContractSupportingFile", "POST");
            requestJSON = string.Format(Helper.REQUEST_SAVECONTRACTSUPPORTINGFILE1, contractNumber);
            WritePostData(request, requestJSON);
            string submitContractFileResponse1 = GetResponseText(request.GetResponse());
            //Send the contract emails Accepted or rejected.
            request = CreateWebRequest(hostAddress, "OrderEntry.svc", "SendContractEmails", "POST");
            requestJSON = contractNumber;
            WritePostData(request, requestJSON);
            string sendEmail = GetResponseText(request.GetResponse());

        }

        private static HttpWebRequest WritePostData(System.Net.HttpWebRequest request, string requestJSON)
        {
            // convert string to stream
            byte[] byteArray = Encoding.UTF8.GetBytes(requestJSON);
            //byte[] byteArray = Encoding.ASCII.GetBytes(contents);                   

            request.GetRequestStream().Write(byteArray, 0, byteArray.Length);
            return request;
        }
        private HttpWebRequest CreateWebRequest(string hostAddress, string service, string operation, string method)
        {

            string webServiceURL = service + "/json/";
            string apiKeyString = "?apikey=2194fc4e-efc5-4c87-b571-bbd02dd54e6c";
            string URL = string.Concat(hostAddress, webServiceURL, operation, apiKeyString);
            //Add logic to invoke the service and get response.
            HttpWebRequest request = System.Net.WebRequest.CreateHttp(URL);
            request.ContentType = "Application/JSON";
            request.Method = method;
            request.Timeout = 1000000;
            request.ContinueTimeout = 1000000;
            request.ReadWriteTimeout = 1000000;
            return request;
        }
        private string GetResponseText(WebResponse response)
        {
            string responseText = string.Empty;
            using (Stream responseStream = response.GetResponseStream())
            {
                StreamReader reader = new StreamReader(responseStream);
                responseText = reader.ReadToEnd();
            }
            return responseText;
        }



    }

}
