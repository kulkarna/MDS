using System;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using api = LibertyPower.Business.CustomerAcquisition.OnlineEnrollment.Domain.OrderEntry; //OnlineEnrollment.Integration.ContractAPI;
using dSVC = LibertyPower.Business.CustomerAcquisition.OnlineEnrollment.Domain.DocumentService;
using crm = LibertyPower.Business.CustomerManagement.CRMBusinessObjects;
using oeDomain = LibertyPower.Business.CustomerAcquisition;
using oeModels = LibertyPower.Business.CustomerAcquisition.OnlineEnrollment.Domain.Models;
using System.Collections.Generic;
using conversion = LibertyPower.Business.CustomerAcquisition.OnlineEnrollment.Domain.LibertyPowerHelpers;

using System.IO;
using System.Runtime.Serialization.Formatters.Binary;
using System.Runtime.Serialization;
using System.Configuration;

namespace OnlineEnrollment.Integration
{
    [TestClass]
    public class OnlineEnrollmentDocumentRetrievalTest
    {
        private oeDomain.OnlineEnrollment.Domain.OnlineEnrollmentRepository repository = new oeDomain.OnlineEnrollment.Domain.OnlineEnrollmentRepository();

        //DocumentTestRun testRun = new DocumentTestRun(@"C:\TestResults");
        private DocumentTestRun documentTestRun;
        
        
        public OnlineEnrollmentDocumentRetrievalTest()
        {
            //repository.LazyLoadingEnabled = false;
            repository.ProxyCreationEnabled = false;
            this.documentTestRun = new DocumentTestRun(ConfigurationManager.AppSettings["TestResultsPath"]);
        }
        public class TestIteration
        {
            public DateTime IterationStart { get; set; }
            public DateTime IterationEnd { get; set; }
            public DocumentTestInput Input { get; set; }
            public DocumentTestOutput Output { get; set; }
            public Double TotalIterationTime { get { return (IterationEnd - IterationStart).TotalSeconds; } set { { /*just for XML serialization*/} } }
        }

        public class DocumentTestRun
        {

            public DocumentTestRun()
            {
                Iterations = new List<TestIteration>();
            }


            public DocumentTestRun(string outputDirectory)
            {
                Iterations = new List<TestIteration>();
                this.OutputFileDir = CreateDir(outputDirectory);
                CurrentFolder = "./";
            }

            public List<TestIteration> Iterations { get; set; }


            //public List<DocumentTestInput> inputs { get; set; }
            //public List<DocumentTestResult> output { get; set; }

            /// <summary>
            /// Custom output Dir to copy the generated files.
            /// </summary>
            public string OutputFileDir { get; set; }
            public string CurrentFolder { get; set; }
            public string OutputFolder { get { return Path.GetFileName(OutputFileDir); } set { { /*just for XML serialization*/} } }
            public string TestStartFormatted { get { return TestStart.ToString(ConfigurationManager.AppSettings["TestRunDateFormat"]); } set { /*just for XML serialization*/} }
            //public double TestTimeSpan { 
            //    get 
            //    { 
                    
            //        return (TestEnd - TestStart).TotalMinutes; 
            //    } 
            //    set { /*just for XML serialization*/} 
            //}
            public string TotalTestTime
            {
                get
                {
                    return String.Format("{0}:{1}", (TestEnd - TestStart).Minutes, (TestEnd - TestStart).Seconds);
                }
                set{}
            }

            public DateTime TestStart { get; set; }
            public DateTime TestEnd { get; set; }
            /// <summary>
            /// Application output /startup dir.
            /// </summary>
            public string ApplicationOutputDir { get { return AppDomain.CurrentDomain.BaseDirectory; } }

            public Int32 PassCount { 
                get 
                { 
                    return this.Iterations.Where(x => x != null && x.Output != null && x.Output.ActualTestResult.ToLower() == "pass").Count(); 
                } 
                set {/*just for XML seria lization*/} }
            public Int32 TotalTestCases { 
                get { return Iterations.Count; } 
                set {/*just for XML serialization*/} }
            public Int32 FailCount { 
                get 
                { 
                    return this.Iterations.Where(x => x != null && x.Output != null && x.Output.ActualTestResult.ToLower() == "fail").Count();
                } 
                set {/*just for XML serialization*/} }

