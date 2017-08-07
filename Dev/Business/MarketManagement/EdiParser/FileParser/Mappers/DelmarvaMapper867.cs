//namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
//{
//    using System;
//    using System.Collections.Generic;
//    using System.Linq;
//    using System.Text;
//    using LibertyPower.Business.MarketManagement.UtilityManagement;
//    using LibertyPower.Business.MarketManagement.EdiParser.FormatParser;

//    /// <summary>
//    /// DELDE utility mapper for 867 file.
//    /// Maps markers in an EDI utility file to specific values in generic collections.
//    /// </summary>
//    public class DelmarvaMapper867 : MapperBase
//    {
//        /// <summary>
//        /// Default constructor
//        /// </summary>
//        public DelmarvaMapper867() { }

//        /// <summary>
//        /// Constructor that takes market and utility codes
//        /// </summary>
//        /// <param name="utilityCode">Utility identifier</param>
//        /// <param name="marketCode">Market Identifier</param>
//        public DelmarvaMapper867( string utilityCode, string marketCode )
//        {
//            this.utilityCode = utilityCode;
//            this.marketCode = marketCode;
//        }

//        /// <summary>
//        /// Maps markers in an EDI utility file to specific values in generic collections.
//        /// </summary>
//        /// <param name="fileRow">Generic collection of rows in utility file</param>
//        /// <param name="rowDelimiter">Row delimiter</param>
//        /// <param name="fieldDelimiter">field delimiter</param>
//        /// <returns>Returns an Edi account list that contains accounts and their respective usage.</returns>
//        public override EdiAccount MapData( FileRow fileRow, char rowDelimiter, char fieldDelimiter )
//        {
//            DelmarvaMarker deldeMarker = new DelmarvaMarker();

//            account = new EdiAccount( "", "", "", "", "", "", "", "", "", "", "", "", "" );
//            account.EdiUsageList = new EdiUsageList();

//            string[] fileCellList = fileRow.Contents.Split( rowDelimiter );
//            foreach( string fc in fileCellList )
//            {
//                string[] cells = fc.Split( fieldDelimiter );
//                string cell0 = cells[0];
//                string cell1 = string.Empty;
//                string marker = string.Empty;
//                if( cells.Count() > 1 )
//                {
//                    cell1 = cells[1];
//                    marker = cell0 + cell1;
//                }
//                string cellContents;
//                switch( cell0 )
//                {
//                    case "SE": // account end **********
//                        {
//                            AddUsagesToList( usageListTemp, account.EdiUsageList, beginDate, endDate, ptdLoop );

//                            account.AccountNumber = accountNumber;
//                            account.BillingAccount = billingAccountNumber;
//                            account.CustomerName = customerName;
//                            account.DunsNumber = dunsNumber;
//                            account.Icap = (icap != null && icap.Length > 0) ? Convert.ToDecimal( icap ) : Convert.ToDecimal( -1 );
//                            account.NameKey = nameKey;
//                            account.PreviousAccountNumber = previousAccountNumber;
//                            account.RateClass = rateClass;
//                            account.RetailMarketCode = marketCode;
//                            account.Tcap = (tcap != null && tcap.Length > 0) ? Convert.ToDecimal( tcap ) : Convert.ToDecimal( -1 );
//                            account.UtilityCode = utilityCode;
//                            account.ZoneCode = zone;
//                            account.LoadProfile = loadProfile;
//                            account.BillGroup = (billGroup != null && billGroup.Length > 0) ? Convert.ToInt32( billGroup ) : -1;
//                            ptdLoop = null;
							
//                            ResetAccountVariables();							// Ticket 17219
//                            break;
//                        }
//                    case "PTD":													// new usage record..
//                        {
//                            // skip 1st record + no double dipping (since summary has only one ptd marker)..
//                            if( ptdLoop != null && ptdLoop != "SU" && ptdLoop != "FG" )
//                                AddUsagesToList( usageListTemp, account.EdiUsageList, beginDate, endDate, ptdLoop );

//                            ClearUsageVariables();
//                            meterNumber = "";

//                            cellContents = cells[deldeMarker.PtdLoopCell].Trim();
//                            ptdLoop = cellContents == null ? "" : cellContents;

//                            if( ptdLoop == "SU" )
//                                measurementSignificanceCode = "51";

//                            break;
//                        }
//                    case "BPT": // transaction set purpose code
//                        {
//                            cellContents = cells[deldeMarker.TransactionSetPurposeCodeCell].Trim();
//                            transactionSetPurposeCode = cellContents == null ? "" : cellContents;
//                            break;
//                        }
//                }
//                switch( marker )
//                {
//                    case "N18S": // duns number
//                        {
//                            cellContents = cells[deldeMarker.DunsNumberCell].Trim();
//                            dunsNumber = cellContents == null ? "" : cellContents;

//                            switch( dunsNumber )
//                            {
//                                case "006971618DE":
//                                    utilityCode = "DELDE";
//                                    break;
//                                case "006971618MD":
//                                    utilityCode = "DELMD";
//                                    break;
//                            }

