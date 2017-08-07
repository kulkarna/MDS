using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data;
using Common.Logging;
using UsageEventAggregator;
using UsageEventAggregator.Events.AccountPropertyHistory;
using LibertyPower.DataAccess.SqlAccess.OfferEngineSql;
using LibertyPower.DataAccess.SqlAccess.TransactionsSql;
using LibertyPower.Business.CommonBusiness.FieldHistory;
using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;
using System.Globalization;
using System.Text;

namespace UsageWindowsService.EventHandler
{
    public class AccountPropertyHistoryProcessRequestedEventHandler : IHandleEvents<AccountPropertyHistoryProcessRequested>
    {
        private static readonly ILog Log = LogManager.GetCurrentClassLogger();
        private bool accountFound = false;
        private static FieldHistoryManager.MapField _applyMapping = LibertyPower.Business.MarketManagement.UtilityManagement.UtilityMappingFactory.ApplyMapping;
        private static StringCollection _texasUtilities = new StringCollection { "AEPCE", "AEPNO", "CTPEN", "TXNMP", "ONCOR", "TXU-SESCO", "ONCOR-SESCO", "SHARYLAND", "TXU" };
        private static string messageId = string.Empty;
        private static string NAMESPACE = "UsageWindowsService.EventHandler";
        private static string CLASS = "AccountPropertyHistoryProcessRequestedEventHandler";