            public void LogResult()
            {

            }

            private string CreateDir(string outputDirectory)
            {
                string finalPath = outputDirectory;
                if (!string.IsNullOrEmpty(outputDirectory))
                {
                    if (!System.IO.Directory.Exists(outputDirectory))
                    {
                        System.IO.Directory.CreateDirectory(outputDirectory);
                    }
                    string defaultFolder = string.
                        //Format("TestResults_{0}", DateTime.Now.ToString("MM-dd-yyyy-HH-mm-ss-ffffff"));
                        Format("TestResults_{0}", DateTime.Now.ToString("MM-dd-yyyy"));
                    int currentCount = 0;
                    if (Directory.Exists(Path.Combine(outputDirectory, defaultFolder)))
                    {
                        currentCount = Directory.GetDirectories(outputDirectory).Where(dir => dir.Contains(defaultFolder)).ToList().
                            Select(item => item.ToCharArray().Where(x => x == '_').
                                Count() > 1 ? int.Parse(item.Split(new char[] { '_' }).Last()) : 0).Max();
                        finalPath = Path.Combine(outputDirectory,
                            string.Format("{0}_{1}", defaultFolder, (currentCount + 1)));
                    }
                    else
                    {
                        finalPath = Path.Combine(outputDirectory, defaultFolder);
                    }




                    if (!System.IO.Directory.Exists(finalPath))
                    {
                        Directory.CreateDirectory(finalPath);
                    }
                }
                return finalPath;
            }
        }
        public class DocumentTestInput
        {
            public Int64 IterationID { get; set; }
            public int ChannelID { get; set; }
            public int ProductBrandID { get; set; }
            public string ProductName { get; set; }
            public int UtilityID { get; set; }
            public string UtilityCode { get; set; }
            public int MarketID { get; set; }
            public string MarketCode { get; set; }
            public int AccountTypeID { get; set; }
            public string AccountType { get; set; }
            public string Language { get; set; }
            public int LanguageID { get; set; }

            public Int64 PriceIdToUse { get; set; }
            public string TemplateName { get; set; }
            public string FileExtension { get; set; }

        }
        public class DocumentTestOutput
        {
            public string ErrorMessage { get; set; }
            public bool FileReceived { get; set; }
            public string FileName { get; set; }
            public string FullFilePath { get; set; }
            public bool IsSuccessful { get; set; }
            public string ActualTestResult { get; set; }

        }

        public class SerializableContracts : List<oeModels.Contract>
        {



        }

        private void SerializeContentDataContract(Stream stream, object obj, Type objType)
        {

            //System.Xml.Serialization.XmlSerializer serializer = new System.Xml.Serialization.XmlSerializer(objType);
            DataContractSerializer serializer = new DataContractSerializer(objType, new DataContractSerializerSettings()
            {
                PreserveObjectReferences = true,
                MaxItemsInObjectGraph = Int32.MaxValue
                /*,
                KnownTypes = new List<Type>() { typeof(oeModels.Contract) }*/
            });

            serializer.WriteObject(stream, obj);
            stream.Flush();
            stream.Close();


        }
        private void SerializeContentXML(Stream stream, object obj, Type objectType)
        {
            System.Xml.Serialization.XmlSerializer serializer = new System.Xml.Serialization.XmlSerializer(objectType);
            serializer.Serialize(stream, obj);
            stream.Flush();
            stream.Close();
        }
        private bool GenerateTestDataThroughTestHarness(List<int> listOfContractIds, string filePath)
        {
            bool isSuccessful = false;
            SerializableContracts contracts = new SerializableContracts();
            //repository.EnableDynamicProxies = false;
            //repository.EnableLazyLoading = false;
            foreach (int id in listOfContractIds)
            {
                oeModels.Contract contract = repository.FindFullContract(id);
                contracts.Add(contract);
            }
            //serialize contract
            //write xml to file
            SerializeContentDataContract(File.Create(string.Format("{0}{1}", filePath, ""))
                , contracts, contracts.GetType());
            isSuccessful = true;
            return isSuccessful;
        }

