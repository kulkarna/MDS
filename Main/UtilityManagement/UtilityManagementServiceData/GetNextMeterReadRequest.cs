using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;
using System.Threading.Tasks;

namespace UtilityManagementServiceData
{
    [DataContract]
    public class GetNextMeterReadRequest
    {
        [DataMember]
        public string MessageId { get; set; }
        [DataMember]
        public int UtilityIdInt { get; set; }
        [DataMember]
        public string TripNumber { get; set; }
        [DataMember]
        public DateTime ReferenceDate { get; set; }
    }
}
