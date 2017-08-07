namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
    using System;
    using System.Collections.Generic;
    using System.Data.SqlTypes;
    using System.Linq;

	/// <summary>
	/// WPP utility mapper for 867 file.
	///  Maps markers in an EDI utility file to specific values in generic collections.
	/// </summary>
	public class WppMapper867 : MapperBase
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public WppMapper867() { }

		/// <summary>
		/// Constructor that takes market and utility codes
		/// </summary>
		/// <param name="utilityCode"></param>
		/// <param name="marketCode"></param>
		public WppMapper867( string utilityCode, string marketCode )
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

			WppMarker wppMarker = new WppMarker();

			account = new EdiAccount( "", "", "", "", "", "", "", "", "", "", "", "", "" );
			account.EdiUsageList = new EdiUsageList();
			account.IdrUsageList = new Dictionary<string, EdiIdrUsage>();
            DateTime? transactionDate = null;
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
							account.CustomerName = customerName;
							account.DunsNumber = dunsNumber;
							account.EspAccount = espAccount;
							account.ZoneCode = zone;
							account.Icap = (icap != null && icap.Length > 0) ? Convert.ToDecimal( icap ) : Convert.ToDecimal( -1 );
							account.RateClass = rateClass;
							account.RetailMarketCode = marketCode;
							account.Tcap = (tcap != null && tcap.Length > 0) ? Convert.ToDecimal( tcap ) : Convert.ToDecimal( -1 );
							account.UtilityCode = utilityCode;
							account.LoadProfile = loadProfile;
							account.BillGroup = (!(string.IsNullOrEmpty(billGroup)) && billGroup.Length > 0) ? billGroup : "-1";
							account.PreviousAccountNumber = previousAccountNumber;
							account.Voltage = voltage;
							account.IcapList = icapList;
							account.TcapList = tcapList;
                            if ((transactionDate > (DateTime)SqlDateTime.MinValue && transactionDate < (DateTime)SqlDateTime.MaxValue))
                                account.TransactionCreatedDate = transactionDate;
							ResetAccountVariables();
							ptdLoop = null;
							break;
						}
					case "PTD":													// new ptd loop value..
						{
							// skip 1st record + no double dipping (since summary has only one ptd marker) + also omit idr data (bq)..
							if( ptdLoop != null & ptdLoop != "SU" & ptdLoop != "BQ" )
								account.EdiUsageList.Add( CreateEdiUsage( quantity, unitOfMeasurement, measurementSignificanceCode,
									transactionSetPurposeCode, meterNumber, beginDate, endDate, ptdLoop ) );

							ClearUsageVariables();
							meterNumber = "";

							cellContents = cells[wppMarker.PtdLoopCell].Trim();
							ptdLoop = cellContents == null ? "" : cellContents;

							// only found PTD|PM for historical..
							if( ptdLoop == "PM" & transactionSetPurposeCode == "52" )
								ptdLoop = "SU";

							if( ptdLoop == "SU" )
								measurementSignificanceCode = "51";

							if( ptdLoop == "BQ" )
								ClearIdrVariables();

							break;
						}
					case "BPT":													// transaction set purpose code
						{
							cellContents = cells[wppMarker.TransactionSetPurposeCodeCell].Trim();
							transactionSetPurposeCode = cellContents == null ? "" : cellContents;
                            cellContents = "";
                            if (cells.Length > 3)
                            {
                                string dateString = string.Empty;
                                dateString = cells[wppMarker.TransactionCreationDateCell].Trim();
                                transactionDate = DateTryParse(dateString);
                            }
							break;
						}
				}
				switch( marker )
				{
					case "N18R": // customer name
						{
							cellContents = cells[wppMarker.CustomerNameCell].Trim();
							customerName = cellContents == null ? "" : cellContents;
							break;
						}
					case "N18S": // duns number
						{
							cellContents = cells[wppMarker.DunsNumberCell].Trim();
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
					case "REF11": // esp account number
						{
							cellContents = cells[wppMarker.EspAccountCell].Trim();
							espAccount = cellContents == null ? "" : cellContents;
							break;
						}
					case "REF45": // previous account number
						{
							cellContents = cells[wppMarker.PreviousAccountNumberCell].Trim();
							previousAccountNumber = cellContents == null ? "" : cellContents;
							break;
						}
					case "REF12": // account number
						{
							cellContents = cells[wppMarker.AccountNumberCell].Trim();
							accountNumber = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFMG": // meter number
						{
							cellContents = cells[wppMarker.MeterNumberCell].Trim();
							meterNumber = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFNH": // rate class
						{
							cellContents = cells[wppMarker.RateClassCell].Trim();
							rateClass = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFSV": 												// voltage
						{
							cellContents = cells[wppMarker.VoltageCell].Trim();
							voltage = cellContents == null ? "" : cellContents;
							break;
						}
					case "QTYKC": // icap
						{
							cellContents = cells[wppMarker.IcapCell].Trim();
							icap = cellContents == null ? "" : cellContents;
							icapList.Add( new Icap( (icap != null && icap.Length > 0) ? Convert.ToDecimal( icap ) : -1m ) );
							icapDatesMissing = true;
							break;
						}
					case "QTYKZ": // tcap
						{
							cellContents = cells[wppMarker.TcapCell].Trim();
							tcap = cellContents == null ? "" : cellContents;
							tcapList.Add( new Tcap( (tcap != null && tcap.Length > 0) ? Convert.ToDecimal( tcap ) : -1m ) );
							tcapDatesMissing = true;
							break;
						}
					case "DTM007": // date range for icap or tcap
						{
							cellContents = cells[wppMarker.IcapTcapDateRangeCell].Trim();
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
							cellContents = cells[wppMarker.ZoneCell].Trim();
							zone = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFBF":	//bill cycle
						{
							cellContents = cells[wppMarker.BillGroupCell].Trim();
							billGroup = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFLO":	//load profile
						{
							cellContents = cells[wppMarker.LoadProfileCell].Trim();
							loadProfile = cellContents == null ? "" : cellContents;
							break;
						}
					case "DTM150": // begin date
						{
							cellContents = cells[wppMarker.BeginDateCell].Trim();
							beginDate = cellContents == null ? "" : cellContents;
							break;
						}
					case "DTM151": // end date
						{
							cellContents = cells[wppMarker.EndDateCell].Trim();
							endDate = cellContents == null ? "" : cellContents;

							// summary has just one ptd marker; for historical, end date is last row..
							if( ptdLoop.Equals( "SU" ) & transactionSetPurposeCode.Equals( "52" ) )
								account.EdiUsageList.Add( CreateEdiUsage( quantity, unitOfMeasurement, measurementSignificanceCode,
									transactionSetPurposeCode, meterNumber, beginDate, endDate, ptdLoop ) );

							break;
						}
					case "DTM582": // idr date
						{
							cellContents = cells[wppMarker.IdrDateCell].Trim();
							//row.FileCellList[pplMarker.IdrDateCell].Trim();
							idrDate = cellContents == null ? "" : cellContents;

							cellContents = cells[wppMarker.IdrIntervalCell].Trim();
							//row.FileCellList[pplMarker.IdrIntervalCell].Trim();
							idrInterval = cellContents == null ? "" : cellContents;

                            account.IdrUsageList[idrInterval + "-" + idrDate+ "-" +meterNumber] = createIdrUsage( meterNumber, quantity, unitOfMeasurement, transactionSetPurposeCode, idrInterval, idrDate, ptdLoop);

							break;
						}
					case "DTM514": // exchange meter date
						{
							cellContents = cells[wppMarker.BeginDateCell].Trim();
							string TransitionDate = cellContents == null ? "" : cellContents;

							if( beginDate == null | beginDate == "" )
								beginDate = TransitionDate;
							else
								endDate = TransitionDate;

							break;
						}
					case "QTYKA":
					case "QTYQD": // begin usage
						{
							cellContents = cells[wppMarker.QuantityCell].Trim();
							quantity = cellContents == null ? "" : cellContents;

							cellContents = cells[wppMarker.UnitOfMeasurementCell].Trim();
							unitOfMeasurement = cellContents == null ? "" : cellContents;

							// billed summary has just one ptd marker; for historical, quantity is last row..
							if( ptdLoop.Equals( "SU" ) & transactionSetPurposeCode.Equals( "00" ) )
								account.EdiUsageList.Add( CreateEdiUsage( quantity, unitOfMeasurement, measurementSignificanceCode,
									transactionSetPurposeCode, meterNumber, beginDate, endDate, ptdLoop ) );

							break;
						}
                    case "QTY20":
                    case "QTY87":
                    case "QTY9H":
                        {
                            cellContents = cells[wppMarker.QuantityCell].Trim();
                            quantity = cellContents == null ? "" : cellContents;
                            unitOfMeasurement = "D1";//This will skip this usage being added
                            break;
                        }
				}
			}
			return account;
		}
	}
}
