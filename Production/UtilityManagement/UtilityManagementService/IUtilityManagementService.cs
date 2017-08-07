using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;
using UtilityManagementServiceData;

namespace UtilityManagementService
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the interface name "IService1" in both code and config file together.
    [ServiceContract]
    public interface IUtilityManagementService
    {

        [OperationContract]
        [FaultContract(typeof(UtilityManagementException))]
        string GetData(int value);

        [OperationContract]
        [FaultContract(typeof(UtilityManagementException))]
        bool DoesUtilityCodeBelongToIso(string messageId, string Iso, string UtilityCode);

        [OperationContract]
        [FaultContract(typeof(UtilityManagementException))]
        RequestMode GetAIRequestMode(int utilityId, EnrollmentType enrollmentType);

        [OperationContract]
        [FaultContract(typeof(UtilityManagementException))]
        GetAllRequestModeEnrollmentTypesResponse GetAllRequestModeEnrollmentTypes(string messageId);

        [OperationContract]
        [FaultContract(typeof(UtilityManagementException))]
        GetAllRequestModeEnrollmentTypesResponse GetAllRequestModeEnrollmentTypesNoTrace();

        [OperationContract]
        [FaultContract(typeof(UtilityManagementException))]
        GetAllUtilitiesResponse GetAllUtilities(string messageId);

        [OperationContract]
        [FaultContract(typeof(UtilityManagementException))]
        GetAllUtilitiesDataResponse GetAllUtilitiesData(string messageId);

        [OperationContract]
        [FaultContract(typeof(UtilityManagementException))]
        GetAllUtilitiesResponse GetAllUtilitiesNoTrace();

        //[OperationContract]
        //[FaultContract(typeof(UtilityManagementException))]
        //GetAllUtilitiesReceiveIdrOnlyResponse GetAllUtiltiesReceiveIdrOnly(string messageId);

        [OperationContract]
        [FaultContract(typeof(UtilityManagementException))]
        List<AccountInfoRequiredFields> GetAllUtilityAccountInfoRequiredFields();

        [OperationContract]
        [FaultContract(typeof(UtilityManagementException))]
        GetBillingTypeResponse GetBillingTypes(int utilityId, string rateClass, string loadProfile, string tariffCode);

        [OperationContract]
        [FaultContract(typeof(UtilityManagementException))]
        GetBillingTypeWithDefaultResponse GetBillingTypesWithDefault(int utilityId, string rateClass, string loadProfile, string tariffCode);
        

        [OperationContract]
        [FaultContract(typeof(UtilityManagementException))]
        GetCapacityThresholdRuleResponse GetCapacityThresholdRule(string messageId, string utilityCode, string accountType);

        [OperationContract]
        [FaultContract(typeof(UtilityManagementException))]
        RequestMode GetHURequestMode(int utilityId, EnrollmentType enrollmentType);

        [OperationContract]
        [FaultContract(typeof(UtilityManagementException))]
        IdrRequestMode GetIDRRequestModeData(string messageId, int utilityId, string serviceAccount, EnrollmentType enrollmentType, string loadProfile, string rateClass, string tariffCode, int? annualUsage, bool hasEligibilityRuleBeenSatisfied, bool hia);

        [OperationContract]
        [FaultContract(typeof(UtilityManagementException))]
        GetMeterReadCalendarByUtilityIdResponse GetMeterReadCalendarByUtilityId(string messageId, int utilityId);

        [OperationContract]
        [FaultContract(typeof(UtilityManagementException))]
        GetNextMeterReadResponse GetNextMeterRead(GetNextMeterReadRequest getNextMeterReadRequest);

        [OperationContract]
        [FaultContract(typeof(UtilityManagementException))]
        DateTime GetNextMeterReadDateForAccount(int utilityId, string serviceAccountNumber, string tripNumber, DateTime contextdate);

        [OperationContract]
        [FaultContract(typeof(UtilityManagementException))]
        GetNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse GetNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDate(string messageId, int utilityId, string readCycleId, bool isAmr, DateTime inquiryDate);

        [OperationContract]
        [FaultContract(typeof(UtilityManagementException))]
        GetPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse GetPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDate(string messageId, int utilityId, string readCycleId, bool isAmr, DateTime inquiryDate);

        //[OperationContract]
        //[FaultContract(typeof(UtilityManagementException))]
        //GetUtilitiesReceiveIdrOnlyByUtilityIdResponse GetUtilitiesReceiveIdrOnlyByUtilityId(string messageId, int utilityId);

        [OperationContract]
        [FaultContract(typeof(UtilityManagementException))]
        string GetUtilityCodeByUtilityId(string messageId, int utilityId);

        [OperationContract]
        [FaultContract(typeof(UtilityManagementException))]
        int GetUtilityIdByUtilityCode(string messageId, string utilityCode);

        [OperationContract]
        [FaultContract(typeof(UtilityManagementException))]
        bool HasPorAssurance(int utilityId, string rateClass, string loadProfile, string tariffCode, BillingType billingType);

        //[OperationContract]
        //[FaultContract(typeof(UtilityManagementException))]
        //HasPurchaseOfReceivableAssuranceResponse PorAssurance(int utilityId, string rateClass, string loadProfile, string tariffCode, DateTime effectiveDate);

        [OperationContract]
        [FaultContract(typeof(UtilityManagementException))]
        GetAllActiveUtilitiesDumpDataResponse GetAllActiveUtilitiesDataDump(string messageId);

        [OperationContract]
        [FaultContract(typeof(UtilityManagementException))]
        bool GetAcceleratedSwitchbyUtilityCode(string messageId, string UtilityCode);

        [OperationContract]
        [FaultContract(typeof(UtilityManagementException))]
        GetAllUtilitiesAcceleratedSwitchResponse GetAllUtilitiesAcceleratedSwitch(string messageId);

        [OperationContract]
        [FaultContract(typeof(UtilityManagementException))]
        GetEnrollmentleadTimesDataResponse GetEnrollmentLeadTimes(string messageId,int utilityId, string rateClass, string loadProfile, string tariffCode);

    }
}