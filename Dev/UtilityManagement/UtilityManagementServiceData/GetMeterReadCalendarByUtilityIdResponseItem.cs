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
   public class GetMeterReadCalendarByUtilityIdResponseItem
    {
        [DataMember]
        public string UtilityCode { get; set; }
        [DataMember]
        public int Year { get; set; }
        [DataMember]
        public int Month { get; set; }
        [DataMember]
        public string ReadCycleId { get; set; }
        [DataMember]
        public Boolean IsAmr { get; set; }
        [DataMember]
        public DateTime ReadDate { get; set; }
        [DataMember]
        public string CreatedBy { get; set; }
        [DataMember]
        public DateTime CreatedDate { get; set; }
        [DataMember]
        public string LastModifiedBy { get; set; }
        [DataMember]
        public DateTime LastModifiedDate { get; set; }

    }
}
