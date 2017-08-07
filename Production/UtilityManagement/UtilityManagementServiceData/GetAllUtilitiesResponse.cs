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
    public class GetAllUtilitiesResponse : IGetAllUtilitiesResponse
    {
        public GetAllUtilitiesResponse()
        { }


        public GetAllUtilitiesResponse(List<GetAllUtilitiesResponseItem> getAllUtilitiesResponseItems, string messageId)
        {
            MessageId = messageId;
            Utilities = getAllUtilitiesResponseItems;
        }

        [DataMember]
        public string MessageId { get; set; }
        [DataMember]
        public List<GetAllUtilitiesResponseItem> Utilities { get; set; }
        [DataMember]
        public string Message { get; set; }
        [DataMember]
        public bool IsSuccess { get; set; }
        [DataMember]
        public string Code { get; set; }

        public override string ToString()
        {
            StringBuilder utilitiesListed = new StringBuilder();
            if (Utilities != null && Utilities.Count > 0)
            {
                foreach (GetAllUtilitiesResponseItem item in Utilities)
                {
                    utilitiesListed.Append(item.ToString());
                }
            }
            string returnValue = string.Format("MessageId:{0};Utilities:[{1}]", MessageId ?? "NULL VALUE", utilitiesListed == null ? "NULL VALUE" : utilitiesListed.ToString());
            return returnValue;
        }
    }
}