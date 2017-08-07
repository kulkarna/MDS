using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
    [Serializable]
    [System.Runtime.Serialization.DataContract]
    public class InCompleteContractCancelReasons
    {

        public InCompleteContractCancelReasons()
        {
        }

        #region Primary key(s)

        /// <summary>
        /// Unique identifier for this contract.
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public string IncompleteContractNumber { get; set; }

        #endregion

        #region Non Primary key(s)

        /// <summary>
        /// Reason code why the contract was cancelled. Reason code is a candidate key to a full reason description in CancelContractReason table.
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public List<string> CancelContractReasonCodes { get; set; }

        #endregion
    }
}
