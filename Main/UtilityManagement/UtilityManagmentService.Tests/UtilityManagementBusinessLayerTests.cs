using DataAccessLayerEntityFramework;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Threading.Tasks;
using System.Text;
using Utilities;
using UtilityManagementBusinessLayer;
using UtilityManagementServiceData;
using UtilityManagementRepository;

namespace UtilityManagmentService.Tests
{
    [TestClass]
    public class UtilityManagementBusinessLayerTests
    {
        #region public method

        #region Get Next Meter Read Date Tests

        [TestMethod]
        /// Get Next Meter Read Date tests
        /// Happy
        public void UtilityManagementBusinessLayer_GetNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDate_HappyTest()
        {
            string messageId = Guid.NewGuid().ToString();
            UtilityManagementRepository.IDataRepository dataRepository = new DataRepositoryMockGetNextMeterReadDateHappyPath();
            IBusinessLayer businessLayer = new BusinessLayer(messageId, dataRepository);
            DateTime inquiryDate = DateTime.Now;
            GetNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse getNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse = businessLayer.GetNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDate(messageId, 9, "9", false, inquiryDate);

            Assert.AreEqual(inquiryDate.AddDays(7).Date, getNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse.NextMeterReadDate.Date);
            Assert.AreEqual(true, getNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse.IsSuccess);
            Assert.AreEqual(messageId, getNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse.MessageId);
            Assert.AreEqual("Success", getNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse.Message);
            Assert.AreEqual("0000", getNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse.Code);
        }

        [TestMethod]
        public void UtilityManagementBusinessLayer_GetNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDate_NoReturnValue()
        {
            string messageId = Guid.NewGuid().ToString();
            UtilityManagementRepository.IDataRepository dataRepository = new DataRepositoryMockGetNextMeterReadDateNoReturnValue();
            IBusinessLayer businessLayer = new BusinessLayer(messageId, dataRepository);
            DateTime inquiryDate = DateTime.Now;
            GetNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse getNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse = businessLayer.GetNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDate(messageId, 9, "9", false, inquiryDate);

            Assert.AreEqual(new DateTime(1900,1,1), getNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse.NextMeterReadDate);
            Assert.AreEqual(false, getNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse.IsSuccess);
            Assert.AreEqual(messageId, getNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse.MessageId);
            Assert.AreEqual("No Data Returned", getNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse.Message);
            Assert.AreEqual("4001", getNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse.Code);
        }

        [TestMethod]
        public void UtilityManagementBusinessLayer_GetNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDate_ValueOutOfRange()
        {
            string messageId = Guid.NewGuid().ToString();
            UtilityManagementRepository.IDataRepository dataRepository = new DataRepositoryMockGetNextMeterReadDateValueOutOfRange();
            IBusinessLayer businessLayer = new BusinessLayer(messageId, dataRepository);
            DateTime inquiryDate = DateTime.Now;
            GetNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse getNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse = businessLayer.GetNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDate(messageId, 9, "9", false, inquiryDate);

            Assert.IsTrue(inquiryDate.Date < getNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse.NextMeterReadDate.Date);
            Assert.AreEqual(false, getNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse.IsSuccess);
            Assert.AreEqual(messageId, getNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse.MessageId);
            Assert.AreEqual("Returned Value Out Of Range", getNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse.Message);
            Assert.AreEqual("4002", getNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse.Code);
        }

        #endregion



        #region Get Previous Meter Read Date Tests
        [TestMethod]
        public void UtilityManagementBusinessLayer_GetPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDate_Happy_Test()
        {
            string messageId = Guid.NewGuid().ToString();
            int utilityId = 9;
            string readCycleId = "1";
            bool isAmr = false;
            DateTime inquiryDate = DateTime.Now;
            IDataRepository repository = new DataRepositoryMockGetPreviousMeterReadDateHappyPath();
            IBusinessLayer businessLayer = new BusinessLayer(messageId, repository);
            GetPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse data = businessLayer.GetPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDate(messageId, utilityId, readCycleId, isAmr, inquiryDate);
            Assert.IsNotNull(data, "data is null");
            Assert.AreEqual("0000", data.Code, string.Format("data.Code:{0} does not equal 0000", Utilities.Common.NullSafeString(data.Code)));
            Assert.IsTrue(data.IsSuccess, string.Format("data.IsSuccess:{0} is false", data.IsSuccess));
            Assert.AreEqual("SUCCESS", data.Message.ToUpper(), string.Format("data.Message:{0} does not equal SUCCESS", Utilities.Common.NullSafeString(data.Message)));
            Assert.AreEqual(messageId, data.MessageId, string.Format("data.MessageId:{0} does not equal messageId:{1}",
                Utilities.Common.NullSafeString(data.MessageId), Utilities.Common.NullSafeString(messageId)));
            Assert.AreEqual(inquiryDate.AddDays(-7).Date, data.PreviousMeterReadDate.Date,
                "data.PreviousMeterReadDate:{0} does not equal inquiryDate.AddDays(-7):{1}",
                Utilities.Common.NullSafeDateToString(data.PreviousMeterReadDate.Date),
                Utilities.Common.NullSafeDateToString(inquiryDate.AddDays(-7).Date));
        }

