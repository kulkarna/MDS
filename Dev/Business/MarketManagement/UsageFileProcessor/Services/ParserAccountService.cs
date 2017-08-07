using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data;
using System.Text.RegularExpressions;
using LibertyPower.Business.CommonBusiness.FieldHistory;
using LibertyPower.Business.MarketManagement.UtilityManagement;
using UsageFileProcessor.Entities;
using LibertyPower.DataAccess.SqlAccess.OfferEngineSql;
using LibertyPower.DataAccess.SqlAccess.TransactionsSql;


namespace UsageFileProcessor.Services
{
    public static class ParserAccountService
    {
        public static List<ParserAccount> UpgradeUtilityAccountList(UtilityAccountList list)
        {
            List<ParserAccount> upgrade = null;
            foreach (LibertyPower.Business.MarketManagement.UtilityManagement.UtilityAccount account in list)
            {
                try
                {
                    var a = (ParserAccount)account;
                    if (upgrade == null)
                        upgrade = new List<ParserAccount>();
                    upgrade.Add(a);
                }
                catch { return null; }
            }
            return upgrade;
        }

        public static ParserAccount GetAccount(int excelRowNumber)
        {
            return new ParserAccount(excelRowNumber);
        }

        public static ParserAccount GetAccount(int excelRowNumber, string sheetName)
        {
            return new ParserAccount(excelRowNumber, sheetName);
        }

        public static string ExtractZip(string buf)
        {
            //handle 3 patterns- a line in either 5-4, 9 digits or 5 digits.
            string pattern = @"(\d{5}-\d{4}$|\d{9}$|\d{5}$)";
            Regex rgx = new Regex(pattern);
            Match m = rgx.Match(buf);
            if (m.Success)
            {
                return m.Value;
            }
            else
            {
                return string.Empty;
            }
        }

        public static string ExtractCity(string buf)
        {
            Regex rgx = new Regex("tx");

            string data = buf.ToLower();
            string[] results = rgx.Split(data);
            return results[0];
        }

        public static string ExtractLoadShapeID(string loadProfile)
        {
            string answer = "";
            string[] parts = loadProfile.Trim().Split("_".ToCharArray());
            if (parts.Length > 1)
            {
                answer = string.Format("{0}_{1}", parts[0], parts[1]);
            }
            return answer;
        }

        public static string ExtractState(string buf)
        {
            //for now all utilities use TX for the state.
            //Add code later to retrieve the 2 letters that are not commas and not whitespace
            //and are in front of the zipcode.
            return "TX";
        }

        public static int FindMostRecentRowToBaseAccountOn(List<DataRow> rows)
        {
            int accountRowIndex = 0;
            DateTime? endDate = ConvertToDate(rows[0]["End Date"].ToString());

            for (int i = 1; i < rows.Count; i++)
            {
                DateTime? dateBuf = ConvertToDate(rows[i]["End Date"].ToString());

                if (dateBuf > endDate)
                {
                    accountRowIndex = i;
                    endDate = dateBuf;
                }
            }

            return accountRowIndex;
        }

        public static DateTime? ConvertToDate(string valueToConvert)
        {
            DateTime result;
            if (DateTime.TryParse(valueToConvert, out result))
            {
                return result;
            }
            else
            {
                return null;
            }
        }

        private static FieldHistoryManager.MapField _applyMapping = LibertyPower.Business.MarketManagement.UtilityManagement.UtilityMappingFactory.ApplyMapping;
        private static StringCollection _texasUtilities = new StringCollection{ "AEPCE", "AEPNO", "CTPEN", "TXNMP", "ONCOR", "TXU-SESCO", "ONCOR-SESCO", "SHARYLAND", "TXU" };
        public static void ProcessAccountPropertyHistory(ParserAccount account, string currentUser)
        {

            DateTime icapEffectiveDate, tcapEffectiveDate;
            DateTime.TryParse(account.FutureICapEffectiveDate, out icapEffectiveDate);
            DateTime.TryParse(account.FutureTCapEffectiveDate, out tcapEffectiveDate);


            _AcquireAndStoreDeterminantHistory(account.RetailMarketCode, account.UtilityCode, icapEffectiveDate,
                                               tcapEffectiveDate, account.Icap, account.Tcap, account.ZoneCode,
                                               account.RateClass, account.LoadProfile, account.Voltage, DateTime.Now);

   
        }

