using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Xrm.Sdk;
using Microsoft.Xrm.Sdk.Client;
using Microsoft.Xrm.Sdk.Query;
using NLog;
using LibertyPower.Business.CustomerManagement.AccountManagement;

namespace CrmServiceAccountUpdater
{
    public class Program
    {
        public const string SERVICE_ACCOUNT_ENTITY = "lpc_serviceaccount";
        public const string CONFIG_ENTITY = "lpc_config";
        public const string CONFIG_NAME_KEY = "lpc_name";
        public const string CONFIG_NAME_KEY_VALUE = "Usage Age Days";
        public const string CONFIG_NAME_VALUE = "lpc_value";
        public const string SERVICE_ACCOUNT_KEY = "lpc_accountnumber";
        public const string SERVICE_ACCOUNT_ID_KEY = "lpc_serviceaccountid";
        public const string UTILITY_ENTITY = "lpc_utility";
        public const string UTILITY_KEY = "lpc_utility_id";
        public const string UTILITY_ID_KEY = "lpc_utilityid";

        public const string USAGE_DATE_KEY = "lpc_usagedate";
        public const string USAGE_ANNUAL_MWH_KEY = "lpc_mwh_annualusage";
        public const string USAGE_ANNUAL_KWH_KEY = "lpc_kwh_annualusage";

        /// <summary>
        /// Annual usage updated date column name to update.
        /// </summary>
        private const string ANNUAL_USAGE_UPDATED_DATE = "lpc_lastdateupdategetannualusage";
        /// <summary>
        /// Annual usage updated date column name to update.
        /// </summary>
        private const string ANNUAL_USAGE_UPDATED_DATE_COLUMN_NAME = "lpc_LastDateUpdateGetAnnualUsage";

        private static readonly Logger Log = LogManager.GetCurrentClassLogger();
        private static StringCollection accountsProcessed;

        private static int _GetUsageDaysFromConfigEntity(OrganizationServiceProxy proxy)
        {
            var query = new QueryExpression
            {
                ColumnSet = new ColumnSet(
                    new[]
                            {
                                CONFIG_NAME_VALUE
                            }),

                EntityName = CONFIG_ENTITY,
                Criteria =
                {
                    Conditions =
                                {
                                    new ConditionExpression(CONFIG_NAME_KEY,
                                                            ConditionOperator.Equal,
                                                            CONFIG_NAME_KEY_VALUE)
                                }
                }
            };

            EntityCollection ec = proxy.RetrieveMultiple(query);

            if (ec.TotalRecordCount == 0)
                return 0;

            var e = ec.Entities.First();

            int o;
            if (int.TryParse(e[CONFIG_NAME_VALUE].ToString(), out o))
                return o;

            return 0;
        }

        public static void Main(string[] args)
        {
            try
            {
                accountsProcessed = new StringCollection();

                Log.Trace("Proxy starting");
                var proxy = CrmUtil.GetProxy();

                Log.Trace("Proxy started");

                proxy.Timeout = new TimeSpan(0, 10, 0);

                var numberOfDays = _GetUsageDaysFromConfigEntity(proxy);

                Log.Trace("Number of days is: " + numberOfDays);

                Log.Trace("Getting all open pr accounts.");
                var accounts = _UsageAccounts(numberOfDays);
                Log.Trace("Done with accounts get. Count: " + accounts.Count);

                foreach (var account in accounts)
                {
                    // Need to trim the account number since CRM allows upto 100 chars for account number
                    account.Number = account.Number.Trim();

                    if (accountsProcessed.Contains(account.Number + account.UtilityCode))
                        continue;

                    try
                    {
                        Log.Trace("Updating account " + account.Number);
                        if (!_UpdateUsageAttributes(account))
                            continue;
                        if (!_UpdateServiceAccount(account, proxy))
                            continue;
                        accountsProcessed.Add(account.Number + account.UtilityCode);
                        Log.Trace("Updated account " + account.Number);
                    }
                    catch (Exception ex)
                    {
                        Log.Error("Failed to update account " + account.Number + " because " + ex.Message, ex);
                    }
                }
                Log.Debug("Completed Update. Accounts updated count " + accountsProcessed.Count);
            }
            catch (Exception ex)
            {
                Log.Error(ex.GetBaseException().ToString(), ex);
            }

        }

