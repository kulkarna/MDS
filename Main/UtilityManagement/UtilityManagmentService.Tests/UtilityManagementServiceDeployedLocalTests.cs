using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Collections.Specialized;

namespace UtilityManagmentService.Tests
{
    //public class UtilityData
    //{
    //    public int LegacyUtilityId { get; set; }
    //    public string UtilityCode { get; set; }
    //    public Guid UtilityId { get; set; }
    //}

    [TestClass]
    public class UtilityManagementServiceDeployedLocalTests
    {
        //[TestMethod]
        //public void GetHistoricalUsageRequestModes_Util22_Basic_Test()
        //{
        //    DeployedLocalService.UtilityManagementServiceClient client = new DeployedLocalService.UtilityManagementServiceClient();

        //    UtilityManagementServiceData.GetHistoricalUsageRequestModesRequest request = new UtilityManagementServiceData.GetHistoricalUsageRequestModesRequest()
        //    {
        //        LegacyUtilityId = 22,
        //        MessageId = null,
        //        RequestModeEnrollmentTypeId = new Guid("390712c2-aaf9-4b96-96b8-cd12fa33eef1"),
        //        UtilityCode = null,
        //        UtilityId = Guid.NewGuid() //Guid.Empty
        //    };
        //    var result = client.GetHistoricalUsageRequestModes(request);
        //    string s = string.Empty;
        //}

