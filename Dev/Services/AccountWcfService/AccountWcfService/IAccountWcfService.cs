using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;
using LibertyPower.MarketDataServices.AccountWcfServiceData;
using LibertyPower.MarketDataServices.AccountBusinessLayer;
using LibertyPower.MarketDataServices.AccountRepository;
using LibertyPower.MarketDataServices.AccountDataMapper;
using Utilities;
using UtilityLogging;
using UtilityUnityLogging;

namespace LibertyPower.MarketDataServices.AccountWcfService
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the interface name "IService1" in both code and config file together.
    [ServiceContract]
    public interface IAccountWcfService
    {
        
        [OperationContract]
        AccountServiceResponse PopulateEnrolledAccounts(string messageId);

        [OperationContract]
        AccountServiceResponse GetEnrolledAccountsToProcess(string messageId, int numberOfAccounts);

        [OperationContract]
        AccountServiceResponse UpdateAnnualUsageBulk(string messageId, AnnualUsageTranRecordList anuualUsageList);

        [OperationContract]
        bool IsServiceRunning();

        [OperationContract]
        string Version();
    }


}
