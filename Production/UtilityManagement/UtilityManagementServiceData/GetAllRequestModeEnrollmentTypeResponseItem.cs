using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UtilityManagementServiceData
{
    public class GetAllRequestModeEnrollmentTypeResponseItem
    {
        public Guid RequestModeEnrollmentTypeId { get; set; }
        public string Name { get; set; }
        public EnrollmentType EnrollmentType { get; set; }
        public override string ToString()
        {
            return string.Format("RequestModeEnrollmentTypeId:{0};Name:{1}", RequestModeEnrollmentTypeId, Name);
        }
    }
}
