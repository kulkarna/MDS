using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UsageResponseImportProcessor.Entities;

namespace UsageResponseImportProcessor.DataAccess
{
    public interface IUsageResponseDao
    {
        void Save(UsageResponseFile usageResponseFile);

        void Save(UsageResponseFileRow usageResponseFileRow, int fileId);

        void Save(UsageResponse usageResponse);

        void Log(Exception exception);

        void Log(Exception exception, string fileName);

        void Log(Exception exception, string fileName, int rowNumber);

        Utility GetUtilityByTerritoryCode(string territoryCode);

        int? GetAccountId(string accountNumber, int utilityId);

        bool Exists(UsageResponse usageResponse);

        bool IsInLatestSentTransactions(string accountNumber, int utilityId);

        DateTime? GetLatestUsageResponseCreatedTimeStamp();
    }
}
