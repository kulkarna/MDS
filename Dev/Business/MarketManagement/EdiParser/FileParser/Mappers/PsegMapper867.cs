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
	/// PSEG utility mapper for 867 file.
	///  Maps markers in an EDI utility file to specific values in generic collections.
	/// </summary>
	public class PsegMapper867 : MapperBase
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public PsegMapper867() { }

		/// <summary>
		/// Constructor that takes market and utility codes
		/// </summary>
		/// <param name="utilityCode">Utility identifier</param>
		/// <param name="marketCode">Market Identifier</param>
		public PsegMapper867( string utilityCode, string marketCode )
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
			PsegMarker psegMarker = new PsegMarker();

			account = new EdiAccount( "", "", "", "", "", "", "", "", "", "", "", "", "" );
			account.EdiUsageList = new EdiUsageList();
			account.IdrUsageList = new Dictionary<string, EdiIdrUsage>();		// ticket 23112

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
								AddUsagesToList( usageListTemp, account.EdiUsageList, beginDate, endDate, ptdLoop );

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
                            // skip 1st record + no double dipping (since summary has only one ptd marker) + also omit acct data (bo)..
                            if (ptdLoop != null & ptdLoop != "SU" & ptdLoop != "BO")
                                AddUsagesToList(usageListTemp, account.EdiUsageList, beginDate, endDate, ptdLoop);

                            ClearUsageVariables();
                            meterNumber = "";

                            cellContents = cells[psegMarker.PtdLoopCell].Trim();
                            ptdLoop = cellContents == null ? "" : cellContents;

                            // BPT*00 for IDR accounts only contain PTD*BB - 1-2851688..
                            if (transactionSetPurposeCode == "00" & ptdLoop == "BB")
                                ptdLoop = "SU";

                            if (transactionSetPurposeCode == "00" & ptdLoop == "SU"
                                                      & account.EdiUsageList.Count != 0
                                                      & (CheckSULoopAlreadyExist(account.EdiUsageList) == 1))
                                //There is already a 'SU' loop added so skip this section.
                                measurementSignificanceCode = "01";

                            else if (ptdLoop == "SU")
                                measurementSignificanceCode = "51";

                            break;
                        }
					case "BPT": // transaction set purpose code
						{
							cellContents = cells[psegMarker.TransactionSetPurposeCodeCell].Trim();
							transactionSetPurposeCode = cellContents == null ? "" : cellContents;
                            cellContents = "";
                            if (cells.Length > 3)
                            {
                                string dateString = string.Empty;
                                dateString = cells[psegMarker.TransactionCreationDateCell].Trim();
                                transactionDate = DateTryParse(dateString);
                            }
							break;
						}
				}
				//System.Diagnostics.Debug.WriteLine( accountNumber + '-' + marker + '-' + idrDate );
				switch( marker )
				{
					case "N18S": // duns number
						{
							cellContents = cells[psegMarker.DunsNumberCell].Trim();
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
							cellContents = cells[psegMarker.CustomerNameCell].Trim();
							customerName = cellContents == null ? "" : cellContents;
							break;
						}
					case "REF12": // account number
						{
							cellContents = cells[psegMarker.AccountNumberCell].Trim();
							accountNumber = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFMG": // meter number
						{
							cellContents = cells[psegMarker.MeterNumberCell].Trim();
							meterNumber = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFNH": // rate class
						{
							cellContents = cells[psegMarker.RateClassCell].Trim();
							rateClass = cellContents == null ? "" : cellContents;
							break;
						}
					case "QTYKC": // icap
						{
							cellContents = cells[psegMarker.IcapCell].Trim();
							icap = cellContents == null ? "" : cellContents;
							icapList.Add( new Icap( (icap != null && icap.Length > 0) ? Convert.ToDecimal( icap ) : -1m ) );
							icapDatesMissing = true;
							break;
						}
					case "QTYKZ": // tcap
						{
							cellContents = cells[psegMarker.TcapCell].Trim();
							tcap = cellContents == null ? "" : cellContents;
							tcapList.Add( new Tcap( (tcap != null && tcap.Length > 0) ? Convert.ToDecimal( tcap ) : -1m ) );
							tcapDatesMissing = true;
							break;
						}
					case "DTM007": // date range for icap or tcap
						{
							cellContents = cells[psegMarker.IcapTcapDateRangeCell].Trim();
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
					case "REFBF":	//bill cycle
						{
							cellContents = cells[psegMarker.BillGroupCell].Trim();
							billGroup = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFLO":	//load profile
						{
							cellContents = cells[psegMarker.LoadProfileCell].Trim();
							loadProfile = cellContents == null ? "" : cellContents;
							break;
						}
					case "MEA": // kwh, uom, measurement significance code
					case "MEAAA":
					case "MEAAE":
					case "MEAEA":
					case "MEAEE":
                    case "MEAAF":
						{
							if( !cells[2].Trim().Equals( "MU" ) )
							{
								cellContents = cells[psegMarker.QuantityCell].Trim();
								quantity = cellContents == null ? "" : cellContents;

								cellContents = cells[psegMarker.UnitOfMeasurementCell].Trim();
								unitOfMeasurement = cellContents == null ? "" : cellContents;

								cellContents = cells[psegMarker.MeasurementSignificanceCodeCell].Trim();
								measurementSignificanceCode = cellContents == null ? "" : cellContents;

								usageListTemp.Add( CreateEdiUsage( quantity, unitOfMeasurement, measurementSignificanceCode,
										transactionSetPurposeCode, meterNumber ) );
							}
							break;
						}
					case "DTM582": // idr date (pseg as well)					-- ticket 23112
						{
							cellContents = cells[psegMarker.IdrDateCell].Trim();
							idrDate = cellContents == null ? "" : cellContents;

							cellContents = cells[psegMarker.IdrIntervalCell].Trim();
							idrInterval = cellContents == null ? "" : cellContents;

                            account.IdrUsageList[idrInterval + "-" + unitOfMeasurement + "-" + idrDate + "-" + meterNumber] = createIdrUsage(meterNumber, quantity, unitOfMeasurement, transactionSetPurposeCode, idrInterval, idrDate, ptdLoop);

							break;
						}
					case "DTM150": // begin date
						{
							cellContents = cells[psegMarker.BeginDateCell].Trim();
							beginDate = cellContents == null ? "" : cellContents;
							break;
						}
					case "DTM151": // end date
						{
							cellContents = cells[psegMarker.EndDateCell].Trim();
							endDate = cellContents == null ? "" : cellContents;

							// summary has just one ptd marker; for historical, end date is last row..
							if( ptdLoop.Equals( "SU" ) & transactionSetPurposeCode.Equals( "52" ) )
								AddUsagesToList( usageListTemp, account.EdiUsageList, beginDate, endDate, ptdLoop );
							break;
						}
					case "DTM514": // exchange meter date
						{
							cellContents = cells[psegMarker.BeginDateCell].Trim();
							string TransitionDate = cellContents == null ? "" : cellContents;

							if( beginDate == null | beginDate == "" )
								beginDate = TransitionDate;
							else
								endDate = TransitionDate;

							break;
						}
					case "QTYD1":
					//					case "QTY87":	-- duggy - co-generation (paneles solares) - 06/03/2011
					case "QTYQD": // begin usage
						{
							// NV - no value
							if( !fc.Contains( "NV" ) )
							{
								cellContents = cells[psegMarker.QuantityAltCell].Trim();
								quantity = cellContents == null ? "" : cellContents;

								cellContents = cells[psegMarker.UnitOfMeasurementAltCell].Trim();
								unitOfMeasurement = cellContents == null ? "" : cellContents;

								// summary has just one ptd marker; for billed, qty is last row..
								if( ptdLoop.Equals( "SU" ) & transactionSetPurposeCode != "52" )
								{
									account.EdiUsageList.Add( CreateEdiUsage( quantity, unitOfMeasurement, measurementSignificanceCode,
										transactionSetPurposeCode, meterNumber, beginDate, endDate, ptdLoop ) );
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
                                cellContents = cells[psegMarker.QuantityAltCell].Trim();
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
