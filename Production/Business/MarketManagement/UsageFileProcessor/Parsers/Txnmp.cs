using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using LibertyPower.Business.CommonBusiness.CommonEntity;
using LibertyPower.Business.MarketManagement.UtilityManagement;
using LibertyPower.DataAccess.WorkbookAccess;
using UsageFileProcessor.Entities;
using UsageFileProcessor.Interfaces;
using UsageFileProcessor.Services;

namespace UsageFileProcessor.Parsers
{
    public class Txnmp : IUsageFileParser
    {
        private const string WorksheetName = "LOA_Detail_Rpt";
        private DataSet _importFileDataSet;
        public string Error { get; private set; }

        public bool IsParser(UsageFile file)
        {
            return file.UtilityCode.Equals("txnmp", StringComparison.InvariantCultureIgnoreCase);
        }

        public bool IsValidFileTemplate(UsageFile file)
        {
            // Validation: make sure the context specifies an Excel file.
            if (file.Path.EndsWith(".xls", StringComparison.InvariantCultureIgnoreCase) == false)
            {
                var actualExtension = System.IO.Path.GetExtension(file.Path);
                Error = string.Format("Invalid file type '{0}' when only '.xls' can be parsed", actualExtension);
                return false;
            }
            
            

            _importFileDataSet = ExcelAccess.GetWorkbookEx(file.Path, false, false);

            if (_importFileDataSet == null)
            {
                Error = string.Format("Unable to read from the '{0}' Excel file", file.Path);
                return false;
            }

            if (!_importFileDataSet.Tables.Contains(WorksheetName))
            {
                Error = WorksheetName + " is a required sheet";
                return false;
            }

            _importFileDataSet = NormalizeWorkbookData(_importFileDataSet, WorksheetName);

            foreach (DataTable dataTable in _importFileDataSet.Tables)
            {
                VerifyColumnsExist(dataTable, "ESI_ID");
                VerifyColumnsExist(dataTable, "CUSTOMER_NAME");
                VerifyColumnsExist(dataTable, "RATE_CODE");
                VerifyColumnsExist(dataTable, "ZIPCODE");
                VerifyColumnsExist(dataTable, "METERED_KW");
                VerifyColumnsExist(dataTable, "ACTUAL_KWH");
                VerifyColumnsExist(dataTable, "BILLED_KW");
                VerifyColumnsExist(dataTable, "TDSPCHARGES");
                VerifyColumnsExist(dataTable, "START_DATE");
                VerifyColumnsExist(dataTable, "END_DATE");
                VerifyColumnsExist(dataTable, "METERREADCYCLE");
                VerifyColumnsExist(dataTable, "STREETADDRESS1");
                VerifyColumnsExist(dataTable, "STREETADDRESS2");
                VerifyColumnsExist(dataTable, "STREETADDRESS3");
                VerifyColumnsExist(dataTable, "LOAD_PROFILE");
                VerifyColumnsExist(dataTable, "POWER_FACTOR");
                VerifyColumnsExist(dataTable, "ERCOT_REGION");
                VerifyColumnsExist(dataTable, "METEREDKVA");

            }

            return string.IsNullOrWhiteSpace(Error);
        }

        public IEnumerable<ParserAccount> Parse(UsageFile file)
        {
            var accounts = new List<ParserAccount>();

            var utilities = UtilityService.GetUtilities();

            for (int i = 0; i < _importFileDataSet.Tables.Count; i++)
            {
                DataTable dt = _importFileDataSet.Tables[i];

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

                var utilityAccount = ParserAccountService.GetAccount(excelRow);

                accounts.Add(utilityAccount);

                string accountNumber = null;

                if (accountRow["ESI_ID"] != DBNull.Value)
                    accountNumber = (string)accountRow["ESI_ID"];

                if (accountNumber != null)
                    utilityAccount.AccountNumber = accountNumber.Replace("ESIID", "");

                var util = UtilityService.GetUtilitiesMatchingUtilityCode(file.UtilityCode, utilities).FirstOrDefault();

                if (util == null)
                {
                    Error = "Utility not found with code " + file.UtilityCode;
                    return null;
                }

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
                    serviceAddress.ZipCode = ParserAccountService.ExtractZip(accountRow["STREETADDRESS3"].ToString());
                }

                // Add the city if it exists.
                if (accountRow["STREETADDRESS3"] != DBNull.Value)
                {
                    if (serviceAddress == null)
                        serviceAddress = new UsGeographicalAddress();
                    serviceAddress.CityName = ParserAccountService.ExtractCity(accountRow["STREETADDRESS3"].ToString());
                }

                // Add the state if it exists.
                if (accountRow["STREETADDRESS3"] != DBNull.Value)
                {
                    if (serviceAddress == null)
                        serviceAddress = new UsGeographicalAddress();
                    serviceAddress.StateCode = ParserAccountService.ExtractState(accountRow["STREETADDRESS3"].ToString());
                    serviceAddress.ProvinceCode = serviceAddress.StateCode;
                    serviceAddress.State = serviceAddress.StateCode;
                }

                // Add the retail market.
                if (accountRow["STREETADDRESS3"] != DBNull.Value)
                {
                    utilityAccount.RetailMarketCode = ParserAccountService.ExtractState(accountRow["STREETADDRESS3"].ToString());
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
                    utilityAccount.LoadShapeId = ParserAccountService.ExtractLoadShapeID(lsid);
                }

                #endregion

                #region get usage fields
                foreach (DataRow dr in dt.Rows)
                {
                    if (dr["Excel Row"] != DBNull.Value)
                        excelRow = Convert.ToInt16((string)dr["Excel Row"]);
                    var usage = ParserUsageService.GetUsage(excelRow);

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

                    decimal actualAsDecimal, billedAsDecimal, meteredKwAsDecimal;
                    usage.MonthlyPeakDemandKw = decimal.TryParse(meteredKw, out meteredKwAsDecimal) ? Convert.ToInt32(meteredKwAsDecimal) : 0;
                    usage.BillingDemandKw = decimal.TryParse(billedKw, out billedAsDecimal) ? Convert.ToInt32(billedAsDecimal) : 0;
                    usage.TotalKwh = decimal.TryParse(actualKwH, out actualAsDecimal) ? Convert.ToInt32(actualAsDecimal) : 0;
                    //					usage.TdspCharges = tdspCharges == "" ? null : (decimal?)Convert.ToDecimal(tdspCharges);

                }
                #endregion
            }

