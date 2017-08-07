using System.Data;
using UsageWebService.Entities;

namespace UsageWebService.Repository
{
    public interface IRepository
    {
        long CreateTransaction(string accountNumber, string utilityCode, string source);

        long GetTransactionId(string accountNumber, string utilityCode);

        void SetTransactionAsComplete(long transactionId);
        void SetTransactionAsComplete(long transactionId, string error);

        UsageTransaction GetTransaction(long transactionId);

        AccountStatusMessageType GetAccountStatusMessageType(string message);

        string GetUtilityCode(int utilityId);

        int GetUtilityId(string utilityCode);

        string GetLpcDunsNumber(string utilityCode);

        bool DoesEclDataExist(string accountNumber, int utilityId);
        string GetIdrUsageDate(string accountNumber, string utilitycd);
        UsageResponseIdr GetUsageListIdr(string messageId, DataTable dtUsageRequestIdr);
        UsageResponseNonIdr GetUsageListNonIdr(string messageId, DataTable dtUsageRequestIdr);
    }
}