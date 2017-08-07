using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SmucDataLayer
{
    public interface IDal
    {

        DataTable Usp_GetAccountDetails(string messageId, DataTable dtRecords);
        DataTable Usp_GetDetailsDetailsByTransactionId(string messageId, DataTable dtRecords);
        DataSet Usp_GetUtilityByIso(string messageId, string isoId);
        DataSet Usp_GetIso(string messageId);
    }
}
