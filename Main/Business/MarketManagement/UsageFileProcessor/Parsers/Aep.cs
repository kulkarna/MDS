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
    public class Aep : IUsageFileParser
    {
        private const string WorksheetName = "USAGE HIST DATA";
        private DataSet _importFileDataSet;
        private string _utilityCode;
        public string Error { get; private set; }
        public bool IsParser(UsageFile file)
        {
            return file.UtilityCode.Equals("aepce", StringComparison.InvariantCultureIgnoreCase)
                || file.UtilityCode.Equals("aepno", StringComparison.InvariantCultureIgnoreCase);;
        }

        public bool IsValidFileTemplate(UsageFile file)
        {
            // Validation: make sure the context specifies an Excel file.
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

            DataTable dataTable = _importFileDataSet.Tables[WorksheetName];

            VerifyColumnsExist(dataTable, "ESI ID");
            VerifyColumnsExist(dataTable, "Customer Name");
            VerifyColumnsExist(dataTable, "Rate Class/Code");
            VerifyColumnsExist(dataTable, "Zip Code");
            VerifyColumnsExist(dataTable, "Metered KW");
            VerifyColumnsExist(dataTable, "Actual KWH");
            VerifyColumnsExist(dataTable, "Billed KW");
            VerifyColumnsExist(dataTable, "TDSP Charges");
            VerifyColumnsExist(dataTable, "Start Date");
            VerifyColumnsExist(dataTable, "End Date");
            VerifyColumnsExist(dataTable, "Meter Read Cycle");
            VerifyColumnsExist(dataTable, "Service Address 1");
            VerifyColumnsExist(dataTable, "Service Address 2");
            VerifyColumnsExist(dataTable, "Service Address 3");
            VerifyColumnsExist(dataTable, "Load Profile");
            VerifyColumnsExist(dataTable, "Power Factor");
            VerifyColumnsExist(dataTable, "ERCOT Region");

            return string.IsNullOrWhiteSpace(Error);
        }

        public IEnumerable<ParserAccount> Parse(UsageFile file)
        {
            _utilityCode = file.UtilityCode;
            var accounts = new List<ParserAccount>();
            var utilities = UtilityService.GetUtilities();
            var dt = _importFileDataSet.Tables["USAGE HIST DATA"];
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
                if (DataSetService.IsRowEmpty(dt.Rows[i], false) == false)
                {
                    string nextAccountNumber = dt.Rows[i]["ESI ID"].ToString();

                    ParserAccount account = null;
                    if (i == dt.Rows.Count - 1)
                    {
                        rows.Add(dt.Rows[i]); //add the final row
                        account = GetUtilityAccountAndUsagesAep(file.UtilityCode, rows, utilities);
                        if (account != null)
                            accounts.Add(account);
                    }
                    else if (string.Compare(accountNumber, nextAccountNumber) != 0)
                    {

                        accountNumber = nextAccountNumber; //to begin the next group

                        account = GetUtilityAccountAndUsagesAep(file.UtilityCode, rows, utilities);

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

        private void VerifyColumnsExist(DataTable dataTable, string requiredColumn)
        {
            if (!dataTable.Columns.Contains(requiredColumn))
            {
                Error = requiredColumn + " is a required column";
            }
        }

        private static ParserAccount GetUtilityAccountAndUsagesAep(string utilityCode, List<DataRow> rows, UtilityDictionary utilities)
        {
            // Parse an account and usages from the collection
            ParserAccount utilityAccount = null;

            int accountRowIndex = ParserAccountService.FindMostRecentRowToBaseAccountOn(rows);

            #region Create Account and Populate

            DataRow accountRow = rows[accountRowIndex];
            int excelRow = 0;

            if (accountRow["Excel Row"] != DBNull.Value)
                excelRow = (int)accountRow["Excel Row"];

            utilityAccount = ParserAccountService.GetAccount(excelRow);

            if (accountRow["ESI ID"] != DBNull.Value)
                utilityAccount.AccountNumber = (string)accountRow["ESI ID"].ToString().Replace("'", ""); ;

            UtilityList utils = UtilityService.GetUtilitiesMatchingUtilityCode(utilityCode, utilities);

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
                utilityAccount.LoadShapeId = ParserAccountService.ExtractLoadShapeID(lsid);
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
            #endregion

            #region Create a usage from each row and add to account

            foreach (DataRow row in rows)
            {
                if (row["Excel Row"] != DBNull.Value)
                {
                    excelRow = (int)row["Excel Row"];
                }

                var usage = ParserUsageService.GetUsage(excelRow);

                if (row["ESI ID"] != DBNull.Value)
                {
                    usage.AccountNumber = row["ESI ID"].ToString();
                }


                DateTime? start = ParserAccountService.ConvertToDate(row["Start Date"].ToString());
                if (start == null)
                {
                    start = DateTime.MinValue;
                }

                DateTime? end = ParserAccountService.ConvertToDate(row["End Date"].ToString());
                if (end == null)
                {
                    end = DateTime.MinValue;
                }

                usage.BeginDate = new DateTime(start.Value.Year, start.Value.Month, start.Value.Day, start.Value.Hour, start.Value.Minute, 0);
                usage.EndDate = new DateTime(end.Value.Year, end.Value.Month, end.Value.Day, end.Value.Hour, end.Value.Minute, 0);
                usage.Days = ((TimeSpan)(end - start)).Days;


                decimal actualAsDecimal, billedAsDecimal, monthlyPeakAsDecimal;
                usage.MonthlyPeakDemandKw = decimal.TryParse(row["Metered KW"].ToString(), out monthlyPeakAsDecimal) ? Convert.ToInt32(monthlyPeakAsDecimal) : 0;
                usage.BillingDemandKw = decimal.TryParse(row["Billed KW"].ToString(), out billedAsDecimal) ? Convert.ToInt32(billedAsDecimal) : 0;
                usage.TotalKwh = decimal.TryParse(row["Actual KWH"].ToString(), out actualAsDecimal) ? Convert.ToInt32(actualAsDecimal) : 0;

                //var tdspCharges = row["TDSP Charges"].ToString();

                usage.UtilityCode = utilityAccount.UtilityCode;
                usage.UsageType = UsageType.File;
                usage.UsageSource = UsageSource.User;
                utilityAccount.Usages.Add(end.Value, usage);
            }

            #endregion

            return utilityAccount;
        }
    }
}