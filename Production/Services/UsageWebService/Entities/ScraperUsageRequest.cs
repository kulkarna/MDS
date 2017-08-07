using System.ComponentModel.DataAnnotations;
using System.Runtime.Serialization;
using Common.Logging;
using UsageEventAggregator.Events.Collector;
using UsageEventAggregator.Helpers;
using UsageWebService.Repository;
using UsageWebService.Validation.Custom;

namespace UsageWebService.Entities
{
    public class ScraperUsageRequest
    {
        private static readonly ILog Log = LogManager.GetCurrentClassLogger();

        #region Data Members
        [DataMember]
        [Required]
        public string AccountNumber { get; set; }
        [DataMember]
        [Required]
        public int UtilityId { get; set; }

        #endregion
        
        public string Execute()
        {
            var repository = Locator.Current.GetInstance<IRepository>();
            var code = repository.GetUtilityCode(UtilityId);
            long transactionId = repository.CreateTransaction(AccountNumber, code, "Scraper");
            var eventMessage = new ScraperRequested
            {
                AccountNumber = AccountNumber,
                UtilityCode = code,
                TransactionId = transactionId,
            };

            UsageEventAggregator.Aggregator.Publish(eventMessage, transactionId);

            Log.Info(string.Format("Usage request recieved with transaction id {0} and mode of {1}", transactionId, "Scraper"));

            return transactionId.ToString();
        }



    }
}