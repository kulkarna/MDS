using Common.Logging;
using UsageEventAggregator;
using UsageEventAggregator.Events.AccountPropertyHistory;
using UsageEventAggregator.Events.Consolidation;
using UsageEventAggregator.Events.DataProcessed;
using UsageEventAggregator.Events.DataResponse;
using UsageEventAggregator.Events.Edi;
using UsageEventAggregator.Helpers;
using UsageWindowsService.Repository;

namespace UsageWindowsService.EventHandler
{
    public class EdiFileParsedEventHandler : IHandleEvents<EdiFileParsed>
    {
        private static readonly ILog Log = LogManager.GetCurrentClassLogger();
        private long _transactionId;
        private IRepository _repository;
        private const string SOURCE = "Edi";
        private const string NO_ACCOUNT_MESSAGE = "Undefined EDI Msg. Request IT to configure.";
        private const string REJECTION = "(Rejection)";
        private const string INFO = "(Info)";
        
        public void Handle(EdiFileParsed e)
        {
            _repository = Locator.Current.GetInstance<IRepository>();
            _transactionId = _repository.GetTransactionId(e.AccountNumber, e.UtilityCode);

                
            if (e.Is867SummaryData)
                _Handle867HUFileParsed(e);
            else if (e.Is867IntervalData)
                _Handle867IdrFileParsed(e);
            else if(e.Is814SummaryData)
                _Handle814HuFileParsed(e);
            else if(e.Is814IntervalData)
                _Handle814IdrFileParsed(e);
            else
            {
                Log.Warn("File parsed is not 814 or 867. Might be SHCE. File log id: " + e.ParserLogId);
                _AccountPropertyHistory(e);
            }
            
        }

        private void _Handle814IdrFileParsed(EdiFileParsed ediFileParsed)
        {
            if (string.IsNullOrWhiteSpace(ediFileParsed.Message))
             {
                 Aggregator.Publish(new DataResponseIdrAcceptance
                     {
                         AccountNumber = ediFileParsed.AccountNumber,
                         UtilityCode = ediFileParsed.UtilityCode,
                         Message = string.Empty,
                         Source = SOURCE,
                         TransactionId = _transactionId
                     });
                 ///Manoj-Added as part of 61849-  where we need to invoke APH processing for 814 files as well
                 _AccountPropertyHistory(ediFileParsed);
                 return;
             }

             var accountStatusMessageType = _repository.GetAccountStatusMessageType(ediFileParsed.Message);

              if (accountStatusMessageType == null)
              {
                  Aggregator.Publish(new DataResponseIdrRejection
                  {
                      AccountNumber = ediFileParsed.AccountNumber,
                      UtilityCode = ediFileParsed.UtilityCode,
                      Message = NO_ACCOUNT_MESSAGE + " - " + ediFileParsed.Message,
                      Source = SOURCE,
                      TransactionId = _transactionId
                  });

                  return;
              }

              if (accountStatusMessageType.IsAcceptance)
                  Aggregator.Publish(new DataResponseIdrAcceptance
                  {
                      AccountNumber = ediFileParsed.AccountNumber,
                      UtilityCode = ediFileParsed.UtilityCode,
                      Message = INFO + " " + accountStatusMessageType.Message + " " + accountStatusMessageType.Description,
                      Source = SOURCE,
                      TransactionId = _transactionId
                  });
             else if (accountStatusMessageType.IsAcceptanceInformational)
                  Aggregator.Publish(new DataResponseIdrAcceptance
                  {
                      AccountNumber = ediFileParsed.AccountNumber,
                      UtilityCode = ediFileParsed.UtilityCode,
                      Message = INFO + " " + accountStatusMessageType.Message + " " + accountStatusMessageType.Description,
                      Source = SOURCE,
                      TransactionId = _transactionId
                  });
              else if (accountStatusMessageType.IsRejection)
                  Aggregator.Publish(new DataResponseIdrRejection
                  {
                      AccountNumber = ediFileParsed.AccountNumber,
                      UtilityCode = ediFileParsed.UtilityCode,
                      Message = REJECTION + " " + accountStatusMessageType.Message + " " + accountStatusMessageType.Description,
                      Source = SOURCE,
                      TransactionId = _transactionId
                  });

             
        }