        [TestMethod]
        // This is a test which matches the successful scenario which would be encountered most of the time.
        // Here, we are using today as the inquiry date, and the mock scenario is subtracting 7 days from the inquiry date and returning that as the previous meter read date
        public void UtilityManagementBusinessLayer_GetPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDate_HappyTest()
        {
            // initialize variables
            string messageId = Guid.NewGuid().ToString();
            int utilityId = 9;
            string readCycleId = "1";
            bool isAmr = false;
            DateTime inquiryDate = DateTime.Now;

            // initialize mock repository layer and business layer
            IDataRepository dataRepository = new DataRepositoryMockGetPreviousMeterReadDateHappyPath();
            IBusinessLayer businessLayer = new BusinessLayer(messageId, dataRepository);

            // call method being tested
            GetPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse getPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse = 
                businessLayer.GetPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDate(messageId, utilityId, readCycleId, isAmr, inquiryDate);

            // test the results
            Assert.AreEqual(inquiryDate.AddDays(-7).Date, getPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse.PreviousMeterReadDate.Date);
            Assert.AreEqual(true, getPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse.IsSuccess);
            Assert.AreEqual(messageId, getPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse.MessageId);
            Assert.AreEqual("Success", getPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse.Message);
            Assert.AreEqual("0000", getPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse.Code);
        }

        [TestMethod]
        public void UtilityManagementBusinessLayer_GetPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDate_NullDate()
        {
            string messageId = Guid.NewGuid().ToString();
            IDataRepository dataRepository = new DataRepositoryMockGetPreviousMeterReadDateNoReturnValue();
            IBusinessLayer businessLayer = new BusinessLayer(messageId, dataRepository);
            DateTime inquiryDate = DateTime.Now;
            GetPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse getPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse = businessLayer.GetPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDate(messageId, 9, "9", false, inquiryDate);

            Assert.AreEqual(new DateTime(1900, 1, 1), getPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse.PreviousMeterReadDate);
            Assert.AreEqual(false, getPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse.IsSuccess);
            Assert.AreEqual(messageId, getPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse.MessageId);
            Assert.AreEqual("Returned Value Out Of Range", getPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse.Message);
            Assert.AreEqual("4002", getPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse.Code);
        }

        [TestMethod]
        public void UtilityManagementBusinessLayer_GetPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDate_OutOfRange_NullDataSet()
        {
            string messageId = Guid.NewGuid().ToString();
            IDataRepository dataRepository = new DataRepositoryMockGetPreviousMeterReadDateNoReturnValueNullDataSet();
            IBusinessLayer businessLayer = new BusinessLayer(messageId, dataRepository);
            DateTime inquiryDate = DateTime.Now;
            GetPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse getPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse = businessLayer.GetPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDate(messageId, 9, "9", false, inquiryDate);

            Assert.AreEqual(new DateTime(1900, 1, 1), getPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse.PreviousMeterReadDate);
            Assert.AreEqual(false, getPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse.IsSuccess);
            Assert.AreEqual(messageId, getPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse.MessageId);
            Assert.AreEqual("No Data Returned", getPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse.Message);
            Assert.AreEqual("4001", getPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse.Code);
        }

        [TestMethod]
        public void UtilityManagementBusinessLayer_GetPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDate_ValueOutOfRange()
        {
            string messageId = Guid.NewGuid().ToString();
            UtilityManagementRepository.IDataRepository dataRepository = new DataRepositoryMockGetPreviousMeterReadDateValueOutOfRange();
            IBusinessLayer businessLayer = new BusinessLayer(messageId, dataRepository);
            DateTime inquiryDate = DateTime.Now;
            GetPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse getPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse = businessLayer.GetPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDate(messageId, 9, "9", false, inquiryDate);

            Assert.IsTrue(inquiryDate.Date > getPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse.PreviousMeterReadDate.Date);
            Assert.AreEqual(false, getPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse.IsSuccess);
            Assert.AreEqual(messageId, getPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse.MessageId);
            Assert.AreEqual("Returned Value Out Of Range", getPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse.Message);
            Assert.AreEqual("4002", getPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse.Code);
        }
        #endregion


