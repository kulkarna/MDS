using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UtilityManagementServiceData;

namespace UtilityManagementBusinessLayer
{
    public interface IBusinessLayer
    {

        GetAllUtilitiesReceiveIdrOnlyResponse GetAllUtiltiesReceiveIdrOnly(string messageId);
        GetUtilitiesReceiveIdrOnlyByUtilityIdResponse GetUtilitiesReceiveIdrOnlyByUtilityId(string messageId, int utilityId);

        GetNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse GetNextMeterReadDateByUtilityIdReadCycleIdAndInquiryDate(string messageId, int utilityId, string readCycleId, bool isAmr, DateTime inquiryDate);
        GetPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDateResponse GetPreviousMeterReadDateByUtilityIdReadCycleIdAndInquiryDate(string messageId, int utilityId, string readCycleId, bool isAmr, DateTime inquiryDate);

        GetMeterReadCalendarByUtilityIdResponse GetMeterReadCalendarByUtilityId(string messageId, int utilityId);
        GetMeterReadCalendarByUtilityIdResponse GetErrorMessageResponse(string messageId);
        bool GetAcceleratedSwitchbyUtilityCode(string messageId, string UtilityCode);
        IGetAllUtilitiesAcceleratedSwitchResponse GetAllUtilitiesAcceleratedSwitch(string messageId);
        GetCapacityThresholdRuleResponse GetCapacityThresholdRule(string messageId, string utilityCode, string accountType);

        RequestMode GetHURequestMode(string messageId, int utilityId, EnrollmentType enrollmentType);
        RequestMode GetIcapRequestModeData(string messageId, int utilityIdInt, EnrollmentType enrollmentType);

        IdrRequestMode GetIdrRequestModeData(string messageId, int utilityIdInt, string serviceAccount, EnrollmentType enrollmentType, string loadProfile, string rateClass, string tariffCode, int? annualUsage, bool hasEligibilityRuleBeenSatisfied, bool hia);

        HasPurchaseOfReceivableAssuranceResponse HasPurchaseOfReceivableAssurance(string messageId, int utilityIdInt, string loadProfile, string rateClass, string tariffCode, DateTime porEffectiveDate);

        GetBillingTypeResponse GetBillingTypes(string messageId, int utilityIdInt, string loadProfile, string rateClass, string tariffCode);
        GetBillingTypeWithDefaultResponse GetBillingTypesWithDefault(string messageId, int utilityIdInt, string loadProfile, string rateClass, string tariffCode);
        IGetAllUtilitiesResponse GetAllUtilities(string messageId);

        IGetAllRequestModeEnrollmentTypesResponse GetAllRequestModeEnrollmentTypes(string messageId);

        IGetAllUtilitiesDataResponse GetAllUtilitiesData(string messageId);

        GetNextMeterReadResponse GetNextMeterRead(string messageId, int utilityIdInt, string tripNumber, DateTime referenceDate);
        DateTime? GetNextMeterReadEstimated(string messageId, int utilityIdInt, string tripNumber, DateTime referenceDate, string accountNumber);

        List<AccountInfoRequiredFields> GetAllUtilityAccountInfoRequiredFields(string messageId);

        int GetUtilityIdByUtilityCode(string messageId, string utilityCode);
        string GetUtilityCodeByUtilityId(string messageId, int utilityId);
        string GetZoneByUtilityCodeAndZipCodeFromDealCapture(string messageId, string utilityCode, string zipCode);
        string GetZoneByAccountNumberFromErcot(string messageId, string accountNumber);
        IGetEnrollmentleadTimesDataResponse GetUtilityEnrollmentLeadTimeData(string messageId, int utilityId, string rateClass, string loadProfile, string tariffCode);
        bool DoesUtilityCodeBelongToIso(string messageId, string Iso, string UtilityCode);
        IGetAllActiveUtilitiesDumpDataResponse GetAllActiveUtilitiesDumpData(string messageId, string energyType);

    }
}