            private static void _AcquireAndStoreDeterminantHistory(string accountNumber, string utilityCode, DateTime IcapEffectiveDate, DateTime TcapEffectiveDate, decimal? iCap, decimal? tCap, string zoneCode, string rateClass, string loadProfile, string voltage, DateTime effectiveDate)
        {
            DataSet ds = OfferSql.AccountExistsInOfferEngine(accountNumber, utilityCode);
            if (ds.Tables[0].Rows[0]["Exists"].ToString() == "0" && !TransactionsSql.HasUsageTransaction(accountNumber, utilityCode))
				return;

		    // If the effective date is "1/1/1980" then use current date else use the EDI account's effective date
			//var effectiveDate = account.EffectiveDate.Year == 1980 ? DateTime.Now.Date : account.EffectiveDate;

            
            if (effectiveDate == DateTime.MinValue || effectiveDate.Year == 1980)
                effectiveDate = DateTime.Now;


            var aphRecords = new List<AccountPropertyHistoryRecord>(7);

            aphRecords.Add(new AccountPropertyHistoryRecord()
            {
                AccountNumber = accountNumber,
                Utility = utilityCode,
                FieldName = TrackedField.Utility.ToString(),
                FieldValue = utilityCode,
                EffectiveDate = effectiveDate,
                FieldSource = FieldUpdateSources.EDIParser.ToString(),
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
                    CreatedBy = ""
                });

            if (IcapEffectiveDate == DateTime.MinValue || IcapEffectiveDate.Year == 1980)
                IcapEffectiveDate = DateTime.Now;

            if (!string.IsNullOrWhiteSpace(utilityCode) && utilityCode.Equals("CMP", StringComparison.InvariantCultureIgnoreCase))
                iCap = iCap * 1000.0m;

            if (iCap.HasValue && iCap > -1)
                aphRecords.Add(new AccountPropertyHistoryRecord()
                {
                    AccountNumber = accountNumber,
                    Utility = utilityCode,
                    FieldName = TrackedField.ICap.ToString(),
                    FieldValue = Convert.ToString(iCap),
                    EffectiveDate = IcapEffectiveDate,
                    FieldSource = FieldUpdateSources.EDIParser.ToString(),
                    CreatedBy = ""
                });

            if (TcapEffectiveDate == DateTime.MinValue || TcapEffectiveDate.Year == 1980)
                TcapEffectiveDate = DateTime.Now;

            if (tCap.HasValue && tCap > -1 && TcapEffectiveDate > new DateTime(1980, 1, 1))
                aphRecords.Add(new AccountPropertyHistoryRecord()
                {
                    AccountNumber = accountNumber,
                    Utility = utilityCode,
                    FieldName = TrackedField.TCap.ToString(),
                    FieldValue = Convert.ToString(tCap),
                    EffectiveDate = TcapEffectiveDate,
                    FieldSource = FieldUpdateSources.EDIParser.ToString(),
                    CreatedBy = ""
                });

            FieldHistoryManager.FieldValueBulkInsert(aphRecords);

		}
        
        public static void AcquireAndStoreDeterminantHistory(string retailMarketCode, string utilityCode, string accountNumber, string rateClass, string loadProfile, string loadShapeID, string zone, string voltage, string meterType, string userName)
        {
            var aid = new AccountIdentifier(utilityCode, accountNumber);

            FieldHistoryManager.FieldValueInsert(aid, TrackedField.Utility, utilityCode, null, FieldUpdateSources.UtilityUsageFile, "", FieldLockStatus.Unknown, _applyMapping);

            switch (retailMarketCode)
            {
                case ("TX"):

                    FieldHistoryManager.FieldValueInsert(aid, TrackedField.RateClass, rateClass ?? "", null, FieldUpdateSources.UtilityUsageFile, userName, FieldLockStatus.Unknown, _applyMapping);
                    FieldHistoryManager.FieldValueInsert(aid, TrackedField.LoadProfile, loadProfile ?? "", null, FieldUpdateSources.UtilityUsageFile, userName, FieldLockStatus.Unknown, _applyMapping);
                    FieldHistoryManager.FieldValueInsert(aid, TrackedField.LoadShapeID, loadShapeID ?? "", null, FieldUpdateSources.UtilityUsageFile, userName, FieldLockStatus.Unknown, _applyMapping);
                    break;
                case ("CA"):

                    FieldHistoryManager.FieldValueInsert(aid, TrackedField.Zone, zone ?? "", null, FieldUpdateSources.UtilityUsageFile, userName, FieldLockStatus.Unknown, _applyMapping);
                    FieldHistoryManager.FieldValueInsert(aid, TrackedField.RateClass, rateClass ?? "", null, FieldUpdateSources.UtilityUsageFile, userName, FieldLockStatus.Unknown, _applyMapping);
                    FieldHistoryManager.FieldValueInsert(aid, TrackedField.Voltage, voltage ?? "", null, FieldUpdateSources.UtilityUsageFile, userName, FieldLockStatus.Unknown, _applyMapping);
                    FieldHistoryManager.FieldValueInsert(aid, TrackedField.MeterType, meterType, null, FieldUpdateSources.UtilityUsageFile, userName, FieldLockStatus.Unknown, _applyMapping);
                    break;
                default:
                    break;
            }


        }

