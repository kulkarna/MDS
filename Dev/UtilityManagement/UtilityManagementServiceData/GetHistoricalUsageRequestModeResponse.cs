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
    public class GetHistoricalUsageRequestModeResponse : IResult
    {
        [DataMember]
        public List<HistoricalUsageRequestMode> HistoricalUsageRequestModeList { get; set; }
        [DataMember]
        public string Message { get; set; }
        [DataMember]
        public bool IsSuccess { get; set; }
        [DataMember]
        public string Code { get; set; }
        [DataMember]
        public string MessageId { get; set; }

        public override string ToString()
        {
            StringBuilder value = new StringBuilder();
            if (HistoricalUsageRequestModeList != null)
            {
                foreach (HistoricalUsageRequestMode historicalUsageRequestMode in HistoricalUsageRequestModeList)
                {
                    value.Append(string.Format("HistoricalUsageRequestMode:[{0}]", historicalUsageRequestMode.ToString()));
                }
            }
            return value.ToString();
        }

    }
}
