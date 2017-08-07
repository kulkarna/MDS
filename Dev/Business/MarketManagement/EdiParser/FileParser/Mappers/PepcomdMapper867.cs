namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using LibertyPower.Business.MarketManagement.UtilityManagement;
    using LibertyPower.Business.MarketManagement.EdiParser.FormatParser;
    using System.Data.SqlTypes;

    /// <summary>
    /// PEPCO-MD utility mapper for 867 file.
    ///  Maps markers in an EDI utility file to specific values in generic collections.
    /// </summary>
    public class PepcomdMapper867 : MapperBase
    {
        #region Fields

        /// <summary>
        /// Represents the Historical Usage data (DD).
        /// </summary>
        private const string historicalUsage = "DD";

        /// <summary>
        /// Represents the Historical Interval Summary data (C1s).
        /// </summary>
        private const string historicalIntervalSummary = "C1";

        #endregion

        #region Constructor

        /// <summary>
        /// Default constructor
        /// </summary>
        public PepcomdMapper867() { }

        /// <summary>
        /// Constructor that takes market and utility codes
        /// </summary>
        /// <param name="utilityCode">Utility identifier</param>
        /// <param name="marketCode">Market Identifier</param>
        public PepcomdMapper867(string utilityCode, string marketCode)
        {
            this.utilityCode = utilityCode;
            this.marketCode = marketCode;
        }

        #endregion Constructor

        #region Methods

        /// <summary>
        /// Maps markers in an EDI utility file to specific values in generic collections.
        /// </summary>
        /// <param name="fileRow">Generic collection of rows in utility file</param>
        /// <param name="rowDelimiter">Row delimiter</param>
        /// <param name="fieldDelimiter">field delimiter</param>
        /// <returns>Returns an Edi account list that contains accounts and their respective usage.</returns>
        public override EdiAccount MapData(FileRow fileRow, char rowDelimiter, char fieldDelimiter)
        {
            bool icapDatesMissing = false;
            bool tcapDatesMissing = false;
            icapList = new IcapList();
            tcapList = new TcapList();
            DateTime? transactionDate = null;
            PepcomdMarker pepcomdMarker = new PepcomdMarker();
            account = new EdiAccount("", "", "", "", "", "", "", "", "", "", "", "", "");
            usageListTemp = new EdiUsageList();
            account.EdiUsageList = new EdiUsageList();
            account.IdrUsageList = new Dictionary<string, EdiIdrUsage>();
            string[] fileCellList = fileRow.Contents.Split(rowDelimiter);
            foreach (string fc in fileCellList)
            {
                string[] cells = fc.Split(fieldDelimiter);
                string cell0 = cells[0];
                string cell1 = string.Empty;
                string marker = string.Empty;
                if (cells.Count() > 1)
                {
                    cell1 = cells[1];
                    marker = cell0 + cell1;
                }
                string cellContents;

                switch (cell0)
                {
                    case "SE": // account end **********
                        {

                            AddUsagesToList(usageListTemp, account.EdiUsageList, beginDate, endDate, ptdLoop);
                            account.AccountNumber = accountNumber;
                            account.BillingAccount = billingAccountNumber;
                            account.CustomerName = customerName;
                            account.DunsNumber = dunsNumber;
                            account.Icap = (icap != null && icap.Length > 0) ? Convert.ToDecimal(icap) : Convert.ToDecimal(-1);
                            account.NameKey = nameKey;
                            account.PreviousAccountNumber = previousAccountNumber;
                            account.RateClass = rateClass;
                            account.RetailMarketCode = marketCode;
                            account.Tcap = (tcap != null && tcap.Length > 0) ? Convert.ToDecimal(tcap) : Convert.ToDecimal(-1);
                            account.UtilityCode = utilityCode;
                            account.ZoneCode = zone;
                            account.LoadProfile = loadProfile;
                            account.BillGroup = (!(string.IsNullOrEmpty(billGroup)) && billGroup.Length > 0) ? billGroup : "-1";
                            account.IcapList = ((string.IsNullOrEmpty(icap))) ? null : icapList;
                            account.TcapList = ((string.IsNullOrEmpty(tcap))) ? null : tcapList;
                            if ((transactionDate > (DateTime)SqlDateTime.MinValue && transactionDate < (DateTime)SqlDateTime.MaxValue))
                                account.TransactionCreatedDate = transactionDate;
                            ResetAccountVariables();    // Ticket 17219
                            ptdLoop = null;
                            break;
                        }
                    case "PTD": // new usage record..
                        {

                            ProcessPhiHu(pepcomdMarker, cells);
                            break;
                        }
                    case "BPT": // transaction set purpose code
                        {
                            cellContents = cells[pepcomdMarker.TransactionSetPurposeCodeCell].Trim();
                            transactionSetPurposeCode = cellContents == null ? "" : cellContents;
                            cellContents = "";

                            if (cells.Length > 3)
                            {
                                string dateString = string.Empty;
                                dateString = cells[pepcomdMarker.TransactionCreationDateCell].Trim();
                                transactionDate = DateTryParse(dateString);

                                //Distinguishing between Historical data
                                if (cells[4] == historicalUsage)
                                {
                                    historicalSection = HistoricalSection.HU;
                                }
                                else if (cells[4] == historicalIntervalSummary)
                                {
                                    historicalSection = HistoricalSection.HI;
                                }
                            }
                            break;
                        }
                }
                switch (marker)
                {
                    case "N18S": // duns number
                        {
                            cellContents = cells[pepcomdMarker.DunsNumberCell].Trim();
                            dunsNumber = cellContents == null ? "" : cellContents;
                            break;
                        }
                    case "IEA1": // end of fileContents **********
                        {
                            return account;
                        }
                    case "ST867": // account start *******
                        {
                            // initialize with empty strings to avoid null value issues
                            account = new EdiAccount("", "", "", "", "", "", "", "", "", "", "", "", "");
                            break;
                        }
                    case "N18R": // customer name
                        {
                            cellContents = cells[pepcomdMarker.CustomerNameCell].Trim();
                            customerName = cellContents == null ? "" : cellContents;
                            break;
                        }
                    case "REF12": // account number
                        {
                            cellContents = cells[pepcomdMarker.AccountNumberCell].Trim();
                            accountNumber = cellContents == null ? "" : cellContents;
                            break;
                        }
                    case "REF45": // previous account number
                        {
                            cellContents = cells[pepcomdMarker.PreviousAccountNumberCell].Trim();
                            previousAccountNumber = cellContents == null ? "" : cellContents;
                            break;
                        }
                    case "REFMG": // meter number
                        {
                            cellContents = cells[pepcomdMarker.MeterNumberCell].Trim();
                            meterNumber = cellContents == null ? "" : cellContents;
                            break;
                        }
                    case "REFNH": // rate class
                        {
                            cellContents = cells[pepcomdMarker.RateClassCell].Trim();
                            rateClass = cellContents == null ? "" : cellContents;
                            break;
                        }
                    case "QTYKC": // icap
                        {
                            cellContents = cells[pepcomdMarker.IcapCell].Trim();
                            icap = cellContents == null ? "" : cellContents;
                            icapList.Add(new Icap((icap != null && icap.Length > 0) ? Convert.ToDecimal(icap) : -1m));
                            if (icap != null && icap.Length > 0)
                            {
                                icapDatesMissing = true;
                                tcapDatesMissing = false;
                            }
                            else
                            {
                                icapDatesMissing = false;
                                tcapDatesMissing = false;
                            }
                            break;
                        }
                    case "QTYKZ": // tcap
                        {
                            cellContents = cells[pepcomdMarker.TcapCell].Trim();
                            tcap = cellContents == null ? "" : cellContents;
                            tcapList.Add(new Tcap((tcap != null && tcap.Length > 0) ? Convert.ToDecimal(tcap) : -1m));
                            if (tcap != null && tcap.Length > 0)
                            {
                                tcapDatesMissing = true;
                                icapDatesMissing = false;
                            }
                            else
                            {
                                icapDatesMissing = false;
                                tcapDatesMissing = false;
                            }
                            break;
                        }
                    case "DTM007": // date range for icap or tcap
                        {
                            cellContents = cells[pepcomdMarker.IcapTcapDateRangeCell].Trim();
                            string dateRangeStr = cellContents == null ? "" : cellContents;
                            if (dateRangeStr.Length == 17) // if string is 17 characters then most likely valid
                            {
                                DateTime beginDate;
                                DateTime endDate;
                                string[] dateRanges = dateRangeStr.Split(Convert.ToChar("-"));
                                if (dateRanges.Length == 2)
                                {
                                    string bDate = FormatDateString(dateRanges[0]);
                                    string eDate = FormatDateString(dateRanges[1]);

                                    if (DateTime.TryParse(bDate, out beginDate) && DateTime.TryParse(eDate, out endDate))
                                    {
                                        // should be the very next iteration after obtaining icap or tcap values, 
                                        // need to determine which values the dates are for.
                                        if (icapDatesMissing)
                                        {
                                            icapList[icapList.Count - 1].BeginDate = beginDate;
                                            icapList[icapList.Count - 1].EndDate = endDate;
                                        }
                                        if (tcapDatesMissing)
                                        {
                                            tcapList[tcapList.Count - 1].BeginDate = beginDate;
                                            tcapList[tcapList.Count - 1].EndDate = endDate;
                                        }
                                    }
                                }
                                icapDatesMissing = false;
                                tcapDatesMissing = false;
                            }
                            break;
                        }
                    case "REFSPL": // zone
                        {
                            cellContents = cells[pepcomdMarker.ZoneCell].Trim();
                            zone = cellContents == null ? "" : cellContents;
                            break;
                        }
                    case "REFBF":	//bill cycle
                        {
                            cellContents = cells[pepcomdMarker.BillGroupCell].Trim();
                            billGroup = cellContents == null ? "" : cellContents;
                            break;
                        }
                    case "REFLO":	//load profile
                        {
                            cellContents = cells[pepcomdMarker.LoadProfileCell].Trim();
                            loadProfile = cellContents == null ? "" : cellContents;
                            break;
                        }
                    case "MEAAA": // kwh, uom, measurement significance code
                    case "MEAAE":
                    case "MEAEA":
                    case "MEAEE":
                        {
                            cellContents = cells[pepcomdMarker.QuantityCell].Trim();
                            quantity = cellContents == null ? "" : cellContents;

                            cellContents = cells[pepcomdMarker.UnitOfMeasurementCell].Trim();
                            unitOfMeasurement = cellContents == null ? "" : cellContents;

                            cellContents = cells[pepcomdMarker.MeasurementSignificanceCodeCell].Trim();
                            measurementSignificanceCode = cellContents == null ? "" : cellContents;

                            if (ptdLoop.Equals("PM"))
                                usageListTemp.Add(CreateEdiUsage(quantity, unitOfMeasurement, measurementSignificanceCode,
                                            transactionSetPurposeCode, meterNumber, ptdLoop));

                            break;
                        }
                    case "DTM150": // begin date
                        {
                            cellContents = cells[pepcomdMarker.BeginDateCell].Trim();
                            beginDate = cellContents == null ? "" : cellContents;
                            break;
                        }
                    case "DTM151": // end date
                        {
                            cellContents = cells[pepcomdMarker.EndDateCell].Trim();
                            endDate = cellContents == null ? "" : cellContents;

                            // summary has just one ptd marker; for historical, end date is last row..
                            if ((ptdLoop.Equals("SU") && transactionSetPurposeCode.Equals("52")))
                                account.EdiUsageList.Add(
                                    CreateEdiUsage(
                                    quantity,
                                    unitOfMeasurement,
                                    measurementSignificanceCode,
                                    transactionSetPurposeCode, 
                                    meterNumber, 
                                    beginDate, 
                                    endDate,
                                    ptdLoop, 
                                    historicalSection
                                    ));

                            break;
                        }
                    case "DTM514": // exchange meter date
                        {
                            cellContents = cells[pepcomdMarker.BeginDateCell].Trim();
                            string TransitionDate = cellContents == null ? "" : cellContents;

                            if (beginDate == null | beginDate == "")
                                beginDate = TransitionDate;
                            else
                                endDate = TransitionDate;

                            break;
                        }
                    case "DTM582": // IDR Date for PHI Utilities.
                        {
                            ProcessPhiHi582(pepcomdMarker, cells);
                            break;
                        }
                    case "QTYD1":
                    case "QTYQD": // begin usage
                        {
                            // NV - no value
                            if (!fc.Contains("NV"))
                            {
                                cellContents = cells[pepcomdMarker.QuantityAltCell].Trim();
                                quantity = cellContents == null ? "" : cellContents;

                                cellContents = cells[pepcomdMarker.UnitOfMeasurementAltCell].Trim();
                                unitOfMeasurement = cellContents == null ? "" : cellContents;

                                // summary has just one ptd marker; for billed, qty is last row..
                                if ((ptdLoop.Equals("SU") && transactionSetPurposeCode != "52") || ptdLoop.Equals("BC"))
                                    account.EdiUsageList.Add(CreateEdiUsage(
                                        quantity, unitOfMeasurement, measurementSignificanceCode, transactionSetPurposeCode, meterNumber, beginDate, endDate, ptdLoop));
                            }
                            break;
                        }
                    case "QTY20":
                    case "QTY87":
                    case "QTY9H":
                        {
                            if (!fc.Contains("NV"))
                            {
                                cellContents = cells[pepcomdMarker.QuantityAltCell].Trim();
                                quantity = cellContents == null ? "" : cellContents;
                                unitOfMeasurement = "D1";
                            }
                            break;
                        }
                }
            }
            return account;
        }

        #endregion
    }
}