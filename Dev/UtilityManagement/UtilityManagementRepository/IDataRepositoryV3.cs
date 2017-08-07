
using System;
using System.Data;
using UtilityManagementServiceData;

namespace UtilityManagementRepository
{
    public interface IDataRepositoryV3
    {
        /// <summary>
        /// MessageId is the key to iddentify Different Calls
        /// </summary>
        string MessageId { get; set; }
        /// <summary>
        /// Method to Check that Whether Utility Belongs to corect ISO.
        /// </summary>
        /// <param name="messageId"></param>
        /// <param name="Iso"></param>
        /// <param name="UtilityCode"></param>
        /// <returns></returns>
        bool DoesUtilityCodeBelongToIso(string messageId, string Iso, string UtilityCode);

        /// <summary>
        /// Method to Check that Whether Utility is Accelerated or not.
        /// </summary>
        /// <param name="messageId"></param>
        /// <param name="Iso"></param>
        /// <param name="UtilityCode"></param>
        /// <returns></returns>
        bool GetAcceleratedSwitchbyUtilityCode(string messageId, string UtilityCode);
        /// <summary>
        /// Returns the Data for All Utilities
        /// </summary>
        /// <param name="messageId"></param>
        /// <returns></returns>
        DataSet GetAllUtilitiesData(string messageId);
        /// <summary>
        /// Get Meter Read Calender by UtilityCode
        /// </summary>
        /// <param name="messageId"></param>
        /// <param name="utilityCode"></param>
        /// <returns></returns>
        DataSet GetMeterReadCalendarByUtilityCode(string messageId, string utilityCode);
        /// <summary>
        /// Get UtilityCode by UtilityId
        /// </summary>
        /// <param name="messageId"></param>
        /// <param name="utilityId"></param>
        /// <returns></returns>
        string GetUtilityCodebyUtilityId(string messageId, string utilityId);
        /// <summary>
        /// We Get the Next Meter Read Suppose the Inquiry Date is 01/13/2017 then it will provide the Meter Read Just Next to It.
        /// </summary>
        /// <param name="messageId"></param>
        /// <param name="utilityId"></param>
        /// <param name="readCycleId"></param>
        /// <param name="isAmr"></param>
        /// <param name="inquiryDate"></param>
        /// <returns></returns>
        DataSet GetMeterReadCalenderNextReadDateByUtilityIdReadCycleIdAndInquiryDate(string messageId, int utilityId, string readCycleId, bool isAmr, DateTime inquiryDate);
        /// <summary>
        /// We Get the Previous Meter Read Suppose the Inquiry Date is 01/13/2017 then it will provide the Previous Meter Read Date Just Previous to It.
        /// </summary>
        /// <param name="messageId"></param>
        /// <param name="utilityId"></param>
        /// <param name="readCycleId"></param>
        /// <param name="isAmr"></param>
        /// <param name="inquiryDate"></param>
        /// <returns></returns>
        DataSet GetMeterReadCalenderPreviousReadDateByUtilityIdReadCycleIdAndInquiryDate(string messageId, int utilityId, string readCycleId, bool isAmr, DateTime inquiryDate);

        /// <summary>
        /// Get UtilityId by UtilityCode
        /// /// </summary>
        /// <param name="messageId"></param>
        /// <param name="utilityCode"></param>
        /// <returns></returns>
        string GetUtilityIdbyUtilityCode(string messageId, string utilityCode);

        /// <summary>
        /// Returns the Data for All Utilities with Accelerated Switch
        /// </summary>
        /// <param name="messageId"></param>
        /// <returns></returns>
        DataSet GetAllUtilitiesAcceleratedSwitchData(string messageId);