        [TestMethod]
        public void GetHistoricalUsageRequestModes_IterativeRandomLoop_Test()
        {
            DataForTest dataForTest = GenerateData();
            using (var fileStream = System.IO.File.OpenWrite(string.Format(@"C:\temp\HistoricalUsageRequestModes_{0}_{1}_{2}_{3}_{4}_{5}.txt", DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, DateTime.Now.Hour, DateTime.Now.Minute, Guid.NewGuid().ToString())))
            {
                DeployedLocalService.UtilityManagementServiceClient client1 = new DeployedLocalService.UtilityManagementServiceClient();
                Random random = new Random(DateTime.Now.Millisecond);
                for (int i = 0; i < 30; i++)
                {
                    for (int j = 0; j < 3; j++)
                    {
                        int utilityRandomIndex = random.Next(dataForTest.NumberOfUtilitiesInList);
                        int requestModeEnrollmentTypeIndex = random.Next(dataForTest.NumberOfRequestModeEnrollmentTypes);
                        UtilityManagementServiceData.GetHistoricalUsageRequestModesRequest request = new UtilityManagementServiceData.GetHistoricalUsageRequestModesRequest()
                        {
                            RequestModeEnrollmentTypeId = dataForTest.ListOfEnrollmentTypes[requestModeEnrollmentTypeIndex]
                        };
                        switch (j)
                        {
                            case 0:
                                request.LegacyUtilityId = dataForTest.ListOfUtilities[utilityRandomIndex].LegacyUtilityId;
                                break;
                            case 1:
                                request.UtilityId = dataForTest.ListOfUtilities[utilityRandomIndex].UtilityId;
                                break;
                            case 2:
                                request.UtilityCode = dataForTest.ListOfUtilities[utilityRandomIndex].UtilityCode;
                                break;
                        }
                        if (!(j == 0 && request.LegacyUtilityId == 0) && !(j == 2 && request.UtilityCode.Contains("&")))
                        {
                            System.Threading.Thread.Sleep(50);
                            var response = client1.GetHistoricalUsageRequestModes(request);

                            byte[] info = new UTF8Encoding(true).GetBytes(string.Format("Request:[UtilityCode:{0};LegacyUtilityId:{1};UtilityId:{2};RequestModeEnrollmentTypeId:{3}];", request.UtilityCode, request.LegacyUtilityId, request.UtilityId, request.RequestModeEnrollmentTypeId));
                            fileStream.Write(info, 0, info.Length);

                            StringBuilder temp = new StringBuilder();
                            temp.AppendLine();
                            temp.AppendFormat("Response[MessageId:{0};IsSuccess:{1};Code:{2};Message:{3}(", response.MessageId, response.IsSuccess, response.Code, response.Message);
                            foreach (var itema in response.HistoricalUsageRequestModeList)
                            {
                                temp.AppendFormat("Id:{0};UtilityCode:{1};UtilityId:{2};UtilityLegacyId:{3};EnrollmentType:{4};RequestMode:{5};Address:{6};EmailTemplate:{7};Instructions:{8};IsLoaRequired:{9};LibertyPowerSlaResponse:{10};UtilitySlaResponse:{11}  ", itema.Id, itema.UtilityCode, itema.UtilityId, itema.UtilityLegacyId, itema.EnrollmentType.ToString(), itema.RequestMode, itema.Address, itema.EmailTemplate, itema.Instructions, itema.IsLoaRequired, itema.LibertyPowerSlaResponse, itema.UtilitySlaResponse);
                            }
                            temp.AppendFormat(")]");
                            temp.AppendLine();
                            info = new UTF8Encoding(true).GetBytes(temp.ToString());
                            fileStream.Write(info, 0, info.Length);
                            Assert.IsNotNull(response);
                            Assert.IsTrue(response.IsSuccess);

                            DataAccessLayerEntityFramework.Lp_UtilityManagementEntities db = new DataAccessLayerEntityFramework.Lp_UtilityManagementEntities();
                            Guid utilityCompanyId = dataForTest.ListOfUtilities[utilityRandomIndex].UtilityId;
                            Guid requestModeEnrollmentTypeId = dataForTest.ListOfEnrollmentTypes[requestModeEnrollmentTypeIndex];
                            var item = db.RequestModeHistoricalUsages.Where(a => a.UtilityCompanyId == utilityCompanyId && a.RequestModeEnrollmentTypeId == requestModeEnrollmentTypeId).ToList<DataAccessLayerEntityFramework.RequestModeHistoricalUsage>();
                            Assert.IsNotNull(item);
                            Assert.AreEqual(item.Count, response.HistoricalUsageRequestModeList.Count());
                            if (item.Count > 0)
                            {

                                string address = string.Empty;
                                string emailTemplate = string.Empty;

                                if (item[0].RequestModeType.Name.ToLower() == "e-mail" || item[0].RequestModeType.Name.ToLower() == "website")
                                {
                                    address = item[0].AddressForPreEnrollment;
                                    if (item[0].RequestModeType.Name.ToLower() == "e-mail")
                                        emailTemplate = item[0].EmailTemplate;
                                }

                                Assert.AreEqual(address, response.HistoricalUsageRequestModeList[0].Address);
                                Assert.AreEqual(emailTemplate, response.HistoricalUsageRequestModeList[0].EmailTemplate);
                                Assert.AreEqual(item[0].Id, response.HistoricalUsageRequestModeList[0].Id);
                                Assert.AreEqual(item[0].Instructions, response.HistoricalUsageRequestModeList[0].Instructions);
                                Assert.AreEqual(item[0].LibertyPowersSlaFollowUpHistoricalUsageResponseInDays, response.HistoricalUsageRequestModeList[0].LibertyPowerSlaResponse);
                                Assert.AreEqual(item[0].RequestModeType.Name, response.HistoricalUsageRequestModeList[0].RequestMode);
                                Assert.AreEqual(item[0].UtilityCompanyId, response.HistoricalUsageRequestModeList[0].UtilityId);
                                Assert.AreEqual(item[0].UtilitysSlaHistoricalUsageResponseInDays, response.HistoricalUsageRequestModeList[0].UtilitySlaResponse);
                                Assert.AreEqual(item[0].IsLoaRequired, response.HistoricalUsageRequestModeList[0].IsLoaRequired);
                            }
                        }
                    }
                }
                fileStream.Flush();
            }
        }