        public static void AcquireAndStoreDeterminantHistory(string retailMarketCode, string utilityCode, string accountNumber, string rateClass, string loadProfile, string loadShapeID, string zone, string voltage, string meterType, string iCap, string tCap, string futureICap, string futureTCap, string futureICapEffectiveDate, string futureTCapEffectiveDate, string userName)
        {
            var aid = new AccountIdentifier(utilityCode, accountNumber);

            FieldHistoryManager.FieldValueInsert(aid, TrackedField.Utility, utilityCode, null, FieldUpdateSources.UtilityUsageFile, "", FieldLockStatus.Unknown, _applyMapping);

            switch (retailMarketCode)
            {
                case ("TX"):

                    FieldHistoryManager.FieldValueInsert(aid, TrackedField.RateClass, rateClass ?? "", null, FieldUpdateSources.UtilityUsageFile, userName, FieldLockStatus.Unknown, _applyMapping);
                    FieldHistoryManager.FieldValueInsert(aid, TrackedField.LoadProfile, loadProfile ?? "", null, FieldUpdateSources.UtilityUsageFile, userName, FieldLockStatus.Unknown, _applyMapping);
                    FieldHistoryManager.FieldValueInsert(aid, TrackedField.LoadShapeID, loadShapeID ?? "", null, FieldUpdateSources.UtilityUsageFile, userName, FieldLockStatus.Unknown, _applyMapping);
                    
                    FieldHistoryManager.FieldValueInsert(aid, TrackedField.ICap, iCap ?? "", null, FieldUpdateSources.UtilityUsageFile, userName, FieldLockStatus.Unknown, _applyMapping);
                    FieldHistoryManager.FieldValueInsert(aid, TrackedField.TCap, tCap ?? "", null, FieldUpdateSources.UtilityUsageFile, userName, FieldLockStatus.Unknown, _applyMapping);
                    FieldHistoryManager.FieldValueInsert(aid, TrackedField.FutureICap, futureICap ?? "", null, FieldUpdateSources.UtilityUsageFile, userName, FieldLockStatus.Unknown, _applyMapping);
                    FieldHistoryManager.FieldValueInsert(aid, TrackedField.FutureTCap, futureTCap ?? "", null, FieldUpdateSources.UtilityUsageFile, userName, FieldLockStatus.Unknown, _applyMapping);
                    FieldHistoryManager.FieldValueInsert(aid, TrackedField.FutureICapEffectiveDate, futureICapEffectiveDate ?? "", null, FieldUpdateSources.UtilityUsageFile, userName, FieldLockStatus.Unknown, _applyMapping);
                    FieldHistoryManager.FieldValueInsert(aid, TrackedField.FutureTCapEffectiveDate, futureTCapEffectiveDate ?? "", null, FieldUpdateSources.UtilityUsageFile, userName, FieldLockStatus.Unknown, _applyMapping);

                    break;
                case ("CA"):

                    FieldHistoryManager.FieldValueInsert(aid, TrackedField.Zone, zone ?? "", null, FieldUpdateSources.UtilityUsageFile, userName, FieldLockStatus.Unknown, _applyMapping);
                    FieldHistoryManager.FieldValueInsert(aid, TrackedField.RateClass, rateClass ?? "", null, FieldUpdateSources.UtilityUsageFile, userName, FieldLockStatus.Unknown, _applyMapping);
                    FieldHistoryManager.FieldValueInsert(aid, TrackedField.Voltage, voltage ?? "", null, FieldUpdateSources.UtilityUsageFile, userName, FieldLockStatus.Unknown, _applyMapping);
                    FieldHistoryManager.FieldValueInsert(aid, TrackedField.MeterType, meterType, null, FieldUpdateSources.UtilityUsageFile, userName, FieldLockStatus.Unknown, _applyMapping);
                    
                    FieldHistoryManager.FieldValueInsert(aid, TrackedField.ICap, iCap ?? "", null, FieldUpdateSources.UtilityUsageFile, userName, FieldLockStatus.Unknown, _applyMapping);
                    FieldHistoryManager.FieldValueInsert(aid, TrackedField.TCap, tCap ?? "", null, FieldUpdateSources.UtilityUsageFile, userName, FieldLockStatus.Unknown, _applyMapping);
                    FieldHistoryManager.FieldValueInsert(aid, TrackedField.FutureICap, futureICap ?? "", null, FieldUpdateSources.UtilityUsageFile, userName, FieldLockStatus.Unknown, _applyMapping);
                    FieldHistoryManager.FieldValueInsert(aid, TrackedField.FutureTCap, futureTCap ?? "", null, FieldUpdateSources.UtilityUsageFile, userName, FieldLockStatus.Unknown, _applyMapping);
                    FieldHistoryManager.FieldValueInsert(aid, TrackedField.FutureICapEffectiveDate, futureICapEffectiveDate ?? "", null, FieldUpdateSources.UtilityUsageFile, userName, FieldLockStatus.Unknown, _applyMapping);
                    FieldHistoryManager.FieldValueInsert(aid, TrackedField.FutureTCapEffectiveDate, futureTCapEffectiveDate ?? "", null, FieldUpdateSources.UtilityUsageFile, userName, FieldLockStatus.Unknown, _applyMapping);
                    break;
                default:
                    FieldHistoryManager.FieldValueInsert(aid, TrackedField.Zone, zone ?? "", null, FieldUpdateSources.UtilityUsageFile, userName, FieldLockStatus.Unknown, _applyMapping);
                    FieldHistoryManager.FieldValueInsert(aid, TrackedField.Voltage, voltage ?? "", null, FieldUpdateSources.UtilityUsageFile, userName, FieldLockStatus.Unknown, _applyMapping);
                    FieldHistoryManager.FieldValueInsert(aid, TrackedField.LoadShapeID, loadShapeID ?? "", null, FieldUpdateSources.UtilityUsageFile, userName, FieldLockStatus.Unknown, _applyMapping);
                    FieldHistoryManager.FieldValueInsert(aid, TrackedField.ICap, iCap ?? "", null, FieldUpdateSources.UtilityUsageFile, userName, FieldLockStatus.Unknown, _applyMapping);
                    FieldHistoryManager.FieldValueInsert(aid, TrackedField.TCap, tCap ?? "", null, FieldUpdateSources.UtilityUsageFile, userName, FieldLockStatus.Unknown, _applyMapping);
                    FieldHistoryManager.FieldValueInsert(aid, TrackedField.FutureICap, futureICap ?? "", null, FieldUpdateSources.UtilityUsageFile, userName, FieldLockStatus.Unknown, _applyMapping);
                    FieldHistoryManager.FieldValueInsert(aid, TrackedField.FutureTCap, futureTCap ?? "", null, FieldUpdateSources.UtilityUsageFile, userName, FieldLockStatus.Unknown, _applyMapping);
                    FieldHistoryManager.FieldValueInsert(aid, TrackedField.FutureICapEffectiveDate, futureICapEffectiveDate ?? "", null, FieldUpdateSources.UtilityUsageFile, userName, FieldLockStatus.Unknown, _applyMapping);
                    FieldHistoryManager.FieldValueInsert(aid, TrackedField.FutureTCapEffectiveDate, futureTCapEffectiveDate ?? "", null, FieldUpdateSources.UtilityUsageFile, userName, FieldLockStatus.Unknown, _applyMapping);

                    break;
            }


        }
    }

}