            return accounts;
        }

        /// <summary>
        /// Parses worksheet LOA_DetailRpt to create 1 worksheet with headers from each group
        /// </summary>
        /// <param name="importFileDataSet"></param>
        /// <param name="originalSheetName"></param>
        /// <returns></returns>
        private DataSet NormalizeWorkbookData(DataSet importFileDataSet, string originalSheetName)
        {
            bool done = false;

            // This is the original sheet to parse on
            DataTable dt = importFileDataSet.Tables[originalSheetName];

            int header = 0, last = 0;
            int groupsFound = 0;

            // Try to find first group if any
            //header = FindNextHeaderRow( dt, last );
            header = 0;
            last = FindLastRowOfGroup(dt, header);

            // Used for newly created sheets
            string sheetName;

            while (!done)
            {

                if (header >= 0 && last > header)
                {
                    // Parse 1st group to its own table
                    DataTable normalTable = GetTable(dt, header, last);

                    normalTable.TableName = string.Format("Group: {0}", (++groupsFound).ToString());

                    sheetName = normalTable.TableName;

                    const int topLeftRowIndex = 0;
                    const int topLeftColumnIndex = 0;
                    var bottomRightRowIndex = normalTable.Rows.Count - 1;
                    var bottomRightColumnIndex = normalTable.Columns.Count - 1;

                    normalTable = ExcelAccess.ExtractRegion(true, topLeftRowIndex, topLeftColumnIndex, bottomRightRowIndex, bottomRightColumnIndex, normalTable);
                    normalTable.Columns[18].ColumnName = "Excel Row";
                    importFileDataSet.Tables.Add(normalTable);

                    // Check if this was the last group
                    if (last == dt.Rows.Count)
                    {
                        done = true;
                    }
                    else // Attempt to find the next group ( might just be blank lines )
                    {
                        header = FindNextHeaderRow(dt, last);
                        last = FindLastRowOfGroup(dt, header);
                    }
                }
                else
                {
                    done = true;
                }

            }

            importFileDataSet.Tables.Remove(originalSheetName);

            return importFileDataSet;
        }

        private void VerifyColumnsExist(DataTable dataTable, string requiredColumn)
        {
            if (!dataTable.Columns.Contains(requiredColumn))
            {
                Error = requiredColumn + " is a required column";
            }
        }

        private int FindLastRowOfGroup(DataTable dt, int start)
        {
            if (start > dt.Rows.Count - 1)
                return -1;

            for (var i = start; i < dt.Rows.Count; i++)
            {
                var empty = DataSetService.IsRowEmpty(dt.Rows[i], true);

                if (empty)
                    return i - 1;
            }

            return dt.Rows.Count;
        }

        private int FindNextHeaderRow(DataTable dt, int start)
        {
            if (start > dt.Rows.Count - 1)
                return -1;

            for (int i = start; i < dt.Rows.Count; i++)
            {

                if (dt.Rows[i][0].ToString().Trim().StartsWith("ESI_ID"))
                    return i;

            }

            return -1;
        }

        private DataTable GetTable(DataTable dt, int header, int last)
        {
            DataTable dtCopy = dt.Copy();

            //Add original excel row
            dtCopy.Columns.Add(new DataColumn("Excel Row"));

            for (int i = 0; i < dtCopy.Rows.Count; i++)
            {
                dtCopy.Rows[i]["Excel Row"] = i + 1;
            }

            for (int i = 0; i < header; i++)
            {
                dtCopy.Rows.RemoveAt(0);
            }

            int targetSize = last - header;

            while (dtCopy.Rows.Count > targetSize + 1)
            {
                dtCopy.Rows.RemoveAt(dtCopy.Rows.Count - 1);
            }

            //dtCopy = CreateHeaders( dtCopy );

            return dtCopy;
        }
    }
}