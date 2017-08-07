using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
    /// <summary>
    /// Stores Sales agent details.
    /// </summary>
    [Serializable]
    [System.Runtime.Serialization.DataContract]
    public class SalesAgent 
    {
        [DataMember]
        public int AgentId { get; set; }
        [DataMember]
        public string AgentFirstName { get; set; }
        [DataMember]
        public string AgentLastName { get; set; }
        [DataMember]
        public string UserName { get; set; }

    }
}
