using Common.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ServiceModel;
using System.Runtime.Serialization;
using System.Data;
using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;
using LibertyPower.Business.MarketManagement.UtilityManagement;
using LibertyPower.Business.CustomerManagement.AccountManagement;
using LibertyPower.Business.MarketManagement.EdiManagement;

namespace UsageWebService.Entities
{
    public class ScraperCalculateUsageResponse
    {
        private const string SOURCE = "Scraper";
        private static readonly ILog Log = LogManager.GetCurrentClassLogger();
        public ScraperCalculateUsageResponse()
        {


        }
        public ScraperCalculateUsageResponse( string code, bool isSuccess, string message)
        {
            
            Code = code;
            IsSuccess = isSuccess;
            Message = message;

        }
        
        [DataMember]
        public string Message { get; set; }
        [DataMember]
        public bool IsSuccess { get; set; }
        [DataMember]
        public string Code { get; set; }

        public string DoProcess(string utilityCode, string processName)
        {
            string ErrorMsg = string.Empty;
            //ErrorMsg = CompanyAccountFactory.PerformScrappingAndCalculation(utilityCode, processName);
            return ErrorMsg;
        }
        

        

        
    }
}