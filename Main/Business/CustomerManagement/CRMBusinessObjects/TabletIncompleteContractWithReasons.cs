using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
    /// <summary>
    /// Flat details with the reasons.
    /// </summary>
    [Serializable]
    [System.Runtime.Serialization.DataContract]
    public class TabletIncompleteContractWithReasons : TabletIncompleteContract
    {
        [DataMember]
        public List<CancelContractReason> CancellationReasons { get; set; }
        [DataMember]
        public string AudioFileName { get; set; }
        [DataMember]
        public string AudiofilePath { get; set; }
        [DataMember]
        public bool IsGas { get; set; }
        [DataMember]
        public string ProductName { get; set; }
        [DataMember]
        public string AgentFirstName { get; set; }
        [DataMember]
        public string AgentLastName { get; set; }
        [DataMember]
        public string ChannelName { get; set; }
        [DataMember]
        public string MarketCode { get; set; }

        [DataMember]
        public string ZipCode { get; set; }

        [DataMember]
        public int MarketId { get; set; }

        [DataMember]
        public Int64? AudioLength { get; set; }
    }
}
