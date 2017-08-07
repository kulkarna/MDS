using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SmucRunDto;

namespace SmucRunBusinessLayer
{
    public interface IBusinessLayer
    {
        void GetTransactionsData(string messageId, string utilityCode, string accountNumber);
        ResultData PopulateResultData(string messageId, DataSet dataSet, string fieldName, ResultData resultData);
        MemoryStream Process(string messageId, byte[] byteArray);
        BulkEdiRequestResponse BulkEdiRequestWithResponse(string messageId, byte[] byteArray);
        bool BulkEdiRequest(byte[] byteArray);
        bool BulkScraperRequest(string messageId, byte[] byteArray);
    }
}