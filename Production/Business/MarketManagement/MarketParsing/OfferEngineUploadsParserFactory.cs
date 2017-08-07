using System.Globalization;
using LibertyPower.Business.CommonBusiness.FieldHistory;

namespace LibertyPower.Business.MarketManagement.MarketParsing
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Data;
    using System.Text;
    using System.Text.RegularExpressions;
    using System.Transactions;
    using System.Linq;
    using LibertyPower.Business.CommonBusiness.CommonEntity;
    using LibertyPower.Business.CommonBusiness.CommonRules;
    using LibertyPower.Business.CommonBusiness.FileManager;
    using LibertyPower.DataAccess.CsvAccess.GenericCsv;
    using LibertyPower.DataAccess.ExcelAccess;
    using LibertyPower.DataAccess.WorkbookAccess;
    using LibertyPower.Business.MarketManagement.UtilityManagement;
    using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;

    /// <summary>
    /// Factory for creation of a ParserResult; point of entry for parsing List of Account files
    /// </summary>
    public sealed class OfferEngineUploadsParserFactory
    {
        #region Methods

        internal static ParserResult PackageParserResult(UtilityAccountList utilityAccounts, FileContext fileContext, ParserFileType parserFileType, BrokenRuleException brokenRuleException, bool acceptFile)
        {
            return new ParserResult(utilityAccounts, fileContext, parserFileType, brokenRuleException, acceptFile);
        }

        /// <summary>
        /// Given  a FileManager.FileContext object creates a ParserResult
        /// </summary>
        /// <param name="fileContext"> FileContext of the file to be parsed</param>
        /// <returns>ParserResult object resulting from the parsing of the provided FileContext's file</returns>
        public static ParserResult GetParserResult(FileContext fileContext)
        {
            ParserFileType parserFileType = OfferEngineUploadsParserFactory.DetermineParserFileType(fileContext);
            ParserResult parserResult = null;

            switch (parserFileType)
            {
                case ParserFileType.CustomOfferAccounts:
                    var customLOAparser = new CustomOfferListOfAccountsParser(fileContext);
                    parserResult = customLOAparser.PackageParserResult(true);
                    break;
                case ParserFileType.ErcotUtilityAccounts:
                    ErcotListOfAccountsParser loaParser = new ErcotListOfAccountsParser(fileContext);
                    parserResult = loaParser.PackageParserResult();
                    break;

                case ParserFileType.UsageAep:
                    AepUsageParser aepParser = new AepUsageParser(fileContext);
                    parserResult = aepParser.PackageParserResult();
                    break;

                case ParserFileType.UsageSharyland:
                    SharylandUsageParser sharylandParser = new SharylandUsageParser(fileContext);
                    parserResult = sharylandParser.PackageParserResult();
                    break;

                case ParserFileType.UsageCtpen:
                    CtpenUsageParser ctpenParser = new CtpenUsageParser(fileContext);
                    parserResult = ctpenParser.PackageParserResult();
                    break;

                case ParserFileType.UsageTxnmp:
                    TxnmpUsageParser txnmpParser = new TxnmpUsageParser(fileContext);
                    parserResult = txnmpParser.PackageParserResult();
                    break;

                case ParserFileType.UsageTxu:
                    TxuUsageParser txuParser = new TxuUsageParser(fileContext);
                    parserResult = txuParser.PackageParserResult();
                    break;

                case ParserFileType.UsageTxuSesco:
                    TxuSescoUsageParser txuSescoParser = new TxuSescoUsageParser(fileContext);
                    parserResult = txuSescoParser.PackageParserResult();
                    break;

                case ParserFileType.UsageOncor:
                    OncorUsageParser oncorParser = new OncorUsageParser(fileContext);
                    parserResult = oncorParser.PackageParserResult();
                    break;

                case ParserFileType.UsageSce:
                    SceUsageParser sceParser = new SceUsageParser(fileContext);
                    parserResult = sceParser.PackageParserResult();
                    break;

                case ParserFileType.UsageSdge:
                    SdgeUsageParser sdgeParser = new SdgeUsageParser(fileContext);
                    parserResult = sdgeParser.PackageParserResult();
                    break;

                case ParserFileType.UsagePge:
                    PgeUsageParser pgeUsageParser = new PgeUsageParser(fileContext);
                    parserResult = pgeUsageParser.PackageParserResult();
                    break;

                case ParserFileType.Unknown:
                default:
                    parserResult = OfferEngineUploadsParserFactory.GetParserResultForUnknownFormat(fileContext);
                    break;
            }

            return parserResult;
        }

        internal static ParserResult GetParserResultForUnknownFormat(FileContext fc)
        {
            ParserResult result = new ParserResult(fc, ParserFileType.Unknown, false);
            return result;
        }

        internal static bool ParseDate(string dateString, out DateTime result)
        {
            dateString = dateString.Replace("\"", "").Trim();

            #region check for OLE Automation date format

            bool isNumber = OfferEngineUploadsParserFactory.IsNumber(dateString);

            if (isNumber == true)
            {
                try
                {
                    result = DateTime.FromOADate(double.Parse(dateString));
                    return true;
                }
                catch { }
                result = DateTime.Now;
                return false;
            }

            #endregion

            #region Check for DD$MONTH$YY {"09DEC08", 09DEC08, 1/2/2010}

            string[] months = new string[] { "JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC" };

            for (int i = 0; i < months.Length; i++)
            {
                if (dateString.Contains(months[i]) == true)
                {
                    int month = i + 1;
                    dateString = dateString.Replace(months[i], ",");
                    string[] items = dateString.Split(",".ToCharArray());
                    if (items.Length == 2)
                    {
                        int day = 0;
                        int year = 0;

                        items[0] = items[0].Replace("-", "");
                        items[1] = items[1].Replace("-", "");

                        if (OfferEngineUploadsParserFactory.IsNumber(items[0]) == true && OfferEngineUploadsParserFactory.IsNumber(items[1]) == true)
                        {
                            day = Convert.ToInt16(items[0]);

                            year = Convert.ToInt16(items[1]);

                            if (year > 50 && year < 100)
                                year += 1900;
                            else if (year <= 50)
                                year += 2000;

                            result = new DateTime(year, month, day);
                            return true;
                        }
                    }
                    break;
                }
            }

            #endregion

            #region check for other standard date formats

            return DateTime.TryParse(dateString, out result);

            #endregion

        }

        internal static bool IsNumber(string item)
        {
            bool isNumber = true;

            if (item.Trim().Length == 0)
            {
                isNumber = false;

            }
            else
            {
                int decCount = 0;

                for (int i = 0; i < item.Length; i++)
                {
                    char c = item[i];

                    if (c == '.')
                        decCount++;

                    if ((char.IsDigit(c) == false && c != '.') || decCount > 1)
                    {
                        isNumber = false;
                        break;
                    }
                }
            }
            return isNumber;
        }

        internal static Int32 ConvertToInt32(string buf)
        {
            try
            {
                if (IsNumber(buf))
                {
                    if (buf.Contains(".") == true)
                    {
                        double intermediateValue = System.Convert.ToDouble(buf);
                        Int32 answer = Convert.ToInt32(intermediateValue);
                        return answer;
                    }
                    else
                    {
                        Int32 answer = Convert.ToInt32(buf);
                        return answer;
                    }
                }
                else
                    return 0;
            }
            catch { }
            return 0;
        }

        public static ParserFileType DetermineParserFileType(FileContext context)
        {
            
            ParserFileType answer = ParserFileType.Unknown;
            try
            {
                DataSet ds = null;
                string extension = System.IO.Path.GetExtension(context.FullFilePath).ToLower();
                if (extension == ".csv")
                {
                    ds = GenericCsv.GetDataEx(context.FullFilePath);
                }
                else if (extension == ".xls" || extension == ".xlsx")
                {
                    try
                    {
                        ds = LibertyPower.DataAccess.WorkbookAccess.ExcelAccess.GetWorkbook(context.FullFilePath);
                    }
                    catch (Exception ex)
                    {
                        CommonShared.SimpleLogging.Trace(ex);
                        throw new Exception(ex.Message + " (Note: Excel 95 and older not supported)");
                    }
                }

                if (IsSce(ds))
                    answer = ParserFileType.UsageSce;
                else if (IsSdge(ds))
                    answer = ParserFileType.UsageSdge;
                else if (IsPge(ds))
                    answer = ParserFileType.UsagePge;
                else if (ds.Tables.Contains("USAGE HIST DATA") == true)
                    answer = ParserFileType.UsageAep;
                else if (ds.Tables.Contains("qry_Usage_History") == true)
                    answer = ParserFileType.UsageTxu;
                else if (ds.Tables.Contains("LOA_Detail_Rpt") == true)
                    answer = ParserFileType.UsageTxnmp;
                else if (ds.Tables.Contains("Accounts") == true)
                    answer = ParserFileType.UsageCtpen;
                else if (ds.Tables.Contains("ERCOT_AccountListing") == true) //Changed from AccountListing for Ticket 16453
                    answer = ParserFileType.ErcotUtilityAccounts;
                else if (ds.Tables.Contains("AccountListing") == true) //Changed from AccountListing for Ticket 16453
                    answer = ParserFileType.CustomOfferAccounts;
                else if (ds.Tables.Contains("Page1_1") == true)
                    answer = ParserFileType.UsageOncor;
            }
            catch (Exception exception)
            {
                CommonShared.SimpleLogging.Trace(exception);
                answer = ParserFileType.Unknown;
            }
            return answer;
        }

        private static bool IsSce(DataSet ds)
        {
            if (ds != null && ds.Tables.Count > 0)
            {
                DataTable dt = ds.Tables[0];
                Int32 rowExtent = dt.Rows.Count > 40 ? 40 : dt.Rows.Count;
                Int32 colExtent = dt.Columns.Count > 40 ? 40 : dt.Columns.Count;

                for (int r = 0; r < rowExtent; r++)
                {
                    for (int c = 0; c < colExtent; c++)
                    {
                        string item = dt.Rows[r][c].ToString();

                        if (item.ToUpper().Contains("SOUTHERN CALIFORNIA EDISON"))
                            return true;
                    }
                }
            }
            return false;
        }

        private static bool IsSdge(DataSet ds)
        {
            if (ds != null && ds.Tables.Count > 0)
            {
                DataTable dt = ds.Tables[0];
                Int32 rowExtent = dt.Rows.Count > 40 ? 40 : dt.Rows.Count;
                Int32 colExtent = dt.Columns.Count > 40 ? 40 : dt.Columns.Count;

                for (int r = 0; r < rowExtent; r++)
                {
                    for (int c = 0; c < colExtent; c++)
                    {
                        string item = dt.Rows[r][c].ToString();

                        if (item.ToUpper().Contains("SDG&E"))
                            return true;
                    }
                }
            }

            return false;
        }

        private static bool IsPge(DataSet ds)
        {
            if (ds != null && ds.Tables.Count > 0)
            {
                DataTable dt = ds.Tables[0];



                Int32 rowExtent = dt.Rows.Count > 40 ? 40 : dt.Rows.Count;
                Int32 colExtent = dt.Columns.Count > 40 ? 40 : dt.Columns.Count;

                for (int r = 0; r < rowExtent; r++)
                {
                    for (int c = 0; c < colExtent; c++)
                    {
                        string item = dt.Rows[r][c].ToString();

                        if (r == 0 && c == 0)
                        {
                            if (item.ToLower().StartsWith("said") || item.ToLower().StartsWith("sa_id"))
                                return true;
                        }

                        if (item.ToUpper().Contains("PGE-"))
                            return true;
                    }
                }
            }
            return false;
        }

        internal static ProspectAccountCandidate FindAccount(string accountNumber, UtilityAccountList accounts)
        {
            foreach (ProspectAccountCandidate candidate in accounts)
                if (string.Compare(accountNumber, candidate.AccountNumber) == 0)
                    return candidate;
            return null;
        }

        internal static bool IsRowEmpty(DataRow dr, bool ignoreSpaces)
        {
            foreach (object o in dr.ItemArray)
                if (o != DBNull.Value && o.ToString().Trim().Length > 0)
                    return false;

            return true;
        }

        internal static bool IsRowEmpty(DataRow dr)
        {
            foreach (object o in dr.ItemArray)
                if (o != DBNull.Value)
                    return false;

            return true;
        }

        #region supporting CA

        internal static PgeUsageAccount CreatePgeUsageAccount(string utility, string accountNumber, string customerName,
            string serviceAddress, string serviceCity, string serviceState, string servicePostal,
            string mailAddress, string mailCity, string mailState, string mailPostal,
            string currentRate, string meterNumber, string voltage,
            string energy_service_provider, string mdma, string meter_installer, string meter_maintainer, string meter_owner,
            PgeUsageItemCollection usageItems,string lossFactorId)
        {
            PgeUsageAccount account = null;
            try
            {
                account = new PgeUsageAccount(utility, accountNumber, customerName,
                    serviceAddress, serviceCity, serviceState, servicePostal,
                    mailAddress, mailCity, mailState, mailPostal,
                    currentRate, meterNumber, voltage, energy_service_provider, mdma, meter_installer, meter_maintainer, meter_owner, usageItems,lossFactorId);
            }
            catch (Exception exception)
            {
                CommonShared.SimpleLogging.Trace(exception);
                throw new UsageParserException("Error creating PgeUsageAccount", exception);
            }
            return account;
        }

        internal static PgeUsageItem CreatePgeUsageItem(string readDate, string previousReadDate, string days, string usage, string demand,
            string off_peak_kwh, string part_peak_kwh, string on_peak_kwh)
        {
            PgeUsageItem item = null;
            try
            {
                item = new PgeUsageItem(readDate, previousReadDate, days, usage, demand, off_peak_kwh, part_peak_kwh, on_peak_kwh);
            }
            catch (Exception exception)
            {
                CommonShared.SimpleLogging.Trace(exception);
                throw new UsageParserException("Error creating PgeUsageItem", exception);
            }
            return item;
        }

        internal static SdgeUsageAccount CreateSdgeUsageAccount(string accountName, string acct, string address, string cityStateZip, string customerName, string cycle, string meter, string meterMaintainer, string meterOption, string meterOwner, string meterReader, string meterInstaller, string rate, string serviceVoltage,string lossFactorId)
        {
            return new SdgeUsageAccount(accountName, acct, address, cityStateZip, customerName, cycle, meter, meterMaintainer, meterOption, meterOwner, meterReader, meterInstaller, rate, serviceVoltage,lossFactorId);
        }

        internal static SdgeUsageItem CreateSdgeUsageItem(string consEdDate, string daysUsed, string maxKw, string maxKwNC, string offKw, string offKwh, string onKw, string onKwh, string totalKwh)
        {
            return new SdgeUsageItem(consEdDate, daysUsed, maxKw, maxKwNC, offKw, offKwh, onKw, onKwh, totalKwh);
        }

        internal static SceUsageAccount CreateSceUsageAccount(string utility, string customerAccountNumber, string serviceAccountNumber, string customerName,
            string customerAddress1A, string customerAddress1B, string customerAddress1C,
            string customerAddress2A, string customerAddress2B, string customerAddress2C,
            string currentRate, string meterNumber, string phase, string voltage, SceUsageItemCollection usageItems,string lossFactorId)
        {
            SceUsageAccount account = null;
            try
            {
                account = new SceUsageAccount(utility, customerAccountNumber, serviceAccountNumber, customerName,
                    customerAddress1A, customerAddress1B, customerAddress1C,
                    customerAddress2A, customerAddress2B, customerAddress2C,
                    currentRate, meterNumber, phase, voltage, usageItems,lossFactorId);
            }
            catch (Exception exception)
            {
                CommonShared.SimpleLogging.Trace(exception);
                throw new UsageParserException("Error creating SceUsageAccount", exception);
            }
            return account;
        }

        internal static SceUsageItem CreateSceUsageItem(DateTime startDate, DateTime readDate, Int16 days, decimal totalKWh, decimal maximumKw)
        {
            SceUsageItem item = null;
            try
            {
                item = new SceUsageItem(readDate, days, totalKWh, maximumKw);
            }
            catch (Exception exception)
            {
                CommonShared.SimpleLogging.Trace(exception);
                throw new UsageParserException("Error creating SceUsageItem", exception);
            }
            return item;
        }




        #endregion

        #region supporting ERCOT

        /// <summary>
        /// Parses the Excel file, found at the provided file path, containing a list of accounts.
        /// </summary>
        /// <param name="context">The context (including path) of the Excel file to parse.</param>
        /// <param name="requiredFields">An object encapsulating the minimum message requirements
        /// to construct a UtilityAccount for each UtilityCode.</param>
        /// <returns>A UtilityAccountList resulting from parsing the given Excel file.</returns>
        internal static UtilityAccountList GetUtilityAccountsFromUtilityAccountFile(FileContext context)
        {
            UtilityAccountList accounts = new UtilityAccountList();

            UtilityAccountExcelSchemaRule utilityAccountExcelFormatRule = new UtilityAccountExcelSchemaRule(context);
            if (!utilityAccountExcelFormatRule.Validate())
            {
                throw utilityAccountExcelFormatRule.Exception;
            }

            //Create all accounts possible; will validate separately
            accounts = GetUtilityAccountsFromUtilityAccountFile(utilityAccountExcelFormatRule.Accounts);

            return accounts;
        }

        internal static UtilityAccountList GetUtilityAccountsWithUsagesFromAep(FileContext context)
        {
            UtilityAccountList accounts = new UtilityAccountList();

            UsageAepExcelSchemaRule usageRule = new UsageAepExcelSchemaRule(context);
            if (!usageRule.Validate())
            {
                throw usageRule.Exception;
            }

            //Create all accounts possible; will validate separately
            accounts = GetUtilityAccountsWithUsagesFromAep(usageRule.ImportFileDataSet);

            return accounts;
        }

        internal static UtilityAccountList GetUtilityAccountsWithUsagesFromOncor(FileContext context)
        {
            UtilityAccountList accounts = new UtilityAccountList();

            UsageOncorExcelSchemaRule usageRule = new UsageOncorExcelSchemaRule(context);
            if (!usageRule.Validate())
            {
                throw usageRule.Exception;
            }

            //Create all accounts possible; will validate separately
            accounts = GetUtilityAccountsWithUsagesFromOncor(usageRule.ImportFileDataSet);

            return accounts;
        }

        internal static UtilityAccountList GetUtilityAccountsWithUsagesFromCtpen(FileContext context)
        {
            UtilityAccountList accounts = new UtilityAccountList();

            UsageCtpenExcelSchemaRule usageRule = new UsageCtpenExcelSchemaRule(context);
            if (!usageRule.Validate())
            {
                throw usageRule.Exception;
            }

            // Create all accounts possible; will validate separately
            accounts = GetUtilityAccountsWithUsagesFromCtpen(usageRule.ImportFileDataSet);

            return accounts;
        }

        internal static UtilityAccountList GetUtilityAccountsWithUsagesFromSharyland(FileContext context)
        {
            UtilityAccountList accounts = new UtilityAccountList();

            UsageAepExcelSchemaRule usageRule = new UsageAepExcelSchemaRule(context);
            if (!usageRule.Validate())
            {
                throw usageRule.Exception;
            }

            //Create all accounts possible; will validate separately
            accounts = GetUtilityAccountsWithUsagesFromAep(usageRule.ImportFileDataSet);

            return accounts;
        }

        internal static UtilityAccountList GetUtilityAccountsWithUsagesFromTxnmp(FileContext context)
        {
            UtilityAccountList accounts = new UtilityAccountList();
            UsageTxnmpExcelSchemaRule usageRule = new UsageTxnmpExcelSchemaRule(context);
            if (!usageRule.Validate())
            {
                throw usageRule.Exception;
            }

            //Create all accounts possible; will validate separately
            accounts = GetUtilityAccountsWithUsagesFromTxnmp(usageRule.ImportFileDataSet);

            return accounts;
        }

        internal static UtilityAccountList GetUtilityAccountsWithUsagesFromTxnmp(DataSet ds)
        {
            UtilityAccountList accounts = new UtilityAccountList();

            UtilityDictionary utilities = UtilityStandInFactory.GetUtilities();

            for (int i = 0; i < ds.Tables.Count; i++)
            {
                DataTable dt = ds.Tables[i];

                #region  Find most recent row to base account on

                DataRow accountRow = dt.Rows[0];

                string mostRecentBuf = DateTime.MinValue.ToShortDateString();

                if (dt.Rows[0]["END_DATE"] != DBNull.Value)
                    mostRecentBuf = dt.Rows[0]["END_DATE"].ToString();

                DateTime endDate = DateTime.Parse(mostRecentBuf);

                for (int ii = 1; ii < dt.Rows.Count; ii++)
                {
                    if (dt.Rows[ii]["END_DATE"] != DBNull.Value)
                        mostRecentBuf = dt.Rows[ii]["END_DATE"].ToString();
                    else
                        mostRecentBuf = DateTime.MinValue.ToShortDateString();

                    DateTime dateBuf = DateTime.Parse(mostRecentBuf);

                    if (dateBuf > endDate)
                    {
                        accountRow = dt.Rows[ii];
                        endDate = dateBuf;
                    }
                }
                #endregion

                #region get account level fields

                int excelRow = 0;

                if (accountRow["Excel Row"] != DBNull.Value)
                    excelRow = Convert.ToInt16((string)accountRow["Excel Row"]);

                ProspectAccountCandidate utilityAccount = ProspectAccountCandidateFactory.GetProspectAccountCandidate(excelRow);

                accounts.Add(utilityAccount);

                string accountNumber = null;

                if (accountRow["ESI_ID"] != DBNull.Value)
                    accountNumber = (string)accountRow["ESI_ID"];
                // Added By Vikas Sharma . PBI -119136. Added Loss Factor Id

                if (accountRow["Loss Factor ID"] != DBNull.Value)
                    utilityAccount.LossFactorID = (string)accountRow["Loss Factor ID"];

                if (accountNumber != null)
                    utilityAccount.AccountNumber = accountNumber.Replace("ESIID", "");

                Utility util = DetermineUtilityFromAccountNumber.GetTexasUtilitiesBestMatchingAccountNumber(utilityAccount.AccountNumber, utilities);

                utilityAccount.UtilityCode = util.Code;

                if (accountRow["CUSTOMER_NAME"] != DBNull.Value)
                    utilityAccount.CustomerName = (string)accountRow["CUSTOMER_NAME"];

                UsGeographicalAddress serviceAddress = null;

                // Add the street if it exists.
                if (accountRow["STREETADDRESS1"] != DBNull.Value)
                {
                    if (serviceAddress == null)
                        serviceAddress = new UsGeographicalAddress();
                    serviceAddress.Street = accountRow["STREETADDRESS1"].ToString();
                }

                // Add the zip code if it exists.
                if (accountRow["STREETADDRESS3"] != DBNull.Value)
                {
                    if (serviceAddress == null)
                        serviceAddress = new UsGeographicalAddress();
                    serviceAddress.ZipCode = ExtractZip(accountRow["STREETADDRESS3"].ToString());
                }

                // Add the city if it exists.
                if (accountRow["STREETADDRESS3"] != DBNull.Value)
                {
                    if (serviceAddress == null)
                        serviceAddress = new UsGeographicalAddress();
                    serviceAddress.CityName = ExtractCity(accountRow["STREETADDRESS3"].ToString());
                }

                // Add the state if it exists.
                if (accountRow["STREETADDRESS3"] != DBNull.Value)
                {
                    if (serviceAddress == null)
                        serviceAddress = new UsGeographicalAddress();
                    serviceAddress.StateCode = ExtractState(accountRow["STREETADDRESS3"].ToString());
                    serviceAddress.ProvinceCode = serviceAddress.StateCode;
                    serviceAddress.State = serviceAddress.StateCode;
                }

                // Add the retail market.
                if (accountRow["STREETADDRESS3"] != DBNull.Value)
                {
                    utilityAccount.RetailMarketCode = ExtractState(accountRow["STREETADDRESS3"].ToString());
                }

                if (serviceAddress != null)
                    utilityAccount.ServiceAddress = serviceAddress;

                if (accountRow["RATE_CODE"] != DBNull.Value)
                    utilityAccount.RateClass = (string)accountRow["RATE_CODE"];
                if (accountRow["METERREADCYCLE"] != DBNull.Value)
                    utilityAccount.MeterReadCycleId = (string)accountRow["METERREADCYCLE"];

                if (accountRow["LOAD_PROFILE"] != DBNull.Value)
                {
                    string lsid = (string)accountRow["LOAD_PROFILE"];
                    utilityAccount.LoadProfile = lsid;
                    utilityAccount.LoadShapeId = ExtractLoadShapeID(lsid);
                }

                #endregion

                #region get usage fields
                foreach (DataRow dr in dt.Rows)
                {
                    if (dr["Excel Row"] != DBNull.Value)
                        excelRow = Convert.ToInt16((string)dr["Excel Row"]);
                    UsageCandidate usage = UsageCandidateFactory.GetUsageCandidate(excelRow);

                    usage.AccountNumber = utilityAccount.AccountNumber;
                    usage.UtilityCode = utilityAccount.UtilityCode;
                    usage.UsageType = UsageType.File;
                    usage.UsageSource = UsageSource.User;

                    string startBuf = DateTime.MinValue.ToShortDateString();
                    string endBuf = DateTime.MinValue.ToShortDateString();

                    if (dr["START_DATE"] != DBNull.Value)
                        startBuf = (string)dr["START_DATE"];

                    if (dr["START_DATE"] != DBNull.Value)
                        endBuf = (string)dr["END_DATE"];

                    DateTime start = DateTime.Parse(startBuf);
                    DateTime end = DateTime.Parse(endBuf);

                    usage.BeginDate = new DateTime(start.Year, start.Month, start.Day, start.Hour, start.Minute, 0);
                    usage.EndDate = new DateTime(end.Year, end.Month, end.Day, end.Hour, end.Minute, 0);

                    usage.Days = ((TimeSpan)(end - start)).Days;

                    utilityAccount.Usages.Add(end, usage);

                    string meteredKw = dr["METERED_KW"] == DBNull.Value ? "" : (string)dr["METERED_KW"];
                    string actualKwH = dr["ACTUAL_KWH"] == DBNull.Value ? "" : (string)dr["ACTUAL_KWH"];
                    string billedKw = dr["BILLED_KW"] == DBNull.Value ? "" : (string)dr["BILLED_KW"];
                    string tdspCharges = dr["TDSPCHARGES"] == DBNull.Value ? "" : (string)dr["TDSPCHARGES"];

                    usage.BillingDemandKw = meteredKw == "" ? null : (decimal?)Convert.ToDecimal(meteredKw);
                    usage.TotalKwh = IsNumber(actualKwH) ? Convert.ToInt32(Convert.ToDecimal(actualKwH)) : 0;
                    //					usage.TdspCharges = tdspCharges == "" ? null : (decimal?)Convert.ToDecimal(tdspCharges);

                }
                #endregion
            }

            return accounts;
        }

        internal static UtilityAccountList GetUtilityAccountsWithUsagesFromTxu(FileContext context)
        {
            UtilityAccountList accounts = new UtilityAccountList();
            UsageTxuExcelSchemaRule usageRule = new UsageTxuExcelSchemaRule(context);
            if (!usageRule.Validate())
            {
                throw usageRule.Exception;
            }

            //Create all accounts possible; will validate separately
            accounts = GetUtilityAccountsWithUsagesFromTxu(usageRule.ImportFileDataSet);

            return accounts;
        }

        internal static UtilityAccountList GetUtilityAccountsWithUsagesFromTxu(DataSet ds)
        {
            UtilityAccountList accounts = new UtilityAccountList();
            ProspectAccountCandidate account = null;
            UtilityDictionary utilities = UtilityStandInFactory.GetUtilities();
            DataTable dt = ds.Tables["qry_Usage_History"];
            //Add excel row value as a column before we split sheet
            int excelRow = 0;
            dt.Columns.Add(new DataColumn("Excel Row", excelRow.GetType()));
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                excelRow = i + 2;
                dt.Rows[i]["Excel Row"] = excelRow;
            }
            // Buffer rows representing a UtilityAccount in a Row Collections
            // and parse them as a collection
            List<DataRow> rows = new List<DataRow>();

            rows.Add(dt.Rows[0]); //begin the 1st collection
            string accountNumber = rows[0]["ESI ID"].ToString();
            //process rows in collection to retrieve usages
            for (int i = 1; i < dt.Rows.Count; i++)
            {
                if (IsRowEmpty(dt.Rows[i]) == false)
                {
                    string nextAccountNumber = dt.Rows[i]["ESI ID"].ToString();

                    if (i == dt.Rows.Count - 1)
                    {
                        rows.Add(dt.Rows[i]); //add the final row
                        account = GetUtilityAccountAndUsagesTxu(rows, utilities);
                        if (account != null)
                            accounts.Add(account);
                    }
                    else if (string.Compare(accountNumber, nextAccountNumber) != 0)
                    {

                        accountNumber = nextAccountNumber; //to begin the next group

                        account = GetUtilityAccountAndUsagesTxu(rows, utilities);

                        if (account != null)
                            accounts.Add(account);

                        //clear the collection for the next account and start it with the current row
                        rows.Clear();
                        rows.Add(dt.Rows[i]); //build the collection
                    }
                    else
                    {
                        rows.Add(dt.Rows[i]); //build the collection
                    }
                }
            }

            return accounts;
        }

        internal static UtilityAccountList GetUtilityAccountsWithUsagesFromTxuSesco(FileContext context)
        {
            UtilityAccountList accounts = new UtilityAccountList();
            UsageTxuExcelSchemaRule usageRule = new UsageTxuExcelSchemaRule(context);
            if (!usageRule.Validate())
            {
                throw usageRule.Exception;
            }

            //Create all accounts possible; will validate separately
            accounts = GetUtilityAccountsWithUsagesFromTxu(usageRule.ImportFileDataSet);

            return accounts;
        }

        internal static UtilityAccountList GetUtilityAccountsWithUsagesFromTxuSesco(DataSet ds)
        {
            UtilityAccountList accounts = new UtilityAccountList();
            ProspectAccountCandidate account = null;
            UtilityDictionary utilities = UtilityStandInFactory.GetUtilities();
            DataTable dt = ds.Tables["qry_Usage_History"];
            //Add excel row value as a column before we split sheet
            int excelRow = 0;
            dt.Columns.Add(new DataColumn("Excel Row", excelRow.GetType()));
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                excelRow = i + 2;
                dt.Rows[i]["Excel Row"] = excelRow;
            }
            // Buffer rows representing a UtilityAccount in a Row Collections
            // and parse them as a collection
            List<DataRow> rows = new List<DataRow>();

            rows.Add(dt.Rows[0]); //begin the 1st collection
            string accountNumber = rows[0]["ESI ID"].ToString();
            //process rows in collection to retrieve usages
            for (int i = 1; i < dt.Rows.Count; i++)
            {
                if (IsRowEmpty(dt.Rows[i]) == false)
                {
                    string nextAccountNumber = dt.Rows[i]["ESI ID"].ToString();

                    if (i == dt.Rows.Count - 1)
                    {
                        rows.Add(dt.Rows[i]); //add the final row
                        account = GetUtilityAccountAndUsagesTxu(rows, utilities);
                        if (account != null)
                            accounts.Add(account);
                    }
                    else if (string.Compare(accountNumber, nextAccountNumber) != 0)
                    {

                        accountNumber = nextAccountNumber; //to begin the next group

                        account = GetUtilityAccountAndUsagesTxu(rows, utilities);

                        if (account != null)
                            accounts.Add(account);

                        //clear the collection for the next account and start it with the current row
                        rows.Clear();
                        rows.Add(dt.Rows[i]); //build the collection
                    }
                    else
                    {
                        rows.Add(dt.Rows[i]); //build the collection
                    }
                }
            }

            return accounts;
        }

        private static string ExtractCity(string buf)
        {
            Regex rgx = new Regex("tx");

            string data = buf.ToLower();
            string[] results = rgx.Split(data);
            return results[0];
        }

        private static string ExtractLoadShapeID(string loadProfile)
        {
            string answer = "";
            string[] parts = loadProfile.Trim().Split("_".ToCharArray());
            if (parts.Length > 1)
            {
                answer = string.Format("{0}_{1}", parts[0], parts[1]);
            }
            return answer;
        }

        private static string ExtractState(string buf)
        {
            //for now all utilities use TX for the state.
            //Add code later to retrieve the 2 letters that are not commas and not whitespace
            //and are in front of the zipcode.
            return "TX";
        }

        private static string ExtractZip(string buf)
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

        /// <summary>
        /// Gets a new UtilityAccount if the minimum constructor is satisfied (an account number) 
        /// </summary>
        /// <param name="dr"></param>
        /// <returns> A UtilityAccountList containing the UtilityAccount and any broken rule exceptions</returns>
        /// <exception cref="MissingAccountListingColumnException">Creates an account so long as an account number is available; validation is handled elsewhere</exception>
        private static ProspectAccountCandidate GetUtilityAccount(DataRow dr, int excelRowNumber)
        {
            ProspectAccountCandidate account = ProspectAccountCandidateFactory.GetProspectAccountCandidate(excelRowNumber);

            if (dr["Utility"] != DBNull.Value)
                account.UtilityCode = dr["Utility"].ToString();

            //Added By Vikas Sharma PBI 119136. Added LossFactorId

            if (dr["Loss Factor ID"] != DBNull.Value)
                account.LossFactorID = Convert.ToString(dr["Loss Factor ID"]);

            // Before getting here guarantee that there is a value in row["Utility"] AND that it exists as a known value
            // we have the minimum to construct an account and continue, even if the Account Number is invalid, it will be caught at validation

            if (dr["Utility"] != DBNull.Value)
            {
                //GET just Prefix portion if long description is appended
                string buf = (dr["Utility"].ToString()).Split(" ".ToCharArray())[0];
                account.UtilityCode = buf;
            }

            if (dr["Account Number"] != DBNull.Value)
                account.AccountNumber = dr["Account Number"].ToString();

            // Add the meter number if it exists.
            // TODO: which meter type is it?
            if (dr["Meter Number"] != DBNull.Value)
				account.AddMeter( dr["Meter Number"].ToString(), UtilityManagement.MeterType.Unmetered );

            UsGeographicalAddress serviceAddress = null;
            // Add the zip code if it exists.
            if (dr["Zip"] != DBNull.Value)
            {
                if (serviceAddress == null)
                    serviceAddress = new UsGeographicalAddress();
                serviceAddress.ZipCode = dr["Zip"].ToString();
            }

            // Add the street if it exists.
            if (dr["Street"] != DBNull.Value)
            {
                if (serviceAddress == null)
                    serviceAddress = new UsGeographicalAddress();
                serviceAddress.Street = dr["Street"].ToString();
            }

            // Add the city if it exists.
            if (dr["City"] != DBNull.Value)
            {
                if (serviceAddress == null)
                    serviceAddress = new UsGeographicalAddress();
                serviceAddress.CityName = dr["City"].ToString();
            }

            // Add the state if it exists.
            if (dr["State"] != DBNull.Value)
            {
                if (serviceAddress == null)
                    serviceAddress = new UsGeographicalAddress();
                serviceAddress.StateCode = dr["State"].ToString();
                serviceAddress.ProvinceCode = dr["State"].ToString();
                serviceAddress.State = serviceAddress.StateCode;
            }

            // Add the country if it exists.
            if (dr["Country"] != DBNull.Value)
            {
                if (serviceAddress == null)
                    serviceAddress = new UsGeographicalAddress();
                serviceAddress.CountryName = dr["Country"].ToString();
            }

            ////////////////////////////////////////////////////////////////////////
            //add billing address and all fields here

            UsGeographicalAddress billingAddress = null;
            // Add the zip code if it exists.
            if (dr["Billing Zip"] != DBNull.Value)
            {
                if (billingAddress == null)
                    billingAddress = new UsGeographicalAddress();
                billingAddress.ZipCode = dr["Billing Zip"].ToString();
            }

            // Add the street if it exists.
            if (dr["Billing Street"] != DBNull.Value)
            {
                if (billingAddress == null)
                    billingAddress = new UsGeographicalAddress();
                billingAddress.Street = dr["Billing Street"].ToString();
            }

            // Add the city if it exists.
            if (dr["Billing City"] != DBNull.Value)
            {
                if (billingAddress == null)
                    billingAddress = new UsGeographicalAddress();
                billingAddress.CityName = dr["Billing City"].ToString();
            }

            // Add the state if it exists.
            if (dr["Billing State"] != DBNull.Value)
            {
                if (billingAddress == null)
                    billingAddress = new UsGeographicalAddress();
                billingAddress.StateCode = dr["Billing State"].ToString();
                billingAddress.ProvinceCode = dr["Billing State"].ToString();
                billingAddress.State = billingAddress.StateCode;
            }

            // Add the country if it exists.
            if (dr["Billing Country"] != DBNull.Value)
            {
                if (billingAddress == null)
                    billingAddress = new UsGeographicalAddress();
                billingAddress.CountryName = dr["Billing Country"].ToString();
            }
            ////////////////////////////////////////////////////////////////////////

            // Add the retail market.
            if (dr["Market"] != DBNull.Value)
            {
                account.RetailMarketCode = dr["Market"].ToString();
            }

            if (dr["Name Key"] != DBNull.Value)
                account.NameKey = dr["Name Key"].ToString();

            if (dr["Billing Account"] != DBNull.Value)
                account.BillingAccount = dr["Billing Account"].ToString();

            if (billingAddress != null)
                account.BillingAddress = billingAddress;

            if (serviceAddress != null)
                account.ServiceAddress = serviceAddress;

            return account;
        }

        private static ProspectAccountCandidate GetCustomOfferUtilityAccount(DataRow dr, int excelRowNumber)
        {
            ProspectAccountCandidate account = ProspectAccountCandidateFactory.GetProspectAccountCandidate(excelRowNumber);



            // Before getting here guarantee that there is a value in row["Utility"] AND that it exists as a known value
            // we have the minimum to construct an account and continue, even if the Account Number is invalid, it will be caught at validation

            if (dr["Account Number"] != DBNull.Value)
                account.AccountNumber = dr["Account Number"].ToString();

            //Added By Vikas Sharma PBI 119136. Added LossFactorId

            if (dr["Loss Factor ID"] != DBNull.Value)
                account.LossFactorID = Convert.ToString(dr["Loss Factor ID"]);

            // Add the retail market.
            if (dr["Market"] != DBNull.Value)
            {
                account.RetailMarketCode = dr["Market"].ToString();
            }

            if (dr["Utility"] != DBNull.Value)
                account.UtilityCode = dr["Utility"].ToString();

            // Add the meter number if it exists, default it to the AccountNumber otherwise
            if (dr["Meter Number"] != DBNull.Value)
            {
                if (account.Meters == null)
                {
                    account.Meters = new MeterList();
					account.AddMeter( dr["Meter Number"].ToString(), UtilityManagement.MeterType.Unknown );
                }
                else
                {
                    var buf = dr["Meter Number"].ToString();
                    var meter = account.Meters.FirstOrDefault(s => s.MeterNumber.Equals(buf));
                    if (meter == null)
                    {
						account.AddMeter( dr["Meter Number"].ToString(), UtilityManagement.MeterType.Unknown );
                    }
                }

            }
            else
            {
                if (account.Meters == null)
                {
                    account.Meters = new MeterList();
					account.AddMeter( account.AccountNumber, UtilityManagement.MeterType.Unknown );
                }
                else
                {
                    var buf = account.AccountNumber;
                    var meter = account.Meters.FirstOrDefault(s => s.MeterNumber.Equals(buf));
                    if (meter == null)
                    {
						account.AddMeter( account.AccountNumber, UtilityManagement.MeterType.Unknown );
                    }
                }

            }

            if (dr["Meter Type"] != DBNull.Value)
            {
                var meterTypeBuf = dr["Meter Type"].ToString().ToUpper().Replace("-", "");
				var meterType = UtilityManagement.MeterType.Unknown;
                if (meterTypeBuf.Equals("IDR"))
					meterType = UtilityManagement.MeterType.Idr;
                else if (meterTypeBuf.Equals("NONIDR"))
					meterType = UtilityManagement.MeterType.NonIdr;

				if( meterType != UtilityManagement.MeterType.Unknown )
                {
                    if (account.Meters == null)
                    {
                        account.Meters = new MeterList();
                        account.Meters.Add(new Meter(account.AccountNumber, meterType));
                    }
                    else if (account.Meters.Count == 0)
                    {
                        account.Meters.Add(new Meter(account.AccountNumber, meterType));
                    }
                    else
                    {
                        account.Meters[0].MeterType = meterType;
                    }

                }
            }

            if (dr["Voltage"] != DBNull.Value)
                account.Voltage = dr["Voltage"].ToString();

            UsGeographicalAddress serviceAddress = null;

            // Add the street if it exists.
            if (dr["Address"] != DBNull.Value)
            {
                if (serviceAddress == null)
                    serviceAddress = new UsGeographicalAddress();
                serviceAddress.Street = dr["Address"].ToString();
            }

            // Add the street if it exists.
            if (dr["Suite"] != DBNull.Value)
            {
                if (serviceAddress == null)
                    serviceAddress = new UsGeographicalAddress();
                serviceAddress.Street += string.Concat("Suite: ", dr["Suite"].ToString());
            }
            // Add the city if it exists.
            if (dr["City"] != DBNull.Value)
            {
                if (serviceAddress == null)
                    serviceAddress = new UsGeographicalAddress();
                serviceAddress.CityName = dr["City"].ToString();
            }

            // Add the state if it exists.
            if (dr["State"] != DBNull.Value)
            {
                if (serviceAddress == null)
                    serviceAddress = new UsGeographicalAddress();
                serviceAddress.StateCode = dr["State"].ToString();
                serviceAddress.ProvinceCode = dr["State"].ToString();
                serviceAddress.State = serviceAddress.StateCode;
            }

            // Add the zip code if it exists.
            if (dr["Zip"] != DBNull.Value)
            {
                if (serviceAddress == null)
                    serviceAddress = new UsGeographicalAddress();
                serviceAddress.ZipCode = dr["Zip"].ToString();
                serviceAddress.PostalCode = dr["Zip"].ToString();
            }

            if (serviceAddress != null)
                account.ServiceAddress = serviceAddress;
            ////////////////////////////////////////////////////////////////////////

            if (dr["Congestion Zone"] != DBNull.Value)
                account.ZoneCode = dr["Congestion Zone"].ToString();

            if (dr["ICAP"] != DBNull.Value)
            {
                decimal icapBuf;
                if (decimal.TryParse(dr["ICAP"].ToString(), out icapBuf))
                    account.Icap = icapBuf;

            }

            if (dr["TCAP"] != DBNull.Value)
            {
                decimal tcapBuf;
                if (decimal.TryParse(dr["TCAP"].ToString(), out tcapBuf))
                    account.Tcap = tcapBuf;

            }

            if (dr["Loss Factor"] != DBNull.Value)
            {
                decimal lfBuf;
                if (decimal.TryParse(dr["Loss Factor"].ToString(), out lfBuf))
                    account.LossFactor = lfBuf;
            }

            if (dr["Load Shape ID"] != DBNull.Value)
                account.LoadShapeId = dr["Load Shape ID"].ToString();

            if (dr["Rate Class"] != DBNull.Value)
                account.RateClass = dr["Rate Class"].ToString();

            if (dr["Name Key"] != DBNull.Value)
                account.NameKey = dr["Name Key"].ToString();

            if (dr["Billing Account"] != DBNull.Value)
                account.BillingAccount = dr["Billing Account"].ToString();

            if (dr["Tariff Code"] != DBNull.Value)
                account.TariffCode = dr["Tariff Code"].ToString();

            if (dr["Load Profile"] != DBNull.Value)
                account.LoadProfile = dr["Load Profile"].ToString();

            if (dr["Grid"] != DBNull.Value)
                account.Grid = dr["Grid"].ToString();

            if (dr["LBMP Zone"] != DBNull.Value)
                account.LBMPZone = dr["LBMP Zone"].ToString();

            if (dr["Service Class"] != DBNull.Value)
                account.ServiceClass = dr["Service Class"].ToString();

            if (dr.Table.Columns.Contains("Future Icap"))
            {

                if (dr["Future ICAP"] != DBNull.Value)
                {
                    decimal ficapBuf;
                    if (decimal.TryParse(dr["Future ICAP"].ToString(), out ficapBuf))
                        account.FutureIcap = ficapBuf;
                }

                if (dr["Future ICAP Effective Date"] != DBNull.Value)
                {
                    DateTime ficapBuf;
                    if (DateTime.TryParse(dr["Future ICAP Effective Date"].ToString(), out ficapBuf))
                        account.FutureIcapEffectiveDate = ficapBuf;
                }

                if (dr["Future TCAP"] != DBNull.Value)
                {
                    decimal ftcapBuf;
                    if (decimal.TryParse(dr["Future TCAP"].ToString(), out ftcapBuf))
                        account.FutureTcap = ftcapBuf;

                }

                if (dr["Future TCAP Effective Date"] != DBNull.Value)
                {
                    DateTime ftcapBuf;
                    if (DateTime.TryParse(dr["Future TCAP Effective Date"].ToString(), out ftcapBuf))
                        account.FutureTcapEffectiveDate = ftcapBuf;
                }

                if (dr["Lock Meter Type"] != DBNull.Value)
                {
                    if (dr["Lock Meter Type"].ToString().Equals("UNLOCK"))
                        account.LockMeterType = FieldLockStatus.Unlocked;
                    else
                        account.LockMeterType = FieldLockStatus.Locked;
                }

                if (dr["Lock Voltage"] != DBNull.Value)
                {
                    if (dr["Lock Voltage"].ToString().Equals("UNLOCK"))
                        account.LockVoltage = FieldLockStatus.Unlocked;
                    else
                        account.LockVoltage = FieldLockStatus.Locked;
                }

                if (dr["Lock Congestion Zone"] != DBNull.Value)
                {
                    if (dr["Lock Congestion Zone"].ToString().Equals("UNLOCK"))
                        account.LockCongestionZone = FieldLockStatus.Unlocked;
                    else
                        account.LockCongestionZone = FieldLockStatus.Locked;
                }

                if (dr["Lock ICAP"] != DBNull.Value)
                {
                    if (dr["Lock ICAP"].ToString().Equals("UNLOCK"))
                        account.LockIcap = FieldLockStatus.Unlocked;
                    else
                        account.LockIcap = FieldLockStatus.Locked;
                }

                if (dr["Lock Future ICAP"] != DBNull.Value)
                {
                    if (dr["Lock Future Icap"].ToString().Equals("UNLOCK"))
                        account.LockFutureIcap = FieldLockStatus.Unlocked;
                    else
                        account.LockFutureIcap = FieldLockStatus.Locked;
                }

                if (dr["Lock TCAP"] != DBNull.Value)
                {
                    if (dr["Lock TCAP"].ToString().Equals("UNLOCK"))
                        account.LockTcap = FieldLockStatus.Unlocked;
                    else
                        account.LockTcap = FieldLockStatus.Locked;
                }

                if (dr["Lock Future TCAP"] != DBNull.Value)
                {
                    if (dr["Lock Future Tcap"].ToString().Equals("UNLOCK"))
                        account.LockFutureTcap = FieldLockStatus.Unlocked;
                    else
                        account.LockFutureTcap = FieldLockStatus.Locked;
                }


                if (dr["Lock Loss Factor"] != DBNull.Value)
                {
                    if (dr["Lock Loss Factor"].ToString().Equals("UNLOCK"))
                        account.LockLossFactor = FieldLockStatus.Unlocked;
                    else
                        account.LockLossFactor = FieldLockStatus.Locked;
                }

                if (dr["Lock Load Shape ID"] != DBNull.Value)
                {
                    if (dr["Lock Load Shape ID"].ToString().Equals("UNLOCK"))
                        account.LockLoadShapeId = FieldLockStatus.Unlocked;
                    else
                        account.LockLoadShapeId = FieldLockStatus.Locked;
                }

                if (dr["Lock Rate Class"] != DBNull.Value)
                {
                    if (dr["Lock Rate Class"].ToString().Equals("UNLOCK"))
                        account.LockRateClass = FieldLockStatus.Unlocked;
                    else
                        account.LockRateClass = FieldLockStatus.Locked;
                }

                if (dr["Lock Tariff Code"] != DBNull.Value)
                {
                    if (dr["Lock Tariff Code"].ToString().Equals("UNLOCK"))
                        account.LockTariffCode = FieldLockStatus.Unlocked;
                    else
                        account.LockTariffCode = FieldLockStatus.Locked;
                }

                if (dr["Lock Profile"] != DBNull.Value)
                {
                    if (dr["Lock Profile"].ToString().Equals("UNLOCK"))
                        account.LockProfile = FieldLockStatus.Unlocked;
                    else
                        account.LockProfile = FieldLockStatus.Locked;
                }

                if (dr["Lock Grid"] != DBNull.Value)
                {
                    if (dr["Lock Grid"].ToString().Equals("UNLOCK"))
                        account.LockGrid = FieldLockStatus.Unlocked;
                    else
                        account.LockGrid = FieldLockStatus.Locked;
                }

                if (dr["Lock LBMP Zone"] != DBNull.Value)
                {
                    if (dr["Lock LBMP Zone"].ToString().Equals("UNLOCK"))
                        account.LockLbmpZone = FieldLockStatus.Unlocked;
                    else
                        account.LockLbmpZone = FieldLockStatus.Locked;
                }

                if (dr["Lock Service Class"] != DBNull.Value)
                {
                    if (dr["Lock Service Class"].ToString().Equals("UNLOCK"))
                        account.LockServiceClass = FieldLockStatus.Unlocked;
                    else
                        account.LockServiceClass = FieldLockStatus.Locked;
                }
            }
            return account;
        }

        private static int FindMostRecentRowToBaseAccountOn(List<DataRow> rows)
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

        private static ProspectAccountCandidate GetUtilityAccountAndUsagesAep(List<DataRow> rows, UtilityDictionary utilities)
        {
            // Parse an account and usages from the collection
            ProspectAccountCandidate utilityAccount = null;

            int accountRowIndex = FindMostRecentRowToBaseAccountOn(rows);

            #region Create Account and Populate

            DataRow accountRow = rows[accountRowIndex];
            int excelRow = 0;

            if (accountRow["Excel Row"] != DBNull.Value)
                excelRow = (int)accountRow["Excel Row"];

            utilityAccount = ProspectAccountCandidateFactory.GetProspectAccountCandidate(excelRow);

            if (accountRow["ESI ID"] != DBNull.Value)
                utilityAccount.AccountNumber = (string)accountRow["ESI ID"].ToString().Replace("'", ""); ;

            UtilityList utils = DetermineUtilityFromAccountNumber.GetTexasUtilitiesMatchingAccountNumber(utilityAccount.AccountNumber, utilities);

            if (utils != null && utils.Count == 1)
                utilityAccount.UtilityCode = utils[0].Code;

            if (accountRow["Customer Name"] != DBNull.Value)
                utilityAccount.CustomerName = (string)accountRow["Customer Name"];

            //Added By Vikas Sharma PBI 119136. Added LossFactorId

            if (accountRow["Loss Factor ID"] != DBNull.Value)
                utilityAccount.LossFactorID = Convert.ToString(accountRow["Loss Factor ID"]);

            if (accountRow["Rate Class/Code"] != DBNull.Value)
                utilityAccount.RateClass = (string)accountRow["Rate Class/Code"];

            if (accountRow["Meter Read Cycle"] != DBNull.Value)
                utilityAccount.MeterReadCycleId = (string)accountRow["Meter Read Cycle"];

            if (accountRow["Load Profile"] != DBNull.Value)
            {
                string lsid = (string)accountRow["Load Profile"];
                utilityAccount.LoadProfile = lsid;
                utilityAccount.LoadShapeId = ExtractLoadShapeID(lsid);
            }

            UsGeographicalAddress serviceAddress = null;

            // Add the Street if it exists.
            if (accountRow["Service Address 1"] != DBNull.Value)
            {
                if (serviceAddress == null)
                    serviceAddress = new UsGeographicalAddress();
                serviceAddress.Street = accountRow["Service Address 1"].ToString();
            }

            // Add the zip code if it exists.
            if (accountRow["Service Address 3"] != DBNull.Value)
            {
                if (serviceAddress == null)
                    serviceAddress = new UsGeographicalAddress();
                serviceAddress.ZipCode = ExtractZip(accountRow["Service Address 3"].ToString());
            }

            // Add the city if it exists.
            if (accountRow["Service Address 3"] != DBNull.Value)
            {
                if (serviceAddress == null)
                    serviceAddress = new UsGeographicalAddress();
                serviceAddress.CityName = ExtractCity(accountRow["Service Address 3"].ToString());
            }

            // Add the state if it exists.
            if (accountRow["Service Address 3"] != DBNull.Value)
            {
                if (serviceAddress == null)
                    serviceAddress = new UsGeographicalAddress();
                serviceAddress.StateCode = ExtractState(accountRow["Service Address 3"].ToString());
                serviceAddress.ProvinceCode = serviceAddress.StateCode;
                serviceAddress.State = serviceAddress.StateCode;
            }

            // Add the retail market.
            if (accountRow["Service Address 3"] != DBNull.Value)
            {
                utilityAccount.RetailMarketCode = ExtractState(accountRow["Service Address 3"].ToString());
            }

            if (serviceAddress != null)
                utilityAccount.ServiceAddress = serviceAddress;
            #endregion

            #region Create a usage from each row and add to account

            foreach (DataRow row in rows)
            {
                if (row["Excel Row"] != DBNull.Value)
                {
                    excelRow = (int)row["Excel Row"];
                }

                UsageCandidate usage = UsageCandidateFactory.GetUsageCandidate(excelRow);

                if (row["ESI ID"] != DBNull.Value)
                {
                    usage.AccountNumber = row["ESI ID"].ToString();
                }


                DateTime? start = ConvertToDate(row["Start Date"].ToString());
                if (start == null)
                {
                    start = DateTime.MinValue;
                }

                DateTime? end = ConvertToDate(row["End Date"].ToString());
                if (end == null)
                {
                    end = DateTime.MinValue;
                }

                usage.BeginDate = new DateTime(start.Value.Year, start.Value.Month, start.Value.Day, start.Value.Hour, start.Value.Minute, 0);
                usage.EndDate = new DateTime(end.Value.Year, end.Value.Month, end.Value.Day, end.Value.Hour, end.Value.Minute, 0);
                usage.Days = ((TimeSpan)(end - start)).Days;


                double meteredKw = ConvertToDouble(row["Metered KW"].ToString());
                double actualKwH = ConvertToDouble(row["Actual KWH"].ToString());
                double tdspCharges = ConvertToDouble(row["TDSP Charges"].ToString());

                usage.BillingDemandKw = double.IsNaN(meteredKw) ? null : (decimal?)Convert.ToDecimal(meteredKw);
                usage.TotalKwh = double.IsNaN(actualKwH) == true ? 0 : Convert.ToInt32(actualKwH);
                usage.UtilityCode = utilityAccount.UtilityCode;
                usage.UsageType = UsageType.File;
                usage.UsageSource = UsageSource.User;
                utilityAccount.Usages.Add(end.Value, usage);
            }

            #endregion

            return utilityAccount;
        }

        private static ProspectAccountCandidate GetUtilityAccountAndUsagesOncor(List<DataRow> rows, UtilityDictionary utilities)
        {
            // Parse an account and usages from the collection
            ProspectAccountCandidate utilityAccount = null;

            int accountRowIndex = FindMostRecentRowToBaseAccountOn(rows);

            #region Create Account and Populate

            DataRow accountRow = rows[accountRowIndex];
            int excelRow = 0;

            if (accountRow["Excel Row"] != DBNull.Value)
                excelRow = (int)accountRow["Excel Row"];

            utilityAccount = ProspectAccountCandidateFactory.GetProspectAccountCandidate(excelRow);

            if (accountRow["ESI ID"] != DBNull.Value)
                utilityAccount.AccountNumber = (string)accountRow["ESI ID"].ToString().Replace("'", ""); ;

            UtilityList utils = DetermineUtilityFromAccountNumber.GetTexasUtilitiesMatchingAccountNumber(utilityAccount.AccountNumber, utilities);

            if (utils != null && utils.Count == 1)
                utilityAccount.UtilityCode = utils[0].Code;

            if (accountRow["Customer Name"] != DBNull.Value)
                utilityAccount.CustomerName = (string)accountRow["Customer Name"];

            // Added Loss Factor Id . PBI 119136
            if (accountRow["Loss Factor ID"] != DBNull.Value)
                utilityAccount.LossFactorID = (string)accountRow["Loss Factor ID"];

            if (accountRow["Rate Class/Code"] != DBNull.Value)
                utilityAccount.RateClass = (string)accountRow["Rate Class/Code"];

            if (accountRow["Meter Read Cycle"] != DBNull.Value)
                utilityAccount.MeterReadCycleId = (string)accountRow["Meter Read Cycle"];

            if (accountRow["Load Profile"] != DBNull.Value)
            {
                string lsid = (string)accountRow["Load Profile"];
                utilityAccount.LoadProfile = lsid;
                utilityAccount.LoadShapeId = ExtractLoadShapeID(lsid);
            }

            UsGeographicalAddress serviceAddress = null;

            // Add the Street if it exists.
            if (accountRow["Service Address 1"] != DBNull.Value)
            {
                if (serviceAddress == null)
                    serviceAddress = new UsGeographicalAddress();
                serviceAddress.Street = accountRow["Service Address 1"].ToString();
            }

            // Add the zip code if it exists.
            if (accountRow["Service Address 3"] != DBNull.Value)
            {
                if (serviceAddress == null)
                    serviceAddress = new UsGeographicalAddress();
                serviceAddress.ZipCode = ExtractZip(accountRow["Service Address 3"].ToString());
            }

            // Add the city if it exists.
            if (accountRow["Service Address 3"] != DBNull.Value)
            {
                if (serviceAddress == null)
                    serviceAddress = new UsGeographicalAddress();
                serviceAddress.CityName = ExtractCity(accountRow["Service Address 3"].ToString());
            }

            // Add the state if it exists.
            if (accountRow["Service Address 3"] != DBNull.Value)
            {
                if (serviceAddress == null)
                    serviceAddress = new UsGeographicalAddress();
                serviceAddress.StateCode = ExtractState(accountRow["Service Address 3"].ToString());
                serviceAddress.ProvinceCode = serviceAddress.StateCode;
                serviceAddress.State = serviceAddress.StateCode;
            }

            // Add the retail market.
            if (accountRow["Service Address 3"] != DBNull.Value)
            {
                utilityAccount.RetailMarketCode = ExtractState(accountRow["Service Address 3"].ToString());
            }

            if (serviceAddress != null)
                utilityAccount.ServiceAddress = serviceAddress;
            #endregion

            #region Create a usage from each row and add to account

            foreach (DataRow row in rows)
            {
                if (row["Excel Row"] != DBNull.Value)
                {
                    excelRow = (int)row["Excel Row"];
                }

                UsageCandidate usage = UsageCandidateFactory.GetUsageCandidate(excelRow);

                if (row["ESI ID"] != DBNull.Value)
                {
                    usage.AccountNumber = row["ESI ID"].ToString();
                }


                DateTime? start = ConvertToDate(row["Start Date"].ToString());
                if (start == null)
                {
                    start = DateTime.MinValue;
                }

                DateTime? end = ConvertToDate(row["End Date"].ToString());
                if (end == null)
                {
                    end = DateTime.MinValue;
                }

                usage.BeginDate = new DateTime(start.Value.Year, start.Value.Month, start.Value.Day, start.Value.Hour, start.Value.Minute, 0);
                usage.EndDate = new DateTime(end.Value.Year, end.Value.Month, end.Value.Day, end.Value.Hour, end.Value.Minute, 0);
                usage.Days = ((TimeSpan)(end - start)).Days;


                double meteredKw = ConvertToDouble(row["Metered KW"].ToString());
                double actualKwH = ConvertToDouble(row["Actual KWH"].ToString());
                double tdspCharges = ConvertToDouble(row["TDSP Charges"].ToString());

                usage.BillingDemandKw = double.IsNaN(meteredKw) ? null : (decimal?)Convert.ToDecimal(meteredKw);
                usage.TotalKwh = double.IsNaN(actualKwH) == true ? 0 : Convert.ToInt32(actualKwH);
                usage.UtilityCode = utilityAccount.UtilityCode;
                usage.UsageType = UsageType.File;
                usage.UsageSource = UsageSource.User;
                if (utilityAccount.Usages.ContainsKey(end.Value) == false)
                    utilityAccount.Usages.Add(end.Value, usage);
            }

            #endregion

            return utilityAccount;
        }


        private static ProspectAccountCandidate GetUtilityAccountAndUsagesSharyland(List<DataRow> rows, UtilityDictionary utilities)
        {
            // Parse an account and usages from the collection
            ProspectAccountCandidate utilityAccount = null;

            #region  Find most recent row to base account on
            int accountRowIndex = 0;
            DateTime endDate = (DateTime)rows[0]["End Date"];
            for (int i = 1; i < rows.Count; i++)
            {
                DateTime dateBuf = (DateTime)rows[i]["End Date"];
                if (dateBuf > endDate)
                {
                    accountRowIndex = i;
                    endDate = dateBuf;
                }
            }
            #endregion

            #region Create Account and Populate
            DataRow accountRow = rows[accountRowIndex];
            int excelRow = 0;

            if (accountRow["Excel Row"] != DBNull.Value)
                excelRow = (int)accountRow["Excel Row"];

            utilityAccount = ProspectAccountCandidateFactory.GetProspectAccountCandidate(excelRow);

            if (accountRow["ESI ID"] != DBNull.Value)
                utilityAccount.AccountNumber = (string)accountRow["ESI ID"];

            UtilityList utils = DetermineUtilityFromAccountNumber.GetTexasUtilitiesMatchingAccountNumber(utilityAccount.AccountNumber, utilities);

            if (utils != null && utils.Count == 1)
                utilityAccount.UtilityCode = utils[0].Code;

            if (accountRow["Customer Name"] != DBNull.Value)
                utilityAccount.CustomerName = (string)accountRow["Customer Name"];

            if (accountRow["Rate Class/Code"] != DBNull.Value)
                utilityAccount.RateClass = (string)accountRow["Rate Class/Code"];

            if (accountRow["Meter Read Cycle"] != DBNull.Value)
                utilityAccount.MeterReadCycleId = (string)accountRow["Meter Read Cycle"];

            if (accountRow["Load Profile"] != DBNull.Value)
            {
                string lsid = (string)accountRow["Load Profile"];
                utilityAccount.LoadProfile = lsid;
                utilityAccount.LoadShapeId = ExtractLoadShapeID(lsid);
            }

            UsGeographicalAddress serviceAddress = null;

            // Add the Street if it exists.
            if (accountRow["Service Address 1"] != DBNull.Value)
            {
                if (serviceAddress == null)
                    serviceAddress = new UsGeographicalAddress();
                serviceAddress.Street = accountRow["Service Address 1"].ToString();
            }

            // Add the zip code if it exists.
            if (accountRow["Service Address 3"] != DBNull.Value)
            {
                if (serviceAddress == null)
                    serviceAddress = new UsGeographicalAddress();
                serviceAddress.ZipCode = ExtractZip(accountRow["Service Address 3"].ToString());
            }

            // Add the city if it exists.
            if (accountRow["Service Address 3"] != DBNull.Value)
            {
                if (serviceAddress == null)
                    serviceAddress = new UsGeographicalAddress();
                serviceAddress.CityName = ExtractCity(accountRow["Service Address 3"].ToString());
            }

            // Add the state if it exists.
            if (accountRow["Service Address 3"] != DBNull.Value)
            {
                if (serviceAddress == null)
                    serviceAddress = new UsGeographicalAddress();
                serviceAddress.StateCode = ExtractState(accountRow["Service Address 3"].ToString());
                serviceAddress.ProvinceCode = serviceAddress.StateCode;
                serviceAddress.State = serviceAddress.StateCode;
            }

            // Add the retail market.
            if (accountRow["Service Address 3"] != DBNull.Value)
            {
                utilityAccount.RetailMarketCode = ExtractState(accountRow["Service Address 3"].ToString());
            }

            if (serviceAddress != null)
                utilityAccount.ServiceAddress = serviceAddress;
            #endregion

            #region Create a usage from each row and add to account

            foreach (DataRow row in rows)
            {
                if (row["Excel Row"] != DBNull.Value)
                    excelRow = (int)row["Excel Row"];
                UsageCandidate usage = UsageCandidateFactory.GetUsageCandidate(excelRow);

                if (row["ESI ID"] != DBNull.Value)
                    usage.AccountNumber = row["ESI ID"].ToString();

                DateTime start = DateTime.MinValue;
                DateTime end = DateTime.MinValue;

                if (row["Start Date"] != DBNull.Value)
                    start = (DateTime)row["Start Date"];
                if (row["End Date"] != DBNull.Value)
                    end = (DateTime)row["End Date"];

                usage.BeginDate = new DateTime(start.Year, start.Month, start.Day, start.Hour, start.Minute, 0);
                usage.EndDate = new DateTime(end.Year, end.Month, end.Day, end.Hour, end.Minute, 0);

                usage.Days = ((TimeSpan)(end - start)).Days;

                double meteredKw = row["Metered KW"] == DBNull.Value ? double.NaN : (double)row["Metered KW"];
                double actualKwH = row["Actual KWH"] == DBNull.Value ? double.NaN : (double)row["Actual KWH"];
                double tdspCharges = row["TDSP Charges"] == DBNull.Value ? double.NaN : (double)row["TDSP Charges"];

                usage.BillingDemandKw = double.IsNaN(meteredKw) ? null : (decimal?)Convert.ToDecimal(meteredKw);
                usage.TotalKwh = double.IsNaN(actualKwH) == true ? 0 : Convert.ToInt32(actualKwH);
                //				usage.TdspCharges = double.IsNaN(tdspCharges) ? null : (decimal?)Convert.ToDecimal(tdspCharges);
                usage.UtilityCode = utilityAccount.UtilityCode;
                usage.UsageType = UsageType.File;
                usage.UsageSource = UsageSource.User;
                utilityAccount.Usages.Add(end, usage);
            }

            #endregion
            return utilityAccount;
        }

        private static ProspectAccountCandidate GetUtilityAccountAndUsagesTxu(List<DataRow> rows, UtilityDictionary utilities)
        {
            // Parse an account and usages from the collection
            ProspectAccountCandidate utilityAccount = null;

            #region  Find most recent row to base account on
            int accountRowIndex = 0;
            DateTime endDate = (DateTime)rows[0]["End Date"];
            for (int i = 1; i < rows.Count; i++)
            {
                DateTime dateBuf = (DateTime)rows[i]["End Date"];
                if (dateBuf > endDate)
                {
                    accountRowIndex = i;
                    endDate = dateBuf;
                }
            }
            #endregion

            #region Create Account and Populate
            DataRow accountRow = rows[accountRowIndex];
            int excelRow = (int)accountRow["Excel Row"];
            utilityAccount = ProspectAccountCandidateFactory.GetProspectAccountCandidate(excelRow);

            utilityAccount.AccountNumber = (string)accountRow["ESI ID"].ToString().Replace("'", ""); ;
            UtilityList utils = DetermineUtilityFromAccountNumber.GetTexasUtilitiesMatchingAccountNumber(utilityAccount.AccountNumber, utilities);
            if (utils.Count == 1)
                utilityAccount.UtilityCode = utils[0].Code;

            if (accountRow["Customer Name"] != DBNull.Value)
                utilityAccount.CustomerName = (string)accountRow["Customer Name"];

            // Added Loss Factor Id . PBI 119136

            if (accountRow["Loss Factor ID"] != DBNull.Value)
                utilityAccount.LossFactorID = (string)accountRow["Loss Factor ID"];

            if (accountRow["Rate Class/Code"] != DBNull.Value)
                utilityAccount.RateClass = (string)accountRow["Rate Class/Code"];

            if (accountRow["Meter Read Cycle"] != DBNull.Value)
                utilityAccount.MeterReadCycleId = (string)accountRow["Meter Read Cycle"];

            if (accountRow["Load Profile"] != DBNull.Value)
            {
                string lsid = (string)accountRow["Load Profile"];
                utilityAccount.LoadProfile = lsid;
                utilityAccount.LoadShapeId = ExtractLoadShapeID(lsid);
            }

            UsGeographicalAddress serviceAddress = null;

            // Add the Street if it exists.
            if (accountRow["Service Address 1"] != DBNull.Value)
            {
                if (serviceAddress == null)
                    serviceAddress = new UsGeographicalAddress();
                serviceAddress.Street = accountRow["Service Address 1"].ToString();
            }

            // Add the zip code if it exists.
            if (accountRow["Service Address 3"] != DBNull.Value)
            {
                if (serviceAddress == null)
                    serviceAddress = new UsGeographicalAddress();
                serviceAddress.ZipCode = ExtractZip(accountRow["Service Address 3"].ToString());
            }

            // Add the city if it exists.
            if (accountRow["Service Address 3"] != DBNull.Value)
            {
                if (serviceAddress == null)
                    serviceAddress = new UsGeographicalAddress();
                serviceAddress.CityName = ExtractCity(accountRow["Service Address 3"].ToString());
            }

            // Add the state if it exists.
            if (accountRow["Service Address 3"] != DBNull.Value)
            {
                if (serviceAddress == null)
                    serviceAddress = new UsGeographicalAddress();
                serviceAddress.StateCode = ExtractState(accountRow["Service Address 3"].ToString());
                serviceAddress.ProvinceCode = serviceAddress.StateCode;
                serviceAddress.State = serviceAddress.StateCode;
            }

            // Add the retail market.
            if (accountRow["Service Address 3"] != DBNull.Value)
            {
                utilityAccount.RetailMarketCode = ExtractState(accountRow["Service Address 3"].ToString());
            }

            if (serviceAddress != null)
                utilityAccount.ServiceAddress = serviceAddress;
            #endregion

            #region Create a usage from each row and add to account

            foreach (DataRow row in rows)
            {
                excelRow = (int)row["Excel Row"];
                UsageCandidate usage = UsageCandidateFactory.GetUsageCandidate(excelRow);

                if (accountRow["ESI ID"] != DBNull.Value)
                    usage.AccountNumber = row["ESI ID"].ToString();

                DateTime start = DateTime.MinValue;
                DateTime end = DateTime.MinValue;

                if (row["Start Date"] != DBNull.Value)
                {
                    start = (DateTime)row["Start Date"];
                    usage.BeginDate = new DateTime(start.Year, start.Month, start.Day, start.Hour, start.Minute, 0);
                }

                if (row["End Date"] != DBNull.Value)
                {
                    end = (DateTime)row["End Date"];
                    usage.EndDate = new DateTime(end.Year, end.Month, end.Day, end.Hour, end.Minute, 0);
                }

                if (end > DateTime.MinValue && start > DateTime.MinValue)
                    usage.Days = ((TimeSpan)(end - start)).Days;

                double meteredKw = row["Metered KW"] == DBNull.Value ? double.NaN : (double)row["Metered KW"];
                double actualKwH = row["Actual KWH"] == DBNull.Value ? double.NaN : (double)row["Actual KWH"];
                double tdspCharges = row["TDSP Charges"] == DBNull.Value ? double.NaN : (double)row["TDSP Charges"];

                usage.BillingDemandKw = double.IsNaN(meteredKw) ? null : (decimal?)Convert.ToDecimal(meteredKw);
                usage.TotalKwh = double.IsNaN(actualKwH) == true ? 0 : Convert.ToInt32(actualKwH);
                //				usage.TdspCharges = double.IsNaN(tdspCharges) ? null : (decimal?)Convert.ToDecimal(tdspCharges);

                usage.UtilityCode = utilityAccount.UtilityCode;
                usage.UsageType = UsageType.File;
                usage.UsageSource = UsageSource.User;

                utilityAccount.Usages.Add(end, usage);
            }

            #endregion
            return utilityAccount;
        }

        private static ProspectAccountCandidate GetUtilityAccountAndUsagesTxuSesco(List<DataRow> rows, UtilityDictionary utilities)
        {
            // Parse an account and usages from the collection
            ProspectAccountCandidate utilityAccount = null;

            #region  Find most recent row to base account on
            int accountRowIndex = 0;
            DateTime endDate = (DateTime)rows[0]["End Date"];
            for (int i = 1; i < rows.Count; i++)
            {
                DateTime dateBuf = (DateTime)rows[i]["End Date"];
                if (dateBuf > endDate)
                {
                    accountRowIndex = i;
                    endDate = dateBuf;
                }
            }
            #endregion

            #region Create Account and Populate
            DataRow accountRow = rows[accountRowIndex];
            int excelRow = (int)accountRow["Excel Row"];
            utilityAccount = ProspectAccountCandidateFactory.GetProspectAccountCandidate(excelRow);

            utilityAccount.AccountNumber = (string)accountRow["ESI ID"];
            UtilityList utils = DetermineUtilityFromAccountNumber.GetTexasUtilitiesMatchingAccountNumber(utilityAccount.AccountNumber, utilities);
            if (utils.Count == 1)
                utilityAccount.UtilityCode = utils[0].Code;

            if (accountRow["Customer Name"] != DBNull.Value)
                utilityAccount.CustomerName = (string)accountRow["Customer Name"];

            if (accountRow["Rate Class/Code"] != DBNull.Value)
                utilityAccount.RateClass = (string)accountRow["Rate Class/Code"];

            if (accountRow["Meter Read Cycle"] != DBNull.Value)
                utilityAccount.MeterReadCycleId = (string)accountRow["Meter Read Cycle"];

            if (accountRow["Load Profile"] != DBNull.Value)
            {
                string lsid = (string)accountRow["Load Profile"];
                utilityAccount.LoadProfile = lsid;
                utilityAccount.LoadShapeId = ExtractLoadShapeID(lsid);
            }

            UsGeographicalAddress serviceAddress = null;

            // Add the Street if it exists.
            if (accountRow["Service Address 1"] != DBNull.Value)
            {
                if (serviceAddress == null)
                    serviceAddress = new UsGeographicalAddress();
                serviceAddress.Street = accountRow["Service Address 1"].ToString();
            }

            // Add the zip code if it exists.
            if (accountRow["Service Address 3"] != DBNull.Value)
            {
                if (serviceAddress == null)
                    serviceAddress = new UsGeographicalAddress();
                serviceAddress.ZipCode = ExtractZip(accountRow["Service Address 3"].ToString());
            }

            // Add the city if it exists.
            if (accountRow["Service Address 3"] != DBNull.Value)
            {
                if (serviceAddress == null)
                    serviceAddress = new UsGeographicalAddress();
                serviceAddress.CityName = ExtractCity(accountRow["Service Address 3"].ToString());
            }

            // Add the state if it exists.
            if (accountRow["Service Address 3"] != DBNull.Value)
            {
                if (serviceAddress == null)
                    serviceAddress = new UsGeographicalAddress();
                serviceAddress.StateCode = ExtractState(accountRow["Service Address 3"].ToString());
                serviceAddress.ProvinceCode = serviceAddress.StateCode;
                serviceAddress.State = serviceAddress.StateCode;
            }

            // Add the retail market.
            if (accountRow["Service Address 3"] != DBNull.Value)
            {
                utilityAccount.RetailMarketCode = ExtractState(accountRow["Service Address 3"].ToString());
            }

            if (serviceAddress != null)
                utilityAccount.ServiceAddress = serviceAddress;
            #endregion

            #region Create a usage from each row and add to account

            foreach (DataRow row in rows)
            {
                excelRow = (int)row["Excel Row"];
                UsageCandidate usage = UsageCandidateFactory.GetUsageCandidate(excelRow);

                if (accountRow["ESI ID"] != DBNull.Value)
                    usage.AccountNumber = row["ESI ID"].ToString();

                DateTime start = DateTime.MinValue;
                DateTime end = DateTime.MinValue;

                if (row["Start Date"] != DBNull.Value)
                {
                    start = (DateTime)row["Start Date"];
                    usage.BeginDate = new DateTime(start.Year, start.Month, start.Day, start.Hour, start.Minute, 0);
                }

                if (row["End Date"] != DBNull.Value)
                {
                    end = (DateTime)row["End Date"];
                    usage.EndDate = new DateTime(end.Year, end.Month, end.Day, end.Hour, end.Minute, 0);
                }

                if (end > DateTime.MinValue && start > DateTime.MinValue)
                    usage.Days = ((TimeSpan)(end - start)).Days;

                double meteredKw = row["Metered KW"] == DBNull.Value ? double.NaN : (double)row["Metered KW"];
                double actualKwH = row["Actual KWH"] == DBNull.Value ? double.NaN : (double)row["Actual KWH"];
                double tdspCharges = row["TDSP Charges"] == DBNull.Value ? double.NaN : (double)row["TDSP Charges"];

                usage.BillingDemandKw = double.IsNaN(meteredKw) ? null : (decimal?)Convert.ToDecimal(meteredKw);
                usage.TotalKwh = double.IsNaN(actualKwH) == true ? 0 : Convert.ToInt32(actualKwH);
                //				usage.TdspCharges = double.IsNaN(tdspCharges) ? null : (decimal?)Convert.ToDecimal(tdspCharges);

                usage.UtilityCode = utilityAccount.UtilityCode;
                usage.UsageType = UsageType.File;
                usage.UsageSource = UsageSource.User;

                utilityAccount.Usages.Add(end, usage);
            }

            #endregion
            return utilityAccount;
        }

        private static UtilityAccountList GetUtilityAccountsFromUtilityAccountFile(DataTable dt)
        {
            UtilityAccountList accounts = null;

            int excelRowNumber = 1;  //start at 1 since there is a header row ( the first data row will be 2 )

            ProspectAccountCandidate account = null;

            foreach (DataRow dr in dt.Rows)
            {
                excelRowNumber += 1;

                if (IsRowEmpty(dr) == false)
                {
                    account = GetUtilityAccount(dr, excelRowNumber);

                    //add account from row to the collection
                    if (account != null)
                    {
                        if (accounts == null)
                            accounts = new UtilityAccountList();

                        accounts.Add(account);
                    }
                }
            }

            return accounts;
        }

        private static UtilityAccountList GetUtilityAccountsWithUsagesFromAep(DataSet ds)
        {
            UtilityAccountList accounts = new UtilityAccountList();
            ProspectAccountCandidate account = null;
            UtilityDictionary utilities = UtilityStandInFactory.GetUtilities();
            DataTable dt = ds.Tables["USAGE HIST DATA"];
            //Add excel row value as a column before we split sheet
            int excelRow = 0;
            dt.Columns.Add(new DataColumn("Excel Row", excelRow.GetType()));
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                excelRow = i + 2;
                dt.Rows[i]["Excel Row"] = excelRow;
            }
            // Buffer rows representing a UtilityAccount in a Row Collections
            // and parse them as a collection
            List<DataRow> rows = new List<DataRow>();

            rows.Add(dt.Rows[0]); //begin the 1st collection
            string accountNumber = rows[0]["ESI ID"].ToString().Replace("'", "");
            //process rows in collection to retrieve usages
            for (int i = 1; i < dt.Rows.Count; i++)
            {
                if (IsRowEmpty(dt.Rows[i]) == false)
                {
                    string nextAccountNumber = dt.Rows[i]["ESI ID"].ToString();

                    if (i == dt.Rows.Count - 1)
                    {
                        rows.Add(dt.Rows[i]); //add the final row
                        account = GetUtilityAccountAndUsagesAep(rows, utilities);
                        if (account != null)
                            accounts.Add(account);
                    }
                    else if (string.Compare(accountNumber, nextAccountNumber) != 0)
                    {

                        accountNumber = nextAccountNumber; //to begin the next group

                        account = GetUtilityAccountAndUsagesAep(rows, utilities);

                        if (account != null)
                            accounts.Add(account);

                        //clear the collection for the next account and start it with the current row
                        rows.Clear();
                        rows.Add(dt.Rows[i]); //build the collection
                    }
                    else
                    {
                        rows.Add(dt.Rows[i]); //build the collection
                    }
                }
            }

            return accounts;
        }

        private static UtilityAccountList GetUtilityAccountsWithUsagesFromOncor(DataSet ds)
        {
            UtilityAccountList accounts = new UtilityAccountList();
            ProspectAccountCandidate account = null;
            UtilityDictionary utilities = UtilityStandInFactory.GetUtilities();
            DataTable dt = ds.Tables["Page1_1"];
            //Add excel row value as a column before we split sheet
            int excelRow = 0;
            dt.Columns.Add(new DataColumn("Excel Row", excelRow.GetType()));
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                excelRow = i + 2;
                dt.Rows[i]["Excel Row"] = excelRow;
            }
            // Buffer rows representing a UtilityAccount in a Row Collections
            // and parse them as a collection
            List<DataRow> rows = new List<DataRow>();

            rows.Add(dt.Rows[0]); //begin the 1st collection
            string accountNumber = rows[0]["ESI ID"].ToString().Replace("'", "");
            //process rows in collection to retrieve usages
            for (int i = 1; i < dt.Rows.Count; i++)
            {
                if (IsRowEmpty(dt.Rows[i]) == false)
                {
                    string nextAccountNumber = dt.Rows[i]["ESI ID"].ToString();

                    if (i == dt.Rows.Count - 1)
                    {
                        rows.Add(dt.Rows[i]); //add the final row
                        account = GetUtilityAccountAndUsagesOncor(rows, utilities);
                        if (account != null)
                            accounts.Add(account);
                    }
                    else if (string.Compare(accountNumber, nextAccountNumber) != 0)
                    {

                        accountNumber = nextAccountNumber; //to begin the next group

                        account = GetUtilityAccountAndUsagesOncor(rows, utilities);

                        if (account != null)
                            accounts.Add(account);

                        //clear the collection for the next account and start it with the current row
                        rows.Clear();
                        rows.Add(dt.Rows[i]); //build the collection
                    }
                    else
                    {
                        rows.Add(dt.Rows[i]); //build the collection
                    }
                }
            }

            return accounts;
        }

        private static UtilityAccountList GetUtilityAccountsWithUsagesFromCtpen(DataSet ds)
        {
            UtilityAccountList accounts = new UtilityAccountList();
            UtilityDictionary utilities = UtilityStandInFactory.GetUtilities();

            #region Add excel row to all sheets
            for (int i = 0; i < ds.Tables.Count; i++)
            {
                DataTable dt = ds.Tables[i];
                dt.Columns.Add(new DataColumn("Excel Row"));
                dt.Columns.Add(new DataColumn("Excel Sheetname"));
                for (int r = 0; r < dt.Rows.Count; r++)
                {
                    dt.Rows[r]["Excel Row"] = r + 2;
                    dt.Rows[r]["Excel Sheetname"] = dt.TableName;
                }
            }
            #endregion

            #region determine sheet with accounts
            DataTable accountsSheet = null;
            if (ds.Tables.Contains("Accounts"))
                accountsSheet = ds.Tables["Accounts"];
            else
            {
                for (int i = 0; i < ds.Tables.Count; i++)
                {
                    DataTable dt = ds.Tables[i];
                    if (dt.Columns.Count > 0 && dt.Columns[0].ColumnName == "#")
                    {
                        accountsSheet = ds.Tables[i];
                        ds.Tables.Remove(accountsSheet);
                        i = ds.Tables.Count;
                    }
                }
            }
            #endregion

            #region extract accounts and usages

            ProspectAccountCandidate utilityAccount = null;

            for (int i = 0; i < accountsSheet.Rows.Count; i++)
            {
                DataRow accountRow = accountsSheet.Rows[i];
                string excelSheetname = accountRow["Excel Sheetname"].ToString();
                int excelRow = System.Convert.ToInt16((string)accountRow["Excel Row"]);
                utilityAccount = ProspectAccountCandidateFactory.GetProspectAccountCandidate(excelRow, excelSheetname);

                if (accountsSheet.Rows[i]["ESI ID"] != DBNull.Value)
                    utilityAccount.AccountNumber = (string)accountsSheet.Rows[i]["ESI ID"].ToString().Replace("'", "");

                UtilityList utils = DetermineUtilityFromAccountNumber.GetTexasUtilitiesMatchingAccountNumber(utilityAccount.AccountNumber, utilities);

                if (utils.Count == 1)
                    utilityAccount.UtilityCode = utils[0].Code;

                if (accountsSheet.Rows[i]["Account Name"] != DBNull.Value)
                    utilityAccount.CustomerName = (string)accountsSheet.Rows[i]["Account Name"];
                //Added By Vikas Sharma PBI - 119136
                if (accountsSheet.Rows[i]["Loss Factor ID"] != DBNull.Value)
                    utilityAccount.LossFactorID = (string)accountsSheet.Rows[i]["Loss Factor ID"];

                UsGeographicalAddress serviceAddress = null;

                // Add the street if it exists.
                if (accountRow["Service Address 1"] != DBNull.Value)
                {
                    if (serviceAddress == null)
                        serviceAddress = new UsGeographicalAddress();
                    serviceAddress.Street = accountRow["Service Address 1"].ToString();
                }

                // Add the zip code if it exists.
                if (accountRow["Service Address 3"] != DBNull.Value)
                {
                    if (serviceAddress == null)
                        serviceAddress = new UsGeographicalAddress();
                    serviceAddress.ZipCode = ExtractZip(accountRow["Service Address 3"].ToString());
                }

                // Add the city if it exists.
                if (accountRow["Service Address 3"] != DBNull.Value)
                {
                    if (serviceAddress == null)
                        serviceAddress = new UsGeographicalAddress();
                    serviceAddress.CityName = ExtractCity(accountRow["Service Address 3"].ToString());
                }
                

                // Add the state if it exists.
                if (accountRow["Service Address 3"] != DBNull.Value)
                {
                    if (serviceAddress == null)
                        serviceAddress = new UsGeographicalAddress();
                    serviceAddress.StateCode = ExtractState(accountRow["Service Address 3"].ToString());
                    serviceAddress.ProvinceCode = serviceAddress.StateCode;
                    serviceAddress.State = serviceAddress.StateCode;
                }

                // Add the retail market.
                if (accountRow["Service Address 3"] != DBNull.Value)
                {
                    utilityAccount.RetailMarketCode = ExtractState(accountRow["Service Address 3"].ToString());
                }

                if (serviceAddress != null)
                    utilityAccount.ServiceAddress = serviceAddress;

                #region extract usages and any additional account fields

                string usageSheetName = string.Format("{0} - {1}", accountRow["#"].ToString(), utilityAccount.AccountNumber);

                if (ds.Tables.Contains(usageSheetName) && ds.Tables[usageSheetName].Rows.Count > 0)
                {
                    DataTable usages = ds.Tables[usageSheetName];
                    //get most recent row for account data

                    string recentDate = DateTime.MinValue.ToShortDateString();
                    if (usages.Rows[0]["End Date"] != DBNull.Value)
                        recentDate = (string)usages.Rows[0]["End Date"];

                    DateTime mostRecent = DateTime.Parse(recentDate);
                    int accountSheet = 0;

                    for (int ii = 0; ii < usages.Rows.Count; ii++)
                    {
                        if (usages.Rows[ii]["End Date"] != DBNull.Value)
                            recentDate = (string)usages.Rows[ii]["End Date"];
                        DateTime dateBuf = DateTime.Parse(recentDate);
                        if (dateBuf > mostRecent)
                        {
                            accountSheet = ii;
                            mostRecent = dateBuf;
                        }
                    }

                    for (int ii = 0; ii < usages.Rows.Count; ii++)
                    {
                        DataRow dr = usages.Rows[ii];

                        if (dr["Excel Row"] != DBNull.Value)
                            excelRow = System.Convert.ToInt16((string)dr["Excel Row"]);

                        if (dr["Excel Sheetname"] != DBNull.Value)
                            excelSheetname = (string)dr["Excel Sheetname"];

                        string startBuf = DateTime.MinValue.ToShortDateString();

                        if (dr["Start Date"] != DBNull.Value)
                            startBuf = dr["Start Date"].ToString();

                        string endBuf = DateTime.MinValue.ToShortDateString();

                        if (dr["End Date"] != DBNull.Value)
                            endBuf = dr["End Date"].ToString();

                        DateTime start = DateTime.Parse(startBuf);
                        DateTime end = DateTime.Parse(endBuf);

                        UsageCandidate usage = UsageCandidateFactory.GetUsageCandidate(excelRow, excelSheetname);
                        utilityAccount.Usages.Add(end, usage);

                        usage.AccountNumber = utilityAccount.AccountNumber;
                        usage.UtilityCode = utilityAccount.UtilityCode;
                        usage.UsageType = UsageType.File;
                        usage.UsageSource = UsageSource.User;

                        usage.BeginDate = new DateTime(start.Year, start.Month, start.Day, start.Hour, start.Minute, 0);
                        usage.EndDate = new DateTime(end.Year, end.Month, end.Day, end.Hour, end.Minute, 0);

                        usage.Days = ((TimeSpan)(end - start)).Days;


                        double meteredKw = ConvertToDouble(dr["Metered KW"].ToString());
                        double actualKwH = ConvertToDouble(dr["Actual KWH"].ToString());
                        double tdspCharges = ConvertToDouble(dr["TDSP Charges"].ToString());



                        usage.BillingDemandKw = double.IsNaN(meteredKw) ? null : (decimal?)Convert.ToDecimal(meteredKw);
                        usage.TotalKwh = double.IsNaN(actualKwH) == true ? 0 : Convert.ToInt32(actualKwH);
                        //						usage.TdspCharges = double.IsNaN(tdspCharges) ? null : (decimal?)Convert.ToDecimal(tdspCharges);

                        if (ii == accountSheet)
                        {

                            if (dr["Meter Read Cycle"] != DBNull.Value)
                                utilityAccount.MeterReadCycleId = (string)dr["Meter Read Cycle"];

                            if (dr["Load Profile"] != DBNull.Value)
                            {
                                string lsid = (string)dr["Load Profile"];
                                utilityAccount.LoadProfile = lsid;
                                utilityAccount.LoadShapeId = ExtractLoadShapeID(lsid);
                            }

                            if (dr["Rate Class/Code"] != DBNull.Value)
                            {
                                utilityAccount.RateClass = (string)dr["Rate Class/Code"];
                            }
                        }
                    }
                }

                #endregion

                accounts.Add(utilityAccount);

            }

            #endregion

            return accounts;
        }

        private static UtilityAccountList GetUtilityAccountsWithUsagesFromSharyland(DataSet ds)
        {
            UtilityAccountList accounts = new UtilityAccountList();
            ProspectAccountCandidate account = null;
            UtilityDictionary utilities = UtilityStandInFactory.GetUtilities();
            DataTable dt = ds.Tables["USAGE HIST DATA"];
            //Add excel row value as a column before we split sheet
            int excelRow = 0;
            dt.Columns.Add(new DataColumn("Excel Row", excelRow.GetType()));
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                excelRow = i + 2;
                dt.Rows[i]["Excel Row"] = excelRow;
            }
            // Buffer rows representing a UtilityAccount in a Row Collections
            // and parse them as a collection
            List<DataRow> rows = new List<DataRow>();

            rows.Add(dt.Rows[0]); //begin the 1st collection
            string accountNumber = rows[0]["ESI ID"].ToString();
            //process rows in collection to retrieve usages
            for (int i = 1; i < dt.Rows.Count; i++)
            {
                if (IsRowEmpty(dt.Rows[i]) == false)
                {
                    string nextAccountNumber = dt.Rows[i]["ESI ID"].ToString();

                    if (i == dt.Rows.Count - 1)
                    {
                        rows.Add(dt.Rows[i]); //add the final row
                        account = GetUtilityAccountAndUsagesAep(rows, utilities);
                        if (account != null)
                            accounts.Add(account);
                    }
                    else if (string.Compare(accountNumber, nextAccountNumber) != 0)
                    {

                        accountNumber = nextAccountNumber; //to begin the next group

                        account = GetUtilityAccountAndUsagesAep(rows, utilities);

                        if (account != null)
                            accounts.Add(account);

                        //clear the collection for the next account and start it with the current row
                        rows.Clear();
                        rows.Add(dt.Rows[i]); //build the collection
                    }
                    else
                    {
                        rows.Add(dt.Rows[i]); //build the collection
                    }
                }
            }

            return accounts;
        }

        #endregion

        #region supporting LPCFormats
        /// <summary>
        /// Parses the Excel file, found at the provided file path, containing a list of accounts.
        /// </summary>
        /// <param name="context">The context (including path) of the Excel file to parse.</param>
        /// <param name="requiredFields">An object encapsulating the minimum message requirements
        /// to construct a UtilityAccount for each UtilityCode.</param>
        /// <returns>A UtilityAccountList resulting from parsing the given Excel file.</returns>
        internal static UtilityAccountList GetUtilityAccountsFromCustomOfferLOAFile(FileContext context)
        {
            UtilityAccountList accounts = new UtilityAccountList();

            CustomUtilityAccountExcelSchemaRule utilityAccountExcelFormatRule = new CustomUtilityAccountExcelSchemaRule(context);
            if (!utilityAccountExcelFormatRule.Validate())
            {
                throw utilityAccountExcelFormatRule.Exception;
            }

            //Create all accounts possible; will validate separately
            accounts = GetUtilityAccountsFromCustomOfferLOAFile(utilityAccountExcelFormatRule.Accounts);

            return accounts;
        }

        private static UtilityAccountList GetUtilityAccountsFromCustomOfferLOAFile(DataTable dt)
        {
            UtilityAccountList accounts = null;

            int excelRowNumber = 1;  //start at 1 since there is a header row ( the first data row will be 2 )

            ProspectAccountCandidate account = null;

            foreach (DataRow dr in dt.Rows)
            {
                excelRowNumber += 1;

                if (IsRowEmpty(dr) == false)
                {
                    account = GetCustomOfferUtilityAccount(dr, excelRowNumber);

                    //add account from row to the collection
                    if (account != null)
                    {

                        if (accounts == null)
                            accounts = new UtilityAccountList();

                        accounts.Add(account);
                    }
                }
            }

            return accounts;
        }

        #endregion

        private static double ConvertToDouble(string valueToConvert)
        {
            double result;
            if (double.TryParse(valueToConvert, out result))
            {
                return result;
            }
            else
            {
                return 0;
            }
        }

        private static DateTime? ConvertToDate(string valueToConvert)
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

        #endregion Methods
    }
}