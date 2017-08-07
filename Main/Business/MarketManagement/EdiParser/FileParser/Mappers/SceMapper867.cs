namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Linq;
	using System.Collections.Generic;
    using System.Data.SqlTypes;

	/// <summary>
	/// SCE utility mapper for 867 file.
	///  Maps markers in an EDI utility file to specific values in generic collections.
	/// </summary>
	public class SceMapper867 : MapperBase
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public SceMapper867() { }

		/// <summary>
		/// Constructor that takes market and utility codes
		/// </summary>
		/// <param name="utilityCode">Utility identifier</param>
		/// <param name="marketCode">Market Identifier</param>
		public SceMapper867( string utilityCode, string marketCode )
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
			SceMarker sceMarker = new SceMarker();

			account = new EdiAccount( "", "", "", "", "", "", "", "", "", "", "", "", "" );
			account.EdiUsageList = new EdiUsageList();
			account.IdrUsageList = new Dictionary<string, EdiIdrUsage>();
			decimal qty = 0;
			TimeSpan interval = new TimeSpan();
			DateTime date = DateTime.MinValue;
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

				if( cell0.Equals( "SE" ) ) // account end **********
				{
					AddUsagesToList( usageListTemp, account.EdiUsageList, beginDate, endDate );

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
					ResetAccountVariables( ref accountNumber, ref billingAccountNumber, ref customerName,
						ref icap, ref nameKey, ref previousAccountNumber, ref rateClass, ref tcap, ref zone, ref usageType );
				}
				else
				{
					switch( marker )
					{
						case "N18S": // duns number
							{
								cellContents = cells[sceMarker.DunsNumberCell].Trim();
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
						case "N18R": // name key
							{
								cellContents = cells[sceMarker.NameKeyCell].Trim();
								nameKey = cellContents == null ? "" : cellContents;
								break;
							}
						case "REF12": // account number
							{
								cellContents = cells[sceMarker.AccountNumberCell].Trim();
								accountNumber = cellContents == null ? "" : cellContents;
								break;
							}
						case "REF45": // previous account number
							{
								cellContents = cells[sceMarker.PreviousAccountNumberCell].Trim();
								previousAccountNumber = cellContents == null ? "" : cellContents;
								break;
							}
						case "REFMG": // meter number
							{
								cellContents = cells[sceMarker.MeterNumberCell].Trim();
								meterNumber = cellContents == null ? "" : cellContents;
								break;
							}
						case "REFMT":		// 5-character field that identifies the type of consumption (K1, KH, etc.) and the interval between measurements (i.e. MON, 015, etc.)
							{
								string Interval;

								cellContents = cells[sceMarker.UnitOfMeasurementCell].Trim();
								unitOfMeasurement = cellContents == null ? "" : cellContents.Substring( 0, 2 );

								Interval = cellContents == null ? "" : cellContents.Substring( 2, 3 );

								interval = new TimeSpan( 0, Convert.ToInt32( Interval ), 0 );

								break;
							}
						case "REFNH": // rate class
							{
								cellContents = cells[sceMarker.RateClassCell].Trim();
								rateClass = cellContents == null ? "" : cellContents;
								break;
							}
						case "BPT00": // transaction set purpose code
						case "BPT01":
						case "BPT05":
						case "BPT06":
						case "BPT52":
							{
								cellContents = cells[sceMarker.TransactionSetPurposeCodeCell].Trim();
								transactionSetPurposeCode = cellContents == null ? "" : cellContents;
                                cellContents = "";
                                if (cells.Length > 3)
                                {
                                    string dateString = string.Empty;
                                    dateString = cells[sceMarker.TransactionCreationDateCell].Trim();
                                    transactionDate = DateTryParse(dateString);
                                }
								break;
							}
						case "QTYA5":		// IDR Data..
						case "QTYKA":
						case "QTY32":
							{
								cellContents = cells[sceMarker.QuantityAltCell].Trim();
								quantity = cellContents == null ? "" : cellContents;

								account.IdrUsageList[idrInterval + "-" + unitOfMeasurement + "-" + beginDate+meterNumber] = createIdrUsage( meterNumber, quantity, unitOfMeasurement, transactionSetPurposeCode, idrInterval, beginDate.Substring( 0, 8 ), ptdLoop );

								// add interval to date
								date = DateHelper.ConvertDateTimeString( beginDate );
								date = date.Add( interval );

								// convert datetime back to string so it can be appended to the idr usage list..
								beginDate = DateHelper.ConvertDateTimeString( date );

								idrInterval = beginDate.Substring( 8, 4 );

								// keep track of period's total kwh
								qty += Convert.ToDecimal( quantity );

								break;
							}
						case "QTYKC": // icap
							{
								cellContents = cells[sceMarker.IcapCell].Trim();
								icap = cellContents == null ? "" : cellContents;
								break;
							}
						case "QTYKZ": // tcap
							{
								cellContents = cells[sceMarker.TcapCell].Trim();
								tcap = cellContents == null ? "" : cellContents;
								break;
							}
						case "REFSPL": // zone
							{
								cellContents = cells[sceMarker.ZoneCell].Trim();
								zone = cellContents == null ? "" : cellContents;
								break;
							}
						case "REFBF":	//bill cycle
							{
								cellContents = cells[sceMarker.BillGroupCell].Trim();
								billGroup = cellContents == null ? "" : cellContents;
								break;
							}
						case "REFLO":	//load profile
							{
								cellContents = cells[sceMarker.LoadProfileCell].Trim();
								loadProfile = cellContents == null ? "" : cellContents;
								break;
							}
						case "PTDSU": // measurement significance code
							{
								measurementSignificanceCode = "51";
								break;
							}
						case "MEA": // kwh, uom, measurement significance code
							{
								cellContents = cells[sceMarker.QuantityCell].Trim();
								quantity = cellContents == null ? "" : cellContents;

								cellContents = cells[sceMarker.UnitOfMeasurementCell].Trim();
								unitOfMeasurement = cellContents == null ? "" : cellContents;

								cellContents = cells[sceMarker.MeasurementSignificanceCodeCell].Trim();
								measurementSignificanceCode = cellContents == null ? "" : cellContents;

								usageListTemp.Add( CreateEdiUsage( quantity, unitOfMeasurement, measurementSignificanceCode,
									transactionSetPurposeCode, meterNumber ) );
								break;
							}
						case "DTM150": // begin date
							{
								cellContents = cells[sceMarker.BeginDateCell].Trim();
								beginDate = cellContents == null ? "" : cellContents;

								// if billed, then get the 4-character metering interval
								if( transactionSetPurposeCode.Equals( "00" ) )
									idrInterval = cellContents == null ? "" : cellContents.Substring( 8, 4 );

								break;
							}
						case "DTM151": // end date
							{
								cellContents = cells[sceMarker.EndDateCell].Trim();
								endDate = cellContents == null ? "" : cellContents;

								// if historical, then add usage
								if( transactionSetPurposeCode.Equals( "52" ) )
									AddUsagesToList( usageListTemp, account.EdiUsageList, beginDate, endDate );
								break;
							}
						case "DTM514": // exchange meter date
							{
								cellContents = cells[sceMarker.BeginDateCell].Trim();
								string TransitionDate = cellContents == null ? "" : cellContents;

								if( beginDate == null | beginDate == "" )
									beginDate = TransitionDate;
								else
									endDate = TransitionDate;

								break;
							}
						case "QTYQD": // begin usage
							{
								// NV - no value
								if( !fc.Contains( "NV" ) )
								{
									cellContents = cells[sceMarker.QuantityAltCell].Trim();
									quantity = cellContents == null ? "" : cellContents;

									cellContents = cells[sceMarker.UnitOfMeasurementAltCell].Trim();
									unitOfMeasurement = cellContents == null ? "" : cellContents;

									// if historical, then need to wait for begin and end dates
									if( !transactionSetPurposeCode.Equals( "52" ) )
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
                                    cellContents = cells[sceMarker.QuantityAltCell].Trim();
                                    quantity = cellContents == null ? "" : cellContents;
                                    unitOfMeasurement = "D1";
                                }
                                break;
                            }
					}
				}
			}
			return account;
		}
	}
}
