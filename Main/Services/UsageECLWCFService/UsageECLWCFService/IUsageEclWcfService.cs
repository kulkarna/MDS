using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.ServiceModel.Description;
using System.Text;
using LibertyPower.MarketDataServices.UsageEclWcfServiceData;



namespace LibertyPower.MarketDataServices.UsageEclWcfService
{
    [ServiceContract]
    public interface IUsageEclWcfService
    {
        [OperationContract]
        IsIdrEligibleResponse IsIdrEligible(string messageId, string accountNumber, int utilityId );

        [OperationContract]
        bool IsServiceRunning();

        [OperationContract]
        string Version();

    }
   
}
