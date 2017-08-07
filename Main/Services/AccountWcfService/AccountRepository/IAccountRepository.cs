using System;
using System.ComponentModel.Composition;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using Utilities;
using UtilityLogging;
using UtilityUnityLogging;
using LibertyPower.MarketDataServices.AccountWcfServiceData;

namespace LibertyPower.MarketDataServices.AccountRepository
{
    public interface IAccountRepository
    {
       // DataSet GetEnrolledAccounts(string messageId);
        //DataSet GetEnrolledAccountsForUtility(string messageId,int utilityId);
        DataSet PopulateEnrolledAccounts(string messageId);
        DataSet GetEnrolledAccountsToProcess(string messageId, int numberOfAccounts);
        DataSet UpdateAnnualUsageBulk(string messageId, AnnualUsageTranRecordList anuualUsageList);
    }
}