        [TestMethod]
        public void CreateTestData()
        {
            string TestDataPath = ConfigurationManager.AppSettings["TestDataPath"];
            if (!string.IsNullOrEmpty(TestDataPath))
            {
                string filePath = "TestData.xml";
                if (!Directory.Exists(TestDataPath))
                {
                    Directory.CreateDirectory(TestDataPath);
                }
                List<int> completedContractIds = new List<int>() { 1086/*,1087,1089,1090,1091,1092,
                                                1093,1094,1095,1096,1097,1098,1101,1102,1103,1104*/};

                if (this.GenerateTestDataThroughTestHarness(completedContractIds, Path.Combine(TestDataPath, filePath)))
                {
                    //do something
                }
                else
                {
                    //figure out what to do if fails
                }
            }
            else
            {
                throw new KeyNotFoundException("Missing key TestDataPath in the application configuration.");
            }
        }


        private LibertyPower.Business.CustomerAcquisition.OnlineEnrollment.Domain.Models.OnlineEnrollmentContext db = new oeDomain.OnlineEnrollment.Domain.Models.OnlineEnrollmentContext();
        [TestMethod]
        [DeploymentItem(@"Resources\TestData.xml", "Resources")]
        [DeploymentItem(@"Resources\TestResult.xslt", "Resources")]
        public void ContractAPI_Returns_ContractDocument()
        {
            //SETUP TEST

            Console.WriteLine("Starting Test...");
            string TestDataPath = ConfigurationManager.AppSettings["TestDataPath"];
            if (!string.IsNullOrEmpty(TestDataPath))
            {
                conversion.CRMConversionHelper helper = new conversion.CRMConversionHelper();
                DataContractSerializer serializer = new DataContractSerializer
                    (typeof(SerializableContracts), new DataContractSerializerSettings()
                    {
                        PreserveObjectReferences = true,
                        MaxItemsInObjectGraph = Int32.MaxValue,
                        /*,
                        KnownTypes = new List<Type>() { typeof(oeModels.Contract) }*/
                    });


                DateTime priceDate = DateTime.Parse(ConfigurationManager.AppSettings["PriceDateToUse"]);

                SerializableContracts contracts = (SerializableContracts)
                    serializer.ReadObject(File.OpenRead(Path.Combine(TestDataPath, "TestData.xml")));
                IEnumerable<DocumentTestInput> testCases = repository.SQLQuery<DocumentTestInput>("usp_TestInputListForDocumentRetrieval");

                int testCasesToRun;
                if (ConfigurationManager.AppSettings["TestCasesToRun"] != null &&
                    Int32.TryParse(ConfigurationManager.AppSettings["TestCasesToRun"], out testCasesToRun))
                {
                    if (testCasesToRun <= testCases.Count())
                        testCases = testCases.Take(testCasesToRun);

                }
                //foreach (oeModels.Contract contract in contracts)


                //DocumentTestRun testRun = new DocumentTestRun(@"C:\TestResults");
                //documentTestRun = new DocumentTestRun(ConfigurationManager.AppSettings["TestResultsPath"]);
                
                documentTestRun.TestStart = DateTime.Now;
                testCases.ToList().ForEach(item =>
                {
                    documentTestRun.Iterations.Add(new TestIteration() { Input = item });
                });

                foreach (TestIteration tempIteration in documentTestRun.Iterations)
                {
                    tempIteration.IterationStart = DateTime.Now;
                    DocumentTestInput tempInput = tempIteration.Input;
                    //OnlineEnrollment.Integration.Properties.Resources.TestResult
                    //Setup continued
                    api.Contract cContract = null;
                    api.Customer customer = null;

                    oeModels.Contract contract = contracts.First();
                    contract.Accounts.FirstOrDefault().AccountType.AccountType1 = tempInput.AccountType;
                    contract.Accounts.FirstOrDefault().AccountType.ID = tempInput.AccountTypeID;
                    contract.SalesChannelID = tempInput.ChannelID;
                    contract.Accounts.FirstOrDefault().Utility.Market.MarketCode = tempInput.MarketCode;
                    contract.Accounts.FirstOrDefault().Utility.Market.MarketID = tempInput.MarketID;
                    contract.ContractRate.Price.ProductBrandID = (int?)tempInput.ProductBrandID ?? 0;
                    contract.ContractRate.Price.ProductBrand.Name = tempInput.ProductName;
                    contract.Accounts.FirstOrDefault().Utility.UtilityCode = tempInput.UtilityCode;
                    contract.Accounts.FirstOrDefault().Utility.UtilityID = tempInput.UtilityID;
                    contract.Customer.CustomerPreference.LanguageID = tempInput.LanguageID > 0 ? tempInput.LanguageID : 0;
                    var price = db.Prices.First();

                    tempInput.FileExtension = "PDF";

                    contract.ContractRate.PriceID = price.PriceID;
                    //Manipulate contract data here
                    //getPriceId to use
                    TestingService.CRMTestingClient testClient = new TestingService.CRMTestingClient();
                    testClient.InnerChannel.OperationTimeout = TimeSpan.FromMinutes(5);
                    //DocumentTestInput tempInput = filtered.First();
                    //This willl work once deployed to DevOrdersAPI.Might not work if the service is runnign locally.
                    Int64 priceIdToUse = testClient.GetValidPriceIdForTesting
                        (tempInput.ChannelID, priceDate, tempInput.MarketID,
                        tempInput.UtilityID, tempInput.AccountTypeID, tempInput.ProductBrandID);

                    tempInput.PriceIdToUse = priceIdToUse;

                    cContract = helper.OnlineEnrollmentContractToCRMContract(contract); //this.OnlineEnrollmentContractToCRMContract(contract);
                    customer = helper.OnlineEnrollmentCustomerToCRMCustomer(contract); //this.OnlineEnrollmentCustomerToCRMCustomer(contract);

                    //Add logic to populate other details.
                    cContract.AccountContracts.ForEach(ac =>
                    {
                        ac.AccountContractRates.ForEach(acr =>
                        {
                            acr.PriceId = priceIdToUse;

                        });
                    });


                    byte[] byteData = new byte[0];
                    dSVC.Result result = new dSVC.Result();


                    //ACTUAL SYSTEM UNDER TEST (SUT)
                    Console.WriteLine("Running Test... for contract {0} using Price Id {1}", contract.Number, priceIdToUse);
                    try
                    {
                        using (dSVC.DocumentServiceClient client = new dSVC.DocumentServiceClient())
                        {
                            dSVC.WSContractDetails wsContractDetails = new dSVC.WSContractDetails()
                            {
                                ContractDetails = cContract,
                                CustomerDetails = customer
                            };
                            client.InnerChannel.OperationTimeout = TimeSpan.FromMinutes(25.0);
                            result = client.GenerateContractDocuments(wsContractDetails, 1, true, true);
                            //bool isWorking = client.TestDBHeartBeat();
                        }
                    }
                    catch
                    {
                        ////TODO: Figure out what if anything we need to do here...
                    }
                    finally
                    {
                        DocumentTestOutput output = new DocumentTestOutput();
                        //Assert.IsTrue(result.IsSuccessful);
                        //Assert.IsNotNull(result.Value);
                        if (result.Value != null && result.IsSuccessful)
                        {
                            byteData = (byte[])result.Value;
                            string generatedDocPath = string.Format("{0}-{1}-{2}-{3}-{4}.{5}", tempInput.MarketCode, tempInput.ProductName,
                                tempInput.UtilityCode, tempInput.AccountType, tempInput.Language, tempInput.FileExtension);

                            CreateFile(byteData, Path.Combine(documentTestRun.OutputFileDir, generatedDocPath));
                            //TODO: write file out to directory here
                            output.FileName = generatedDocPath;
                            output.FullFilePath = Path.Combine(documentTestRun.OutputFileDir, generatedDocPath);
                        }




                        output.IsSuccessful = result.IsSuccessful;

                        /******************************************************/
                        //If Successful Test Passes with No Error
                        //If Not Successful and the Price ID is valid (found) - Test Fails with Exception String
                        //If Not Successful but the Price ID is not valid (not found) - Test Passes with applicable message
                        if (result.IsSuccessful)
                        {
                            output.ActualTestResult = "Pass";
                            output.ErrorMessage = "None";

                        }
                        else
                        {
                            if (tempInput.PriceIdToUse > 0)
                        {
                                output.ActualTestResult = "Fail";
                                output.ErrorMessage = result.ExceptionString;
                        }
                        else
                        {
                                output.ActualTestResult = "Pass";
                                output.ErrorMessage = "No Price available for this Combination";
                            }
                        }

                       


                        //if (result.IsSuccessful || (!result.IsSuccessful && tempInput.PriceIdToUse == 0))
                        //{
                        //    output.ActualTestResult = "Pass";

                        //}
                        //else
                        //{
                        //    output.ActualTestResult = "Fail";

                        //}
                        //if (result.IsSuccessful)
                        //{
                        //    output.ErrorMessage = "None";
                        //}
                        //else
                        //{
                        //    output.ErrorMessage = result.ExceptionString;
                        //}
                        /*****************************/
                        tempIteration.Output = output;

                    }

                    tempIteration.IterationEnd = DateTime.Now;
                    Console.WriteLine("Iteration completed in {0} Seconds.", (tempIteration.IterationEnd - tempIteration.IterationStart).TotalSeconds);

                }
                //Dont move this line from here to somewhere else.
                documentTestRun.TestEnd = DateTime.Now;


                string xmlFilePath = Path.Combine(documentTestRun.OutputFileDir, "TestResults.XML");
                string htmlFilePath = Path.Combine(documentTestRun.OutputFileDir, "TestResults.HTML");
                SerializeContentXML(File.Create(xmlFilePath), documentTestRun, typeof(DocumentTestRun));
                System.Xml.Xsl.XslCompiledTransform xslcompiled = new System.Xml.Xsl.XslCompiledTransform();

                //System.Xml.XmlReader reader = System.Xml.XmlReader.Create(new MemoryStream(OnlineEnrollment.Integration.Properties.Resources.TestResult));
                xslcompiled.Load(Path.Combine(documentTestRun.ApplicationOutputDir, @"Resources\TestResult.xslt"));
                xslcompiled.Transform(xmlFilePath, htmlFilePath);

                //ASSERT and VERIFY - OUTPUT RESULTS
                //Output results of TestRun Here....
            }
            else
            {
                throw new KeyNotFoundException("Missing key TestDataPath in the application configuration.");
            }
            Console.WriteLine("Test completed..");
        }


