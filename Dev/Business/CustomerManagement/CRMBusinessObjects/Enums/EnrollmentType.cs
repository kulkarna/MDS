using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects.Enums
{
    [Serializable]
    [System.Runtime.Serialization.DataContract]
    public enum EnrollmentType
    {
        [System.Runtime.Serialization.EnumMember]
        Standard = 1,		//Standard
        [System.Runtime.Serialization.EnumMember]
        MoveIn = 3,		//Move In
        [System.Runtime.Serialization.EnumMember]
        MoveInCurrentlyDeenergized = 4,		//Move In - Currently De-energized
        [System.Runtime.Serialization.EnumMember]
        SelfSelected = 5,		//Self Selected
        [System.Runtime.Serialization.EnumMember]
        OffcyclePriority = 6,		//Offcycle Priority
        [System.Runtime.Serialization.EnumMember]
        StandardFutureMonth = 8		//Standard (Future Month)
    }
}