        [TestMethod]
        public void GetIcapRequestModes_Util22_Basic_Test()
        {
            DeployedLocalService.UtilityManagementServiceClient client = new DeployedLocalService.UtilityManagementServiceClient();

            UtilityManagementServiceData.GetIcapRequestModesRequest request = new UtilityManagementServiceData.GetIcapRequestModesRequest()
            {
                LegacyUtilityId = 22,
                MessageId = null,
                RequestModeEnrollmentTypeId = new Guid("390712c2-aaf9-4b96-96b8-cd12fa33eef1"),
                UtilityCode = null,
                UtilityId = Guid.Empty
            };
            var result = client.GetIcapRequestModes(request);
            string s = string.Empty;
        }

        [TestMethod]
        public void GetIcapRequestModes_IterativeRandomLoop_Test()
        {
            DataForTest dataForTest = GenerateData();
            using (var fileStream = System.IO.File.OpenWrite(string.Format(@"C:\temp\ICapRequestModes_{0}_{1}_{2}_{3}_{4}_{5}.txt", DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, DateTime.Now.Hour, DateTime.Now.Minute, Guid.NewGuid().ToString())))
            {

                DeployedLocalService.UtilityManagementServiceClient client1 = new DeployedLocalService.UtilityManagementServiceClient();

                
                
                Random random = new Random(DateTime.Now.Millisecond);
                for (int i = 0; i < 30; i++)
                {
                    for (int j = 0; j < 3; j++)
                    {
                        int utilityRandomIndex = random.Next(dataForTest.NumberOfUtilitiesInList);
                        int requestModeEnrollmentTypeIndex = random.Next(dataForTest.NumberOfRequestModeEnrollmentTypes);
                        UtilityManagementServiceData.GetIcapRequestModesRequest request = new UtilityManagementServiceData.GetIcapRequestModesRequest()
                        {
                            RequestModeEnrollmentTypeId = dataForTest.ListOfEnrollmentTypes[requestModeEnrollmentTypeIndex]
                        };
                        switch (j)
                        {
                            case 0:
                                request.LegacyUtilityId = dataForTest.ListOfUtilities[utilityRandomIndex].LegacyUtilityId;
                                break;
                            case 1:
                                request.UtilityId = dataForTest.ListOfUtilities[utilityRandomIndex].UtilityId;
                                break;
                            case 2:
                                request.UtilityCode = dataForTest.ListOfUtilities[utilityRandomIndex].UtilityCode;
                                break;
                        }
                        if (!(j == 0 && request.LegacyUtilityId == 0) && !(j == 2 && request.UtilityCode.Contains("&")))
                        {
                            System.Threading.Thread.Sleep(50);
                            var response = client1.GetIcapRequestModes(request);

                            byte[] info = new UTF8Encoding(true).GetBytes(string.Format("Request:[UtilityCode:{0};LegacyUtilityId:{1};UtilityId:{2};RequestModeEnrollmentTypeId:{3}];", request.UtilityCode, request.LegacyUtilityId, request.UtilityId, request.RequestModeEnrollmentTypeId));
                            fileStream.Write(info, 0, info.Length);

                            StringBuilder temp = new StringBuilder();
                            temp.AppendLine();
                            temp.AppendFormat("Response[MessageId:{0};IsSuccess:{1};Code:{2};Message:{3}(", response.MessageId, response.IsSuccess, response.Code, response.Message);
                            foreach (var itema in response.IcapRequestModeList)
                            {
                                temp.AppendFormat("Id:{0};UtilityCode:{1};UtilityId:{2};UtilityLegacyId:{3};EnrollmentType:{4};RequestMode:{5};Address:{6};EmailTemplate:{7};Instructions:{8};IsLoaRequired:{9};LibertyPowerSlaResponse:{10};UtilitySlaResponse:{11}  ", itema.Id, itema.UtilityCode, itema.UtilityId, itema.UtilityLegacyId, itema.EnrollmentType.ToString(), itema.RequestMode, itema.Address, itema.EmailTemplate, itema.Instructions, itema.IsLoaRequired, itema.LibertyPowerSlaResponse, itema.UtilitySlaResponse);
                            }
                            temp.AppendFormat(")]");
                            temp.AppendLine();
                            info = new UTF8Encoding(true).GetBytes(temp.ToString());
                            fileStream.Write(info, 0, info.Length);
                            
                            
                            Assert.IsNotNull(response);
                            Assert.IsTrue(response.IsSuccess);

                            DataAccessLayerEntityFramework.Lp_UtilityManagementEntities db = new DataAccessLayerEntityFramework.Lp_UtilityManagementEntities();
                            Guid utilityCompanyId = dataForTest.ListOfUtilities[utilityRandomIndex].UtilityId;
                            Guid requestModeEnrollmentTypeId = dataForTest.ListOfEnrollmentTypes[requestModeEnrollmentTypeIndex];
                            var item = db.RequestModeIcaps.Where(a => a.UtilityCompanyId == utilityCompanyId && a.RequestModeEnrollmentTypeId == requestModeEnrollmentTypeId).ToList<DataAccessLayerEntityFramework.RequestModeIcap>();
                            Assert.IsNotNull(item);
                            Assert.AreEqual(item.Count, response.IcapRequestModeList.Count());
                            if (item.Count > 0)
                            {

                                string address = string.Empty;
                                string emailTemplate = string.Empty;

                                if (item[0].RequestModeType.Name.ToLower() == "e-mail" || item[0].RequestModeType.Name.ToLower() == "website")
                                {
                                    address = item[0].AddressForPreEnrollment;
                                    if (item[0].RequestModeType.Name.ToLower() == "e-mail")
                                        emailTemplate = item[0].EmailTemplate;
                                }

                                Assert.AreEqual(address, response.IcapRequestModeList[0].Address);
                                Assert.AreEqual(emailTemplate, response.IcapRequestModeList[0].EmailTemplate);
                                Assert.AreEqual(item[0].Id, response.IcapRequestModeList[0].Id);
                                Assert.AreEqual(item[0].Instructions, response.IcapRequestModeList[0].Instructions);
                                Assert.AreEqual(item[0].LibertyPowersSlaFollowUpIcapResponseInDays, response.IcapRequestModeList[0].LibertyPowerSlaResponse);
                                Assert.AreEqual(item[0].RequestModeType.Name, response.IcapRequestModeList[0].RequestMode);
                                Assert.AreEqual(item[0].UtilityCompanyId, response.IcapRequestModeList[0].UtilityId);
                                Assert.AreEqual(item[0].UtilitysSlaIcapResponseInDays, response.IcapRequestModeList[0].UtilitySlaResponse);
                                Assert.AreEqual(item[0].IsLoaRequired, response.IcapRequestModeList[0].IsLoaRequired);
                            }
                        }
                    }
                }
            }
        }

