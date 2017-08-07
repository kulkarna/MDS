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
	/// NSTAR-BOS utility mapper for 867 file.
	///  Maps markers in an EDI utility file to specific values in generic collections.
	/// </summary>
	public class NstarMapper867 : MapperBase
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public NstarMapper867() { }

		/// <summary>
		/// Constructor that takes market and utility codes
		/// </summary>
		/// <param name="utilityCode">Utility identifier</param>
		/// <param name="marketCode">Market Identifier</param>
		public NstarMapper867( string utilityCode, string marketCode )
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
			NstarMarker nstarMarker = new NstarMarker();

			account = new EdiAccount( "", "", "", "", "", "", "", "", "", "", "", "", "" );
			account.EdiUsageList = new EdiUsageList();
            DateTime? transactionDate = null;
			// only found PTD*PM (and historical)..
			ptdLoop = "SU";

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
							account.ZoneCode = zone;
                            if ((transactionDate > (DateTime)SqlDateTime.MinValue && transactionDate < (DateTime)SqlDateTime.MaxValue))
                                account.TransactionCreatedDate = transactionDate;
							

							

							ResetAccountVariables();
							break;
						}
					case "PTD":													// new ptd loop value..
						{
							ClearUsageVariables();
							meterNumber = "";

							cellContents = cells[nstarMarker.PtdLoopCell].Trim();
							ptdLoop = cellContents == null ? "" : cellContents;

							// only found PTD*PM for historical..
							if( ptdLoop == "PM" & transactionSetPurposeCode == "52" )
								ptdLoop = "SU";

							if( ptdLoop == "SU" )
								measurementSignificanceCode = "51";

							break;
						}
					case "BPT":													// transaction set purpose code
						{
							cellContents = cells[nstarMarker.TransactionSetPurposeCodeCell].Trim();
							transactionSetPurposeCode = cellContents == null ? "" : cellContents;
                            cellContents = "";
                            if (cells.Length > 3)
                            {
                                string dateString = string.Empty;
                                dateString = cells[nstarMarker.TransactionCreationDateCell].Trim();
                                transactionDate = DateTryParse(dateString);
                            }
							break;
						}
				}

				switch( marker )
				{
					case "N18S": // duns number
						{
							cellContents = cells[nstarMarker.DunsNumberCell].Trim();
							dunsNumber = cellContents == null ? "" : cellContents;

							switch( dunsNumber )
							{
								case "006951552":
									utilityCode = "NSTAR-BOS";
									break;
								case "006953665":
									utilityCode = "NSTAR-CAMB";
									break;
								case "006953848":
									utilityCode = "NSTAR-COMM";
									break;
							}

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
							cellContents = cells[nstarMarker.NameKeyCell].Trim();
							nameKey = cellContents == null ? "" : cellContents;
							break;
						}
					case "REF12": // account number
						{
							cellContents = cells[nstarMarker.AccountNumberCell].Trim();
							accountNumber = cellContents == null ? "" : cellContents;
							break;
						}
					case "REF45": // previous account number
						{
							cellContents = cells[nstarMarker.PreviousAccountNumberCell].Trim();
							previousAccountNumber = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFMG": // meter number
						{
							cellContents = cells[nstarMarker.MeterNumberCell].Trim();
							meterNumber = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFNH": // rate class
						{
							cellContents = cells[nstarMarker.RateClassCell].Trim();
							rateClass = cellContents == null ? "" : cellContents;
							break;
						}
					case "PSA93": // icap
						{
							cellContents = cells[nstarMarker.IcapCell].Trim();
							icap = cellContents == null ? "" : cellContents;
							break;
						}
					case "QTYKZ": // tcap
						{
							cellContents = cells[nstarMarker.TcapCell].Trim();
							tcap = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFSPL": // zone
						{
							cellContents = cells[nstarMarker.ZoneCell].Trim();
							zone = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFBF":	//bill cycle
						{
							cellContents = cells[nstarMarker.BillGroupCell].Trim();
							billGroup = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFLO":	//load profile
						{
							cellContents = cells[nstarMarker.LoadProfileCell].Trim();
							loadProfile = cellContents == null ? "" : cellContents;
							break;
						}
					case "MEA": // kwh, uom, measurement significance code
						{
							cellContents = cells[nstarMarker.UnitOfMeasurementCell].Trim();

							// skip demand; decision made by me :-SS ..
							if( cellContents == "KH" )
							{
								unitOfMeasurement = cellContents == null ? "" : cellContents;

								cellContents = cells[nstarMarker.QuantityCell].Trim();
								quantity = cellContents == null ? "" : cellContents;

								cellContents = cells[nstarMarker.MeasurementSignificanceCodeCell].Trim();
								measurementSignificanceCode = cellContents == null ? "" : cellContents;
							}

							break;
						}
					case "DTM514": // exchange meter date
						{
							cellContents = cells[nstarMarker.BeginDateCell].Trim();
							string TransitionDate = cellContents == null ? "" : cellContents;

							if( beginDate == null | beginDate == "" )
								beginDate = TransitionDate;
							else
								endDate = TransitionDate;

							break;
						}
					case "DTM150": // begin date
						{
							cellContents = cells[nstarMarker.BeginDateCell].Trim();
							beginDate = cellContents == null ? "" : cellContents;
							break;
						}
					case "DTM151": // end date
						{
							cellContents = cells[nstarMarker.EndDateCell].Trim();
							endDate = cellContents == null ? "" : cellContents;

							// if historical, then add usage
							if( transactionSetPurposeCode.Equals( "52" ) )
								account.EdiUsageList.Add( CreateEdiUsage( quantity, unitOfMeasurement, measurementSignificanceCode,
									transactionSetPurposeCode, meterNumber, beginDate, endDate, ptdLoop ) );

							break;
						}
					case "QTYQD": // begin usage
						{
							// NV - no value
							if( !fc.Contains( "NV" ) )
							{
								cellContents = cells[nstarMarker.QuantityAltCell].Trim();
								quantity = cellContents == null ? "" : cellContents;

								cellContents = cells[nstarMarker.UnitOfMeasurementAltCell].Trim();
								unitOfMeasurement = cellContents == null ? "" : cellContents;

								// if historical, then need to wait for begin and end dates
								if( !transactionSetPurposeCode.Equals( "52" ) )
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
                                cellContents = cells[nstarMarker.QuantityAltCell].Trim();
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
