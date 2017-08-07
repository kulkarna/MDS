using System;
using System.ComponentModel.DataAnnotations;
using System.Runtime.Serialization;
using System.ServiceModel;
using Common.Logging;
using LibertyPower.Business.CustomerManagement.AccountManagement;
using UsageEventAggregator.Helpers;
using UsageWebService.Repository;

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
            var repository = Locator.Current.GetInstance<IRepository>();
            var code = repository.GetUtilityCode(UtilityId);

            var date = CompanyAccountFactory.GetMostRecentMeterDate(AccountNumber, code);

            if (date == DateTime.MinValue)            
                throw new FaultException("Could not find any meter reads");
                LogManager.GetCurrentClassLogger().Debug(string.Format("Usage date requested for utility: {0} account: {1} date: {2}", UtilityId, AccountNumber, date.ToString()));
                return date;
            
        }
    }
}