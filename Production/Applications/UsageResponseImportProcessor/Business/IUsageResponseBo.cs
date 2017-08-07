using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UsageResponseImportProcessor.Entities;

namespace UsageResponseImportProcessor.Business
{
    public interface IUsageResponseBo
    {
        bool HeaderIsValid(string fileHeader);

        void SetUsageResponseFile(UsageResponseFile usageResponseFile);

        void ValidateRows();

        bool HasInvalidData();

        bool HasUnexpectedError();

        void SaveEdiTransactions();

        void SaveFile();
    }
}
