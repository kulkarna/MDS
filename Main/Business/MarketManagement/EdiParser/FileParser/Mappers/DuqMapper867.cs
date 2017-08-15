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
	/// DUQ utility mapper for 867 file.
	///  Maps markers in an EDI utility file to specific values in generic collections.
	/// </summary>
	public class DuqMapper867 : MapperBase
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public DuqMapper867() { }

		/// <summary>
		/// Constructor that takes market and utility codes
		/// </summary>
		/// <param name="utilityCode">Utility identifier</param>
		/// <param name="marketCode">Market Identifier</param>
		public DuqMapper867( string utilityCode, string marketCode )
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
			DuqMarker duqMarker = new DuqMarker();

			account = new EdiAccount( "", "", "", "", "", "", "", "", "", "", "", "", "" );
			account.EdiUsageList = new EdiUsageList();
			account.IdrUsageList = new Dictionary<string, EdiIdrUsage>();		// 1-183417931

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
							account.BillGroup = (!(string.IsNullOrEmpty(billGroup)) && billGroup.Length > 0) ? billGroup : "-1";
							account.IcapList = icapList;
							account.TcapList = tcapList;
                            if ((transactionDate > (DateTime)SqlDateTime.MinValue && transactionDate < (DateTime)SqlDateTime.MaxValue))
                                account.TransactionCreatedDate = transactionDate;
							ResetAccountVariables();							// Ticket 17219
							ptdLoop = null;
							break;
						}
					case "PTD":													// new usage record..
						{
							ClearUsageVariables();
							meterNumber = "";

							cellContents = cells[duqMarker.PtdLoopCell].Trim();
							ptdLoop = cellContents == null ? "" : cellContents;

							// BPT*52 only contains PTD*PM thus won't make it to the EdiUsage table..
                            // By adding the PM loop in the conditional sentence, it's ensured the values go to
                            // EdiUsage or EdiUsageDetail tables
                            if (transactionSetPurposeCode == "52" & !ptdLoop.Equals("FG") & !ptdLoop.Equals("PM")) 
                            {
                                ptdLoop = "SU";
                            }

                            if (ptdLoop == "SU" || ptdLoop == "PM")
                            {
                                measurementSignificanceCode = "51";
                            }

							break;
						}
					case "BPT": // transaction set purpose code
						{
							cellContents = cells[duqMarker.TransactionSetPurposeCodeCell].Trim();
							transactionSetPurposeCode = cellContents == null ? "" : cellContents;
                            cellContents = "";
                            if (cells.Length > 3)
                            {
                                string dateString = string.Empty;
                                dateString = cells[duqMarker.TransactionCreationDateCell].Trim();
                                transactionDate = DateTryParse(dateString);
                            }
							break;
						}
				}
				switch( marker )
				{
					case "N18S": // duns number
						{
							cellContents = cells[duqMarker.DunsNumberCell].Trim();
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
							cellContents = cells[duqMarker.CustomerNameCell].Trim();
							customerName = cellContents == null ? "" : cellContents;
							break;
						}
					case "REF12": // account number
						{
							cellContents = cells[duqMarker.AccountNumberCell].Trim();
							accountNumber = cellContents == null ? "" : cellContents;

							break;
						}
					case "REF45": // previous account number
						{
							cellContents = cells[duqMarker.PreviousAccountNumberCell].Trim();
							previousAccountNumber = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFMG": // meter number
						{
							cellContents = cells[duqMarker.MeterNumberCell].Trim();
							meterNumber = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFNH": // rate class
						{
							cellContents = cells[duqMarker.RateClassCell].Trim();
							rateClass = cellContents == null ? "" : cellContents;
							break;
						}
					case "QTYKC": // icap
						{
							cellContents = cells[duqMarker.IcapCell].Trim();
							icap = cellContents == null ? "" : cellContents;
							icapList.Add( new Icap( (icap != null && icap.Length > 0) ? Convert.ToDecimal( icap ) : -1m ) );
							icapDatesMissing = true;
							break;
						}
					case "QTYKZ": // tcap
						{
							cellContents = cells[duqMarker.TcapCell].Trim();
							tcap = cellContents == null ? "" : cellContents;
							tcapList.Add( new Tcap( (tcap != null && tcap.Length > 0) ? Convert.ToDecimal( tcap ) : -1m ) );
							tcapDatesMissing = true;
							break;
						}
					case "DTM007": // date range for icap or tcap
						{
							cellContents = cells[duqMarker.IcapTcapDateRangeCell].Trim();
							string dateRangeStr = cellContents == null ? "" : cellContents;
							if( dateRangeStr.Length == 17 ) // if string is 17 characters then most likely valid
							{
								DateTime beginDate;
								DateTime endDate;
								string[] dateRanges = dateRangeStr.Split( Convert.ToChar( "-" ) );
								if( dateRanges.Length == 2 )
								{
									string bDate = FormatDateString( dateRanges[0] );
									string eDate = FormatDateString( dateRanges[1] );

									if( DateTime.TryParse( bDate, out beginDate ) && DateTime.TryParse( eDate, out endDate ) )
									{
										// should be the very next iteration after obtaining icap or tcap values, 
										// need to determine which values the dates are for.
										if( icapDatesMissing )
										{
											icapList[icapList.Count - 1].BeginDate = beginDate;
											icapList[icapList.Count - 1].EndDate = endDate;
										}
										if( tcapDatesMissing )
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
							cellContents = cells[duqMarker.ZoneCell].Trim();
							zone = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFBF":	//bill cycle
						{
							cellContents = cells[duqMarker.BillGroupCell].Trim();
							billGroup = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFLO":	//load profile
						{
							cellContents = cells[duqMarker.LoadProfileCell].Trim();
							loadProfile = cellContents == null ? "" : cellContents;
							break;
						}
					case "MEAAA": // kwh, uom, measurement significance code
					case "MEAAE":
					case "MEAEA":
					case "MEAEE":
						{
							cellContents = cells[duqMarker.QuantityCell].Trim();
							quantity = cellContents == null ? "" : cellContents;

							cellContents = cells[duqMarker.UnitOfMeasurementCell].Trim();
							unitOfMeasurement = cellContents == null ? "" : cellContents;

							cellContents = cells[duqMarker.MeasurementSignificanceCodeCell].Trim();
							measurementSignificanceCode = cellContents == null ? "51" : cellContents;

							break;
						}
					case "DTM514": // exchange meter date
						{
							cellContents = cells[duqMarker.BeginDateCell].Trim();
							string TransitionDate = cellContents == null ? "" : cellContents;

							if( beginDate == null | beginDate == "" )
								beginDate = TransitionDate;
							else
								endDate = TransitionDate;

							break;
						}
					case "DTM582": // idr date (pseg as well)					-- ticket 23112
						{
							cellContents = cells[duqMarker.IdrDateCell].Trim();
							idrDate = cellContents == null ? "" : cellContents;

							cellContents = cells[duqMarker.IdrIntervalCell].Trim();
							idrInterval = cellContents == null ? "" : cellContents;

                            account.IdrUsageList[idrInterval + "-" + idrDate + "-"+meterNumber] = createIdrUsage(meterNumber, quantity, unitOfMeasurement, transactionSetPurposeCode, idrInterval, idrDate, ptdLoop);

							break;
						}
					case "DTM150": // begin date
						{
							cellContents = cells[duqMarker.BeginDateCell].Trim();
							beginDate = cellContents == null ? "" : cellContents;
							break;
						}
					case "DTM151": // end date
						{
							cellContents = cells[duqMarker.EndDateCell].Trim();
							endDate = cellContents == null ? "" : cellContents;

							// if historical, then add usage
                            if (transactionSetPurposeCode.Equals("52") & !ptdLoop.Equals("FG"))
							{
								account.EdiUsageList.Add( CreateEdiUsage( quantity, unitOfMeasurement, measurementSignificanceCode,
									transactionSetPurposeCode, meterNumber, beginDate, endDate, ptdLoop ) );
							}
							break;
						}
                    // Begin usage
                    case "QTYQD": //Actual Quantity Delivered
                    case "QTYKA": //Estimated Quantity Delivered
						{
							// NV - no value
							if( !fc.Contains( "NV" ) )
							{
								cellContents = cells[duqMarker.QuantityAltCell].Trim();
								quantity = cellContents == null ? "" : cellContents;

								cellContents = cells[duqMarker.UnitOfMeasurementAltCell].Trim();
								unitOfMeasurement = cellContents == null ? "" : cellContents;

								// if historical, then need to wait for begin and end dates
								if( !transactionSetPurposeCode.Equals( "52" ) )
								{
									account.EdiUsageList.Add( 
                                        CreateEdiUsage(quantity,
                                        unitOfMeasurement, 
                                        measurementSignificanceCode,
                                        transactionSetPurposeCode,
                                        meterNumber,
                                        beginDate,
                                        endDate,
                                        ptdLoop));
								}
							}
							break;
						}
                    case "QTY20":
                    case "QTY87":
                    case "QTY9H":
                        {
                            if (!fc.Contains("NV"))
                            {
                                cellContents = cells[duqMarker.QuantityAltCell].Trim();
                                quantity = cellContents == null ? "" : cellContents;
                                unitOfMeasurement = "D1";
                            }
                            break;
                        }
				}
			}

			return account;
		}
	}
}
