namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
    using System;
    using System.Collections.Generic;
    using System.Data.SqlTypes;
    using System.Linq;

	/// <summary>
	/// SDGE utility mapper for 867 file.
	///  Maps markers in an EDI utility file to specific values in generic collections.
	/// </summary>
	public class SdgeMapper867 : MapperBase
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public SdgeMapper867() { }

		/// <summary>
		/// Constructor that takes market and utility codes
		/// </summary>
		/// <param name="utilityCode">Utility identifier</param>
		/// <param name="marketCode">Market Identifier</param>
		public SdgeMapper867( string utilityCode, string marketCode )
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
			try
			{
				SdgeMarker sdgeMarker = new SdgeMarker();
                DateTime? transactionDate = null;
				account = new EdiAccount( "", "", "", "", "", "", "", "", "", "", "", "", "" );
				account.EdiUsageList = new EdiUsageList();
				account.IdrUsageList = new Dictionary<string, EdiIdrUsage>();
				decimal qty = 0;
				TimeSpan interval=new TimeSpan();
				DateTime date = DateTime.MinValue;

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
						case "BPT":		// transaction set purpose code
							{
								cellContents = cells[sdgeMarker.TransactionSetPurposeCodeCell].Trim();
								//row.FileCellList[pplMarker.TransactionSetPurposeCodeCell].Trim();
								transactionSetPurposeCode = cellContents == null ? "" : cellContents;
                                cellContents = "";
                                if (cells.Length > 3)
                                {
                                    string dateString = string.Empty;
                                    dateString = cells[sdgeMarker.TransactionCreationDateCell].Trim();
                                    transactionDate = DateTryParse(dateString);
                                }
								break;
							}
						case "PTD":		// new usage record..
							{
								ClearUsageVariables();
								meterNumber = "";

								cellContents = cells[sdgeMarker.PtdLoopCell].Trim();
								//row.FileCellList[pplMarker.PtdLoopCell].Trim();
								ptdLoop = cellContents == null ? "" : cellContents;

								if( ptdLoop == "PM" && transactionSetPurposeCode.Equals( "00" ) )
								{
									ptdLoop = "SU";
									ClearIdrVariables();
								}

								if( ptdLoop == "SU" )
									measurementSignificanceCode = "51";

								break;
							}
						case "SE":		// account end **********
							{
								// only found 2 billed files, both have idr data with no total kwh for the period..
								if( transactionSetPurposeCode.Equals( "00" ) )
									account.EdiUsageList.Add( CreateEdiUsage( qty.ToString(), unitOfMeasurement, measurementSignificanceCode,
										transactionSetPurposeCode, meterNumber, beginDate, endDate.Substring(0, 8), ptdLoop ) );

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
                                if ((transactionDate > (DateTime)SqlDateTime.MinValue && transactionDate < (DateTime)SqlDateTime.MaxValue))
                                    account.TransactionCreatedDate = transactionDate;
								ResetAccountVariables();							// Ticket 17219
								ptdLoop = null;
								break;
							}
					}
					switch( marker )
					{
						case "DTM150":		// begin date
							{
								cellContents = cells[sdgeMarker.BeginDateCell].Trim();
								beginDate = cellContents == null ? "" : cellContents.Substring( 0, 8 );

								break;
							}
						case "DTM151":		// end date
							{
								cellContents = cells[sdgeMarker.EndDateCell].Trim();
								endDate = cellContents == null ? "" : cellContents;

								// if billed, then get the 4-character metering interval
								if( transactionSetPurposeCode.Equals( "00" ) )
									idrInterval = cellContents == null ? "" : cellContents.Substring(8, 4);

								break;
							}
						case "DTM514":		// exchange meter date
							{
								cellContents = cells[sdgeMarker.BeginDateCell].Trim();
								string TransitionDate = cellContents == null ? "" : cellContents;

								if( beginDate == null | beginDate == "" )
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
								cellContents = cells[sdgeMarker.NameKeyCell].Trim();
								nameKey = cellContents == null ? "" : cellContents;
								break;
							}
						case "N18S":		// duns number
							{
								cellContents = cells[sdgeMarker.DunsNumberCell].Trim();
								dunsNumber = cellContents == null ? "" : cellContents;
								break;
							}
						case "QTY32":		// IDR Data..
							{
								cellContents = cells[sdgeMarker.QuantityAltCell].Trim();
								quantity = cellContents == null ? "" : cellContents;

                                account.IdrUsageList[idrInterval + "-" + endDate+"-"+meterNumber] = createIdrUsage( meterNumber, quantity, unitOfMeasurement, transactionSetPurposeCode, idrInterval, endDate.Substring(0, 8), ptdLoop);

								// add interval to date
								date = DateHelper.ConvertDateTimeString( endDate );
								date = date.Add( interval );

								// convert datetime back to string so it can be appended to the idr usage list..
								endDate = DateHelper.ConvertDateTimeString( date );

								idrInterval = endDate.Substring( 8, 4 );

								// keep track of period's total kwh
								qty += Convert.ToDecimal(quantity);

								break;
							}
						case "QTYKC":		// icap
							{
								cellContents = cells[sdgeMarker.IcapCell].Trim();
								icap = cellContents == null ? "" : cellContents;
								break;
							}
						case "QTYKZ":		// tcap
							{
								cellContents = cells[sdgeMarker.TcapCell].Trim();
								tcap = cellContents == null ? "" : cellContents;
								break;
							}
						case "QTYQD":		// begin usage
							{
								// NV - no value
								if( !fc.Contains( "NV" ) )
								{
									cellContents = cells[sdgeMarker.QuantityAltCell].Trim();
									quantity = cellContents == null ? "" : cellContents;

									cellContents = cells[sdgeMarker.UnitOfMeasurementAltCell].Trim();
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
                                    cellContents = cells[sdgeMarker.QuantityAltCell].Trim();
                                    quantity = cellContents == null ? "" : cellContents;
                                    unitOfMeasurement = "D1";
                                }
                                break;
                            }
						case "REF12":		// account number
							{
								cellContents = cells[sdgeMarker.AccountNumberCell].Trim();
								accountNumber = cellContents == null ? "" : cellContents;
								break;
							}
						case "REF45":		// previous account number
							{
								cellContents = cells[sdgeMarker.PreviousAccountNumberCell].Trim();
								previousAccountNumber = cellContents == null ? "" : cellContents;
								break;
							}
						case "REFBF":		//bill cycle
							{
								cellContents = cells[sdgeMarker.BillGroupCell].Trim();
								billGroup = cellContents == null ? "" : cellContents;
								break;
							}
						case "REFLO":		//load profile
							{
								cellContents = cells[sdgeMarker.LoadProfileCell].Trim();
								loadProfile = cellContents == null ? "" : cellContents;
								break;
							}
						case "REFMG":		// meter number
							{
								cellContents = cells[sdgeMarker.MeterNumberCell].Trim();
								meterNumber = cellContents == null ? "" : cellContents;
								break;
							}
						case "REFMT":		// 5-character field that identifies the type of consumption (K1, KH, etc.) and the interval between measurements (i.e. MON, 015, etc.)
							{
								string Interval;

								cellContents = cells[sdgeMarker.UnitOfMeasurementCell].Trim();
								unitOfMeasurement = cellContents == null ? "" : cellContents.Substring(0, 2);

								Interval = cellContents == null ? "" : cellContents.Substring( 2, 3 );

								interval = new TimeSpan(0, Convert.ToInt32(Interval), 0);

								break;
							}
						case "REFNH":		// rate class
							{
								cellContents = cells[sdgeMarker.RateClassCell].Trim();
								rateClass = cellContents == null ? "" : cellContents;
								break;
							}
						case "REFSPL":		// zone
							{
								cellContents = cells[sdgeMarker.ZoneCell].Trim();
								zone = cellContents == null ? "" : cellContents;
								break;
							}
						case "ST867":		// account start *******
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
