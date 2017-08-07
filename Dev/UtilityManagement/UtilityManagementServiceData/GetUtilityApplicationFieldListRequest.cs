using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;
using System.Threading.Tasks;

namespace UtilityManagementServiceData
{
    public class AccountInfoRequiredFields
    {
        [DataMember]
        public int UtilityId { get; set; }
        [DataMember]
        public string UtilityCode { get; set; }
        [DataMember]
        public List<string> RequiredFields { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder(string.Format("AccountInfoRequiredFields[UtilityId:{0},UtilityCode:{1},RequiredFields:[", UtilityId, UtilityCode));
            foreach (string value in RequiredFields)
            {
                stringBuilder.Append(string.Format("RequiredField:{0} ", value));
            }
            stringBuilder.Append("]]");
            return stringBuilder.ToString();
        }
    }
}