        private void CreateFile(byte[] byteData, string path)
        {
            //Create new file and open it for read and write, if the file exists overwrite it.
            FileStream fs = new FileStream(path, FileMode.Create);
            //Read block of bytes from stream into the byte array
            fs.Write(byteData, 0, byteData.Length);
            //Close the File Stream
            fs.Close();
        }
        private crm.Contract OnlineEnrollmentContractToCRMContract(oeDomain.OnlineEnrollment.Domain.Models.Contract contract)
        {
            crm.Contract newContract = new crm.Contract();
            //newContract.ContractId = contract.ContractID;
            newContract.Number = (string.IsNullOrEmpty(contract.Number)) ? string.Empty : contract.Number;

            newContract.ContractDealType = crm.Enums.ContractDealType.New;

            newContract.ContractType = crm.Enums.ContractType.ONLINE;

            newContract.ContractTemplate = crm.Enums.ContractTemplate.Normal;
            //aTODO: TemplateVersionID returned from service?
            newContract.ContractTemplateVersionId = contract.ContractTemplateID;

            newContract.SalesChannelId = contract.SalesChannelID;
            newContract.SalesManagerId = contract.SalesChannel.ChannelDevelopmentManagerID;

            newContract.SalesRep = contract.SalesChannel.ChannelName;//contract.SalesRep;

            newContract.SignedDate = contract.SignedDate;

            newContract.StartDate = contract.StartDate;
            newContract.EndDate = contract.EndDate;

            newContract.AccountContracts = new List<crm.AccountContract>();

            foreach (oeDomain.OnlineEnrollment.Domain.Models.Account account in contract.Accounts)
            {
                crm.AccountContract newAccountContract = ConvertAccountToCRMAccount(contract, account);
                newContract.AccountContracts.Add(newAccountContract);
            }

            newContract.DigitalSignature = contract.DigitalSignature;
            return newContract;
        }

