using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects.Enums
{
    [Serializable]
    [System.Runtime.Serialization.DataContract]
    public enum BillingType
    {
        [System.Runtime.Serialization.EnumMember]
        NotSet= 0,
        [System.Runtime.Serialization.EnumMember]
        BR = 1,		//BR
        [System.Runtime.Serialization.EnumMember]
        DUAL = 2,		//DUAL
        [System.Runtime.Serialization.EnumMember]
        RR = 3,		//RR
        [System.Runtime.Serialization.EnumMember]
        SC = 4		//SC
    }
}
