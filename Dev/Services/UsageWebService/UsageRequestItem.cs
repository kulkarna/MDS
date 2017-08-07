using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;

namespace UsageWebService
{
   public class UsageRequestItem
    {
        [DataMember]
        [Required]
        public string AccountNumber { get; set; }

        [DataMember]
        [Required]
        public int UtilityId { get; set; }

        [DataMember]
        [Required]
        public DateTime FromDate {get;set;}

        [DataMember]
        [Required]
        public DateTime ToDate { get; set; }

    }

   public class UsageRequestNonIdrItem
   {
       

       [DataMember]
       [Required]
       public string AccountNumber { get; set; }

       [DataMember]
       [Required]
       public int UtilityId { get; set; }
   }
[DataContract]
   public class UsageRequestNonIdrItemWithTerm
   {
       public UsageRequestNonIdrItemWithTerm(string accountNumber, int utilityId, DateTime fromDate, DateTime toDate)
       {
           AccountNumber = accountNumber;
           UtilityId = utilityId;
           FromDate = fromDate;
           ToDate = toDate;
       }

       [DataMember]
       [Required]
       public string AccountNumber { get; set; }

       [DataMember]
       [Required]
       public int UtilityId { get; set; }

       [DataMember]
       [Required]
       public DateTime FromDate { get; set; }

       [DataMember]
       [Required]
       public DateTime ToDate { get; set; }


   }
}
