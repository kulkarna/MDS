using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UtilityManagementServiceData
{
    public class GetAllRequestModeEnrollmentTypesResponse : IGetAllRequestModeEnrollmentTypesResponse
    {
        private const string NULLVALUE = "NULL VALUE";
        public string MessageId { get; set; }
        public List<GetAllRequestModeEnrollmentTypeResponseItem> RequestModeEnrollmentTypes { get; set; }
        public string Message { get; set; }
        public bool IsSuccess { get; set; }
        public string Code { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            foreach (GetAllRequestModeEnrollmentTypeResponseItem item in RequestModeEnrollmentTypes)
            {
                stringBuilder.Append(string.Format("[GetAllRequestModeEnrollmentTypeResponseItem:{0}",item.ToString()));
            }
            return string.Format("MessageId:{0};RequestModeEnrollmentTypes:[{1}];IsSuccess:{3};Code:{4};Message:{2}", MessageId ?? NULLVALUE, stringBuilder, Message ?? NULLVALUE, IsSuccess, Code ?? NULLVALUE);
        }
    }
}
