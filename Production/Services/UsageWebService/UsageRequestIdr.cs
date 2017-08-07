using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.Runtime.Serialization;
using System.ServiceModel;
using Common.Logging;
using LibertyPower.Business.CustomerManagement.AccountManagement;
using UsageEventAggregator.Helpers;
using UsageWebService.Repository;
using LibertyPower.Business.MarketManagement.UsageManagement;
using System.Data;

namespace UsageWebService
{
    public class UsageRequestIdr
    {
        public UsageRequestIdr()
        {
            lstUsageRequestItem = new List<UsageRequestItem>();
        }
        public List<UsageRequestItem> lstUsageRequestItem { get; set; }
        private string messageId { get; set; }
        internal UsageResponseIdr Execute(string messageId)
        {
            var repository = Locator.Current.GetInstance<IRepository>();
            DataTable dtUsageRequestIdr = ListConverter.ToDataTable(lstUsageRequestItem);
            UsageResponseIdr usageResponseIdr = repository.GetUsageListIdr(messageId, dtUsageRequestIdr);
            return usageResponseIdr;
        }

    }

    
    public class UsageRequestNonIdr
    {
        public UsageRequestNonIdr()
        {
            lstUsageRequestNonIdrItem = new List<UsageRequestNonIdrItem>();
        }
        public List<UsageRequestNonIdrItem> lstUsageRequestNonIdrItem { get; set; }
        private List<UsageRequestNonIdrItemWithTerm> lstUsageRequestNonIdrItemWithTerm = new List<UsageRequestNonIdrItemWithTerm>();

        
        private string messageId { get; set; }
        internal UsageResponseNonIdr Execute(string messageId,int term)
        {
            var repository = Locator.Current.GetInstance<IRepository>();
            foreach(UsageRequestNonIdrItem usageRequestNonIdrItem in lstUsageRequestNonIdrItem)
                       {
                                                                  
            lstUsageRequestNonIdrItemWithTerm.Add(new UsageRequestNonIdrItemWithTerm( usageRequestNonIdrItem.AccountNumber
                                                  ,usageRequestNonIdrItem.UtilityId
                                                  ,DateTime.Now.AddDays(-365*term)
                                                  ,DateTime.Now));
                       }
            DataTable dtUsageRequestNonIdr = ListConverter.ToDataTable(lstUsageRequestNonIdrItemWithTerm);
            UsageResponseNonIdr usageResponseNonIdr = repository.GetUsageListNonIdr(messageId, dtUsageRequestNonIdr);
            return usageResponseNonIdr;
        }

    }
}
