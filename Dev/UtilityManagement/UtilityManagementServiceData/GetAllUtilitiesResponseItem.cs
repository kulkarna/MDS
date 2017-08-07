using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.Serialization;
using System.ServiceModel;

namespace UtilityManagementServiceData
{
    [DataContract]
    public class GetAllUtilitiesResponseItem
    {
        [DataMember]
        public Guid UtilityId { get; set; }
        [DataMember]
        public int LegacyUtilityId { get; set; }
        [DataMember]
        public string UtilityCode { get; set; }
        [DataMember]
        public int UtilityIdInt { get; set; }
        public override string ToString()
        {
            return string.Format("UtilityId:{0};LegacyUtilityId:{1};UtilityCode:{2};UtilityIdInt:{3}", UtilityId, LegacyUtilityId, UtilityCode ?? "NULL VALUE", UtilityIdInt);
        }
    }
}
