using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Diagnostics;
using System.IO;
using System.Reflection;

namespace CRMWCFTester
{
    [TestClass]
    public class ContractSubmissionTests
    {

        //[TestMethod]
        //public void TestSimpleContractSubmission()
        //{
        //    CRMTestingClient testAPI = new CRMTestingClient();
        //    ContractSubmissionClient submissionClient = new ContractSubmissionClient();
        //    CRMWebServices.WSContractSubmissionResult contractSubmissionResult = null;

        //    //Typically next month
        //    DateTime flowdate = new DateTime(2013, 6, 1);
        //    // Day which we have prices for
        //    DateTime signedDate = new DateTime(2013, 3, 9);

        //    LibertyPower.Business.CustomerManagement.CRMBusinessObjects.Contract newContract = testAPI.GenerateRandomContractBySalesChannel(flowdate, signedDate, 66);
        //    //newContract.AccountContracts.First().Account.AccountNumber = "08019779280000897925";
        //    //newContract.AccountContracts.First().Account.RetailMktId = 9;
        //    //newContract.AccountContracts.First().Account.UtilityId = 22;
        //    LibertyPower.Business.CustomerManagement.CRMBusinessObjects.Customer newCustomer = testAPI.GetTestCustomer();

        //    if (newContract.AccountContracts.First().Account.AccountType == LibertyPower.Business.CustomerManagement.CRMBusinessObjects.Enums.AccountType.RES)
        //        newCustomer.BusinessTypeId = 7;// residential customer type
        //    else
        //        newCustomer.BusinessTypeId = 6;// LLC

        //    LibertyPower.Business.CommonBusiness.SecurityManager.User user = testAPI.GetUserForContractSubmittal(newContract.SalesChannelId.Value);
            

        //    contractSubmissionResult = submissionClient.SubmitContract(newContract, newCustomer, user.userID);

        //    if (contractSubmissionResult.HasErrors)
        //    {
        //        foreach (var item in contractSubmissionResult.Errors)
        //        {
        //            Debug.WriteLine("Error: " + item);
        //        }
        //    }

        //    Assert.IsNotNull(contractSubmissionResult);
        //    Assert.IsFalse(contractSubmissionResult.HasErrors);
        //    Assert.IsTrue(contractSubmissionResult.Errors == null || contractSubmissionResult.Errors.Count() == 0);
        //    Assert.IsTrue(contractSubmissionResult.ContractId > 0);
        //    Assert.IsTrue(contractSubmissionResult.CustomerId > 0);
        //    Assert.IsFalse(string.IsNullOrEmpty(contractSubmissionResult.ContractNumber));

        //}

        //[TestMethod]
        //public void TestMultipleContractsSubmission()
        //{
        //    CRMTestingClient testAPI = new CRMTestingClient();
        //    ContractSubmissionClient submissionClient = new ContractSubmissionClient();
        //    CRMWebServices.WSContractSubmissionResult contractSubmissionResult = null;

        //    DateTime flowdate = new DateTime(2013, 2, 1);
        //    DateTime signedDate = new DateTime(2013, 1, 10);

        //    int numberofContracts = 1;
        //    for (int i = 0; i < numberofContracts; i++)
        //    {
        //        // LibertyPower.Business.CustomerManagement.CRMBusinessObjects.Contract newContract = testAPI.GenerateRandomContractBySalesChannel( flowdate, signedDate, 328 );
        //        LibertyPower.Business.CustomerManagement.CRMBusinessObjects.Contract newContract = testAPI.GenerateRandomContractBySalesChannel(flowdate, signedDate, 66);
        //        //newContract.AccountContracts.First().Account.AccountNumber = "08019779280000897925";
        //        //newContract.AccountContracts.First().Account.RetailMktId = 9;
        //        //newContract.AccountContracts.First().Account.UtilityId = 22;
        //        LibertyPower.Business.CustomerManagement.CRMBusinessObjects.Customer newCustomer = testAPI.GetTestCustomer();

        //        if (newContract.AccountContracts.First().Account.AccountType == LibertyPower.Business.CustomerManagement.CRMBusinessObjects.Enums.AccountType.RES)
        //            newCustomer.BusinessTypeId = 7;// residential customer type
        //        else
        //            newCustomer.BusinessTypeId = 6;// LLC

        //        LibertyPower.Business.CommonBusiness.SecurityManager.User user = testAPI.GetUserForContractSubmittal(newContract.SalesChannelId.Value);

        //        contractSubmissionResult = submissionClient.SubmitContract(newContract, newCustomer, user.userID);

