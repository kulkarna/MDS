using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SmucBusinessLayer
{
    public interface IBusinessLayer
    {
        BulkRequestResponse RunProcess(string messageId, List<DataRecord> records);
        DataTable GetProcessingDetailByTransactionId(string messageId, DataTable transactionIds);
        DataSet GetIso(string messageId);
        DataSet GetUtility(string messageId, string isoId);
        DataSet GetResults(string messageId, string isoId, string utility, string accountNumber);
    }
}
