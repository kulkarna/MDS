using DataAccessLayerEntityFramework;
using Microsoft.Practices.Unity;
using Microsoft.Practices.Unity.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UtilityManagementServiceData;
using UtilityLogging;
using UtilityUnityLogging;
using System.Data;
using Utilities;



namespace UtilityManagementDataMapper
{
    public class EfToWcfMapping
    {

        #region private variables
        private const string NAMESPACE = "UtilityManagementDataMapper";
        private const string CLASS = "EfToWcfMapping";
        private string _messageId = Guid.NewGuid().ToString();
        private ILogger _logger;
        #endregion


        #region public constructors
        public EfToWcfMapping()
        {
            string method = "EfToWcfMapping()";
            try
            {
                _logger = UnityLoggerGenerator.GenerateLogger();
                _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
            }
            catch (Exception exc)
            {
                _logger.LogError(_messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }
        #endregion


        #region public methods
        public GetCapacityThresholdRuleResponse ConvertDataSetToGetCapacityThresholdRuleResponse(string messageId, DataSet dataSet)
        {
            string method = "ConvertDataSetToGetUtilitiesReceiveIdrOnlyByUtilityIdResponse(messageId, DataSet dataSet)";
            GetCapacityThresholdRuleResponse returnValue = new GetCapacityThresholdRuleResponse();
            _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

            ///////////////////////////////////////
            // validate the data
            // no records returned
            if (!Utilities.Common.IsDataSetRowValid(dataSet))
            {
                returnValue = new GetCapacityThresholdRuleResponse()
                {
                    Code = "7004",
                    Message = "No Capacity Threshold Present For Criteria",
                    MessageId = messageId,
                    CapacityThreshold = null,
                    CapacityThresholdMax = null,
                    UseCapacityThreshold = null,
                    IsSuccess = false
                };
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} No Records Returned - returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));
                return returnValue;
            }
            //////////////////////////////////////

