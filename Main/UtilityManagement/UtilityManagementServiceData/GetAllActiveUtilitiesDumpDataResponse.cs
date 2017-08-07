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
    public class GetAllActiveUtilitiesDumpDataResponse : IGetAllActiveUtilitiesDumpDataResponse
    {
        public GetAllActiveUtilitiesDumpDataResponse()
        { }


        public GetAllActiveUtilitiesDumpDataResponse(List<GetAllActiveUtilitiesDumpDataResponseItem> getAllActiveUtilitiesDumpDataResponseItems, string messageId)
        {
            MessageId = messageId;
            UtilitiesData = getAllActiveUtilitiesDumpDataResponseItems;
        }

        [DataMember]
        public string MessageId { get; set; }
        [DataMember]
        public List<GetAllActiveUtilitiesDumpDataResponseItem> UtilitiesData { get; set; }
        [DataMember]
        public string Message { get; set; }
        [DataMember]
        public bool IsSuccess { get; set; }
        [DataMember]
        public string Code { get; set; }

        public override string ToString()
        {
            StringBuilder utilitiesDataListed = new StringBuilder();
            if (UtilitiesData != null && UtilitiesData.Count > 0)
            {
                foreach (GetAllActiveUtilitiesDumpDataResponseItem item in UtilitiesData)
                {
                    utilitiesDataListed.Append(item.ToString());
                }
            }
            string returnValue = string.Format("MessageId:{0};UtilitiesData:[{1}]", MessageId ?? "NULL VALUE", utilitiesDataListed == null ? "NULL VALUE" : utilitiesDataListed.ToString());
            return returnValue;
        }
    }
}