        private static crm.AccountContract ConvertAccountToCRMAccount(oeDomain.OnlineEnrollment.Domain.Models.Contract contract, oeDomain.OnlineEnrollment.Domain.Models.Account account)
        {

            crm.Address newBillingAddress = new crm.Address();
            newBillingAddress.City = account.Address.City;
            newBillingAddress.State = account.Address.State;
            newBillingAddress.Street = account.Address.Address1;
            newBillingAddress.Suite = account.Address.Address2;
            newBillingAddress.Zip = account.Address.Zip;

            crm.Address newServiceAddress = new crm.Address();
            newServiceAddress.City = account.Address1.City;
            newServiceAddress.State = account.Address1.State;
            newServiceAddress.Street = account.Address1.Address1;
            newServiceAddress.Suite = account.Address1.Address2;
            newServiceAddress.Zip = account.Address1.Zip;

            crm.Contact newBillingContact = new crm.Contact();
            newBillingContact.Birthday = new DateTime(1900, 1, 1);
            newBillingContact.Email = contract.Customer.Contact.Email;
            newBillingContact.Fax = contract.Customer.Contact.Fax;
            newBillingContact.FirstName = contract.Customer.Contact.FirstName;
            newBillingContact.LastName = contract.Customer.Contact.LastName;
            newBillingContact.Phone = contract.Customer.Contact.Phone;
            newBillingContact.Title = (String.IsNullOrEmpty(contract.Customer.Contact.Title) ? "_" : contract.Customer.Contact.Title);


            crm.Account newAccount = new crm.Account();
            //newAccount.AccountId = account.AccountID;
            newAccount.AccountName = contract.Customer.CustomerName;
            newAccount.AccountIdLegacy = account.AccountID.ToString();
            newAccount.AccountNumber = account.AccountNumber;
            newAccount.Zone = account.Zone;
            newAccount.ServiceRateClass = account.ServiceRateClass;

            //newAccount.AccountTypeId = account.AccountTypeID;
            switch (account.AccountType.AccountType1)
            {
                case "SMB":
                    newAccount.AccountType = crm.Enums.AccountType.SMB;
                    break;
                case "LCI":
                    newAccount.AccountType = crm.Enums.AccountType.LCI;
                    break;
                case "RES":
                    newAccount.AccountType = crm.Enums.AccountType.RES;
                    break;
                case "SOHO":
                    newAccount.AccountType = crm.Enums.AccountType.SOHO;
                    break;
            }

            newAccount.BillingAddress = newBillingAddress;
            newAccount.BillingContact = newBillingContact;

            switch (account.Utility.BillingType)
            {
                case "BR":
                    newAccount.BillingType = crm.Enums.BillingType.BR;
                    break;
                case "DUAL":
                    newAccount.BillingType = crm.Enums.BillingType.DUAL;
                    break;
                case "SC":
                    newAccount.BillingType = crm.Enums.BillingType.SC;
                    break;
                case "RR":
                default:
                    newAccount.BillingType = crm.Enums.BillingType.RR;
                    break;
            }

            newAccount.Details = new crm.AccountDetail() { EnrollmentType = crm.Enums.EnrollmentType.Standard };
            newAccount.PorOption = account.PorOption;
            newAccount.Origin = "WEB";

            newAccount.ServiceAddress = newServiceAddress;
            switch (account.TaxStatusID)
            {
                case 1:
                    newAccount.TaxStatus = crm.Enums.TaxStatus.Full;
                    break;
                case 2:
                    newAccount.TaxStatus = crm.Enums.TaxStatus.Exempt;
                    break;
                case 3:
                    newAccount.TaxStatus = crm.Enums.TaxStatus.NotFull;
                    break;
                default:
                    newAccount.TaxStatus = crm.Enums.TaxStatus.Full;
                    break;
            }
            newAccount.UtilityId = account.UtilityID;
            newAccount.RetailMktId = account.Utility.Market.MarketID;



            #region AccountContract

            crm.AccountContract newAccountContract = new crm.AccountContract();
            newAccountContract.Account = newAccount;
            newAccountContract.AccountContractCommission = new crm.AccountContractCommission();
            newAccountContract.AccountContractRates = new List<crm.AccountContractRate>();
            newAccountContract.RequestedStartDate = contract.StartDate;
            newAccountContract.SendEnrollmentDate = contract.StartDate.AddDays(-(account.Utility.EnrollmentLeadDays ?? 0));
            #endregion

            #region AccountContractRate

            crm.AccountContractRate accountContractRate = new crm.AccountContractRate();
            LibertyPower.Business.CustomerAcquisition.OnlineEnrollment.Domain.Models.OnlineEnrollmentContext db = new oeDomain.OnlineEnrollment.Domain.Models.OnlineEnrollmentContext();
            var price = db.Prices.Where(w => w.PriceID == contract.ContractRate.PriceID);
            if (price == null || price.Count() == 0)
            {
                throw new ApplicationException("Could not retrieve price from Online Enrollment. Contract " + contract.Number);
            }

            oeDomain.OnlineEnrollment.Domain.Models.Price priceObj = price.First();

            accountContractRate.PriceId = priceObj.LPPriceID; //account.PriceID;
            accountContractRate.Rate = contract.ContractRate.Rate;

            accountContractRate.RateEnd = contract.ContractRate.RateEnd;
            accountContractRate.RateStart = contract.ContractRate.RateStart;
            accountContractRate.Term = contract.ContractRate.Term;
            accountContractRate.TransferRate = Convert.ToDouble(contract.ContractRate.TransferRate);
            newAccountContract.AccountContractRates.Add(accountContractRate);

            #endregion

            #region AccountInfo
            crm.AccountInfo accountInfo = new crm.AccountInfo();
            //accountInfo.BillingAccount = account.BillingAccount;
            //accountInfo.NameKey = account.NameKey;
            newAccount.AccountInfo = accountInfo;
            newAccount.MeterNumbers = new List<string>();
            newAccount.AccountInfo.UtilityCode = account.Utility.UtilityCode;

            #endregion

            return newAccountContract;
        }

