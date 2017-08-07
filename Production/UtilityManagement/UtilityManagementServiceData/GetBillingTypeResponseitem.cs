using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace UtilityManagementServiceData
{
    [DataContract]
    public class GetBillingTypeWithDefaultResponseitem
    {
        [DataMember]
        public string BillingType { get; set; }
        [DataMember]
        public string AccountType { get; set; }
        [DataMember]
        public bool IsDefault { get; set; }
    }

    [DataContract]
    public class GetBillingTypeResponseitem
    {
        [DataMember]
        public string BillingType { get; set; }
        [DataMember]
        public string AccountType { get; set; }
    }
  
}
