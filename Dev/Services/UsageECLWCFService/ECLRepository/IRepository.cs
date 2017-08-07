using System;
using System.ComponentModel.Composition;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using LibertyPower.MarketDataServices.UsageEclWcfServiceData;

namespace LibertyPower.MarketDataServices.UsageEclRepository
{
    public interface IRepository
    {
        DataSet DoesEclDataExist(string messageId, string accountNumber, int utilityId);
    }
}