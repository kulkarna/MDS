using System.ComponentModel.DataAnnotations;
using System.Runtime.Serialization;
using System.ServiceModel;
using Common.Logging;
using LibertyPower.Business.CustomerManagement.AccountManagement;
using UsageEventAggregator.Helpers;
using UsageWebService.Repository;

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
            var repository = Locator.Current.GetInstance<IRepository>();
            var code = repository.GetUtilityCode(UtilityId);

            int usage;
            if (!CompanyAccountFactory.CalculateAnnualUsage(AccountNumber, code, out usage))
                throw new FaultException("No meter reads available for annual usage calculation.");

            LogManager.GetCurrentClassLogger().Debug(string.Format("Annual Usage requested for utility: {0} account: {1} usage: {2}", UtilityId, AccountNumber, usage));

            return usage;
        }
    }
}