        /// <summary>
        /// Returns the Lead Time for Enrollment
        /// </summary>
        /// <param name="messageId"></param>
        /// <param name="utilityId"></param>
        /// <param name="rateClass"></param>
        /// <param name="loadProfile"></param>
        /// <param name="tarrifCode"></param>
        /// <returns></returns>
        DataSet GetEnrollmentLeadTimeData(string messageId, int utilityId, string rateClass, string loadProfile, string tariffCode);
        /// <summary>
        /// Returns the Data for All Utilities Required Fields
        /// </summary>
        /// <param name="messageId"></param>
        /// <returns></returns>
        DataSet GetAllUtilityAccountInfoRequiredFields(string messageId);
        /// <summary>
        /// Returns the ICap Request Mode
        /// </summary>
        /// <param name="messageId"></param>
        /// <param name="utilityId"></param>
        /// <param name="enrollmentType"></param>
        /// <returns></returns>
        DataSet GetAIRequestMode(string messageId, int utilityId, string enrollmentType);
        /// <summary>
        /// Get All Request Mode Like Pre Enrollment and Post Enrollment
        /// </summary>
        /// <param name="messageId"></param>
        /// <returns></returns>
        DataSet GetAllRequestModeEnrollmentTypes(string messageId);
        /// <summary>
        /// Return The Billing Type of Utility
        /// </summary>
        /// <param name="messageId"></param>
        /// <param name="utilityId"></param>
        /// <param name="rateClass"></param>
        /// <param name="loadProfile"></param>
        /// <param name="tariffCode"></param>
        /// <returns></returns>
        DataSet GetBillingType(string messageId, int utilityId, string rateClass, string loadProfile, string tariffCode);

        /// <summary>
        /// Return The Billing Type of Utility
        /// </summary>
        /// <param name="messageId"></param>
        /// <param name="utilityId"></param>
        /// <param name="rateClass"></param>
        /// <param name="loadProfile"></param>
        /// <param name="tariffCode"></param>
        /// <returns></returns>
        DataSet GetBillingTypeWithDefault(string messageId, int utilityId, string rateClass, string loadProfile, string tariffCode);
        /// <summary>
        /// Returns the Capacity Threshold Value
        /// </summary>
        /// <param name="messageId"></param>
        /// <param name="utilityCode"></param>
        /// <param name="accountType"></param>
        /// <returns></returns>
        DataSet GetCapacityThresholdRuleGetByUtilityCodeCustomerAccountType(string messageId, string utilityCode, string accountType);

        /// <summary>
        /// Get Id Request Mode by Stored Procedure USP_GetIDRRequestModeData
        /// </summary>
        /// <param name="messageId"></param>
        /// <param name="rateClassCode"></param>
        /// <param name="loadProfileCode"></param>
        /// <param name="tariffCodeCode"></param>
        /// <param name="eligibility"></param>
        /// <param name="hia"></param>
        /// <param name="utilityIdInt"></param>
        /// <param name="usage"></param>
        /// <param name="enrollmentType"></param>
        /// <returns></returns>
        DataSet GetIdrRequestModeData(string messageId, string rateClassCode, string loadProfileCode, string tariffCodeCode, bool? eligibility, bool? hia, int? utilityIdInt, int? usage, EnrollmentType enrollmentType);
        /// <summary>
        ///  Get Request Mode Data By Parameter
        /// </summary>
        /// <param name="messageId"></param>
        /// <param name="utilityIdInt"></param>
        /// <param name="serviceAccount"></param>
        /// <param name="enrollmentType"></param>
        /// <param name="rateClass"></param>
        /// <param name="loadProfile"></param>
        /// <param name="tariffCode"></param>
        /// <param name="annualUsage"></param>
        /// <param name="hia"></param>
        /// <returns></returns>
        DataSet GetIdrRequestModeDataValuesByParam(string messageId, int utilityIdInt, string serviceAccount, EnrollmentType enrollmentType, string rateClass, string loadProfile, string tariffCode, string annualUsage, bool hia);
        /// <summary>
        /// Get Purchase of Receivable data
        /// </summary>
        /// <param name="messageId"></param>
        /// <param name="utilityId"></param>
        /// <param name="rateClass"></param>
        /// <param name="loadProfile"></param>
        /// <param name="tariffCode"></param>
        /// <param name="effectiveDate"></param>
        /// <returns></returns>
        DataSet GetPurchaseOfReceivableAssurance(string messageId, int utilityId, string loadProfile, string rateClass, string tariffCode, DateTime effectiveDate);
        /// <summary>
        /// Method to get Request Mode for HU
        /// </summary>
        /// <param name="messageId"></param>
        /// <param name="utilityId"></param>
        /// <param name="enrollmentType"></param>
        /// <returns></returns>
        DataSet GetRequestModeHUData(string messageId, int utilityId, EnrollmentType enrollmentType);
    }
}