//                            break;
//                        }
//                    case "IEA1": // end of fileContents **********
//                        {
//                            return account;
//                        }
//                    case "ST867": // account start *******
//                        {
//                            // initialize with empty strings to avoid null value issues
//                            account = new EdiAccount( "", "", "", "", "", "", "", "", "", "", "", "", "" );
//                            break;
//                        }
//                    case "N18R": // customer name
//                        {
//                            cellContents = cells[deldeMarker.CustomerNameCell].Trim();
//                            customerName = cellContents == null ? "" : cellContents;
//                            break;
//                        }
//                    case "REF12": // account number
//                        {
//                            cellContents = cells[deldeMarker.AccountNumberCell].Trim();
//                            accountNumber = cellContents == null ? "" : cellContents;
//                            break;
//                        }
//                    case "REF45": // previous account number
//                        {
//                            cellContents = cells[deldeMarker.PreviousAccountNumberCell].Trim();
//                            previousAccountNumber = cellContents == null ? "" : cellContents;
//                            break;
//                        }
//                    case "REFMG": // meter number
//                        {
//                            cellContents = cells[deldeMarker.MeterNumberCell].Trim();
//                            meterNumber = cellContents == null ? "" : cellContents;
//                            break;
//                        }
//                    case "REFNH": // rate class
//                        {
//                            cellContents = cells[deldeMarker.RateClassCell].Trim();
//                            rateClass = cellContents == null ? "" : cellContents;
//                            break;
//                        }
//                    case "QTYKC": // icap
//                        {
//                            cellContents = cells[deldeMarker.IcapCell].Trim();
//                            icap = cellContents == null ? "" : cellContents;
//                            break;
//                        }
//                    case "QTYKZ": // tcap
//                        {
//                            cellContents = cells[deldeMarker.TcapCell].Trim();
//                            tcap = cellContents == null ? "" : cellContents;
//                            break;
//                        }
//                    case "REFSPL": // zone
//                        {
//                            cellContents = cells[deldeMarker.ZoneCell].Trim();
//                            zone = cellContents == null ? "" : cellContents;
//                            break;
//                        }
//                    case "REFBF":	//bill cycle
//                        {
//                            cellContents = cells[deldeMarker.BillGroupCell].Trim();
//                            billGroup = cellContents == null ? "" : cellContents;
//                            break;
//                        }
//                    case "REFLO":	//load profile
//                        {
//                            cellContents = cells[deldeMarker.LoadProfileCell].Trim();
//                            loadProfile = cellContents == null ? "" : cellContents;
//                            break;
//                        }
//                    case "MEA": // kwh, uom, measurement significance code
//                    case "MEAAA":
//                    case "MEAAE":
//                    case "MEAEA":
//                    case "MEAEE":
//                    case "MEAAF":
//                        {
//                            // when marker is MEA, then there will be rows that are not usage (MU)
//                            if( !fc.Contains( "MU" ) )
//                            {
//                                cellContents = cells[deldeMarker.QuantityCell].Trim();
//                                quantity = cellContents == null ? "" : cellContents;

//                                cellContents = cells[deldeMarker.UnitOfMeasurementCell].Trim();
//                                unitOfMeasurement = cellContents == null ? "" : cellContents;

//                                cellContents = cells[deldeMarker.MeasurementSignificanceCodeCell].Trim();

//                                measurementSignificanceCode = cellContents == null ? "" : cellContents;

//                                usageListTemp.Add( CreateEdiUsage( quantity, unitOfMeasurement, measurementSignificanceCode,
//                                    transactionSetPurposeCode, meterNumber ) );
//                            }
//                            break;
//                        }
//                    case "DTM150": // begin date
//                        {
//                            cellContents = cells[deldeMarker.BeginDateCell].Trim();
//                            beginDate = cellContents == null ? "" : cellContents;
//                            break;
//                        }
//                    case "DTM151": // end date
//                        {
//                            cellContents = cells[deldeMarker.EndDateCell].Trim();
//                            endDate = cellContents == null ? "" : cellContents;

//                            // summary has just one ptd marker; for historical, end date is last row..
//                            if( ptdLoop.Equals( "SU" ) & transactionSetPurposeCode.Equals( "52" ) )
//                                AddUsagesToList( usageListTemp, account.EdiUsageList, beginDate, endDate, ptdLoop );

//                            break;
//                        }
//                    case "DTM514": // exchange meter date
//                        {
//                            cellContents = cells[deldeMarker.BeginDateCell].Trim();
//                            string TransitionDate = cellContents == null ? "" : cellContents;

//                            if( beginDate == null | beginDate == "" )
//                                beginDate = TransitionDate;
//                            else
//                                endDate = TransitionDate;

//                            break;
//                        }
//                    case "QTYKA":
//                    case "QTYD1":
//                    case "QTYQD": // begin usage
//                        {
//                            // NV - no value
//                            if( !fc.Contains( "NV" ) )
//                            {
//                                cellContents = cells[deldeMarker.QuantityAltCell].Trim();

//                                quantity = cellContents == null ? "" : cellContents;

//                                cellContents = cells[deldeMarker.UnitOfMeasurementAltCell].Trim();
//                                unitOfMeasurement = cellContents == null ? "" : cellContents;

//                                // summary has just one ptd marker; for billed, qty is last row..
//                                if( ptdLoop.Equals( "SU" ) & transactionSetPurposeCode != "52" )
//                                {
//                                    account.EdiUsageList.Add( CreateEdiUsage( quantity, unitOfMeasurement, measurementSignificanceCode,
//                                        transactionSetPurposeCode, meterNumber, beginDate, endDate, ptdLoop ) );
//                                }
//                            }
//                            break;
//                        }
//                }
//            }
//            return account;
//        }
//    }
//}
