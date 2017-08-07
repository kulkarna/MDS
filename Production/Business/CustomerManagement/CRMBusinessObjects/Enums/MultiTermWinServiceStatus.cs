using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects.Enums
{
    [Serializable]
    [System.Runtime.Serialization.DataContract]
    public enum MultiTermWinServiceStatus
    {
        [System.Runtime.Serialization.EnumMember]
        Pending = 1,
        [System.Runtime.Serialization.EnumMember]
        RateEndStartDateToBeAdjusted = 2,
        [System.Runtime.Serialization.EnumMember]
        ReadyToIsta = 3,
        [System.Runtime.Serialization.EnumMember]
        SubmitionToIstaSucceeded = 4,
        [System.Runtime.Serialization.EnumMember]
        SubmittionToIstaFailed = 5,
        [System.Runtime.Serialization.EnumMember]
        SubmitionVerifiedAndConfirmedByIsta = 6,
        [System.Runtime.Serialization.EnumMember]
        SubmitionVerifiedAndNotConfirmedByIsta = 7
    }
}
