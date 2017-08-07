namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Collections;
	using System.Data;
	using System.Text.RegularExpressions;
	using LibertyPower.Business.CommonBusiness.CommonEntity;
	using LibertyPower.Business.CommonBusiness.CommonExceptions;
	using LibertyPower.Business.CommonBusiness.FieldHistory;
	using LibertyPower.DataAccess.SqlAccess.OfferEngineSql;
    using LibertyPower.DataAccess.SqlAccess.TransactionsSql;

	public static class ConedParser
	{
		private static FieldHistoryManager.MapField _applyMapping = LibertyPower.Business.MarketManagement.UtilityManagement.UtilityMappingFactory.ApplyMapping;

		// ------------------------------------------------------------------------------------
		public static string ParseData( Coned coned, string Data, bool HasData )
		{
			int BeginPos, EndPos, FinalPos, DataLength, PageLength, LoopCount;
			UsGeographicalAddress address = new UsGeographicalAddress();
			ConedUsage usage;

			try
			{
				if( !HasData )
					throw new WebManagerException( "Invalid account number: " + coned.AccountNumber );

				BeginPos = 0;
				EndPos = 0;
				LoopCount = 0;

				// Customer Name ------------------------------------------
				EndPos = Data.IndexOf( "next&nbsp;scheduled&nbsp;read&nbsp;date", EndPos, StringComparison.OrdinalIgnoreCase ) + 39;
				BeginPos = Data.IndexOf( "<td align=center>", EndPos, StringComparison.OrdinalIgnoreCase ) + 17;
				EndPos = Data.IndexOf( "</td>", BeginPos, StringComparison.OrdinalIgnoreCase );
				DataLength = EndPos - BeginPos;

				coned.CustomerName = Data.Substring( BeginPos, DataLength ).Trim();

				// EP - Service Address -----------------------------------
				// move index
				EndPos = Data.IndexOf( "<td align=center>", EndPos, StringComparison.OrdinalIgnoreCase ) + 10;

				BeginPos = Data.IndexOf( "<td align=center>", EndPos, StringComparison.OrdinalIgnoreCase ) + 17;
				EndPos = Data.IndexOf( "</td>", BeginPos, StringComparison.OrdinalIgnoreCase );
				DataLength = EndPos - BeginPos;

				//address = new GeographicalAddress(EntityLinkType.GeographicalAddress);
				address.Street = Data.Substring( BeginPos, DataLength ).Trim();

				// ------------------------------------------
				BeginPos = Data.IndexOf( "<td align=center>", EndPos, StringComparison.OrdinalIgnoreCase ) + 17;
				EndPos = Data.IndexOf( "</td>", BeginPos, StringComparison.OrdinalIgnoreCase );
				DataLength = EndPos - BeginPos;

				address.CityName = Data.Substring( BeginPos, DataLength ).Trim();

				// ------------------------------------------
				BeginPos = Data.IndexOf( "<td align=center>", EndPos, StringComparison.OrdinalIgnoreCase ) + 17;
				EndPos = Data.IndexOf( "</td>", BeginPos, StringComparison.OrdinalIgnoreCase );
				DataLength = EndPos - BeginPos;

				address.PostalCode = Data.Substring( BeginPos, DataLength ).Trim();

				coned.Address = address;

				// EP - Seasonal Turn-Of ----------------------------------
				BeginPos = Data.IndexOf( "<td align=center>", EndPos, StringComparison.OrdinalIgnoreCase ) + 17;
				EndPos = Data.IndexOf( "</td>", BeginPos, StringComparison.OrdinalIgnoreCase );
				DataLength = EndPos - BeginPos;

				coned.SeasonalTurnOff = Data.Substring( BeginPos, DataLength ).Trim();

				// EP - Next Scheduled Read Date --------------------------
				BeginPos = Data.IndexOf( "<td align=center>", EndPos, StringComparison.OrdinalIgnoreCase ) + 17;
				EndPos = Data.IndexOf( "</td>", BeginPos, StringComparison.OrdinalIgnoreCase );
				DataLength = EndPos - BeginPos;

				coned.NextScheduledReadDate = Convert.ToDateTime( Data.Substring( BeginPos, DataLength ).Trim() );

				// EP - Tension Code --------------------------------------
				BeginPos = Data.IndexOf( "<td align=center>", EndPos, StringComparison.OrdinalIgnoreCase ) + 17;
				EndPos = Data.IndexOf( "</td>", BeginPos, StringComparison.OrdinalIgnoreCase );
				DataLength = EndPos - BeginPos;

				try
				{
					coned.TensionCode = Data.Substring( BeginPos, DataLength ).Trim();
				}
				catch( Exception ) { }


				// ------------------------------------------
				// continue..
				BeginPos = 0;
				EndPos = 0;

				// replace all spaces, commas and dollar signs for easier parsing
				Data = Regex.Replace( Data, "[ \\t\\n\\v\\f\\r]", "" );
				Data = Data.Replace( ",", "" ).Replace( "$", "" );
				PageLength = Data.Length;
				FinalPos = Data.IndexOf( "</center>" );

				// move index
				EndPos = Data.IndexOf( "next&nbsp;scheduled&nbsp;read&nbsp;date", BeginPos, StringComparison.OrdinalIgnoreCase ) + 39;
				EndPos = Data.IndexOf( "<tr>", EndPos, StringComparison.OrdinalIgnoreCase ) + 4;
				EndPos = Data.IndexOf( "<tr>", EndPos, StringComparison.OrdinalIgnoreCase ) + 4;
				EndPos = Data.IndexOf( "<tdalign=center>", EndPos, StringComparison.OrdinalIgnoreCase ) + 16;

				// Trip Number --------------------------------------------
				BeginPos = Data.IndexOf( "<tdalign=center>", EndPos, StringComparison.OrdinalIgnoreCase ) + 16;
				EndPos = Data.IndexOf( "</td>", BeginPos, StringComparison.OrdinalIgnoreCase );
				DataLength = EndPos - BeginPos;

				try
				{
					coned.BillGroup = Data.Substring( BeginPos, DataLength ).Trim() ;
				}
				catch( Exception ) { }

				// Stratum Variable ---------------------------------------
				BeginPos = Data.IndexOf( "<tdalign=center>", EndPos, StringComparison.OrdinalIgnoreCase ) + 16;
				EndPos = Data.IndexOf( "</td>", BeginPos, StringComparison.OrdinalIgnoreCase );
				DataLength = EndPos - BeginPos;

				coned.StratumVariable = Data.Substring( BeginPos, DataLength ).Trim();

				// ICAP ---------------------------------------------------
				BeginPos = Data.IndexOf( "<tdalign=center>&nbsp;", EndPos, StringComparison.OrdinalIgnoreCase ) + 22;
				EndPos = Data.IndexOf( "</td>", BeginPos, StringComparison.OrdinalIgnoreCase );
				DataLength = EndPos - BeginPos;

				try
				{
					coned.Icap = Convert.ToDecimal( Data.Substring( BeginPos, DataLength ).Trim() );
				}
				catch( Exception ) { }

				// PFJ ICAP
                //BeginPos = Data.IndexOf( "<tdalign=center>&nbsp;", EndPos, StringComparison.OrdinalIgnoreCase ) + 22;
                //EndPos = Data.IndexOf( "</td>", BeginPos, StringComparison.OrdinalIgnoreCase );
                //DataLength = EndPos - BeginPos;

			    coned.PfjIcap = string.Empty;

				//Residential %
				BeginPos = Data.IndexOf( "<tdalign=center>", EndPos, StringComparison.OrdinalIgnoreCase ) + 16;
				EndPos = Data.IndexOf( "</td>", BeginPos, StringComparison.OrdinalIgnoreCase );
				DataLength = EndPos - BeginPos;

				coned.Residential = Convert.ToInt16( Data.Substring( BeginPos, DataLength ).Trim() );

				// Zone ---------------------------------------------------
				BeginPos = Data.IndexOf( "<tdalign=center>&nbsp;", EndPos, StringComparison.OrdinalIgnoreCase ) + 22;
				EndPos = Data.IndexOf( "</td>", BeginPos, StringComparison.OrdinalIgnoreCase );
				DataLength = EndPos - BeginPos;

				coned.ZoneCode = Data.Substring( BeginPos, DataLength ).Trim();

				// Recharge --------------------------------------------
				BeginPos = Data.IndexOf( "<tdalign=center>", EndPos, StringComparison.OrdinalIgnoreCase ) + 16;
				EndPos = Data.IndexOf( "</td>", BeginPos, StringComparison.OrdinalIgnoreCase );
				DataLength = EndPos - BeginPos;

				// Metering --------------------------------------------
				BeginPos = Data.IndexOf( "<tdalign=center>", EndPos, StringComparison.OrdinalIgnoreCase ) + 16;
				EndPos = Data.IndexOf( "</td>", BeginPos, StringComparison.OrdinalIgnoreCase );
				DataLength = EndPos - BeginPos;

				// Service Class ------------------------------------------
				BeginPos = Data.IndexOf( "<tdalign=center>", EndPos, StringComparison.OrdinalIgnoreCase ) + 16;
				EndPos = Data.IndexOf( "</td>", BeginPos, StringComparison.OrdinalIgnoreCase );
				DataLength = EndPos - BeginPos;

				coned.RateClass = Data.Substring( BeginPos, DataLength ).Trim();

				// EP - Previous Account Number ---------------------------
				BeginPos = Data.IndexOf( "<tdalign=center>", EndPos, StringComparison.OrdinalIgnoreCase ) + 16;
				EndPos = Data.IndexOf( "</td>", BeginPos, StringComparison.OrdinalIgnoreCase );
				DataLength = EndPos - BeginPos;

				coned.PreviousAccountNumber = Data.Substring( BeginPos, DataLength ).Trim();

				// Min Monthly Demand
				BeginPos = Data.IndexOf( "<tdalign=center>", EndPos, StringComparison.OrdinalIgnoreCase ) + 16;
				EndPos = Data.IndexOf( "</td>", BeginPos, StringComparison.OrdinalIgnoreCase );
				DataLength = EndPos - BeginPos;

				try
				{
					coned.MinMonthlyDemand = Convert.ToInt16( Data.Substring( BeginPos, DataLength ).Trim() );
				}
				catch( Exception ) { }

				// TOD Code
				BeginPos = Data.IndexOf( "<tdalign=center>", EndPos, StringComparison.OrdinalIgnoreCase ) + 16;
				EndPos = Data.IndexOf( "</td>", BeginPos, StringComparison.OrdinalIgnoreCase );
				DataLength = EndPos - BeginPos;

				coned.TodCode = Data.Substring( BeginPos, DataLength ).Trim();

				// Profile -------------------------------------------
				BeginPos = Data.IndexOf( "<tdalign=center>", EndPos, StringComparison.OrdinalIgnoreCase ) + 16;
				EndPos = Data.IndexOf( "</td>", BeginPos, StringComparison.OrdinalIgnoreCase );
				DataLength = EndPos - BeginPos;

				coned.Profile = Data.Substring( BeginPos, DataLength ).Trim();

				//Tax
				BeginPos = Data.IndexOf( "<tdalign=center>", EndPos, StringComparison.OrdinalIgnoreCase ) + 16;
				EndPos = Data.IndexOf( "</td>", BeginPos, StringComparison.OrdinalIgnoreCase );
				DataLength = EndPos - BeginPos;

				coned.Taxable = Data.Substring( BeginPos, DataLength ).Trim();

				//Muni
				BeginPos = Data.IndexOf( "<tdalign=center>", EndPos, StringComparison.OrdinalIgnoreCase ) + 16;
				EndPos = Data.IndexOf( "</td>", BeginPos, StringComparison.OrdinalIgnoreCase );
				DataLength = EndPos - BeginPos;

				coned.Muni = Data.Substring( BeginPos, DataLength ).Trim();


				AcquireAndStoreDeterminantHistory( coned );

				// Usage --------------------------------------------------
				WebUsageList list = new WebUsageList();

				while( (BeginPos < FinalPos) | (BeginPos > 0) )
				{
					usage = new ConedUsage();

					// start parsing
					if( LoopCount == 0 )
						EndPos = Data.IndexOf( "BillAmt", 0 ) + 7;

					// finished parsing
					if( Data.IndexOf( "<tdalign=center>", EndPos, StringComparison.OrdinalIgnoreCase ) == -1 | (Data.IndexOf( "</table>", EndPos, StringComparison.OrdinalIgnoreCase ) < Data.IndexOf( "<tdalign=center>", EndPos, StringComparison.OrdinalIgnoreCase )) )
						break; // TODO: might not be correct. Was : Exit While

					// Calculate days in billing period -------------------
					BeginPos = Data.IndexOf( "<tdalign=center>", EndPos, StringComparison.OrdinalIgnoreCase ) + 16;
					EndPos = Data.IndexOf( "</td>", BeginPos, StringComparison.OrdinalIgnoreCase );
					DataLength = EndPos - BeginPos;

					try
					{
						usage.BeginDate = Convert.ToDateTime( Data.Substring( BeginPos, DataLength ).Trim() );
					}
					catch( Exception ) { }

					BeginPos = Data.IndexOf( "<tdalign=center>", EndPos, StringComparison.OrdinalIgnoreCase ) + 16;
					EndPos = Data.IndexOf( "</td>", BeginPos, StringComparison.OrdinalIgnoreCase );
					DataLength = EndPos - BeginPos;

					try
					{
						usage.EndDate = Convert.ToDateTime( Data.Substring( BeginPos, DataLength ).Trim() );
					}
					catch( Exception ) { }

					// Days Billing Period --------------------------------
					try
					{
						usage.Days = (usage.EndDate - usage.BeginDate).Days;
					}
					catch( Exception ) { }

					// Total KWH ------------------------------------------
					BeginPos = Data.IndexOf( "<tdalign=right>", EndPos, StringComparison.OrdinalIgnoreCase ) + 15;
					EndPos = Data.IndexOf( "</td>", BeginPos, StringComparison.OrdinalIgnoreCase );
					DataLength = EndPos - BeginPos;

					try
					{
						usage.TotalKwh = Convert.ToInt32( Data.Substring( BeginPos, DataLength ).Trim() );
					}
					catch( Exception ) { }

					// KVARS ----------------------------------
					BeginPos = Data.IndexOf( "<tdalign=right>", EndPos, StringComparison.OrdinalIgnoreCase ) + 15;
					EndPos = Data.IndexOf( "</td>", BeginPos, StringComparison.OrdinalIgnoreCase );
					DataLength = EndPos - BeginPos;


					// Billing Demand KW ----------------------------------
					BeginPos = Data.IndexOf( "<tdalign=right>", EndPos, StringComparison.OrdinalIgnoreCase ) + 15;
					EndPos = Data.IndexOf( "</td>", BeginPos, StringComparison.OrdinalIgnoreCase );
					DataLength = EndPos - BeginPos;

					usage.Demand = Convert.ToDecimal( Data.Substring( BeginPos, DataLength ).Trim() );

					// Current Charges ------------------------------------
					BeginPos = Data.IndexOf( "<tdalign=right>", EndPos, StringComparison.OrdinalIgnoreCase ) + 15;
					EndPos = Data.IndexOf( "</td>", BeginPos, StringComparison.OrdinalIgnoreCase );
					DataLength = EndPos - BeginPos;

					usage.BillAmount = Convert.ToDecimal( Data.Substring( BeginPos, DataLength ).Trim() );

					//coned.WebUsageList.Add( usage );
					list.Add( usage );

					LoopCount += 1;
				}

				coned.WebUsageList = list;

				if( LoopCount <= 0 )
					return "Success - No Annual Usage";
				else
					return "Success";

			}
			catch( Exception ex )
			{
				if( ex.Message.ToLower().Contains( "arithmetic" ) & ex.Message.ToLower().Contains( "overflow" ) )
					return "No historical usage found.";
				else
					return ex.Message;
			}
		}

        private static void AcquireAndStoreDeterminantHistory(Coned coned)
        {
			DataSet ds = OfferSql.AccountExistsInOfferEngine( coned.AccountNumber, "CONED" );
            if (ds.Tables[0].Rows[0]["Exists"].ToString() == "0" && !TransactionsSql.HasUsageTransaction(coned.AccountNumber, "CONED"))
                return;
            var aid = new AccountIdentifier("CONED", coned.AccountNumber);
            var billGroup = coned.BillGroup ?? string.Empty;
            
            FieldHistoryManager.FieldValueInsert(aid, TrackedField.Utility, "CONED", null, FieldUpdateSources.WebScraping, "", FieldLockStatus.Unknown, _applyMapping);
			if(coned.Icap >=0)
            FieldHistoryManager.FieldValueInsert(aid, TrackedField.ICap, coned.Icap.ToString(), null, FieldUpdateSources.WebScraping, "", FieldLockStatus.Unknown, _applyMapping);
            FieldHistoryManager.FieldValueInsert(aid, TrackedField.Zone, coned.LbmpZone, null, FieldUpdateSources.WebScraping, "", FieldLockStatus.Unknown, _applyMapping);
            FieldHistoryManager.FieldValueInsert(aid, TrackedField.LoadProfile, coned.Profile ?? "", null, FieldUpdateSources.WebScraping, "", FieldLockStatus.Unknown, _applyMapping);
            FieldHistoryManager.FieldValueInsert(aid, TrackedField.RateClass, coned.ServiceClass ?? "", null, FieldUpdateSources.WebScraping, "", FieldLockStatus.Unknown, _applyMapping);
            if (!string.IsNullOrWhiteSpace(billGroup) && Convert.ToInt16(billGroup) > -1)
            {
                FieldHistoryManager.FieldValueInsert(aid, TrackedField.BillGroup, billGroup, null, FieldUpdateSources.WebScraping, "", FieldLockStatus.Unknown, _applyMapping);
            }
        }
	}
}