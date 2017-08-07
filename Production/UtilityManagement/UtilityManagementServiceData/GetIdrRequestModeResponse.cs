using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;
using System.Threading.Tasks;

namespace UtilityManagementServiceData
{
    public class GetIdrRequestModeResponse : IResult
    {
        [DataMember]
        public List<IdrRequestMode> IdrRequestModeList { get; set; }
        [DataMember]
        public string Message { get; set; }
        [DataMember]
        public bool IsSuccess { get; set; }
        [DataMember]
        public string Code { get; set; }
        [DataMember]
        public string MessageId { get; set; }
    }
}