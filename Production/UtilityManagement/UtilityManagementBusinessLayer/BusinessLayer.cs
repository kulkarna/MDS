using DataAccessLayerEntityFramework;
using Microsoft.Practices.Unity;
using Microsoft.Practices.Unity.Configuration;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Utilities;
using UtilityLogging;
using UtilityManagementDataMapper;
using UtilityManagementServiceData;
using UtilityManagementRepository;
using UtilityUnityLogging;
using UsageWebService.Entities;
using LibertyPower.Business.CommonBusiness.FieldHistory;


namespace UtilityManagementBusinessLayer
{
    /// <summary>
    /// This class serves as the business layer for the Utility Management WCF Service and contains any and all necesary
    /// business logic for the service.  It derives from the interface UtilityManagementBusinessLayer.IBusinessLayer.
    /// </summary>
    public class BusinessLayer : IBusinessLayer
    {

        #region private variables
        private const string NAMESPACE = "UtilityManagementBusinessLayer";
        private const string CLASS = "BusinessLayer";
        private IDataRepository _dataRepository;
        private IDataRepositoryV3 _dataRepositoryV3;
        private ILogger _logger;
        private const string NOVALUERETURNED = "4001";
        private const string ERRORCODE = "9999";
        private const string INVALIDINPUTPARAMETER = "7777";
        private const string CODEINSUFFICIENTINFO = "4200";
        private const string RETURNEDVALUEOUTOFRANGE = "4002";
        #endregion

        #region public constructors
        /// <summary>
        /// Basic Constructor for BusinessLayer class with no parameters.
        /// </summary>
        public BusinessLayer()
        {
            string method = "BusinessLayer()";
            string messageId = Guid.NewGuid().ToString();
            try
            {
                _logger = UnityLoggerGenerator.GenerateLogger();

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
                _dataRepository = new DataRepositoryEntityFramework();
                _dataRepositoryV3 = new DataRepository();
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }


        /// <summary>
        /// Constructor for BusinessLayer class which allows for IOC and Mocking for Unit Testing.
        /// </summary>
        /// <param name="messageId">A string based GUID which serves as a traceable id for calls within a particular thread or across systems utilized for logging and other diagnostic purposes.</param>
        /// <param name="dataRepository"></param>
        public BusinessLayer(string messageId, IDataRepository dataRepository)
        {
            string method = "BusinessLayer(dataRepository)";

            try
            {
                _logger = UnityLoggerGenerator.GenerateLogger();

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
                _dataRepository = dataRepository;

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        /// <summary>
        /// Constructor for BusinessLayer class which allows for IOC and Mocking for Unit Testing and logging.
        /// </summary>
        /// <param name="messageId">A string based GUID which serves as a traceable id for calls within a particular thread or across systems utilized for logging and other diagnostic purposes.</param>
        /// <param name="dataRepository">The data repository object to be used by the BusinessLayer class.</param>
        /// <param name="logger">The logger object to be utilized by the Business Layer class.</param>
        public BusinessLayer(string messageId, IDataRepository dataRepository, ILogger logger)
        {
            string method = "BusinessLayer(dataRepository)";

            try
            {
                if (logger != null)
                    _logger = logger;
                else
                    _logger = UnityLoggerGenerator.GenerateLogger();

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
                _dataRepository = dataRepository;

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }
        #endregion


        #region public methods

        /// <summary>
        /// This method encapsulates the business logic for the call which retrieves the previous meter read date for a particular utility and read cycle with reference to the specified inquiry date.
        /// </summary>
        /// <param name="messageId">A string based GUID which serves as a traceable id for calls within a particular thread or across systems utilized for logging and other diagnostic purposes.</param>
        /// <param name="utilityId">The integer representing a particular utility which maps to LPCNOCSQLINT2\DELTA LP_UtilityManagement.dbo.UtilityCompany.UtilityIdInt.</param>
        /// <param name="readCycleId">A string representing a particular Read Cycle or Meter Read Trip for a particular utility which maps to LPCNOCSQLINT2\DELTA LP_UtilityManagement.dbo.MeterReadCalendar.ReadCycleId.</param>
        /// <param name="isAmr">A boolean specifying whether the meters in question are automated meter reads.</param>
        /// <param name="inquiryDate">A date (usually today's date) serving as a reference point for obtaining the next future meter read for the specified utility id and read cycle id.</param>
        /// <returns>An instance of the GetPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse class which contains the previous meter read date as well as parameters which illustrate the status of the call.</returns>
        public GetPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse GetPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDate(string messageId, int utilityId, string readCycleId, bool isAmr, DateTime inquiryDate)
        {
            string method = string.Format("GetPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDate(messageId, utilityId:{0}, readCycleId:{1}, isAmr:{2}, inquiryDate:{3})",
                Common.NullSafeString(utilityId), Common.NullSafeString(readCycleId), Common.NullSafeString(isAmr), Common.NullSafeDateToString(inquiryDate));
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
                _dataRepositoryV3.MessageId = messageId;
                GetPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse returnValue;
                EfToWcfMapping mapper = new EfToWcfMapping();
                int previousMeterReadFutureDayThreshold = (-1) * Common.NullSafeInteger(System.Configuration.ConfigurationManager.AppSettings["PreviousMeterReadFutureDayThreshold"]);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} previousMeterReadFutureDayThreshold={3}", NAMESPACE, CLASS, method, previousMeterReadFutureDayThreshold));

                DataSet dataSet = _dataRepositoryV3.GetMeterReadCalenderPreviousReadDateByUtilityIdReadCycleIdAndInquiryDate(messageId, utilityId, readCycleId, isAmr, inquiryDate);

                // validate dataset
                if (!Utilities.Common.IsDataSetRowValid(dataSet))
                {
                    returnValue = new GetPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse()
                    {
                        PreviousMeterReadDate = new DateTime(1900, 1, 1),
                        Code = "4001",
                        Message = "No Data Returned",
                        IsSuccess = false,
                        MessageId = messageId
                    };
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:[{3}] END", NAMESPACE, CLASS, method, returnValue));
                    return returnValue;
                }

                // map the data
                returnValue = mapper.ConvertDataSetToGetPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse(messageId, dataSet);

                // validate return value
                if (inquiryDate.AddDays(previousMeterReadFutureDayThreshold) > returnValue.PreviousMeterReadDate)
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} inquiryDate:{3}.AddDays(previousMeterReadFutureDayThreshold:{4}):{5} < returnValue.PreviousMeterReadDate:{6} END", NAMESPACE, CLASS, method,
                        Common.NullSafeDateToString(inquiryDate), Common.NullSafeString(previousMeterReadFutureDayThreshold), Common.NullSafeDateToString(inquiryDate.AddDays(previousMeterReadFutureDayThreshold)), Common.NullSafeDateToString(returnValue.PreviousMeterReadDate)));
                    returnValue.Code = RETURNEDVALUEOUTOFRANGE;
                    returnValue.Message = "Returned Value Out Of Range";
                    returnValue.IsSuccess = false;
                    returnValue.MessageId = messageId;
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:[{3}] END", NAMESPACE, CLASS, method, returnValue));
                return returnValue;
            }
            catch (Exception exc)
            {
                GetPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse returnValue = new GetPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse()
                {
                    Code = ERRORCODE,
                    Message = exc.Message,
                    MessageId = messageId,
                    IsSuccess = false,
                    PreviousMeterReadDate = new DateTime(1900, 1, 1)
                };
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                return returnValue;
            }
        }

