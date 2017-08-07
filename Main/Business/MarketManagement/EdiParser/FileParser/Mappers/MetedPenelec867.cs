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
	/// Both Meted and Penelec come in one single file; this is the 867 parser for these files..
	/// </summary>

	public class MetedPenelec867 : MapperBase
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public MetedPenelec867() { }

		/// <summary>
		/// Constructor that takes market and utility codes
		/// </summary>
		/// <param name="utilityCode"></param>
		/// <param name="marketCode"></param>
		public MetedPenelec867( string utilityCode, string marketCode )
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
            DateTime? transactionDate = null;
			MetedPenelecMaker metePeneMarker = new MetedPenelecMaker();

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
					case "SE": // account end **********
						{
							account.EdiUsageList.Add( CreateEdiUsage( quantity, unitOfMeasurement, measurementSignificanceCode,
								transactionSetPurposeCode, meterNumber, beginDate, endDate, ptdLoop ) );

							account.AccountNumber = accountNumber;
							account.BillGroup = (!(string.IsNullOrEmpty(billGroup)) && billGroup.Length > 0) ? billGroup : "-1";
							account.BillingAccount = billingAccountNumber;
							account.CustomerName = customerName;
							account.DunsNumber = dunsNumber;

							account.Icap = (icap != null && icap.Length > 0) ? Convert.ToDecimal( icap ) : Convert.ToDecimal( -1 );
							account.LoadProfile = loadProfile;
							account.LossFactor = (lossFactor != null && lossFactor.Length > 0) ? Convert.ToDecimal( lossFactor ) : Convert.ToDecimal( -1 );
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
					case "PTD":													// new ptd loop value..
						{
							// skip skip 1st record + record header + no double dipping (since summary has only one ptd marker)..
							if( ptdLoop != null & ptdLoop != "FG" & ptdLoop != "SU" )
								account.EdiUsageList.Add( CreateEdiUsage( quantity, unitOfMeasurement, measurementSignificanceCode,
									transactionSetPurposeCode, meterNumber, beginDate, endDate, ptdLoop ) );

							ClearUsageVariables();
							meterNumber = "";

							cellContents = cells[metePeneMarker.PtdLoopCell].Trim();
							ptdLoop = cellContents == null ? "" : cellContents;

							if( ptdLoop == "SU" || ptdLoop == "BC" )
								measurementSignificanceCode = "51";

							break;
						}
					case "BPT": // transaction set purpose code
						{
							cellContents = cells[metePeneMarker.TransactionSetPurposeCodeCell].Trim();
							transactionSetPurposeCode = cellContents == null ? "" : cellContents;
                            cellContents = "";
                            if (cells.Length > 3)
                            {
                                string dateString = string.Empty;
                                dateString = cells[metePeneMarker.TransactionCreationDateCell].Trim();
                                transactionDate = DateTryParse(dateString);
                            }
							break;
						}
				}
				switch( marker )
				{
					case "N18S": // duns number
						{
							cellContents = cells[metePeneMarker.DunsNumberCell].Trim();
							dunsNumber = cellContents == null ? "" : cellContents;

							switch( dunsNumber )
							{
								case "008967614":
									utilityCode = "PENELEC";
									break;
								case "007916836":
									utilityCode = "METED";
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
					case "N18R": // customer name
						{
							cellContents = cells[metePeneMarker.CustomerNameCell].Trim();
							customerName = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFSV": // voltage
						{
							cellContents = cells[metePeneMarker.VoltageCell].Trim();
							voltage = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFLF": // loss factor
						{
							cellContents = cells[metePeneMarker.LossFactorCell].Trim();
							lossFactor = cellContents == null ? "" : cellContents;
							break;
						}
					case "REF12": // account number
						{
							cellContents = cells[metePeneMarker.AccountNumberCell].Trim();
							accountNumber = cellContents == null ? "" : cellContents;
							break;
						}
					case "REF45": // previous account number
						{
							cellContents = cells[metePeneMarker.PreviousAccountNumberCell].Trim();
							previousAccountNumber = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFMG": // meter number
						{
							cellContents = cells[metePeneMarker.MeterNumberCell].Trim();
							meterNumber = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFNH": // rate class
						{
							cellContents = cells[metePeneMarker.RateClassCell].Trim();
							rateClass = cellContents == null ? "" : cellContents;
							break;
						}
					case "QTYKC": // icap
						{
							cellContents = cells[metePeneMarker.IcapCell].Trim();
							icap = cellContents == null ? "" : cellContents;
							icapList.Add( new Icap( (icap != null && icap.Length > 0) ? Convert.ToDecimal( icap ) : -1m ) );
							icapDatesMissing = true;
							break;
						}
					case "QTYKZ": // tcap
						{
							cellContents = cells[metePeneMarker.TcapCell].Trim();
							tcap = cellContents == null ? "" : cellContents;
							tcapList.Add( new Tcap( (tcap != null && tcap.Length > 0) ? Convert.ToDecimal( tcap ) : -1m ) );
							tcapDatesMissing = true;
							break;
						}
					case "DTM007": // date range for icap or tcap
						{
							cellContents = cells[metePeneMarker.IcapTcapDateRangeCell].Trim();
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
							cellContents = cells[metePeneMarker.ZoneCell].Trim();
							zone = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFBF":	//bill cycle
						{
							cellContents = cells[metePeneMarker.BillGroupCell].Trim();
							billGroup = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFLO":	//load profile
						{
							cellContents = cells[metePeneMarker.LoadProfileCell].Trim();
							loadProfile = cellContents == null ? "" : cellContents;
							break;
						}
					case "DTM150": // begin date
						{
							cellContents = cells[metePeneMarker.BeginDateCell].Trim();
							beginDate = cellContents == null ? "" : cellContents;
							break;
						}
					case "DTM151": // end date
						{
							cellContents = cells[metePeneMarker.EndDateCell].Trim();
							endDate = cellContents == null ? "" : cellContents;

							if( ptdLoop.Equals( "SU" ) & transactionSetPurposeCode.Equals( "52" ) )	// summary has just one ptd marker
								account.EdiUsageList.Add( CreateEdiUsage( quantity, unitOfMeasurement, measurementSignificanceCode,
									transactionSetPurposeCode, meterNumber, beginDate, endDate, ptdLoop ) );

							break;
						}
					case "DTM582": // idr date
						{
							cellContents = cells[metePeneMarker.IdrDateCell].Trim();
							idrDate = cellContents == null ? "" : cellContents;

							cellContents = cells[metePeneMarker.IdrIntervalCell].Trim();
							idrInterval = cellContents == null ? "" : cellContents;

							account.IdrUsageList[idrInterval + idrDate + unitOfMeasurement+meterNumber] = createIdrUsage( meterNumber, quantity, unitOfMeasurement, transactionSetPurposeCode, idrInterval, idrDate, ptdLoop );

							break;
						}
					case "DTM514": // exchange meter date
						{
							cellContents = cells[metePeneMarker.BeginDateCell].Trim();
							string TransitionDate = cellContents == null ? "" : cellContents;

							if( beginDate == null | beginDate == "" )
								beginDate = TransitionDate;
							else
								endDate = TransitionDate;

							break;
						}
					case "QTYKA":
					case "QTYD1":
					case "QTYQD": // begin usage
						{
							cellContents = cells[metePeneMarker.QuantityAltCell].Trim();
							quantity = cellContents == null ? "" : cellContents;

							cellContents = cells[metePeneMarker.UnitOfMeasurementAltCell].Trim();
							unitOfMeasurement = cellContents == null ? "" : cellContents;

							if( ptdLoop.Equals( "SU" ) & transactionSetPurposeCode != "52" )	// summary has just one ptd marker
								account.EdiUsageList.Add( CreateEdiUsage( quantity, unitOfMeasurement, measurementSignificanceCode,
									transactionSetPurposeCode, meterNumber, beginDate, endDate, ptdLoop ) );

							break;
						}
                    case "QTY20":
                    case "QTY87":
                    case "QTY9H":
                        {
                            cellContents = cells[metePeneMarker.QuantityAltCell].Trim();
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
