using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects.Enums
{
    [Serializable]
    [System.Runtime.Serialization.DataContract]
    public enum TaxStatus
    {
        [System.Runtime.Serialization.EnumMember] // WFC has problems with default values and we need a "default" value for serialization
        NotSet = 0,
        [System.Runtime.Serialization.EnumMember]
        Exempt = 1,
        [System.Runtime.Serialization.EnumMember]
        Full = 2,
        [System.Runtime.Serialization.EnumMember]
        NotFull = 3
    }
}
