using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UtilityManagementServiceData
{
    public class GetAllUtiltiesReceiveIdrOnlyResponseItem
    {
        public int UtilityIdInt { get; set; }
        public string UtilityCode { get; set; }
        public bool ReceiveIdrOnly { get; set; }
        public override string ToString()
        {
            return string.Format("GetAllUtiltiesReceiveIdrOnlyResponseItem[UtilityIdInt:{0};UtilityCode:{1};ReceiveIdrOnly:{2}", UtilityIdInt, UtilityCode, ReceiveIdrOnly);
        }
    }
}
