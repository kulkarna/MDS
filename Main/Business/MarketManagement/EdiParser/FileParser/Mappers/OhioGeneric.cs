namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
    using System;
    using System.Collections.Generic;
    using System.Data.SqlTypes;
    using System.Linq;

	public class OhioGeneric : MapperBase
	{
		/// <summary>
		/// Default constructor..
		/// </summary>
		public OhioGeneric() { }

		public OhioGeneric( string utilityCode, string marketCode )
		{
			this.utilityCode = utilityCode;
			this.marketCode = marketCode;
		}
		/// <summary>
		/// Maps markers in an EDI utility file to specific values in generic collections.
		/// </summary>
		/// <param name="fileRow">Generic collection of rows in utility file</param>
		/// <param name="rowDelimiter">row delimiter</param>
		/// <param name="fieldDelimiter">field delimiter</param>
		/// <returns>Returns an Edi account list that contains accounts and their respective usage.</returns>
		public override EdiAccount MapData( FileRow fileRow, char rowDelimiter, char fieldDelimiter )
		{
			try
			{
				bool icapDatesMissing = false;
				bool tcapDatesMissing = false;
				icapList = new IcapList();
				tcapList = new TcapList();
                DateTime? transactionDate = null;
				OhioMaker ohioMaker = new OhioMaker();

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
						case "BPT": // transaction set purpose code
							{
								cellContents = cells[ohioMaker.TransactionSetPurposeCodeCell].Trim();
								transactionSetPurposeCode = cellContents == null ? "" : cellContents;
                                cellContents = "";
                                if (cells.Length > 3)
                                {
                                    string dateString = string.Empty;
                                    dateString = cells[ohioMaker.TransactionCreationDateCell].Trim();
                                    transactionDate = DateTryParse(dateString);
                                }
								break;
							}
						case "PTD":	// block header..
							{
								// skip 1st record + account header..
								if( ptdLoop != null && ptdLoop != "FG" && ptdLoop != "PM" )
									account.EdiUsageList.Add( CreateEdiUsage( quantity, unitOfMeasurement, measurementSignificanceCode,
										transactionSetPurposeCode, meterNumber, beginDate, endDate, ptdLoop ) );

								ClearUsageVariables();
								meterNumber = "";

								cellContents = cells[ohioMaker.PtdLoopCell].Trim();
								ptdLoop = cellContents == null ? "" : cellContents;

								// have only received 52's so far.. also BPT*52 contains only PTD*PL (no summary).. BC = UNMETERED SERVICES
								if( transactionSetPurposeCode == "52" && (ptdLoop == "PL" || ptdLoop == "BC") )
									ptdLoop = "SU";

								if( ptdLoop == "SU" )
									measurementSignificanceCode = "51";

								if( ptdLoop == "PM" )
									ClearIdrVariables();

								break;
							}
						case "SE": // account end **********
							{
								if( !ptdLoop.Equals( "PM" ) )
									account.EdiUsageList.Add( CreateEdiUsage( quantity, unitOfMeasurement, measurementSignificanceCode,
									transactionSetPurposeCode, meterNumber, beginDate, endDate, ptdLoop ) );

								account.AccountNumber = accountNumber;
								account.BillGroup = (!(string.IsNullOrEmpty(billGroup)) && billGroup.Length > 0) ? billGroup : "-1";
								account.BillingAccount = billingAccountNumber;
								account.CustomerName = customerName;
								account.DunsNumber = dunsNumber;
								account.Icap = (icap != null && icap.Length > 0) ? Convert.ToDecimal( icap ) : Convert.ToDecimal( -1 );
								account.LoadProfile = loadProfile;
								account.NameKey = nameKey;
								account.PreviousAccountNumber = previousAccountNumber;
								account.RateClass = rateClass;
								account.RetailMarketCode = marketCode;
								account.Tcap = (tcap != null && tcap.Length > 0) ? Convert.ToDecimal( tcap ) : Convert.ToDecimal( -1 );
								account.UtilityCode = utilityCode;
								account.Voltage = voltage;
								account.ZoneCode = zone;
								account.IcapList = icapList;
								account.TcapList = tcapList;
                                if ((transactionDate > (DateTime)SqlDateTime.MinValue && transactionDate < (DateTime)SqlDateTime.MaxValue))
                                    account.TransactionCreatedDate = transactionDate;
								ResetAccountVariables();
								ptdLoop = null;
								break;
							}
					}
					switch( marker )
					{
						case "DTM150": // begin date
							{
								cellContents = cells[ohioMaker.BeginDateCell].Trim();
								beginDate = cellContents == null ? "" : cellContents;
								break;
							}
						case "DTM151": // end date
							{
								cellContents = cells[ohioMaker.EndDateCell].Trim();
								endDate = cellContents == null ? "" : cellContents;

								// only recieved historical usage so far..
								if( ptdLoop.Equals( "SU" ) & transactionSetPurposeCode.Equals( "52" ) )
									account.EdiUsageList.Add( CreateEdiUsage( quantity, unitOfMeasurement, measurementSignificanceCode,
										transactionSetPurposeCode, meterNumber, beginDate, endDate, ptdLoop ) );

								break;
							}
						case "DTM194": // idr date
							{
								cellContents = cells[ohioMaker.IdrDateCell].Trim();
								idrDate = cellContents == null ? "" : cellContents;

								cellContents = cells[ohioMaker.IdrIntervalCell].Trim();
								idrInterval = cellContents == null ? "" : cellContents;

								account.IdrUsageList[idrInterval + idrDate + unitOfMeasurement+meterNumber] = createIdrUsage( meterNumber, quantity, unitOfMeasurement, transactionSetPurposeCode, idrInterval, idrDate, ptdLoop );

								break;
							}
						case "DTM514": // exchange meter date
							{
								cellContents = cells[ohioMaker.BeginDateCell].Trim();
								string TransitionDate = cellContents == null ? "" : cellContents;

								if( beginDate == null | beginDate == "" )
									beginDate = TransitionDate;
								else
									endDate = TransitionDate;

								break;
							}
						case "IEA1": // end of fileContents **********
							{
								return account;
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
								if( !fc.Contains( "MU" ) )
								{

									cellContents = cells[ohioMaker.QuantityCell].Trim();
									quantity = cellContents == null ? "" : cellContents;

									cellContents = cells[ohioMaker.UnitOfMeasurementCell].Trim();
									unitOfMeasurement = cellContents == null ? "" : cellContents;

									cellContents = cells[ohioMaker.MeasurementSignificanceCodeCell].Trim();
									measurementSignificanceCode = cellContents == null ? "51" : cellContents;
								}
								break;
							}
						case "N18R": // customer name
							{
								cellContents = cells[ohioMaker.CustomerNameCell].Trim();
								customerName = cellContents == null ? "" : cellContents;
								break;
							}
						case "N18S": // duns number
							{
								cellContents = cells[ohioMaker.DunsNumberCell].Trim();
								dunsNumber = cellContents == null ? "" : cellContents;

								if( dunsNumber == "006998371" )
									utilityCode = "OHED";
								else if( dunsNumber == "007900293" )
									utilityCode = "CEI";
								else
									utilityCode = "TOLED";

								break;
							}
						case "QTYKC": // icap
							{
								cellContents = cells[ohioMaker.IcapCell].Trim();
								icap = cellContents == null ? "" : cellContents;
								icapList.Add( new Icap( (icap != null && icap.Length > 0) ? Convert.ToDecimal( icap ) : -1m ) );
								icapDatesMissing = true;
								break;
							}
						case "QTYKZ": // tcap
							{
								cellContents = cells[ohioMaker.TcapCell].Trim();
								tcap = cellContents == null ? "" : cellContents;
								tcapList.Add( new Tcap( (tcap != null && tcap.Length > 0) ? Convert.ToDecimal( tcap ) : -1m ) );
								tcapDatesMissing = true;
								break;
							}
						case "DTM007": // date range for icap or tcap
							{
								cellContents = cells[ohioMaker.IcapTcapDateRangeCell].Trim();
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
						case "QTYQD": // begin usage
						case "QTYKA":
							{
								cellContents = cells[ohioMaker.QuantityAltCell].Trim();
								quantity = cellContents == null ? "" : cellContents;
                                cellContents = cells[ohioMaker.UnitOfMeasurementNewCell].Trim();
                                unitOfMeasurement = cellContents == null ? "" : cellContents;

								break;
							}
                        case "QTY20":
                        case "QTY87":
                        case "QTY9H":
                            {
                                cellContents = cells[ohioMaker.QuantityAltCell].Trim();
                                quantity = cellContents == null ? "" : cellContents;
                                unitOfMeasurement = "D1";
                                break;
                            }
						case "REF45": // previous account number
							{
								cellContents = cells[ohioMaker.PreviousAccountNumberCell].Trim();
								previousAccountNumber = cellContents == null ? "" : cellContents;
								break;
							}
						case "REFBF":	//bill cycle
							{
								cellContents = cells[ohioMaker.BillGroupCell].Trim();
								billGroup = cellContents == null ? "" : cellContents;

								if( billGroup.Length > 2 )
									billGroup = billGroup.Substring( 0, 2 );

								break;
							}
						case "REFLO":	//load profile
							{
								cellContents = cells[ohioMaker.LoadProfileCell].Trim();
								loadProfile = cellContents == null ? "" : cellContents;
								break;
							}
						case "REFMG": // meter number
							{
								cellContents = cells[ohioMaker.MeterNumberCell].Trim();
								meterNumber = cellContents == null ? "" : cellContents;
								break;
							}
						case "REFMT": // usage type
							{
								cellContents = cells[ohioMaker.UsageTypeCell].Trim();
								usageType = cellContents == null ? "" : cellContents;

								if( usageType.Length > 2 )
									usageType = usageType.Substring( 0, 2 );

								unitOfMeasurement = unitOfMeasurement == null || unitOfMeasurement.Length.Equals( 0 ) ? usageType : unitOfMeasurement;

								break;
							}
						case "REFNH": // rate class
							{
								cellContents = cells[ohioMaker.RateClassCell].Trim();
								rateClass = cellContents == null ? "" : cellContents;
								break;
							}
						case "REF12": // account number
							{
								cellContents = cells[ohioMaker.AccountNumberCell].Trim();
								accountNumber = cellContents == null ? "" : cellContents;
								break;
							}
						case "REFSPL": // zone
							{
								cellContents = cells[ohioMaker.ZoneCell].Trim();
								zone = cellContents == null ? "" : cellContents;
								break;
							}
						case "REFSV":
							{
								cellContents = cells[ohioMaker.VoltageCell].Trim();
								voltage = cellContents == null ? "" : cellContents;
								break;
							}
						case "ST867": // account start *******
							{
								// initialize with empty strings to avoid null value issues
								account = new EdiAccount( "", "", "", "", "", "", "", "", "", "", "", "", "" );
								break;
							}
					}
				}
				return account;
			}
			catch( Exception ex )
			{
				throw ex;
			}
		}
	}
}
