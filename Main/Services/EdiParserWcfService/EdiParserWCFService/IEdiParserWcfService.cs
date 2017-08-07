using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.ServiceModel.Description;
using System.Text;
using LibertyPower.MarketDataServices.EdiParserWcfServiceData;



namespace LibertyPower.MarketDataServices.EdiParserWcfService
{
    [ServiceContract]
    public interface IEdiParserWcfService
    {
        [OperationContract]
        GetBillGroupMostRecentResponse GetBillGroupMostRecent(string messageId, string accountNumber, string utilitycd);

        [OperationContract]
        bool IsServiceRunning();

        [OperationContract]
        string Version();

    }
   
}
