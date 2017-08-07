using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UsageManagementWcfServiceRepository;
using AccountWcfServiceRepository;
using System.Net.Mail;
using Utilities;
using UtilityLogging;
using UtilityUnityLogging;
using LibertyPower.MarketDataServices.AccountWcfServiceData;
using LibertyPower.MarketDataServices.AnnualUsageUpdatorRespository;
using LibertyPower.MarketDataServices.AnnualUsageBusinessLayer;
using LibertyPower.MarketDataServices.AnnualUsageUpdator;


namespace LibertyPower.MarketDataServices.AnnualUsageUpdater
{

    class Program
    {
        private static IAnnualUsageUpdatorRespositoryManagement _annualUsageUpdatorRespository;
        private static IAccountWcfServiceRepositoryManagement _accountWcfServiceRepository;
        private static IUsageManagementWcfServiceRepositoryManagement _usageWcfRepository;
        private static IBusinessLayer _annualUsageBusinessLayer;
        #region private variables
        private const string NAMESPACE = "LibertyPower.MarketDataServices.AnnualUsageUpdater";
        private const string CLASS = "AnnualUsageUpdater";
        private static ILogger _logger;
        
        #endregion
        static void Main(string[] args)
        {
            string method = string.Format("Main(Arguments:{0})", 0);
            DateTime beginTime = DateTime.Now;
            string messageId = Guid.NewGuid().ToString();
            _logger = UnityLoggerGenerator.GenerateLogger();
            string _emailEnabled  = ConfigurationManager.AppSettings["EmailEnabled"];
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} AnnualUsageUpdater BEGIN", NAMESPACE, CLASS, method));
                int _processIntervalDays = Convert.ToInt32(ConfigurationManager.AppSettings["ProcessIntervalDays"]);
                int _chunkSize = Convert.ToInt32(ConfigurationManager.AppSettings["ChunkSize"]);
                

                _annualUsageUpdatorRespository = new AnnualUsageUpdatorRespositoryManagement();
                _accountWcfServiceRepository = new AccountWcfServiceRepositoryManagement();
                _usageWcfRepository = new UsageManagementWcfServiceRepositoryManagement();
                _annualUsageBusinessLayer = new BusinessLayer(messageId, _annualUsageUpdatorRespository, _accountWcfServiceRepository, _usageWcfRepository);
                string lsMessage = "Annual Usage Updator Process Started at :" + beginTime.ToString();
                ///Send Email
                if (_emailEnabled == "true"){
                    SendResults(lsMessage);
                 }

