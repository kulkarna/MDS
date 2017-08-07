namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using CommonBusiness.CommonEntity;
    using System;
    using System.Data.SqlTypes;

	/// <summary>
	/// Responsible for mapping files 814 to a list of EdiAccount instances
	/// </summary>
	public class FileMapper814
	{
		private ClassMap accountMap;
		private string marketCode;

		/// <summary>
		/// Constructor that receives its account map as input
		/// </summary>
		/// <param name="accountMap">Map for the fields contained in the rows that will be mapped to edi account instances</param>
		public FileMapper814( EdiAccountMap814 accountMap )
		{
			this.accountMap = accountMap;
		}

		/// <summary>
		/// Sets the market code
		/// </summary>
		/// <param name="marketCode">Market code</param>
		/// <returns>FileMapper814 instance with market code defined</returns>
		public FileMapper814 WithMarketCode( string marketCode )
		{
			this.marketCode = marketCode;

			return this;
		}

		/// <summary>
		/// Parses an edi file to a list of EdiAccount instances.
		/// </summary>
		/// <returns>Ediaccount list</returns>
		public EdiAccount Map( FileRow fileRow, char rowDelimiter, char fieldDelimiter )
		{
			EdiAccount account = new EdiAccount( "", "", "", "", "", "", "", "", "", "", "", "", "" );
			account.EdiUsageList = new EdiUsageList();

			account.RetailMarketCode = this.marketCode;
			account.ServiceAddress = new UsGeographicalAddress();
			account.BillingAddress = new UsGeographicalAddress();
			account.Contact = new EdiAccountContact();
			account.AnnualUsage = -1;
			account.ServicePeriodStart = DateHelper.DefaultDate;
			account.ServicePeriodEnd = DateHelper.DefaultDate;
			account.EffectiveDate = DateHelper.DefaultDate;
			account.LossFactor = -1;
			account.MeterMultiplier = -1;
			account.MonthsToComputeKwh = -1;
          
				
			string[] fileCellList = fileRow.Contents.Split( rowDelimiter );
			foreach( string fc in fileCellList )
			{
				if( fc.Equals( string.Empty ) )
					continue;

				FieldResolver fr = new FieldResolver();
				Field field = fr.Resolve( fc, fieldDelimiter );

				if( field == null )
					continue;

                if (field.IsEndOfFile)
                    break;

                if (field.IsAccountEnd)
                {
                    // leslie - bug 2840 10/25/2010
                    if (account.UtilityIdentifier == "ROCKLAND ELECTRIC COMPANY" | account.UtilityIdentifier == "ORANGE AND ROCKLAND UTILITIES, INC.")
                    {
                        if (account.UtilityIdentifier == "ORANGE AND ROCKLAND UTILITIES, INC.")
                        {
                            account.UtilityCode = "O&R";
                            account.RetailMarketCode = "NY";
                        }
                        else
                        {
                            account.UtilityCode = "ORNJ";
                            account.RetailMarketCode = "NJ";
                        }
                    }
                }
                else if (Validator.Validate814RateClass(field.Name, account))
                {
                    continue;
                }
                else
                    accountMap.Map(account, field.Name, fc, fieldDelimiter);
			}

            //Checking for incorrect Icap data 999 for CONEC Utility code
            accountMap.MapNullIcapValue(account);

            accountMap.MapIcapTcap(account);

            if (account.HasIcap)  
            {
                IcapList icaplist = null;
                if ((account.IcapEffectiveDate > (DateTime)SqlDateTime.MinValue && account.IcapEffectiveDate < (DateTime)SqlDateTime.MaxValue))
                {
                     icaplist = account.IcapList;
                    icaplist.Add(new Icap(account.Icap, account.IcapEffectiveDate, account.IcapEffectiveDate));
                    account.IcapList = icaplist;
                }
                if ((account.FutureIcapEffectiveDate > (DateTime)SqlDateTime.MinValue && account.FutureIcapEffectiveDate < (DateTime)SqlDateTime.MaxValue && (account.IcapEffectiveDate.Date < account.FutureIcapEffectiveDate)))
                {
                    icaplist = account.IcapList;
                    icaplist.Add(new Icap(account.FutureIcap, account.FutureIcapEffectiveDate, account.FutureIcapEffectiveDate));
                    account.IcapList = icaplist;
                }
            }

            if (account.HasTcap)
            {
                TcapList tcaplist = null;
                if ((account.TcapEffectiveDate > (DateTime)SqlDateTime.MinValue && account.TcapEffectiveDate < (DateTime)SqlDateTime.MaxValue))
                {
                    tcaplist = account.TcapList;
                    tcaplist.Add(new Tcap(account.Tcap, account.TcapEffectiveDate, account.TcapEffectiveDate));
                    account.TcapList = tcaplist;
                }
                if ((account.FutureTcapEffectiveDate > (DateTime)SqlDateTime.MinValue && account.FutureTcapEffectiveDate < (DateTime)SqlDateTime.MaxValue) &&  (account.TcapEffectiveDate.Date<account.FutureTcapEffectiveDate))
                {
                    tcaplist = account.TcapList;
                    tcaplist.Add(new Tcap(account.FutureTcap, account.FutureTcapEffectiveDate, account.FutureTcapEffectiveDate));
                    account.TcapList = tcaplist;
                }
            }
			return account;
		}
	}
}