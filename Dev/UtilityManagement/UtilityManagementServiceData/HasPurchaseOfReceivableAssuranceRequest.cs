using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;
using System.Threading.Tasks;

namespace UtilityManagementServiceData
{
    public class HasPurchaseOfReceivableAssuranceRequest
    {
        [DataMember]
        public int UtilityIdInt { get; set; }
        [DataMember]
        public string LoadProfile { get; set; }
        [DataMember]
        public string RateClass { get; set; }
        [DataMember]
        public string TariffCode { get; set; }
        [DataMember]
        public DateTime PurchaseOfReceivableDiscountEffectiveDate { get; set; }
        [DataMember]
        public string MessageId { get; set; }
    }
}