        [TestMethod]
        public void GetIdrRequestModes_Util22_Basic_Test()
        {
            DeployedLocalService.UtilityManagementServiceClient client = new DeployedLocalService.UtilityManagementServiceClient();

            UtilityManagementServiceData.GetIdrRequestModesRequest request = new UtilityManagementServiceData.GetIdrRequestModesRequest()
            {
                LegacyUtilityId = 22,
                MessageId = null,
                RequestModeEnrollmentTypeId = new Guid("390712c2-aaf9-4b96-96b8-cd12fa33eef1"),
                UtilityCode = null,
                UtilityId = Guid.Empty
            };
            var result = client.GetIdrRequestModes(request);
            string s = string.Empty;
        }

        [TestMethod]
        public void GetIdrRequestModes_IterativeRandomLoop_Test()
        {
            DataForTest dataForTest = GenerateData();

            DeployedLocalService.UtilityManagementServiceClient client1 = new DeployedLocalService.UtilityManagementServiceClient();
            Random random = new Random(DateTime.Now.Millisecond);
            for (int i = 0; i < 30; i++)
            {
                for (int j = 0; j < 3; j++)
                {
                    int utilityRandomIndex = random.Next(dataForTest.NumberOfUtilitiesInList);
                    int requestModeEnrollmentTypeIndex = random.Next(dataForTest.NumberOfRequestModeEnrollmentTypes);
                    UtilityManagementServiceData.GetIdrRequestModesRequest request = new UtilityManagementServiceData.GetIdrRequestModesRequest()
                    {
                        RequestModeEnrollmentTypeId = dataForTest.ListOfEnrollmentTypes[requestModeEnrollmentTypeIndex]
                    };
                    switch (j)
                    {
                        case 0:
                            request.LegacyUtilityId = dataForTest.ListOfUtilities[utilityRandomIndex].LegacyUtilityId;
                            break;
                        case 1:
                            request.UtilityId = dataForTest.ListOfUtilities[utilityRandomIndex].UtilityId;
                            break;
                        case 2:
                            request.UtilityCode = dataForTest.ListOfUtilities[utilityRandomIndex].UtilityCode;
                            break;
                    }
                    if (!(j == 0 && request.LegacyUtilityId == 0) && !(j == 2 && request.UtilityCode.Contains("&")))
                    {
                        System.Threading.Thread.Sleep(50);
                        var response = client1.GetIdrRequestModes(request);
                        Assert.IsNotNull(response);
                        Assert.IsTrue(response.IsSuccess);

                        DataAccessLayerEntityFramework.Lp_UtilityManagementEntities db = new DataAccessLayerEntityFramework.Lp_UtilityManagementEntities();
                        Guid utilityCompanyId = dataForTest.ListOfUtilities[utilityRandomIndex].UtilityId;
                        Guid requestModeEnrollmentTypeId = dataForTest.ListOfEnrollmentTypes[requestModeEnrollmentTypeIndex];
                        var item = db.RequestModeIdrs.Where(a => a.UtilityCompanyId == utilityCompanyId && a.RequestModeEnrollmentTypeId == requestModeEnrollmentTypeId).ToList<DataAccessLayerEntityFramework.RequestModeIdr>();
                        Assert.IsNotNull(item);
                        Assert.AreEqual(item.Count, response.IdrRequestModeList.Count());
                        if (item.Count > 0)
                        {

                            string address = string.Empty;
                            string emailTemplate = string.Empty;

                            if (item[0].RequestModeType.Name.ToLower() == "e-mail" || item[0].RequestModeType.Name.ToLower() == "website")
                            {
                                address = item[0].AddressForPreEnrollment;
                                if (item[0].RequestModeType.Name.ToLower() == "e-mail")
                                    emailTemplate = item[0].EmailTemplate;
                            }

                            Assert.AreEqual(address, response.IdrRequestModeList[0].Address);
                            Assert.AreEqual(emailTemplate, response.IdrRequestModeList[0].EmailTemplate);
                            Assert.AreEqual(item[0].Id, response.IdrRequestModeList[0].Id);
                            Assert.AreEqual(item[0].Instructions, response.IdrRequestModeList[0].Instructions);
                            Assert.AreEqual(item[0].LibertyPowersSlaFollowUpIdrResponseInDays, response.IdrRequestModeList[0].LibertyPowerSlaResponse);
                            Assert.AreEqual(item[0].RequestModeType.Name, response.IdrRequestModeList[0].RequestMode);
                            Assert.AreEqual(item[0].UtilityCompanyId, response.IdrRequestModeList[0].UtilityId);
                            Assert.AreEqual(item[0].UtilitysSlaIdrResponseInDays, response.IdrRequestModeList[0].UtilitySlaResponse);
                            Assert.AreEqual(item[0].IsLoaRequired, response.IdrRequestModeList[0].IsLoaRequired);
                            Assert.AreEqual(item[0].RequestCostAccount, response.IdrRequestModeList[0].RequestCostAccount);
                        }
                    }
                }
            }
        }

