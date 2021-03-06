﻿namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;
	using LibertyPower.Business.MarketManagement.UtilityManagement;
	using LibertyPower.Business.MarketManagement.EdiParser.FormatParser;
    using System.Data.SqlTypes;

	/// <summary>
	/// UI utility mapper for 867 file.
	///  Maps markers in an EDI utility file to specific values in generic collections.
	/// </summary>
	public class UiMapper867 : MapperBase
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public UiMapper867() { }

		/// <summary>
		/// Constructor that takes market and utility codes
		/// </summary>
		/// <param name="utilityCode">Utility identifier</param>
		/// <param name="marketCode">Market Identifier</param>
		public UiMapper867( string utilityCode, string marketCode )
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
			UiMarker uiMarker = new UiMarker();
            DateTime? transactionDate = null;
			account = new EdiAccount( "", "", "", "", "", "", "", "", "", "", "", "", "" );
			account.EdiUsageList = new EdiUsageList();

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
                    //  Commented by : Vikas Sharma
                    // Details  :  In UI we have Date details after MEA Loop so no need to store Temp List 
				    //AddUsagesToList( usageListTemp, account.EdiUsageList, beginDate, endDate );
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
								cellContents = cells[uiMarker.DunsNumberCell].Trim();
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
								cellContents = cells[uiMarker.NameKeyCell].Trim();
								nameKey = cellContents == null ? "" : cellContents;
								break;
							}
						case "REF12": // account number
							{
								cellContents = cells[uiMarker.AccountNumberCell].Trim();
								accountNumber = cellContents == null ? "" : cellContents;
								break;
							}
						case "REF45": // previous account number
							{
								cellContents = cells[uiMarker.PreviousAccountNumberCell].Trim();
								previousAccountNumber = cellContents == null ? "" : cellContents;
								break;
							}
						case "REFMG": // meter number
							{
								cellContents = cells[uiMarker.MeterNumberCell].Trim();
								meterNumber = cellContents == null ? "" : cellContents;
								break;
							}
						case "REFNH": // rate class
							{
								cellContents = cells[uiMarker.RateClassCell].Trim();
								rateClass = cellContents == null ? "" : cellContents;
								break;
							}
						case "BPT00": // transaction set purpose code
						case "BPT01":
						case "BPT05":
						case "BPT06":
						case "BPT52":
							{
								cellContents = cells[uiMarker.TransactionSetPurposeCodeCell].Trim();
								transactionSetPurposeCode = cellContents == null ? "" : cellContents;
                                cellContents = "";
                                if (cells.Length > 3)
                                {
                                    string dateString = string.Empty;
                                    dateString = cells[uiMarker.TransactionCreationDateCell].Trim();
                                    transactionDate = DateTryParse(dateString);
                                }
								break;
							}
						case "PSA93": // icap
							{
								string iCap = "";

								cellContents = cells[uiMarker.IcapCell].Trim();
								iCap = cellContents == null ? "" : cellContents;

								if (iCap == "ICAP TAG")
								{
									cellContents = cells[uiMarker.IcapCell + 1].Trim();
									icap = cellContents == null ? "" : cellContents;
								}

								break;
							}
						case "QTYKZ": // tcap
							{
								cellContents = cells[uiMarker.TcapCell].Trim();
								tcap = cellContents == null ? "" : cellContents;
								break;
							}
						case "REFSPL": // zone
							{
								cellContents = cells[uiMarker.ZoneCell].Trim();
								zone = cellContents == null ? "" : cellContents;
								break;
							}
						case "REFBF":	//bill cycle
							{
								cellContents = cells[uiMarker.BillGroupCell].Trim();
								billGroup = cellContents == null ? "" : cellContents;
								break;
							}
						case "REFLO":	//load profile
							{
								cellContents = cells[uiMarker.LoadProfileCell].Trim();
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
								cellContents = cells[uiMarker.QuantityCell].Trim();
								quantity = cellContents == null ? "" : cellContents;

								cellContents = cells[uiMarker.UnitOfMeasurementCell].Trim();
								unitOfMeasurement = cellContents == null ? "" : cellContents;

								cellContents = cells[uiMarker.MeasurementSignificanceCodeCell].Trim();
								measurementSignificanceCode = cellContents == null ? "" : cellContents;
                                //  Commented by : Vikas Sharma
                                // Details  :  In UI we have Date details after MEA Loop so no need to store Temp List 
                                //usageListTemp.Add( CreateEdiUsage( quantity, unitOfMeasurement, measurementSignificanceCode,
                                //    transactionSetPurposeCode, meterNumber ) );
								break;
							}
						case "DTM150": // begin date
							{
								cellContents = cells[uiMarker.BeginDateCell].Trim();
								beginDate = cellContents == null ? "" : cellContents;

								break;
							}
						case "DTM151": // end date
							{
								cellContents = cells[uiMarker.EndDateCell].Trim();
								endDate = cellContents == null ? "" : cellContents;

								// if historical, then add usage
								if( transactionSetPurposeCode.Equals( "52" ) )
								{
									account.EdiUsageList.Add( CreateEdiUsage( quantity, unitOfMeasurement, measurementSignificanceCode,
										transactionSetPurposeCode, meterNumber, beginDate, endDate, null ) );
								}
								break;
							}
						case "DTM514": // exchange meter date
							{
								cellContents = cells[uiMarker.BeginDateCell].Trim();
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
									cellContents = cells[uiMarker.QuantityAltCell].Trim();
									quantity = cellContents == null ? "" : cellContents;

									cellContents = cells[uiMarker.UnitOfMeasurementAltCell].Trim();
									unitOfMeasurement = cellContents == null ? "" : cellContents;

									// if historical, then need to wait for begin and end dates
									if( !transactionSetPurposeCode.Equals( "52" ) )
									{
										account.EdiUsageList.Add( CreateEdiUsage( quantity, unitOfMeasurement, measurementSignificanceCode,
											transactionSetPurposeCode, meterNumber, beginDate, endDate, null ) );
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
                                    cellContents = cells[uiMarker.QuantityAltCell].Trim();
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
