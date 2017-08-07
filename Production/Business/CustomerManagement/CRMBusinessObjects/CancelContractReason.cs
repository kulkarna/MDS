using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
    /// <summary>
    /// Stores the cancel contract reaon details.
    /// </summary>
    [Serializable]
    [System.Runtime.Serialization.DataContract]
    public class CancelContractReason
    {
        [DataMember]
        public string Code { get; set; }
        [DataMember]
        public string Description { get; set; }
    }
}
