using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;
using System.Threading.Tasks;

namespace UtilityManagementServiceData
{
    public class GetPurchaseOfReceivablesRequest
    {
        [DataMember]
        public int UtilityIdInt { get; set; }
        [DataMember]
        public PurchaseOfReceivableDriver PurchaseOfReceivableDriver { get; set; }
        [DataMember]
        public Guid DriverId { get; set; }
        [DataMember]
        public DateTime PurchaseOfReceivableDiscountEffectiveDate { get; set; }
        [DataMember]
        public string MessageId { get; set; }
    }
}
