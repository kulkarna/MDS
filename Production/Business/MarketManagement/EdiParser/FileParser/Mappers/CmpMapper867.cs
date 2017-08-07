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
	/// CMP utility mapper for 867 file.
	///  Maps markers in an EDI utility file to specific values in generic collections.
	/// </summary>
	public class CmpMapper867 : MapperBase
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public CmpMapper867() { }

		/// <summary>
		/// Constructor that takes market and utility codes
		/// </summary>
		/// <param name="utilityCode">Utility identifier</param>
		/// <param name="marketCode">Market Identifier</param>
		public CmpMapper867( string utilityCode, string marketCode )
		{
			this.utilityCode = utilityCode;
			this.marketCode = marketCode;
		}

		private static int SortUsage(EdiUsage usage1, EdiUsage usage2)
		{
			//start off by comparing begin dates..
			if( usage2.EndDate < usage1.EndDate )
				return -1;
			else if( usage2.EndDate > usage1.EndDate )
				return 1;

			return 0;
		}

		private void CalculateBillingPeriod( EdiUsageList usageList )
		{
			usageList.Sort(SortUsage);
			var differentDates = from e in usageList
								 group e by e.EndDate
									 into g
									 select new { Date = g.Key, Total = g.Count() }
			;

			int c = 0;
			DateTime begin = DateTime.MinValue;

			for( int i = 0; i < usageList.Count; i++ )
			{
				if( c + 1 < differentDates.Count() )
					begin = differentDates.ElementAt(c + 1).Date;

				if( c + 1 < differentDates.Count() )
					usageList[i].BeginDate = begin;
				else
					usageList[i].BeginDate = usageList[i].EndDate.AddMonths(-1);

				if( i + 1 < usageList.Count && differentDates.ElementAt( c ).Date != usageList[i + 1].EndDate )
					c++;
			}
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
			CmpMarker cmpMarker = new CmpMarker();
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

				switch( cell0 )
				{
					case "SE": // account end **********
						{
							AddUsagesToList( usageListTemp, account.EdiUsageList, beginDate, endDate, ptdLoop );
							CalculateBillingPeriod( account.EdiUsageList );

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

							cellContents = cells[cmpMarker.PtdLoopCell].Trim();
							ptdLoop = cellContents == null ? "" : cellContents;

							// BPT^52 only contains PTD^PM thus won't make it to the EdiUsage table..
							if( transactionSetPurposeCode == "52" & ptdLoop == "PM" )
								ptdLoop = "SU";

							if( ptdLoop == "SU" )
								measurementSignificanceCode = "51";

							break;
						}
					case "BPT": // transaction set purpose code - we've only received BPT^52 so far..
						{
							cellContents = cells[cmpMarker.TransactionSetPurposeCodeCell].Trim();
							transactionSetPurposeCode = cellContents == null ? "" : cellContents;
                            cellContents = "";
                            if (cells.Length > 3)
                            {
                                string dateString = string.Empty;
                                dateString = cells[cmpMarker.TransactionCreationDateCell].Trim();
                                transactionDate = DateTryParse(dateString);
                            }
							break;
						}
				}
				switch( marker )
				{
					case "N18S": // duns number
						{
							cellContents = cells[cmpMarker.DunsNumberCell].Trim();
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
							cellContents = cells[cmpMarker.CustomerNameCell].Trim();
							customerName = cellContents == null ? "" : cellContents;
							break;
						}
					case "REF12": // account number
						{
							cellContents = cells[cmpMarker.AccountNumberCell].Trim();
							accountNumber = cellContents == null ? "" : cellContents;
							break;
						}
					case "REF45": // previous account number
						{
							cellContents = cells[cmpMarker.PreviousAccountNumberCell].Trim();
							previousAccountNumber = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFMG": // meter number
						{
							cellContents = cells[cmpMarker.MeterNumberCell].Trim();
							meterNumber = cellContents == null ? "" : cellContents;
							break;
						}
                    case "REFSC": //UnMetered Meter number PBI-85351
                        {
                            cellContents = cells[cmpMarker.UnmeteredMeter].Trim();
                            if (cellContents == "U")
                            {
                                cellContents = "";
                                cellContents = cells[3].Trim();
                            }
                            meterNumber = cellContents == null ? "" : cellContents;
                            break;
                        }
					case "REFNH": // rate class
						{
							cellContents = cells[cmpMarker.RateClassCell].Trim();
							rateClass = cellContents == null ? "" : cellContents;
							break;
						}
					case "PSA93": // icap
						{
							if( cells[cmpMarker.IcapCell - 1].Trim() == "ICAP TAG" )
							{
								cellContents = cells[cmpMarker.IcapCell].Trim();
								icap = cellContents == null ? "" : cellContents;
							}
							break;
						}
					case "AMTKZ": // tcap
						{
							cellContents = cells[cmpMarker.TcapCell].Trim();
							tcap = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFSPL": // zone
						{
							cellContents = cells[cmpMarker.ZoneCell].Trim();
							zone = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFBF":	//bill cycle
						{
							cellContents = cells[cmpMarker.BillGroupCell].Trim();
							billGroup = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFLO":	//load profile
						{
							cellContents = cells[cmpMarker.LoadProfileCell].Trim();
							loadProfile = cellContents == null ? "" : cellContents;
							break;
						}
					case "MEAAN":	// actual??
					case "MEAEN":	// estimate??
						{
							cellContents = cells[cmpMarker.QuantityCell].Trim();
							quantity = cellContents == null ? "" : cellContents;

							cellContents = cells[cmpMarker.UnitOfMeasurementCell].Trim();
							unitOfMeasurement = cellContents == null || cellContents.Length.Equals( 0 ) ? usageType : cellContents;

							if( cmpMarker.MeasurementSignificanceCodeCell < cells.Length )
							{
								cellContents = cells[cmpMarker.MeasurementSignificanceCodeCell].Trim();
								measurementSignificanceCode = cellContents == null ? "" : cellContents;
							}
							else
								measurementSignificanceCode = "";

							break;
						}
					case "DTM187": // end date
						{
							cellContents = cells[cmpMarker.EndDateCell].Trim();
							endDate = cellContents == null ? "" : cellContents;

							usageListTemp.Add( CreateEdiUsage( quantity, unitOfMeasurement, measurementSignificanceCode,
								transactionSetPurposeCode, meterNumber, beginDate, endDate, ptdLoop ) );

							break;
						}
					case "DTM514": // exchange meter date
						{
							cellContents = cells[cmpMarker.BeginDateCell].Trim();
							string TransitionDate = cellContents == null ? "" : cellContents;

							if( beginDate == null | beginDate == "" )
								beginDate = TransitionDate;
							else
								endDate = TransitionDate;

							break;
						}
					case "QTYQD": // begin usage
						{
							cellContents = cells[cmpMarker.QuantityAltCell].Trim();
							quantity = cellContents == null ? "" : cellContents;

							cellContents = cells[cmpMarker.UnitOfMeasurementAltCell].Trim();
							unitOfMeasurement = cellContents == null ? "" : cellContents;

							break;
						}
                    case "QTY20":
                    case "QTY87":
                    case "QTY9H":
                        {
                            cellContents = cells[cmpMarker.QuantityAltCell].Trim();
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
