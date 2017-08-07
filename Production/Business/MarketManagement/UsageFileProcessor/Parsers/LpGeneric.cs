using System;
using System.Collections.Generic;
using System.Data;
using LibertyPower.Business.MarketManagement.UtilityManagement;
using LibertyPower.DataAccess.WorkbookAccess;
using UsageFileProcessor.Entities;
using UsageFileProcessor.Interfaces;
using UsageFileProcessor.Services;

namespace UsageFileProcessor.Parsers
{
    public class LpGeneric : IUsageFileParser
    {
        private const string WorksheetName = "GenericTemplate";
        private DataSet _importFileDataSet;

        public string Error { get; private set; }
        public bool IsParser(UsageFile file)
        {
            if (file.UtilityCode.Equals("lpgeneric", StringComparison.InvariantCultureIgnoreCase))
                return true;

            return false;
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
                Error = WorksheetName + " is a required sheet. Invalid LP Generic file.";
                return false;
            }

            var dataTable = _importFileDataSet.Tables[WorksheetName];

            VerifyColumnsExist(dataTable, "Customer Name");
            VerifyColumnsExist(dataTable, "Utility");
            VerifyColumnsExist(dataTable, "Congestion Zone");
            VerifyColumnsExist(dataTable, "Account Number");
            VerifyColumnsExist(dataTable, "MeterNum");
            VerifyColumnsExist(dataTable, "Voltage");
            VerifyColumnsExist(dataTable, "Load Shape ID");
            VerifyColumnsExist(dataTable, "Start Date");
            VerifyColumnsExist(dataTable, "End Date");
            VerifyColumnsExist(dataTable, "kwh");
            VerifyColumnsExist(dataTable, "ICAP");
            VerifyColumnsExist(dataTable, "TCAP");
            VerifyColumnsExist(dataTable, "Future ICAP");
            VerifyColumnsExist(dataTable, "Future ICAP");
            VerifyColumnsExist(dataTable, "Future TCAP");
            VerifyColumnsExist(dataTable, "Future TCAP Effective Date");


            return string.IsNullOrWhiteSpace(Error);
        }

