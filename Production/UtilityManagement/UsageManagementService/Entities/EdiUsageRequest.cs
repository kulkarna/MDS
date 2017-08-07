using System.ComponentModel.DataAnnotations;
using System.Runtime.Serialization;
using UsageWebService.Validation.Custom;

namespace UsageWebService.Entities
{
    [DataContract]
    public class EdiUsageRequest
    {

        #region Data Members

        private string _zip;
        private string _nameKey;


        [DataMember]
        [Required]
        public string AccountNumber { get; set; }

        [DataMember]
        [Required]
        public string UtilityCode { get; set; }

        [DataMember]
        [Required]
        public string DunsNumber { get; set; }

        [DataMember]
        public string BillingAccountNumber { get; set; }

        [DataMember]
        public string NameKey
        {
            get { return UtilityCode.StartsWith("NSTAR") ? "STAR" : _nameKey; }
            set { _nameKey = value; }
        }

        [DataMember]
        public string MeterNumber { get; set; }

        public string Zip
        {
            get { return string.IsNullOrWhiteSpace(_zip) ? "11111" : _zip; }
            set { _zip = value; }
        }

        [DataMember]
        public string Strata { get; set; }

        [DataMember]
        [IsAny("HU,HI")]
        public string UsageType { get; set; }

        #endregion


        public string SubmitReturningTransactionId()
        {
            return string.Empty;
        }
    }
}