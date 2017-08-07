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
    public class RequestMode
    {
        [DataMember]
        public int UtilityId { get; set; }
        [DataMember]
        public EnrollmentType EnrollmentType { get; set; }
        [DataMember]
        public string RequestModeType { get; set; }
        [DataMember]
        public string Address { get; set; }
        [DataMember]
        public string EmailTemplate { get; set; }
        [DataMember]
        public string Instructions { get; set; }
        [DataMember]
        public int UtilitySlaResponse { get; set; }
        [DataMember]
        public int LibertyPowerSlaResponse { get; set; }
        [DataMember]
        public bool IsLoaRequired { get; set; }

        public override string ToString()
        {
            return string.Format("RequestMode[UtilityId:{0},EnrollmentType:{1},RequestModeType:{2},Address:{3},EmailTemplate:{4},Instructions:{5},UtilitySlaResponse:{6},LibertyPowerSlaResponse:{7},IsLoaRequired:{8}]",
                UtilityId, EnrollmentType, RequestModeType ?? "NULL VALUE", Address ?? "NULL VALUE", EmailTemplate ?? "NULL VALUE", Instructions ?? "NULL VALUE", UtilitySlaResponse, LibertyPowerSlaResponse, IsLoaRequired);
        }
    }
}