                int processIdentifier = _annualUsageUpdatorRespository.CheckjobStatus(messageId, _processIntervalDays);
                //if 1 - Start over. Last process date passed and start from the begining.
                //if 2 - Process half way done/interrupted -  Re-initiate the process
                //if 3 - Process completed for the period- Nothing to be done- Return.
                switch (processIdentifier)
                {
                    case 1:
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} ProcessFresh call BEGIN", NAMESPACE, CLASS, method));
                        ProcessFresh(messageId, _chunkSize);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2}.{3} ProcessFresh Call END", NAMESPACE, CLASS, method, processIdentifier.ToString()));
                        break;
                    case 2:
                        //Do not Reload the Date-but continue with the data from transaction table
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2}.{3} ProcessAccount Call BEGIN", NAMESPACE, CLASS, method, processIdentifier.ToString()));
                        ProcessAccounts(messageId, _chunkSize);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2}.{3} ProcessAccount Call END", NAMESPACE, CLASS, method, processIdentifier.ToString()));
                        break;
                    case 3:
                        ///Nothing- to Do -Return -Log the message as complete.
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2}.{3} No Accounts to Process.EXIT", NAMESPACE, CLASS, method, processIdentifier.ToString()));
                        string lsTotalTime = DateTime.Now.Subtract(beginTime).ToString(); 
                        string lsMessge = "There was no Accounts To Process for the Time Period."  +"<br><br>" + "Total Time Taken for Process : " + lsTotalTime;
                        if (_emailEnabled == "true")
                        {
                            SendResults(lsMessge);
                        }
                        break;
                }
               
            }
            catch (Exception ex)
            {
                _logger.LogError(messageId, string.Format("{0} {1} {2}.{3}.{4} ERROR {5} {6} Duration:{7} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), messageId, NAMESPACE, CLASS, method, Utilities.Common.NullSafeString(ex.Message), Utilities.Common.NullSafeString(ex.StackTrace), DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} END {5} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), messageId, NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                string lsMessage = "AnnualUsageUpdator Process Encountered a System Error."+"<br><br>" +  ex.Message + ".";
                if (_emailEnabled == "true")
                {
                    SendResults(lsMessage);
                }
            }
        }

        private static void ProcessFresh(string messageId,int _chunkSize)
        {
            string method = string.Format("Main(Arguments:{0})", 0);
            
            DateTime beginTime = DateTime.Now;
            _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} PopulateAccounts call BEGIN", NAMESPACE, CLASS, method));
            int retrun = PopulateAccounts(messageId);
            _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} PopulateAccounts Call END", NAMESPACE, CLASS, method));
            if (retrun == 1)
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} ProcessFresh Call BEGIN", NAMESPACE, CLASS, method));
                ProcessAccounts(messageId, _chunkSize);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} ProcessFresh Call END", NAMESPACE, CLASS, method));
        }
            else
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} Error Populating Enrolled Accounts", NAMESPACE, CLASS, method));
            }
        }

        private static void ProcessAccounts(string messageId,int _chunkSize)
        {

            string method = string.Format("ProcessAccounts:{0})", 0);
            DateTime beginTime = DateTime.Now;
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
                int liReturn = _annualUsageBusinessLayer.ProcessAccounts(messageId, _chunkSize);
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} END {5} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), messageId, NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                ///If all good, Generate the Email Message
                string lsTotalTime = DateTime.Now.Subtract(beginTime).ToString();
                string lsMessge = "AnnualUsageUpdator Process complete without Error. Total Time Taken is : " + lsTotalTime + ".";
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2}.{3} TotalTime For Process", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).ToString()));
                lsMessge = _annualUsageBusinessLayer.GenerateReport(messageId);
                lsMessge = lsMessge + "<br><br>" + "Total Time Taken for Process : " + lsTotalTime;
                SendResults(lsMessge);
            }
            catch (Exception ex)
            {
               _logger.LogError(messageId, string.Format("{0} {1} {2}.{3}.{4} ERROR {5} {6} Duration:{7} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), messageId, NAMESPACE, CLASS, method, Utilities.Common.NullSafeString(ex.Message), Utilities.Common.NullSafeString(ex.StackTrace), DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} END {5} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), messageId, NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
            }    
        }
        private static int PopulateAccounts(string messageId)
        {

            string method = string.Format("PopulateAccounts:{0})", 0);
            DateTime beginTime = DateTime.Now;
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
                int liReturn = _annualUsageBusinessLayer.PopulateEnrolledAccounts(messageId);
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} END {5} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), messageId, NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                return liReturn;
            }
            catch (Exception ex)
            {
                _logger.LogError(messageId, string.Format("{0} {1} {2}.{3}.{4} ERROR {5} {6} Duration:{7} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), messageId, NAMESPACE, CLASS, method, Utilities.Common.NullSafeString(ex.Message), Utilities.Common.NullSafeString(ex.StackTrace), DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} END {5} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), messageId, NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                return 0; 
               
            }
        }
        public static void SendResults(string msg)
        {
            string Sender = ConfigurationManager.AppSettings["MailSender"];
            string Recipient = ConfigurationManager.AppSettings["MailRecipient"];
            string Recipient1 = ConfigurationManager.AppSettings["MailRecipient1"];
            string Recipient2 = ConfigurationManager.AppSettings["MailRecipient2"];
            SmtpClient smtpClient = new SmtpClient();
            MailMessage message = new MailMessage();
            MailAddress fromAddress = new MailAddress(Sender);
            
            smtpClient.Host = ConfigurationManager.AppSettings["SMTPServer"];
            smtpClient.Port = 25;
            message.From = fromAddress;
            message.To.Add(Recipient);
            message.CC.Add(Recipient1);
            message.Bcc.Add(Recipient2);
            message.Subject = "AnnualUsageUpdater";
            message.IsBodyHtml = true;
            message.Body = "<span style=font-family:Verdana,Arial;font-size:10pt>" + "TEST MAIL" + "<br><br>" + msg + "</span>";
            smtpClient.Send(message);
        }
     
    }
}
