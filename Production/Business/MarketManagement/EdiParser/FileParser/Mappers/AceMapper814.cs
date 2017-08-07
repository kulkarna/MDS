namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	// this is just a copy of the 867, will not work, need to change.. (rick - 05/20/2010)
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;
	using LibertyPower.Business.MarketManagement.UtilityManagement;
	using LibertyPower.Business.MarketManagement.EdiParser.FormatParser;
	using LibertyPower.Business.CommonBusiness.CommonEntity;
    using System.Data.SqlTypes;

	/// <summary>
	/// ACE utility mapper for 814 file.
	///  Maps markers in an EDI utility file to specific values in generic collections.
	/// </summary>
	public class AceMapper814 : MapperBase
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public AceMapper814() { }

		/// <summary>
		/// Constructor that takes market and utility codes
		/// </summary>
		/// <param name="utilityCode">Utility identifier</param>
		/// <param name="marketCode">Market Identifier</param>
		public AceMapper814( string utilityCode, string marketCode )
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
			AceMarker aceMarker = new AceMarker();
			account = new EdiAccount( "", "", "", "", "", "", "", "", "", "", "", "", "" );
			account.EdiUsageList = new EdiUsageList();
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
							account.AccountNumber = accountNumber;
							account.EspAccount = espAccount;
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
							account.AccountStatus = accountStatus;
							account.ServiceAddress = serviceAddress;
							account.BillingType = billingType;
							account.BillCalculation = billCalculation;
							account.ServicePeriodStart = DateHelper.ConvertDateString( servicePeriodStart );
							account.ServicePeriodEnd = DateHelper.ConvertDateString(servicePeriodEnd);
							account.AnnualUsage = (annualUsage != null && annualUsage.Length > 0) ? Convert.ToInt32( annualUsage ) : Convert.ToInt32( -1 );
							account.MonthsToComputeKwh = (monthsToComputeKwh != null && monthsToComputeKwh.Length > 0) ? Convert.ToInt16( monthsToComputeKwh ) :Convert.ToInt16( -1 );
							account.MeterType = meterType;
							account.MeterMultiplier = (meterMultiplier != null && meterMultiplier.Length > 0) ? Convert.ToInt16( meterMultiplier.Split( '.' )[0] ) : Convert.ToInt16( -1 );
							account.TransactionType = transactionType;
							account.ServiceType = serviceType;
							account.ProductType = productType;
							account.ProductAltType = productAltType;
							account.BillingAddress = billingAddress;
                            if ((transactionDate > (DateTime)SqlDateTime.MinValue && transactionDate < (DateTime)SqlDateTime.MaxValue))
                                account.TransactionCreatedDate = transactionDate;

							ResetAccountVariables();
							break;
						}
					case "N3":	//street BillingAddress
						{
							cellContents = cells[aceMarker.AddressCell].Trim();

							if( billTo == null | billTo == "" )
								serviceAddress.Street = cellContents == null ? "" : cellContents;
							else
								billingAddress.Street = cellContents == null ? "" : cellContents;

							break;
						}
					case "N4":	//city, state, zip
						{
							cellContents = cells[aceMarker.CityCell].Trim();

							if( billTo == null | billTo == "" )
							{
								serviceAddress.CityName = cellContents == null ? "" : cellContents;

								cellContents = cells[aceMarker.StateCell].Trim();
								serviceAddress.State = cellContents == null ? "" : cellContents;

								cellContents = cells[aceMarker.ZipCell].Trim();
								serviceAddress.PostalCode = cellContents == null ? "" : cellContents;
							}
							else
							{
								billingAddress.CityName = cellContents == null ? "" : cellContents;

								cellContents = cells[aceMarker.StateCell].Trim();
								billingAddress.State = cellContents == null ? "" : cellContents;

								cellContents = cells[aceMarker.ZipCell].Trim();
								billingAddress.PostalCode = cellContents == null ? "" : cellContents;
							}

							break;
						}
					case "BGN":		// Beginning Segment
						{
							cellContents = cells[aceMarker.TransactionTypeCell].Trim();
							transactionType = cellContents;
							break;
						}
					case "LIN":
						{
							cellContents = cells[aceMarker.ServiceTypeCell].Trim();
							string cellAltContents = cells[aceMarker.ServiceTypeCell + 1].Trim();
							serviceType = cellContents + cellAltContents;

							cellContents = cells[aceMarker.ServiceTypeCell + 2].Trim();
							cellAltContents = cells[aceMarker.ServiceTypeCell + 3].Trim();
							productType = cellContents + cellAltContents;

							try
							{	// sometimes, a third product type id is provided..
								cellContents = cells[aceMarker.ServiceTypeCell + 4].Trim();
								cellAltContents = cells[aceMarker.ServiceTypeCell + 5].Trim();
								productAltType = cellContents + cellAltContents;
							}
							catch
							{ }

							break;
						}
				}

				switch( marker )
				{
					case "N18S": // duns number
						{
							cellContents = cells[aceMarker.DunsNumberCell].Trim();
							dunsNumber = cellContents == null ? "" : cellContents;
							break;
						}
					case "IEA1": // end of fileContents **********
						{
							return account;
						}
					case "ST814": // account start *******
						{
							// initialize with empty strings to avoid null value issues
							account = new EdiAccount( "", "", "", "", "", "", "", "", "", "", "", "", "" );

							// new serviceAddress object
							serviceAddress = new GeographicalAddress();
							billingAddress = new GeographicalAddress();
							break;
						}
					case "N18R": // customer name
						{
							cellContents = cells[aceMarker.CustomerNameCell].Trim();
							customerName = cellContents == null ? "" : cellContents;
							break;
						}
					case "N1BT": // customer name (bill to contact)
						{
							cellContents = cells[aceMarker.BillToCell].Trim();
							billTo = cellContents == null ? "" : cellContents;
							break;
						}
					case "REF11":	//esp account number
						{
							cellContents = cells[aceMarker.EspAccountCell].Trim();
							espAccount = cellContents == null ? "" : cellContents;
							break;
						}
					case "REF12": // account number
						{
							cellContents = cells[aceMarker.AccountNumberCell].Trim();
							accountNumber = cellContents == null ? "" : cellContents;
							break;
						}
					case "REF1P":	//account status
					case "REF7G":
						{
							cellContents = cells[aceMarker.AccountStatusCell].Trim();
							accountStatus = cellContents == null ? "" : cellContents;
							break;
						}
					case "REF45": // previous account number
						{
							cellContents = cells[aceMarker.PreviousAccountNumberCell].Trim();
							previousAccountNumber = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFMG": // meter number
						{
							cellContents = cells[aceMarker.MeterNumberCell].Trim();
							meterNumber = cellContents == null ? "" : cellContents;
							break;
						}
					case "REF4P": // mutiplier
						{
							// KHMON = kilowatt hours per month; K1015 = kilowatt demand per 15 minute interval
							if( !cells.Contains( "KHMON" ) )
							{
								cellContents = cells[aceMarker.MeterMultiplierCell].Trim();
								meterMultiplier = cellContents == null ? "" : cellContents;
							}
							break;
						}
					case "REFNH": // rate class
						{
							cellContents = cells[aceMarker.RateClassCell].Trim();
							rateClass = cellContents == null ? "" : cellContents;
							break;
						}
					case "BPT00": // transaction set purpose code
					case "BPT01":
					case "BPT05":
					case "BPT06":
					case "BPT52":
						{
							cellContents = cells[aceMarker.TransactionSetPurposeCodeCell].Trim();
							transactionSetPurposeCode = cellContents == null ? "" : cellContents;
							break;
						}
					case "AMTKC": // icap
						{
							cellContents = cells[aceMarker.IcapCell].Trim();
							icap = cellContents == null ? "" : cellContents;
							break;
						}
					case "AMTKZ": // tcap
						{
							cellContents = cells[aceMarker.TcapCell].Trim();
							tcap = cellContents == null ? "" : cellContents;
							break;
						}
					case "AMTTA":	//anuual usage
						{
							cellContents = cells[aceMarker.AnuualUsageCell].Trim();
							annualUsage = cellContents == null ? "" : cellContents;
							break;
						}
					case "AMTLD":	//incremental
						{
							cellContents = cells[aceMarker.MonthsToComputeKwhCell].Trim();
							monthsToComputeKwh = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFSPL": // zone
						{
							cellContents = cells[aceMarker.ZoneCell].Trim();
							zone = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFBLT":	//bill type
						{
							cellContents = cells[aceMarker.BillingTypeCell].Trim();
							billingType = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFPC":	//production code
						{
							cellContents = cells[aceMarker.BillCalculationCell].Trim();
							billCalculation = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFBF":	//bill cycle
					case "REFTZ":
						{
							cellContents = cells[aceMarker.BillGroupCell].Trim();
							billGroup = cellContents == null ? "" : cellContents;
							break;
						}
					case "DTM150":	//service period start
						{
							cellContents = cells[aceMarker.ServicePeriodStartCell].Trim();
							servicePeriodStart = cellContents == null ? "" : cellContents;
							break;
						}
					case "DTM151":	//service period end
						{
							cellContents = cells[aceMarker.ServicePeriodEndCell].Trim();
							servicePeriodEnd = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFLO":	//load profile
						{
							cellContents = cells[aceMarker.LoadProfileCell].Trim();
							loadProfile = cellContents == null ? "" : cellContents;
							break;
						}
					case "REFMT":	//meter type
						{
							cellContents = cells[aceMarker.MeterTypeCell].Trim();
							meterType = cellContents == null ? "" : cellContents;
							break;
						}
				}
			}
			return account;
		}
	}
}