        [TestMethod]
        public void TestNewIdrRule()
        {
            UtilityManagementRepository.DataRepositoryEntityFramework dref = new UtilityManagementRepository.DataRepositoryEntityFramework();
            var result = dref.usp_IdrRule_Integrated(Guid.NewGuid().ToString(), "a2", "r", "t", false, true, 9, 13866);
            IBusinessLayer businessLayer = new BusinessLayer();


            //match
            var data0 = businessLayer.GetIdrRequestModeData(Guid.NewGuid().ToString(), 9, "123", EnrollmentType.PreEnrollment, "A", "A", "A", 1, true, false);

            //?
            var data1 = businessLayer.GetIdrRequestModeData(Guid.NewGuid().ToString(), 9, "123", EnrollmentType.PreEnrollment, "A", "A", "A", 1, true, false);

            // guaranteed no match
            var data2 = businessLayer.GetIdrRequestModeData(Guid.NewGuid().ToString(), 9, "123", EnrollmentType.PreEnrollment, "A", "A", "A", 1, true, false);

            // match 4E853E64-796E-465C-9699-3A669FF5E664	NULL	R	1	1	NULL	NULL
            //   and 9F159A1D-54CD-4BDC-B4CF-A156250EBFD5	NULL	R	0	1	1	13865
            var data3 = businessLayer.GetIdrRequestModeData(Guid.NewGuid().ToString(), 9, "123", EnrollmentType.PreEnrollment, "A", "A", "A", 1, true, true);
            // match 4E853E64-796E-465C-9699-3A669FF5E664	NULL	R	1	1	NULL	NULL
            var data4 = businessLayer.GetIdrRequestModeData(Guid.NewGuid().ToString(), 9, "123", EnrollmentType.PreEnrollment, "A", "A", "A", 1, true, true);
            // match 4E853E64-796E-465C-9699-3A669FF5E664	NULL	R	1	1	NULL	NULL
            var data5 = businessLayer.GetIdrRequestModeData(Guid.NewGuid().ToString(), 9, "123", EnrollmentType.PreEnrollment, "A", "A", "A", 1, true, true);

            // match 188CF467-3D14-470E-A6B5-683379A4469A	AAA 111	R	0	0	1	NULL
            var data6 = businessLayer.GetIdrRequestModeData(Guid.NewGuid().ToString(), 9, "123", EnrollmentType.PreEnrollment, "A", "A", "A", 1, true, false);
            // business no match
            var data7 = businessLayer.GetIdrRequestModeData(Guid.NewGuid().ToString(), 9, "123", EnrollmentType.PreEnrollment, "A", "A", "A", 1, true, false);
            // guaranteed no match
            var data8 = businessLayer.GetIdrRequestModeData(Guid.NewGuid().ToString(), 9, "123", EnrollmentType.PreEnrollment, "A", "A", "A", 1, true, false);

            // insufficient info
            try
            {
                var data9 = businessLayer.GetIdrRequestModeData(Guid.NewGuid().ToString(), 9, "123", EnrollmentType.PreEnrollment, "A", "A", "A", 1, true, false);
            }
            catch (Exception)
            {
                string s = string.Empty;
            }
            try
            {
                var data10 = businessLayer.GetIdrRequestModeData(Guid.NewGuid().ToString(), 9, "123", EnrollmentType.PreEnrollment, "A", "A", "A", 1, true, false);
            }
            catch (Exception)
            {
                string s1 = string.Empty;
            }

            var data111 = businessLayer.GetIdrRequestModeData(Guid.NewGuid().ToString(), 9, "123", EnrollmentType.PreEnrollment, "A", "A", "A", 1, true, false);

            string s3 = string.Empty;

        }

