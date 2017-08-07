using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;
using System.Threading.Tasks;

namespace UtilityManagementServiceData
{
    public interface IGetAllUtilitiesDataResponse : IResult
    {
        string MessageId { get; set; }
        List<GetAllUtilitiesDataResponseItem> UtilitiesData { get; set; }
        string ToString();
    }
    public interface IGetEnrollmentleadTimesDataResponse : IResult
    {
        string MessageId { get; set; }
       List< GetEnrollmentLeadTimesResponseItem> EnrollmentLeadTimesData { get; set; }        
        string ToString();
    }


    public interface IGetAllActiveUtilitiesDumpDataResponse : IResult
    {
        string MessageId { get; set; }
        List<GetAllActiveUtilitiesDumpDataResponseItem> UtilitiesData { get; set; }
        string ToString();
    }

    public interface IGetAllUtilitiesAcceleratedSwitchResponse : IResult
    {
        string MessageId { get; set; }
        List<GetAllUtilitiesAcceleratedSwitchResponseItem> AcceleratedUtilitiesData { get; set; }
        string ToString();
    }
}
