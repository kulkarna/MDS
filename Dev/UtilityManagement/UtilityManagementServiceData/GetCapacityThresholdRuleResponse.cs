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
    public class GetCapacityThresholdRuleResponse
    {
        public GetCapacityThresholdRuleResponse()
        { 
        }

        [DataMember]
        public string MessageId { get; set; }
        [DataMember]
        public bool? UseCapacityThreshold { get; set; }
        [DataMember]
        public int? CapacityThreshold { get; set; }
        [DataMember]
        public int? CapacityThresholdMax { get; set; }
        [DataMember]
        public string Message { get; set; }
        [DataMember]
        public bool IsSuccess { get; set; }
        [DataMember]
        public string Code { get; set; }

        public override string ToString()
        {
            string returnValue = string.Format("MessageId:{0};UseCapacityThreshold:{1};CapacityThreshold:{2};CapacityThresholdMax:{3};IsSuccess:{4};Code:{5};Message:{6}",
                MessageId ?? "NULL VALUE",
                UseCapacityThreshold == null ? "NULL VALUE" : UseCapacityThreshold.ToString(),
                CapacityThreshold == null ? "NULL VALUE" : CapacityThreshold.ToString(),
                CapacityThresholdMax == null ? "NULL VALUE" : CapacityThresholdMax.ToString(),
                //CapacityThresholdDecimal == null ? "NULL VALUE" : CapacityThresholdDecimal.ToString(),
                //CapacityThresholdMax == null ? "NULL VALUE" : CapacityThresholdMax.ToString(),
                IsSuccess,
                Code ?? "NULL VALUE",
                Message ?? "NULL VALUE");
            return returnValue;
        }
    }
}