        [TestMethod]
        public void UtilityManagementBusinessLayer_GetAllUtiltiesReceiveIdrOnly_Happy_Test()
        {
            string messageId = Guid.NewGuid().ToString();
            IDataRepository dataRepository = new DataRepositoryMockGetAllUtiltiesReceiveIdrOnlyHappyPath();
            IBusinessLayer businessLayer = new BusinessLayer(messageId, dataRepository);
            GetAllUtilitiesReceiveIdrOnlyResponse getAllUtilitiesReceiveIdrOnlyResponse = businessLayer.GetAllUtiltiesReceiveIdrOnly(messageId);
            Assert.IsNotNull(getAllUtilitiesReceiveIdrOnlyResponse);
            Assert.AreEqual("0000",getAllUtilitiesReceiveIdrOnlyResponse.Code);
            Assert.AreEqual("SUCCESS", getAllUtilitiesReceiveIdrOnlyResponse.Message.ToUpper());
            Assert.AreEqual(messageId, getAllUtilitiesReceiveIdrOnlyResponse.MessageId);
            Assert.AreEqual(true, getAllUtilitiesReceiveIdrOnlyResponse.IsSuccess);
            Assert.IsNotNull(getAllUtilitiesReceiveIdrOnlyResponse.GetAllUtiltiesReceiveIdrOnlyResponseItems);
            Assert.AreEqual(3, getAllUtilitiesReceiveIdrOnlyResponse.GetAllUtiltiesReceiveIdrOnlyResponseItems.Count);
            Assert.AreEqual("ACE", getAllUtilitiesReceiveIdrOnlyResponse.GetAllUtiltiesReceiveIdrOnlyResponseItems[0].UtilityCode);
            Assert.AreEqual(9, getAllUtilitiesReceiveIdrOnlyResponse.GetAllUtiltiesReceiveIdrOnlyResponseItems[0].UtilityIdInt);
            Assert.AreEqual(true, getAllUtilitiesReceiveIdrOnlyResponse.GetAllUtiltiesReceiveIdrOnlyResponseItems[0].ReceiveIdrOnly);
            Assert.AreEqual("AEPCE", getAllUtilitiesReceiveIdrOnlyResponse.GetAllUtiltiesReceiveIdrOnlyResponseItems[1].UtilityCode);
            Assert.AreEqual(1, getAllUtilitiesReceiveIdrOnlyResponse.GetAllUtiltiesReceiveIdrOnlyResponseItems[1].UtilityIdInt);
            Assert.AreEqual(true, getAllUtilitiesReceiveIdrOnlyResponse.GetAllUtiltiesReceiveIdrOnlyResponseItems[1].ReceiveIdrOnly);
            Assert.AreEqual("ONCOR", getAllUtilitiesReceiveIdrOnlyResponse.GetAllUtiltiesReceiveIdrOnlyResponseItems[2].UtilityCode);
            Assert.AreEqual(5, getAllUtilitiesReceiveIdrOnlyResponse.GetAllUtiltiesReceiveIdrOnlyResponseItems[2].UtilityIdInt);
            Assert.AreEqual(false, getAllUtilitiesReceiveIdrOnlyResponse.GetAllUtiltiesReceiveIdrOnlyResponseItems[2].ReceiveIdrOnly);
        }


        [TestMethod]
        public void UtilityManagementBusinessLayer_GetAllUtiltiesReceiveIdrOnly_No_Value_Returned_Test()
        {
            string messageId = Guid.NewGuid().ToString();
            IDataRepository dataRepository = new DataRepositoryMockGetAllUtiltiesReceiveIdrNoValueReturnedPath();
            IBusinessLayer businessLayer = new BusinessLayer(messageId, dataRepository);
            GetAllUtilitiesReceiveIdrOnlyResponse getAllUtilitiesReceiveIdrOnlyResponse = businessLayer.GetAllUtiltiesReceiveIdrOnly(messageId);
            Assert.IsNotNull(getAllUtilitiesReceiveIdrOnlyResponse);
            Assert.AreEqual("4001", getAllUtilitiesReceiveIdrOnlyResponse.Code);
            Assert.AreEqual("NO VALUE RETURNED", getAllUtilitiesReceiveIdrOnlyResponse.Message.ToUpper());
            Assert.AreEqual(messageId, getAllUtilitiesReceiveIdrOnlyResponse.MessageId);
            Assert.AreEqual(false, getAllUtilitiesReceiveIdrOnlyResponse.IsSuccess);
            Assert.IsNotNull(getAllUtilitiesReceiveIdrOnlyResponse.GetAllUtiltiesReceiveIdrOnlyResponseItems);
            Assert.AreEqual(0, getAllUtilitiesReceiveIdrOnlyResponse.GetAllUtiltiesReceiveIdrOnlyResponseItems.Count);
        }

