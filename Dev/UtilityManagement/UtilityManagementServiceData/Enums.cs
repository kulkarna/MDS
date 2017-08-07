using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;
using System.Threading.Tasks;

namespace UtilityManagementServiceData
{
    [DataContract]
    public enum EnrollmentType
    {
        [EnumMember]
        PreEnrollment = 0,
        [EnumMember]
        PostEnrollment = 1
    }
    
    [DataContract]
    public enum PurchaseOfReceivableDriver
    { 
        [EnumMember]
        LoadProfile = 0,
        [EnumMember]
        TariffCode = 1,
        [EnumMember]
        RateClass = 2
    }

    [DataContract]
    public enum PurchaseOfReceivableRecourse
    {
        [EnumMember]
        Recourse = 0,
        [EnumMember]
        NonRecourse = 1,
        [EnumMember]
        None = 2
    }

    [DataContract]
    public enum BillingType
    {
        [EnumMember]
        BillReady = 1,
        [EnumMember]
        Dual = 2,
        [EnumMember]
        RateReady = 3,
        [EnumMember]
        SupplierConsolidated = 4
    }

    [DataContract]
    public enum MeterType
    { 
        [EnumMember]
        NonIdr = 1,
        [EnumMember]
        Idr = 2
    }
}