        private static bool _UpdateServiceAccount(Account ua, OrganizationServiceProxy proxy)
        {
            try
            {
                var query = new QueryExpression
                {
                    ColumnSet = new ColumnSet(
                        new[]
                            {
                                USAGE_DATE_KEY,
                                USAGE_ANNUAL_KWH_KEY,
                                USAGE_ANNUAL_MWH_KEY,
                                //New last date update annual usage column
                                ANNUAL_USAGE_UPDATED_DATE
                            }),

                    EntityName = SERVICE_ACCOUNT_ENTITY,
                    Criteria =
                    {
                        Conditions =
                                {
                                    new ConditionExpression(SERVICE_ACCOUNT_KEY,
                                                            ConditionOperator.Equal,
                                                            ua.Number)
                                }
                    }
                };

                LinkEntity utilityEntityLink = query.AddLink(UTILITY_ENTITY, UTILITY_ID_KEY, UTILITY_ID_KEY, JoinOperator.Inner);
                utilityEntityLink.LinkCriteria.AddCondition(UTILITY_KEY, ConditionOperator.Equal, ua.UtilityId);

                EntityCollection ec = proxy.RetrieveMultiple(query);

                Entity e = ec.Entities.FirstOrDefault();
                if (e == null)
                {
                    Log.Error(string.Format("Could not find Pending Data Request object for AccountNumber[{0}] and UtilityId [{1}]", ua.Number, ua.UtilityId));
                    return false;
                }

                e[USAGE_DATE_KEY] = ua.UsageDate;
                //CrmUtil.SetAttribute(e, USAGE_DATE_KEY, ua.UsageDate);
                Log.Trace("Date is " + ua.UsageDate.ToString());

                e[USAGE_ANNUAL_KWH_KEY] = Convert.ToDecimal(ua.Usage);
                //CrmUtil.SetAttribute(e, USAGE_ANNUAL_KWH_KEY, ua.Usage);
                Log.Trace("KWH Usage is " + ua.Usage);
                try
                {

                    var mwh = Convert.ToDecimal(Convert.ToDecimal(ua.Usage) / 1000);
                    //CrmUtil.SetAttribute(e, USAGE_ANNUAL_MWH_KEY, mwh);
                    e[USAGE_ANNUAL_MWH_KEY] = mwh;
                    Log.Trace("MWH Usage is " + mwh);
                }
                catch (Exception ex)
                {
                    Log.Error("MWH division failed " + ex.Message, ex);
                    return false;
                }

                CrmUtil.SetAttribute(e, ANNUAL_USAGE_UPDATED_DATE, ua.AnnualUsageUpdatedDate);
                Log.Trace("Annual usage updated date is " + ua.AnnualUsageUpdatedDate);

                proxy.Update(e);
                return true;
            }
            catch (Exception ex)
            {
                Log.Error("Error with UpdateServiceAccount: " + ex.GetBaseException(), ex);
                return false;
            }


        }

        private static bool _UpdateUsageAttributes(Account account)
        {
            try
            {
                //Annual Usage
                int usage;
                if (!CompanyAccountFactory.CalculateAnnualUsage(account.Number.Trim(), account.UtilityCode.Trim(), out usage))
                {
                    Log.Warn("No meter reads available for annual usage calculation for Account " + account.Number);
                    return false;
                }

                // Update the usage date in CRM
                DateTime latestDate = CompanyAccountFactory.GetMostRecentMeterDateWithoutUsageConsolidation(account.Number.Trim(), account.UtilityCode.Trim());

                // Abhi Kulkarni 06/21/2016 
                // Only update the annual usage if usage date is different
                // Vikas Sharma 11/07/2016
                // While comparing Date it is taking consideration of time also.Removed now only date is compared
                // Ayane Suarez 31/03/2017
                // New last date update annual usage is being updated
                if ((latestDate != null && DateTime.Compare(latestDate.Date, account.UsageDate.Date) != 0))
                {
                    // Update the Usage in CRM
                    account.Usage = usage;
                    account.UsageDate = latestDate;
                    account.AnnualUsageUpdatedDate = DateTime.Today;

                    return true;
                }

                return false;
            }
            catch (Exception ex)
            {
                Log.Error("Error in Update usage attributes: " + ex.GetBaseException(), ex);
                return false;
            }

        }

        private static List<Account> _UsageAccounts(int numberOfDays)
        {

            var cutOffDate = DateTime.Now.Subtract(TimeSpan.FromDays(numberOfDays)).ToShortDateString();

            Log.Debug("Cut off date is " + cutOffDate);

            var accounts = new List<Account>();

            var sqlStatement = "GET_ServiceAccounts_OpenPRs";
            var cs = ConfigurationManager.ConnectionStrings["CRM"].ConnectionString;
            using (var con = new SqlConnection(cs))
            {
                using (var cmd = new SqlCommand(sqlStatement, con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandTimeout = 1440;

                    SqlParameter param1 = new SqlParameter("UsageDate", SqlDbType.DateTime);
                    param1.Direction = ParameterDirection.Input;
                    param1.Value = cutOffDate;
                    cmd.Parameters.Add(param1);

                    Log.Trace("open sql connection..");
                    con.Open();
                    Log.Trace("Executing sql get all accounts");
                    using (var reader = cmd.ExecuteReader(CommandBehavior.CloseConnection))
                    {
                        while (reader.Read())
                        {
                            if (reader.IsDBNull(0))
                                continue;

                            // Ayane Suarez 31/03/2017
                            // New last date update annual usage is being retrieved from DB.
                            // Using new SqlDataReaderExtension form getting values.
                            accounts.Add(new Account
                            {
                                Number = reader.GetText("LPC_AccountNumber"),
                                UtilityId = reader.GetText("LPC_Utility_Id"),
                                UtilityCode = reader.GetText("LPC_UtilityCode"),
                                Usage = string.IsNullOrWhiteSpace(reader.GetText("LPC_Mwh_AnnualUsage"))
                                        ? 0
                                        : Convert.ToInt32(Convert.ToDouble(reader.GetText("LPC_Mwh_AnnualUsage"))),
                                UsageDate = reader.GetValue<DateTime>("LPC_UsageDate") == null
                                            ? DateTime.MinValue
                                            : DateTime.Parse(reader.GetText("LPC_UsageDate")),
                                AnnualUsageUpdatedDate = reader.GetValue<DateTime>(ANNUAL_USAGE_UPDATED_DATE_COLUMN_NAME) == null
                                            ? DateTime.MinValue
                                            : DateTime.Parse(reader.GetText(ANNUAL_USAGE_UPDATED_DATE_COLUMN_NAME))
                            });
                        }
                    }
                    con.Close();
                }
            }

            return accounts;

        }

        private static void _UpdateLastTxn(string txn)
        {
            Configuration config = ConfigurationManager.OpenExeConfiguration(ConfigurationUserLevel.None);  // the config that applies to all users
            AppSettingsSection appSettings = config.AppSettings;

            if (appSettings.IsReadOnly() == false)
            {

                appSettings.Settings["LastTxn"].Value = txn;

                config.Save();
            }
        }
    }
}