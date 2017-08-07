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
	/// CTPEN utility mapper for 867 file.
	///  Maps markers in an EDI utility file to specific values in generic collections.
	/// </summary>
	public class CtpenMapper867 : MapperBase
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public CtpenMapper867() { }

		/// <summary>
		/// Constructor that takes market and utility codes
		/// </summary>
		/// <param name="utilityCode">Utility identifier</param>
		/// <param name="marketCode">Market Identifier</param>
		public CtpenMapper867( string utilityCode, string marketCode )
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
			CtpenMarker ctpenMarker = new CtpenMarker();

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

							cellContents = cells[ctpenMarker.PtdLoopCell].Trim();
							ptdLoop = cellContents == null ? "" : cellContents;

							// BPT*52 only contains PTD*PL thus won't make it to the EdiUsage table..
							if( transactionSetPurposeCode == "52" & ptdLoop == "PL" )
								ptdLoop = "SU";

							if( ptdLoop == "SU" )
								measurementSignificanceCode = "51";

							break;
						}
					case "BPT": // transaction set purpose code
						{
							cellContents = cells[ctpenMarker.TransactionSetPurposeCodeCell].Trim();
							transactionSetPurposeCode = cellContents == null ? "" : cellContents;
                            cellContents = "";
                            if (cells.Length > 3)
                            {
                                string dateString = string.Empty;
                                dateString = cells[ctpenMarker.TransactionCreationDateCell].Trim();
                                transactionDate = DateTryParse(dateString);
                            }
							break;
						}
				}
				switch( marker )
				{
					case "N18S": // duns number
						{
							cellContents = cells[ctpenMarker.DunsNumberCell].Trim();
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
							cellContents = cells[ctpenMarker.CustomerNameCell].Trim();
							customerName = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFQ5": // account number
						{
							cellContents = cells[ctpenMarker.AccountNumberCell].Trim();
							accountNumber = cellContents == null ? "" : cellContents;
							break;
						}
					case "REF45": // previous account number
						{
							cellContents = cells[ctpenMarker.PreviousAccountNumberCell].Trim();
							previousAccountNumber = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFMG": // meter number
						{
							cellContents = cells[ctpenMarker.MeterNumberCell].Trim();
							meterNumber = cellContents == null ? "" : cellContents;
							break;
						}
                    case "PTDPM": // meter number
                        {
                            cellContents = cells[ctpenMarker.IdrMeterNumberCell].Trim();
                            meterNumber = cellContents == null ? "" : cellContents;
                            ptdLoop = cells[ctpenMarker.PtdLoopCell].Trim();
                            break;
                        }
					case "REFNH": // rate class
						{
							cellContents = cells[ctpenMarker.RateClassCell].Trim();
							rateClass = cellContents == null ? "" : cellContents;
							break;
						}
					case "QTYKC": // icap
						{
							cellContents = cells[ctpenMarker.IcapCell].Trim();
							icap = cellContents == null ? "" : cellContents;
							break;
						}
					case "QTYKZ": // tcap
						{
							cellContents = cells[ctpenMarker.TcapCell].Trim();
							tcap = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFSPL": // zone
						{
							cellContents = cells[ctpenMarker.ZoneCell].Trim();
							zone = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFBF":	//bill cycle
						{
							cellContents = cells[ctpenMarker.BillGroupCell].Trim();
							billGroup = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFLO":	//load profile
						{
							cellContents = cells[ctpenMarker.LoadProfileCell].Trim();
							loadProfile = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFMT": // usage type
						{
							cellContents = cells[ctpenMarker.UsageTypeCell].Trim();
							usageType = cellContents == null ? "" : cellContents;
							if( usageType.Length > 2 )
								usageType = usageType.Substring( 0, 2 );

							unitOfMeasurement = unitOfMeasurement == null || unitOfMeasurement.Length.Equals( 0 ) ? usageType : unitOfMeasurement;

							break;
						}
					case "MEA": // kwh, uom, measurement significance code
					case "MEAAA":
					case "MEAAE":
					case "MEAAN":
					case "MEAEA":
					case "MEAEE":
					case "MEAEN":
                   // case "MEAAF":
						{
							// when marker is MEA, then there will be rows that are not usage
							if( !fc.Contains( "MU" ) && !fc.Contains( "ZA" ) && !fc.Contains( "CO" ) )
							{
								cellContents = cells[ctpenMarker.QuantityCell].Trim();
								quantity = cellContents == null ? "" : cellContents;

								cellContents = cells[ctpenMarker.UnitOfMeasurementCell].Trim();
								unitOfMeasurement = cellContents == null || cellContents.Length.Equals( 0 ) ? usageType : cellContents;

								if( ctpenMarker.MeasurementSignificanceCodeCell < cells.Length )
								{
									cellContents = cells[ctpenMarker.MeasurementSignificanceCodeCell].Trim();
									measurementSignificanceCode = cellContents == null ? "" : cellContents;
								}
								else
									measurementSignificanceCode = "";

								usageListTemp.Add( CreateEdiUsage( quantity, unitOfMeasurement, measurementSignificanceCode,
									transactionSetPurposeCode, meterNumber ) );
							}
							break;
						}
					case "DTM194": // idr date
						{
							cellContents = cells[ctpenMarker.IdrDateCell].Trim();
							idrDate = cellContents == null ? "" : cellContents;

							cellContents = cells[ctpenMarker.IdrIntervalCell].Trim();
							idrInterval = cellContents == null ? "" : cellContents;
                            if(ptdLoop.ToUpper()=="PM")
                            account.IdrUsageList[idrInterval + idrDate + unitOfMeasurement+meterNumber] = createIdrUsage( meterNumber, quantity, unitOfMeasurement, transactionSetPurposeCode, idrInterval, idrDate, ptdLoop);

							break;
						}
					case "DTM514": // exchange meter date
						{
							cellContents = cells[ctpenMarker.BeginDateCell].Trim();
							string TransitionDate = cellContents == null ? "" : cellContents;

							if( beginDate == null | beginDate == "" )
								beginDate = TransitionDate;
							else
								endDate = TransitionDate;

							break;
						}
					case "DTM150": // begin date
						{
							cellContents = cells[ctpenMarker.BeginDateCell].Trim();
							beginDate = cellContents == null ? "" : cellContents;
							break;
						}
					case "DTM151": // end date
						{
							cellContents = cells[ctpenMarker.EndDateCell].Trim();
							endDate = cellContents == null ? "" : cellContents;

							// BPT*00 only contains PTD*IA for IDR File-Types..
							if( transactionSetPurposeCode == "00" & ptdLoop == "IA" )
								account.EdiUsageList.Add( CreateEdiUsage( quantity, unitOfMeasurement, "51",
																		transactionSetPurposeCode, meterNumber, beginDate, endDate, "SU" ) );

							break;
						}
					case "QTYQD": // begin usage
						{
							cellContents = cells[ctpenMarker.QuantityAltCell].Trim();
							quantity = cellContents == null ? "" : cellContents;
							break;
						}
                    case "QTY20":
                    case "QTY87":
                    case "QTY9H":
                        {
                            cellContents = cells[ctpenMarker.QuantityAltCell].Trim();
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
