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
    public class HistoricalUsageRequestMode
    {
        [DataMember]
        public Guid Id { get; set; }
        [DataMember]
        public int UtilityIdInt { get; set; }
        [DataMember]
        public int UtilityLegacyId { get; set; }
        [DataMember]
        public Guid UtilityId { get; set; }
        [DataMember]
        public string UtilityCode { get; set; }
        [DataMember]
        public EnrollmentType EnrollmentType { get; set; }
        [DataMember]
        public string RequestMode { get; set; }
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
            return string.Format("UtilityLegacyId:{0},UtilityId:{1},UtilityCode:{2},EnrollmentType:{3},Address:{4},EmailTemplate:{5},Instructions:{6},UtilitySlaResponse:{7},LibertyPowerSlaResponse:{8},IsLoaRequired:{9}",
                UtilityLegacyId, UtilityId, UtilityCode, EnrollmentType, Address, EmailTemplate, Instructions, UtilitySlaResponse, LibertyPowerSlaResponse, IsLoaRequired);
        }
    }
}