        /// <summary>
        /// This method encapsulates the business logic for the call which retrieves the next meter read date for a particular utility and read cycle with reference to the specified inquiry date.
        /// </summary>
        /// <param name="messageId">A string based GUID which serves as a traceable id for calls within a particular thread or across systems utilized for logging and other diagnostic purposes.</param>
        /// <param name="utilityId">The integer representing a particular utility which maps to LPCNOCSQLINT2\DELTA LP_UtilityManagement.dbo.UtilityCompany.UtilityIdInt.</param>
        /// <param name="readCycleId">A string representing a particular Read Cycle or Meter Read Trip for a particular utility which maps to LPCNOCSQLINT2\DELTA LP_UtilityManagement.dbo.MeterReadCalendar.ReadCycleId.</param>
        /// <param name="isAmr">A boolean specifying whether the meters in question are automated meter reads.</param>
        /// <param name="inquiryDate">A date (usually today's date) serving as a reference point for obtaining the next future meter read for the specified utility id and read cycle id.</param>
        /// <returns>An instance of the GetNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse class which contains the next meter read date as well as parameters which illustrate the status of the call.</returns>
        public GetNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse GetNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDate(string messageId, int utilityId, string readCycleId, bool isAmr, DateTime inquiryDate)
        {
            string method = string.Format("GetNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDate(messageId, utilityId:{0}, readCycleId:{1}, isAmr:{2}, inquiryDate:{3})",
                Common.NullSafeString(utilityId), Common.NullSafeString(readCycleId), Common.NullSafeString(isAmr), Common.NullSafeDateToString(inquiryDate));
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
                _dataRepositoryV3.MessageId = messageId;
                GetNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse returnValue;
                EfToWcfMapping mapper = new EfToWcfMapping();
                int nextMeterReadFutureDayThreshold = Common.NullSafeInteger(System.Configuration.ConfigurationManager.AppSettings["NextMeterReadFutureDayThreshold"]);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} nextMeterReadFutureDayThreshold={3}", NAMESPACE, CLASS, method, nextMeterReadFutureDayThreshold));

                DataSet dataSet = _dataRepositoryV3.GetMeterReadCalenderNextReadDateByUtilityIdReadCycleIdAndInquiryDate(messageId, utilityId, readCycleId, isAmr, inquiryDate);

                // validate dataset
                if (!Utilities.Common.IsDataSetRowValid(dataSet))
                {
                    returnValue = new GetNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse()
                    {
                        NextMeterReadDate = new DateTime(1900, 1, 1),
                        Code = "4001",
                        Message = "No Data Returned",
                        IsSuccess = false,
                        MessageId = messageId
                    };
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:[{3}] END", NAMESPACE, CLASS, method, returnValue));
                    return returnValue;
                }

                // map the data
                returnValue = mapper.ConvertDataSetToGetNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse(messageId, dataSet);

