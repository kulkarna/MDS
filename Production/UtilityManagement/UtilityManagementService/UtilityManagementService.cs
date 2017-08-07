using Microsoft.Practices.Unity;
using Microsoft.Practices.Unity.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;
using Utilities;
using UtilityLogging;
using UtilityUnityLogging;
using UtilityManagementBusinessLayer;
using UtilityManagementServiceData;
using System.ServiceModel.Activation;
using System.ServiceModel.Web;
using System.Runtime.Caching;

namespace UtilityManagementService
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the class name "Service1" in both code and config file together.


    public class UtilityManagementService : IUtilityManagementService
    {
        #region private variables;
        IBusinessLayer _businessLayer = null;
        private const string NAMESPACE = "UtilityManagementService";
        private const string CLASS = "UtilityManagementService";
        private const string NOVALUERETURNED = "4001";
        private const string ERRORMESSAGE = "An Error Occurred While Processing The Service Call";
        private ILogger _logger; private const string ERRORCODE = "9999";
        private const string INVALIDINPUTPARAMETER = "7777";

        private string CacheKey = string.Empty;
        private string CHACHE_EXPIRATION_SECONDS = System.Configuration.ConfigurationManager.AppSettings["CHACHING_EXPIRATION_SECONDS"];
        #endregion


        #region public constructors
        public UtilityManagementService()
        {
            string messageId = Guid.NewGuid().ToString();
            string method = "UtilityManagementService()";
            DateTime beginTime = DateTime.Now;
            try
            {
                _logger = new UtilityLogging.Logger();

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
                _businessLayer = new UtilityManagementBusinessLayer.BusinessLayer();

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                throw;
            }
        }
        #endregion


        #region public methods
        //public GetAllUtilitiesReceiveIdrOnlyResponse GetAllUtiltiesReceiveIdrOnly(string messageId)
        //{
        //    string method = string.Format("GetAllUtiltiesReceiveIdrOnly(messageId:{0})", !string.IsNullOrWhiteSpace(messageId) ? "NULL VALUE" : messageId);
        //    DateTime beginTime = DateTime.Now;
        //    try
        //    {
        //        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

        //        // Validate input parameters
        //        if (string.IsNullOrWhiteSpace(messageId))
        //            messageId = Guid.NewGuid().ToString();

        //        // Check if we can retrieve data from cache
        //        CacheKey = "GetAllUtiltiesReceiveIdrOnly";

        //        ObjectCache cache = MemoryCache.Default;
        //        if (cache.Contains(CacheKey))
        //        {
        //            GetAllUtilitiesReceiveIdrOnlyResponse cacheResponse = (GetAllUtilitiesReceiveIdrOnlyResponse)cache.Get(CacheKey);
        //            _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} cacheResponse:{4} END Method Duration ms:{3}",
        //                NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString(), cacheResponse));

        //            return cacheResponse;
        //        }
        //        else
        //        {

        //            // no cache data, so retrieve from data source
        //            GetAllUtilitiesReceiveIdrOnlyResponse getAllUtilitiesReceiveIdrOnlyResponse = _businessLayer.GetAllUtiltiesReceiveIdrOnly(messageId);

        //            // store result in cache
        //            CacheItemPolicy cacheItemPolicy = new CacheItemPolicy();
        //            cacheItemPolicy.AbsoluteExpiration = DateTime.Now.AddSeconds(Convert.ToInt32(string.IsNullOrEmpty(CHACHE_EXPIRATION_SECONDS) ? "0" : CHACHE_EXPIRATION_SECONDS));
        //            cache.Add(CacheKey, getAllUtilitiesReceiveIdrOnlyResponse, cacheItemPolicy);

        //            // log the result and leave
        //            _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{4} END Method Duration ms:{3}", NAMESPACE, CLASS, method,
        //                DateTime.Now.Subtract(beginTime).Milliseconds.ToString(), getAllUtilitiesReceiveIdrOnlyResponse));
        //            return getAllUtilitiesReceiveIdrOnlyResponse;
        //        }
        //    }
        //    catch (Exception exc)
        //    {
        //        string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
        //        string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
        //        string errorMessage = exception + innerException;
        //        _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));

        //        GetAllUtilitiesReceiveIdrOnlyResponse getAllUtilitiesReceiveIdrOnlyResponse = new GetAllUtilitiesReceiveIdrOnlyResponse()
        //        {
        //            Code = ERRORCODE,
        //            MessageId = messageId,
        //            IsSuccess = false,
        //            Message = exc.Message,
        //            GetAllUtiltiesReceiveIdrOnlyResponseItems = new List<GetAllUtiltiesReceiveIdrOnlyResponseItem>()
        //        };
        //        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{4} END Method Duration ms:{3}", NAMESPACE, CLASS, method,
        //            DateTime.Now.Subtract(beginTime).Milliseconds.ToString(), getAllUtilitiesReceiveIdrOnlyResponse));
        //        return getAllUtilitiesReceiveIdrOnlyResponse;
        //    }
        //}



        //public GetUtilitiesReceiveIdrOnlyByUtilityIdResponse GetUtilitiesReceiveIdrOnlyByUtilityId(string messageId, int utilityId)
        //{
        //    string method = string.Format("GetUtiltiesReceiveIdrOnlyByUtilityId(messageId:{0},utilityId:{1})", !string.IsNullOrWhiteSpace(messageId) ? "NULL VALUE" : messageId, utilityId);
        //    DateTime beginTime = DateTime.Now;
        //    try
        //    {
        //        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

        //        // Validate input parameters
        //        if (string.IsNullOrWhiteSpace(messageId))
        //            messageId = Guid.NewGuid().ToString();

        //        // Check if we can retrieve data from cache
        //        CacheKey = string.Format("GetAllUtiltiesReceiveIdrOnly(messageId,utilityId:{0})", utilityId);
        //        ObjectCache cache = MemoryCache.Default;
        //        if (cache.Contains(CacheKey))
        //        {
        //            GetUtilitiesReceiveIdrOnlyByUtilityIdResponse cacheResponse = (GetUtilitiesReceiveIdrOnlyByUtilityIdResponse)cache.Get(CacheKey);
        //            _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} cacheResponse:{4} END Method Duration ms:{3}",
        //                NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString(), cacheResponse));

        //            return cacheResponse;
        //        }
        //        else
        //        {

        //            // no cache data, so retrieve from data source
        //            GetUtilitiesReceiveIdrOnlyByUtilityIdResponse getUtilitiesReceiveIdrOnlyByUtilityIdResponse = _businessLayer.GetUtilitiesReceiveIdrOnlyByUtilityId(messageId, utilityId);

        //            // store result in cache
        //            CacheItemPolicy cacheItemPolicy = new CacheItemPolicy();
        //            cacheItemPolicy.AbsoluteExpiration = DateTime.Now.AddSeconds(Convert.ToInt32(string.IsNullOrEmpty(CHACHE_EXPIRATION_SECONDS) ? "0" : CHACHE_EXPIRATION_SECONDS));
        //            cache.Add(CacheKey, getUtilitiesReceiveIdrOnlyByUtilityIdResponse, cacheItemPolicy);

        //            // log the result and leave
        //            _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{4} END Method Duration ms:{3}", NAMESPACE, CLASS, method,
        //                DateTime.Now.Subtract(beginTime).Milliseconds.ToString(), getUtilitiesReceiveIdrOnlyByUtilityIdResponse));
        //            return getUtilitiesReceiveIdrOnlyByUtilityIdResponse;
        //        }
        //    }
        //    catch (Exception exc)
        //    {
        //        string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
        //        string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
        //        string errorMessage = exception + innerException;
        //        _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));

        //        GetUtilitiesReceiveIdrOnlyByUtilityIdResponse getUtilitiesReceiveIdrOnlyByUtilityIdResponse = new GetUtilitiesReceiveIdrOnlyByUtilityIdResponse()
        //        {
        //            Code = ERRORCODE,
        //            MessageId = messageId,
        //            IsSuccess = false,
        //            Message = exc.Message,
        //            ReceiveIdrOnlyResponse = false,
        //            UtilityId = utilityId
        //        };
        //        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{4} END Method Duration ms:{3}", NAMESPACE, CLASS, method,
        //            DateTime.Now.Subtract(beginTime).Milliseconds.ToString(), getUtilitiesReceiveIdrOnlyByUtilityIdResponse));
        //        return getUtilitiesReceiveIdrOnlyByUtilityIdResponse;
        //    }
        //}



        public GetPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse GetPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDate(string messageId, int utilityId, string readCycleId, bool isAmr, DateTime inquiryDate)
        {
            string method = string.Format("GetPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDate(messageId:{0},utilityid:{1},readCycleId:{2},isAmr:{3},inquiryDate:{4})",
                !string.IsNullOrWhiteSpace(messageId) ? "NULL VALUE" : messageId, utilityId, Common.NullSafeString(readCycleId), Common.NullSafeString(isAmr), Common.NullSafeDateToString(inquiryDate));
            DateTime beginTime = DateTime.Now;
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                // Validate input parameters
                if (string.IsNullOrWhiteSpace(messageId))
                    messageId = Guid.NewGuid().ToString();
                if (utilityId < 1 || !Common.IsValidString(readCycleId) || !Common.IsValidDate(inquiryDate))
                {
                    GetPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse getPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse = new GetPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse()
                    {
                        Code = INVALIDINPUTPARAMETER,
                        MessageId = messageId,
                        IsSuccess = false,
                        Message = "Invalid Input Parameter Provided -- utilityId >= 1, readCycleId non null and not empty string, inquiryDate must be a valid date.",
                        PreviousMeterReadDate = new DateTime(1900, 1, 1)
                    };
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{4} END Method Duration ms:{3}", NAMESPACE, CLASS, method,
                        DateTime.Now.Subtract(beginTime).Milliseconds.ToString(), getPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse));
                    return getPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse;
                }

                // Check if we can retrieve data from cache
                CacheKey = string.Format("GetPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDate:{0}:{1}:{2}:{3}",
                    Common.NullSafeString(utilityId), Common.NullSafeString(readCycleId), Common.NullSafeString(isAmr), Common.NullSafeDateToString(inquiryDate));
                ObjectCache cache = MemoryCache.Default;
                if (cache.Contains(CacheKey))
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} getPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse:{4} END Method Duration ms:{3}",
                        NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString(),
                        (GetPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse)cache.Get(CacheKey)));
                    return (GetPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse)cache.Get(CacheKey);
                }
                else
                {

                    // no cache data, so retrieve from data source
                    GetPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse getPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse =
                        _businessLayer.GetPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDate(messageId, utilityId, readCycleId, isAmr, inquiryDate);

                    // store result in cache
                    CacheItemPolicy cacheItemPolicy = new CacheItemPolicy();
                    cacheItemPolicy.AbsoluteExpiration = DateTime.Now.AddSeconds(Convert.ToInt32(string.IsNullOrEmpty(CHACHE_EXPIRATION_SECONDS) ? "0" : CHACHE_EXPIRATION_SECONDS));
                    cache.Add(CacheKey, getPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse, cacheItemPolicy);

                    // log the result and leave
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{4} END Method Duration ms:{3}", NAMESPACE, CLASS, method,
                        DateTime.Now.Subtract(beginTime).Milliseconds.ToString(), getPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse));
                    return getPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse;
                }
            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));

                GetPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse getPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse = new GetPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse()
                {
                    Code = ERRORCODE,
                    MessageId = messageId,
                    IsSuccess = false,
                    Message = exc.Message,
                    PreviousMeterReadDate = new DateTime(1900, 1, 1)
                };
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{4} END Method Duration ms:{3}", NAMESPACE, CLASS, method,
                    DateTime.Now.Subtract(beginTime).Milliseconds.ToString(), getPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse));
                return getPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse;
            }
        }



        public GetNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse GetNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDate(string messageId, int utilityId, string readCycleId, bool isAmr, DateTime inquiryDate)
        {
            string method = string.Format("GetNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDate(messageId:{0},utilityid:{1},readCycleId:{2},isAmr:{3},inquiryDate:{4})",
                !string.IsNullOrWhiteSpace(messageId) ? "NULL VALUE" : messageId, utilityId, Common.NullSafeString(readCycleId), Common.NullSafeString(isAmr), Common.NullSafeDateToString(inquiryDate));
            DateTime beginTime = DateTime.Now;
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                // Validate input parameters
                if (string.IsNullOrWhiteSpace(messageId))
                    messageId = Guid.NewGuid().ToString();
                if (utilityId < 1 || !Common.IsValidString(readCycleId) || !Common.IsValidDate(inquiryDate))
                {
                    GetNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse getNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse = new GetNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse()
                    {
                        Code = INVALIDINPUTPARAMETER,
                        MessageId = messageId,
                        IsSuccess = false,
                        Message = "Invalid Input Parameter Provided -- utilityId >= 1, readCycleId non null and not empty string, inquiryDate must be a valid date.",
                        NextMeterReadDate = new DateTime(1900, 1, 1)
                    };
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{4} END Method Duration ms:{3}", NAMESPACE, CLASS, method,
                        DateTime.Now.Subtract(beginTime).Milliseconds.ToString(), getNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse));
                    return getNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse;
                }

                // Check if we can retrieve data from cache
                CacheKey = string.Format("GetNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDate:{0}:{1}:{2}:{3}",
                    Common.NullSafeString(utilityId), Common.NullSafeString(readCycleId), Common.NullSafeString(isAmr), Common.NullSafeDateToString(inquiryDate));
                ObjectCache cache = MemoryCache.Default;
                if (cache.Contains(CacheKey))
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} getNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse:{4} END Method Duration ms:{3}",
                        NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString(),
                        (GetNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse)cache.Get(CacheKey)));
                    return (GetNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse)cache.Get(CacheKey);
                }
                else
                {

                    // no cache data, so retrieve from data source
                    GetNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse getNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse =
                        _businessLayer.GetNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDate(messageId, utilityId, readCycleId, isAmr, inquiryDate);

                    // store result in cache
                    CacheItemPolicy cacheItemPolicy = new CacheItemPolicy();
                    cacheItemPolicy.AbsoluteExpiration = DateTime.Now.AddSeconds(Convert.ToInt32(string.IsNullOrEmpty(CHACHE_EXPIRATION_SECONDS) ? "0" : CHACHE_EXPIRATION_SECONDS));
                    cache.Add(CacheKey, getNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse, cacheItemPolicy);

                    // log the result and leave
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{4} END Method Duration ms:{3}", NAMESPACE, CLASS, method,
                        DateTime.Now.Subtract(beginTime).Milliseconds.ToString(), getNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse));
                    return getNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse;
                }
            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));

                GetNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse getNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse = new GetNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse()
                {
                    Code = ERRORCODE,
                    MessageId = messageId,
                    IsSuccess = false,
                    Message = exc.Message,
                    NextMeterReadDate = new DateTime(1900, 1, 1)
                };
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{4} END Method Duration ms:{3}", NAMESPACE, CLASS, method,
                    DateTime.Now.Subtract(beginTime).Milliseconds.ToString(), getNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse));
                return getNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse;
            }
        }


        public GetMeterReadCalendarByUtilityIdResponse GetMeterReadCalendarByUtilityId(string messageId, int utilityId)
        {
            string method = string.Format("GetMeterReadCalendarByUtilityId(messageId,utilityid:{0})", utilityId);
            DateTime beginTime = DateTime.Now;
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
                if (string.IsNullOrWhiteSpace(messageId))
                {
                    messageId = Guid.NewGuid().ToString();
                }

                CacheKey = method;
                ObjectCache cache = MemoryCache.Default;
                if (cache.Contains(CacheKey))
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} getMeterReadCalendarByUtilityIdResponse END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                    return (GetMeterReadCalendarByUtilityIdResponse)cache.Get(CacheKey);
                }
                else
                {
                    GetMeterReadCalendarByUtilityIdResponse getMeterReadCalendarByUtilityIdResponse = _businessLayer.GetMeterReadCalendarByUtilityId(messageId, utilityId);
                    CacheItemPolicy cacheItemPolicy = new CacheItemPolicy();
                    cacheItemPolicy.AbsoluteExpiration = DateTime.Now.AddSeconds(Convert.ToInt32(string.IsNullOrEmpty(CHACHE_EXPIRATION_SECONDS) ? "0" : CHACHE_EXPIRATION_SECONDS));
                    cache.Add(CacheKey, getMeterReadCalendarByUtilityIdResponse, cacheItemPolicy);
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} getMeterReadCalendarByUtilityIdResponse END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                    return getMeterReadCalendarByUtilityIdResponse;
                }
            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                var response = _businessLayer.GetErrorMessageResponse(messageId);
                GetMeterReadCalendarByUtilityIdResponse getMeterReadCalendarByUtilityIdResponse = (GetMeterReadCalendarByUtilityIdResponse)response;
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} getMeterReadCalendarByUtilityIdResponse:{4} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString(), getMeterReadCalendarByUtilityIdResponse));
                return getMeterReadCalendarByUtilityIdResponse;
            }
        }


        public int GetUtilityIdByUtilityCode(string messageId, string utilityCode)
        {
            string method = string.Format("GetUtilityIdByUtilityCode(messageId:{0}, utilityCode:{1})", !string.IsNullOrWhiteSpace(messageId) ? "NULL VALUE" : messageId, Common.NullSafeString(utilityCode));
            DateTime beginTime = DateTime.Now;
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (string.IsNullOrWhiteSpace(messageId))
                    messageId = Guid.NewGuid().ToString();
                CacheKey = string.Format("GetUtilityIdByUtilityCode:{0}", utilityCode);
                ObjectCache cache = MemoryCache.Default;
                if (cache.Contains(CacheKey))
                    return (int)cache.Get(CacheKey);
                else
                {
                    var response = _businessLayer.GetUtilityIdByUtilityCode(messageId, utilityCode);
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} response:{4} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString(), response));
                    CacheItemPolicy cacheItemPolicy = new CacheItemPolicy();
                    cacheItemPolicy.AbsoluteExpiration = DateTime.Now.AddSeconds(Convert.ToInt32(string.IsNullOrEmpty(CHACHE_EXPIRATION_SECONDS) ? "0" : CHACHE_EXPIRATION_SECONDS));
                    cache.Add(CacheKey, response, cacheItemPolicy);
                    return response;
                }
            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                UtilityManagementException ume = new UtilityManagementException(messageId, ERRORCODE, ERRORMESSAGE);
                throw new FaultException<UtilityManagementException>(ume, ume.Message);
            }
        }


        public string GetUtilityCodeByUtilityId(string messageId, int utilityId)
        {
            string method = string.Format("GetAllUtilities(messageId:{0})", !string.IsNullOrWhiteSpace(messageId) ? "NULL VALUE" : messageId);
            DateTime beginTime = DateTime.Now;
            var response = string.Empty;
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
                CacheKey = string.Format("GetUtilityCodeByUtilityId:{0}", utilityId);
                ObjectCache cache = MemoryCache.Default;
                if (cache.Contains(CacheKey))
                    response = (string)cache.Get(CacheKey);
                else
                {
                    if (string.IsNullOrWhiteSpace(messageId))
                        messageId = Guid.NewGuid().ToString();
                    response = _businessLayer.GetUtilityCodeByUtilityId(messageId, utilityId);
                    CacheItemPolicy cacheItemPolicy = new CacheItemPolicy();
                    cacheItemPolicy.AbsoluteExpiration = DateTime.Now.AddSeconds(Convert.ToInt32(string.IsNullOrEmpty(CHACHE_EXPIRATION_SECONDS) ? "0" : CHACHE_EXPIRATION_SECONDS));
                    cache.Add(CacheKey, response, cacheItemPolicy);

                }
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} response:{3} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                return response;
            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                UtilityManagementException ume = new UtilityManagementException(messageId, ERRORCODE, ERRORMESSAGE);
                throw new FaultException<UtilityManagementException>(ume, ume.Message);
            }
        }


        public string GetData(int value) { return Guid.NewGuid().ToString(); }

        public GetAllUtilitiesResponse GetAllUtilities(string messageId)
        {
            string method = string.Format("GetAllUtilities(messageId:{0})", !string.IsNullOrWhiteSpace(messageId) ? "NULL VALUE" : messageId);
            DateTime beginTime = DateTime.Now;
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (string.IsNullOrWhiteSpace(messageId))
                    messageId = Guid.NewGuid().ToString();
                var response = _businessLayer.GetAllUtilities(messageId);
                GetAllUtilitiesResponse getAllUtilitiesResponse = (GetAllUtilitiesResponse)response;

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} getAllUtilitiesResponse:{4} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString(), getAllUtilitiesResponse));
                return getAllUtilitiesResponse;
            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                UtilityManagementException ume = new UtilityManagementException(messageId, ERRORCODE, ERRORMESSAGE);
                throw new FaultException<UtilityManagementException>(ume, ume.Message);
            }
        }


        public GetAllUtilitiesDataResponse GetAllUtilitiesData(string messageId)
        {
            string method = string.Format("GetAllUtilitiesData(messageId:{0})", !string.IsNullOrWhiteSpace(messageId) ? "NULL VALUE" : messageId);
            DateTime beginTime = DateTime.Now;
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
                //CacheKey = method;
                CacheKey = "GetAllUtilitiesData";
                ObjectCache cache = MemoryCache.Default;
                if (cache.Contains(CacheKey))
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} getAllUtilitiesDataResponse END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                    return (GetAllUtilitiesDataResponse)cache.Get(CacheKey);

                }
                else
                {
                    if (string.IsNullOrWhiteSpace(messageId))
                        messageId = Guid.NewGuid().ToString();
                    GetAllUtilitiesDataResponse response = (GetAllUtilitiesDataResponse)_businessLayer.GetAllUtilitiesData(messageId);
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} response END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                    CacheItemPolicy cacheItemPolicy = new CacheItemPolicy();
                    cacheItemPolicy.AbsoluteExpiration = DateTime.Now.AddSeconds(Convert.ToInt32(string.IsNullOrEmpty(CHACHE_EXPIRATION_SECONDS) ? "0" : CHACHE_EXPIRATION_SECONDS));
                    cache.Add(CacheKey, response, cacheItemPolicy);
                    return response;
                }

            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                UtilityManagementException ume = new UtilityManagementException(messageId, ERRORCODE, ERRORMESSAGE);
                throw new FaultException<UtilityManagementException>(ume, ume.Message);
            }
        }

        public GetAllUtilitiesResponse GetAllUtilitiesNoTrace()
        {
            string messageId = Guid.NewGuid().ToString();
            string method = "GetAllUtilitiesNoTrace()";
            DateTime beginTime = DateTime.Now;
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));


                GetAllUtilitiesResponse getAllUtilitiesResponse = GetAllUtilities(messageId);

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} getAllUtilitiesResponse:{4} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString(), getAllUtilitiesResponse));
                return getAllUtilitiesResponse;
            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                UtilityManagementException ume = new UtilityManagementException(messageId, ERRORCODE, ERRORMESSAGE);
                _logger.LogError(messageId, string.Format("Throwing Fault Exception: Code:{0}; Message:{1}", ume.Code ?? "", ume.Message ?? ""));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                throw new FaultException<UtilityManagementException>(ume, ume.Message);
            }
        }

        public GetAllRequestModeEnrollmentTypesResponse GetAllRequestModeEnrollmentTypes(string messageId)
        {
            string method = string.Format("GetAllRequestModeEnrollmentTypes(messageId:{0})", !string.IsNullOrWhiteSpace(messageId) ? "NULL VALUE" : messageId);
            DateTime beginTime = DateTime.Now;
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (string.IsNullOrWhiteSpace(messageId))
                    messageId = Guid.NewGuid().ToString();

                GetAllRequestModeEnrollmentTypesResponse getAllRequestModeEnrollmentTypesResponse = (GetAllRequestModeEnrollmentTypesResponse)_businessLayer.GetAllRequestModeEnrollmentTypes(messageId);

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} getAllRequestModeEnrollmentTypesResponse:{4} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString(), getAllRequestModeEnrollmentTypesResponse.ToString()));
                return getAllRequestModeEnrollmentTypesResponse;
            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                UtilityManagementException ume = new UtilityManagementException(messageId, ERRORCODE, ERRORMESSAGE);
                _logger.LogError(messageId, string.Format("Throwing Fault Exception: Code:{0}; Message:{1}", ume.Code ?? "", ume.Message ?? ""));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                throw new FaultException<UtilityManagementException>(ume, ume.Message);
            }
        }

        public GetAllRequestModeEnrollmentTypesResponse GetAllRequestModeEnrollmentTypesNoTrace()
        {
            string messageId = Guid.NewGuid().ToString();
            string method = "GetAllRequestModeEnrollmentTypesNoTrace()";
            DateTime beginTime = DateTime.Now;
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));


                GetAllRequestModeEnrollmentTypesResponse getAllRequestModeEnrollmentTypesResponse = GetAllRequestModeEnrollmentTypes(messageId);

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} getAllRequestModeEnrollmentTypesResponse:{4} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString(), getAllRequestModeEnrollmentTypesResponse.ToString()));
                return getAllRequestModeEnrollmentTypesResponse;
            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                UtilityManagementException ume = new UtilityManagementException(messageId, ERRORCODE, ERRORMESSAGE);
                _logger.LogError(messageId, string.Format("Throwing Fault Exception: Code:{0}; Message:{1}", ume.Code ?? "", ume.Message ?? ""));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                throw new FaultException<UtilityManagementException>(ume, ume.Message);
            }
        }


        public RequestMode GetHURequestMode(int utilityId, EnrollmentType enrollmentType)
        {
            string method = string.Format("GetHistoricalUsageRequestModes(utilityId:{0},enrollmentType:{1})", utilityId, enrollmentType.ToString());
            string messageId = Guid.NewGuid().ToString();
            DateTime beginTime = DateTime.Now;
            try
            {

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
                RequestMode requestMode = null;
                CacheKey = method;
                ObjectCache cache = MemoryCache.Default;
                if (cache.Contains(CacheKey))
                    requestMode = (RequestMode)cache.Get(CacheKey);
                else
                {
                    // validate input parameters
                    if (utilityId < 1)
                    {
                        _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR Invalid Input Parameter: utilityId!", NAMESPACE, CLASS, method));
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                        UtilityManagementException ume = new UtilityManagementException(messageId, INVALIDINPUTPARAMETER, "Invalid Input Parameter: utilityId!");
                        throw new FaultException<UtilityManagementException>(ume, ume.Message);
                    }

                    // call business layer method
                    requestMode = _businessLayer.GetHURequestMode(messageId, utilityId, enrollmentType);
                    // validate response
                    if (requestMode == null)
                    {
                        string utility = utilityId.ToString();
                        var utilities = _businessLayer.GetAllUtilities(messageId);
                        if (utilities.IsSuccess && utilities.Utilities != null)
                        {
                            foreach (var util in utilities.Utilities)
                            {
                                if (util.UtilityIdInt == utilityId)
                                {
                                    utility = util.UtilityCode;
                                    break;
                                }
                            }
                        }
                        UtilityManagementException ume = new UtilityManagementException(messageId, NOVALUERETURNED, string.Format("HU Request Mode for Utility {0} is not configured for Type {1}", utility, enrollmentType.ToString()));
                        throw new FaultException<UtilityManagementException>(ume, ume.Message);
                    }
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} requestMode:{4} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString(), requestMode.ToString()));
                    CacheItemPolicy cacheItemPolicy = new CacheItemPolicy();
                    cacheItemPolicy.AbsoluteExpiration = DateTime.Now.AddSeconds(Convert.ToInt32(string.IsNullOrEmpty(CHACHE_EXPIRATION_SECONDS) ? "0" : CHACHE_EXPIRATION_SECONDS));
                    cache.Add(CacheKey, requestMode, cacheItemPolicy);

                }
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR No Value Returned", NAMESPACE, CLASS, method));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                return requestMode;
            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                if (exc is UtilityManagementBusinessException)
                {
                    UtilityManagementBusinessException umbe = (UtilityManagementBusinessException)exc;
                    UtilityManagementException ume = new UtilityManagementException(messageId, umbe.Code, umbe.Message);
                    _logger.LogError(messageId, string.Format("Throwing Fault Exception: Code:{0}; Message:{1}", ume.Code ?? "", ume.Message ?? ""));
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                    throw new FaultException<UtilityManagementException>(ume, ume.Message);
                }
                if (!(exc is FaultException<UtilityManagementException>))
                {
                    UtilityManagementException umexc = new UtilityManagementException(messageId, NOVALUERETURNED, "No Value Returned!");
                    _logger.LogError(messageId, string.Format("Throwing Fault Exception: Code:{0}; Message:{1}", umexc.Code ?? "", umexc.Message ?? ""));
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                    throw new FaultException<UtilityManagementException>(umexc, umexc.Message);
                }
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                throw;
            }
        }


        public RequestMode GetAIRequestMode(int utilityId, EnrollmentType enrollmentType)
        {
            string method = string.Format("GetAIRequestMode(utilityId:{0},enrollmentType:{1})", utilityId, enrollmentType.ToString());
            string messageId = Guid.NewGuid().ToString();
            DateTime beginTime = DateTime.Now;
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                RequestMode requestMode = null;

                CacheKey = method;
                ObjectCache cache = MemoryCache.Default;
                if (cache.Contains(CacheKey))
                    requestMode = (RequestMode)cache.Get(CacheKey);
                else
                {
                    // validate input parameters
                    if (utilityId < 1)
                    {
                        _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR Invalid Input Parameter: utilityId!", NAMESPACE, CLASS, method));
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                        UtilityManagementException ume = new UtilityManagementException(messageId, INVALIDINPUTPARAMETER, "Invalid Input Parameter: utilityId!");
                        throw new FaultException<UtilityManagementException>(ume, ume.Message);
                    }
                    // call business layer method
                    requestMode = _businessLayer.GetIcapRequestModeData(messageId, utilityId, enrollmentType);
                    // validate response
                    if (requestMode == null)
                    {
                        string utility = utilityId.ToString();
                        
                        _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR No Value Returned", NAMESPACE, CLASS, method));
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                        UtilityManagementException ume = new UtilityManagementException(messageId, NOVALUERETURNED, string.Format("I-Cap Request Mode for Utility {0} is not configured for Type {1}", utility, enrollmentType));
                        throw new FaultException<UtilityManagementException>(ume, ume.Message);
                    }
                    CacheItemPolicy cacheItemPolicy = new CacheItemPolicy();
                    cacheItemPolicy.AbsoluteExpiration = DateTime.Now.AddSeconds(Convert.ToInt32(string.IsNullOrEmpty(CHACHE_EXPIRATION_SECONDS) ? "0" : CHACHE_EXPIRATION_SECONDS));
                    cache.Add(CacheKey, requestMode, cacheItemPolicy);
                }
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} requestMode:{4} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString(), requestMode));
                return requestMode;
            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                if (exc is UtilityManagementBusinessException)
                {
                    UtilityManagementBusinessException umbe = (UtilityManagementBusinessException)exc;
                    UtilityManagementException ume = new UtilityManagementException(messageId, umbe.Code, umbe.Message);
                    _logger.LogError(messageId, string.Format("Throwing Fault Exception: Code:{0}; Message:{1}", ume.Code ?? "", ume.Message ?? ""));
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                    throw new FaultException<UtilityManagementException>(ume, new FaultReason(ume.Message));
                }
                if (!(exc is FaultException<UtilityManagementException>))
                {
                    UtilityManagementException umexc = new UtilityManagementException(messageId, ERRORCODE, ERRORMESSAGE);
                    _logger.LogError(messageId, string.Format("Throwing Fault Exception: Code:{0}; Message:{1}", umexc.Code ?? "", umexc.Message ?? ""));
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                    throw new FaultException<UtilityManagementException>(umexc, new FaultReason(umexc.Message));
                }
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                throw;
            }
        }


        public IdrRequestMode GetIDRRequestModeData(string messageId, int utilityId, string serviceAccount, EnrollmentType enrollmentType, string loadProfile, string rateClass, string tariffCode, int? annualUsage, bool hasEligibilityRuleBeenSatisfied, bool hia)
        {
            string method = string.Format("GetIDRRequestMode(messageId,utilityId:{0},serviceAccount:{1},enrollmentType:{2},loadProfile:{3},rateClass:{4},tariffCode:{5},annualUsage:{6},hasEligibilityRuleBeenSatisfied:{7},hia:{8})",
                utilityId, serviceAccount, enrollmentType, loadProfile, rateClass, tariffCode, annualUsage, hasEligibilityRuleBeenSatisfied, hia);
            DateTime beginTime = DateTime.Now;
            IdrRequestMode idrRequestMode = null;
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
                CacheKey = method;
                ObjectCache cache = MemoryCache.Default;
                if (cache.Contains(CacheKey))
                {
                    idrRequestMode = (IdrRequestMode)cache.Get(CacheKey);
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} idrRequestMode:{4} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString(), idrRequestMode));
                }
                else
                {
                    // validate input parameters
                    if (utilityId < 1)
                    {
                        _logger.LogError(string.Format("{0}.{1}.{2} ERROR Null Input Parameter", NAMESPACE, CLASS, method));
                        _logger.LogInfo(string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                        UtilityManagementException ume = new UtilityManagementException(messageId, INVALIDINPUTPARAMETER, "Invalid Input Parameter: utilityId!");
                        throw new FaultException<UtilityManagementException>(ume, ume.Message);
                    }
                    _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} utilityId > 0", NAMESPACE, CLASS, method));
                    if (string.IsNullOrWhiteSpace(serviceAccount))
                    {
                        _logger.LogError(string.Format("{0}.{1}.{2} ERROR Null or Whitespace Input Parameter", NAMESPACE, CLASS, method));
                        _logger.LogInfo(string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                        UtilityManagementException ume = new UtilityManagementException(messageId, INVALIDINPUTPARAMETER, "Invalid Input Parameter: serviceAccount!");
                        throw new FaultException<UtilityManagementException>(ume, ume.Message);
                    }
                    _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} serviceAccount is not null", NAMESPACE, CLASS, method));

                    // call the method
                    _logger.LogDebug(string.Format("{0}.{1}.{2} Calling GetIdrRequestModeData", NAMESPACE, CLASS, method));
                    idrRequestMode = _businessLayer.GetIdrRequestModeData(messageId, utilityId, serviceAccount, enrollmentType, loadProfile, rateClass, tariffCode, annualUsage, hasEligibilityRuleBeenSatisfied, hia);
                    _logger.LogDebug(string.Format("{0}.{1}.{2} GetIdrRequestModeData Called", NAMESPACE, CLASS, method));

                    if (idrRequestMode == null)
                    {
                        idrRequestMode = new IdrRequestMode() { IsProhibited = true, Address = string.Empty, EmailTemplate = string.Empty, EnrollmentType = 0, Instructions = string.Empty, IsLoaRequired = false, LibertyPowerSlaResponse = 0, RequestModeType = string.Empty, UtilityId = utilityId, UtilitySlaResponse = 0 };
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2}  idrRequestMode:{4} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString(), idrRequestMode));
                        return idrRequestMode;
                    }

                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} idrRequestMode:{4} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString(), idrRequestMode));
                    CacheItemPolicy cacheItemPolicy = new CacheItemPolicy();
                    cacheItemPolicy.AbsoluteExpiration = DateTime.Now.AddSeconds(Convert.ToInt32(string.IsNullOrEmpty(CHACHE_EXPIRATION_SECONDS) ? "0" : CHACHE_EXPIRATION_SECONDS));
                    cache.Add(CacheKey, idrRequestMode, cacheItemPolicy);
                }
                return idrRequestMode;
            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                if (exc is UtilityManagementBusinessException)
                {
                    UtilityManagementBusinessException umbe = (UtilityManagementBusinessException)exc;
                    UtilityManagementException ume = new UtilityManagementException(messageId, umbe.Code, umbe.Message);
                    _logger.LogError(messageId, string.Format("Throwing Fault Exception: Code:{0}; Message:{1}", ume.Code ?? "", ume.Message ?? ""));
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                    throw new FaultException<UtilityManagementException>(ume, ume.Message);
                }
                if (!(exc is FaultException<UtilityManagementException>))
                {
                    UtilityManagementException umexc = new UtilityManagementException(messageId, ERRORCODE, ERRORMESSAGE);
                    _logger.LogError(messageId, string.Format("Throwing Fault Exception: Code:{0}; Message:{1}", umexc.Code ?? "", umexc.Message ?? ""));
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                    throw new FaultException<UtilityManagementException>(umexc, umexc.Message);
                }
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                throw;
            }
        }


        public bool HasPorAssurance(int utilityId, string rateClass, string loadProfile, string tariffCode, BillingType billingType)
        {
            string method = string.Format("HasPorAssurance(utilityId:{0},rateClass:{1},loadProfile:{2},tariffCode:{3},billingType:{4}) currentDate:{5}", utilityId, rateClass ?? "NULL VALUE", loadProfile ?? "NULL VALUE", tariffCode ?? "NULL VALUE", billingType, DateTime.Now);
            string messageId = Guid.NewGuid().ToString();
            DateTime beginTime = DateTime.Now;
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                bool returnValue = false;

                if (billingType == BillingType.BillReady || billingType == BillingType.RateReady)
                {
                    HasPurchaseOfReceivableAssuranceResponse response = _businessLayer.HasPurchaseOfReceivableAssurance(messageId, utilityId, loadProfile, rateClass, tariffCode, DateTime.Now);

                    if (response != null && response.HasPurchaseOfReceivableAssuranceList != null && response.HasPurchaseOfReceivableAssuranceList.Count > 0)
                    {
                        if (response.HasPurchaseOfReceivableAssuranceList.Count == 1)
                            returnValue = response.HasPurchaseOfReceivableAssuranceList[0].IsPorAssurance;
                        else // Two records were returned
                        {
                            bool firstRec = response.HasPurchaseOfReceivableAssuranceList[0].IsPorAssurance;
                            bool secondRec = response.HasPurchaseOfReceivableAssuranceList[1].IsPorAssurance;

                            returnValue = (firstRec == secondRec && firstRec) ? true : false;   
                        }
                    }                  
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{4} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString(), returnValue));
                return returnValue;
            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                UtilityManagementException umexc = new UtilityManagementException(messageId, ERRORCODE, ERRORMESSAGE);
                _logger.LogError(messageId, string.Format("Throwing Fault Exception: Code:{0}; Message:{1}", umexc.Code ?? "", umexc.Message ?? ""));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                throw new FaultException<UtilityManagementException>(umexc, umexc.Message);
            }
        }

        //public HasPurchaseOfReceivableAssuranceResponse PorAssurance(int utilityId, string rateClass, string loadProfile, string tariffCode, DateTime effectiveDate)
        //{
        //    string method = string.Format("HasPorAssurance(utilityId:{0},rateClass:{1},loadProfile:{2},tariffCode:{3},effectiveDate:{4})", utilityId, rateClass ?? "NULL VALUE", loadProfile ?? "NULL VALUE", tariffCode ?? "NULL VALUE", effectiveDate);
        //    string messageId = Guid.NewGuid().ToString();
        //    DateTime beginTime = DateTime.Now;
        //    try
        //    {
        //        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

        //        HasPurchaseOfReceivableAssuranceResponse response = _businessLayer.HasPurchaseOfReceivableAssurance(messageId, utilityId, loadProfile, rateClass, tariffCode, DateTime.Now);

        //        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} response:{4} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString(), response.ToString()));
        //        return response;
        //    }
        //    catch (Exception exc)
        //    {
        //        string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
        //        string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
        //        string errorMessage = exception + innerException;
        //        _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
        //        UtilityManagementException umexc = new UtilityManagementException(messageId, ERRORCODE, ERRORMESSAGE);
        //        _logger.LogError(messageId, string.Format("Throwing Fault Exception: Code:{0}; Message:{1}", umexc.Code ?? "", umexc.Message ?? ""));
        //        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
        //        throw new FaultException<UtilityManagementException>(umexc, umexc.Message);
        //    }
        //}


        public GetBillingTypeResponse GetBillingTypes(int utilityId, string rateClass, string loadProfile, string tariffCode)
        {
            string method = string.Format("GetBillingTypes(utilityId:{0},rateClass:{1},loadProfile:{2},tariffCode:{3})", utilityId, rateClass ?? "NULL VALUE", loadProfile ?? "NULL VALUE", tariffCode ?? "NULL VALUE");
            string messageId = Guid.NewGuid().ToString();
            DateTime beginTime = DateTime.Now;
            try
            {
                _logger.LogInfo(string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                // validate input parameters
                if (utilityId < 1)
                {
                    _logger.LogError(string.Format("{0}.{1}.{2} ERROR Invalid Utility Id Parameter", NAMESPACE, CLASS, method));
                    _logger.LogInfo(string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                    UtilityManagementException ume = new UtilityManagementException(messageId, INVALIDINPUTPARAMETER, "Invalid Input: utilityId");
                    throw new FaultException<UtilityManagementException>(ume, ume.Message);
                }
                //if (string.IsNullOrWhiteSpace(rateClass) && string.IsNullOrWhiteSpace(loadProfile) && string.IsNullOrWhiteSpace(tariffCode))
                //{
                //    _logger.LogError(string.Format("{0}.{1}.{2} ERROR No Value Specified For LoadProfile, RateClass And TariffCode", NAMESPACE, CLASS, method));
                //    _logger.LogInfo(string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                //    UtilityManagementException ume = new UtilityManagementException(messageId, INVALIDINPUTPARAMETER, "Invalid Input: LoadProfile, RateClass, TariffCode");
                //    throw new FaultException<UtilityManagementException>(ume, ume.Message);
                //}

                GetBillingTypeResponse billingTypeResponse = _businessLayer.GetBillingTypes(messageId, utilityId,rateClass,loadProfile, tariffCode);

                if (billingTypeResponse == null || billingTypeResponse.LstBillingTypeResponseItem.Count < 1)
                {
                    _logger.LogError(string.Format("{0}.{1}.{2} ERROR No Value Returned For UtilityId, RateClass, LoadProfile And TariffCode", NAMESPACE, CLASS, method));
                    _logger.LogInfo(string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                    UtilityManagementException ume = new UtilityManagementException(messageId, NOVALUERETURNED, "No billing types defined");
                    throw new FaultException<UtilityManagementException>(ume, ume.Message);
                }

                StringBuilder logData = new StringBuilder("BillingTypeList:[");
                foreach (GetBillingTypeResponseitem billingType in billingTypeResponse.LstBillingTypeResponseItem)
                {
                    logData.Append(string.Format("BillingType:{0};AccountType:{1}", billingType.BillingType,billingType.AccountType));
                }
                logData = new StringBuilder("]");

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} billingTypeList:{4} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString(), logData.ToString()));
                return billingTypeResponse;
            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                if (exc is UtilityManagementBusinessException)
                {
                    UtilityManagementBusinessException umbe = (UtilityManagementBusinessException)exc;
                    UtilityManagementException ume = new UtilityManagementException(messageId, umbe.Code, umbe.Message);
                    _logger.LogError(messageId, string.Format("Throwing Fault Exception: Code:{0}; Message:{1}", ume.Code ?? "", ume.Message ?? ""));
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                    throw new FaultException<UtilityManagementException>(ume, ume.Message);
                }
                if (!(exc is FaultException<UtilityManagementException>))
                {
                    UtilityManagementException umexc = new UtilityManagementException(messageId, ERRORCODE, ERRORMESSAGE);
                    _logger.LogError(messageId, string.Format("Throwing Fault Exception: Code:{0}; Message:{1}", umexc.Code ?? "", umexc.Message ?? ""));
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                    throw new FaultException<UtilityManagementException>(umexc, umexc.Message);
                }
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                throw;
            }
        }

        /// <summary>
        /// Added By Vikas Sharma PBI 124161
        /// </summary>
        /// method name GetBillingTypesWithDefault
        /// <param name="utilityId"></param>
        /// <param name="rateClass"></param>
        /// <param name="loadProfile"></param>
        /// <param name="tariffCode"></param>
        /// <returns>GetBillingTypeResponse</returns>
        /// 
        public GetBillingTypeWithDefaultResponse GetBillingTypesWithDefault(int utilityId, string rateClass, string loadProfile, string tariffCode)
        {
            string method = string.Format("GetBillingTypesWithDefault(utilityId:{0},rateClass:{1},loadProfile:{2},tariffCode:{3})", utilityId, rateClass ?? "NULL VALUE", loadProfile ?? "NULL VALUE", tariffCode ?? "NULL VALUE");
            string messageId = Guid.NewGuid().ToString();
            DateTime beginTime = DateTime.Now;
            try
            {
                _logger.LogInfo(string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                // validate input parameters
                if (utilityId < 1)
                {
                    _logger.LogError(string.Format("{0}.{1}.{2} ERROR Invalid Utility Id Parameter", NAMESPACE, CLASS, method));
                    _logger.LogInfo(string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                    UtilityManagementException ume = new UtilityManagementException(messageId, INVALIDINPUTPARAMETER, "Invalid Input: utilityId");
                    throw new FaultException<UtilityManagementException>(ume, ume.Message);
                }
                //if (string.IsNullOrWhiteSpace(rateClass) && string.IsNullOrWhiteSpace(loadProfile) && string.IsNullOrWhiteSpace(tariffCode))
                //{
                //    _logger.LogError(string.Format("{0}.{1}.{2} ERROR No Value Specified For  RateClass,LoadProfile And TariffCode", NAMESPACE, CLASS, method));
                //    _logger.LogInfo(string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                //    UtilityManagementException ume = new UtilityManagementException(messageId, INVALIDINPUTPARAMETER, "Invalid Input: LoadProfile, RateClass, TariffCode");
                //    throw new FaultException<UtilityManagementException>(ume, ume.Message);
                //}

                GetBillingTypeWithDefaultResponse billingTypeResponse = _businessLayer.GetBillingTypesWithDefault(messageId, utilityId, loadProfile, rateClass, tariffCode);

                if (billingTypeResponse == null || billingTypeResponse.LstBillingTypeWithDefaultResponseItem.Count < 1)
                {
                    _logger.LogError(string.Format("{0}.{1}.{2} ERROR No Value Returned For UtilityId, LoadProfile, RateClass And TariffCode", NAMESPACE, CLASS, method));
                    _logger.LogInfo(string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                    UtilityManagementException ume = new UtilityManagementException(messageId, NOVALUERETURNED, "No billing types defined");
                    throw new FaultException<UtilityManagementException>(ume, ume.Message);
                }

                StringBuilder logData = new StringBuilder("BillingTypeList:[");
                foreach (GetBillingTypeWithDefaultResponseitem billingTypeItem in billingTypeResponse.LstBillingTypeWithDefaultResponseItem)
                {
                    logData.Append(string.Format("BillingType:{0};", billingTypeItem.BillingType));
                }
                logData = new StringBuilder("]");

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} billingTypeList:{4} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString(), logData.ToString()));
                return billingTypeResponse;
            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                if (exc is UtilityManagementBusinessException)
                {
                    UtilityManagementBusinessException umbe = (UtilityManagementBusinessException)exc;
                    UtilityManagementException ume = new UtilityManagementException(messageId, umbe.Code, umbe.Message);
                    _logger.LogError(messageId, string.Format("Throwing Fault Exception: Code:{0}; Message:{1}", ume.Code ?? "", ume.Message ?? ""));
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                    throw new FaultException<UtilityManagementException>(ume, ume.Message);
                }
                if (!(exc is FaultException<UtilityManagementException>))
                {
                    UtilityManagementException umexc = new UtilityManagementException(messageId, ERRORCODE, ERRORMESSAGE);
                    _logger.LogError(messageId, string.Format("Throwing Fault Exception: Code:{0}; Message:{1}", umexc.Code ?? "", umexc.Message ?? ""));
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                    throw new FaultException<UtilityManagementException>(umexc, umexc.Message);
                }
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                throw;
            }
        }

        public GetNextMeterReadResponse GetNextMeterRead(GetNextMeterReadRequest getNextMeterReadRequest)
        {
            string method = string.Format("GetNextMeterRead(getNextMeterReadRequest:{0})", getNextMeterReadRequest == null ? "NULL VALUE" : getNextMeterReadRequest.ToString());
            string messageId = Guid.NewGuid().ToString();
            DateTime beginTime = DateTime.Now;
            try
            {
                GetNextMeterReadResponse getNextMeterReadResponse = null;

                // validate input parameter
                if (getNextMeterReadRequest == null)
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
                    _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR Null Input Parameter", NAMESPACE, CLASS, method));
                    GetNextMeterReadResponse returnValue = new GetNextMeterReadResponse() { Code = "8888", Message = "Null Input Parameter", IsSuccess = false, NextMeterRead = new DateTime(1900, 1, 1) };
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2}  END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                    return returnValue;
                }

                // validate message id passed in
                if (string.IsNullOrWhiteSpace(getNextMeterReadRequest.MessageId))
                    getNextMeterReadRequest.MessageId = Guid.NewGuid().ToString();

                _logger.LogInfo(getNextMeterReadRequest.MessageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (getNextMeterReadRequest.UtilityIdInt < 1 || getNextMeterReadRequest.ReferenceDate == null || getNextMeterReadRequest.ReferenceDate < DateTime.Now.AddDays(-40) || string.IsNullOrWhiteSpace(getNextMeterReadRequest.TripNumber))
                {
                    _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR Invalid Input Parameter -- UtilityIdInt, ReferenceDate or TripNumber Has No Value", NAMESPACE, CLASS, method));
                    GetNextMeterReadResponse returnValue = new GetNextMeterReadResponse() { Code = "7777", Message = "Invalid Input Parameter", IsSuccess = false, NextMeterRead = new DateTime(1900, 1, 1), MessageId = getNextMeterReadRequest.MessageId };
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                    return returnValue;
                }

                getNextMeterReadResponse = _businessLayer.GetNextMeterRead(getNextMeterReadRequest.MessageId, getNextMeterReadRequest.UtilityIdInt, getNextMeterReadRequest.TripNumber, getNextMeterReadRequest.ReferenceDate);


                _logger.LogInfo(getNextMeterReadRequest.MessageId, string.Format("{0}.{1}.{2} getNextMeterReadResponse:{4} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString(), getNextMeterReadResponse.ToString()));
                return getNextMeterReadResponse;
            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                if (!(exc is FaultException<UtilityManagementException>))
                {
                    UtilityManagementException umexc = new UtilityManagementException(messageId, ERRORCODE, ERRORMESSAGE);
                    _logger.LogError(messageId, string.Format("Throwing Fault Exception: Code:{0}; Message:{1}", umexc.Code ?? "", umexc.Message ?? ""));
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                    throw new FaultException<UtilityManagementException>(umexc, umexc.Message);
                }
                _logger.LogInfo(getNextMeterReadRequest.MessageId, string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                throw;
            }
        }

        public DateTime GetNextMeterReadDateForAccount(int utilityId, string serviceAccountNumber, string tripNumber, DateTime contextdate)
        {
            string method = string.Format("GetNextMeterReadDateForAccount(utilityId:{0},serviceAccountNumber:{1},tripNumber:{2},contextdate:{3})", utilityId, serviceAccountNumber ?? "NULL VALUE", tripNumber ?? "NULL VALUE", contextdate == null ? "NULL VALUE" : contextdate.ToString());
            string messageId = Guid.NewGuid().ToString();
            DateTime beginTime = DateTime.Now;
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
                DateTime? response = null;

                // validate input parameters
                if (utilityId < 1)
                {
                    _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR Invalid Input: utilityId!", NAMESPACE, CLASS, method));
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                    UtilityManagementException ume = new UtilityManagementException(messageId, INVALIDINPUTPARAMETER, "Invalid Input: utilityId");
                    throw new FaultException<UtilityManagementException>(ume, ume.Message);
                }
                if (string.IsNullOrWhiteSpace(serviceAccountNumber))
                {
                    _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR Invalid Input: serviceAccountNumber!", NAMESPACE, CLASS, method));
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                    UtilityManagementException ume = new UtilityManagementException(messageId, INVALIDINPUTPARAMETER, "Invalid Input: serviceAccountNumber");
                    throw new FaultException<UtilityManagementException>(ume, ume.Message);
                }
                if (string.IsNullOrWhiteSpace(tripNumber))
                {
                    _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR Invalid Input: tripNumber!", NAMESPACE, CLASS, method));
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                    UtilityManagementException ume = new UtilityManagementException(messageId, INVALIDINPUTPARAMETER, "Invalid Input: tripNumber");
                    throw new FaultException<UtilityManagementException>(ume, ume.Message);
                }
                if (contextdate == null || contextdate < new DateTime(2010, 1, 1) || contextdate > new DateTime(2112, 1, 1))
                {
                    _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR Invalid Input: contextDate!", NAMESPACE, CLASS, method));
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                    UtilityManagementException ume = new UtilityManagementException(messageId, INVALIDINPUTPARAMETER, "Invalid Input: contextDate");
                    throw new FaultException<UtilityManagementException>(ume, ume.Message);
                }

                // call the business layer
                response = _businessLayer.GetNextMeterReadEstimated(messageId, utilityId, tripNumber, contextdate, serviceAccountNumber);

                // validate the response
                if (response == null)
                {
                    _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR No Value Returned", NAMESPACE, CLASS, method));
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                    UtilityManagementException ume = new UtilityManagementException(messageId, NOVALUERETURNED, "No Value Returned!");
                    throw new FaultException<UtilityManagementException>(ume, ume.Message);
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} getNextMeterReadEstimatedResponse:{4} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString(), response.ToString()));
                return (DateTime)response;
            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                if (!(exc is FaultException<UtilityManagementException>))
                {
                    UtilityManagementException umexc = new UtilityManagementException(messageId, ERRORCODE, ERRORMESSAGE);
                    _logger.LogError(messageId, string.Format("Throwing Fault Exception: Code:{0}; Message:{1}", umexc.Code ?? "", umexc.Message ?? ""));
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                    throw new FaultException<UtilityManagementException>(umexc, umexc.Message);
                }
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                throw;
            }
        }



        public List<AccountInfoRequiredFields> GetAllUtilityAccountInfoRequiredFields()
        {
            string method = "GetAllUtilityAccountInfoRequiredFields()";
            string messageId = Guid.NewGuid().ToString();
            DateTime beginTime = DateTime.Now;

            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
                CacheKey = "GetAllUtilityAccountInfoRequiredFields";
                ObjectCache cache = MemoryCache.Default;
                if (cache.Contains(CacheKey))
                {
                    StringBuilder stringBuilder = new StringBuilder("List<AccountInfoRequiredFields>:[");
                    foreach (AccountInfoRequiredFields accountInfoRequiredFields in (List<AccountInfoRequiredFields>)cache.Get(CacheKey))
                        stringBuilder.Append(accountInfoRequiredFields.ToString() + ";");
                    stringBuilder.Append("]");
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} getAllUtilityAccountInfoRequiredFieldsResponse:{3} END Method Duration ms:{4}", NAMESPACE, CLASS, method, stringBuilder.ToString(), DateTime.Now.Subtract(beginTime).Milliseconds));
                    return (List<AccountInfoRequiredFields>)cache.Get(CacheKey);

                }
                else
                {
                    var result = _businessLayer.GetAllUtilityAccountInfoRequiredFields(messageId);
                    StringBuilder stringBuilder = new StringBuilder("List<AccountInfoRequiredFields>:[");
                    foreach (AccountInfoRequiredFields accountInfoRequiredFields in result)
                        stringBuilder.Append(accountInfoRequiredFields.ToString() + ";");
                    stringBuilder.Append("]");
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} getAllUtilityAccountInfoRequiredFieldsResponse:{3} END Method Duration ms:{4}", NAMESPACE, CLASS, method, stringBuilder.ToString(), DateTime.Now.Subtract(beginTime).Milliseconds));
                    CacheItemPolicy cacheItemPolicy = new CacheItemPolicy();
                    cacheItemPolicy.AbsoluteExpiration = DateTime.Now.AddSeconds(Convert.ToInt32(string.IsNullOrEmpty(CHACHE_EXPIRATION_SECONDS) ? "0" : CHACHE_EXPIRATION_SECONDS));
                    cache.Add(CacheKey, result, cacheItemPolicy);
                    return result;
                }

            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                throw;
            }
        }




        public bool DoesUtilityCodeBelongToIso(string messageId, string Iso, string UtilityCode)
        {
            string method = string.Format("DoesUtilityCodeBelongToIso(messageId,Iso:{0},UtilityCode:{1})", Iso, UtilityCode);
            DateTime beginTime = DateTime.Now;
            bool returnValue = false;
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
                CacheKey = method;
                ObjectCache cache = MemoryCache.Default;
                if (cache.Contains(CacheKey))
                    returnValue = (bool)cache.Get(CacheKey);
                else
                {
                    returnValue = _businessLayer.DoesUtilityCodeBelongToIso(messageId, Iso, UtilityCode);
                    CacheItemPolicy cacheItemPolicy = new CacheItemPolicy();
                    cacheItemPolicy.AbsoluteExpiration = DateTime.Now.AddSeconds(Convert.ToInt32(string.IsNullOrEmpty(CHACHE_EXPIRATION_SECONDS) ? "0" : CHACHE_EXPIRATION_SECONDS));
                    cache.Add(CacheKey, returnValue, cacheItemPolicy);
                }
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END Method Duration ms:{4}", NAMESPACE, CLASS, method, returnValue, DateTime.Now.Subtract(beginTime).Milliseconds));
                return returnValue;
            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                throw;
            }
        }

        public bool GetAcceleratedSwitchbyUtilityCode(string messageId, string UtilityCode)
        {
            string method = string.Format("GetAcceleratedSwitchbyUtilityCode(messageId,UtilityCode:{0})", UtilityCode);
            DateTime beginTime = DateTime.Now;
            bool returnValue = false;
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
                CacheKey = method;
                ObjectCache cache = MemoryCache.Default;
                if (cache.Contains(CacheKey))
                    returnValue = (bool)cache.Get(CacheKey);
                else
                {
                    returnValue = _businessLayer.GetAcceleratedSwitchbyUtilityCode(messageId,UtilityCode);
                    CacheItemPolicy cacheItemPolicy = new CacheItemPolicy();
                    cacheItemPolicy.AbsoluteExpiration = DateTime.Now.AddSeconds(Convert.ToInt32(string.IsNullOrEmpty(CHACHE_EXPIRATION_SECONDS) ? "0" : CHACHE_EXPIRATION_SECONDS));
                    cache.Add(CacheKey, returnValue, cacheItemPolicy);
                }
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END Method Duration ms:{4}", NAMESPACE, CLASS, method, returnValue, DateTime.Now.Subtract(beginTime).Milliseconds));
                return returnValue;
            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                throw;
            }
        }

        #endregion


        public GetCapacityThresholdRuleResponse GetCapacityThresholdRule(string messageId, string utilityCode, string accountType)
        {
            string method = string.Format("GetCapacityThresholdRule(messageId,utilityCode:{0},accountType:{1})", utilityCode ?? "NULL VALUE", accountType ?? "NULL VALUE");
            DateTime beginTime = DateTime.Now;
            GetCapacityThresholdRuleResponse returnValue = new GetCapacityThresholdRuleResponse() { CapacityThreshold = 0, CapacityThresholdMax = 999, UseCapacityThreshold = false, IsSuccess = false, Code = "9999", Message = string.Empty, MessageId = messageId };

            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
                CacheKey = method;
                ObjectCache cache = MemoryCache.Default;
                if (cache.Contains(CacheKey))
                {
                    returnValue = (GetCapacityThresholdRuleResponse)cache.Get(CacheKey);
                    returnValue.MessageId = messageId;
                }
                else
                {
                    returnValue = _businessLayer.GetCapacityThresholdRule(messageId, utilityCode, accountType);
                    CacheItemPolicy cacheItemPolicy = new CacheItemPolicy();
                    cacheItemPolicy.AbsoluteExpiration = DateTime.Now.AddSeconds(Convert.ToInt32(string.IsNullOrEmpty(CHACHE_EXPIRATION_SECONDS) ? "0" : CHACHE_EXPIRATION_SECONDS));
                    cache.Add(CacheKey, returnValue, cacheItemPolicy);
                }
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END Method Duration ms:{4}", NAMESPACE, CLASS, method, returnValue, DateTime.Now.Subtract(beginTime).Milliseconds));
                return returnValue;
            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                returnValue.Code = "9999";
                returnValue.Message = "A System Error Occurred";
                returnValue.IsSuccess = false;
                returnValue.UseCapacityThreshold = null;
                returnValue.CapacityThreshold = null;
                returnValue.CapacityThresholdMax = null;
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                return returnValue; ;
            }

        }

        public GetAllActiveUtilitiesDumpDataResponse GetAllActiveUtilitiesDataDump(string messageId)
        {
            string method = string.Format("GetAllUtilitiesData(messageId:{0})", !string.IsNullOrWhiteSpace(messageId) ? "NULL VALUE" : messageId);
            DateTime beginTime = DateTime.Now;
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
                if (string.IsNullOrWhiteSpace(messageId))
                    messageId = Guid.NewGuid().ToString();
                GetAllActiveUtilitiesDumpDataResponse response = (GetAllActiveUtilitiesDumpDataResponse)_businessLayer.GetAllActiveUtilitiesDumpData(messageId);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} response END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                return response;
            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                UtilityManagementException ume = new UtilityManagementException(messageId, ERRORCODE, ERRORMESSAGE);
                throw new FaultException<UtilityManagementException>(ume, ume.Message);
            }
        }

        public GetAllUtilitiesAcceleratedSwitchResponse GetAllUtilitiesAcceleratedSwitch(string messageId)
        {
            string method = string.Format("GetallUtilitiesAcceleratedSwitch(messageId:{0})", !string.IsNullOrWhiteSpace(messageId) ? "NULL VALUE" : messageId);
            DateTime beginTime = DateTime.Now;
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
               // CacheKey = "GetallUtilitiesAcceleratedSwitch";
                CacheKey = method;
                ObjectCache cache = MemoryCache.Default;
                if (cache.Contains(CacheKey))
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} getAllUtilitiesDataResponse END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                    return (GetAllUtilitiesAcceleratedSwitchResponse)cache.Get(CacheKey);

                }
                else
                {
                    if (string.IsNullOrWhiteSpace(messageId))
                        messageId = Guid.NewGuid().ToString();
                    GetAllUtilitiesAcceleratedSwitchResponse response = (GetAllUtilitiesAcceleratedSwitchResponse)_businessLayer.GetAllUtilitiesAcceleratedSwitch(messageId);
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} response END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                    CacheItemPolicy cacheItemPolicy = new CacheItemPolicy();
                    cacheItemPolicy.AbsoluteExpiration = DateTime.Now.AddSeconds(Convert.ToInt32(string.IsNullOrEmpty(CHACHE_EXPIRATION_SECONDS) ? "0" : CHACHE_EXPIRATION_SECONDS));
                    cache.Add(CacheKey, response, cacheItemPolicy);
                    return response;
                }

            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                UtilityManagementException ume = new UtilityManagementException(messageId, ERRORCODE, ERRORMESSAGE);
                throw new FaultException<UtilityManagementException>(ume, ume.Message);
            }
        }

        public GetEnrollmentleadTimesDataResponse GetEnrollmentLeadTimes(string messageId,int utilityId, string rateClass, string loadProfile, string tariffCode)
        {
            string method = string.Format("GetEnrollmentLeadTimes(messageId:{0},utilityId:{1},rateClass:{2},loadProfile:{3},tariffCode)", 
                !string.IsNullOrWhiteSpace(messageId) ? "NULL VALUE" : messageId,Common.NullSafeString(utilityId),rateClass,loadProfile,tariffCode);
            DateTime beginTime = DateTime.Now;
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
                CacheKey = method;
                //CacheKey = "GetEnrollmentLeadTimes";
                ObjectCache cache = MemoryCache.Default;
                if (cache.Contains(CacheKey))
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} getAllUtilitiesDataResponse END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                    return (GetEnrollmentleadTimesDataResponse)cache.Get(CacheKey);

                }
                else
                {
                    if (string.IsNullOrWhiteSpace(messageId))
                        messageId = Guid.NewGuid().ToString();
                    GetEnrollmentleadTimesDataResponse response = (GetEnrollmentleadTimesDataResponse)_businessLayer.GetUtilityEnrollmentLeadTimeData(messageId,utilityId,rateClass,loadProfile,tariffCode);
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} response END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                    CacheItemPolicy cacheItemPolicy = new CacheItemPolicy();
                    cacheItemPolicy.AbsoluteExpiration = DateTime.Now.AddSeconds(Convert.ToInt32(string.IsNullOrEmpty(CHACHE_EXPIRATION_SECONDS) ? "0" : CHACHE_EXPIRATION_SECONDS));
                    cache.Add(CacheKey, response, cacheItemPolicy);
                    return response;
                }

            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Method Duration ms:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                UtilityManagementException ume = new UtilityManagementException(messageId, ERRORCODE, ERRORMESSAGE);
                throw new FaultException<UtilityManagementException>(ume, ume.Message);
            }
        }


    }
}