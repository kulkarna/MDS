using System.Runtime.Serialization;

namespace LibertyPower.RepositoryManagement.Contracts.AccountManagement.v1
{
    [DataContract(Namespace = ContractNamespaces.AccountManagementV1)]
    public class ServiceAccountInfo
    {
        [DataMember(Order = 1, IsRequired = true)]
        public string Utility { get; set; }
        [DataMember(Order = 2, IsRequired = true)]
        public string AccountNumber { get; set; }
        [DataMember(Order = 3, IsRequired = true)]
        public string UpdateSource { get; set; }
        [DataMember(Order = 4, IsRequired = true)]
        public string UpdateUser { get; set; }

        [DataMember(Order = 5, IsRequired = false)]
        public decimal? ICap { get; set; }
        [DataMember(Order = 6, IsRequired = false)]
        public decimal? TCap { get; set; }

        [DataMember(Order = 7, IsRequired = false)]
        public string AccountType { get; set; }
        [DataMember(Order = 8, IsRequired = false)]
        public string Grid { get; set; }
        [DataMember(Order = 9, IsRequired = false)]
        public string LbmpZone { get; set; }
        [DataMember(Order = 10, IsRequired = false)]
        public string LoadProfile { get; set; }
        [DataMember(Order = 11, IsRequired = false)]
        public string LoadShapeId { get; set; }
        [DataMember(Order = 12, IsRequired = false)]
        public decimal? LossFactor { get; set; }
        [DataMember(Order = 13, IsRequired = false)]
        public string MeterType { get; set; }
        [DataMember(Order = 14, IsRequired = false)]
        public string RateClass { get; set; }
        [DataMember(Order = 15, IsRequired = false)]
        public string ServiceClass { get; set; }
        [DataMember(Order = 16, IsRequired = false)]
        public string TariffCode { get; set; }
        [DataMember(Order = 17, IsRequired = false)]
        public string Voltage { get; set; }
        [DataMember(Order = 18, IsRequired = false)]
        public string Zone { get; set; }
        [DataMember(Order = 19, IsRequired = false)]
        public string ServiceAddressZipCode { get; set; }
        [DataMember(Order = 20, IsRequired = false)]
        public string MeterNumber { get; set; }
        [DataMember(Order = 21, IsRequired = false)]
        public string NameKey { get; set; }
        [DataMember(Order = 22, IsRequired = false)]
        public string Strata { get; set; }
        [DataMember(Order = 23, IsRequired = false)]
        public string BillingAccount { get; set; }



        public override string ToString()
        {

            string returnValue = string.Format("ServiceAccountInfo[Utility:{0},AccountNumber:{1},UpdateSource:{2},UpdateUser:{3},ICap:{4},TCap:{5},AccountType:{6},Grid:{7},LbmpZone:{8},LoadProfile:{9},LoadShapeId:{10},LossFactor:{11},MeterType:{12},RateClass:{13},ServiceClass:{14},TariffCode:{15},Voltage:{16},Zone:{17},ServiceAddressZipCode:{18}",
                Utilities.Common.NullSafeString(Utility),
                Utilities.Common.NullSafeString(AccountNumber),
                Utilities.Common.NullSafeString(UpdateSource),
                Utilities.Common.NullSafeString(UpdateUser),
                Utilities.Common.NullSafeString(ICap),
                Utilities.Common.NullSafeString(TCap),
                Utilities.Common.NullSafeString(AccountType),
                Utilities.Common.NullSafeString(Grid),
                Utilities.Common.NullSafeString(LbmpZone),
                Utilities.Common.NullSafeString(LoadProfile),
                Utilities.Common.NullSafeString(LoadShapeId),
                Utilities.Common.NullSafeString(LossFactor),
                Utilities.Common.NullSafeString(MeterType),
                Utilities.Common.NullSafeString(RateClass),
                Utilities.Common.NullSafeString(ServiceClass),
                Utilities.Common.NullSafeString(TariffCode),
                Utilities.Common.NullSafeString(Voltage),
                Utilities.Common.NullSafeString(Zone),
                Utilities.Common.NullSafeString(ServiceAddressZipCode));

            return returnValue;
        }

    }
}