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
    public class GetIdrRequestModesRequest
    {
        [DataMember]
        public string MessageId { get; set; }
        [DataMember]
        public int UtilityIdInt { get; set; }
        [DataMember]
        public string ServiceAccount { get; set; }
        [DataMember]
        public EnrollmentType EnrollmentType { get; set; }
        [DataMember]
        public string RateClass { get; set; }
        [DataMember]
        public string LoadProfile { get; set; }
        [DataMember]
        public string AnnualUsage { get; set; }
        [DataMember]
        public bool? HIA { get; set; }
    }
}