        public IEnumerable<ParserAccount> Parse(UsageFile file)
        {
            var AccountNumber = string.Empty;
            var RowCount = 0;
            var Utility = "";
            var LoadProfile = "";
            var LoadShapeID = "";
            var importFileDataTable = _importFileDataSet.Tables[0];

            if (importFileDataTable.Rows.Count == 0)
            {
                Error = "No data found in file.";
            }

            RowCount = importFileDataTable.Rows.Count;
            var PrevAccountNumber = "";
            var PrevUtility = "";
            var accounts = new List<ParserAccount>();

            for (int i = 1; i < RowCount; i++)
            {
                if (Convert.IsDBNull(importFileDataTable.Rows[i]["Start Date"]) || Convert.IsDBNull(importFileDataTable.Rows[i]["End Date"]))
                {
                    Error = "One or more dates are missing in file.";
                    return null;
                }
                if (importFileDataTable.Rows[i]["Start Date"].ToString().Trim().Length == 0 ||
                         importFileDataTable.Rows[i]["End Date"].ToString().Trim().Length == 0)
                {
                    Error = "One or more dates are missing in file.";
                    return null;
                }
                if (Convert.IsDBNull(importFileDataTable.Rows[i]["Utility"]))
                {
                    Error = "One or more utility ids are missing in file.";
                    return null;
                }
                if (importFileDataTable.Rows[i]["Utility"].ToString().Trim().Length == 0)
                {
                    Error = "One or more utility ids are missing in file.";
                    return null;
                }
                if (Convert.IsDBNull(importFileDataTable.Rows[i]["Account Number"]))
                {
                    Error = "One or more account numbers are missing in file.";
                    return null;
                }
                if (importFileDataTable.Rows[i]["Account Number"].ToString().Trim().Length == 0)
                {
                    Error = "One or more account numbers are missing in file.";
                    return null;
                }


                AccountNumber = ((Convert.IsDBNull(importFileDataTable.Rows[i]["Account Number"])) ? "" : importFileDataTable.Rows[i]["Account Number"].ToString().ToUpper().Replace("ESIID", "").Replace(" ", ""));
                AccountNumber = AccountNumber.Trim();
                Utility = ((Convert.IsDBNull(importFileDataTable.Rows[i]["Utility"])) ? "" : importFileDataTable.Rows[i]["Utility"].ToString().ToUpper());
                Utility = Utility.Trim();
                if (accounts.Exists(a => string.Equals(a.AccountNumber, AccountNumber) && string.Equals(a.UtilityCode, Utility)))
                    continue;

                var account = ParserAccountService.GetAccount(i);
                
                account.AccountNumber = AccountNumber;
                account.UtilityCode = Utility;
                
                accounts.Add(account);
            }

            

            for (int i = 0; i < RowCount; i++)
            {
                // only process row if account number is present and correct number of columns



                if (importFileDataTable.Columns.Count < 10) continue;

                 AccountNumber = ((Convert.IsDBNull(importFileDataTable.Rows[i]["Account Number"])) ? "" : importFileDataTable.Rows[i]["Account Number"].ToString().ToUpper().Replace("ESIID", "").Replace(" ", ""));

               AccountNumber = AccountNumber.Trim();

                var account = accounts.Find(a => string.Equals(a.AccountNumber, AccountNumber, StringComparison.InvariantCultureIgnoreCase));
                if(account == null)
                    continue;

                var CustomerName = ((Convert.IsDBNull(importFileDataTable.Rows[i]["Customer Name"])) ? "" : importFileDataTable.Rows[i]["Customer Name"].ToString());
                Utility = ((Convert.IsDBNull(importFileDataTable.Rows[i]["Utility"])) ? "" : importFileDataTable.Rows[i]["Utility"].ToString().ToUpper());
                var Zone = ((Convert.IsDBNull(importFileDataTable.Rows[i]["Congestion Zone"])) ? "" : importFileDataTable.Rows[i]["Congestion Zone"].ToString());
                

                var MeterNumber = ((Convert.IsDBNull(importFileDataTable.Rows[i]["MeterNum"])) ? "" : importFileDataTable.Rows[i]["MeterNum"].ToString());
                var Voltage = ((Convert.IsDBNull(importFileDataTable.Rows[i]["Voltage"])) ? "" : importFileDataTable.Rows[i]["Voltage"].ToString());
                LoadShapeID = ((Convert.IsDBNull(importFileDataTable.Rows[i]["Load Shape ID"])) ? "" : importFileDataTable.Rows[i]["Load Shape ID"].ToString());
                var StartDate = DateTime.Parse((importFileDataTable.Rows[i]["Start Date"]).ToString());
                var EndDate = DateTime.Parse((importFileDataTable.Rows[i]["End Date"]).ToString());
                var KWH = (int)Convert.ToDouble(((Convert.IsDBNull(importFileDataTable.Rows[i]["kwh"])) ? 0 : importFileDataTable.Rows[i]["kwh"]));
                var TCAP = Convert.ToDecimal(((Convert.IsDBNull(importFileDataTable.Rows[i]["TCAP"])) ? -1 : importFileDataTable.Rows[i]["TCAP"]));
                var TotalDays = Convert.ToInt32(ParserUsageService.DateDiff(ParserUsageService.DateInterval.Day, StartDate, EndDate));
                var ICAP =  Convert.ToDecimal(((Convert.IsDBNull(importFileDataTable.Rows[i]["ICAP"])) ? -1 : importFileDataTable.Rows[i]["ICAP"]));

                string marketCode = MarketFactory.GetRetailMarketByUtility(Utility).ToUpper();

                decimal? FutureIcap = null;
                DateTime? FutureIcapEffectiveDate = null;
                decimal? FutureTcap = null;
                DateTime? FutureTcapEffectiveDate = null;

                FutureIcap = Convert.ToDecimal(((Convert.IsDBNull(importFileDataTable.Rows[i]["Future ICAP"])) ? -1 : importFileDataTable.Rows[i]["Future ICAP"]));

                string bufFutureIcapDateString = importFileDataTable.Rows[i]["Future ICAP Effective Date"].ToString();
                DateTime bufutureIcapDate = DateTime.MinValue;
                if (DateTime.TryParse(bufFutureIcapDateString, out bufutureIcapDate) == true)
                    FutureIcapEffectiveDate = bufutureIcapDate;
                else
                {
                    Error = "Future ICAP Effective Date must be specified for account " + AccountNumber;
                    return null;
                }

                FutureTcap = Convert.ToDecimal(((Convert.IsDBNull(importFileDataTable.Rows[i]["Future TCAP"])) ? -1 : importFileDataTable.Rows[i]["Future TCAP"]));

                string bufFutureTcapDateString = importFileDataTable.Rows[i]["Future TCAP Effective Date"].ToString();
                DateTime bufutureTcapDate = DateTime.MinValue;
                if (DateTime.TryParse(bufFutureTcapDateString, out bufutureTcapDate) == true)
                    FutureTcapEffectiveDate = bufutureTcapDate;
                else
                {
                    Error = "Future TCAP Effective Date must be specified for account " + AccountNumber;
                    return null;
                }
                

                if (account.Usages.Count == 0)
                {
                    account.CustomerName = CustomerName;
                    account.RetailMarketCode = marketCode;
                    account.Voltage = Voltage;
                    account.ZoneCode = Zone;
                    account.Tcap = TCAP;
                    account.Icap = ICAP;
                    account.LoadProfile = LoadProfile;
                    account.LoadShapeId = LoadShapeID;
                    account.FutureICap = FutureIcap.Value;
                    account.FutureTCap = FutureTcap.Value;
                    account.FutureICapEffectiveDate = FutureIcapEffectiveDate.Value.ToShortDateString();
                    account.FutureTCapEffectiveDate = FutureTcapEffectiveDate.Value.ToShortDateString();
                }

                #region verify no conflicting data in extended fields

                if (FutureIcap != -1 && !FutureIcap.Value.Equals(account.FutureICap))
                {
                    Error = "Future Icap has multiple values for account : " + AccountNumber;
                    return null;
                }

                if (FutureTcap != -1 && !FutureTcap.Value.Equals(account.FutureTCap))
                {
                    Error = "Future Tcap has multiple values for account : " + AccountNumber;
                    return null;
                }

                if (!string.IsNullOrWhiteSpace(Zone) && !Zone.Equals(account.ZoneCode, StringComparison.InvariantCultureIgnoreCase))
                {
                    Error = "Congestion Zone has multiple values for account : " + AccountNumber;
                    return null;
                }
                if (!string.IsNullOrWhiteSpace(Voltage) && !Voltage.Equals(account.Voltage, StringComparison.InvariantCultureIgnoreCase))
                {
                    Error = "Voltage has multiple values for account : " + AccountNumber;
                    return null;
                }

                if (!string.IsNullOrWhiteSpace(LoadShapeID) && !LoadShapeID.Equals(account.LoadShapeId, StringComparison.InvariantCultureIgnoreCase))
                {
                    Error = "Load Shape ID has multiple values for account : " + AccountNumber;
                    return null;
                }
                if (ICAP != -1 && !ICAP.Equals(account.Icap))
                {
                    Error = "ICAP has multiple values for account : " + AccountNumber;
                    return null;
                }
                if (TCAP != -1 && !TCAP.Equals(account.Tcap))
                {
                    Error = " has multiple values for account : " + AccountNumber;
                    return null;
                }


                #endregion
                

                var usage = ParserUsageService.GetUsage(i);

                usage.AccountNumber = AccountNumber;
                usage.BeginDate = StartDate;
                usage.EndDate = EndDate;
                usage.MeterNumber = MeterNumber;
                usage.TotalKwh = KWH;
                usage.Days = TotalDays;
                usage.UtilityCode = Utility;
                usage.UsageType = UsageType.File;
                usage.UsageSource = UsageSource.User;

                account.Usages.Add(usage.EndDate, usage);

                PrevAccountNumber = AccountNumber;
                PrevUtility = Utility;

            }
      
            return accounts;
        }

        private bool DoExtendedFieldsExist(DataTable importFileDataTable)
        {
            var extendedColumns = new string[] {"Future ICAP", "Future ICAP Effective Date", "Future TCAP", "Future TCAP Effective Date", "Lock Congestion Zone", "Lock Voltage", 
                "Lock Load Shape ID", "Lock ICAP", "Lock Future ICAP", "Lock TCAP", "Lock Future TCAP"};

            foreach (var column in extendedColumns)
                if (importFileDataTable.Columns.Contains(column) == false)
                    return false;

            return true;
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