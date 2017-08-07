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
    public class GetAllUtilitiesDataResponse : IGetAllUtilitiesDataResponse
    {
        public GetAllUtilitiesDataResponse()
        { }


        public GetAllUtilitiesDataResponse(List<GetAllUtilitiesDataResponseItem> getAllUtilitiesDataResponseItems, string messageId)
        {
            MessageId = messageId;
            UtilitiesData = getAllUtilitiesDataResponseItems;
        }

        [DataMember]
        public string MessageId { get; set; }
        [DataMember]
        public List<GetAllUtilitiesDataResponseItem> UtilitiesData { get; set; }
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
                foreach (GetAllUtilitiesDataResponseItem item in UtilitiesData)
                {
                    utilitiesDataListed.Append(item.ToString());
                }
            }
            string returnValue = string.Format("MessageId:{0};UtilitiesData:[{1}]", MessageId ?? "NULL VALUE", utilitiesDataListed == null ? "NULL VALUE" : utilitiesDataListed.ToString());
            return returnValue;
        }
    }

    [DataContract]
    public class GetAllUtilitiesAcceleratedSwitchResponse : IGetAllUtilitiesAcceleratedSwitchResponse
    {
        public GetAllUtilitiesAcceleratedSwitchResponse()
        { }


        public GetAllUtilitiesAcceleratedSwitchResponse(List<GetAllUtilitiesAcceleratedSwitchResponseItem> getAllUtilitiesAcceleratedSwitchResponseItems, string messageId)
        {
            MessageId = messageId;
            AcceleratedUtilitiesData = getAllUtilitiesAcceleratedSwitchResponseItems;
        }

        [DataMember]
        public string MessageId { get; set; }
        [DataMember]
        public List<GetAllUtilitiesAcceleratedSwitchResponseItem> AcceleratedUtilitiesData { get; set; }
        [DataMember]
        public string Message { get; set; }
        [DataMember]
        public bool IsSuccess { get; set; }
        [DataMember]
        public string Code { get; set; }

        public override string ToString()
        {
            StringBuilder acceleratedUtilitiesDataListed = new StringBuilder();
            if (AcceleratedUtilitiesData != null && AcceleratedUtilitiesData.Count > 0)
            {
                foreach (GetAllUtilitiesAcceleratedSwitchResponseItem item in AcceleratedUtilitiesData)
                {
                    acceleratedUtilitiesDataListed.Append(item.ToString());
                }
            }
            string returnValue = string.Format("MessageId:{0};UtilitiesData:[{1}]", MessageId ?? "NULL VALUE", acceleratedUtilitiesDataListed == null ? "NULL VALUE" : acceleratedUtilitiesDataListed.ToString());
            return returnValue;
        }
    }

    [DataContract]
    public class GetEnrollmentleadTimesDataResponse : IGetEnrollmentleadTimesDataResponse
    {
        public GetEnrollmentleadTimesDataResponse()
        { }


        public GetEnrollmentleadTimesDataResponse(List<GetEnrollmentLeadTimesResponseItem> getEnrollmentLeadTimesResponseItems, string messageId)
        {
            MessageId = messageId;
            EnrollmentLeadTimesData = getEnrollmentLeadTimesResponseItems;
        }

        [DataMember]
        public string MessageId { get; set; }
        [DataMember]
        public List<GetEnrollmentLeadTimesResponseItem> EnrollmentLeadTimesData { get; set; }
        [DataMember]
        public string Message { get; set; }
        [DataMember]
        public bool IsSuccess { get; set; }
        [DataMember]
        public string Code { get; set; }

        public override string ToString()
        {
            StringBuilder EnrollmentLeadTimesDataListed = new StringBuilder();

            if (EnrollmentLeadTimesData != null && EnrollmentLeadTimesData.Count > 0)
            {
                foreach (GetEnrollmentLeadTimesResponseItem item in EnrollmentLeadTimesData)
                {
                    EnrollmentLeadTimesDataListed.Append(EnrollmentLeadTimesData.ToString());
                }
            }
            string returnValue = string.Format("MessageId:{0};UtilitiesData:[{1}]", MessageId ?? "NULL VALUE", EnrollmentLeadTimesDataListed == null ? "NULL VALUE"
                : EnrollmentLeadTimesDataListed.ToString());
            return returnValue;
        }
    }

}