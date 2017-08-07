using System;
using System.ComponentModel.DataAnnotations;
using System.Runtime.Serialization;
using System.ServiceModel;


namespace UsageWebService.Entities
{
    public class AnnualUsageRequest
    {
        [DataMember]
        [Required]
        public string AccountNumber { get; set; }

        [DataMember]
        [Required]
        public int UtilityId { get; set; }

        internal int Execute()
        {
            try
            {
                var rnd = new Random();
                return rnd.Next(150);
            }
            catch (Exception)
            {
                throw new FaultException("No meter reads available for annual usage calculation.");
            }
        }

    }
}