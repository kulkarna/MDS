using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;
using System.Threading.Tasks;

namespace UtilityManagementServiceData
{
    public interface IGetAllUtilitiesResponse : IResult
    {
        string MessageId { get; set; }
        List<GetAllUtilitiesResponseItem> Utilities { get; set; }
        string ToString();
    }
}
