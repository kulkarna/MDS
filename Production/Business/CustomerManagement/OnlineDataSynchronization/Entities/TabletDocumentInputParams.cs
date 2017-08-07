using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Web;

namespace LibertyPower.Business.CustomerManagement.OnlineDataSynchronization
{
    [DataContract]
    public class TabletDocumentInputParams
    {
        /// <summary>
        /// Gets or Sets the MarketId.
        /// </summary>
        [DataMember]
        public int MarketID { get; set; }
        /// <summary>
        /// Gets or Sets the BrandId.
        /// </summary>
        [DataMember]
        public int BrandID { get; set; }
        /// <summary>
        /// Gets or Sets the ChannelID
        /// We need channelID for getting the flyer documents or any other
        /// document type specific to a channel
        /// </summary>
        [DataMember]
        public int ChannelID { get; set; }

    }
  
}