using System;
using System.Collections.Generic;
using System.Data;
using LibertyPower.Business.CommonBusiness.CommonEntity;
using LibertyPower.Business.MarketManagement.UtilityManagement;
using LibertyPower.DataAccess.WorkbookAccess;
using UsageFileProcessor.Entities;
using UsageFileProcessor.Interfaces;
using UsageFileProcessor.Services;

namespace UsageFileProcessor.Parsers
{
    public class Ctpen : IUsageFileParser
    {
        private const string WorksheetName = "Accounts"; //This worksheet is always present; additional worksheets are required for each ESI ID in this worksheet
        private DataSet _importFileDataSet;
        public string Error { get; private set; }
        public bool IsParser(UsageFile file)
        {
            return file.UtilityCode.Equals("ctpen", StringComparison.InvariantCultureIgnoreCase);
        }

        public bool IsValidFileTemplate(UsageFile file)
        {
            if (file.Path.EndsWith(".xls", StringComparison.InvariantCultureIgnoreCase) == false)
            {
                string actualExtension = System.IO.Path.GetExtension(file.Path);
                string format = "Invalid file type '{0}' when only '.xls' can be parsed";
                Error = string.Format(format, actualExtension);
                
                return false;
            }

            _importFileDataSet = ExcelAccess.GetWorkbookEx(file.Path, true, false);

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

            DataTable accounts = _importFileDataSet.Tables[WorksheetName];

            VerifyColumnsExist(accounts, "#");
            VerifyColumnsExist(accounts, "ESI ID");
            VerifyColumnsExist(accounts, "Account Number");
            VerifyColumnsExist(accounts, "Service Address 1");
            VerifyColumnsExist(accounts, "Service Address 3");

            CheckEachDependentWorksheet(_importFileDataSet);

            return string.IsNullOrWhiteSpace(Error);
        }

