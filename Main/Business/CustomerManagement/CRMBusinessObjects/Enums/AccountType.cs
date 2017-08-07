using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects.Enums
{
    [Serializable]
    [System.Runtime.Serialization.DataContract]
    public enum AccountType
    {
        [System.Runtime.Serialization.EnumMember]
        LCI = 1,		//Large Commercial Industrial
        [System.Runtime.Serialization.EnumMember]
        SMB = 2,		//Commercial
        [System.Runtime.Serialization.EnumMember]
        RES = 3,		//Residential
        [System.Runtime.Serialization.EnumMember]
        SOHO = 4		//Small Office Home Office
    }
}
