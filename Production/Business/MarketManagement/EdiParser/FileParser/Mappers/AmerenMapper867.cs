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
    /// AMEREN utility mapper for 867 file.
    ///  Maps markers in an EDI utility file to specific values in generic collections.
    /// </summary>
    public class AmerenMapper867 : MapperBase
    {
        /// <summary>
        /// Default constructor
        /// </summary>
        public AmerenMapper867() { }

        /// <summary>
        /// Constructor that takes market and utility codes
        /// </summary>
        /// <param name="utilityCode">Utility identifier</param>
        /// <param name="marketCode">Market Identifier</param>
        public AmerenMapper867(string utilityCode, string marketCode)
        {
            this.utilityCode = utilityCode;
            this.marketCode = marketCode;
        }

        private void updateLightingDetails(EdiUsageList list)
        {
            IEnumerable<EdiUsage> lightningMcQueen = from t in list where t.MeterNumber == "Lighting" select t;

            if (lightningMcQueen.Count() > 0)
            {
                DateTime begin = DateTime.MinValue;
                DateTime end = DateTime.MaxValue;
                decimal kwh = 0;
                string meter = "";

                foreach (EdiUsage item in list)
                {
                    if (item.BeginDate == begin && item.EndDate == end && item.Quantity == kwh && item.MeterNumber == "")
                        item.MeterNumber = meter;

                    begin = item.BeginDate;
                    end = item.EndDate;
                    kwh = item.Quantity;
                    meter = item.MeterNumber;
                }
            }
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
            AmerenMarker amerenMarker = new AmerenMarker();

            account = new EdiAccount("", "", "", "", "", "", "", "", "", "", "", "", "");
            account.EdiUsageList = new EdiUsageList();
            account.IdrUsageList = new Dictionary<string, EdiIdrUsage>();
            decimal qty = 0;
            DateTime? transactionDate = null;
            string refJh = string.Empty;
            bool isKh = true;
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
                            if (ptdLoop.Equals("BC") && meterNumber == "" && transactionSetPurposeCode == "00")	// add LITE detail..
                                account.EdiUsageList.Add(CreateEdiUsage(quantity, unitOfMeasurement, measurementSignificanceCode,
                                    transactionSetPurposeCode, meterNumber, beginDate, endDate, ptdLoop, serviceDeliveryPoint));

                            if (qty != 0 && account.IdrUsageList.Count() != 0)
                                account.EdiUsageList.Add(CreateEdiUsage(Math.Round(qty).ToString(), "KH", measurementSignificanceCode,
                                                          transactionSetPurposeCode, meterNumber, beginDate, endDate.Substring(0, 8), ptdLoop));

                            updateLightingDetails(account.EdiUsageList);

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
                            account.MeterNumber = meterNumber;
                            account.ServiceDeliveryPoint = serviceDeliveryPoint;
                            account.UtilityCode = utilityCode;
                            account.ZoneCode = zone;
                            account.LoadProfile = loadProfile;
                            account.BillGroup = (!(string.IsNullOrEmpty(billGroup)) && billGroup.Length > 0) ? billGroup : "-1";
                            account.BillingType = billingType;
                            account.BillCalculation = billCalculation;
                            account.Voltage = voltage;
                            if ((transactionDate > (DateTime)SqlDateTime.MinValue && transactionDate < (DateTime)SqlDateTime.MaxValue))
                                account.TransactionCreatedDate = transactionDate;
                            qty = 0;
                            ResetAccountVariables();							// Ticket 17219
                            ptdLoop = null;
                            break;
                        }
                    case "PTD":													// new usage record..
                        {
                            if (qty != 0 && account.IdrUsageList.Count() != 0)
                                account.EdiUsageList.Add(CreateEdiUsage(Math.Round(qty).ToString(), "KH", measurementSignificanceCode,
                                                          transactionSetPurposeCode, meterNumber, beginDate, endDate.Substring(0, 8), ptdLoop));

                            qty = 0;
                            // skip 1st record + no double dipping (since summary-historical has only one ptd marker) + skip idr data (PM) for now..
                            ClearUsageVariables();
                            meterNumber = "";

                            cellContents = cells[amerenMarker.PtdLoopCell].Trim();
                            ptdLoop = cellContents == null ? "" : cellContents;

                            if (ptdLoop == "SU")
                                measurementSignificanceCode = "51";

                            break;
                        }
                    case "BPT": // transaction set purpose code
                        {
                            cellContents = cells[amerenMarker.TransactionSetPurposeCodeCell].Trim();
                            transactionSetPurposeCode = cellContents == null ? "" : cellContents;
                            if (cells.Length > 3)
                            {
                                string dateString = string.Empty;
                                dateString = cells[amerenMarker.TransactionCreationDateCell].Trim();
                                transactionDate = DateTryParse(dateString);
                            }
                            break;
                        }
                }
                switch (marker)
                {
                    case "N18S": // duns number
                        {
                            cellContents = cells[amerenMarker.DunsNumberCell].Trim();
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
                            cellContents = cells[amerenMarker.CustomerNameCell].Trim();
                            customerName = cellContents == null ? "" : cellContents;
                            break;
                        }
                    // PBI 129451 Added by Vikas Sharma
                    case "REFJH":
                        {
                            cellContents = cells[amerenMarker.RefJhCell].Trim();
                            refJh = cellContents == null ? "" : cellContents;
                            break;
                        }
                    case "REF12": // account number
                        {
                            cellContents = cells[amerenMarker.AccountNumberCell].Trim();
                            accountNumber = cellContents == null ? "" : cellContents;
                            break;
                        }
                    case "REF45": // previous account number
                        {
                            cellContents = cells[amerenMarker.PreviousAccountNumberCell].Trim();
                            previousAccountNumber = cellContents == null ? "" : cellContents;
                            break;
                        }
                    case "REFLU":	// location number
                        {
                            cellContents = cells[amerenMarker.ServiceDeliveryPointCell].Trim();
                            serviceDeliveryPoint = cellContents == null ? "" : cellContents;
                            break;
                        }
                    case "REFMG":	// meter number
                        {
                            cellContents = cells[amerenMarker.MeterNumberCell].Trim();
                            meterNumber = cellContents == null ? "" : cellContents;
                            break;
                        }
                    case "REFNH": // rate class
                        {
                            cellContents = cells[amerenMarker.RateClassCell].Trim();
                            rateClass = cellContents == null ? "" : cellContents;
                            break;
                        }
                    case "REFSV":
                        {
                            cellContents = cells[amerenMarker.VoltageCell].Trim();
                            voltage = cellContents == null ? "" : cellContents;
                            break;
                        }
                    case "QTYKZ": // icap
                        {
                            cellContents = cells[amerenMarker.IcapCell].Trim();
                            icap = cellContents == null ? "" : cellContents;
                            break;
                        }
                    //case "QTYKC": // icap
                    //    {
                    //        cellContents = cells[amerenMarker.IcapCell].Trim();
                    //        icap = cellContents == null ? "" : cellContents;
                    //        break;
                    //    }
                    //case "QTYKZ": // tcap
                    //    {
                    //        cellContents = cells[amerenMarker.TcapCell].Trim();
                    //        tcap = cellContents == null ? "" : cellContents;
                    //        break;
                    //    }
                    case "REFSPL": // zone
                        {
                            cellContents = cells[amerenMarker.ZoneCell].Trim();
                            zone = cellContents == null ? "" : cellContents;
                            break;
                        }
                    case "REFBLT":	//bill type
                        {
                            cellContents = cells[amerenMarker.BillingTypeCell].Trim();
                            billingType = cellContents == null ? "" : cellContents;
                            break;
                        }
                    case "REFPC":	//production code
                        {
                            cellContents = cells[amerenMarker.BillCalculationCell].Trim();
                            billCalculation = cellContents == null ? "" : cellContents;
                            break;
                        }
                    case "REFBF":	//bill cycle
                        {
                            cellContents = cells[amerenMarker.BillGroupCell].Trim();
                            billGroup = cellContents == null ? "" : cellContents;
                            break;
                        }
                    case "REFLO":	//load profile
                        {
                            cellContents = cells[amerenMarker.LoadProfileCell].Trim();
                            loadProfile = cellContents == null ? "" : cellContents;

                            if (loadProfile == "LITE")
                                meterNumber = "Lighting";

                            if (loadProfile != "")
                            {
                                char invalid = Convert.ToChar(cellContents.Substring(cellContents.Length - 1, 1));
                                if (invalid == '-')
                                    loadProfile = loadProfile.Substring(0, loadProfile.Length - 1);
                            }

                            break;
                        }
                    case "MEA": // kwh, uom, measurement significance code
                    case "MEAAA":
                    case "MEAAE":
                    case "MEAAN":
                    case "MEAEA":
                    case "MEAEE":
                    case "MEAEN":
                    case "MEAAF":
                        {
                            // when marker is MEA, then there will be rows that are not usage (MU)
                            if (!fc.Contains("MU") && isKh)
                            {
                                cellContents = cells[amerenMarker.QuantityCell].Trim();
                                quantity = cellContents == null ? "" : cellContents;

                                cellContents = cells[amerenMarker.UnitOfMeasurementCell].Trim();
                                unitOfMeasurement = cellContents == null ? "" : cellContents;
                                isKh = unitOfMeasurement == "KH" ? false : true;
                                cellContents = cells[amerenMarker.MeasurementSignificanceCodeCell].Trim();
                                measurementSignificanceCode = cellContents == null ? "" : cellContents;

                                if (ptdLoop != "SU" && qty == 0)
                                    account.EdiUsageList.Add(CreateEdiUsage(quantity, unitOfMeasurement, measurementSignificanceCode,
                                            transactionSetPurposeCode, meterNumber, beginDate, endDate, ptdLoop, serviceDeliveryPoint));

                                // keep track of period's total kwh
                                if (unitOfMeasurement == "KH")
                                    qty += Convert.ToDecimal(quantity);
                            }
                            break;
                        }
                    case "DTM582": // copied from legacy code - idr date
                        {
                            cellContents = cells[amerenMarker.IdrDateCell].Trim();
                            idrDate = cellContents == null ? "" : cellContents;

                            cellContents = cells[amerenMarker.IdrIntervalCell].Trim();
                            idrInterval = cellContents == null ? "" : cellContents;

                            // todo: ameren sends both kwh and kw, i'm only catching the last one (not a priority)..
                            if (refJh == "A")
                                account.IdrUsageList[idrInterval + "-" + idrDate + "-" + meterNumber] = createIdrUsage(meterNumber, quantity, unitOfMeasurement, transactionSetPurposeCode, idrInterval, idrDate, ptdLoop);

                            // convert datetime back to string so it can be appended to the idr usage list..
                            endDate = idrDate;

                            break;
                        }
                    case "DTM514": // exchange meter date - duggy 09/24/2010
                        {
                            cellContents = cells[amerenMarker.BeginDateCell].Trim();
                            string TransitionDate = cellContents == null ? "" : cellContents;

                            if (beginDate == null | beginDate == "")
                                beginDate = TransitionDate;
                            else
                                endDate = TransitionDate;

                            break;
                        }
                    case "DTM150": // begin date
                        {
                            cellContents = cells[amerenMarker.BeginDateCell].Trim();
                            beginDate = cellContents == null ? "" : cellContents;
                            break;
                        }
                    case "DTM151": // end date
                        {
                            cellContents = cells[amerenMarker.EndDateCell].Trim();
                            endDate = cellContents == null ? "" : cellContents;

                            // summary has just one ptd marker; for historical, end date is last row..
                            if (ptdLoop.Equals("SU") & transactionSetPurposeCode.Equals("52"))
                                account.EdiUsageList.Add(CreateEdiUsage(quantity, unitOfMeasurement, measurementSignificanceCode,
                                    transactionSetPurposeCode, meterNumber, beginDate, endDate, ptdLoop, serviceDeliveryPoint));

                            break;
                        }
                    case "QTYQD": // begin usage
                    case "QTYKA":
                        {
                            cellContents = cells[amerenMarker.QuantityAltCell].Trim();
                            quantity = cellContents == null ? "" : cellContents;

                            cellContents = cells[amerenMarker.UnitOfMeasurementAltCell].Trim();
                            unitOfMeasurement = cellContents == null ? "" : cellContents;

                            // summary has just one ptd marker; for billed, qty is last row..
                            if (ptdLoop.Equals("SU") & transactionSetPurposeCode != "52")
                                account.EdiUsageList.Add(CreateEdiUsage(quantity, unitOfMeasurement, measurementSignificanceCode,
                                    transactionSetPurposeCode, meterNumber, beginDate, endDate, ptdLoop, serviceDeliveryPoint));

                            break;
                        }
                    case "QTY20":
                    case "QTY87":
                    case "QTY9H":
                        {
                            cellContents = cells[amerenMarker.QuantityAltCell].Trim();
                            quantity = cellContents == null ? "" : cellContents;
                            unitOfMeasurement = "D1";

                            break;
                        }
                }
            }
            return account;
        }
    }
}
