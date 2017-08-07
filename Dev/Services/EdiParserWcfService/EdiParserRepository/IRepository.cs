using System;
using System.ComponentModel.Composition;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using Common.Logging;
using LibertyPower.MarketDataServices.EdiParserWcfServiceData;

namespace LibertyPower.MarketDataServices.EdiParserRepository
{
    public interface IRepository
    {
        DataSet GetBillGroupMostRecent(string messageId, string accountNumber, string utilitycd);
    }
}