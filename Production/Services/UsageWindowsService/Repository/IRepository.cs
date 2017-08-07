using UsageWindowsService.Entities;

namespace UsageWindowsService.Repository
{
    public interface IRepository
    {
        long CreateTransaction(string accountNumber, string utilityCode, string source);

        long GetTransactionId(string accountNumber, string utilityCode);

        void SetTransactionAsComplete(long transactionId);
        void SetTransactionAsComplete(long transactionId, string error);

        AccountStatusMessageType GetAccountStatusMessageType(string message);

        string GetUtilityCode(int utilityId);

        int GetUtilityId(string utilityCode);

        string GetLpcDunsNumber(string utilityCode);

        bool DoesEclDataExist(string accountNumber, int utilityId);
    }
}