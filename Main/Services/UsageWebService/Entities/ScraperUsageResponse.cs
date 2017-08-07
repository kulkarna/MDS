using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ServiceModel;
using System.Runtime.Serialization;
using Common.Logging;
using UsageWebService.Repository;
using UsageEventAggregator.Helpers;
using UsageEventAggregator;
using UsageEventAggregator.Events.AccountPropertyHistory;
using UsageEventAggregator.Events.DataProcessed;
using UsageEventAggregator.Events.Consolidation;
using UsageEventAggregator.Events.DataResponse;
using LibertyPower.Business.MarketManagement.UtilityManagement;

namespace UsageWebService.Entities
{
    [DataContract]
    public class ScraperUsageResponse
    {
        private const string SOURCE = "Scraper";
        private static readonly ILog Log = LogManager.GetCurrentClassLogger();
        public ScraperUsageResponse()
        {


        }
        public ScraperUsageResponse(string messageId, string code, bool isSuccess, string message, int accountId, string accountNumber, int utilityId, int usage)
        {
            MessageId = messageId;
            Code = code;
            IsSuccess = isSuccess;
            Message = message;

        }
        [DataMember]
        public string MessageId { get; set; }
        [DataMember]
        public string Message { get; set; }
        [DataMember]
        public bool IsSuccess { get; set; }
        [DataMember]
        public string Code { get; set; }
        [DataMember]
        public long TransactionId { get; set; }

        public ScraperUsageResponse IsScraperRequested(ScraperUsageRequest scraperUsageRequest)
        {
            var repository = Locator.Current.GetInstance<IRepository>();
            var UtilityCode = repository.GetUtilityCode(scraperUsageRequest.UtilityId);
            var exceptions = string.Empty;
            var AccountNumber = scraperUsageRequest.AccountNumber;
            long transactionId = repository.CreateTransaction(AccountNumber, UtilityCode, "Scraper");
            ScraperUsageResponse scraperUsageResponse = new ScraperUsageResponse();

            Log.Debug(string.Format("Running Scraper With Account {0}, Utility {1}", AccountNumber, UtilityCode));
            try
            {


                if (!(ScraperFactory.RunScraper(AccountNumber, UtilityCode, out exceptions)))
                {
                    Aggregator.Publish(new DataResponseHuRejection
                    {
                        AccountNumber = AccountNumber,
                        UtilityCode = UtilityCode,
                        Message = exceptions,
                        Source = SOURCE,
                        TransactionId = transactionId
                    });
                    scraperUsageResponse.Message = exceptions;
                    scraperUsageResponse.IsSuccess = false;
                    scraperUsageResponse.Code = "9999";
                    scraperUsageResponse.TransactionId = transactionId;
                }
                else
                {
                    scraperUsageResponse.Message = "Success";
                    scraperUsageResponse.IsSuccess = true;
                    scraperUsageResponse.Code = "0000";
                    scraperUsageResponse.TransactionId = transactionId;
                }
                //If call success trigger the rest of the proess.
                Aggregator.Publish(new UsageConsolidationRequested
                {
                    AccountNumber = AccountNumber,
                    UtilityCode = UtilityCode,
                    TransactionId = transactionId,
                    Source = SOURCE
                });

                Aggregator.Publish(new DataSyncRequested
                {
                    AccountNumber = AccountNumber,
                    UtilityCode = UtilityCode,
                    TransactionId = transactionId,
                    Source = SOURCE
                });


            }
            catch (Exception ex)
            {

                Aggregator.Publish(new DataProcessedHuFailed
                {
                    Message = "Scraper Service Call Failed With Message " + ex.Message,
                    AccountNumber = AccountNumber,
                    UtilityCode = Code,
                    TransactionId = transactionId,
                    Source = SOURCE
                });
                scraperUsageResponse.Message = "Scraper Service Call Failed With Message " + ex.Message;
                scraperUsageResponse.IsSuccess = false;
                scraperUsageResponse.Code = "9999";
                scraperUsageResponse.TransactionId = transactionId;
                Log.Info(string.Format("Scraper Service Recieved With Transaction Id {0} and Mode of {1}", transactionId, "Scraper"));
            }
            return scraperUsageResponse;
        }
    }
}