using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects.Enums
{
    [Serializable]
    [System.Runtime.Serialization.DataContract]
    public enum ContractTemplate
    {
        [System.Runtime.Serialization.EnumMember]
        NotSet = 0,
        [System.Runtime.Serialization.EnumMember]
        Normal = 1,		//Normal
        [System.Runtime.Serialization.EnumMember]
        Custom = 2,		//Custom
        [System.Runtime.Serialization.EnumMember]
        Modified = 3	//Modified
    }
}