        private DataForTest GenerateData()
        {
            List<Guid> listOfRequestModeEnrollmentTypes = new List<Guid>();
            List<UtilityData> listOfUtilities = new List<UtilityData>();
            string messageId = Guid.NewGuid().ToString();
            using (DeployedLocalService.UtilityManagementServiceClient client = new DeployedLocalService.UtilityManagementServiceClient())
            {
                var utilityResponse = client.GetAllUtilities(messageId);
                if (utilityResponse.IsSuccess)
                {
                    using (var fileStream = System.IO.File.OpenWrite(string.Format(@"C:\temp\UtilityList_{0}_{1}_{2}_{3}_{4}_{5}_{6}_{7}.txt", DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, DateTime.Now.Hour, DateTime.Now.Minute, DateTime.Now.Second, DateTime.Now.Millisecond, Guid.NewGuid().ToString())))
                    {
                        foreach (var utility in utilityResponse.Utilities)
                        {
                            var utilityData = new UtilityData()
                            {
                                LegacyUtilityId = utility.LegacyUtilityId,
                                UtilityCode = utility.UtilityCode,
                                UtilityId = utility.UtilityId
                            };
                            listOfUtilities.Add(utilityData);

                            StringBuilder temp = new StringBuilder();
                            temp.AppendFormat("Utility[LegacyUtilityId:{0};UtilityCode:{1};UtilityId:{2}]", utility.LegacyUtilityId, utility.UtilityCode, utility.UtilityId);
                            temp.AppendLine();
                            byte[] info = new UTF8Encoding(true).GetBytes(temp.ToString());
                            fileStream.Write(info, 0, info.Length);
                        }
                        fileStream.Flush();
                    }

                    var requestModeEnrollmentTypeResponse = client.GetAllRequestModeEnrollmentTypes(messageId);
                    if (requestModeEnrollmentTypeResponse.IsSuccess)
                    {
                        using (var fileStream = System.IO.File.OpenWrite(string.Format(@"C:\temp\RequestModeEnrollmentType_{0}_{1}_{2}_{3}_{4}_{5}_{6}_{7}.txt", DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, DateTime.Now.Hour, DateTime.Now.Minute, DateTime.Now.Second, DateTime.Now.Millisecond, Guid.NewGuid().ToString())))
                        {

                            foreach (var requestModeEnrollmentType in requestModeEnrollmentTypeResponse.RequestModeEnrollmentTypes)
                            {
                                listOfRequestModeEnrollmentTypes.Add(requestModeEnrollmentType.RequestModeEnrollmentTypeId);

                                StringBuilder temp = new StringBuilder();
                                temp.AppendFormat("RequestModeEnrollmentType[RequestModeEnrollmentTypeId:{0};Name:{1}]", requestModeEnrollmentType.RequestModeEnrollmentTypeId, requestModeEnrollmentType.Name);
                                temp.AppendLine();
                                byte[] info = new UTF8Encoding(true).GetBytes(temp.ToString());
                                fileStream.Write(info, 0, info.Length);
                            }
                            fileStream.Flush();
                        }
                    }
                }
            }

            DataForTest dataForTest = new DataForTest()
            {
                ListOfEnrollmentTypes = listOfRequestModeEnrollmentTypes,
                ListOfUtilities = listOfUtilities
            };
            return dataForTest;
        }

    }

    public class DataForTest
    {
        public List<Guid> ListOfEnrollmentTypes { get; set; }
        public List<UtilityData> ListOfUtilities { get; set; }
        public int NumberOfUtilitiesInList
        {
            get
            {
                if (ListOfUtilities == null)
                    return 0;
                return ListOfUtilities.Count;
            }
        }
        public int NumberOfRequestModeEnrollmentTypes
        {
            get
            {
                if (ListOfEnrollmentTypes == null)
                    return 0;
                return ListOfEnrollmentTypes.Count;
            }
        }

    }

}
