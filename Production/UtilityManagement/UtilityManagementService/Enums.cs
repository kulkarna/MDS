using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;
using System.Threading.Tasks;

namespace UtilityManagementService
{
    [DataContract]
    public enum EnrollmentType
    {
        PreEnrollment = 0,
        PostEnrollment = 1
    }
}
