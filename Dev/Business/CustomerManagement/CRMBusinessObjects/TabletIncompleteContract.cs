using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
    [Serializable]
    [System.Runtime.Serialization.DataContract]
    public class TabletIncompleteContract
    {
        #region Primary key(s)

        /// <summary>
        /// Unique identifier and primary key for this contract.
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public int TabletIncompleteContractID { get; set; }

        #endregion

        #region Non Primary key(s)

        /// <summary>
        /// Unique identifier and candidate key for this contract.
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public string ContractNumber { get; set; }

        /// <summary>
        /// Identifier to find the Sales Channel.
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public int SalesChannelID { get; set; }

        /// <summary>
        /// Who was the agent creating the contract.
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public int AgentId { get; set; }

        /// <summary>
        /// When the incomplete contract was created.
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public DateTime CreatedDate { get; set; }

        /// <summary>
        /// Details why the contract was cancelled.
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public string AdditionalNotes { get; set; }

        /// <summary>
        /// The account number.
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public string AccountNumber { get; set; }

        /// <summary>
        /// Associated retail market id.
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public int? RetailMarketId { get; set; }

        /// <summary>
        /// Associated utility.
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public int? UtilityId { get; set; }

        /// <summary>
        /// In which zone is this contract being done.
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public string Zone { get; set; }

        /// <summary>
        /// The associated account type.
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public int? AccountTypeId { get; set; }

        /// <summary>
        /// Product associated with contract.
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public int? ProductBrandId { get; set; }

        /// <summary>
        /// When will the contract start.
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public DateTime? ContractStartDate { get; set; }

        /// <summary>
        /// Term of  the contract.
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public int? Term { get; set; }

        /// <summary>
        /// ID of associated service class.
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public string ServiceClassId { get; set; }

        /// <summary>
        /// ID of the associated tier.
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public int? TierId { get; set; }

        /// <summary>
        /// Pricing/rate associated with this contract linked via a price id.
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public long? PriceId { get; set; }

        /// <summary>
        /// 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public string BACity { get; set; }

        /// <summary>
        /// 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public string BAState { get; set; }

        /// <summary>
        /// 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public string BAStreet { get; set; }

        /// <summary>
        /// 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public string BAZip { get; set; }

        /// <summary>
        /// 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public string BCEmail { get; set; }

        /// <summary>
        /// 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public string BCFax { get; set; }

        /// <summary>
        /// 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public string BCFirstName { get; set; }

        /// <summary>
        /// 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public string BCLastName { get; set; }

        /// <summary>
        /// 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public string BCPhone { get; set; }

        /// <summary>
        /// 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public string BCTitle { get; set; }

        /// <summary>
        /// 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public string SACity { get; set; }

        /// <summary>
        /// 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public string SAState { get; set; }

        /// <summary>
        /// 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public string SAStreet { get; set; }

        /// <summary>
        /// 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public string SAZip { get; set; }

        /// <summary>
        /// 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public string CISSN { get; set; }

        /// <summary>
        /// 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public string CIEmail { get; set; }

        /// <summary>
        /// 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public string CIFax { get; set; }

        /// <summary>
        /// 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public string CIFirstName { get; set; }

        /// <summary>
        /// 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public string CILastName { get; set; }

        /// <summary>
        /// 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public string CIPhone { get; set; }

        /// <summary>
        /// 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public string CITitle { get; set; }

        /// <summary>
        /// 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public string CACity { get; set; }

        /// <summary>
        /// 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public string CAState { get; set; }

        /// <summary>
        /// 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public string CAStreet { get; set; }

        /// <summary>
        /// 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public string CASuite { get; set; }

        /// <summary>
        /// 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public string CAZip { get; set; }

        /// <summary>
        /// Name used for this business.
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public string BusinessName { get; set; }

        /// <summary>
        /// ?
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public string DBA { get; set; }

        /// <summary>
        /// ?
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public string BusinessType { get; set; }

        /// <summary>
        /// ?
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public string DUNS { get; set; }

        /// <summary>
        /// ?
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public int? ContractTypeId { get; set; }

        /// <summary>
        /// Tax ID provided.
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public string TaxId { get; set; }

        /// <summary>
        /// Language of the contract (typically English or Spanish)
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public string Language { get; set; }

        /// <summary>
        /// The promo code used with the contract if any.
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public string PromoCode { get; set; }

        /// <summary>
        /// Origin of submission.
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public string Origin { get; set; }

        /// <summary>
        /// API Key used to submit the contract
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public Guid? ClientSubmitApplicationKey { get; set; }

        /// <summary>
        /// ?
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public string Review { get; set; }

        /// <summary>
        /// ?
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public bool? OutCome { get; set; }

        /// <summary>
        /// Who modified this contract in the form of an ID.
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public int? ModifiedBy { get; set; }

        /// <summary>
        /// Date when contract was modified.
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public DateTime? ModifiedDate { get; set; }


        /// <summary>
        /// Length of the incomplete contract details Audio File
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.Int64? AudioLength { get; set; }
        #endregion
    }
}
