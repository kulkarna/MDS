using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects.Enums
{
    [System.Runtime.Serialization.DataContract]
    public enum ContractType
    {
        [System.Runtime.Serialization.EnumMember]
        VOICE = 1,		//VOICE
        [System.Runtime.Serialization.EnumMember]
        PAPER = 2,		//PAPER
        [System.Runtime.Serialization.EnumMember]
        EDI = 3,		//EDI
        [System.Runtime.Serialization.EnumMember]
        ONLINE = 4		//ONLINE
    }
}
