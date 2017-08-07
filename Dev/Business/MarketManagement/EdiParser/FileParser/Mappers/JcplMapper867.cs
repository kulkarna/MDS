namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
    using System;
    using System.Collections.Generic;
    using System.Data.SqlTypes;
    using System.Linq;

	/// <summary>
	/// JCPL utility mapper for 867 file.
	///  Maps markers in an EDI utility file to specific values in generic collections.
    ///  // Changes to Bill Group type by ManojTFS-63739 -3/09/15
	/// </summary>
	public class JcplMapper867 : MapperBase
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public JcplMapper867() { }

		/// <summary>
		/// Constructor that takes market and utility codes
		/// </summary>
		/// <param name="utilityCode">Utility identifier</param>
		/// <param name="marketCode">Market Identifier</param>
		public JcplMapper867( string utilityCode, string marketCode )
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
		public override EdiAccount MapData( FileRow fileRow, char rowDelimiter, char fieldDelimiter )
		{
            bool icapDatesMissing = false;
            bool tcapDatesMissing = false;
            icapList = new IcapList();
            tcapList = new TcapList();
            DateTime? transactionDate = null;
			JcplMarker jcplMarker = new JcplMarker();

			account = new EdiAccount( "", "", "", "", "", "", "", "", "", "", "", "", "" );
			account.EdiUsageList = new EdiUsageList();
			account.IdrUsageList = new Dictionary<string, EdiIdrUsage>();

			string[] fileCellList = fileRow.Contents.Split( rowDelimiter );

			foreach( string fc in fileCellList )
			{
				string[] cells = fc.Split( fieldDelimiter );
				string cell0 = cells[0];
				string cell1 = string.Empty;
				string marker = string.Empty;

				if( cells.Count() > 1 )
				{
					cell1 = cells[1];
					marker = cell0 + cell1;
				}

				string cellContents;

				switch( cell0 )
				{
					case "SE": // account end **********
						{
							if( !ptdLoop.Equals( "FG" ) )
								account.EdiUsageList.Add( CreateEdiUsage( quantity, unitOfMeasurement, measurementSignificanceCode,
									transactionSetPurposeCode, meterNumber, beginDate, endDate, ptdLoop ) );

							account.AccountNumber = accountNumber;
							account.BillingAccount = billingAccountNumber;
							account.CustomerName = customerName;
							account.DunsNumber = dunsNumber;
							account.Icap = (icap != null && icap.Length > 0) ? Convert.ToDecimal( icap ) : Convert.ToDecimal( -1 );
							account.NameKey = nameKey;
							account.PreviousAccountNumber = previousAccountNumber;
							account.RateClass = rateClass;
							account.RetailMarketCode = marketCode;
							account.Tcap = (tcap != null && tcap.Length > 0) ? Convert.ToDecimal( tcap ) : Convert.ToDecimal( -1 );
							account.UtilityCode = utilityCode;
							account.ZoneCode = zone;
							account.LoadProfile = loadProfile;
							account.BillGroup = (billGroup != null && billGroup.Length > 0) ? billGroup  : "-1";
							account.Voltage = voltage;
                            account.IcapList = icapList;
                            account.TcapList = tcapList;
                            if ((transactionDate > (DateTime)SqlDateTime.MinValue && transactionDate < (DateTime)SqlDateTime.MaxValue))
                                account.TransactionCreatedDate = transactionDate;
//							idrList.Clear();

							ResetAccountVariables();							// Ticket 17219
							ptdLoop = null;
							break;
						}
					case "PTD":													// new usage record..
						{
							// skip 1st record + no double dipping (since summary has only one ptd marker) + also omit idr data (bq)..
							if( ptdLoop != null & ptdLoop != "SU" & ptdLoop != "BQ" & ptdLoop != "FG" )
								account.EdiUsageList.Add( CreateEdiUsage( quantity, unitOfMeasurement, measurementSignificanceCode,
									transactionSetPurposeCode, meterNumber, beginDate, endDate, ptdLoop ) );

							ClearUsageVariables();
							meterNumber = "";

							cellContents = cells[jcplMarker.PtdLoopCell].Trim();
							ptdLoop = cellContents == null ? "" : cellContents;

                            // PBI-117732- preventing BB loop overwitten by SU  with IDR  Files.
                            if (transactionSetPurposeCode == "00" & ptdLoop == "BB")
                                ptdLoop = "SU";

                            if (transactionSetPurposeCode == "00" & ptdLoop == "SU"
                                                      & account.EdiUsageList.Count != 0
                                                      & (CheckSULoopAlreadyExist(account.EdiUsageList) == 1))
                            //There is already a 'SU' loop added so skip this section.
                            {
                                unitOfMeasurement = "D1";
                                measurementSignificanceCode = "01";
                            }
                            else if (ptdLoop == "SU")
                            {
                                measurementSignificanceCode = "51";
                            }

                            break;
						}
					case "BPT": // transaction set purpose code
						{
							cellContents = cells[jcplMarker.TransactionSetPurposeCodeCell].Trim();
							transactionSetPurposeCode = cellContents == null ? "" : cellContents;
                            cellContents = "";
                            if (cells.Length > 3)
                            {
                                string dateString = string.Empty;
                                dateString = cells[jcplMarker.TransactionCreationDateCell].Trim();
                                transactionDate = DateTryParse(dateString);
                            }
							break;
						}
				}
				switch( marker )
				{
					case "N18S": // duns number
						{
							cellContents = cells[jcplMarker.DunsNumberCell].Trim();
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
							account = new EdiAccount( "", "", "", "", "", "", "", "", "", "", "", "", "" );
							break;
						}
					case "N18R": // customer name
						{
							cellContents = cells[jcplMarker.CustomerNameCell].Trim();
							customerName = cellContents == null ? "" : cellContents;
							break;
						}
					case "REF12": // account number
						{
							cellContents = cells[jcplMarker.AccountNumberCell].Trim();
							accountNumber = cellContents == null ? "" : cellContents;
							break;
						}
					case "REF45": // previous account number
						{
							cellContents = cells[jcplMarker.PreviousAccountNumberCell].Trim();
							previousAccountNumber = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFMG": // meter number
						{
							cellContents = cells[jcplMarker.MeterNumberCell].Trim();
							meterNumber = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFNH": // rate class
						{
							cellContents = cells[jcplMarker.RateClassCell].Trim();
							rateClass = cellContents == null ? "" : cellContents;
							break;
						}
					case "QTYKC": // icap
						{
							cellContents = cells[jcplMarker.IcapCell].Trim();
							icap = cellContents == null ? "" : cellContents;

                            icapList.Add(new Icap((icap != null && icap.Length > 0) ? Convert.ToDecimal(icap) : -1m));
                            
                            if(!string.IsNullOrWhiteSpace(icap))
                            {
                                icapDatesMissing = true;
                            }
							break;
						}
					case "QTYKZ": // tcap
						{
							cellContents = cells[jcplMarker.TcapCell].Trim();
							tcap = cellContents == null ? "" : cellContents;

                            tcapList.Add(new Tcap((tcap != null && tcap.Length > 0) ? Convert.ToDecimal(tcap) : -1m));
                            
                            if (!string.IsNullOrWhiteSpace(icap))
                            {
                                tcapDatesMissing = true;
                            }
							break;
						}
                    case "DTM007": // date range for icap or tcap
                        {
                            cellContents = cells[jcplMarker.IcapTcapDateRangeCell].Trim();
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
							cellContents = cells[jcplMarker.ZoneCell].Trim();
							zone = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFBF":	//bill cycle
						{
							cellContents = cells[jcplMarker.BillGroupCell].Trim();
							billGroup = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFLO":	//load profile
						{
							cellContents = cells[jcplMarker.LoadProfileCell].Trim();
							loadProfile = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFSV":
						{
							cellContents = cells[jcplMarker.VoltageCell].Trim();
							voltage = cellContents == null ? "" : cellContents;
							break;
						}
					case "MEA": // kwh, uom, measurement significance code
					case "MEAAA":
					case "MEAAE":
					case "MEAEA":
					case "MEAEE":
                    case "MEAAF":
						{
							// when marker is MEA, then there will be rows that are not usage (MU)
							if( !fc.Contains( "MU" ) )
							{
								cellContents = cells[jcplMarker.QuantityCell].Trim();
								quantity = cellContents == null ? "" : cellContents;

								cellContents = cells[jcplMarker.UnitOfMeasurementCell].Trim();
								unitOfMeasurement = cellContents == null ? "" : cellContents;

								cellContents = cells[jcplMarker.MeasurementSignificanceCodeCell].Trim();
								measurementSignificanceCode = cellContents == null ? "" : cellContents;
							}

							break;
						}
					case "DTM582": // idr date
						{
							cellContents = cells[jcplMarker.IdrDateCell].Trim();
							idrDate = cellContents == null ? "" : cellContents;

							cellContents = cells[jcplMarker.IdrIntervalCell].Trim();
							idrInterval = cellContents == null ? "" : cellContents;

//							idrList.Add( createIdrUsage( meterNumber, quantity, unitOfMeasurement, transactionSetPurposeCode, idrInterval, idrDate, ptdLoop ) );
							account.IdrUsageList[idrInterval + idrDate + unitOfMeasurement+meterNumber] = 
								createIdrUsage( meterNumber, quantity, unitOfMeasurement, transactionSetPurposeCode, idrInterval, idrDate, ptdLoop );

							break;
						}
					case "DTM150": // begin date
						{
							cellContents = cells[jcplMarker.BeginDateCell].Trim();
							beginDate = cellContents == null ? "" : cellContents;
							break;
						}
					case "DTM151": // end date
						{
							cellContents = cells[jcplMarker.EndDateCell].Trim();
							endDate = cellContents == null ? "" : cellContents;

							// summary has just one ptd marker; for historical, end date is last row..
							if( ptdLoop.Equals( "SU" ) & transactionSetPurposeCode.Equals( "52" ) )
								account.EdiUsageList.Add( CreateEdiUsage( quantity, unitOfMeasurement, measurementSignificanceCode,
									transactionSetPurposeCode, meterNumber, beginDate, endDate, ptdLoop ) );

							break;
						}
					case "DTM514": // exchange meter date
						{
							cellContents = cells[jcplMarker.BeginDateCell].Trim();
							string TransitionDate = cellContents == null ? "" : cellContents;

							if( beginDate == null | beginDate == "" )
								beginDate = TransitionDate;
							else
								endDate = TransitionDate;

							break;
						}
					case "QTYKA":
					case "QTYD1":
					case "QTYQD": // begin usage
						{
							cellContents = cells[jcplMarker.QuantityAltCell].Trim();
							quantity = cellContents == null ? "" : cellContents;

							cellContents = cells[jcplMarker.UnitOfMeasurementAltCell].Trim();
							unitOfMeasurement = cellContents == null ? "" : cellContents;

							// summary has just one ptd marker; for billed, qty is last row..
							if( ptdLoop.Equals( "SU" ) & transactionSetPurposeCode != "52" )
								account.EdiUsageList.Add( CreateEdiUsage( quantity, unitOfMeasurement, measurementSignificanceCode,
									transactionSetPurposeCode, meterNumber, beginDate, endDate, ptdLoop ) );

							break;
						}
                    case "QTY20":
                    case "QTY87":
                    case "QTY9H":
                        {
                            cellContents = cells[jcplMarker.QuantityAltCell].Trim();
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
