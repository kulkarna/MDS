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
    public class UtilityManagementException //: Exception
    {
        public UtilityManagementException(string transactionId, string code, string message)
        {
            TransactionId = transactionId;
            Code = code;
            Message = message;
        }

        [DataMember]
        public string TransactionId { get; set; }
        [DataMember]
        public string Code { get; set; }
        [DataMember]
        public string Message { get; set; }
    }
}
