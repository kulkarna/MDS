using System;
using System.ComponentModel.DataAnnotations;
using System.Runtime.Serialization;
using Common.Logging;
using UsageEventAggregator.Events.Collector;
using UsageEventAggregator.Helpers;
using UsageWebService.Repository;
using UsageWebService.Validation.Custom;

namespace UsageWebService.Entities
{
    [DataContract]
    public class EdiUsageRequest
    {
        private static readonly ILog Log = LogManager.GetCurrentClassLogger();
        private IRepository _repository;

        #region Data Members
        
        private string _zip;
        private string _nameKey;


        [DataMember]
        [Required]
        public string AccountNumber { get; set; }

        [DataMember]
        [Required]
        public string UtilityCode { get; set; }

        [DataMember]
        [Required]
        public string DunsNumber { get; set; }

        [DataMember]
        public string BillingAccountNumber { get; set; }

        [DataMember]
        public string NameKey { get; set; }
    /*    
    {
            get { return UtilityCode.StartsWith("NSTAR") ? "STAR" : _nameKey; }
            set { _nameKey = value; }
        }
        */
        [DataMember]
        public string MeterNumber { get; set; }

        public string Zip
        {
            get { return string.IsNullOrWhiteSpace(_zip) ? "11111" : _zip; }
            set { _zip = value; }
        }

        [DataMember]
        public string Strata { get; set; }

        [DataMember]
        [IsAny("HU,HI")]
        public string UsageType { get; set; }

        #endregion
        

        public string Execute()
        {
            try
            {
                _repository = Locator.Current.GetInstance<IRepository>();

                var transactionId = _repository.CreateTransaction(AccountNumber, UtilityCode, "Ista");

                _RequestEdi(transactionId);

                if("HI".Equals(UsageType))
                    return transactionId.ToString();

                //Process IDR request if is IDR eligible or if DUKE or DAYTON
                if("DUKE".Equals(UtilityCode, StringComparison.InvariantCultureIgnoreCase) || "DAYTON".Equals(UtilityCode, StringComparison.InvariantCultureIgnoreCase))
                    _RequestHi(transactionId);

                else if (_DoesEclDataExist())
                    _RequestHi(transactionId);

                return transactionId.ToString();
            }
            catch (Exception ex)
            {
                Log.Error("Ista usage request: " + ex.GetBaseException().Message, ex.GetBaseException());
                throw;
            }
         
        }

        private bool _DoesEclDataExist()
        {

            var utilityId = _repository.GetUtilityId(UtilityCode);

            return _repository.DoesEclDataExist(AccountNumber, utilityId);
        }

        private void _RequestEdi(long transactionId)
        {
            var eventMessage = new IstaUsageRequested
                {
                    AccountNumber = this.AccountNumber,
                    UtilityCode = this.UtilityCode,
                    DUNS = this.DunsNumber,
                    BillingAccountNumber = this.BillingAccountNumber,
                    MeterNumber = this.MeterNumber,
                    NameKey = this.NameKey,
                    Zip = this.Zip,
                    Strata = this.Strata,
                    TransactionId = transactionId,
                    UsageType = this.UsageType
                };

            UsageEventAggregator.Aggregator.Publish(eventMessage, transactionId);

            Log.Info(string.Format("Usage requested from ISTA with transaction id {0} and type of {1}", transactionId, UsageType));
        }

        private void _RequestHi(long transactionId)
        {
            var eventMessage = new IstaUsageRequested
                {
                    AccountNumber = this.AccountNumber,
                    UtilityCode = this.UtilityCode,
                    DUNS = this.DunsNumber,
                    BillingAccountNumber = this.BillingAccountNumber,
                    MeterNumber = this.MeterNumber,
                    NameKey = this.NameKey,
                    Zip = this.Zip,
                    Strata = this.Strata,
                    TransactionId = transactionId,
                    UsageType = "HI"
                };

            UsageEventAggregator.Aggregator.Publish(eventMessage, transactionId);

            Log.Info(string.Format("Usage requested from ISTA with transaction id {0} and type of {1}", transactionId, "HI"));
        }
    }
}