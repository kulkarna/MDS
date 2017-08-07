using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace UtilityManagement.Models
{
    
    public class RequestModeHistoricalUsageModel
    {
        public List<RequestModeHistoricalUsageList> RequestModeHistoricalList { get; set; }
        public string SelectedUtilityCompanyId { get; set; }
        public RequestModeHistoricalUsageModel()
        {
        }


    }
}