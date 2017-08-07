using System;
using System.ComponentModel.DataAnnotations;
using System.Runtime.Serialization;
using System.ServiceModel;

namespace UsageWebService.Entities
{
    public class UsageDateRequest
    {

        [DataMember]
        [Required]
        public string AccountNumber { get; set; }

        [DataMember]
        [Required]
        public int UtilityId { get; set; }

        internal DateTime Execute()
        {
            var rnd = new Random(1);
            var day = rnd.Next(30);
            return new DateTime(DateTime.Now.Year, DateTime.Now.Month, day);
        }
    }
}