        //        if (contractSubmissionResult.HasErrors)
        //        {
        //            foreach (var item in contractSubmissionResult.Errors)
        //            {
        //                Debug.WriteLine("Error: " + item);
        //            }
        //        }

        //        Assert.IsNotNull(contractSubmissionResult);
        //        Assert.IsFalse(contractSubmissionResult.HasErrors);
        //        Assert.IsTrue(contractSubmissionResult.Errors == null || contractSubmissionResult.Errors.Count() == 0);
        //        Assert.IsTrue(contractSubmissionResult.ContractId > 0);
        //        Assert.IsTrue(contractSubmissionResult.CustomerId > 0);
        //        Assert.IsFalse(string.IsNullOrEmpty(contractSubmissionResult.ContractNumber));
        //    }



        //}


        //[TestMethod]
        //public void TestCustomPricingContractSubmission()
        //{
        //    CRMTestingClient testAPI = new CRMTestingClient();
        //    ContractSubmissionClient submissionClient = new ContractSubmissionClient();
        //    CRMWebServices.WSContractSubmissionResult contractSubmissionResult = null;
        //    int priceId = 1129638547;
        //    int numberofContracts = 1;
        //    for (int i = 0; i < numberofContracts; i++)
        //    {
        //        LibertyPower.Business.CustomerManagement.CRMBusinessObjects.Contract newContract = testAPI.GenerateContractByPriceId(priceId);
        //        LibertyPower.Business.CustomerManagement.CRMBusinessObjects.Customer newCustomer = testAPI.GetTestCustomer();

        //        if (newContract.AccountContracts.First().Account.AccountType == LibertyPower.Business.CustomerManagement.CRMBusinessObjects.Enums.AccountType.RES)
        //            newCustomer.BusinessTypeId = 7;// residential customer type
        //        else
        //            newCustomer.BusinessTypeId = 6;// LLC
                

        //        LibertyPower.Business.CommonBusiness.SecurityManager.User user = testAPI.GetUserForContractSubmittal(newContract.SalesChannelId.Value);

        //        contractSubmissionResult = submissionClient.SubmitContract(newContract, newCustomer, user.userID);

        //        Debug.WriteLine("==============================================");

        //        if (contractSubmissionResult.HasErrors)
        //        {
        //            foreach (var item in contractSubmissionResult.Errors)
        //            {
        //                Debug.WriteLine("Error: " + item);
        //            }
        //        }

        //        Assert.IsNotNull(contractSubmissionResult);
        //        Assert.IsFalse(contractSubmissionResult.HasErrors);
        //        Assert.IsTrue(contractSubmissionResult.Errors == null || contractSubmissionResult.Errors.Count() == 0);
        //        Assert.IsTrue(contractSubmissionResult.ContractId > 0);
        //        Assert.IsTrue(contractSubmissionResult.CustomerId > 0);
        //        Assert.IsFalse(string.IsNullOrEmpty(contractSubmissionResult.ContractNumber));



        //        Debug.WriteLine("Contract Id: " + contractSubmissionResult.ContractId.ToString());
        //        Debug.WriteLine("Customer Id: " + contractSubmissionResult.CustomerId.ToString());
        //        Debug.WriteLine("Contract Number: " + contractSubmissionResult.ContractNumber);
        //        Debug.WriteLine("==============================================");

        //    }



        //}


        //[TestMethod]
        //public void TestSimpleRenewalContractSubmission()
        //{
        //    CRMTestingClient testAPI = new CRMTestingClient();
        //    ContractSubmissionClient contractAPI = new ContractSubmissionClient();
        //    ContractSubmissionClient submissionClient = new ContractSubmissionClient();
        //    CRMWebServices.WSContractSubmissionResult contractSubmissionResult = null;
        //    DateTime signedDate = new DateTime(2012, 11, 20);

        //    //LibertyPower.Business.CustomerManagement.CRMBusinessObjects.Contract newContract = testAPI.GenerateRandomRenewalContractBySalesChannel( signedDate, 328 );	//Broke by changes made in Main
        //    LibertyPower.Business.CustomerManagement.CRMBusinessObjects.Contract newContract = testAPI.GenerateRandomRenewalContractBySalesChannel(signedDate, 328);

        //    Assert.IsNotNull(newContract);
        //    Assert.IsNotNull(newContract.AccountContracts);
        //    Assert.IsTrue(newContract.AccountContracts.Count() > 0);
        //    LibertyPower.Business.CustomerManagement.CRMBusinessObjects.Customer newCustomer = contractAPI.GetCustomerById(newContract.AccountContracts.First().Account.CustomerId.Value);