                // validate return value
                if (inquiryDate.AddDays(nextMeterReadFutureDayThreshold) < returnValue.NextMeterReadDate)
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} inquiryDate:{3}.AddDays(nextMeterReadFutureDayThreshold:{4}):{5} < returnValue.NextMeterReadDate:{6} END", NAMESPACE, CLASS, method,
                        Common.NullSafeDateToString(inquiryDate), Common.NullSafeString(nextMeterReadFutureDayThreshold), Common.NullSafeDateToString(inquiryDate.AddDays(nextMeterReadFutureDayThreshold)), Common.NullSafeDateToString(returnValue.NextMeterReadDate)));
                    returnValue.Code = RETURNEDVALUEOUTOFRANGE;
                    returnValue.Message = "Returned Value Out Of Range";
                    returnValue.IsSuccess = false;
                    returnValue.MessageId = messageId;
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:[{3}] END", NAMESPACE, CLASS, method, returnValue));
                return returnValue;
            }
            catch (Exception exc)
            {
                GetNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse returnValue = new GetNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse()
                {
                    Code = ERRORCODE,
                    Message = exc.Message,
                    MessageId = messageId,
                    IsSuccess = false,
                    NextMeterReadDate = new DateTime(1900, 1, 1)
                };
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                return returnValue;
            }
        }

        /// <summary>
        /// This method retrieves the Meter Read Calendar for an entire Utility based on that Utility's integer Id (LPCNOCSQLINT2\PROD LP_UtilityManagement.dbo.UtilityCompany.UtilityIdInt).
        /// </summary>
        /// <param name="messageId">A string based GUID which serves as a traceable id for calls within a particular thread or across systems utilized for logging and other diagnostic purposes.</param>
        /// <param name="utilityId">The integer representing a particular utility which maps to LPCNOCSQLINT2\DELTA LP_UtilityManagement.dbo.UtilityCompany.UtilityIdInt.</param>
        /// <returns></returns>
        public GetMeterReadCalendarByUtilityIdResponse GetMeterReadCalendarByUtilityId(string messageId, int utilityIdInt)
        {
            string method = string.Format("GetMeterReadCalendarByUtilityId(messageId, utilityIdInt:{0})", utilityIdInt);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
                EfToWcfMapping mapper = new EfToWcfMapping();
                _dataRepositoryV3.MessageId = messageId;
                string utilityCode = GetUtilityCodeByUtilityId(messageId, utilityIdInt);
                var response = _dataRepositoryV3.GetMeterReadCalendarByUtilityCode(messageId, utilityCode);
                if (response == null)
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} Null Response Generated For Call! END", NAMESPACE, CLASS, method));
                    return null;
                }
                var returnValue = mapper.ConvertEfGetMeterReadCalendarByUtilityIdResponseToWcfGetMeterReadCalendarByUtilityIdResponse(messageId, response, utilityCode);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue END", NAMESPACE, CLASS, method));
                return returnValue;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public GetMeterReadCalendarByUtilityIdResponse GetErrorMessageResponse(string messageId)
        {
            string method = string.Format("GetErrorMessageResponse(messageId)");
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
                EfToWcfMapping mapper = new EfToWcfMapping();
                var returnValue = mapper.ConvertEfGetMeterReadCalendarByUtilityIdResponseToWcfGetMeterReadCalendarByUtilityIdResponse(messageId);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:[{3}]END", NAMESPACE, CLASS, method, returnValue));
                return returnValue;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public int GetUtilityIdByUtilityCode(string messageId, string utilityCode)
        {
            string method = string.Format("GetUtilityIdByUtilityCode(messageId, utilityCode:{0})", utilityCode);

            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                _dataRepositoryV3.MessageId = messageId;

                // process legacy utility id
                var utilityIdItem = _dataRepositoryV3.GetUtilityIdbyUtilityCode(messageId, utilityCode);

                int returnValue = -1;
                if (utilityIdItem != null)
                    returnValue = Common.NullSafeInteger(utilityIdItem);

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:[{3}] END", NAMESPACE, CLASS, method, returnValue));
                return returnValue;
            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                if (!(exc is UtilityManagementBusinessException))
                {
                    _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exception));
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                    throw;
                }
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public string GetUtilityCodeByUtilityId(string messageId, int utilityId)
        {
            string method = string.Format("GetUtilityCodeByUtilityId(messageId, utilityId:{0})", utilityId);

            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                _dataRepositoryV3.MessageId = messageId;

                // process legacy utility id
                var utilityCode = _dataRepositoryV3.GetUtilityCodebyUtilityId(messageId, Convert.ToString(utilityId));

                string returnValue = string.Empty;
                if (utilityCode != null)
                    returnValue = utilityCode;

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:[{3}] END", NAMESPACE, CLASS, method, returnValue));
                return returnValue;
            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                if (!(exc is UtilityManagementBusinessException))
                {
                    _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exception), exc);
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                    throw;
                }
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }



        #region historical usage
        public RequestMode GetHURequestMode(string messageId, int utilityId, EnrollmentType enrollmentType)
        {
            string method = string.Format("GetHURequestMode(messageId, utilityId:{0}, enrollmentType:{1})", utilityId,Common.NullSafeString(enrollmentType));

            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                EfToWcfMapping mapper = new EfToWcfMapping();
                _dataRepositoryV3.MessageId = messageId;

                // process legacy utility id
                string utilityCode = _dataRepositoryV3.GetUtilityCodebyUtilityId(messageId, Convert.ToString(utilityId));
                if (string.IsNullOrEmpty(utilityCode))
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} Invalid Utility Id Int Provided! END", NAMESPACE, CLASS, method));
                    throw new UtilityManagementBusinessException(messageId, NOVALUERETURNED, string.Format("Utility ID {0} is not defined in Utility Management.", utilityId));
                }
                // process request mode historical usages
                DataSet dsData = _dataRepositoryV3.GetRequestModeHUData(messageId, utilityId, enrollmentType);
                if (dsData == null)
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} Null Response Generated For Legacy Utility Id and Request Enrollment Type Id! END", NAMESPACE, CLASS, method));
                    return null;
                }

                RequestMode returnValue = mapper.ConvertEfHistoricalusageRequestModeToWcfHistoricalusageRequestMode(messageId, dsData);

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:[{3}] END", NAMESPACE, CLASS, method, returnValue));
                return returnValue;
            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                if (!(exc is UtilityManagementBusinessException))
                {
                    _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exception), exc);
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                    throw;
                }
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }
        #endregion


        #region icap

        public RequestMode GetIcapRequestModeData(string messageId, int utilityIdInt, EnrollmentType enrollmentType)
        {
            string method = string.Format("GetIcapRequestModeData(messageId, UtilityIdInt:{0}, enrollmentType:{1})", utilityIdInt, enrollmentType);

            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                EfToWcfMapping mapper = new EfToWcfMapping();
                _dataRepository.MessageId = messageId;

                // process legacy utility id
                var utility = _dataRepositoryV3.GetUtilityCodebyUtilityId(messageId, Common.NullSafeString(utilityIdInt));
                if (utility == null || string.IsNullOrWhiteSpace(utility.ToString()))
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} Invalid Utility Id Int Provided! END", NAMESPACE, CLASS, method));
                    throw new UtilityManagementBusinessException(messageId, NOVALUERETURNED, string.Format("Utility ID {0} is not defined in Utility Management.", utilityIdInt));
                }

                DataTable data = _dataRepositoryV3.GetAIRequestMode(messageId, utilityIdInt, enrollmentType.ToString()).Tables[0];
                if (data == null)
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} Null Response Generated For Legacy Utility Id and Request Enrollment Type Id! END", NAMESPACE, CLASS, method));
                    return null;
                }
                RequestMode returnValue = mapper.ConvertEfIcapRequestModeToWcfIcapRequestMode(messageId, data);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:[{3}] END", NAMESPACE, CLASS, method, returnValue));
                return returnValue;
            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                if (!(exc is UtilityManagementBusinessException))
                {
                    _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exception), exc);
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                    throw;
                }
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }
        #endregion


        #region idr

        public bool GetAcceleratedSwitchbyUtilityCode(string messageId, string UtilityCode)
        {

            string method = string.Format("GetAcceleratedSwitchbyUtilityCode(messageId,UtilityCode:{0})", UtilityCode);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
                bool result = _dataRepositoryV3.GetAcceleratedSwitchbyUtilityCode(messageId, UtilityCode);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} result:{3} END", NAMESPACE, CLASS, method, result));
                return result;
            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                if (!(exc is UtilityManagementBusinessException))
                {
                    _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exception), exc);
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                    throw;
                }
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public bool DoesUtilityCodeBelongToIso(string messageId, string Iso, string UtilityCode)
        {

            string method = string.Format("DoesUtilityCodeBelongToIso(messageId,Iso:{0},UtilityCode:{1})", Iso, UtilityCode);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));


                bool result = _dataRepositoryV3.DoesUtilityCodeBelongToIso(messageId, Iso, UtilityCode);

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} result:{3} END", NAMESPACE, CLASS, method, result));
                return result;
            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                if (!(exc is UtilityManagementBusinessException))
                {
                    _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exception), exc);
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                    throw;
                }
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        private IdrRequestMode GenerateIdrRequestModeAlwaysRequestSetResponse(string messageId, int utilityIdInt, string serviceAccount, EnrollmentType enrollmentType, string rateClass, string loadProfile, string tariffCode, string annualUsage, bool hia)
        {

            string method = string.Format("GenerateIdrRequestModeAlwaysRequestSetResponse(messageId,utilityIdInt:{0},serviceAccount:{1},enrollmentType:{2},rateClass:{3},loadProfile:{4},tariffCode:{5}annualUsage:{6},hia:{7})", utilityIdInt, serviceAccount, enrollmentType, rateClass, loadProfile, tariffCode, annualUsage, hia.ToString());
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));


                DataSet dsResponse = _dataRepositoryV3.GetIdrRequestModeDataValuesByParam(messageId, utilityIdInt, serviceAccount, enrollmentType, rateClass, loadProfile, tariffCode, annualUsage, hia);
                if (!Common.IsDataSetRowValid(dsResponse))
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} Null Value Obtained For usp_IdrRuleAndRequestMode_SelectByParam! END", NAMESPACE, CLASS, method));
                    return null;
                }
                DataTable dtResponse = dsResponse.Tables[0];
                foreach (DataRow drResult in dtResponse.Rows)
                {
                    if (drResult != null)
                    {
                        // return request mode:
                        IdrRequestMode idrRequestMode = new IdrRequestMode()
                        {
                            Address = Common.NullSafeString(drResult["AddressForPreEnrollment"]),
                            EmailTemplate = Common.NullSafeString(drResult["EmailTemplate"]),
                            EnrollmentType = enrollmentType,
                            Instructions = Common.NullSafeString(drResult["Instructions"]),
                            IsLoaRequired = Convert.ToBoolean(drResult["IsLoaRequired"]),
                            IsProhibited = false,
                            LibertyPowerSlaResponse = Common.NullSafeInteger(drResult["LibertyPowersSlaFollowUpIdrResponseInDays"]),
                            RequestModeType = Common.NullSafeString(drResult["RequestModeTypeName"]),
                            UtilityId = utilityIdInt,
                            UtilitySlaResponse = Common.NullSafeInteger(drResult["UtilitysSlaIdrResponseInDays"]),
                            IsAlwaysRequestSet = true
                        };

                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} Returning Request Mode! idrRequestMode:{3} END", NAMESPACE, CLASS, method, idrRequestMode));
                        return idrRequestMode;
                    }
                }
                throw new UtilityManagementBusinessException(messageId, CODEINSUFFICIENTINFO, "Match scenario obtained but no request mode created.");
            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                if (!(exc is UtilityManagementBusinessException))
                {
                    _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exception), exc);
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                    throw;
                }
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        private IdrRequestMode GenerateIdrRequestModeMatchResponse(string messageId, int utilityIdInt, string serviceAccount, EnrollmentType enrollmentType, string rateClass, string loadProfile, string tariffCode, string annualUsage, bool hia)
        {

            string method = string.Format("GenerateIdrRequestModeMatchResponse(messageId,utilityIdInt:{0},serviceAccount:{1},enrollmentType:{2},rateClass:{3},loadProfile:{4},tariffCode:{5}annualUsage:{6},hia:{7})", utilityIdInt, serviceAccount, enrollmentType, rateClass, loadProfile, tariffCode, annualUsage, hia.ToString());
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
                DataSet dsResponse = _dataRepositoryV3.GetIdrRequestModeDataValuesByParam(messageId, utilityIdInt, serviceAccount, enrollmentType, rateClass, loadProfile, tariffCode, annualUsage, hia);
                if (Common.IsDataSetRowValid(dsResponse))
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} Null Value Obtained For usp_IdrRuleAndRequestMode_SelectByParam! END", NAMESPACE, CLASS, method));
                    return null;
                }
                DataTable dtResponse = dsResponse.Tables[0];
                foreach (DataRow drResult in dtResponse.Rows)
                {
                    if (drResult != null)
                    {
                        // return request mode:
                        IdrRequestMode idrRequestMode = new IdrRequestMode()
                        {
                            Address = Common.NullSafeString(drResult["AddressForPreEnrollment"]),
                            EmailTemplate = Common.NullSafeString(drResult["EmailTemplate"]),
                            EnrollmentType = enrollmentType,
                            Instructions = Common.NullSafeString(drResult["Instructions"]),
                            IsLoaRequired = Convert.ToBoolean(drResult["IsLoaRequired"]),
                            IsProhibited = false,
                            LibertyPowerSlaResponse = Common.NullSafeInteger(drResult["LibertyPowersSlaFollowUpIdrResponseInDays"]),
                            RequestModeType = Common.NullSafeString(drResult["RequestModeTypeName"]),
                            UtilityId = utilityIdInt,
                            UtilitySlaResponse = Common.NullSafeInteger(drResult["UtilitysSlaIdrResponseInDays"]),

                        };

                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} Returning Request Mode! idrRequestMode:{3} END", NAMESPACE, CLASS, method, idrRequestMode));
                        return idrRequestMode;
                    }
                }
                throw new UtilityManagementBusinessException(messageId, CODEINSUFFICIENTINFO, "Match scenario obtained but no request mode created.");
            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                if (!(exc is UtilityManagementBusinessException))
                {
                    _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exception), exc);
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                    throw;
                }
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        private IdrRequestMode GenerateIdrRequestModeBusinessFactorNotMetResponse(string messageId, int utilityIdInt, string serviceAccount)
        {
            string method = string.Format("GenerateIdrRequestModeBusinessFactorNotMetResponse(messageId,utilityIdInt:{0},serviceAccount:{1})", utilityIdInt, serviceAccount);
            try
            {
                //return business factor not met
                IdrRequestMode idrRequestModeBusinessFactorNotMet = new IdrRequestMode()
                {
                    Address = string.Empty,
                    EmailTemplate = string.Empty,
                    EnrollmentType = EnrollmentType.PreEnrollment,
                    Instructions = string.Empty,
                    IsLoaRequired = false,
                    IsProhibited = true,
                    LibertyPowerSlaResponse = 0,
                    RequestModeType = string.Empty,
                    UtilityId = utilityIdInt,
                    UtilitySlaResponse = 0
                };
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} Returning Business Factor Not Met! idrRequestMode:{3} END", NAMESPACE, CLASS, method, idrRequestModeBusinessFactorNotMet));
                return idrRequestModeBusinessFactorNotMet;
            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                if (!(exc is UtilityManagementBusinessException))
                {
                    _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exception), exc);
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                    throw;
                }
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }


        private IdrRequestMode GenerateIdrRequestModeGuaranteedFactorNotMetResponse(string messageId, int utilityIdInt, string serviceAccount)
        {

            string method = string.Format("GenerateIdrRequestModeGuaranteedFactorNotMetResponse(messageId,utilityIdInt:{0},string serviceAccount:{1})", utilityIdInt, serviceAccount);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                //return guaranteed factor not met
                IdrRequestMode idrRequestModeGuaranteedFactorNotMet = new IdrRequestMode()
                {
                    Address = string.Empty,
                    EmailTemplate = string.Empty,
                    EnrollmentType = EnrollmentType.PreEnrollment,
                    Instructions = string.Empty,
                    IsLoaRequired = false,
                    IsProhibited = true,
                    LibertyPowerSlaResponse = 0,
                    RequestModeType = string.Empty,
                    UtilityId = utilityIdInt,
                    UtilitySlaResponse = 0
                };

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} Returning Guaranteed Factor Not Met! idrRequestMode:{3} END", NAMESPACE, CLASS, method, idrRequestModeGuaranteedFactorNotMet));
                return idrRequestModeGuaranteedFactorNotMet;
            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                if (!(exc is UtilityManagementBusinessException))
                {
                    _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exception), exc);
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                    throw;
                }
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }


        public IdrRequestMode GetIdrRequestModeData(string messageId, int utilityIdInt, string serviceAccount, EnrollmentType enrollmentType, string loadProfile, string rateClass, string tariffCode, int? annualUsage, bool hasEligibilityRuleBeenSatisfied, bool hia)
        {
            string method = string.Format("GetIdrRequestModeData(messageId,utilityIdInt:{0},serviceAccount:{1},enrollmentType:{2},loadProfile:{3},rateClass:{4},tariffCode:{5},annualUsage:{6},hasEligibilityRuleBeenSatisfied:{7},hia:{8})",
                utilityIdInt, serviceAccount, enrollmentType, loadProfile, rateClass, tariffCode, annualUsage.ToString(), hasEligibilityRuleBeenSatisfied.ToString(), hia.ToString());
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                // validate utility id
                string utilityCode = _dataRepositoryV3.GetUtilityCodebyUtilityId(messageId, Convert.ToString(utilityIdInt));
                if (string.IsNullOrEmpty(utilityCode))
                {
                    _logger.LogError(messageId, string.Format("{0}.{1}.{2} Invalid Utility Id Provided {3}! END", NAMESPACE, CLASS, method, utilityIdInt));
                    throw new UtilityManagementBusinessException(messageId, NOVALUERETURNED, string.Format("Utility ID {0} is not defined in Utility Management.", utilityIdInt));
                }

                // initialize variables
                IdrRequestMode idrRequestMode = null;
                _dataRepositoryV3.MessageId = messageId;

                // get match, guaranteed factor not met, business determining factors, and insufficient info data from database
                DataSet dsIdrRuleIntegratedResult = _dataRepositoryV3.GetIdrRequestModeData(messageId, rateClass, loadProfile, tariffCode, hasEligibilityRuleBeenSatisfied, hia, utilityIdInt, annualUsage, enrollmentType);

                //------------------//------------------//------------------//------------------//------------------//------------------//

                // check for and process match sceneario
                if (Common.NullSafeInteger(dsIdrRuleIntegratedResult.Tables[0].Rows[0]["IsAlwaysRequestSet"]) == 1)
                {
                    IdrRequestMode idrRequestModeMatch = GenerateIdrRequestModeAlwaysRequestSetResponse(messageId, utilityIdInt, serviceAccount, enrollmentType, rateClass, loadProfile, tariffCode, annualUsage.ToString(), hia);
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} Returning Request Mode GenerateIdrRequestModeAlwaysRequestSetResponse! idrRequestMode:{3} END", NAMESPACE, CLASS, method, idrRequestMode));
                    return idrRequestModeMatch;
                }

                if (Common.NullSafeInteger(dsIdrRuleIntegratedResult.Tables[0].Rows[0]["Match"]) == 1)
                {
                    IdrRequestMode idrRequestModeMatch = GenerateIdrRequestModeMatchResponse(messageId, utilityIdInt, serviceAccount, enrollmentType, rateClass, loadProfile, tariffCode, annualUsage.ToString(), hia);
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} Returning Request Mode! idrRequestMode:{3} END", NAMESPACE, CLASS, method, idrRequestMode));
                    return idrRequestModeMatch;
                }

                // check for and process guaranteed factor not met scenario
                if (Common.NullSafeInteger(dsIdrRuleIntegratedResult.Tables[0].Rows[0]["GuaranteedFactorNotMet"]) == 1)
                {

                    IdrRequestMode idrRequestModeGuaranteedFactorNotMet = GenerateIdrRequestModeGuaranteedFactorNotMetResponse(messageId, utilityIdInt, serviceAccount);
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} Returning Guaranteed Factor Not Met! idrRequestModeGuaranteedFactorNotMet:{3} END", NAMESPACE, CLASS, method, idrRequestModeGuaranteedFactorNotMet));
                    return idrRequestModeGuaranteedFactorNotMet;
                }

                // check for and process business factor not met scenario
                if (Common.NullSafeInteger(dsIdrRuleIntegratedResult.Tables[0].Rows[0]["BusinessFactorNotMet"]) == 1)
                {
                    IdrRequestMode idrRequestModeBusinessFactorNotMet = GenerateIdrRequestModeBusinessFactorNotMetResponse(messageId, utilityIdInt, serviceAccount);
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} Returning Business Factor Not Met! idrRequestModeBusinessFactorNotMet:{3} END", NAMESPACE, CLASS, method, idrRequestModeBusinessFactorNotMet));
                    return idrRequestModeBusinessFactorNotMet;
                }

                // check for and process insufficient info scenario
                if (Common.NullSafeInteger(dsIdrRuleIntegratedResult.Tables[0].Rows[0]["InsufficientInfo"]) == 1)
                {
                    //return insufficient info
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} Returning Insufficient Info! END", NAMESPACE, CLASS, method));
                    throw new UtilityManagementBusinessException(messageId, CODEINSUFFICIENTINFO, "Insufficient Info. : Service Name ('UtilityManagement Wcf WebService.') ");
                }

                throw new UtilityManagementBusinessException(messageId, CODEINSUFFICIENTINFO, "No matches found.");
            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                if (!(exc is UtilityManagementBusinessException))
                {
                    _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exception));
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                    throw;
                }
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }
        #endregion

        public HasPurchaseOfReceivableAssuranceResponse HasPurchaseOfReceivableAssurance(string messageId, int utilityIdInt, string loadProfile, string rateClass, string tariffCode, DateTime porEffectiveDate)
        {
            string method = string.Format("HasPurchaseOfReceivableAssurance(messageId, utilityIdInt:{0}, loadProfile:{1}, rateClass:{2}, tariffCode:{3}, porEffectiveDate:{4})", utilityIdInt, loadProfile, rateClass, tariffCode, porEffectiveDate);

            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                EfToWcfMapping mapper = new EfToWcfMapping();
                _dataRepositoryV3.MessageId = messageId;

                // process legacy utility id
                DataSet dsResponse = _dataRepositoryV3.GetPurchaseOfReceivableAssurance(messageId, utilityIdInt, loadProfile, rateClass, tariffCode, porEffectiveDate);

                if (dsResponse == null)
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} Null Response Generated For Call! END", NAMESPACE, CLASS, method));
                    return new HasPurchaseOfReceivableAssuranceResponse() { MessageId = messageId, Code = "9999", IsSuccess = false, Message = "Null Response For Input Parameters!", HasPurchaseOfReceivableAssuranceList = new List<UtilityManagementServiceData.PurchaseOfReceivable>() };
                }

                HasPurchaseOfReceivableAssuranceResponse returnValue = mapper.ConvertEfPorAssuranceResponseToWcfPorAssuranceResponse(messageId, dsResponse);
                returnValue.Code = "0000";
                returnValue.IsSuccess = true;
                returnValue.Message = string.Empty;

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:[{3}] END", NAMESPACE, CLASS, method, returnValue));
                return returnValue;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public GetBillingTypeWithDefaultResponse GetBillingTypesWithDefault(string messageId, int utilityIdInt, string rateClass, string loadProfile, string tariffCode)
        {
            string method = string.Format("GetBillingTypesWithDefault(messageId, utilityIdInt:{0}, rateClass:{1},loadProfile:{2},, tariffCode:{3})", utilityIdInt, loadProfile, rateClass, tariffCode);

            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                EfToWcfMapping mapper = new EfToWcfMapping();
                _dataRepositoryV3.MessageId = messageId;

                DataSet response = _dataRepositoryV3.GetBillingTypeWithDefault(messageId, utilityIdInt, loadProfile, rateClass, tariffCode);

                if (response == null)
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} Null Response Generated For Call! END", NAMESPACE, CLASS, method));
                    return null;
                }

                var returnValue = mapper.ConvertEfBillingTypeWithDefaultResponseToWcfBillingTypeResponse(messageId, response);
                returnValue.Code = "0000";
                returnValue.IsSuccess = true;
                returnValue.Message = string.Empty;

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:[{3}] END", NAMESPACE, CLASS, method, returnValue));
                return returnValue;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public GetBillingTypeResponse GetBillingTypes(string messageId, int utilityIdInt, string rateClass, string loadProfile, string tariffCode)
        {
            string method = string.Format("GetBillingTypes(messageId, utilityIdInt:{0},  rateClass:{1},loadProfile:{2}, tariffCode:{3})", utilityIdInt, rateClass, loadProfile, tariffCode);

            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                EfToWcfMapping mapper = new EfToWcfMapping();
                _dataRepositoryV3.MessageId = messageId;


                DataSet response = _dataRepositoryV3.GetBillingType(messageId, utilityIdInt, rateClass, loadProfile, tariffCode);

                if (!Common.IsDataSetRowValid(response))
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} Null Response Generated For Call! END", NAMESPACE, CLASS, method));
                    return null;
                }

                var returnValue = mapper.ConvertEfBillingTypeResponseToWcfBillingTypeResponse(messageId, response);
                returnValue.Code = "0000";
                returnValue.IsSuccess = true;
                returnValue.Message = string.Empty;

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:[{3}] END", NAMESPACE, CLASS, method, returnValue));
                return returnValue;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public GetNextMeterReadResponse GetNextMeterRead(string messageId, int utilityIdInt, string tripNumber, DateTime referenceDate)
        {
            string method = string.Format("GetNextMeterRead(messageId, utilityIdInt:{0}, referenceDate:{1})", utilityIdInt, referenceDate);

            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                EfToWcfMapping mapper = new EfToWcfMapping();
                _dataRepository.MessageId = messageId;


                var response = _dataRepository.usp_MeterReadSchedule_GetNext(messageId, utilityIdInt, tripNumber, referenceDate, Guid.NewGuid().ToString());

                if (response == null)
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} Null Response Generated For Call! END", NAMESPACE, CLASS, method));
                    return new GetNextMeterReadResponse() { MessageId = messageId, Code = "9999", IsSuccess = false, Message = "Null Response For Input Parameters!", NextMeterRead = new DateTime(1900, 1, 1) };
                }

                var returnValue = new GetNextMeterReadResponse()
                {
                    Code = "0000",
                    IsSuccess = true,
                    Message = string.Empty,
                    MessageId = messageId,
                    NextMeterRead = (DateTime)response
                };

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:[{3}] END", NAMESPACE, CLASS, method, returnValue));
                return returnValue;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }


        public DateTime? GetNextMeterReadEstimated(string messageId, int utilityIdInt, string tripNumber, DateTime referenceDate, string accountNumber)
        {
            string method = string.Format("GetNextMeterReadEstimated(messageId, utilityIdInt:{0}, tripNumber:{1}, referenceDate:{2}, accountNumber:{3})", utilityIdInt, tripNumber, referenceDate, accountNumber);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                EfToWcfMapping mapper = new EfToWcfMapping();
                _dataRepository.MessageId = messageId;


                var response = _dataRepository.usp_MeterReadSchedule_GetNext(messageId, utilityIdInt, tripNumber, referenceDate, accountNumber);

                if (response == null)
                {
                    response = GetUsageDate(messageId, accountNumber, utilityIdInt);
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:[{3}] END", NAMESPACE, CLASS, method, response == null ? "NULL VALUE" : response.ToString()));
                return (DateTime?)response;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        private UsageDateRequest GenerateServiceAccount(string messageId, string accountNumber, int utilityIdInt)
        {
            string method = string.Format("GenerateServiceAccount(messageId, utilityIdInt:{0}, accountNumber:{1})", utilityIdInt, accountNumber);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                var utility = _dataRepository.UtilityCompanies.Where(x => x.UtilityIdInt == utilityIdInt).FirstOrDefault();
                string utilityCode = utility.UtilityCode;
                UsageDateRequest serviceAccount = new UsageDateRequest()
                {
                    AccountNumber = accountNumber,
                    UtilityId = utility.UtilityIdInt
                };

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} serviceAccount:[{3}] END", NAMESPACE, CLASS, method, serviceAccount == null ? "NULL VALUE" : serviceAccount.ToString()));
                return serviceAccount;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        private DateTime ProcessUsageServiceGetUsageDateResult(string messageId, DateTime usageDate)
        {
            string method = string.Format("ProcessUsageServiceGetUsageDateResult(messageId, usageDate:{0})", usageDate);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                DateTime returnDate;
                DateTime contextDate = DateTime.Now;
                int usageDayOfMonth = usageDate.Day;
                int contextMonth = contextDate.Month;
                int contextYear = contextDate.Year;
                int daysInThisMonth = DateTime.DaysInMonth(contextDate.Year, contextDate.Month);
                int daysInNextMonth = DateTime.DaysInMonth(contextDate.Year, contextDate.Month + 1);
                bool usageDayGreaterThanContextday = usageDayOfMonth > contextDate.Day;
                bool usageDayLessThanOrEqualToDaysInThisMonth = usageDayOfMonth <= daysInThisMonth;
                bool usageDayLessThanOrEqualToDaysInNextMonth = usageDayOfMonth <= daysInNextMonth;
                bool contextMonthIsTwelve = contextMonth == 12;

                if (usageDayGreaterThanContextday)
                {
                    if (usageDayLessThanOrEqualToDaysInThisMonth)
                    {
                        returnDate = new DateTime(contextYear, contextMonth, usageDayOfMonth);
                    }
                    else
                    {
                        returnDate = new DateTime(contextYear, contextMonth + 1, 1);
                    }
                }
                else
                {
                    if (usageDayLessThanOrEqualToDaysInNextMonth)
                    {
                        if (contextMonthIsTwelve)
                        {
                            returnDate = new DateTime(contextYear + 1, 1, usageDayOfMonth);
                        }
                        else
                        {
                            returnDate = new DateTime(contextYear, contextMonth + 1, usageDayOfMonth);
                        }
                    }
                    else
                    {
                        returnDate = new DateTime(contextYear, contextMonth + 2, 1);
                    }
                }
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnDate:[{3}] END", NAMESPACE, CLASS, method, returnDate == null ? "NULL VALUE" : returnDate.ToString()));
                return returnDate;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        private DateTime GetUsageDate(string messageId, string accountNumber, int utilityIdInt)
        {
            string method = string.Format("GetUsageDate(messageId, accountNumber:{0})", accountNumber);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
                DateTime returnDate;
                UsageClient usageClient = new UsageClient();

                UsageDateRequest serviceAccount = GenerateServiceAccount(messageId, accountNumber, utilityIdInt);

                DateTime result = usageClient.GetUsageDate(serviceAccount);

                returnDate = ProcessUsageServiceGetUsageDateResult(messageId, result);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnDate:[{3}] END", NAMESPACE, CLASS, method, returnDate == null ? "NULL VALUE" : returnDate.ToString()));
                return returnDate;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + ":" + exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public IsIdrEligibleRequest GenerateIsIdrEligibleRequest(string messageId, string accountNumber, int utilityId)
        {
            IsIdrEligibleRequest isIdrEligibleRequest = new IsIdrEligibleRequest()
            {
                AccountNumber = accountNumber,
                UtilityId = utilityId
            };
            return isIdrEligibleRequest;
        }

        public IGetAllUtilitiesResponse GetAllUtilities(string messageId)
        {
            string method = "GetAllUtilities(messageId)";

            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                EfToWcfMapping mapper = new EfToWcfMapping();
                _dataRepositoryV3.MessageId = messageId;

                DataSet dsUtilityCompanies = _dataRepositoryV3.GetAllUtilitiesData(messageId);

                _logger.LogDebug("after utilitycompanies");


                IGetAllUtilitiesResponse returnValue = mapper.ConvertEfUtilitiesToGetAllUtilitiesResponse(messageId, dsUtilityCompanies);
                returnValue.Code = "0000";
                returnValue.IsSuccess = true;
                returnValue.Message = string.Empty;

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));
                return returnValue;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + ":" + exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public IGetAllRequestModeEnrollmentTypesResponse GetAllRequestModeEnrollmentTypes(string messageId)
        {
            string method = "GetAllRequestModeEnrollmentTypes(messageId)";

            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                EfToWcfMapping mapper = new EfToWcfMapping();
                _dataRepositoryV3.MessageId = messageId;

                DataSet repositoryRequestModeEnrollmentTypeList = _dataRepositoryV3.GetAllRequestModeEnrollmentTypes(messageId);

                IGetAllRequestModeEnrollmentTypesResponse returnValue = mapper.ConvertEfRequestModeEnrollmentTypesToGetAllRequestModeEnrollmentTypesResponse(messageId, repositoryRequestModeEnrollmentTypeList);
                returnValue.Code = "0000";
                returnValue.IsSuccess = true;
                returnValue.Message = string.Empty;

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));
                return returnValue;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public List<AccountInfoRequiredFields> GetAllUtilityAccountInfoRequiredFields(string messageId)
        {
            string method = "GetAllUtilityAccountInfoRequiredFields(messageId)";

            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                List<AccountInfoRequiredFields> returnValue = new List<AccountInfoRequiredFields>();
                var accountInfoFieldRequiredList = _dataRepositoryV3.GetAllUtilityAccountInfoRequiredFields(messageId);
                var columnNames = accountInfoFieldRequiredList.Tables[0].Columns;
                foreach (DataRow utility in accountInfoFieldRequiredList.Tables[0].Rows)
                {
                    AccountInfoRequiredFields accountInfoRequiredFields = new AccountInfoRequiredFields()
                    {
                        UtilityId = Common.NullSafeInteger(utility["UtilityId"]),
                        UtilityCode = Common.NullSafeString(utility["UtilityCode"]),
                        RequiredFields = new List<string>()
                    };
                    List<string> requiredFields = new List<string>();
                    foreach (DataColumn dc in columnNames)
                    {
                        if (Common.NullSafeString(utility[dc.ColumnName]).ToUpper() == "YES")
                        {
                            requiredFields.Add(dc.ColumnName);
                        }
                    }
                    if (requiredFields != null && requiredFields.Count > 0)
                    {
                        accountInfoRequiredFields.RequiredFields = requiredFields;
                        returnValue.Add(accountInfoRequiredFields);
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));
                return returnValue;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public string GetZoneByUtilityCodeAndZipCodeFromDealCapture(string messageId, string utilityCode, string zipCode)
        {
            string method = string.Format("GetZoneByUtilityCodeAndZipCodeFromDealCapture(messageId,utilityCode:{0},zipCode:{1})", utilityCode, zipCode);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                string returnValue = _dataRepository.GetZoneByUtilityCodeAndZipCodeFromDealCapture(messageId, utilityCode, zipCode);

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));
                return returnValue;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public string GetZoneByAccountNumberFromErcot(string messageId, string accountNumber)
        {
            string method = string.Format("GetZoneByAccountNumberFromErcot(messageId,accountNumber:{0})", accountNumber);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                string returnValue = _dataRepository.GetZoneByAccountNumberFromErcot(messageId, accountNumber);

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));
                return returnValue;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }


        public IGetAllUtilitiesDataResponse GetAllUtilitiesData(string messageId)
        {
            string method = "GetAllUtilitiesData(messageId)";

            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                EfToWcfMapping mapper = new EfToWcfMapping();
                _dataRepositoryV3.MessageId = messageId;
                DataSet dataSet = _dataRepositoryV3.GetAllUtilitiesData(messageId);

                _logger.LogDebug("after utilitycompanies");

                IGetAllUtilitiesDataResponse returnValue = mapper.ConvertEfUtilitiesToGetAllUtilitiesDataResponse(messageId, dataSet);
                returnValue.Code = "0000";
                returnValue.IsSuccess = true;
                returnValue.Message = "Success";

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue END", NAMESPACE, CLASS, method));
                return returnValue;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + ":" + exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public IGetAllUtilitiesAcceleratedSwitchResponse GetAllUtilitiesAcceleratedSwitch(string messageId)
        {
            string method = "GetAllUtilitiesAcceleratedSwitch(messageId)";

            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                EfToWcfMapping mapper = new EfToWcfMapping();
                _dataRepositoryV3.MessageId = messageId;
                DataSet dataSet = _dataRepositoryV3.GetAllUtilitiesAcceleratedSwitchData(messageId);
                IGetAllUtilitiesAcceleratedSwitchResponse returnValue = mapper.ConvertEfUtilitiesToGetallUtilitiesAcceleratedSwitchDataResponse(messageId, dataSet);
                returnValue.Code = "0000";
                returnValue.IsSuccess = true;
                returnValue.Message = "Success";

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue END", NAMESPACE, CLASS, method));
                return returnValue;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + ":" + exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }


        public IGetAllActiveUtilitiesDumpDataResponse GetAllActiveUtilitiesDumpData(string messageId)
        {
            string method = "GetAllActiveUtilitiesDumpData(messageId)";

            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                EfToWcfMapping mapper = new EfToWcfMapping();
                _dataRepository.MessageId = messageId;

                DataSet dataSet = _dataRepository.usp_UtilityGetAllActiveUtilitiesDumpData(messageId);

                _logger.LogDebug("after utilitycompanies");

                IGetAllActiveUtilitiesDumpDataResponse returnValue = mapper.ConvertEfActiveUtilitiesToGetAllUtilitiesDataResponse(messageId, dataSet);
                returnValue.Code = "0000";
                returnValue.IsSuccess = true;
                returnValue.Message = "Success";

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue END", NAMESPACE, CLASS, method));
                return returnValue;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + ":" + exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }
        #endregion


        public GetAllUtilitiesReceiveIdrOnlyResponse GetAllUtiltiesReceiveIdrOnly(string messageId)
        {
            string method = "GetAllUtilitiesReceiveIdrOnly(messageId)";

            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                EfToWcfMapping mapper = new EfToWcfMapping();
                _dataRepository.MessageId = messageId;

                DataSet dataSet = _dataRepository.usp_UtilityCompanyGetAllUtilitiesReceiveIdrOnly(messageId);

                if (!Utilities.Common.IsDataSetRowValid(dataSet))
                {
                    GetAllUtilitiesReceiveIdrOnlyResponse invalidResponse = new GetAllUtilitiesReceiveIdrOnlyResponse()
                    {
                        Code = NOVALUERETURNED,
                        Message = "NO VALUE RETURNED",
                        MessageId = messageId,
                        GetAllUtiltiesReceiveIdrOnlyResponseItems = new List<GetAllUtiltiesReceiveIdrOnlyResponseItem>(),
                        IsSuccess = false
                    };
                    return invalidResponse;
                }

                GetAllUtilitiesReceiveIdrOnlyResponse getAllUtilitiesReceiveIdrOnlyResponse = mapper.ConvertDataSetToGetAllUtilitiesReceiveIdrOnly(messageId, dataSet);

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} getAllUtilitiesReceiveIdrOnlyResponse:{3} END", NAMESPACE, CLASS, method, getAllUtilitiesReceiveIdrOnlyResponse));

                return getAllUtilitiesReceiveIdrOnlyResponse;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}:{4}:{5}", NAMESPACE, CLASS, method, Utilities.Common.NullSafeString(exc.Message), Utilities.Common.NullSafeString(exc.StackTrace), Utilities.Common.NullSafeString(exc.InnerException)));
                GetAllUtilitiesReceiveIdrOnlyResponse returnErrorResponse = new GetAllUtilitiesReceiveIdrOnlyResponse()
                {
                    Code = ERRORCODE,
                    GetAllUtiltiesReceiveIdrOnlyResponseItems = new List<GetAllUtiltiesReceiveIdrOnlyResponseItem>(),
                    IsSuccess = false,
                    Message = "An Application Error Occurred",
                    MessageId = messageId
                };
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnErrorResponse:{3} END", NAMESPACE, CLASS, method, Utilities.Common.NullSafeString(returnErrorResponse)));
                return returnErrorResponse;
            }
        }

        public GetUtilitiesReceiveIdrOnlyByUtilityIdResponse GetUtilitiesReceiveIdrOnlyByUtilityId(string messageId, int utilityId)
        {
            string method = string.Format("GetUtilitiesReceiveIdrOnlyByUtilityId(messageId,utilityId:{0})", utilityId);

            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                EfToWcfMapping mapper = new EfToWcfMapping();
                _dataRepository.MessageId = messageId;

                DataSet dataSet = _dataRepository.usp_UtilityCompanyGetReceiveIdrOnlyByUtilityId(messageId, utilityId);

                if (!Utilities.Common.IsDataSetRowValid(dataSet))
                {
                    GetUtilitiesReceiveIdrOnlyByUtilityIdResponse invalidResponse = new GetUtilitiesReceiveIdrOnlyByUtilityIdResponse()
                    {
                        Code = NOVALUERETURNED,
                        Message = "NO VALUE RETURNED",
                        MessageId = messageId,
                        ReceiveIdrOnlyResponse = false,
                        UtilityId = utilityId,
                        IsSuccess = false
                    };
                    return invalidResponse;
                }
                GetUtilitiesReceiveIdrOnlyByUtilityIdResponse getUtilitiesReceiveIdrOnlyByUtilityIdResponse = mapper.ConvertDataSetToGetUtilitiesReceiveIdrOnlyByUtilityId(messageId, dataSet, utilityId);

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} getUtilitiesReceiveIdrOnlyByUtilityIdResponse:{3} END", NAMESPACE, CLASS, method, getUtilitiesReceiveIdrOnlyByUtilityIdResponse));

                return getUtilitiesReceiveIdrOnlyByUtilityIdResponse;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}:{4}:{5}", NAMESPACE, CLASS, method, Utilities.Common.NullSafeString(exc.Message), Utilities.Common.NullSafeString(exc.StackTrace), Utilities.Common.NullSafeString(exc.InnerException)));
                GetUtilitiesReceiveIdrOnlyByUtilityIdResponse returnErrorResponse = new GetUtilitiesReceiveIdrOnlyByUtilityIdResponse()
                {
                    Code = ERRORCODE,
                    ReceiveIdrOnlyResponse = false,
                    UtilityId = utilityId,
                    IsSuccess = false,
                    Message = "An Application Error Occurred",
                    MessageId = messageId
                };
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnErrorResponse:{3} END", NAMESPACE, CLASS, method, Utilities.Common.NullSafeString(returnErrorResponse)));
                return returnErrorResponse;
            }
        }


        public GetCapacityThresholdRuleResponse GetCapacityThresholdRule(string messageId, string utilityCode, string accountType)
        {
            string method = string.Format("GetCapacityThresholdRule(messageId,utilityCode:{0},accountType:{1})", utilityCode ?? "NULL VALUE", accountType ?? "NULL VALUE");
            GetCapacityThresholdRuleResponse returnValue = new GetCapacityThresholdRuleResponse();

            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                //////////////////////////////////////////////////////
                // validate inputs
                if (string.IsNullOrWhiteSpace(utilityCode))
                {
                    returnValue = new GetCapacityThresholdRuleResponse()
                    {
                        CapacityThreshold = null,
                        CapacityThresholdMax = null,
                        UseCapacityThreshold = null,
                        IsSuccess = false,
                        Code = "7001",
                        Message = "Invalid Input",
                        MessageId = messageId
                    };
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} Validation FAILED, Invalid Input - returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));
                    return returnValue;
                }
                if (string.IsNullOrWhiteSpace(accountType))
                {
                    returnValue = new GetCapacityThresholdRuleResponse()
                    {
                        CapacityThreshold = null,
                        CapacityThresholdMax = null,
                        UseCapacityThreshold = null,
                        IsSuccess = false,
                        Code = "7001",
                        Message = "Invalid Input",
                        MessageId = messageId
                    };
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} Validation FAILED, Invalid Input - returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));
                    return returnValue;
                }
                _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} Inputs Validated", NAMESPACE, CLASS, method));
                //////////////////////////////////////////////////////

                //////////////////////////////////////////////////////
                // initialize variables
                EfToWcfMapping mapper = new EfToWcfMapping();
                _dataRepositoryV3.MessageId = messageId;
                //////////////////////////////////////////////////////

                //////////////////////////////////////////////////////
                // retrieve the data
                DataSet dataSet = _dataRepositoryV3.GetCapacityThresholdRuleGetByUtilityCodeCustomerAccountType(messageId, utilityCode, accountType);
                //////////////////////////////////////////////////////

                //////////////////////////////////////////////////////
                // map the data
                returnValue = mapper.ConvertDataSetToGetCapacityThresholdRuleResponse(messageId, dataSet);
                //////////////////////////////////////////////////////

                //////////////////////////////////////////////////////
                // return the data
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));
                return returnValue;
                //////////////////////////////////////
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}:{4}:{5}", NAMESPACE, CLASS, method, Utilities.Common.NullSafeString(exc.Message), Utilities.Common.NullSafeString(exc.StackTrace), Utilities.Common.NullSafeString(exc.InnerException)));
                returnValue = new GetCapacityThresholdRuleResponse()
                {
                    Code = "9999",
                    CapacityThreshold = null,
                    UseCapacityThreshold = null,
                    CapacityThresholdMax = null,
                    //CapacityThresholdDecimal = null,
                    IsSuccess = false,
                    Message = "A System Error Occurred",
                    MessageId = messageId
                };
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, Utilities.Common.NullSafeString(returnValue)));
                return returnValue;
            }
        }

        public IGetEnrollmentleadTimesDataResponse GetUtilityEnrollmentLeadTimeData(string messageId, int utilityId, string rateClass, string loadProfile, string tariffCode)
        {
            string method = "GetUtilityEnrollmentLeadTimeData( messageId,utilityId, rateClass, loadProfile,tarrifCode)";

            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                EfToWcfMapping mapper = new EfToWcfMapping();
                _dataRepositoryV3.MessageId = messageId;
                DataSet dataSet = _dataRepositoryV3.GetEnrollmentLeadTimeData(messageId, utilityId, rateClass, loadProfile, tariffCode);
                IGetEnrollmentleadTimesDataResponse returnValue = null;
                if (Utilities.Common.IsDataSetRowValid(dataSet))
                {
                    returnValue = mapper.ConvertEfUtilitiesToGetUtilityEnrollmentleadTimeDataResponse(messageId, dataSet);
                    returnValue.Code = "0000";
                    returnValue.IsSuccess = true;
                    returnValue.Message = "Success";
                }
                else
                {
                    returnValue = new GetEnrollmentleadTimesDataResponse();
                    returnValue.Code = NOVALUERETURNED;
                    returnValue.IsSuccess = false;
                    returnValue.Message = "NO VALUE RETURNED";
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue END", NAMESPACE, CLASS, method));
                return returnValue;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + ":" + exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }
    }
}