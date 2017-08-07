using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UtilityManagementServiceData
{
    public interface IGetAllRequestModeEnrollmentTypesResponse : IResult
    {
        string MessageId { get; set; }
        List<GetAllRequestModeEnrollmentTypeResponseItem> RequestModeEnrollmentTypes { get; set; }
        string ToString();
    }
}