        //    if (newContract.AccountContracts.First().Account.AccountType == LibertyPower.Business.CustomerManagement.CRMBusinessObjects.Enums.AccountType.RES)
        //        newCustomer.BusinessTypeId = 7;// residential customer type
        //    else
        //        newCustomer.BusinessTypeId = 6;// LLC

        //    LibertyPower.Business.CommonBusiness.SecurityManager.User user = testAPI.GetUserForContractSubmittal(newContract.SalesChannelId.Value);
        //    contractSubmissionResult = submissionClient.SubmitContract(newContract, newCustomer, user.userID);

        //    if (contractSubmissionResult.HasErrors)
        //    {
        //        foreach (var item in contractSubmissionResult.Errors)
        //        {
        //            Debug.WriteLine("Error: " + item);
        //        }
        //    }
        //    Assert.IsNotNull(contractSubmissionResult);
        //    Assert.IsFalse(contractSubmissionResult.HasErrors);
        //    Assert.IsTrue(contractSubmissionResult.Errors == null || contractSubmissionResult.Errors.Count() == 0);
        //    Assert.IsTrue(contractSubmissionResult.ContractId > 0);
        //    Assert.IsTrue(contractSubmissionResult.CustomerId > 0);
        //    Assert.IsFalse(string.IsNullOrEmpty(contractSubmissionResult.ContractNumber));
        //}

        //[TestMethod]
        //public void TestNewDealsAllChannelsAllMarkets()
        //{
        //    CRMTestingClient testingClient = new CRMTestingClient();
        //    CommonServicesClient commonClient = new CommonServicesClient();
        //    CRMWebServices.WSSalesChannel[] salesChannels = commonClient.GetActiveSalesChannels();
        //    ContractSubmissionClient submissionClient = new ContractSubmissionClient();
        //    CRMWebServices.WSContractSubmissionResult contractSubmissionResult = null;

        //    DateTime flowdate = new DateTime(2012, 11, 1);
        //    DateTime signedDate = new DateTime(2012, 9, 19);




        //    //we gonna test for all sales channels:
        //    foreach (CRMWebServices.WSSalesChannel channel in salesChannels)
        //    {
        //        CRMWebServices.WSRetailMarket[] scMarkets = commonClient.GetMarketsBySalesChannelCode(channel.ChannelName);
        //        LibertyPower.Business.CommonBusiness.SecurityManager.User scUser = testingClient.GetUserForContractSubmittal(channel.ChannelID);

        //        foreach (CRMWebServices.WSRetailMarket currentMarket in scMarkets)
        //        {
        //            CRMWebServices.WSUtility[] scUtils = commonClient.GetUtilitiesByMarketAndSalesChannel(currentMarket.MarketCode, channel.ChannelName);
        //            foreach (CRMWebServices.WSUtility utility in scUtils)
        //            {
        //                LibertyPower.Business.CustomerManagement.CRMBusinessObjects.Contract newContract = testingClient.GenerateRandomContractBySalesChannel(flowdate, signedDate, 328);	//Hacked to work with changes in Main
        //                LibertyPower.Business.CustomerManagement.CRMBusinessObjects.Customer newCustomer = testingClient.GetTestCustomer();

        //                if (newContract.AccountContracts.First().Account.AccountType == LibertyPower.Business.CustomerManagement.CRMBusinessObjects.Enums.AccountType.RES)
        //                    newCustomer.BusinessTypeId = 7;// residential customer type
        //                else
        //                    newCustomer.BusinessTypeId = 6;// LLC

        //                LibertyPower.Business.CommonBusiness.SecurityManager.User user = testingClient.GetUserForContractSubmittal(newContract.SalesChannelId.Value);

        //                contractSubmissionResult = submissionClient.SubmitContract(newContract, newCustomer, user.userID);

        //                string msg = string.Format("Sales Channel: {0}, Market: {1}, Utility: {2}, Message: {6}", channel.ChannelName, currentMarket.MarketCode, utility.Code, contractSubmissionResult.Message);
        //                Debug.WriteLine(msg);


        //                if (contractSubmissionResult.HasErrors)
        //                {
        //                    foreach (var item in contractSubmissionResult.Errors)
        //                    {
        //                        Debug.WriteLine("Error: " + item);
        //                    }
        //                }

        //                Assert.IsNotNull(contractSubmissionResult);
        //                Assert.IsFalse(contractSubmissionResult.HasErrors);
        //                Assert.IsTrue(contractSubmissionResult.Errors == null || contractSubmissionResult.Errors.Count() == 0);
        //                Assert.IsTrue(contractSubmissionResult.ContractId > 0);
        //                Assert.IsTrue(contractSubmissionResult.CustomerId > 0);
        //                Assert.IsFalse(string.IsNullOrEmpty(contractSubmissionResult.ContractNumber));


