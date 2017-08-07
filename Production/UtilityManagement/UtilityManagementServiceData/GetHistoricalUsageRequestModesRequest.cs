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
    public class GetHistoricalUsageRequestModesRequest
    {
        [DataMember]
        public int LegacyUtilityId { get; set; }
        [DataMember]
        public int UtilityIdInt { get; set; }
        //[DataMember]
        //public Guid UtilityId { get; set; }
        [DataMember]
        public string UtilityCode { get; set; }
        //[DataMember]
        //public Guid RequestModeEnrollmentTypeId { get; set; }
        [DataMember]
        public EnrollmentType? EnrollmentType { get; set; }
        [DataMember]
        public string MessageId { get; set; }

        public override string ToString()
        {
            return string.Format("UtilityId:{0};LegacyUtilityId:{1};UtilityCode:{2};RequestModeEnrollmentTypeId:{3};MessageId:{4}",
                //UtilityId == null || UtilityId == Guid.Empty ? "NULL VALUE" : UtilityId.ToString(),
                "",
                LegacyUtilityId == 0 ? "NOT SET" : LegacyUtilityId.ToString(),
                UtilityCode == null ? "NULL VALUE" : UtilityCode,
                //RequestModeEnrollmentTypeId == null ? "NULL VALUE" : RequestModeEnrollmentTypeId.ToString(),
                "",
                MessageId ?? "NULL VALUE");
        }
    }
}
