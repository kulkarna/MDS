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
	/// NANT utility mapper for 867 file.
	///  Maps markers in an EDI utility file to specific values in generic collections.
	/// </summary>
	public class NantMapper867 : MapperBase
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public NantMapper867() { }

		/// <summary>
		/// Constructor that takes market and utility codes
		/// </summary>
		/// <param name="utilityCode">Utility identifier</param>
		/// <param name="marketCode">Market Identifier</param>
		public NantMapper867( string utilityCode, string marketCode )
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
			NantMarker nantMarker = new NantMarker();

			account = new EdiAccount( "", "", "", "", "", "", "", "", "", "", "", "", "" );
			account.EdiUsageList = new EdiUsageList();
            DateTime? transactionDate = null;
			// only found PTD~PM (and historical)..
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
								cellContents = cells[nantMarker.DunsNumberCell].Trim();
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
								cellContents = cells[nantMarker.NameKeyCell].Trim();
								nameKey = cellContents == null ? "" : cellContents;
								break;
							}
						case "REF12": // account number
							{
								cellContents = cells[nantMarker.AccountNumberCell].Trim();
								accountNumber = cellContents == null ? "" : cellContents;
								break;
							}
						case "REF45": // previous account number
							{
								cellContents = cells[nantMarker.PreviousAccountNumberCell].Trim();
								previousAccountNumber = cellContents == null ? "" : cellContents;
								break;
							}
						case "REFMG": // meter number
							{
								cellContents = cells[nantMarker.MeterNumberCell].Trim();
								meterNumber = cellContents == null ? "" : cellContents;
								break;
							}
						case "REFNH": // rate class
							{
								cellContents = cells[nantMarker.RateClassCell].Trim();
								rateClass = cellContents == null ? "" : cellContents;
								break;
							}
						case "BPT00": // transaction set purpose code
						case "BPT01":
						case "BPT05":
						case "BPT06":
						case "BPT52":
							{
								cellContents = cells[nantMarker.TransactionSetPurposeCodeCell].Trim();
								transactionSetPurposeCode = cellContents == null ? "" : cellContents;
                                cellContents = "";
                                if (cells.Length > 3)
                                {
                                    string dateString = string.Empty;
                                    dateString = cells[nantMarker.TransactionCreationDateCell].Trim();
                                    transactionDate = DateTryParse(dateString);
                                }
								break;
							}
						case "PSA93": // icap
							{
								cellContents = cells[nantMarker.IcapCell].Trim();
								icap = cellContents == null ? "" : cellContents;
								break;
							}
						case "QTYKZ": // tcap
							{
								cellContents = cells[nantMarker.TcapCell].Trim();
								tcap = cellContents == null ? "" : cellContents;
								break;
							}
						case "REFSPL": // zone
							{
								cellContents = cells[nantMarker.ZoneCell].Trim();
								zone = cellContents == null ? "" : cellContents;
								break;
							}
						case "REFBF":	//bill cycle
							{
								cellContents = cells[nantMarker.BillGroupCell].Trim();
								billGroup = cellContents == null ? "" : cellContents;
								break;
							}
						case "REFLO":	//load profile
							{
								cellContents = cells[nantMarker.LoadProfileCell].Trim();
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
								cellContents = cells[nantMarker.QuantityCell].Trim();
								quantity = cellContents == null ? "" : cellContents;

								cellContents = cells[nantMarker.UnitOfMeasurementCell].Trim();
								unitOfMeasurement = cellContents == null ? "" : cellContents;

								cellContents = cells[nantMarker.MeasurementSignificanceCodeCell].Trim();
								measurementSignificanceCode = cellContents == null ? "" : cellContents;

								usageListTemp.Add( CreateEdiUsage( quantity, unitOfMeasurement, measurementSignificanceCode,
									transactionSetPurposeCode, meterNumber, ptdLoop ) );
								break;
							}
						case "DTM150": // begin date
							{
								cellContents = cells[nantMarker.BeginDateCell].Trim();
								beginDate = cellContents == null ? "" : cellContents;

								break;
							}
						case "DTM151": // end date
							{
								cellContents = cells[nantMarker.EndDateCell].Trim();
								endDate = cellContents == null ? "" : cellContents;

								// if historical, then add usage
								if( transactionSetPurposeCode.Equals( "52" ) )
									AddUsagesToList( usageListTemp, account.EdiUsageList, beginDate, endDate );
								break;
							}
						case "DTM514": // exchange meter date
							{
								cellContents = cells[nantMarker.BeginDateCell].Trim();
								string TransitionDate = cellContents == null ? "" : cellContents;

								if( beginDate == null | beginDate == "" )
									beginDate = TransitionDate;
								else
									endDate = TransitionDate;

								break;
							}
						case "QTYQD": // begin usage
							{
								// if historical, then need to wait for begin and end dates
								if( !transactionSetPurposeCode.Equals( "52" ) )
								{
									account.EdiUsageList.Add( CreateEdiUsage( quantity, unitOfMeasurement, measurementSignificanceCode,
										transactionSetPurposeCode, meterNumber, beginDate, endDate, ptdLoop ) );
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