        //                if (!contractSubmissionResult.HasErrors)
        //                {
        //                    string msg2 = string.Format("Sales Channel: {0}, Market: {1}, Utility: {2}, Contract Id: {3} , Contract Number: {4}, CustomerId: {5}, Message: {6}", channel.ChannelName, currentMarket.MarketCode, utility.Code, contractSubmissionResult.ContractId, contractSubmissionResult.ContractNumber, contractSubmissionResult.CustomerId, contractSubmissionResult.Message);
        //                    Debug.WriteLine(msg2);
        //                }


        //            }
        //        }
        //    }

        //}

        //[TestMethod]
        //public void TestFileuploadWebService()
        //{
        //    ContractSubmissionClient csClient = new ContractSubmissionClient();
        //    CommonServicesClient commonAPIClient = new CommonServicesClient();
        //    // string filename = @"CRMWCFTester.SampleFiles.SmallFile.txt";
        //    string filename = @"CRMWCFTester.SampleFiles.SampleContract.pdf";
        //    Assembly thisAssembly = Assembly.GetExecutingAssembly();
        //    CRMWebServices.WSDocumentResult docRes = null;
        //    Byte[] info = null;
        //    //string[] names = thisAssembly.GetManifestResourceNames();
        //    Stream st = thisAssembly.GetManifestResourceStream(filename);
        //    info = new byte[st.Length];
        //    st.Read(info, 0, Convert.ToInt32(st.Length));
        //    CRMWebServices.WSDocumentType[] docTypes = commonAPIClient.GetDocumentTypes();

        //    CRMWebServices.WSDocumentType contractType = docTypes.First(f => f.DocumentType.ToLower().Contains("contract"));
        //    // Get the document types:
        //    docRes = csClient.SaveDocument(info, "DocName", contractType.DocTypeID, null, "20110041679", "libertypower\\jforero");

        //    Assert.IsNotNull(docRes);
        //    Assert.IsNull(docRes.Errors);

        //}

        //public byte[] FileToByteArray(string fileName)
        //{
        //    byte[] buff = null;
        //    FileStream fs = new FileStream(fileName, FileMode.Open, FileAccess.Read);
        //    BinaryReader br = new BinaryReader(fs);
        //    long numBytes = new FileInfo(fileName).Length;
        //    buff = br.ReadBytes((int)numBytes);
        //    return buff;
        //}

        //[TestMethod]
        //public void FreeFormContractSubmission()
        //{
        //    CRMTestingClient testAPI = new CRMTestingClient();
        //    ContractSubmissionClient submissionClient = new ContractSubmissionClient();
        //    CRMWebServices.WSContractSubmissionResult contractSubmissionResult = null;

        //    DateTime flowdate = new DateTime(2012, 12, 1);
        //    DateTime signedDate = new DateTime(2012, 10, 11);

        //    LibertyPower.Business.CustomerManagement.CRMBusinessObjects.Contract newContract = testAPI.GenerateRandomContractBySalesChannel(flowdate, signedDate, 328);
        //    LibertyPower.Business.CustomerManagement.CRMBusinessObjects.Customer newCustomer = testAPI.GetTestCustomer();

        //    newCustomer.Contact.Email = "";

        //    if (newContract.AccountContracts.First().Account.AccountType == LibertyPower.Business.CustomerManagement.CRMBusinessObjects.Enums.AccountType.RES)
        //        newCustomer.BusinessTypeId = 7;// residential customer type
        //    else
        //        newCustomer.BusinessTypeId = 6;// LLC

        //    LibertyPower.Business.CommonBusiness.SecurityManager.User user = testAPI.GetUserForContractSubmittal(newContract.SalesChannelId.Value);

        //    contractSubmissionResult = submissionClient.SubmitContract(newContract, newCustomer, user.userID);

        //    if (contractSubmissionResult.HasErrors)
        //    {
        //        foreach (var item in contractSubmissionResult.Errors)
        //        {
        //            Debug.WriteLine("Error: " + item);
        //        }
        //    }

        //    Assert.IsNotNull(contractSubmissionResult);
        //    Assert.IsFalse(contractSubmissionResult.HasErrors);
        //    Assert.IsTrue(contractSubmissionResult.Errors == null || contractSubmissionResult.Errors.Count() == 0);
        //    Assert.IsTrue(contractSubmissionResult.ContractId > 0);
        //    Assert.IsTrue(contractSubmissionResult.CustomerId > 0);
        //    Assert.IsFalse(string.IsNullOrEmpty(contractSubmissionResult.ContractNumber));

        //}

    }
}
