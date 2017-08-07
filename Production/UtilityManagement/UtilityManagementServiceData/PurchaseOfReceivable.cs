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
    public class PurchaseOfReceivable
    {
        [DataMember]
        public int UtilityId { get; set; }
        [DataMember]
        public Guid UtilityGuid { get; set; }
        [DataMember]
        public string UtilityCode { get; set; }
        [DataMember]
        public Guid PORGuid { get; set; }
        [DataMember]
        public bool IsPorAssurance { get; set; }
        [DataMember]
        public string UtilityAccountType { get; set; }
        [DataMember]
        public string Commodity { get; set; }

        public override string ToString()
        {
            return string.Format("UtilityId:{0},UtilityGuid:{1},UtilityCode:{2},PORGuid:{3},IsPorAssurance:{4},UtilityAccountType:{5},Commodity:{6}",
                UtilityId, UtilityGuid, UtilityCode, PORGuid, IsPorAssurance, UtilityAccountType, Commodity);
        }
    }
}