        public IEnumerable<ParserAccount> Parse(UsageFile file)
        {
            var accounts = new List<ParserAccount>();
            var utilities = UtilityService.GetUtilities();

            #region Add excel row to all sheets
            for (int i = 0; i < _importFileDataSet.Tables.Count; i++)
            {
                DataTable dt = _importFileDataSet.Tables[i];
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
            if (_importFileDataSet.Tables.Contains("Accounts"))
                accountsSheet = _importFileDataSet.Tables["Accounts"];
            else
            {
                for (int i = 0; i < _importFileDataSet.Tables.Count; i++)
                {
                    DataTable dt = _importFileDataSet.Tables[i];
                    if (dt.Columns.Count > 0 && dt.Columns[0].ColumnName == "#")
                    {
                        accountsSheet = _importFileDataSet.Tables[i];
                        _importFileDataSet.Tables.Remove(accountsSheet);
                        i = _importFileDataSet.Tables.Count;
                    }
                }
            }
            #endregion

            #region extract accounts and usages

            ParserAccount utilityAccount = null;

            for (int i = 0; i < accountsSheet.Rows.Count; i++)
            {
                DataRow accountRow = accountsSheet.Rows[i];
                string excelSheetname = accountRow["Excel Sheetname"].ToString();
                int excelRow = System.Convert.ToInt16((string)accountRow["Excel Row"]);
                utilityAccount = ParserAccountService.GetAccount(excelRow, excelSheetname);

                if (accountsSheet.Rows[i]["ESI ID"] != DBNull.Value)
                    utilityAccount.AccountNumber = accountsSheet.Rows[i]["ESI ID"].ToString().Replace("'", "");

                UtilityList utils = UtilityService.GetUtilitiesMatchingUtilityCode(file.UtilityCode, utilities);

                if (utils.Count == 1)
                    utilityAccount.UtilityCode = utils[0].Code;

                if (accountsSheet.Rows[i]["Account Name"] != DBNull.Value)
                    utilityAccount.CustomerName = (string)accountsSheet.Rows[i]["Account Name"];

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
                    serviceAddress.ZipCode = ParserAccountService.ExtractZip(accountRow["Service Address 3"].ToString());
                }

                // Add the city if it exists.
                if (accountRow["Service Address 3"] != DBNull.Value)
                {
                    if (serviceAddress == null)
                        serviceAddress = new UsGeographicalAddress();
                    serviceAddress.CityName = ParserAccountService.ExtractCity(accountRow["Service Address 3"].ToString());
                }

                // Add the state if it exists.
                if (accountRow["Service Address 3"] != DBNull.Value)
                {
                    if (serviceAddress == null)
                        serviceAddress = new UsGeographicalAddress();
                    serviceAddress.StateCode = ParserAccountService.ExtractState(accountRow["Service Address 3"].ToString());
                    serviceAddress.ProvinceCode = serviceAddress.StateCode;
                    serviceAddress.State = serviceAddress.StateCode;
                }

                // Add the retail market.
                if (accountRow["Service Address 3"] != DBNull.Value)
                {
                    utilityAccount.RetailMarketCode = ParserAccountService.ExtractState(accountRow["Service Address 3"].ToString());
                }

                if (serviceAddress != null)
                    utilityAccount.ServiceAddress = serviceAddress;

                #region extract usages and any additional account fields

                string usageSheetName = string.Format("{0} - {1}", accountRow["#"], utilityAccount.AccountNumber);

                if (_importFileDataSet.Tables.Contains(usageSheetName) && _importFileDataSet.Tables[usageSheetName].Rows.Count > 0)
                {
                    DataTable usages = _importFileDataSet.Tables[usageSheetName];
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

                        var usage = ParserUsageService.GetUsage(excelRow, excelSheetname);
                        utilityAccount.Usages.Add(end, usage);

                        usage.AccountNumber = utilityAccount.AccountNumber;
                        usage.UtilityCode = utilityAccount.UtilityCode;
                        usage.UsageType = UsageType.File;
                        usage.UsageSource = UsageSource.User;

                        usage.BeginDate = new DateTime(start.Year, start.Month, start.Day, start.Hour, start.Minute, 0);
                        usage.EndDate = new DateTime(end.Year, end.Month, end.Day, end.Hour, end.Minute, 0);

                        usage.Days = ((TimeSpan)(end - start)).Days;


                        decimal actualAsDecimal, billedAsDecimal, monthlyPeakAsDecimal;
                        usage.MonthlyPeakDemandKw = decimal.TryParse(dr["Metered KW"].ToString(), out monthlyPeakAsDecimal) ? Convert.ToInt32(monthlyPeakAsDecimal) : 0;
                        usage.BillingDemandKw = decimal.TryParse(dr["Billed KW"].ToString(), out billedAsDecimal) ? Convert.ToInt32(billedAsDecimal) : 0;
                        usage.TotalKwh = decimal.TryParse(dr["Actual KWH"].ToString(), out actualAsDecimal) ? Convert.ToInt32(actualAsDecimal) : 0;

                        //var tdspCharges = dr["TDSP Charges"].ToString();



                        if (ii == accountSheet)
                        {

                            if (dr["Meter Read Cycle"] != DBNull.Value)
                                utilityAccount.MeterReadCycleId = (string)dr["Meter Read Cycle"];

                            if (dr["Load Profile"] != DBNull.Value)
                            {
                                var lsid = (string)dr["Load Profile"];
                                utilityAccount.LoadProfile = lsid;
                                utilityAccount.LoadShapeId = ParserAccountService.ExtractLoadShapeID(lsid);
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

        private void CheckEachDependentWorksheet(DataSet importFileDataSet)
        {
            DataTable accounts = importFileDataSet.Tables[WorksheetName];

            int excelRow;

            for (int i = 0; i < accounts.Rows.Count; i++)
            {
                excelRow = i + 1;

                string prefix = accounts.Rows[i]["#"].ToString();
                string ESIID = accounts.Rows[i]["ESI ID"].ToString();
                string sheetName = string.Format("{0} - {1}", prefix, ESIID);

                if (!importFileDataSet.Tables.Contains(sheetName))
                {
                    sheetName = string.Format("{0}-{1}", prefix, ESIID);

                    if (!importFileDataSet.Tables.Contains(sheetName))
                    {
                        Error = sheetName + " is a required sheet Excel file";
                        return;
                    }

                }

                DataTable dt = importFileDataSet.Tables[sheetName];

                VerifyColumnsExist(dt, "ESI ID");
                VerifyColumnsExist(dt, "Customer Name");
                VerifyColumnsExist(dt, "Rate Class/Code");
                VerifyColumnsExist(dt, "Zip Code");
                VerifyColumnsExist(dt, "Metered KW");
                VerifyColumnsExist(dt, "Actual KWH");
                VerifyColumnsExist(dt, "Billed KW");
                VerifyColumnsExist(dt, "TDSP Charges");
                VerifyColumnsExist(dt, "Start Date");
                VerifyColumnsExist(dt, "End Date");
                VerifyColumnsExist(dt, "Meter Read Cycle");
                VerifyColumnsExist(dt, "Service Address 1");
                VerifyColumnsExist(dt, "Service Address 2");
                VerifyColumnsExist(dt, "Service Address 3");
                VerifyColumnsExist(dt, "Load Profile");
                VerifyColumnsExist(dt, "Power Factor");
                VerifyColumnsExist(dt, "ERCOT Region");
                VerifyColumnsExist(dt, "Metered KVA");
                VerifyColumnsExist(dt, "Billed KVA");

            }
        }

        private void VerifyColumnsExist(DataTable dataTable, string requiredColumn)
        {
            if (!dataTable.Columns.Contains(requiredColumn))
            {
                Error = requiredColumn + " is a required column";
            }
        }
    }
}