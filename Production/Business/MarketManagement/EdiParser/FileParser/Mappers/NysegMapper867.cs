namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;
	using LibertyPower.Business.MarketManagement.UtilityManagement;
	using LibertyPower.Business.MarketManagement.EdiParser.FormatParser;
	using LibertyPower.Business.CommonBusiness.CommonEntity;
    using System.Data.SqlTypes;

	/// <summary>
	/// NYSEG utility mapper for 867 file.
	///  Maps markers in an EDI utility file to specific values in generic collections.
	/// </summary>
	public class NysegMapper867 : MapperBase
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public NysegMapper867() { }

		/// <summary>
		/// Constructor that takes market and utility codes
		/// </summary>
		/// <param name="utilityCode">Utility identifier</param>
		/// <param name="marketCode">Market Identifier</param>
		public NysegMapper867( string utilityCode, string marketCode )
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
			NysegMarker nysegMarker = new NysegMarker();

			account = new EdiAccount( "", "", "", "", "", "", "", "", "", "", "", "", "" );
			account.EdiUsageList = new EdiUsageList();
            DateTime? transactionDate = null;
			// new serviceAddress object
			serviceAddress = new GeographicalAddress();

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
							AddUsagesToList( usageListTemp, account.EdiUsageList, beginDate, endDate );

							account.AccountNumber = accountNumber;
							account.BillingAccount = billingAccountNumber;
							account.CustomerName = customerName;
							account.DunsNumber = dunsNumber;
							account.LoadProfile = loadProfile;
							account.BillGroup = (!(string.IsNullOrEmpty(billGroup)) && billGroup.Length > 0) ? billGroup : "-1";
							account.Icap = (icap != null && icap.Length > 0) ? Convert.ToDecimal( icap ) : Convert.ToDecimal( -1 );
							account.NameKey = nameKey;
							account.PreviousAccountNumber = previousAccountNumber;
							account.RateClass = rateClass;
							account.RetailMarketCode = marketCode;
							account.Tcap = (tcap != null && tcap.Length > 0) ? Convert.ToDecimal( tcap ) : Convert.ToDecimal( -1 );
							account.UtilityCode = utilityCode;
							account.ZoneCode = zone;
							account.ServiceAddress = serviceAddress;
                            if ((transactionDate > (DateTime)SqlDateTime.MinValue && transactionDate < (DateTime)SqlDateTime.MaxValue))
                                account.TransactionCreatedDate = transactionDate;
							ResetAccountVariables();
							break;
						}
					case "PTD":													// new usage record..
						{
							// skip 1st record + no double dipping (since summary-historical has only one ptd marker) + skip idr data (PM) for now..
							ClearUsageVariables();
							meterNumber = "";

							cellContents = cells[nysegMarker.PtdLoopCell].Trim();
							ptdLoop = cellContents == null ? "" : cellContents;

							// BPT^52 & BPT^00 contain mainly PTD^BQ..
							if( ptdLoop == "BQ" )
								ptdLoop = "SU";

							// some PTD^BC found..
							if( transactionSetPurposeCode == "00" && ptdLoop == "BC" )
								ptdLoop = "SU";

							if( ptdLoop == "SU" )
								measurementSignificanceCode = "51";

							break;
						}
					case "BPT": // transaction set purpose code
						{
							cellContents = cells[nysegMarker.TransactionSetPurposeCodeCell].Trim();
							transactionSetPurposeCode = cellContents == null ? "" : cellContents;
                            cellContents = "";
                            if (cells.Length > 3)
                            {
                                string dateString = string.Empty;
                                dateString = cells[nysegMarker.TransactionCreationDateCell].Trim();
                                transactionDate = DateTryParse(dateString);
                            }
							break;
						}
					case "N3": // serviceAddress
						{
							cellContents = cells[nysegMarker.AddressCell].Trim();
							serviceAddress.Street = cellContents == null ? "" : cellContents;
							break;
						}
					case "N4": // city, state, zip
						{
							cellContents = cells[nysegMarker.CityCell].Trim();
							serviceAddress.CityName = cellContents == null ? "" : cellContents;

							cellContents = cells[nysegMarker.StateCell].Trim();
							serviceAddress.State = cellContents == null ? "" : cellContents;

							cellContents = cells[nysegMarker.ZipCell].Trim();
							serviceAddress.PostalCode = cellContents == null ? "" : cellContents;

							break;
						}
				}

				switch( marker )
				{
					case "N18S": // duns number
						{
							cellContents = cells[nysegMarker.DunsNumberCell].Trim();
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
							cellContents = cells[nysegMarker.CustomerNameCell].Trim();
							customerName = cellContents == null ? "" : cellContents;
							break;
						}
					case "REF12": // account number
						{
							cellContents = cells[nysegMarker.AccountNumberCell].Trim();
							accountNumber = cellContents == null ? "" : cellContents;
							break;
						}
					case "REF45": // previous account number
						{
							cellContents = cells[nysegMarker.PreviousAccountNumberCell].Trim();
							previousAccountNumber = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFMG": // meter number
						{
							cellContents = cells[nysegMarker.MeterNumberCell].Trim();
							meterNumber = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFNH": // rate class
						{
							cellContents = cells[nysegMarker.RateClassCell].Trim();
							rateClass = cellContents == null ? "" : cellContents;
							break;
						}
					case "QTYKC": // tcap
						{
							cellContents = cells[nysegMarker.IcapCell].Trim();
							icap = cellContents == null ? "" : cellContents;
							break;
						}
					case "QTYKZ": // icap PBI_96149
						{
							cellContents = cells[nysegMarker.IcapCell].Trim();
							icap = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFSPL": // zone
						{
							cellContents = cells[nysegMarker.ZoneCell].Trim();
							zone = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFBF":	//bill cycle
						{
							cellContents = cells[nysegMarker.BillGroupCell].Trim();
							billGroup = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFLO":	//load profile
						{
							cellContents = cells[nysegMarker.LoadProfileCell].Trim();
							loadProfile = cellContents == null ? "" : cellContents;
							break;
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
								cellContents = cells[nysegMarker.QuantityCell].Trim();
								quantity = cellContents == null ? "" : cellContents;

								cellContents = cells[nysegMarker.UnitOfMeasurementCell].Trim();
								unitOfMeasurement = cellContents == null ? "" : cellContents;

								if( nysegMarker.MeasurementSignificanceCodeCell < cells.Length )
								{
									cellContents = cells[nysegMarker.MeasurementSignificanceCodeCell].Trim();
									measurementSignificanceCode = cellContents == null ? "" : cellContents;
								}
								else
									measurementSignificanceCode = "";

								usageListTemp.Add( CreateEdiUsage( quantity, unitOfMeasurement, measurementSignificanceCode,
									transactionSetPurposeCode, meterNumber, ptdLoop ) );
							}
							break;
						}
					case "DTM150": // begin date
						{
							cellContents = cells[nysegMarker.BeginDateCell].Trim();
							beginDate = cellContents == null ? "" : cellContents;

							break;
						}
					case "DTM151": // end date
						{
							cellContents = cells[nysegMarker.EndDateCell].Trim();
							endDate = cellContents == null ? "" : cellContents;

							// if historical, then add usage
							if( transactionSetPurposeCode.Equals( "52" ) )
								AddUsagesToList( usageListTemp, account.EdiUsageList, beginDate, endDate );

							break;
						}
					case "DTM514": // exchange meter date
						{
							cellContents = cells[nysegMarker.BeginDateCell].Trim();
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
								cellContents = cells[nysegMarker.QuantityAltCell].Trim();
								quantity = cellContents == null ? "" : cellContents;

								cellContents = cells[nysegMarker.UnitOfMeasurementAltCell].Trim();
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
                                cellContents = cells[nysegMarker.QuantityAltCell].Trim();
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
