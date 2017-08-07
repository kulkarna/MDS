using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{

    /// <summary>
    /// Store the market detail
    /// </summary>
    [Serializable]
    [System.Runtime.Serialization.DataContract]
    public class Market
    {
        #region Constructors
        public Market()
        { }
        #endregion


        #region Properties


        #region Primary Key
        /// <summary>
        /// Market ID
        /// </summary>
        [DataMember]
        public int MarketID { get; set; }
        #endregion

        #region Foreign Key
        /// <summary>
        /// Whole Sale Market ID
        /// </summary>
        [DataMember]
        public int? WholeSaleMarketID { get; set; }
        #endregion


        /// <summary>
        /// Market Code
        /// </summary>
        [DataMember]
        public string MarketCode { get; set; }

        /// <summary>
        ///PUC Certification number
        /// </summary>
        [DataMember]
        public int PUCCertificationNumber { get; set; }

        /// <summary>
        /// Retail Market description
        /// </summary>
        [DataMember]
        public string RetailMarketDescription { get; set; }

        /// <summary>
        /// Indicate if Market is active.
        /// </summary>
        [DataMember]
        public char InactiveIndicator { get; set; }


        /// <summary>
        /// Date the market was active
        /// </summary>
        [DataMember]
        public DateTime ActiveDate { get; set; }


        /// <summary>
        /// Date when the market was created
        /// </summary>
        [DataMember]
        public DateTime DateCreated { get; set; }


        /// <summary>
        /// User name
        /// </summary>
        [DataMember]
        public string UserName { get; set; }


        /// <summary>
        /// Can ownership be transferred
        /// </summary>
        [DataMember]
        public bool EnableTransferOwnerShip { get; set; }

        /// <summary>
        /// Is Tired pricing Enabled
        /// </summary>
        [DataMember]
        public bool EnableTiredPricing { get; set; }
        #endregion
    }

}