            //////////////////////////////////////
            // capacity factor to be ignored
            bool ignoreCapacityFactory = Utilities.Common.NullableBoolean(dataSet.Tables[0].Rows[0]["UseCapacityThreshold"]) == true;
            _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} ignoreCapacityFactory:{3} END", NAMESPACE, CLASS, method, ignoreCapacityFactory));
            _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} Utilities.Common.NullSafeInteger(dataSet.Tables[0].Rows[0][IgnoreCapacityFactor]):{3} END", NAMESPACE, CLASS, method, Utilities.Common.NullSafeInteger(dataSet.Tables[0].Rows[0]["UseCapacityThreshold"])));
            _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} dataSet.Tables[0].Rows[0][IgnoreCapacityFactor]:{3} END", NAMESPACE, CLASS, method, dataSet.Tables[0].Rows[0]["UseCapacityThreshold"]));
            int capacityThreshold = Convert.ToInt32(Utilities.Common.NullSafeDecimal(dataSet.Tables[0].Rows[0]["CapacityThreshold"]));
            int capacityThresholdMax = Convert.ToInt32(Utilities.Common.NullSafeDecimal(dataSet.Tables[0].Rows[0]["CapacityThresholdMax"]));

            if (ignoreCapacityFactory)
            {
                returnValue = new GetCapacityThresholdRuleResponse()
                {
                    Code = "0000",
                    CapacityThreshold = null,
                    CapacityThresholdMax = null,
                    IsSuccess = true,
                    Message = "Success",
                    MessageId = messageId,
                    UseCapacityThreshold = !ignoreCapacityFactory
                };
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} Ignore Capacity Factor - returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));
                return returnValue;
            }
            //////////////////////////////////////

            //////////////////////////////////////
            // value less than zero
            if (capacityThreshold < 0)
            {
                returnValue = new GetCapacityThresholdRuleResponse()
                {
                    Code = "7002",
                    CapacityThreshold = null,
                    CapacityThresholdMax = null,
                    IsSuccess = false,
                    Message = "Capacity Threshold Less Than Zero",
                    MessageId = messageId,
                    UseCapacityThreshold = null
                };
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} Capacity Threshold Less Than Zero - returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));
                return returnValue;
            }
            //////////////////////////////////////

            //////////////////////////////////////
            // value greater than or equal to 1000
            if (capacityThreshold >= 1000)
            {
                returnValue = new GetCapacityThresholdRuleResponse()
                {
                    Code = "7003",
                    CapacityThreshold = null,
                    CapacityThresholdMax = null,
                    IsSuccess = false,
                    Message = "Capacity Threshold Greater Than Or Equal To 1000",
                    MessageId = messageId,
                    UseCapacityThreshold = null
                };
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} Capacity Threshold Greater Than Or Equal To 100 - returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));
                return returnValue;
            }
            //////////////////////////////////////

            //////////////////////////////////////
            // max value less than or equal to min value
            if (capacityThreshold >= capacityThresholdMax)
            {
                returnValue = new GetCapacityThresholdRuleResponse()
                {
                    Code = "7005",
                    CapacityThreshold = null,
                    CapacityThresholdMax = null,
                    IsSuccess = false,
                    Message = "Capacity Threshold Max Not Greater Than Capacity Threshold Min",
                    MessageId = messageId,
                    UseCapacityThreshold = null
                };
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} Capacity Threshold Greater Than Capacity Threshold Max - returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));
                return returnValue;
            }
            //////////////////////////////////////

            //////////////////////////////////////
            // normal return
            returnValue = new GetCapacityThresholdRuleResponse()
            {
                Code = "0000",
                CapacityThreshold = capacityThreshold,
                CapacityThresholdMax = capacityThresholdMax,
                IsSuccess = true,
                Message = "SUCCESS",
                MessageId = messageId,
                UseCapacityThreshold = !ignoreCapacityFactory
            };
            _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} Capacity Threshold Greater Than Or Equal To 100 - returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));
            return returnValue;
            //////////////////////////////////////

        }


        public GetUtilitiesReceiveIdrOnlyByUtilityIdResponse ConvertDataSetToGetUtilitiesReceiveIdrOnlyByUtilityId(string messageId, DataSet dataSet, int utilityId)
        {
            string method = "ConvertDataSetToGetUtilitiesReceiveIdrOnlyByUtilityIdResponse(string messageId, DataSet dataSet)";
            GetUtilitiesReceiveIdrOnlyByUtilityIdResponse returnValue;
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (!Utilities.Common.IsDataSetRowValid(dataSet) || dataSet.Tables[0].Rows[0][0] == null)
                {
                    throw new ArgumentException("dataSet is not valid");
                }

                returnValue = new GetUtilitiesReceiveIdrOnlyByUtilityIdResponse()
                {
                    Code = "0000",
                    IsSuccess = true,
                    Message = "Success",
                    MessageId = messageId,
                    ReceiveIdrOnlyResponse = Utilities.Common.NullSafeInteger(dataSet.Tables[0].Rows[0][0]) == 1,
                    UtilityId = utilityId
                };

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));
                return returnValue;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public GetAllUtilitiesReceiveIdrOnlyResponse ConvertDataSetToGetAllUtilitiesReceiveIdrOnly(string messageId, DataSet dataSet)
        {
            string method = "ConvertDataSetToGetAllUtilitiesReceiveIdrOnlyResponse(string messageId, DataSet dataSet)";
            GetAllUtilitiesReceiveIdrOnlyResponse returnValue;
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (!Utilities.Common.IsDataSetRowValid(dataSet))
                {
                    throw new ArgumentException("dataSet is not valid");
                }

                List<GetAllUtiltiesReceiveIdrOnlyResponseItem> items = new List<GetAllUtiltiesReceiveIdrOnlyResponseItem>();
                foreach (DataRow dataRow in dataSet.Tables[0].Rows)
                {
                    GetAllUtiltiesReceiveIdrOnlyResponseItem getAllUtiltiesReceiveIdrOnlyResponseItem = new GetAllUtiltiesReceiveIdrOnlyResponseItem()
                    {
                        ReceiveIdrOnly = Utilities.Common.NullSafeInteger(dataRow["ReceiveIdrOnly"]) == 1,
                        UtilityCode = Utilities.Common.NullSafeString(dataRow["UtilityCode"]),
                        UtilityIdInt = Utilities.Common.NullSafeInteger(dataRow["UtilityIdInt"])
                    };
                    items.Add(getAllUtiltiesReceiveIdrOnlyResponseItem);
                }

                returnValue = new GetAllUtilitiesReceiveIdrOnlyResponse()
                {
                    Code = "0000",
                    IsSuccess = true,
                    Message = "Success",
                    MessageId = messageId,
                    GetAllUtiltiesReceiveIdrOnlyResponseItems = items
                };

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));
                return returnValue;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }




        public GetPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse ConvertDataSetToGetPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse(string messageId, DataSet dataSet)
        {
            string method = "ConvertDataSetToGetPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse(dataSet)";
            GetPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse returnValue;
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
                if (Utilities.Common.IsDataSetRowValid(dataSet))
                {
                    returnValue = new GetPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse(messageId, Utilities.Common.NullSafeDateTime(dataSet.Tables[0].Rows[0][0]), "Success", true, "0000");
                    if (returnValue.PreviousMeterReadDate == new DateTime(1, 1, 1))
                    {
                        returnValue.PreviousMeterReadDate = new DateTime(1900, 1, 1);
                    }
                }
                else
                {
                    throw new ArgumentException("dataSet is not valid");
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:[{3}] END", NAMESPACE, CLASS, method, returnValue));
                return returnValue;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public GetNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse ConvertDataSetToGetNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse(string messageId, DataSet dataSet)
        {
            string method = "ConvertDataSetToGetNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse(dataSet)";
            GetNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse returnValue;
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
                if (Utilities.Common.IsDataSetRowValid(dataSet))
                {
                    returnValue = new GetNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse(messageId, Utilities.Common.NullSafeDateTime(dataSet.Tables[0].Rows[0][0]), "Success", true, "0000");
                    if (returnValue.NextMeterReadDate == new DateTime(1, 1, 1))
                    {
                        returnValue.NextMeterReadDate = new DateTime(1900, 1, 1);
                    }
                }
                else
                {
                    throw new ArgumentException("dataSet is not valid");
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:[{3}] END", NAMESPACE, CLASS, method, returnValue));
                return returnValue;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public GetMeterReadCalendarByUtilityIdResponse ConvertEfGetMeterReadCalendarByUtilityIdResponseToWcfGetMeterReadCalendarByUtilityIdResponse(string messageId, DataSet dataSet, string UtilityCode)
        {
            string method = "ConvertEfGetMeterReadCalendarByUtilityIdResponseToWcfGetMeterReadCalendarByUtilityIdResponse(meterReadCalendarList)";
            GetMeterReadCalendarByUtilityIdResponse returnValue;
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
                List<GetMeterReadCalendarByUtilityIdResponseItem> items = new List<GetMeterReadCalendarByUtilityIdResponseItem>();
                foreach (DataRow dataRow in dataSet.Tables[0].Rows)
                {
                    GetMeterReadCalendarByUtilityIdResponseItem item = new GetMeterReadCalendarByUtilityIdResponseItem()
                    {
                        CreatedBy = dataRow["CreatedBy"].ToString(),
                        CreatedDate = Utilities.Common.NullSafeDateTime(dataRow["CreatedDate"]),
                        LastModifiedBy = dataRow["LastModifiedBy"].ToString(),
                        LastModifiedDate = Utilities.Common.NullSafeDateTime(dataRow["LastModifiedDate"]),
                        Month = Utilities.Common.NullSafeInteger(dataRow["Month"]),
                        ReadCycleId = Utilities.Common.NullSafeString(dataRow["ReadCycleId"]),
                        ReadDate = Utilities.Common.NullSafeDateTime(dataRow["ReadDate"]),
                        UtilityCode = Utilities.Common.NullSafeString(dataRow["UtilityCode"]),
                        Year = Utilities.Common.NullSafeInteger(dataRow["Year"]),
                        IsAmr = Convert.ToBoolean(dataRow["IsAmr"])
                    };
                    items.Add(item);
                }

                if (string.IsNullOrEmpty(UtilityCode))
                {
                    returnValue = new GetMeterReadCalendarByUtilityIdResponse()
                                   {
                                       Code = "7777",
                                       Message = "Invalid Utility Id Provided",
                                       MeterReadCalendarData = items,
                                       IsSuccess = false,
                                       MessageId = messageId
                                   };

                }
                else
                {
                    returnValue = new GetMeterReadCalendarByUtilityIdResponse()
                               {
                                   Code = "0000",
                                   Message = "Success",
                                   MeterReadCalendarData = items,
                                   IsSuccess = true,
                                   MessageId = messageId
                               };

                }
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue END", NAMESPACE, CLASS, method));
                return returnValue;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public GetMeterReadCalendarByUtilityIdResponse ConvertEfGetMeterReadCalendarByUtilityIdResponseToWcfGetMeterReadCalendarByUtilityIdResponse(string messageId)
        {
            string method = "ConvertEfGetMeterReadCalendarByUtilityIdResponseToWcfGetMeterReadCalendarByUtilityIdResponse(messageId)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
                GetMeterReadCalendarByUtilityIdResponse returnValue;
                returnValue = new GetMeterReadCalendarByUtilityIdResponse()
                {
                    Code = "9999",
                    Message = "An Exception Occurred in the Process. Check the Log Files",
                    MeterReadCalendarData = null,
                    IsSuccess = false,
                    MessageId = messageId
                };
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:[{3}] END", NAMESPACE, CLASS, method, returnValue));
                return returnValue;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }



        public RequestMode ConvertEfHistoricalusageRequestModeToWcfHistoricalusageRequestMode(string messageId, DataSet dsData)
        {
            string method = "ConvertEfHistoricalusageRequestModeToWcfHistoricalusageRequestMode(dsData)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
                if (Common.IsDataSetRowValid(dsData))
                    foreach (DataRow drRequestModeHistoricalUsage in dsData.Tables[0].Rows)
                    {
                        string address = string.Empty;
                        string emailTemplate = string.Empty;
                        if (Common.NullSafeString(drRequestModeHistoricalUsage["RequestModeType"]).ToLower() == "website" || Common.NullSafeString(drRequestModeHistoricalUsage["RequestModeType"]).ToLower() == "e-mail")
                        {
                            address = Common.NullSafeString(drRequestModeHistoricalUsage["Address"]);
                            if (Common.NullSafeString(drRequestModeHistoricalUsage["RequestModeType"]).ToLower() == "e-mail")
                                emailTemplate = Common.NullSafeString(drRequestModeHistoricalUsage["EmailTemplate"]);
                        }

                        RequestMode returnValue = new RequestMode()
                        {
                            Address = address,
                            EmailTemplate = emailTemplate,
                            EnrollmentType = MapEnrollmentType(messageId, Common.NullSafeString(drRequestModeHistoricalUsage["EnrollmentType"])),
                            Instructions = Common.NullSafeString(drRequestModeHistoricalUsage["Instructions"]),
                            IsLoaRequired = Convert.ToBoolean(drRequestModeHistoricalUsage["IsLOARequired"]),
                            LibertyPowerSlaResponse = Common.NullSafeInteger(drRequestModeHistoricalUsage["LibertyPowerSLAResponse"]),
                            RequestModeType = Common.NullSafeString(drRequestModeHistoricalUsage["RequestModeType"]),
                            UtilityId = Common.NullSafeInteger(drRequestModeHistoricalUsage["UtilityId"]),
                            UtilitySlaResponse = Common.NullSafeInteger(drRequestModeHistoricalUsage["UtilitySLAResponse"]),
                        };
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:[{3}] END", NAMESPACE, CLASS, method, returnValue));
                        return returnValue;
                    }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:[{3}] END", NAMESPACE, CLASS, method, "NULL VALUE"));
                return null;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public RequestMode ConvertEfIcapRequestModeToWcfIcapRequestMode(string messageId, DataTable requestModeIcaps)
        {
            string method = "ConvertEfIcapRequestModeToWcfIcapRequestMode(requestModeIcaps)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                foreach (DataRow requestModeIcap in requestModeIcaps.Rows)
                {
                    string address = string.Empty;
                    string emailTemplate = string.Empty;
                    if (Utilities.Common.NullSafeString(requestModeIcap["RequestModeType"]).ToLower() == "website" || Utilities.Common.NullSafeString(requestModeIcap["RequestModeType"]).ToLower() == "e-mail")
                    {
                        address = Utilities.Common.NullSafeString(requestModeIcap["Address"]);
                        emailTemplate = Utilities.Common.NullSafeString(requestModeIcap["EmailTemplate"]);
                    }

                    RequestMode returnValue = new RequestMode()
                    {
                        Address = address,
                        EmailTemplate = emailTemplate,
                        EnrollmentType = MapEnrollmentType(messageId, Utilities.Common.NullSafeString(requestModeIcap["EnrollmentType"])),
                        Instructions = Utilities.Common.NullSafeString(requestModeIcap["Instructions"]),
                        IsLoaRequired = Convert.ToBoolean(requestModeIcap["IsLoaRequired"]),
                        LibertyPowerSlaResponse = Utilities.Common.NullSafeInteger(requestModeIcap["LibertyPowerSLAResponse"]),
                        RequestModeType = Utilities.Common.NullSafeString(requestModeIcap["RequestModeType"]),
                        UtilityId = Utilities.Common.NullSafeInteger(requestModeIcap["UtilityId"]),
                        UtilitySlaResponse = Utilities.Common.NullSafeInteger(requestModeIcap["UtilitySLAResponse"]),
                    };

                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:[{3}] END", NAMESPACE, CLASS, method, returnValue));
                    return returnValue;
                }
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:[{3}] END", NAMESPACE, CLASS, method, "NULL VALUE"));
                return null;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public IdrRequestMode ConvertEfIdrRequestModeToWcfIdrRequestMode(string messageId, List<RequestModeIdr> requestModeIdrs)
        {
            if (!string.IsNullOrWhiteSpace(messageId))
                messageId = messageId;
            string method = "ConvertEfIdrRequestModeToWcfIdrRequestMode(requestModeIdrs)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                GetIdrRequestModeResponse returnValue = new GetIdrRequestModeResponse()
                {
                    IdrRequestModeList = new List<IdrRequestMode>(),
                    MessageId = messageId
                };
                foreach (RequestModeIdr requestModeIdr in requestModeIdrs)
                {
                    string address = string.Empty;
                    string emailTemplate = string.Empty;
                    if (requestModeIdr.RequestModeType.Name.ToLower() == "website" || requestModeIdr.RequestModeType.Name.ToLower() == "e-mail")
                    {
                        address = requestModeIdr.AddressForPreEnrollment;
                        if (requestModeIdr.RequestModeType.Name.ToLower() == "e-mail")
                            emailTemplate = requestModeIdr.EmailTemplate;
                    }

                    return new IdrRequestMode()
                    {
                        Address = address,
                        EmailTemplate = emailTemplate,
                        Instructions = requestModeIdr.Instructions,
                        IsLoaRequired = requestModeIdr.IsLoaRequired,
                        LibertyPowerSlaResponse = requestModeIdr.LibertyPowersSlaFollowUpIdrResponseInDays,
                        UtilitySlaResponse = requestModeIdr.UtilitysSlaIdrResponseInDays,
                        IsProhibited = false,
                        EnrollmentType = (EnrollmentType)requestModeIdr.RequestModeEnrollmentType.EnumValue,
                        RequestModeType = requestModeIdr.RequestModeType.Name,
                        UtilityId = requestModeIdr.UtilityCompany.UtilityIdInt
                    };
                }

                return null;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public HasPurchaseOfReceivableAssuranceResponse ConvertEfPorAssuranceResponseToWcfPorAssuranceResponse(string messageId, DataSet dsPurchaseOfReceivable)
        {

            string method = "ConvertEfPorAssuranceResponseToWcfPorAssuranceResponse(dsPurchaseOfReceivable)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                HasPurchaseOfReceivableAssuranceResponse returnValue = new HasPurchaseOfReceivableAssuranceResponse()
                {
                    HasPurchaseOfReceivableAssuranceList = new List<UtilityManagementServiceData.PurchaseOfReceivable>(),
                    MessageId = messageId
                };
                foreach (DataRow drPurchaseOfReceivable in dsPurchaseOfReceivable.Tables[0].Rows)
                {
                    UtilityManagementServiceData.PurchaseOfReceivable por = new UtilityManagementServiceData.PurchaseOfReceivable()
                    {
                        UtilityId = Convert.ToInt32(drPurchaseOfReceivable["UtilityId"]),
                        UtilityGuid = Common.NullSafeGuid(drPurchaseOfReceivable["UtilityGuid"]),
                        UtilityCode = Convert.ToString(drPurchaseOfReceivable["UtilityCode"]),
                        PORGuid = Common.NullSafeGuid(drPurchaseOfReceivable["PORGuid"]),
                        IsPorAssurance = Convert.ToBoolean(drPurchaseOfReceivable["IsPorAssurance"]),
                        UtilityAccountType = Convert.ToString(drPurchaseOfReceivable["UtilityAccountType"]),
                        Commodity = Convert.ToString(drPurchaseOfReceivable["Commodity"])
                    };
                    returnValue.HasPurchaseOfReceivableAssuranceList.Add(por);
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:[{3}] END", NAMESPACE, CLASS, method, returnValue));
                return returnValue;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        //public HasPurchaseOfReceivableAssuranceResponse ConvertEfPorAssuranceResponseToWcfPorAssuranceResponse(string messageId, DataSet dsPurchaseOfReceivable)
        //{

        //    string method = "ConvertEfPorAssuranceResponseToWcfPorAssuranceResponse(dsPurchaseOfReceivable)";
        //    try
        //    {
        //        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

        //        HasPurchaseOfReceivableAssuranceResponse returnValue = new HasPurchaseOfReceivableAssuranceResponse()
        //        {
        //            HasPurchaseOfReceivableAssuranceList = new List<UtilityManagementServiceData.PurchaseOfReceivable>(),
        //            MessageId = messageId
        //        };
        //        foreach (DataRow drPurchaseOfReceivable in dsPurchaseOfReceivable.Tables[0].Rows)
        //        {
        //            PurchaseOfReceivableRecourse recourse = PurchaseOfReceivableRecourse.None;
        //            switch (Common.NullSafeString(drPurchaseOfReceivable["PorRecourseName"]).Trim().ToLower())
        //            {
        //                case "recourse":
        //                    recourse = PurchaseOfReceivableRecourse.Recourse;
        //                    break;
        //                case "non-recourse":
        //                    recourse = PurchaseOfReceivableRecourse.NonRecourse;
        //                    break;
        //            }

        //            UtilityManagementServiceData.PurchaseOfReceivable por = new UtilityManagementServiceData.PurchaseOfReceivable()
        //            {
        //                Id = Common.NullSafeGuid(drPurchaseOfReceivable["Id"]),
        //                IsPorAssurance = Convert.ToBoolean(drPurchaseOfReceivable["IsPorAssurance"]),
        //                IsPorOffered = Convert.ToBoolean(drPurchaseOfReceivable["IsPorOffered"]),
        //                IsPorParticipated = Convert.ToBoolean(drPurchaseOfReceivable["IsPorParticipated"]),
        //                PorDiscountEffectiveDate = Common.NullSafeDateTime(drPurchaseOfReceivable["PorDiscountEffectiveDate"]),
        //                PorDiscountExpirationDate = Common.NullSafeDateTime(drPurchaseOfReceivable["PorDiscountExpirationDate"]),
        //                PorDiscountRate = Common.NullSafeDecimal(drPurchaseOfReceivable["PorDiscountRate"]),
        //                PorFlatFee = Common.NullSafeDecimal(drPurchaseOfReceivable["PorFlatFee"]),
        //                PurchaseOfReceivableRecourse = recourse
        //            };
        //            returnValue.HasPurchaseOfReceivableAssuranceList.Add(por);
        //        }

        //        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:[{3}] END", NAMESPACE, CLASS, method, returnValue));
        //        return returnValue;
        //    }
        //    catch (Exception exc)
        //    {
        //        _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
        //        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
        //        throw;
        //    }
        //}

        public GetBillingTypeWithDefaultResponse ConvertEfBillingTypeWithDefaultResponseToWcfBillingTypeResponse(string messageId, DataSet dsRespnose)
        {
            string method = "ConvertEfBillingTypeWithDefaultResponseToWcfBillingTypeResponse(messageId, dsResponse)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                GetBillingTypeWithDefaultResponse returnValue = new GetBillingTypeWithDefaultResponse();
                List<GetBillingTypeWithDefaultResponseitem> lstBillingResponseitem = new List<UtilityManagementServiceData.GetBillingTypeWithDefaultResponseitem>();
                foreach (DataRow drbillingType in dsRespnose.Tables[0].Rows)
                {
                    if (drbillingType != null)
                    {
                        GetBillingTypeWithDefaultResponseitem item = new GetBillingTypeWithDefaultResponseitem()
                        {


                            BillingType = Utilities.Common.NullSafeString(drbillingType["UtilityOfferedBillingType"]),
                            AccountType = Utilities.Common.NullSafeString(drbillingType["UtilityAccountType"]),
                            IsDefault = Convert.ToBoolean(drbillingType["IsDefault"])
                        };
                        lstBillingResponseitem.Add(item);
                    }

                }
                returnValue.LstBillingTypeWithDefaultResponseItem = lstBillingResponseitem;

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:[{3}] END", NAMESPACE, CLASS, method, returnValue));
                return returnValue;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }
        public GetBillingTypeResponse ConvertEfBillingTypeResponseToWcfBillingTypeResponse(string messageId, DataSet dsBillingType)
        {
            string method = "ConvertEfBillingTypeResponseToWcfBillingTypeResponse(messageId, dsBillingType)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                GetBillingTypeResponse returnValue = new GetBillingTypeResponse();
                List<GetBillingTypeResponseitem> lstBillingResponseitem = new List<UtilityManagementServiceData.GetBillingTypeResponseitem>();
                foreach (DataRow drbillingType in dsBillingType.Tables[0].Rows)
                {
                    if (drbillingType != null)
                    {
                        GetBillingTypeResponseitem item = new GetBillingTypeResponseitem()
                        {


                            BillingType = Utilities.Common.NullSafeString(drbillingType["UtilityOfferedBillingType"]),
                            AccountType = Utilities.Common.NullSafeString(drbillingType["UtilityAccountType"])
                        };
                        lstBillingResponseitem.Add(item);
                    }

                }
                returnValue.LstBillingTypeResponseItem = lstBillingResponseitem;
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:[{3}] END", NAMESPACE, CLASS, method, returnValue));
                return returnValue;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public IGetAllUtilitiesResponse ConvertEfUtilitiesToGetAllUtilitiesResponse(string messageId, DataSet dsUtilityCompanies)
        {
            if (string.IsNullOrWhiteSpace(messageId))
            {
                messageId = Guid.NewGuid().ToString();
            }
            string method = "ConvertEfUtilitiesToGetAllUtilitiesResponse(messageId, dsUtilityCompanies)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (dsUtilityCompanies.Tables.Count <= 0)
                {
                    _logger.LogError(messageId, "dsUtilityCompanies is empty");
                    throw new Exception("DSUTILITYCOMPANIES IS EMPTY NO DATA AVAILABLE");
                }

                IGetAllUtilitiesResponse returnValue = new GetAllUtilitiesResponse()
                {
                    MessageId = messageId,
                    Utilities = new List<GetAllUtilitiesResponseItem>()
                };

                _logger.LogInfo(messageId, "After init returnValue");
                int i = 0;
                foreach (DataRow drUtilityCompany in dsUtilityCompanies.Tables[0].Rows)
                {
                    _logger.LogInfo(string.Format("i={0}", i));

                    if (drUtilityCompany != null)
                    {
                        int legacyUtilityId = 0;
                        legacyUtilityId = Utilities.Common.NullSafeInteger(drUtilityCompany["UtilityLegacyId"]);
                        _logger.LogInfo(string.Format("legacyUtilityId={0}", legacyUtilityId));

                        GetAllUtilitiesResponseItem mappedValue = new GetAllUtilitiesResponseItem()
                        {
                            LegacyUtilityId = legacyUtilityId,
                            UtilityId = Utilities.Common.NullSafeGuid(drUtilityCompany["UtilityCompanyId"]),
                            UtilityCode = Utilities.Common.NullSafeString(drUtilityCompany["UtilityCode"]),
                            UtilityIdInt = Utilities.Common.NullSafeInteger(drUtilityCompany["UtilityIdInt"])
                        };
                        _logger.LogInfo(string.Format("utilityCompany.UtilityCode={0}", Utilities.Common.NullSafeString(drUtilityCompany["UtilityCode"])));
                        returnValue.Utilities.Add(mappedValue);
                        _logger.LogInfo("returnValue.Utilities.Add(mappedValue);");

                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));
                return returnValue;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + ":" + exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString()), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public IGetEnrollmentleadTimesDataResponse ConvertEfUtilitiesToGetUtilityEnrollmentleadTimeDataResponse(string messageId, DataSet dataSet)
        {
            if (string.IsNullOrWhiteSpace(messageId))
            {
                messageId = Guid.NewGuid().ToString();
            }
            string method = "ConvertEfUtilitiesToGetUtilityEnrollmentleadTimeDataResponse(messageId, dataSet)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                IGetEnrollmentleadTimesDataResponse returnValue = new GetEnrollmentleadTimesDataResponse()
                {
                    MessageId = messageId,
                    EnrollmentLeadTimesData = new List<GetEnrollmentLeadTimesResponseItem>()
                };

                if (Utilities.Common.IsDataSetRowValid(dataSet))
                {
                    foreach (DataRow dataRow in dataSet.Tables[0].Rows)
                    {
                        GetEnrollmentLeadTimesResponseItem getEnrollmentLeadTimesResponseItem = new GetEnrollmentLeadTimesResponseItem()
                        {


                            //UtilityCode = Utilities.Common.NullSafeString(dataRow["UtilityCode"]),
                            UtilityId = Utilities.Common.NullSafeInteger(dataRow["UtilityId"]),
                            EnrollmentleadTime = Utilities.Common.NullSafeInteger(dataRow["EnrollmentLeadTime"]),
                            AccountType = Utilities.Common.NullSafeString(dataRow["UtilityAccountType"]),
                            IsBusinessDay = Convert.ToBoolean(Utilities.Common.NullSafeString(dataRow["BusinessDay"]).ToUpper() == "YES" ? "True" : "False")
                            //IsEnrollmentLeadTimeDefault = Convert.ToBoolean(Utilities.Common.NullSafeString(dataRow["EnrollmentLeadTImeDefault"]).ToUpper() == "YES" ? "True" : "False")
                        };
                        returnValue.EnrollmentLeadTimesData.Add(getEnrollmentLeadTimesResponseItem);
                    }
                }
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue END", NAMESPACE, CLASS, method));
                return returnValue;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + ":" + exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString()), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public IGetAllUtilitiesDataResponse ConvertEfUtilitiesToGetAllUtilitiesDataResponse(string messageId, DataSet dataSet)
        {
            if (string.IsNullOrWhiteSpace(messageId))
            {
                messageId = Guid.NewGuid().ToString();
            }
            string method = "ConvertEfUtilitiesToGetAllUtilitiesDataResponse(messageId, dataSet)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                IGetAllUtilitiesDataResponse returnValue = new GetAllUtilitiesDataResponse()
                {
                    MessageId = messageId,
                    UtilitiesData = new List<GetAllUtilitiesDataResponseItem>()
                };

                if (Utilities.Common.IsDataSetRowValid(dataSet))
                {
                    foreach (DataRow dataRow in dataSet.Tables[0].Rows)
                    {
                        GetAllUtilitiesDataResponseItem getAllUtilitiesDataResponseItem = new GetAllUtilitiesDataResponseItem()
                        {
                            FullName = Utilities.Common.NullSafeString(dataRow["FullName"]),
                            LegacyUtilityId = Utilities.Common.NullSafeInteger(dataRow["UtilityLegacyId"]),
                            MarketId = Utilities.Common.NullSafeGuid(dataRow["MarketId"]),
                            MarketIdInt = Utilities.Common.NullableInteger(dataRow["MarketIdInt"]),
                            MarketName = Utilities.Common.NullSafeString(dataRow["Market"]),
                            UtilityCode = Utilities.Common.NullSafeString(dataRow["UtilityCode"]),
                            UtilityId = Utilities.Common.NullSafeGuid(dataRow["UtilityCompanyId"]),
                            UtilityIdInt = Utilities.Common.NullSafeInteger(dataRow["UtilityIdInt"])
                        };
                        returnValue.UtilitiesData.Add(getAllUtilitiesDataResponseItem);
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue END", NAMESPACE, CLASS, method));
                return returnValue;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + ":" + exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString()), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public IGetAllUtilitiesAcceleratedSwitchResponse ConvertEfUtilitiesToGetallUtilitiesAcceleratedSwitchDataResponse(string messageId, DataSet dataSet)
        {
            if (string.IsNullOrWhiteSpace(messageId))
            {
                messageId = Guid.NewGuid().ToString();
            }
            string method = "ConvertEfUtilitiesToGetallUtilitiesAcceleratedSwitchDataResponse(messageId, dataSet)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                IGetAllUtilitiesAcceleratedSwitchResponse returnValue = new GetAllUtilitiesAcceleratedSwitchResponse()
                {
                    MessageId = messageId,
                    AcceleratedUtilitiesData = new List<GetAllUtilitiesAcceleratedSwitchResponseItem>()
                };

                if (Utilities.Common.IsDataSetRowValid(dataSet))
                {
                    foreach (DataRow dataRow in dataSet.Tables[0].Rows)
                    {
                        GetAllUtilitiesAcceleratedSwitchResponseItem getallUtilitiesAcceleratedSwitchResponseItem = new GetAllUtilitiesAcceleratedSwitchResponseItem()
                        {

                            UtilityCode = Utilities.Common.NullSafeString(dataRow["UtilityCode"]),
                            UtilityId = Utilities.Common.NullSafeGuid(dataRow["UtilityCompanyId"]),
                            UtilityIdInt = Utilities.Common.NullSafeInteger(dataRow["UtilityIdInt"]),
                            AcceleratedSwitch = Utilities.Common.NullSafeInteger(dataRow["AcceleratedSwitch"])
                        };
                        returnValue.AcceleratedUtilitiesData.Add(getallUtilitiesAcceleratedSwitchResponseItem);
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue END", NAMESPACE, CLASS, method));
                return returnValue;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + ":" + exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString()), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public IGetAllActiveUtilitiesDumpDataResponse ConvertEfActiveUtilitiesToGetAllUtilitiesDataResponse(string messageId, DataSet dataSet)
        {
            if (string.IsNullOrWhiteSpace(messageId))
            {
                messageId = Guid.NewGuid().ToString();
            }
            string method = "ConvertEfActiveUtilitiesToGetAllUtilitiesDataResponse(messageId, dataSet)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                IGetAllActiveUtilitiesDumpDataResponse returnValue = new GetAllActiveUtilitiesDumpDataResponse()
                {
                    MessageId = messageId,
                    UtilitiesData = new List<GetAllActiveUtilitiesDumpDataResponseItem>()
                };

                if (Utilities.Common.IsDataSetRowValid(dataSet))
                {
                    foreach (DataRow dataRow in dataSet.Tables[0].Rows)
                    {
                        GetAllActiveUtilitiesDumpDataResponseItem getAllUtilitiesDataResponseItem = new GetAllActiveUtilitiesDumpDataResponseItem()
                        {

                            MarketId = Utilities.Common.NullSafeGuid(dataRow["MarketId"]),
                            MarketIdInt = Utilities.Common.NullableInteger(dataRow["MarketIdInt"]),
                            MarketName = Utilities.Common.NullSafeString(dataRow["MarketName"]),
                            UtilityCode = Utilities.Common.NullSafeString(dataRow["UtilityCode"]),
                            UtilityId = Utilities.Common.NullSafeGuid(dataRow["UtilityCompanyId"]),
                            UtilityIdInt = Utilities.Common.NullSafeInteger(dataRow["UtilityIdInt"]),
                            IsoId = Utilities.Common.NullSafeGuid(dataRow["ISOID"]),
                            IsoName = Utilities.Common.NullSafeString(dataRow["ISONAME"]),
                            PrimaryDunsNumber = Utilities.Common.NullSafeString(dataRow["PrimaryDunsNumber"]),
                            LpEntityId = Utilities.Common.NullSafeString(dataRow["LpEntityId"]),
                            ServiceAccountPattern = Utilities.Common.NullSafeString(dataRow["ServiceAccountPattern"]),
                            ServiceAccountPatternDesc = Utilities.Common.NullSafeString(dataRow["SERVICEACCOUNTPATTERNDESC"]),
                            BillingAccountPattern = Utilities.Common.NullSafeString(dataRow["BILLINGACCOUNTPATTERN"]),
                            BillingAccountPatternDesc = Utilities.Common.NullSafeString(dataRow["BILLINGACCOUNTPATTERNDESC"]),
                            NameKeyPattern = Utilities.Common.NullSafeString(dataRow["NAMEKEYPATTERN"]),
                            NameKeyPatternDesc = Utilities.Common.NullSafeString(dataRow["NAMEKEYPATTERNDESC"]),
                            HURequestModeType = Utilities.Common.NullSafeString(dataRow["HURequestModeType"]),
                            HURequestModeAddress = Utilities.Common.NullSafeString(dataRow["HURequestModeAddress"]),
                            HURequestModeEmailTemplate = Utilities.Common.NullSafeString(dataRow["HURequestModeEmailTemplate"]),
                            HURequestModeInstructions = Utilities.Common.NullSafeString(dataRow["HURequestModeInstructions"]),
                            HURequestModeEnrollmentType = Utilities.Common.NullSafeString(dataRow["HUREQUESTMODEENROLLMENTTYPE"]),
                            HURequestModeIsLoaRequired = Convert.ToBoolean(Utilities.Common.NullableBoolean(dataRow["HURequestModeIsLoaRequired"])),
                            HIRequestModeType = Utilities.Common.NullSafeString(dataRow["IDRREQUESTMODETYPE"]),
                            HIRequestModeAddress = Utilities.Common.NullSafeString(dataRow["IDRREQUESTMODEADDRESS"]),
                            HIRequestModeEmailTemplate = Utilities.Common.NullSafeString(dataRow["IDRREQUESTMODEEMAILTEMPLATE"]),
                            HIRequestModeInstructions = Utilities.Common.NullSafeString(dataRow["IDRREQUESTMODEINSTRUCTIONS"]),
                            HIRequestModeEnrollmentType = Utilities.Common.NullSafeString(dataRow["IDRREQUESTMODEENROLLMENTTYPE"]),
                            HIRequestModeIsLoaRequired = Convert.ToBoolean(Utilities.Common.NullableBoolean(dataRow["IDRREQUESTMODEISLOAREQUIRED"])),
                            ICapRequestModeType = Utilities.Common.NullSafeString(dataRow["ICapRequestModeType"]),
                            ICapRequestModeAddress = Utilities.Common.NullSafeString(dataRow["ICapRequestModeAddress"]),
                            ICapRequestModeEmailTemplate = Utilities.Common.NullSafeString(dataRow["ICapRequestModeEmailTemplate"]),
                            ICapRequestModeInstructions = Utilities.Common.NullSafeString(dataRow["ICapRequestModeInstructions"]),
                            ICapRequestModeEnrollmentType = Utilities.Common.NullSafeString(dataRow["IcapREQUESTMODEENROLLMENTTYPE"]),
                            ICapRequestModeIsLoaRequired = Convert.ToBoolean(Utilities.Common.NullableBoolean(dataRow["ICapRequestModeIsLoaRequired"]))

                        };
                        returnValue.UtilitiesData.Add(getAllUtilitiesDataResponseItem);


                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue END", NAMESPACE, CLASS, method));
                return returnValue;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + ":" + exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString()), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                return null;
                throw;
            }
        }

        public IGetAllUtilitiesDataResponse ConvertEfUtilitiesToGetAllUtilitiesDataResponse(string messageId, List<UtilityCompany> utilityCompanies)
        {
            if (string.IsNullOrWhiteSpace(messageId))
            {
                messageId = Guid.NewGuid().ToString();
            }
            string method = "ConvertEfUtilitiesToGetAllUtilitiesDataResponse(messageId, utilityCompanies)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                IGetAllUtilitiesDataResponse returnValue = new GetAllUtilitiesDataResponse()
                {
                    MessageId = messageId,
                    UtilitiesData = new List<GetAllUtilitiesDataResponseItem>()
                };

                _logger.LogDebug(messageId, "After init returnValue");
                int i = 0;
                foreach (UtilityCompany utilityCompany in utilityCompanies)
                {
                    _logger.LogDebug(string.Format("i={0}", i));

                    if (utilityCompany != null)
                    {
                        int legacyUtilityId = 0;
                        if (utilityCompany.UtilityCompanyToUtilityLegacies != null && utilityCompany.UtilityCompanyToUtilityLegacies.FirstOrDefault() != null)
                        {
                            legacyUtilityId = utilityCompany.UtilityCompanyToUtilityLegacies.FirstOrDefault().UtilityLegacyId;
                        }
                        _logger.LogDebug(string.Format("legacyUtilityId={0}", legacyUtilityId));

                        GetAllUtilitiesDataResponseItem mappedValue = new GetAllUtilitiesDataResponseItem()
                        {
                            LegacyUtilityId = legacyUtilityId,
                            UtilityId = utilityCompany.Id,
                            UtilityCode = utilityCompany.UtilityCode,
                            UtilityIdInt = utilityCompany.UtilityIdInt,
                            FullName = utilityCompany.FullName,
                            MarketId = utilityCompany.Market.Id,
                            MarketIdInt = utilityCompany.Market.MarketIdInt,
                            MarketName = utilityCompany.Market.Market1
                        };
                        _logger.LogDebug(string.Format("utilityCompany.UtilityCode={0}", utilityCompany.UtilityCode));
                        returnValue.UtilitiesData.Add(mappedValue);
                        _logger.LogDebug("returnValue.Utilities.Add(mappedValue);");

                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));
                return returnValue;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + ":" + exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString()), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public IGetAllRequestModeEnrollmentTypesResponse ConvertEfRequestModeEnrollmentTypesToGetAllRequestModeEnrollmentTypesResponse(string messageId, DataSet requestModeEnrollmentTypes)
        {
            if (string.IsNullOrWhiteSpace(messageId))
            {
                messageId = Guid.NewGuid().ToString();
            }
            string method = "ConvertEfRequestModeEnrollmentTypesToGetAllRequestModeEnrollmentTypesResponse(messageId, requestModeEnrollmentTypes)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                IGetAllRequestModeEnrollmentTypesResponse returnValue = new GetAllRequestModeEnrollmentTypesResponse()
                {
                    MessageId = messageId,
                    RequestModeEnrollmentTypes = new List<GetAllRequestModeEnrollmentTypeResponseItem>()
                };

                foreach (DataRow requestModeEnrollmentType in requestModeEnrollmentTypes.Tables[0].Rows)
                {
                    EnrollmentType enrollmentType = EnrollmentType.PreEnrollment;
                    if (Utilities.Common.NullSafeString(requestModeEnrollmentType["Name"]).Trim().ToLower().Substring(0, 3) == "pre")
                    {
                        enrollmentType = EnrollmentType.PreEnrollment;
                    }
                    if (Utilities.Common.NullSafeString(requestModeEnrollmentType["Name"]).Trim().ToLower().Substring(0, 4) == "post")
                    {
                        enrollmentType = EnrollmentType.PostEnrollment;
                    }
                    GetAllRequestModeEnrollmentTypeResponseItem mappedValue = new GetAllRequestModeEnrollmentTypeResponseItem()
                    {
                        Name = Utilities.Common.NullSafeString(requestModeEnrollmentType["Name"]),
                        RequestModeEnrollmentTypeId = Utilities.Common.NullSafeGuid(requestModeEnrollmentType["RequestModeEnrollmentTypeId"]),
                        EnrollmentType = enrollmentType
                    };
                    returnValue.RequestModeEnrollmentTypes.Add(mappedValue);
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));
                return returnValue;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }
        #endregion


        #region private methods
        private EnrollmentType MapEnrollmentType(string messageId, string name)
        {
            string method = string.Format("MapEnrollmentType(messageId, name:{0})", name);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                switch (name.ToLower().Trim())
                {
                    case "post enrollment":
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} EnrollmentType.PostEnrollment END", NAMESPACE, CLASS, method));
                        return EnrollmentType.PostEnrollment;
                    case "pre enrollment":
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} EnrollmentType.PreEnrollment END", NAMESPACE, CLASS, method));
                        return EnrollmentType.PreEnrollment;
                }
                throw new ArgumentException();
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }
        #endregion
    }
}
