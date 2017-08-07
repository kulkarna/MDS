using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using LibertyPower.MarketDataServices.EdiParserRepository;
using LibertyPower.MarketDataServices.EdiParserWcfServiceData;

namespace LibertyPower.MarketDataServices.EdiParserBusinessLayer
{
    /// <summary>
    /// Interface IBusinessLayer
    /// </summary>
    public interface IBusinessLayer
    {
        GetBillGroupMostRecentResponse GetBillGroupMostRecent(string messageId, string accountNumber, string utilityCode);
    }
}