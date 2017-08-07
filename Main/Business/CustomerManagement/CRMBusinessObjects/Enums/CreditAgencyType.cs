using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects.Enums
{
    [Serializable]
    [System.Runtime.Serialization.DataContract]
    public enum CreditAgencyType
    {
        [System.Runtime.Serialization.EnumMember]
        Moodys = 1,
        [System.Runtime.Serialization.EnumMember]
        SNP = 2,
        [System.Runtime.Serialization.EnumMember]
        EXPERIAN = 3,
        [System.Runtime.Serialization.EnumMember]
        Equifax = 4,
        [System.Runtime.Serialization.EnumMember]
        DNB = 5
    }
}