        public void Handle(AccountPropertyHistoryProcessRequested e)
        {
            VerifyMessageIdAndError();
            string methodName = string.Format(" Handle(AccountPropertyHistoryProcessRequested e)  e.account:{0}, e.Utility:{1}", e == null || e.AccountNumber == null ? "NULL" : e.AccountNumber, e == null || e.UtilityCode == null ? "NULL" : e.UtilityCode);

            Log.Info(string.Format("{0} - {1} Handle(AccountPropertyHistoryProcessRequested e) BEGIN APH insert requested for account:{2}, Utility:{3}", messageId, DateTime.Now.ToString(), e == null || e.AccountNumber == null ? "NULL" : e.AccountNumber, e == null || e.UtilityCode == null ? "NULL" : e.UtilityCode));

            try
            {
                int fileLogId;
                if (!int.TryParse(e.EdiLogId, out fileLogId))
                {
                    Log.Error(string.Format("{0}-{1} ERROR Invalid edi file log id of {2}", messageId, DateTime.Now.ToString(), e == null || e.EdiLogId == null ? "NULL" : e.EdiLogId));
                    Log.Debug(string.Format("{0} - {1} Aggregator.Publish(new AccountPropertyHistoryProcessFailed{AccountNumber={2},UtilityCode={3},TransactionId={4},Message={5}, Source={6}});", messageId, DateTime.Now.ToString(), e == null || e.AccountNumber == null ? "NULL" : e.AccountNumber, e == null || e.UtilityCode == null ? "NULL" : e.UtilityCode, e == null || e.TransactionId == null ? 0.00 : e.TransactionId, string.Format("APH insert failed because invalid ediLogId:{2} account:{0}, Utility:{1}", e.AccountNumber, e.UtilityCode, e.EdiLogId), e == null || e.Source == null ? "NULL" : e.Source));
                    Aggregator.Publish(new AccountPropertyHistoryProcessFailed
                    {
                        AccountNumber = e.AccountNumber,
                        UtilityCode = e.UtilityCode,
                        TransactionId = e.TransactionId,
                        Message = string.Format("APH insert failed because invalid ediLogId:{2} account:{0}, Utility:{1}", e.AccountNumber, e.UtilityCode, e.EdiLogId),
                        Source = e.Source
                    });
                    Log.Info(string.Format("{0} - {1} Handle(AccountPropertyHistoryProcessRequested e) END APH insert requested for account:{2}, Utility:{3}", messageId, DateTime.Now.ToString(), e == null || e.AccountNumber == null ? "NULL" : e.AccountNumber, e == null || e.UtilityCode == null ? "NULL" : e.UtilityCode));
                    return;
                }

                string debugData = string.Format("{0} - {1} var accounts = TransactionsSql.GetEdiAccountsUsingEdiLogId(e.AccountNumber:{2}, e.UtilityCode:{3}, fileLogId:{4});", messageId, DateTime.Now.ToString(), e == null || e.AccountNumber == null ? "NULL" : e.AccountNumber, e == null || e.UtilityCode == null ? "NULL" : e.UtilityCode, fileLogId);
                Log.Debug(string.Format("{0} - {1} Calling {2}", messageId, DateTime.Now.ToString(), debugData));


                var accounts = TransactionsSql.GetEdiAccountsUsingEdiLogId(e.AccountNumber, e.UtilityCode, fileLogId);

                Log.Debug(string.Format("{0} - {1} Called {2}", messageId, DateTime.Now.ToString(), debugData));

                if (accounts == null || accounts.Tables.Count < 1 || accounts.Tables[0].Rows.Count < 1)
                {
                    Log.Warn(string.Format("{0} - {1} APH insert failed because account not found for ediLogId:{4} account:{2}, Utility:{3}", messageId, DateTime.Now.ToString(), e.AccountNumber, e.UtilityCode, e.EdiLogId));

                    Aggregator.Publish(new AccountPropertyHistoryProcessFailed
                    {
                        AccountNumber = e.AccountNumber,
                        UtilityCode = e.UtilityCode,
                        TransactionId = e.TransactionId,
                        Message = string.Format("APH insert failed because account not found for ediLogId:{2} account:{0}, Utility:{1}", e.AccountNumber, e.UtilityCode, e.EdiLogId),
                        Source = e.Source
                    });
                    return;
                }

                foreach (DataRow dr in accounts.Tables[0].Rows)
                {
                    var AccountNumber = Convert.ToString(dr["AccountNumber"] == DBNull.Value ? String.Empty : dr["AccountNumber"]);
                    var Icap = Convert.ToDecimal(dr["Icap"] == DBNull.Value ? -1 : dr["Icap"]);
                    var LoadProfile = Convert.ToString(dr["LoadProfile"] == DBNull.Value ? String.Empty : dr["LoadProfile"]);
                    var RateClass = Convert.ToString(dr["RateClass"] == DBNull.Value ? String.Empty : dr["RateClass"]);
                    var Tcap = Convert.ToDecimal(dr["Tcap"] == DBNull.Value ? -1 : dr["Tcap"]);
                    var UtilityCode = Convert.ToString(dr["UtilityCode"] == DBNull.Value ? String.Empty : dr["UtilityCode"]);
                    var Voltage = Convert.ToString(dr["Voltage"] == DBNull.Value ? String.Empty : dr["Voltage"]);
                    var ZoneCode = Convert.ToString(dr["ZoneCode"] == DBNull.Value ? String.Empty : dr["ZoneCode"]);
                    var IcapEffectiveDate = Convert.ToDateTime(dr["IcapEffectiveDate"] == DBNull.Value ? DateTime.MinValue : dr["IcapEffectiveDate"]);
                    var TcapEffectiveDate = Convert.ToDateTime(dr["TcapEffectiveDate"] == DBNull.Value ? DateTime.MinValue : dr["TcapEffectiveDate"]);
                    var EffectiveDate = Convert.ToDateTime(dr["EffectiveDate"] == DBNull.Value ? DateTime.MinValue : dr["EffectiveDate"]);
                    var BillGroup = Convert.ToString(dr["BillGroup"] == DBNull.Value ? String.Empty : dr["BillGroup"]);

                    Log.Debug(string.Format("{0} - {1} AccountPropertyHistoryProcessRequestedEventHandler.Handle().AcquireAndStoreDeterminantHistory( AccountNumber:{2},Icap:{3},LoadProfile:{4},RateClass:{5},Tcap:{6},UtilityCode:{7},Voltage:{8},ZoneCode:{9},IcapEffectiveDate:{10},TcapEffectiveDate:{11},EffectiveDate:{12},BillGroup:{13})", messageId, DateTime.Now.ToString(), AccountNumber, Icap, LoadProfile, RateClass, Tcap, UtilityCode, Voltage, ZoneCode, IcapEffectiveDate.ToShortDateString(), TcapEffectiveDate.ToShortDateString(), EffectiveDate.ToShortDateString(), BillGroup));

                    AcquireAndStoreDeterminantHistory(AccountNumber, UtilityCode, IcapEffectiveDate, TcapEffectiveDate, Icap, Tcap, ZoneCode, RateClass, LoadProfile, Voltage, EffectiveDate, BillGroup);
                    Log.Info(string.Format("{0} - {1}  BEGIN Aggregator.Publish(new AccountPropertyHistoryProcessCompleted for AccountNumber : {2},UtilityCode : {3},TransactionId : {4},Source  : {5}", messageId, DateTime.Now.ToString(), e == null || e.AccountNumber == null ? "NULL" : e.AccountNumber, e == null || e.UtilityCode == null ? "NULL" : e.UtilityCode, e == null || e.TransactionId == null ? "NULL" : e.TransactionId.ToString(), e == null || e.Source == null ? "NULL" : e.Source));

                    Aggregator.Publish(new AccountPropertyHistoryProcessCompleted
                    {
                        AccountNumber = e.AccountNumber,
                        UtilityCode = e.UtilityCode,
                        TransactionId = e.TransactionId,
                        Source = e.Source
                    });

                    Log.Info(string.Format("{0} - {1} END Aggregator.Publish(new AccountPropertyHistoryProcessCompleted for AccountNumber : {2},UtilityCode : {3},TransactionId : {4},Source  : {5}", messageId, DateTime.Now.ToString(), e == null || e.AccountNumber == null ? "NULL" : e.AccountNumber, e == null || e.UtilityCode == null ? "NULL" : e.UtilityCode, e == null || e.TransactionId == null ? "NULL" : e.TransactionId.ToString(), e == null || e.Source == null ? "NULL" : e.Source));

                    Log.Info(string.Format("{0} - {1} BEGIN  Aggregator.Publish(new DataSyncRequested Completed For  AccountNumber : {2}, UtilityCode : {3},TransactionId : {4},Source : {5},BillingCycle : {6},Icap : {7},Tcap : {8},Profile : {9},ServiceClass :{10},Zone : {11}"
                       , messageId, DateTime.Now.ToString(), e == null || e.AccountNumber == null ? "NULL" : e.AccountNumber, e == null || e.UtilityCode == null ? "NULL" : e.UtilityCode, e == null || e.TransactionId == null ? "NULL" : e.TransactionId.ToString(), e == null || e.Source == null ? "NULL" : e.Source, BillGroup == null ? "NULL" : BillGroup, Icap == null ? "NULL" : Icap.ToString(), Tcap == null ? "NULL" : Tcap.ToString()
                       , LoadProfile == null ? "NULL" : LoadProfile.ToString(), RateClass == null ? "NULL" : RateClass, ZoneCode == null ? "NULL" : ZoneCode));
                    Aggregator.Publish(new DataSyncRequested
                    {
                        AccountNumber = e.AccountNumber,
                        UtilityCode = e.UtilityCode,
                        TransactionId = e.TransactionId,
                        Source = e.Source,
                        BillingCycle = BillGroup,
                        Icap = Icap.ToString(),
                        Tcap = Tcap.ToString(),
                        Profile = LoadProfile,
                        ServiceClass = RateClass,
                        Zone = ZoneCode
                    });

                    Log.Info(string.Format("{0} - {1} END  Aggregator.Publish(new DataSyncRequested Completed For  AccountNumber : {2}, UtilityCode : {3},TransactionId : {4},Source : {5},BillingCycle : {6},Icap : {7},Tcap : {8},Profile : {9},ServiceClass :{10},Zone : {11}"
                        , messageId, DateTime.Now.ToString(), e == null || e.AccountNumber == null ? "NULL" : e.AccountNumber, e == null || e.UtilityCode == null ? "NULL" : e.UtilityCode, e == null || e.TransactionId == null ? "NULL" : e.TransactionId.ToString(), e == null || e.Source == null ? "NULL" : e.Source, BillGroup == null ? "NULL" : BillGroup, Icap == null ? "NULL" : Icap.ToString(), Tcap == null ? "NULL" : Tcap.ToString()
                        , LoadProfile == null ? "NULL" : LoadProfile.ToString(), RateClass == null ? "NULL" : RateClass, ZoneCode == null ? "NULL" : ZoneCode));


                    Log.Info(string.Format("{0} - {1} Handle(AccountPropertyHistoryProcessRequested e) END APH insert requested for account:{2}, Utility:{3}", messageId, DateTime.Now.ToString(), e == null || e.AccountNumber == null ? "NULL" : e.AccountNumber, e == null || e.UtilityCode == null ? "NULL" : e.UtilityCode));
                }


            }
            catch (Exception ex)
            {
                Aggregator.Publish(new AccountPropertyHistoryProcessFailed
                {
                    AccountNumber = e.AccountNumber,
                    UtilityCode = e.UtilityCode,
                    TransactionId = e.TransactionId,
                    Message = string.Format("APH insert failed because error:{1} ediLogId:{2} account:{0}", e.AccountNumber, ex.Message, e.EdiLogId),
                    Source = e.Source
                });

                Log.Error("Error on APH request. " + ex.Message, ex);
                ErrorHandler(ex, methodName);
            }

        }

