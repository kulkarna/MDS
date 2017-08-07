using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SmucRunDataAccessLayer
{
    public interface IDal
    {
        DataSet usp_EdiAccountICapByUtilityCodeAndAccountNumber(string messageId, string utilityCode, string accountNumber);
        DataSet usp_EdiAccountTCapByUtilityCodeAndAccountNumber(string messageId, string utilityCode, string accountNumber);
        DataSet usp_EdiAccountZoneByUtilityCodeAndAccountNumber(string messageId, string utilityCode, string accountNumber);
        DataSet usp_EdiAccountLoadProfileByUtilityCodeAndAccountNumber(string messageId, string utilityCode, string accountNumber);
        DataSet usp_EdiAccountRateClassByUtilityCodeAndAccountNumber(string messageId, string utilityCode, string accountNumber);
    }
}