        [TestMethod]
        public void UtilityManagementBusinessLayer_GetAllUtiltiesReceiveIdrOnly_Error_Test()
        {
            string messageId = Guid.NewGuid().ToString();
            IDataRepository dataRepository = new DataRepositoryMockGetAllUtiltiesReceiveIdrErrorPath();
            IBusinessLayer businessLayer = new BusinessLayer(messageId, dataRepository);
            GetAllUtilitiesReceiveIdrOnlyResponse getAllUtilitiesReceiveIdrOnlyResponse = businessLayer.GetAllUtiltiesReceiveIdrOnly(messageId);
            Assert.IsNotNull(getAllUtilitiesReceiveIdrOnlyResponse);
            Assert.AreEqual("9999", getAllUtilitiesReceiveIdrOnlyResponse.Code);
            Assert.AreEqual("AN APPLICATION ERROR OCCURRED", getAllUtilitiesReceiveIdrOnlyResponse.Message.ToUpper());
            Assert.AreEqual(messageId, getAllUtilitiesReceiveIdrOnlyResponse.MessageId);
            Assert.AreEqual(false, getAllUtilitiesReceiveIdrOnlyResponse.IsSuccess);
            Assert.IsNotNull(getAllUtilitiesReceiveIdrOnlyResponse.GetAllUtiltiesReceiveIdrOnlyResponseItems);
            Assert.AreEqual(0, getAllUtilitiesReceiveIdrOnlyResponse.GetAllUtiltiesReceiveIdrOnlyResponseItems.Count);
        }

        #region Get All Request Mode Enrollment Types Tests
        [TestMethod]
        public void UtilityManagementBusinessLayer_GetAllRequestModeEnrollmentTypes_Happy_Test()
        {
            string messageId = Guid.NewGuid().ToString();
            IBusinessLayer businessLayer = new BusinessLayer();
            var data = businessLayer.GetAllRequestModeEnrollmentTypes(messageId);
            Assert.IsNotNull(data);
            Assert.AreEqual("0000", data.Code);
            Assert.IsTrue(data.IsSuccess);
            Assert.AreEqual("", data.Message);
            Assert.AreEqual(messageId, data.MessageId);
            Assert.IsNotNull(data.RequestModeEnrollmentTypes);
            Assert.AreEqual(2, data.RequestModeEnrollmentTypes.Count);
            Assert.IsNotNull(data.RequestModeEnrollmentTypes[0]);
            Assert.IsNotNull(data.RequestModeEnrollmentTypes[1]);
            Assert.IsFalse(string.IsNullOrWhiteSpace(data.RequestModeEnrollmentTypes[0].Name));
            Assert.IsFalse(string.IsNullOrWhiteSpace(data.RequestModeEnrollmentTypes[1].Name));
            Assert.IsTrue(Common.IsValidGuid(data.RequestModeEnrollmentTypes[0].RequestModeEnrollmentTypeId));
            Assert.IsTrue(Common.IsValidGuid(data.RequestModeEnrollmentTypes[1].RequestModeEnrollmentTypeId));
        }
        #endregion



        #region Get All Utilities Tests
        [TestMethod]
        public void UtilityManagementBusinessLayer_GetAllUtilities_Happy_Test()
        {
            string messageId = Guid.NewGuid().ToString();
            IBusinessLayer businessLayer = new BusinessLayer();
            var data = businessLayer.GetAllUtilities(messageId);
            Assert.IsNotNull(data);
            Assert.AreEqual("0000", data.Code);
            Assert.IsTrue(data.IsSuccess);
            Assert.AreEqual("", data.Message);
            Assert.AreEqual(messageId, data.MessageId);
            Assert.IsNotNull(data.Utilities);
            Assert.AreNotEqual(0, data.Utilities.Count);
            foreach (var utility in data.Utilities)
            {
                Assert.IsNotNull(utility);
                Assert.IsTrue(Common.IsValidGuid(utility.UtilityId));
                Assert.IsFalse(string.IsNullOrWhiteSpace(utility.UtilityCode));
            }
        }
        #endregion


        #endregion



        #region private methods
        private DataForTest GenerateData()
        {
            List<Guid> listOfRequestModeEnrollmentTypes = new List<Guid>();
            List<UtilityData> listOfUtilities = new List<UtilityData>();
            string messageId = Guid.NewGuid().ToString();
            IBusinessLayer businessLayer = new BusinessLayer();
            var utilityResponse = businessLayer.GetAllUtilities(messageId);
            if (utilityResponse.IsSuccess)
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
                }

                var requestModeEnrollmentTypeResponse = businessLayer.GetAllRequestModeEnrollmentTypes(messageId);
                if (requestModeEnrollmentTypeResponse.IsSuccess)
                {
                    foreach (var requestModeEnrollmentType in requestModeEnrollmentTypeResponse.RequestModeEnrollmentTypes)
                    {
                        listOfRequestModeEnrollmentTypes.Add(requestModeEnrollmentType.RequestModeEnrollmentTypeId);
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
        #endregion
    }
}