        private void _Handle814HuFileParsed(EdiFileParsed ediFileParsed)
        {
            if (string.IsNullOrWhiteSpace(ediFileParsed.Message))
                    {
                            Aggregator.Publish(new DataResponseHuAcceptance
                                {
                                    AccountNumber = ediFileParsed.AccountNumber,
                                    UtilityCode = ediFileParsed.UtilityCode,
                                    Message = string.Empty,
                                    Source = SOURCE,
                                    TransactionId = _transactionId
                                });
                       
                        ///Manoj-Added as part of 61849-  where we need to invoke APH processing for 814 files as well
                        _AccountPropertyHistory(ediFileParsed);
                        return;
                    }

            var accountStatusMessageType = _repository.GetAccountStatusMessageType(ediFileParsed.Message);

            if (accountStatusMessageType == null)
            {
                Aggregator.Publish(new DataResponseHuRejection
                    {
                        AccountNumber = ediFileParsed.AccountNumber,
                        UtilityCode = ediFileParsed.UtilityCode,
                        Message = NO_ACCOUNT_MESSAGE + " - " + ediFileParsed.Message,
                        Source = SOURCE,
                        TransactionId = _transactionId
                    });

                return;
            }
            

            if (accountStatusMessageType.IsAcceptance)
                Aggregator.Publish(new DataResponseHuAcceptance
                {
                    AccountNumber = ediFileParsed.AccountNumber,
                    UtilityCode = ediFileParsed.UtilityCode,
                    Message = string.Empty,
                    Source = SOURCE,
                    TransactionId = _transactionId
                });
            else if (accountStatusMessageType.IsAcceptanceIdrAvailable)
                Aggregator.Publish(new DataResponseHuAcceptance
                {
                    AccountNumber = ediFileParsed.AccountNumber,
                    UtilityCode = ediFileParsed.UtilityCode,
                    IdrDataAvailable = true,
                    Message = INFO + " " + accountStatusMessageType.Message + " " + accountStatusMessageType.Description,
                    Source = SOURCE,
                    TransactionId = _transactionId
                });
            else if (accountStatusMessageType.IsAcceptanceInformational)
                Aggregator.Publish(new DataResponseHuAcceptance
                {
                    AccountNumber = ediFileParsed.AccountNumber,
                    UtilityCode = ediFileParsed.UtilityCode,
                    IdrDataAvailable = false,
                    Message = INFO + " " + accountStatusMessageType.Message + " " + accountStatusMessageType.Description,
                    Source = SOURCE,
                    TransactionId = _transactionId
                });
            else if (accountStatusMessageType.IsRejection)
                Aggregator.Publish(new DataResponseHuRejection
                {
                    AccountNumber = ediFileParsed.AccountNumber,
                    UtilityCode = ediFileParsed.UtilityCode,
                    Message = REJECTION + " " + accountStatusMessageType.Message + " " + accountStatusMessageType.Description,
                    Source = SOURCE,
                    TransactionId = _transactionId
                });
           
        }

        private void _Handle867HUFileParsed(EdiFileParsed ediFileParsed)
        {
            if (ediFileParsed.IsError)
            {
                Aggregator.Publish(new DataProcessedHuFailed
                    {
                        AccountNumber = ediFileParsed.AccountNumber,
                        UtilityCode = ediFileParsed.UtilityCode,
                        TransactionId = _transactionId,
                        Source = SOURCE,
                        Message = ediFileParsed.Message
                    });
                return;
            }

            _AccountPropertyHistory(ediFileParsed);
            
        }

        private void _Handle867IdrFileParsed(EdiFileParsed ediFileParsed)
        {
            if (ediFileParsed.IsError)
                Aggregator.Publish(new DataProcessedIdrFailed
                {
                    AccountNumber = ediFileParsed.AccountNumber,
                    UtilityCode = ediFileParsed.UtilityCode,
                    TransactionId = _transactionId,
                    Source = SOURCE,
                    Message = ediFileParsed.Message
                });
            else
            {
                _AccountPropertyHistory(ediFileParsed);
                Aggregator.Publish(new DataProcessedIdrComplete
                    {
                        AccountNumber = ediFileParsed.AccountNumber,
                        UtilityCode = ediFileParsed.UtilityCode,
                        TransactionId = _transactionId,
                        Source = SOURCE
                    });
            }
        }

        public void _AccountPropertyHistory(EdiFileParsed ediFileParsed)
        {
            Aggregator.Publish(new AccountPropertyHistoryProcessRequested
            {
                AccountNumber = ediFileParsed.AccountNumber,
                UtilityCode = ediFileParsed.UtilityCode,
                TransactionId = _transactionId,
                Source = SOURCE,
                EdiLogId = ediFileParsed.ParserLogId
            });
        }

        

    }
}