        private crm.Customer OnlineEnrollmentCustomerToCRMCustomer(oeDomain.OnlineEnrollment.Domain.Models.Contract contract)
        {
            crm.Customer newCustomer = new crm.Customer();


            crm.Contact newCustomerContact = new crm.Contact();
            newCustomerContact.Birthday = (contract.Customer.Contact.Birthdate != null) ? contract.Customer.Contact.Birthdate.Value : new DateTime(1900, 1, 1);

            newCustomerContact.Email = contract.Customer.Contact.Email;
            newCustomerContact.Fax = contract.Customer.Contact.Fax;
            newCustomerContact.FirstName = contract.Customer.Contact.FirstName;
            newCustomerContact.LastName = contract.Customer.Contact.LastName;
            newCustomerContact.Phone = contract.Customer.Contact.Phone;
            newCustomerContact.Title = (String.IsNullOrEmpty(contract.Customer.Contact.Title) ? "_" : contract.Customer.Contact.Title);

            crm.Address newCustomerAddress = new crm.Address();
            newCustomerAddress.City = contract.Customer.Address.City;
            newCustomerAddress.State = contract.Customer.Address.State;
            newCustomerAddress.Street = contract.Customer.Address.Address1;
            newCustomerAddress.Suite = contract.Customer.Address.Address2;
            newCustomerAddress.Zip = contract.Customer.Address.Zip;

            newCustomer.BusinessActivityId = 1; // NONE 
            newCustomer.BusinessTypeId = 1; // NONE

            newCustomer.BusinessActivityId = 1; // NONE 
            newCustomer.BusinessTypeId = contract.Customer.BusinessTypeID;

            newCustomer.Contact = newCustomerContact;
            newCustomer.CustomerAddress = newCustomerAddress;
            newCustomer.CustomerName = contract.Customer.CustomerName;
            newCustomer.OwnerName = contract.Customer.CustomerName;

            newCustomer.TaxId = contract.Customer.TaxId;
            newCustomer.Duns = contract.Customer.Duns;
            newCustomer.EmployerId = contract.Customer.EmployerId;

            crm.CustomerPreference preference = new crm.CustomerPreference();
            preference.LanguageId = (contract.Customer.CustomerPreference.LanguageID == 0 ? 1 : contract.Customer.CustomerPreference.LanguageID);
            preference.OptOutSpecialOffers = contract.Customer.CustomerPreference.OptOutSpecialOffers;
            preference.IsGoGreen = contract.Customer.CustomerPreference.IsGoGreen;

            newCustomer.Preferences = preference;

            oeDomain.OnlineEnrollment.Domain.Models.Account account = contract.Accounts.First();
            if (account.AccountType.AccountType1 == "RES" && String.IsNullOrEmpty(newCustomer.SsnClear))
            {
                newCustomer.SsnClear = "111111111";
            }

            return newCustomer;
        }

