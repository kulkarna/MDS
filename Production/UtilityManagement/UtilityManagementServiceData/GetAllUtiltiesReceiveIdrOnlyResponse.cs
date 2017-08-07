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
    public class GetAllUtilitiesReceiveIdrOnlyResponse
    {
        #region public constructors
        public GetAllUtilitiesReceiveIdrOnlyResponse()
        { }

        public GetAllUtilitiesReceiveIdrOnlyResponse(string messageId, List<GetAllUtiltiesReceiveIdrOnlyResponseItem> getAllUtiltiesReceiveIdrOnlyResponseItems)
        {
            MessageId = messageId;
            GetAllUtiltiesReceiveIdrOnlyResponseItems = getAllUtiltiesReceiveIdrOnlyResponseItems;
        }
        #endregion


        #region public properties
        [DataMember]
        public string MessageId { get; set; }

        [DataMember]
        public List<GetAllUtiltiesReceiveIdrOnlyResponseItem> GetAllUtiltiesReceiveIdrOnlyResponseItems { get; set; }

        [DataMember]
        public string Message { get; set; }

        [DataMember]
        public bool IsSuccess { get; set; }

        [DataMember]
        public string Code { get; set; }
        #endregion


        public override string ToString()
        {
            StringBuilder getAllUtiltiesReceiveIdrOnlyResponseItems = new StringBuilder();
            if (GetAllUtiltiesReceiveIdrOnlyResponseItems != null && GetAllUtiltiesReceiveIdrOnlyResponseItems.Count > 0)
            {
                foreach (GetAllUtiltiesReceiveIdrOnlyResponseItem item in GetAllUtiltiesReceiveIdrOnlyResponseItems)
                {
                    getAllUtiltiesReceiveIdrOnlyResponseItems.Append(item.ToString());
                    getAllUtiltiesReceiveIdrOnlyResponseItems.Append(";");
                }
            }
            string returnValue = string.Format("GetAllUtiltiesReceiveIdrOnlyResponse[MessageId:{0};Code:{1};IsSuccess:{2};Message:{3};GetAllUtiltiesReceiveIdrOnlyResponseItems:[{4}]", 
                MessageId ?? "NULL VALUE", 
                Code ?? "NULL VALUE",
                IsSuccess,
                Message??"NULL VALUE",
                getAllUtiltiesReceiveIdrOnlyResponseItems == null ? "NULL VALUE" : getAllUtiltiesReceiveIdrOnlyResponseItems.ToString());
            return returnValue;
        }
    }
}