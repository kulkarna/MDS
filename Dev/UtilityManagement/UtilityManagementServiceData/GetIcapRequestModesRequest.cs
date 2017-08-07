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
    public class GetIcapRequestModesRequest
    {
        [DataMember]
        public int LegacyUtilityId { get; set; }
        [DataMember]
        public int UtilityIdInt { get; set; }
        [DataMember]
        public string UtilityCode { get; set; }
        [DataMember]
        public EnrollmentType? EnrollmentType { get; set; }
        [DataMember]
        public string MessageId { get; set; }

        public override string ToString()
        {
            return string.Format("LegacyUtilityId:{0};UtilityCode:{1};RequestModeEnrollmentTypeId:{2};MessageId:{3}",
                LegacyUtilityId == 0 ? "NOT SET" : LegacyUtilityId.ToString(),
                UtilityCode == null ? "NULL VALUE" : UtilityCode,
                "",
                MessageId ?? "NULL VALUE");
        }
    }
}
