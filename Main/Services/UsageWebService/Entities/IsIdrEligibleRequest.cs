using System;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Runtime.Serialization;
using Common.Logging;
using UsageEventAggregator.Helpers;
using UsageWebService.Repository;

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
            var repository = Locator.Current.GetInstance<IRepository>();

            var exists = repository.DoesEclDataExist(AccountNumber, UtilityId);

            LogManager.GetCurrentClassLogger().Debug(string.Format("ECL exists check for utility: {0} account: {1} exists: {2}", UtilityId, AccountNumber, exists));

            return exists;
        }
    }
}