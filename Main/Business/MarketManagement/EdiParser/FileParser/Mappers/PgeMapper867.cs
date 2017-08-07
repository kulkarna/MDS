namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
    using System;
    using System.Collections.Generic;
    using System.Data.SqlTypes;
    using System.Linq;

    /// <summary>
    /// PGE utility mapper for 867 file.
    ///  Maps markers in an EDI utility file to specific values in generic collections.
    /// </summary>
    public class PgeMapper867 : MapperBase
    {
        /// <summary>
        /// Default constructor
        /// </summary>
        public PgeMapper867() { }

        /// <summary>
        /// Constructor that takes market and utility codes
        /// </summary>
        /// <param name="utilityCode">Utility identifier</param>
        /// <param name="marketCode">Market Identifier</param>
        public PgeMapper867(string utilityCode, string marketCode)
        {
            this.utilityCode = utilityCode;
            this.marketCode = marketCode;
        }

        /// <summary>
        /// Maps markers in an EDI utility file to specific values in generic collections.
        /// </summary>
        /// <param name="fileRow">Generic collection of rows in utility file</param>
        /// <param name="rowDelimiter">Row delimiter</param>
        /// <param name="fieldDelimiter">field delimiter</param>
        /// <returns>Returns an Edi account list that contains accounts and their respective usage.</returns>
        public override EdiAccount MapData(FileRow fileRow, char rowDelimiter, char fieldDelimiter)
        {
            try
            {
                PgeMarker pgeMarker = new PgeMarker();

                account = new EdiAccount("", "", "", "", "", "", "", "", "", "", "", "", "");
                account.EdiUsageList = new EdiUsageList();
                account.IdrUsageList = new Dictionary<string, EdiIdrUsage>();
                decimal qty = 0;
                DateTime? transactionDate = null;

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
                        case "BPT":		// transaction set purpose code
                            {
                                cellContents = cells[pgeMarker.TransactionSetPurposeCodeCell].Trim();
                                transactionSetPurposeCode = cellContents == null ? "" : cellContents;
                                cellContents = "";
                                if (cells.Length > 3)
                                {
                                    string dateString = string.Empty;
                                    dateString = cells[pgeMarker.TransactionCreationDateCell].Trim();
                                    transactionDate = DateTryParse(dateString);
                                }
                                break;
                            }
                        case "PTD":		// new usage record..
                            {
                                if (qty > 0)
                                    account.EdiUsageList.Add(CreateEdiUsage(qty.ToString(), unitOfMeasurement, measurementSignificanceCode,
                                                transactionSetPurposeCode, meterNumber, beginDate, endDate.Substring(0, 8), ptdLoop));

                                ClearUsageVariables();
                                meterNumber = "";

                                cellContents = cells[pgeMarker.PtdLoopCell].Trim();
                                ptdLoop = cellContents == null ? "" : cellContents;

                                if (ptdLoop == "PM" && transactionSetPurposeCode.Equals("00"))
                                {
                                    ptdLoop = "SU";
                                    qty = 0;
                                    ClearIdrVariables();
                                }

                                if (ptdLoop == "SU")
                                    measurementSignificanceCode = "51";

                                break;
                            }
                        case "SE":		// account end **********
                            {
                                // only found billed files which have idr data but no total kwh for the period..
                                if (qty > 0)
                                    account.EdiUsageList.Add(CreateEdiUsage(qty.ToString(), unitOfMeasurement, measurementSignificanceCode,
                                        transactionSetPurposeCode, meterNumber, beginDate, endDate.Substring(0, 8), ptdLoop));

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
                                if ((transactionDate > (DateTime)SqlDateTime.MinValue && transactionDate < (DateTime)SqlDateTime.MaxValue))
                                    account.TransactionCreatedDate = transactionDate;
                                ResetAccountVariables();							// Ticket 17219
                                ptdLoop = null;

                                break;
                            }
                    }
                    switch (marker)
                    {
                        case "DTM150":		// begin date
                            {
                                cellContents = cells[pgeMarker.BeginDateCell].Trim();
                                beginDate = cellContents == null ? "" : cellContents;

                                break;
                            }
                        case "DTM151":		// end date
                            {
                                cellContents = cells[pgeMarker.EndDateCell].Trim();
                                endDate = cellContents == null ? "" : cellContents;

                                if (meterType == "1")
                                {
                                    idrDate = endDate.Substring(0, 8);
                                    idrInterval = endDate.Substring(8, 4);

                                    account.IdrUsageList[idrInterval + idrDate + unitOfMeasurement + meterNumber] = createIdrUsage(meterNumber, quantity, unitOfMeasurement, transactionSetPurposeCode, idrInterval, idrDate, ptdLoop);
                                }

                                break;
                            }
                        case "DTM514":		// exchange meter date
                            {
                                cellContents = cells[pgeMarker.BeginDateCell].Trim();
                                string TransitionDate = cellContents == null ? "" : cellContents;

                                if (beginDate == null | beginDate == "")
                                    beginDate = TransitionDate;
                                else
                                    endDate = TransitionDate;

                                break;
                            }
                        case "IEA1":		// end of fileContents **********
                            {
                                return account;
                            }
                        case "N18R":		// name key
                            {
                                cellContents = cells[pgeMarker.NameKeyCell].Trim();
                                nameKey = cellContents == null ? "" : cellContents;
                                break;
                            }
                        case "N18S":		// duns number
                            {
                                cellContents = cells[pgeMarker.DunsNumberCell].Trim();
                                dunsNumber = cellContents == null ? "" : cellContents;
                                break;
                            }
                        case "QTY32":
                        case "QTYAO": // IDR Data..
                            {
                                cellContents = cells[pgeMarker.QuantityAltCell].Trim();
                                quantity = cellContents == null ? "" : cellContents;

                                meterType = "1";

                                // keep track of period's total kwh
                                qty += Convert.ToDecimal(quantity);

                                break;
                            }
                        case "QTYKC":		// icap
                            {
                                cellContents = cells[pgeMarker.IcapCell].Trim();
                                icap = cellContents == null ? "" : cellContents;
                                break;
                            }
                        case "QTYKZ":		// tcap
                            {
                                cellContents = cells[pgeMarker.TcapCell].Trim();
                                tcap = cellContents == null ? "" : cellContents;
                                break;
                            }
                        case "QTYQD":		// begin usage
                            {
                                // NV - no value
                                if (!fc.Contains("NV"))
                                {
                                    cellContents = cells[pgeMarker.QuantityAltCell].Trim();
                                    quantity = cellContents == null ? "" : cellContents;

                                    cellContents = cells[pgeMarker.UnitOfMeasurementAltCell].Trim();
                                    unitOfMeasurement = cellContents == null ? "" : cellContents;
                                }

                                break;
                            }
                        case "QTY20":
                        case "QTY87":
                        case "QTY9H":
                            {
                                if (!fc.Contains("NV"))
                                {
                                    cellContents = cells[pgeMarker.QuantityAltCell].Trim();
                                    quantity = cellContents == null ? "" : cellContents;
                                    unitOfMeasurement = "D1";
                                }
                                break;
                            }
                        case "REF12":		// account number
                            {
                                cellContents = cells[pgeMarker.AccountNumberCell].Trim();
                                accountNumber = cellContents == null ? "" : cellContents;
                                break;
                            }
                        case "REF45":		// previous account number
                            {
                                cellContents = cells[pgeMarker.PreviousAccountNumberCell].Trim();
                                previousAccountNumber = cellContents == null ? "" : cellContents;
                                break;
                            }
                        case "REFBF":		//bill cycle
                            {
                                cellContents = cells[pgeMarker.BillGroupCell].Trim();
                                billGroup = cellContents == null ? "" : cellContents;
                                break;
                            }
                        case "REFLO":		//load profile
                            {
                                cellContents = cells[pgeMarker.LoadProfileCell].Trim();
                                loadProfile = cellContents == null ? "" : cellContents;
                                break;
                            }
                        case "REFMG":		// meter number
                            {
                                cellContents = cells[pgeMarker.MeterNumberCell].Trim();
                                meterNumber = cellContents == null ? "" : cellContents;
                                break;
                            }
                        case "REFMT":		// 5-character field that identifies the type of consumption (K1, KH, etc.) and the interval between measurements (i.e. MON, 015, etc.)
                            {
                                //								string Interval;

                                cellContents = cells[pgeMarker.UnitOfMeasurementCell].Trim();
                                unitOfMeasurement = cellContents == null ? "" : cellContents.Substring(0, 2);

                                //								Interval = cellContents == null ? "" : cellContents.Substring( 2, 3 );

                                //								interval = new TimeSpan( 0, Convert.ToInt32( Interval ), 0 );

                                break;
                            }
                        case "REFNH":		// rate class
                            {
                                cellContents = cells[pgeMarker.RateClassCell].Trim();
                                rateClass = cellContents == null ? "" : cellContents;
                                break;
                            }
                        case "REFSPL":		// zone
                            {
                                cellContents = cells[pgeMarker.ZoneCell].Trim();
                                zone = cellContents == null ? "" : cellContents;
                                break;
                            }
                        case "ST867":		// account start *******
                            {
                                // initialize with empty strings to avoid null value issues
                                account = new EdiAccount("", "", "", "", "", "", "", "", "", "", "", "", "");
                                break;
                            }
                    }
                }
                return account;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
