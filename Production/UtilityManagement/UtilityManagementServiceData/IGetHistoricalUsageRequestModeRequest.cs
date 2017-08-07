using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UtilityManagementServiceData
{
    public interface IGetHistoricalUsageRequestModeRequest
    {
        string MessageId { get; set; }
        int LegacyUtilityId { get; set; }
        Guid UtiiltyId { get; set; }
        Guid RequestModeEnrollmentTypeId { get; set; }
    }
}
