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
    public class GetMeterReadCalendarByUtilityIdResponse
    {
        public GetMeterReadCalendarByUtilityIdResponse()
        { }

        public GetMeterReadCalendarByUtilityIdResponse(List<GetMeterReadCalendarByUtilityIdResponseItem> getMeterReadCalendarByUtilityIdResponseItems, string messageId)
        {
            MessageId = messageId;
            MeterReadCalendarData = getMeterReadCalendarByUtilityIdResponseItems;
        }
        [DataMember]
        public string MessageId { get; set; }
        [DataMember]
        public List<GetMeterReadCalendarByUtilityIdResponseItem> MeterReadCalendarData { get; set; }
        [DataMember]
        public string Message { get; set; }
        [DataMember]
        public bool IsSuccess { get; set; }
        [DataMember]
        public string Code { get; set; }
        public override string ToString()
        {
            StringBuilder meterReadCalendarDataListed = new StringBuilder();
            if (MeterReadCalendarData != null && MeterReadCalendarData.Count > 0)
            {
                foreach (GetMeterReadCalendarByUtilityIdResponseItem item in MeterReadCalendarData)
                {
                    meterReadCalendarDataListed.Append(item.ToString());
                }
            }
            string returnValue = string.Format("MessageId:{0};MeterReadCalendarData:[{1}]", MessageId ?? "NULL VALUE", meterReadCalendarDataListed == null ? "NULL VALUE" : meterReadCalendarDataListed.ToString());
            return returnValue;
        }

    }
}

