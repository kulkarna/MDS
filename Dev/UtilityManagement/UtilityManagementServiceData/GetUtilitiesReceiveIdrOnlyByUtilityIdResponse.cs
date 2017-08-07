using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace UtilityManagementServiceData
{
    [DataContract]
    public class GetUtilitiesReceiveIdrOnlyByUtilityIdResponse
    {
        #region public constructors
        public GetUtilitiesReceiveIdrOnlyByUtilityIdResponse()
        { }
        #endregion


        #region public properties
        [DataMember]
        public string MessageId { get; set; }

        [DataMember]
        public bool ReceiveIdrOnlyResponse { get; set; }

        [DataMember]
        public int UtilityId { get; set; }

        [DataMember]
        public string Message { get; set; }

        [DataMember]
        public bool IsSuccess { get; set; }

        [DataMember]
        public string Code { get; set; }
        #endregion


        public override string ToString()
        {
            string returnValue = string.Format("GetUtilitiesReceiveIdrOnlyByUtilityIdResponse[MessageId:{0};ReceiveIdrOnlyResponse:{1};UtilityId:{2};Message:{3};IsSuccess:{4};Code:{5}]", Utilities.Common.NullSafeString(MessageId),
                Utilities.Common.NullSafeString(ReceiveIdrOnlyResponse),
                Utilities.Common.NullSafeString(UtilityId),
                Utilities.Common.NullSafeString(Message),
                Utilities.Common.NullSafeString(IsSuccess),
                Utilities.Common.NullSafeString(Code));
            return returnValue;
        }



    }
}