        public static void ErrorHandler(Exception exc, string method)
        {
            Log.Error(string.Format("MESSAGE ID- {0} . NAMESPACE - {1}.CLASS - {2}. METHOD - {3}. ERROR MESSAGE - {4} . ERROR DESCRIPTION - {5}", messageId.ToString(), NAMESPACE, CLASS, method, exc.Message, exc.InnerException == null ? string.Empty : exc.InnerException.ToString(), exc.StackTrace ?? string.Empty), exc);

        }
        public static void VerifyMessageIdAndError()
        {

            if (messageId == null || string.IsNullOrWhiteSpace(messageId))
                messageId = Guid.NewGuid().ToString();
        }

        private static void AcquireAndStoreDeterminantHistory(string accountNumber, string utilityCode, DateTime IcapEffectiveDate, DateTime TcapEffectiveDate, decimal iCap, decimal tCap, string zoneCode, string rateClass, string loadProfile, string voltage, DateTime effectiveDate, string billGroup)
        {
            string methodName = string.Format("AcquireAndStoreDeterminantHistory(accountNumber:{1},utilityCode:{2},IcapEffectiveDate:{3},TCapEffectiveDate:{4},iCap:{5},tCap:{6},zoneCode:{7},rateClass:{8},loadProfile:{9},voltage:{10},effectiveDate:{11}, billGroup:{12}",
                                messageId, accountNumber ?? "NULL", utilityCode ?? "NULL", IcapEffectiveDate.ToString("yyyy-MM-dd HH:mm:ss.fff", CultureInfo.InvariantCulture), TcapEffectiveDate.ToString("yyyy-MM-dd HH:mm:ss.fff", CultureInfo.InvariantCulture), iCap.ToString() ?? "NULL", tCap.ToString() ?? "NULL", zoneCode ?? "NULL", rateClass ?? "NULL", loadProfile ?? "NULL", voltage ?? "NULL", effectiveDate.ToString("yyyy-MM-dd HH:mm:ss.fff", CultureInfo.InvariantCulture), billGroup ?? "NULL");

            try
            {
                VerifyMessageIdAndError();
                Log.Info(string.Format("{0}-{1}-{2} BEGIN Method", messageId, DateTime.Now.ToString(), methodName));

                //DataSet ds = LibertyPowerSql.AccountsExistsInOfferEngineAndServiceAccount(accountNumber, utilityCode);
                //if (ds.Tables[0].Rows[0]["Exists"].ToString() == "0" && !TransactionsSql.HasUsageTransaction(accountNumber, utilityCode))
                //{
                //    Log.Info(string.Format("{0} - {1} Account {2} Doesn't Exist in Offer Engine in {3} Method", messageId,DateTime.Now.ToString(), accountNumber, methodName));
                //    return;
                //}


                // If the effective date is "1/1/1980" then use current date else use the EDI account's effective date
                //var effectiveDate = account.EffectiveDate.Year == 1980 ? DateTime.Now.Date : account.EffectiveDate;


                if (effectiveDate == DateTime.MinValue || effectiveDate.Year == 1980)
                    effectiveDate = DateTime.Now;

                var aphRecords = new List<AccountPropertyHistoryRecord>();

                aphRecords.Add(new AccountPropertyHistoryRecord()
                {
                    AccountNumber = accountNumber,
                    Utility = utilityCode,
                    FieldName = TrackedField.Utility.ToString(),
                    FieldValue = utilityCode,
                    EffectiveDate = effectiveDate,
                    FieldSource = FieldUpdateSources.EDIParser.ToString(),
                    LockStatus = FieldLockStatus.Unknown,
                    CreatedBy = ""
                });

                if (!string.IsNullOrWhiteSpace(zoneCode) && !_texasUtilities.Contains(utilityCode.ToUpper()))
                    aphRecords.Add(new AccountPropertyHistoryRecord()
                    {
                        AccountNumber = accountNumber,
                        Utility = utilityCode,
                        FieldName = TrackedField.Zone.ToString(),
                        FieldValue = zoneCode,
                        EffectiveDate = effectiveDate,
                        FieldSource = FieldUpdateSources.EDIParser.ToString(),
                        LockStatus = FieldLockStatus.Unknown,
                        CreatedBy = ""
                    });
                if (!string.IsNullOrWhiteSpace(rateClass))
                    aphRecords.Add(new AccountPropertyHistoryRecord()
                    {
                        AccountNumber = accountNumber,
                        Utility = utilityCode,
                        FieldName = TrackedField.RateClass.ToString(),
                        FieldValue = rateClass,
                        EffectiveDate = effectiveDate,
                        FieldSource = FieldUpdateSources.EDIParser.ToString(),
                        LockStatus = FieldLockStatus.Unknown,
                        CreatedBy = ""
                    });

                if (!string.IsNullOrWhiteSpace(loadProfile))
                    aphRecords.Add(new AccountPropertyHistoryRecord()
                    {
                        AccountNumber = accountNumber,
                        Utility = utilityCode,
                        FieldName = TrackedField.LoadProfile.ToString(),
                        FieldValue = loadProfile,
                        EffectiveDate = effectiveDate,
                        FieldSource = FieldUpdateSources.EDIParser.ToString(),
                        LockStatus = FieldLockStatus.Unknown,
                        CreatedBy = ""
                    });

                if (!string.IsNullOrWhiteSpace(voltage))
                    aphRecords.Add(new AccountPropertyHistoryRecord()
                    {
                        AccountNumber = accountNumber,
                        Utility = utilityCode,
                        FieldName = TrackedField.Voltage.ToString(),
                        FieldValue = voltage,
                        EffectiveDate = effectiveDate,
                        FieldSource = FieldUpdateSources.EDIParser.ToString(),
                        LockStatus = FieldLockStatus.Unknown,
                        CreatedBy = ""
                    });

                if (IcapEffectiveDate == DateTime.MinValue || IcapEffectiveDate.Year == 1980)
                    IcapEffectiveDate = DateTime.Now;

                if (!string.IsNullOrWhiteSpace(utilityCode) && (utilityCode.Equals("CMP", StringComparison.InvariantCultureIgnoreCase) || utilityCode.Equals("BANGOR", StringComparison.InvariantCultureIgnoreCase)))
                    iCap = iCap * 1000.0m;

                if (iCap > -1)
                    aphRecords.Add(new AccountPropertyHistoryRecord()
                    {
                        AccountNumber = accountNumber,
                        Utility = utilityCode,
                        FieldName = TrackedField.ICap.ToString(),
                        FieldValue = Convert.ToString(iCap),
                        EffectiveDate = IcapEffectiveDate,
                        FieldSource = FieldUpdateSources.EDIParser.ToString(),
                        LockStatus = FieldLockStatus.Unknown,
                        CreatedBy = ""
                    });

                if (!string.IsNullOrWhiteSpace(billGroup) && Convert.ToInt16(billGroup) > -1)
                    aphRecords.Add(new AccountPropertyHistoryRecord()
                    {
                        AccountNumber = accountNumber,
                        Utility = utilityCode,
                        FieldName = TrackedField.BillGroup.ToString(),
                        FieldValue = billGroup,
                        EffectiveDate = IcapEffectiveDate,
                        FieldSource = FieldUpdateSources.EDIParser.ToString(),
                        LockStatus = FieldLockStatus.Unknown,
                        CreatedBy = ""
                    });

                if (TcapEffectiveDate == DateTime.MinValue || TcapEffectiveDate.Year == 1980)
                    TcapEffectiveDate = DateTime.Now;

                if (tCap > -1 && TcapEffectiveDate > new DateTime(1980, 1, 1))
                    aphRecords.Add(new AccountPropertyHistoryRecord()
                    {
                        AccountNumber = accountNumber,
                        Utility = utilityCode,
                        FieldName = TrackedField.TCap.ToString(),
                        FieldValue = Convert.ToString(tCap),
                        EffectiveDate = TcapEffectiveDate,
                        FieldSource = FieldUpdateSources.EDIParser.ToString(),
                        LockStatus = FieldLockStatus.Unknown,
                        CreatedBy = ""
                    });
                StringBuilder sbLog = new StringBuilder();
                foreach (AccountPropertyHistoryRecord accountPropertyHistoryRecord in aphRecords)
                {
                    sbLog.Append(string.Format(
                                "\n aphRecords.Item[AccountNumber:{2};Utility:{3};FieldName:{4};FieldValue:{5};EffectiveDate:{6};FieldSource:{7};LockStatus:{8};CreatedBy:{9}",
                                messageId,
                                DateTime.Now.ToString(),
                                accountPropertyHistoryRecord.AccountNumber ?? "NULL",
                                accountPropertyHistoryRecord.Utility ?? "NULL",
                                accountPropertyHistoryRecord.FieldName ?? "NULL",
                                accountPropertyHistoryRecord.FieldValue ?? "NULL",
                                accountPropertyHistoryRecord.EffectiveDate.ToString("yyyy-MM-dd HH:mm:ss.fff", CultureInfo.InvariantCulture),
                                accountPropertyHistoryRecord.FieldSource ?? "NULL",
                                accountPropertyHistoryRecord.LockStatus.ToString() ?? "NULL",
                                accountPropertyHistoryRecord.CreatedBy ?? "NULL"));
                }

                Log.Info(string.Format("\n {0} - {1}  {2}",
                                       messageId,
                                       DateTime.Now.ToString(),
                                       sbLog.ToString()));

                Log.Info(string.Format("{0}-{1} BEGIN FieldHistoryManager.FieldValueBulkInsert(aphRecords :{3}", messageId, DateTime.Now.ToString(), methodName, sbLog.ToString()));

                FieldHistoryManager.FieldValueBulkInsert(aphRecords);

                Log.Info(string.Format("{0}-{1} END FieldHistoryManager.FieldValueBulkInsert(aphRecords :{3}", messageId, DateTime.Now.ToString(), methodName, sbLog.ToString()));
                //Code added for PBI-82454

                Log.Info(string.Format("{0}-{1}-{2} BEGIN CRMLibertyPowerSql.AccountPropertyHistoryWatchdogInsertV4", messageId, DateTime.Now.ToString(), methodName));
                DataSet dataSet = CRMLibertyPowerSql.AccountPropertyHistoryWatchdogInsertFromQuerysV4(accountNumber, utilityCode, 1);
                if (dataSet != null)

                    Log.Info(string.Format("{0}-{1}-{2}Sucess-END CRMLibertyPowerSql.AccountPropertyHistoryWatchdogInsertV4", messageId, DateTime.Now.ToString(), methodName));
                else
                    Log.Info(string.Format("{0}-{1}-{2}Fail-END CRMLibertyPowerSql.AccountPropertyHistoryWatchdogInsertV4", messageId, DateTime.Now.ToString(), methodName));

                Log.Info(string.Format("{0}-{1}-{2} END Method", messageId, DateTime.Now.ToString(), methodName));
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, methodName);
            }
        }
    }


}