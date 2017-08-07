namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
    using System;
    using System.Collections.Generic;
    using System.Data.SqlTypes;
    using System.Globalization;
    using System.Linq;

	public class DukeMapper867 : MapperBase
	{
		/// <summary>
		/// Default constructor..
		/// </summary>
		public DukeMapper867() { }

		public DukeMapper867( string utilityCode, string marketCode )
		{
			this.utilityCode = utilityCode;
			this.marketCode = marketCode;
		}
		/// <summary>
		/// Maps markers in an EDI utility file to specific values in generic collections.
		/// </summary>
		/// <param name="fileRow">Generic collection of rows in utility file</param>
		/// <param name="rowDelimiter">row delimiter</param>
		/// <param name="fieldDelimiter">field delimiter</param>
		/// <returns>Returns an Edi account list that contains accounts and their respective usage.</returns>
		public override EdiAccount MapData( FileRow fileRow, char rowDelimiter, char fieldDelimiter )
		{
            bool icapDatesMissing = false;
            bool tcapDatesMissing = false;
            icapList = new IcapList();
            tcapList = new TcapList();
            DateTime? transactionDate=null;  
			try
			{
				DukeMaker DukeMaker = new DukeMaker();

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
						case "BPT": // transaction set purpose code
							{
								cellContents = cells[DukeMaker.TransactionSetPurposeCodeCell].Trim();
								transactionSetPurposeCode = cellContents == null ? "" : cellContents;
                                cellContents = "";     
                                if (cells.Length > 3)
                                {
                                    string dateString = string.Empty;
                                    dateString = cells[DukeMaker.TransactionCreationDateCell].Trim();
                                    transactionDate = DateTryParse(dateString); 
                                }
								break;
							}
						case "PTD":	// block header..
							{
								ClearUsageVariables();
								meterNumber = "";

								cellContents = cells[DukeMaker.PtdLoopCell].Trim();
								ptdLoop = cellContents == null ? "" : cellContents;

								// have only received 52's so far.. also BPT*52 contains only PTD*PL (no summary) + BO (IDR)..
								if( transactionSetPurposeCode == "52" && ptdLoop == "PL" )
									ptdLoop = "SU";

								if( ptdLoop == "SU" )
									measurementSignificanceCode = "51";

								if( ptdLoop == "PM" )
									ClearIdrVariables();

								break;
							}
						case "SE": // account end **********
							{
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
								account.BillGroup = (!(string.IsNullOrEmpty(billGroup)) && billGroup.Length > 0) ? billGroup : "-1";;
                                account.IcapList = icapList;
                                account.TcapList = tcapList;
                                if ((transactionDate > (DateTime)SqlDateTime.MinValue && transactionDate < (DateTime)SqlDateTime.MaxValue))
                                    account.TransactionCreatedDate = transactionDate;
								ResetAccountVariables();
								ptdLoop = null;
								break;
							}
					}
					switch( marker )
					{
						case "DTM150": // begin date
							{
								cellContents = cells[DukeMaker.BeginDateCell].Trim();
								beginDate = cellContents == null ? "" : cellContents;
								break;
							}
						case "DTM151": // end date
							{
								cellContents = cells[DukeMaker.EndDateCell].Trim();
								endDate = cellContents == null ? "" : cellContents;

								// only recieved historical usage so far..
								if( ptdLoop.Equals( "SU" ) && transactionSetPurposeCode.Equals( "52" ) )
									account.EdiUsageList.Add( CreateEdiUsage( quantity, unitOfMeasurement, measurementSignificanceCode,
										transactionSetPurposeCode, meterNumber, beginDate, endDate, ptdLoop ) );

								if( ptdLoop.Equals( "BC" ) && transactionSetPurposeCode.Equals( "52" ) )
									account.EdiUsageList.Add( CreateEdiUsage( quantity, unitOfMeasurement, "51",
										transactionSetPurposeCode, meterNumber, beginDate, endDate, "SU" ) );

								break;
							}
						case "DTM194": // idr date
							{
								cellContents = cells[DukeMaker.IdrDateCell].Trim();
								idrDate = cellContents == null ? "" : cellContents;

								cellContents = cells[DukeMaker.IdrIntervalCell].Trim();
								idrInterval = cellContents == null ? "" : cellContents;

								account.IdrUsageList[idrInterval + idrDate + unitOfMeasurement + meterNumber] = createIdrUsage( meterNumber, quantity, unitOfMeasurement, transactionSetPurposeCode, idrInterval, idrDate, ptdLoop );

								break;
							}
						case "DTM514": // exchange meter date
							{
								cellContents = cells[DukeMaker.BeginDateCell].Trim();
								string TransitionDate = cellContents == null ? "" : cellContents;

								if( beginDate == null | beginDate == "" )
									beginDate = TransitionDate;
								else
									endDate = TransitionDate;

								break;
							}
						case "IEA1": // end of fileContents **********
							{
								return account;
							}
						case "N18R": // customer name
							{
								cellContents = cells[DukeMaker.CustomerNameCell].Trim();
								customerName = cellContents == null ? "" : cellContents;
								break;
							}
						case "N18S": // duns number
							{
								cellContents = cells[DukeMaker.DunsNumberCell].Trim();
								dunsNumber = cellContents == null ? "" : cellContents;
								break;
							}
						case "QTYKC": // icap
							{
								cellContents = cells[DukeMaker.IcapCell].Trim();
                                icap = cellContents == null ? "" : cellContents;
                                icapList.Add(new Icap((icap != null && icap.Length > 0) ? Convert.ToDecimal(icap) : -1m,null,null));
                                if (icap != null && icap.Length > 0)
                                {
                                    icapDatesMissing = true;
                                    tcapDatesMissing = false;
                                }
                                else
                                {
                                    icapDatesMissing = false;
                                    tcapDatesMissing = false;
                                }
								break;
							}
						case "QTYKZ": // tcap
							{
								cellContents = cells[DukeMaker.TcapCell].Trim();
                                tcap = cellContents == null ? "" : cellContents;
                                tcapList.Add(new Tcap((tcap != null && tcap.Length > 0) ? Convert.ToDecimal(tcap) : -1m,null,null));
                                if (tcap != null && tcap.Length > 0)
                                {
                                    tcapDatesMissing = true;
                                    icapDatesMissing = false;
                                }
                                else
                                {
                                    icapDatesMissing = false;
                                    tcapDatesMissing = false;
                                }
								break;
							}
                        case "DTM007": // date range for icap or tcap
                            {
                                cellContents = cells[DukeMaker.IcapTcapDateRangeCell].Trim();
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
                                        //  Added By Vikas  Sharma 
                                        DateTime.TryParse(bDate, out beginDate);
                                        DateTime.TryParse(eDate, out endDate);
                                        if ((beginDate > (DateTime)SqlDateTime.MinValue && beginDate < (DateTime)SqlDateTime.MaxValue) && (endDate > (DateTime)SqlDateTime.MinValue && endDate < (DateTime)DateTime.MaxValue))
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
						case "QTYQD": // begin usage
						case "QTYKA":
							{
								cellContents = cells[DukeMaker.UnitOfMeasurementAltCell].Trim();
								unitOfMeasurement = cellContents == null ? unitOfMeasurement : cellContents;

								cellContents = cells[DukeMaker.QuantityAltCell].Trim();
								quantity = cellContents == null ? "" : cellContents;

								// yearly meter reads come in a different order..
								if( ptdLoop.Equals( "BO" ) && transactionSetPurposeCode.Equals( "52" ) )
									account.EdiUsageList.Add( CreateEdiUsage( quantity, unitOfMeasurement, "51",
										transactionSetPurposeCode, meterNumber, beginDate, endDate, "SU" ) );

                                if (ptdLoop.Equals("SU") & !transactionSetPurposeCode.Equals("52"))
                                    account.EdiUsageList.Add(CreateEdiUsage(quantity, unitOfMeasurement, "51",
                                        transactionSetPurposeCode, meterNumber, beginDate, endDate, "SU"));
								break;
							}
                        case "QTY20":
                        case "QTY87":
                        case "QTY9H":
                            {
                                cellContents = cells[DukeMaker.QuantityAltCell].Trim();
                                quantity = cellContents == null ? "" : cellContents;
                                unitOfMeasurement = "D1";
                                break;
                            }
						case "REF45": // previous account number
							{
								cellContents = cells[DukeMaker.PreviousAccountNumberCell].Trim();
								previousAccountNumber = cellContents == null ? "" : cellContents;
								break;
							}
						case "REFBF":	//bill cycle
							{
								cellContents = cells[DukeMaker.BillGroupCell].Trim();
								billGroup = cellContents == null ? "" : cellContents;

								if( billGroup.Length > 2 )
									billGroup = billGroup.Substring( 0, 2 );

								break;
							}
						case "REFLO":	//load profile
							{
								cellContents = cells[DukeMaker.LoadProfileCell].Trim();
								loadProfile = cellContents == null ? "" : cellContents;
								break;
							}
						case "REFMG": // meter number
							{
								cellContents = cells[DukeMaker.MeterNumberCell].Trim();
								meterNumber = cellContents == null ? "" : cellContents;
								break;
							}
						case "REFMT": // usage type
							{
								cellContents = cells[DukeMaker.UsageTypeCell].Trim();
								usageType = cellContents == null ? "" : cellContents;

								if( usageType.Length > 2 )
									usageType = usageType.Substring( 0, 2 );

								unitOfMeasurement = unitOfMeasurement == null || unitOfMeasurement.Length.Equals( 0 ) ? usageType : unitOfMeasurement;

								break;
							}
						case "REFNH": // rate class
							{
								cellContents = cells[DukeMaker.RateClassCell].Trim();
								rateClass = cellContents == null ? "" : cellContents;
								break;
							}
						case "REF12": // account number
							{
								cellContents = cells[DukeMaker.AccountNumberCell].Trim();
								accountNumber = cellContents == null ? "" : cellContents;
								break;
							}
						case "REFSPL": // zone
							{
								cellContents = cells[DukeMaker.ZoneCell].Trim();
								zone = cellContents == null ? "" : cellContents;
								break;
							}
						case "ST867": // account start *******
							{
								// initialize with empty strings to avoid null value issues
								account = new EdiAccount( "", "", "", "", "", "", "", "", "", "", "", "", "" );
								break;
							}

					}
				}
				return account;
			}
			catch( Exception ex )
			{
				throw ex;
			}
		}




	}
}
