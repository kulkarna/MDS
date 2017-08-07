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
	/// BGE utility mapper for 867 file.
	///  Maps markers in an EDI utility file to specific values in generic collections.
	/// </summary>
	public class BgeMapper867 : MapperBase
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public BgeMapper867() { }

		/// <summary>
		/// Constructor that takes market and utility codes
		/// </summary>
		/// <param name="utilityCode">Utility identifier</param>
		/// <param name="marketCode">Market Identifier</param>
		public BgeMapper867( string utilityCode, string marketCode )
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
			BgeMarker bgeMarker = new BgeMarker();
			account = new EdiAccount( "", "", "", "", "", "", "", "", "", "", "", "", "" );
			account.EdiUsageList = new EdiUsageList();
               DateTime? transactionDate=null;  
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
							AddUsagesToList( usageListTemp, account.EdiUsageList, beginDate, endDate, ptdLoop );

					account.AccountNumber = accountNumber;
					account.BillingAccount = billingAccountNumber;
					account.CustomerName = customerName;
					account.DunsNumber = dunsNumber;
							account.MeterNumber = meterNumber;
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
							ptdLoop = null;
							ResetAccountVariables();
							break;
						}
					case "PTD":													// new usage record..
						{
							// skip 1st record + no double dipping (since summary has only one ptd marker)..
							if( ptdLoop != null )
								AddUsagesToList( usageListTemp, account.EdiUsageList, beginDate, endDate, ptdLoop );

							ClearUsageVariables();
							meterNumber = "";

							cellContents = cells[bgeMarker.PtdLoopCell].Trim();
							ptdLoop = cellContents == null ? "" : cellContents;

							if( ptdLoop == "SU" )
								measurementSignificanceCode = "51";

							break;
				}
					case "BPT": // transaction set purpose code
				{
							cellContents = cells[bgeMarker.TransactionSetPurposeCodeCell].Trim();
							transactionSetPurposeCode = cellContents == null ? "" : cellContents;
                            cellContents = "";
                            if (cells.Length > 3)
                            {
                                string dateString = string.Empty;
                                dateString = cells[bgeMarker.TransactionCreationDateCell].Trim();
                                transactionDate = DateTryParse(dateString);
                            }
							break;
						}
				}
					switch( marker )
					{
						case "N18S": // duns number
							{
								cellContents = cells[bgeMarker.DunsNumberCell].Trim();
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
								cellContents = cells[bgeMarker.CustomerNameCell].Trim();
								customerName = cellContents == null ? "" : cellContents;
								break;
							}
						case "REF12": // account number
							{
								cellContents = cells[bgeMarker.AccountNumberCell].Trim();
								accountNumber = cellContents == null ? "" : cellContents;
								break;
							}
						case "REF45": // previous account number
							{
								cellContents = cells[bgeMarker.PreviousAccountNumberCell].Trim();
								previousAccountNumber = cellContents == null ? "" : cellContents;
								break;
							}
						case "REFMG": // meter number
							{
								cellContents = cells[bgeMarker.MeterNumberCell].Trim();
								meterNumber = cellContents == null ? "" : cellContents;
								break;
							}
						case "REFNH": // rate class
							{
								cellContents = cells[bgeMarker.RateClassCell].Trim();
								rateClass = cellContents == null ? "" : cellContents;
								break;
							}
					case "AMTKC": // icap
							{
								cellContents = cells[bgeMarker.IcapCell].Trim();
								icap = cellContents == null ? "" : cellContents;
								break;
							}
					case "AMTKZ": // tcap
							{
								cellContents = cells[bgeMarker.TcapCell].Trim();
								tcap = cellContents == null ? "" : cellContents;
								break;
							}
						case "REFSPL": // zone
							{
								cellContents = cells[bgeMarker.ZoneCell].Trim();
								zone = cellContents == null ? "" : cellContents;
								break;
							}
						case "REFBF":	//bill cycle
							{
								cellContents = cells[bgeMarker.BillGroupCell].Trim();
								billGroup = cellContents == null ? "" : cellContents;
								break;
							}
						case "REFLO":	//load profile
							{
								cellContents = cells[bgeMarker.LoadProfileCell].Trim();
								loadProfile = cellContents == null ? "" : cellContents;
								break;
							}
						case "MEAAA": // kwh, uom, measurement significance code
						case "MEAAE":
						case "MEAEA":
						case "MEAEE":
							{
								cellContents = cells[bgeMarker.QuantityCell].Trim();
								quantity = cellContents == null ? "" : cellContents;

								cellContents = cells[bgeMarker.UnitOfMeasurementCell].Trim();
							unitOfMeasurement = cellContents == null || cellContents.Length.Equals( 0 ) ? usageType : cellContents;

								cellContents = cells[bgeMarker.MeasurementSignificanceCodeCell].Trim();
								measurementSignificanceCode = cellContents == null ? "" : cellContents;

								usageListTemp.Add( CreateEdiUsage( quantity, unitOfMeasurement, measurementSignificanceCode,
									transactionSetPurposeCode, meterNumber ) );
								break;
							}
						case "DTM150": // begin date
							{
								cellContents = cells[bgeMarker.BeginDateCell].Trim();
								beginDate = cellContents == null ? "" : cellContents;

								break;
							}
						case "DTM151": // end date
							{
								cellContents = cells[bgeMarker.EndDateCell].Trim();
								endDate = cellContents == null ? "" : cellContents;

								// if historical, then add usage
							if( ptdLoop.Equals( "SU" ) & transactionSetPurposeCode.Equals( "52" ) )
								account.EdiUsageList.Add( CreateEdiUsage( quantity, unitOfMeasurement, measurementSignificanceCode,
									transactionSetPurposeCode, meterNumber, beginDate, endDate, ptdLoop ) );

								break;
							}
						case "DTM514": // exchange meter date
							{
								cellContents = cells[bgeMarker.BeginDateCell].Trim();
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
									cellContents = cells[bgeMarker.QuantityAltCell].Trim();
									quantity = cellContents == null ? "" : cellContents;

									cellContents = cells[bgeMarker.UnitOfMeasurementAltCell].Trim();
									unitOfMeasurement = cellContents == null ? "" : cellContents;

									// if historical, then need to wait for begin and end dates
								if( ptdLoop.Equals( "SU" ) & transactionSetPurposeCode != "52" )
										account.EdiUsageList.Add( CreateEdiUsage( quantity, unitOfMeasurement, measurementSignificanceCode,
											transactionSetPurposeCode, meterNumber, beginDate, endDate, ptdLoop ) );

								}
								break;
							}
                        case "QTY20":
                        case "QTY87":
                        case "QTY9H":
                            {
                                if (!fc.Contains("NV"))
                                {
                                    cellContents = cells[bgeMarker.QuantityAltCell].Trim();
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
