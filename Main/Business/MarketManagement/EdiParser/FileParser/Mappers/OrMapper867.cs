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
	public class OrMapper867 : MapperBase
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public OrMapper867() { }

		/// <summary>
		/// Constructor that takes market and utility codes
		/// </summary>
		/// <param name="utilityCode">Utility identifier</param>
		/// <param name="marketCode">Market Identifier</param>
		public OrMapper867( string utilityCode, string marketCode )
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
			OrMarker orMarker = new OrMarker();
            bool icapDatesMissing = false;
            bool tcapDatesMissing = false;
            icapList = new IcapList();
            tcapList = new TcapList();

			account = new EdiAccount( "", "", "", "", "", "", "", "", "", "", "", "", "" );
			account.EdiUsageList = new EdiUsageList();
            DateTime? transactionDate = null;
			// new serviceAddress object
			serviceAddress = new GeographicalAddress();

			// only found PTD*BQ for both historical and billed..
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
							AddUsagesToList( usageListTemp, account.EdiUsageList, beginDate, endDate );

							account.AccountNumber = accountNumber;
							account.BillGroup = (!(string.IsNullOrEmpty(billGroup)) && billGroup.Length > 0) ? billGroup : "-1";
							account.BillingAccount = billingAccountNumber;
							account.CustomerName = customerName;
							account.DunsNumber = dunsNumber;
							
							account.EspAccount = espAccount;					// leslie - 10/18/2010
							account.Icap = (icap != null && icap.Length > 0) ? Convert.ToDecimal( icap ) : Convert.ToDecimal( -1 );
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
							ResetAccountVariables( ref accountNumber, ref billingAccountNumber, ref customerName,
								ref icap, ref nameKey, ref previousAccountNumber, ref rateClass, ref tcap, ref zone, ref usageType );
							break;
						}
					case "N3": // serviceAddress
						{
							cellContents = cells[orMarker.AddressCell].Trim();
							serviceAddress.Street = cellContents == null ? "" : cellContents;
							break;
						}
					case "N4": // city, state, zip
						{
							cellContents = cells[orMarker.CityCell].Trim();
							serviceAddress.CityName = cellContents == null ? "" : cellContents;

							cellContents = cells[orMarker.StateCell].Trim();
							serviceAddress.State = cellContents == null ? "" : cellContents;

							cellContents = cells[orMarker.ZipCell].Trim();
							serviceAddress.PostalCode = cellContents == null ? "" : cellContents;

							break;
						}

                    //case "PTD":													// new usage record..
                    //    {
                    //        ProcessPhiHu(orMarker, cells);
                    //        break;
                    //    }
				}

				switch( marker )
				{
					case "N18S": // duns number
						{
							cellContents = cells[orMarker.DunsNumberCell].Trim();
							dunsNumber = cellContents == null ? "" : cellContents;

							cellContents = cells[orMarker.UtilityNameResolverCell].Trim();
							utilityCode = cellContents == null ? "" : cellContents;

							// bug 2840 - per Lelie's request (verified verbally by duggy)..
							if( utilityCode == "ROCKLAND ELECTRIC COMPANY" )
							{
								utilityCode = "ORNJ";
								marketCode = "NJ";
							}
							else if( utilityCode == "ORANGE AND ROCKLAND UTILITIES, INC." )
							{
								utilityCode = "O&R";
								marketCode = "NY";
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
							cellContents = cells[orMarker.CustomerNameCell].Trim();
							customerName = cellContents == null ? "" : cellContents;
							break;
						}
					case "REF11": // esp account number	- leslie - 10/18/2010
						{
							cellContents = cells[orMarker.EspAccountCell].Trim();
							espAccount = cellContents == null ? "" : cellContents;
							break;
						}
					case "REF12": // account number
						{
							cellContents = cells[orMarker.AccountNumberCell].Trim();
							accountNumber = cellContents == null ? "" : cellContents;
                            //if (cells.Contains("U"))
                            //    isUnmeterdAccountNumber = true;
							break;
						}
					case "REF45": // previous account number
						{
							cellContents = cells[orMarker.PreviousAccountNumberCell].Trim();
							previousAccountNumber = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFMG": // meter number
						{
							cellContents = cells[orMarker.MeterNumberCell].Trim();
							meterNumber = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFNH": // rate class
						{
							cellContents = cells[orMarker.RateClassCell].Trim();
							rateClass = cellContents == null ? "" : cellContents;
							break;
						}
					case "BPT00": // transaction set purpose code
					case "BPT01":
					case "BPT05":
					case "BPT06":
					case "BPT52":
						{
							cellContents = cells[orMarker.TransactionSetPurposeCodeCell].Trim();
							transactionSetPurposeCode = cellContents == null ? "" : cellContents;
                            cellContents = "";
                            if (cells.Length > 3)
                            {
                                string dateString = string.Empty;
                                dateString = cells[orMarker.TransactionCreationDateCell].Trim();
                                transactionDate = DateTryParse(dateString);
                            }
							break;
						}
                    case "REFPR": // tcap PBI_96868
                        {
                            cellContents = cells[orMarker.TcapCell].Trim();
                            tcap = cellContents == null ? "" : cellContents;
                            tcapList.Add(new Tcap((tcap != null && tcap.Length > 0) ? Convert.ToDecimal(tcap) : -1m, null, null));
                            break;
                        }
					case "QTYKZ": // icap as per PBI-96149
						{
							cellContents = cells[orMarker.IcapCell].Trim();
							icap = cellContents == null ? "" : cellContents;
                            icapList.Add(new Icap((icap != null && icap.Length > 0) ? Convert.ToDecimal(icap) : -1m));
                            icapDatesMissing = true;
							break;
						}
                    case "DTM007": // date range for icap or tcap
                        {
                            cellContents = cells[orMarker.IcapTcapDateRangeCell].Trim();
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
							cellContents = cells[orMarker.ZoneCell].Trim();
							zone = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFBF":	//bill cycle
						{
							cellContents = cells[orMarker.BillGroupCell].Trim();
							billGroup = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFLO":	//load profile
						{
							cellContents = cells[orMarker.LoadProfileCell].Trim();
							loadProfile = cellContents == null ? "" : cellContents;
							break;
						}
                    case "PTDSU":
                        {
                            measurementSignificanceCode = "51";
                            break;
                        }
                    case "PTDBC":// measurement significance code
                        {
                            measurementSignificanceCode = "51";
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
								cellContents = cells[orMarker.QuantityCell].Trim();
								quantity = cellContents == null ? "" : cellContents;

								cellContents = cells[orMarker.UnitOfMeasurementCell].Trim();
								unitOfMeasurement = cellContents == null ? "" : cellContents;

								if( orMarker.MeasurementSignificanceCodeCell < cells.Length )
								{
									cellContents = cells[orMarker.MeasurementSignificanceCodeCell].Trim();
									measurementSignificanceCode = cellContents == null ? "" : cellContents;
								}
								else if(measurementSignificanceCode!="51"  )
									measurementSignificanceCode = "51";

								usageListTemp.Add( CreateEdiUsage( quantity, unitOfMeasurement, measurementSignificanceCode,
									transactionSetPurposeCode, meterNumber, ptdLoop ) );
							}
							break;
						}
					case "DTM514": // exchange meter date
						{
							cellContents = cells[orMarker.BeginDateCell].Trim();
							string TransitionDate = cellContents == null ? "" : cellContents;

							if( beginDate == null | beginDate == "" )
								beginDate = TransitionDate;
							else
								endDate = TransitionDate;

							break;
						}
					case "DTM150": // begin date
						{
							cellContents = cells[orMarker.BeginDateCell].Trim();
							beginDate = cellContents == null ? "" : cellContents;

							break;
						}
					case "DTM151": // end date
						{
							cellContents = cells[orMarker.EndDateCell].Trim();
							endDate = cellContents == null ? "" : cellContents;

							// if historical, then add usage
							if( transactionSetPurposeCode.Equals( "52" ) )
								AddUsagesToList( usageListTemp, account.EdiUsageList, beginDate, endDate );

							break;
						}
					case "QTYQD": // begin usage
						{
							// NV - no value
							if( !fc.Contains( "NV" ) )
							{
								cellContents = cells[orMarker.QuantityAltCell].Trim();
								quantity = cellContents == null ? "" : cellContents;

								cellContents = cells[orMarker.UnitOfMeasurementAltCell].Trim();
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
                                cellContents = cells[orMarker.QuantityAltCell].Trim();
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
