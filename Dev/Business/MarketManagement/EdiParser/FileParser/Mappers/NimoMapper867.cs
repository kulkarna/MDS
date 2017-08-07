namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;
	using LibertyPower.Business.CommonBusiness.CommonEntity;
	using LibertyPower.Business.MarketManagement.UtilityManagement;
	using LibertyPower.Business.MarketManagement.EdiParser.FormatParser;
    using System.Data.SqlTypes;

	/// <summary>
	/// NIMO utility mapper for 867 file.
	///  Maps markers in an EDI utility file to specific values in generic collections.
	/// </summary>
	public class NimoMapper867 : MapperBase
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public NimoMapper867() { }

		/// <summary>
		/// Constructor that takes market and utility codes
		/// </summary>
		/// <param name="utilityCode">Utility identifier</param>
		/// <param name="marketCode">Market Identifier</param>
		public NimoMapper867( string utilityCode, string marketCode )
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
			NimoMarker nimoMarker = new NimoMarker();
            bool icapDatesMissing = false;
            bool tcapDatesMissing = false;
            icapList = new IcapList();
            tcapList = new TcapList();
            DateTime? transactionDate = null;
			account = new EdiAccount( "", "", "", "", "", "", "", "", "", "", "", "", "" );
			account.EdiUsageList = new EdiUsageList();

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
							AddUsagesToList( usageListTemp, account.EdiUsageList, beginDate, endDate, ptdLoop );

							account.AccountNumber = accountNumber;
							account.BillGroup = (!(string.IsNullOrEmpty(billGroup)) && billGroup.Length > 0) ? billGroup : "-1";
							account.BillingAccount = billingAccountNumber;
							account.CustomerName = customerName;
							account.DunsNumber = dunsNumber;

							account.Icap = (icap != null && icap.Length > 0) ? Convert.ToDecimal( icap ) : Convert.ToDecimal( -1 );
							account.LoadProfile = loadProfile;
							account.LoadProfile = loadProfile;
							account.NameKey = nameKey;
							account.PreviousAccountNumber = previousAccountNumber;
							account.RateClass = rateClass;
							account.RetailMarketCode = marketCode;
							account.ServiceAddress = serviceAddress;
							account.Tcap = (tcap != null && tcap.Length > 0) ? Convert.ToDecimal( tcap ) : Convert.ToDecimal( -1 );
							account.UtilityCode = utilityCode;
							account.ZoneCode = zone;
                            account.IcapList = icapList;
                            account.TcapList = tcapList;
                            if ((transactionDate > (DateTime)SqlDateTime.MinValue && transactionDate < (DateTime)SqlDateTime.MaxValue))
                                account.TransactionCreatedDate = transactionDate;
							ResetAccountVariables();
							break;
						}
					case "PTD":													// new ptd loop value.. - copied from wpp (10/18/2010)
						{
							// skip 1st record..
							if( ptdLoop != null )
								AddUsagesToList( usageListTemp, account.EdiUsageList, beginDate, endDate, ptdLoop );

							ClearUsageVariables();
							meterNumber = "";

							cellContents = cells[nimoMarker.PtdLoopCell].Trim();
							ptdLoop = cellContents == null ? "" : cellContents;

							if( ptdLoop == "BC" )
								meterNumber = "Unmetered";

							if( (ptdLoop == "BO" || ptdLoop == "BC") )			//1-6984403
								ptdLoop = "SU";

							if( ptdLoop == "SU" )
								measurementSignificanceCode = "51";

							break;
						}
					case "BPT":													// transaction set purpose code
						{
							cellContents = cells[nimoMarker.TransactionSetPurposeCodeCell].Trim();
							transactionSetPurposeCode = cellContents == null ? "" : cellContents;
                            cellContents = "";
                            if (cells.Length > 3)
                            {
                                string dateString = string.Empty;
                                dateString = cells[nimoMarker.TransactionCreationDateCell].Trim();
                                transactionDate = DateTryParse(dateString);
                            }
							break;
						}
					case "N3":
						{
							cellContents = cells[nimoMarker.AddressCell].Trim();
							serviceAddress.Street = cellContents == null ? "" : cellContents;
							break;
						}
					case "N4":
						{
							cellContents = cells[nimoMarker.CityCell].Trim();
							serviceAddress.CityName = cellContents == null ? "" : cellContents;

							cellContents = cells[nimoMarker.StateCell].Trim();
							serviceAddress.State = cellContents == null ? "" : cellContents;

							cellContents = cells[nimoMarker.ZipCell].Trim();
							serviceAddress.PostalCode = cellContents == null ? "" : cellContents;

							break;
						}
				}

				switch( marker )
				{
					case "N18S": // duns number
						{
							cellContents = cells[nimoMarker.DunsNumberCell].Trim();
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
							cellContents = cells[nimoMarker.CustomerNameCell].Trim();
							customerName = cellContents == null ? "" : cellContents;
							break;
						}
					case "REF12": // account number
						{
							cellContents = cells[nimoMarker.AccountNumberCell].Trim();
							accountNumber = cellContents == null ? "" : cellContents;
							break;
						}
					case "REF45": // previous account number
						{
							cellContents = cells[nimoMarker.PreviousAccountNumberCell].Trim();
							previousAccountNumber = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFMG": // meter number
						{
							cellContents = cells[nimoMarker.MeterNumberCell].Trim();
							meterNumber = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFNH": // rate class
						{
							cellContents = cells[nimoMarker.RateClassCell].Trim();
							rateClass = cellContents == null ? "" : cellContents;
							break;
						}
					case "PSA93": // icap
						{
							cellContents = cells[nimoMarker.IcapCell].Trim();
							icap = cellContents == null ? "" : cellContents;
							break;
						}
					case "QTYKZ": // ICAP ---Change as part of 96149
						{
							cellContents = cells[nimoMarker.IcapCell].Trim();
                            icap = cellContents == null ? "" : cellContents;
                            icapList.Add(new Icap((icap != null && icap.Length > 0) ? Convert.ToDecimal(icap) : -1m));
                            icapDatesMissing = true;
							break;
						}
                    case "DTM007": // date range for icap or tcap
                        {
                            cellContents = cells[nimoMarker.IcapTcapDateRangeCell].Trim();
                            string dateRangeStr = cellContents == null ? "" : cellContents;
                            if (dateRangeStr.Length == 17) // if string is 17 characters then most likely valid
                            {
                                DateTime beginDate;
                                DateTime endDate;
                                string[] dateRanges = dateRangeStr.Split(Convert.ToChar("-"));
                                if (dateRanges.Length == 2)
                                {
                                    string bDate = FormatDateString(dateRanges[0]);
                                    string eDate = FormatDateString(dateRanges[1]);

                                    if (DateTime.TryParse(bDate, out beginDate) && DateTime.TryParse(eDate, out endDate))
                                    {
                                        // should be the very next iteration after obtaining icap or tcap values, 
                                        // need to determine which values the dates are for.
                                        if (icapDatesMissing)
                                        {
                                            icapList[icapList.Count - 1].BeginDate = beginDate;
                                            icapList[icapList.Count - 1].EndDate = endDate;
                                        }
                                        if (tcapDatesMissing)
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
							cellContents = cells[nimoMarker.ZoneCell].Trim();
							zone = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFBF":	//bill cycle
						{
							cellContents = cells[nimoMarker.BillGroupCell].Trim();
							billGroup = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFLO":	//load profile
						{
							cellContents = cells[nimoMarker.LoadProfileCell].Trim();
							loadProfile = cellContents == null ? "" : cellContents;
							break;
						}
					case "MEAAN": // kwh, uom, measurement significance code
					case "MEAEN":
                    case "MEAAF":
						{
							cellContents = cells[nimoMarker.UnitOfMeasurementCell].Trim();
							unitOfMeasurement = cellContents == null ? "" : cellContents;

							cellContents = cells[nimoMarker.QuantityCell].Trim();
							quantity = cellContents == null ? "" : cellContents;

							try
							{
								//sometimes MEA*AN*PRQ*1543*KH instead of MEA*AN*PRQ*55840*KH***51 (not a show stopper)
								cellContents = cells[nimoMarker.MeasurementSignificanceCodeCell].Trim();
								measurementSignificanceCode = cellContents == null ? "" : cellContents;
							}
							catch( Exception )
							{
								if( transactionSetPurposeCode == "52" )		//1-6984403
									measurementSignificanceCode = "51";
							}

							usageListTemp.Add( CreateEdiUsage( quantity, unitOfMeasurement, measurementSignificanceCode,
								transactionSetPurposeCode, meterNumber ) );

							break;
						}
					case "DTM514": // exchange meter date
						{
							cellContents = cells[nimoMarker.BeginDateCell].Trim();
							string TransitionDate = cellContents == null ? "" : cellContents;

							if( beginDate == null | beginDate == "" )
								beginDate = TransitionDate;
							else
								endDate = TransitionDate;

							break;
						}
					case "DTM150": // begin date
						{
							cellContents = cells[nimoMarker.BeginDateCell].Trim();
							beginDate = cellContents == null ? "" : cellContents;
							break;
						}
					case "DTM151": // end date
						{
							cellContents = cells[nimoMarker.EndDateCell].Trim();
							endDate = cellContents == null ? "" : cellContents;

							// if historical, then add usage
							if( transactionSetPurposeCode.Equals( "52" ) )
								AddUsagesToList( usageListTemp, account.EdiUsageList, beginDate, endDate, ptdLoop );

							break;
						}
					case "QTYQD": // begin usage
						{
							// NV - no value
							if( !fc.Contains( "NV" ) )
							{
								cellContents = cells[nimoMarker.QuantityAltCell].Trim();
								quantity = cellContents == null ? "" : cellContents;

								cellContents = cells[nimoMarker.UnitOfMeasurementAltCell].Trim();
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
                                cellContents = cells[nimoMarker.QuantityAltCell].Trim();
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
