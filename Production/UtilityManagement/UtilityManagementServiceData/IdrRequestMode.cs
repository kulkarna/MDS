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
    public class IdrRequestMode : RequestMode
    {
        [DataMember]
        public bool IsProhibited { get; set; }
        [DataMember]
        public bool IsAlwaysRequestSet { get; set; }

        public override string ToString()
        {
            return string.Format("IdrRequestMode[UtilityId:{0},EnrollmentType:{1},RequestModeType:{2},Address:{3},EmailTemplate:{4},Instructions:{5},UtilitySlaResponse:{6},LibertyPowerSlaResponse:{7},IsLoaRequired:{8},IsProhibited:{9}]",
                UtilityId, EnrollmentType, RequestModeType ?? "NULL VALUE", Address ?? "NULL VALUE", EmailTemplate ?? "NULL VALUE", Instructions ?? "NULL VALUE", UtilitySlaResponse, LibertyPowerSlaResponse, IsLoaRequired, IsProhibited);
        }

    }
}
