using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects.Enums
{
    [Serializable]
    [System.Runtime.Serialization.DataContract]
    public enum ContractDealType
    {
        [System.Runtime.Serialization.EnumMember]
        New = 1,		//New
        [System.Runtime.Serialization.EnumMember]
        Renewal = 2,		//Renewal
        [System.Runtime.Serialization.EnumMember]
        Conversion = 3,		//Conversion
        [System.Runtime.Serialization.EnumMember]
        //Amendment Added on June 17 2013
        //Bug 7839: 1-64232573 Contract Amendments
        Amendment =4,	//Contract Amendment

        [System.Runtime.Serialization.EnumMember]
        RolloverRenewal = 5		//RolloverRenewal
    }
}
