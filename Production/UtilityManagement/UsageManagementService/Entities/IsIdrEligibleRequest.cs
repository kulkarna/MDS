using System;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Runtime.Serialization;

namespace UsageWebService.Entities
{
    public class IsIdrEligibleRequest
    {
        #region Data Members
        [DataMember]
        [Required]
        public string AccountNumber { get; set; }
        [DataMember]
        [Required]
        public int UtilityId { get; set; }

        #endregion


        public bool Execute()
        {
            var chars = AccountNumber.ToCharArray();
            var last = chars.LastOrDefault(char.IsNumber);
            return (Convert.ToInt32(last) % 2 != 0);
        }
    }
}