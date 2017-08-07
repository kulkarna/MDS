namespace LibertyPower.RepositoryManagement.Core.AccountManagement
{
    public class ServiceAccountInfo
    {
        public string AccountNumber { get; set; }
        public string Utility { get; set; }
        public string UpdateSource { get; set; }
        public string UpdateUser { get; set; }

        public string AccountType { get; set; }
        public string BillingAccount { get; set; }
        public string Grid { get; set; }
        public decimal? ICap { get; set; }
        public string LbmpZone { get; set; }
        public string LoadProfile { get; set; }
        public string LoadShapeId { get; set; }
        public decimal? LossFactor { get; set; }
        public string MeterNumber { get; set; }
        public string MeterType { get; set; }
        public string NameKey { get; set; }
        public string RateClass { get; set; }
        public string ServiceAddressZipCode { get; set; }
        public string ServiceClass { get; set; }
        public string Strata { get; set; }
        public string TariffCode { get; set; }
        public decimal? TCap { get; set; }
        public string Voltage { get; set; }
        public string Zone { get; set; }
    }
}