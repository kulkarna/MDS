using System.ComponentModel.DataAnnotations;
using System.Runtime.Serialization;

namespace UsageWebService.Entities
{
    [DataContract]
    public class ServiceAccount
    {
         [DataMember]
        [Required]
         public string AccountNumber { get; set; }

        [DataMember]
        [Required]
        public string UtilityCode { get; set; }

    }
}