        private IEnumerable<Type> KnownTypeList()
        {
            List<Type> knownTypes = new List<Type>();
            knownTypes.Add(typeof(oeModels.AccountType));
            knownTypes.Add(typeof(oeModels.Account));
            knownTypes.Add(typeof(oeModels.Address));
            knownTypes.Add(typeof(oeModels.BusinessActivity));
            knownTypes.Add(typeof(oeModels.BusinessType));
            knownTypes.Add(typeof(oeModels.Contact));
            knownTypes.Add(typeof(oeModels.Contract));
            knownTypes.Add(typeof(oeModels.ContractDocument));
            knownTypes.Add(typeof(oeModels.ContractRate));
            knownTypes.Add(typeof(oeModels.Customer));
            knownTypes.Add(typeof(oeModels.CustomerPreference));
            knownTypes.Add(typeof(oeModels.DailyPricingPriceTier));
            knownTypes.Add(typeof(oeModels.Email));
            knownTypes.Add(typeof(oeModels.EmailDistributionList));
            knownTypes.Add(typeof(oeModels.EmailGroup));
            knownTypes.Add(typeof(oeModels.EmailType));
            knownTypes.Add(typeof(oeModels.Language));
            knownTypes.Add(typeof(oeModels.LegalContent));
            knownTypes.Add(typeof(oeModels.Market));
            knownTypes.Add(typeof(oeModels.Price));
            knownTypes.Add(typeof(oeModels.ProductBrand));
            knownTypes.Add(typeof(oeModels.ProductBrandPrice));
            knownTypes.Add(typeof(oeModels.RateList));
            knownTypes.Add(typeof(oeModels.SalesChannel));
            knownTypes.Add(typeof(oeModels.Sequence));
            knownTypes.Add(typeof(oeModels.SyncTracker));
            knownTypes.Add(typeof(oeModels.TaxStatus));
            knownTypes.Add(typeof(oeModels.Utility));
            knownTypes.Add(typeof(oeModels.UtilityLite));
            knownTypes.Add(typeof(oeModels.UtilityZone));
            knownTypes.Add(typeof(oeModels.Zipcode));
            knownTypes.Add(typeof(oeModels.ZipToUtility));
            knownTypes.Add(typeof(oeModels.Zone));

            return knownTypes;
        }

        [TestMethod]
        public void TestSimpleEchoWebservice()
        {
            using (api.OrderEntryClient client = new api.OrderEntryClient())
            {

                client.InnerChannel.OperationTimeout = TimeSpan.FromMinutes(25.0);
                string asd = client.Echo("asdasfsdf");
            }
        }

        //[TestMethod]
        //public void TestGetMarkets()
        //{
        //    using (CommonServicesAPI.CommonServicesClient client = new ContractAPI.ContractSubmissionClient())
        //    {

        //        client.InnerChannel.OperationTimeout = TimeSpan.FromMinutes( 25.0 );
        //        string asd = client.Echo( "asdasfsdf" );
        //    }
        //}


    }
}
