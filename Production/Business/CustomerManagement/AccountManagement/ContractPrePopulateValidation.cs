namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;
	using System.Data;
	using System.Configuration;

	using LibertyPower.Business.CustomerAcquisition.DailyPricing;
	using LibertyPower.Business.MarketManagement.UtilityManagement;
	using LibertyPower.Business.CustomerAcquisition.ProspectManagement;
	using LibertyPower.Business.CustomerAcquisition.ProductManagement;
	using LibertyPower.DataAccess.SqlAccess.AccountSql;
	using LibertyPower.Business.CommonBusiness.SecurityManager;
	using LibertyPower.Business.CustomerAcquisition.Prospects;

	public static class ContractPrePopulateValidation
	{
		public static void ValidateContract( string username, ProspectContract contract )
		{
			try
			{
				if( contract.ContractType != "POLR" && contract.ContractType != "POWER MOVE" )
				{
					if( contract.Utility.RetailMarketID != contract.Market.ID )
					{
						throw new Exception( "Utility does not belong to this Market. Please refer to help section for list of Market-Utility Codes" );
					}
					int gracePeriod = contract.GracePeriod;
					//do validations
					//delete errors from 

					//usp_contract_val
					//usp_contract_express_val
					if( contract.Product != null )
					{
						ValidateExpress( username, contract.GracePeriod, contract.ContractType, contract.Status, contract.ContractNumber, contract.DateDeal, contract.Product.ProductId, contract.RateId );
					}
					else
					{
						throw new Exception( "Product is null" );
					}

					// end of usp_contract_express_val

                    // As per Michael Cofer
                    //if( String.IsNullOrEmpty( contract.ContractNumber ) )
                    //{
                    //    throw new Exception( AccountSql.SelectMessage( "DEAL", "00000011" ) );
                    //}

                    // As per Michael Cofer
                    //if( String.IsNullOrEmpty( contract.ContractType ) || contract.ContractType.ToUpper() == "Corparate".ToUpper() || contract.ContractType.ToUpper() == "Power Move".ToUpper() )
                    //{
                    //    throw new Exception( AccountSql.SelectMessage( "DEAL", "00000012" ) );
                    //}

					if( contract.Username.Username != username )
					{
						if( !CheckRole( username, contract.SalesChannelRole ) && !CheckRole( username, "LibertyPowerSales" ) )
							throw new Exception( AccountSql.SelectMessage( "DEAL", "00000004" ) );
					}

					//end of usp_contract_val

					//usp_contract_link_val
					ValidateLink( contract.CustomerNameLink, contract.OwnerNameLink, contract.CustomerAddressLink, contract.BillingAddressLink, contract.ServiceAddressLink, contract.CustomerContactLink, contract.BillingContactLink );
					//end of usp_contract_link_val

					CompanyAccountType ConvertedType = ConvertAccountType( contract.AccountType );

					//usp_contract_general_val
					ValidateGeneral( username, ConvertedType, contract.AdditionalIdNumber, contract.AdditionalIdNumberType, contract.SalesChannelRole, contract.SalesRep );
					//end of usp_contract_general_val ok

					//usp_contract_pricing_val
					ValidatePricing( contract.Market, contract.Utility, contract.Product, contract.RateId, contract.Rate, contract.TermMonths, contract.ContractType,
						contract.EnrollmentType, contract.RequestedFlowStartDate, contract.DateDeal, contract.PriceID );
					//end of usp_contract_pricing_val ok

					//[usp_contract_contact_val]
					ValidateContact( contract.CustomerFirstName, contract.CustomerLastName, contract.BillingFirstName, contract.BillingLastName, contract.CustomerTitle, contract.BillingTitle, contract.CustomerPhone, contract.BillingPhone );
					//end of [usp_contract_contact_val]

					//[usp_contract_name_val]
					ValidateName( contract.CustomerName, contract.OwnerName );
					//end of [usp_contract_name_val]

					ValidateAccounts( username, contract.Accounts );
				}
				//end of [usp_contract_submit_val]
			}
			catch( Exception e )
			{
				contract.ErrorMsg = e.Message;
				throw new Exception( e.Message );
			}
		}

		private static CompanyAccountType ConvertAccountType( LibertyPower.Business.CustomerAcquisition.ProductManagement.AccountType? a )
		{
			CompanyAccountType ConvertedType = CompanyAccountType.SMB;
			if( a == LibertyPower.Business.CustomerAcquisition.ProductManagement.AccountType.Lci )
				ConvertedType = CompanyAccountType.LCI;
			else if( a == LibertyPower.Business.CustomerAcquisition.ProductManagement.AccountType.Residential )
				ConvertedType = CompanyAccountType.RESIDENTIAL;
			else if( a == LibertyPower.Business.CustomerAcquisition.ProductManagement.AccountType.Soho )
				ConvertedType = CompanyAccountType.SOHO;
			return ConvertedType;
		}

		private static void ValidatePricing( RetailMarket Market, Utility Utility, Product Product, int RateId, decimal Rate, int TermMonths, string ContractType, int EnrollmentType,
			DateTime RequestedFlowStartDate, DateTime DateDeal, Int64 priceID )
		{
			if( Market == null || Market.Code == "NN" )
			{
				throw new Exception( AccountSql.SelectMessage( "DEAL", "00000017" ) );
			}
			if( Utility == null )
			{
				throw new Exception( AccountSql.SelectMessage( "DEAL", "00000006" ) );
			}
			if( Product == null )
			{
				throw new Exception( AccountSql.SelectMessage( "COMMON", "00000032" ) );
			}

            // As per Micahel Cofer
            if ((RateId == 0) && (Product.Category == LibertyPower.Business.CustomerAcquisition.ProductManagement.ProductCategory.Fixed))
            {
                throw new Exception(AccountSql.SelectMessage("COMMON", "00000042"));
            }

            //if( (Rate <= 0) && (Product.Category == LibertyPower.Business.CustomerAcquisition.ProductManagement.ProductCategory.Fixed) )
            //{
            //    throw new Exception( AccountSql.SelectMessage( "COMMON", "00000045" ) );
            //}
			if( (TermMonths <= 0) && ContractType == "CORPORATE" )
			{
				throw new Exception( AccountSql.SelectMessage( "DEAL", "00000030" ) );
			}
            //if( Market.Code != "TX" && EnrollmentType != 1 )
            //{
            //    throw new Exception( AccountSql.SelectMessage( "RISK", "00000103" ) );
            //}
            // AS per Michael Cofer
            //if( Market.Code == "TX" )
            //{
            //    if( RequestedFlowStartDate.DayOfWeek == DayOfWeek.Sunday || RequestedFlowStartDate.DayOfWeek == DayOfWeek.Saturday )
            //    {
            //        throw new Exception( AccountSql.SelectMessage( "COMMON", "00001053" ) );
            //    }
            //    if( EnrollmentType == 8 )
            //    {
            //        if( Convert.ToDateTime( RequestedFlowStartDate.ToString( "MM/" ) + "01/" + RequestedFlowStartDate.ToString( "yyyy" ) ) <
            //            Convert.ToDateTime( DateTime.Today.AddMonths( 1 ).ToString( "MM/" ) + "01/" + DateTime.Today.AddMonths( 1 ).ToString( "yyyy" ) ) ||
            //            Convert.ToDateTime( RequestedFlowStartDate.ToString( "MM/" ) + "01/" + RequestedFlowStartDate.ToString( "yyyy" ) ) >
            //            Convert.ToDateTime( DateTime.Today.AddMonths( 12 ).ToString( "MM/" ) + "01/" + DateTime.Today.AddMonths( 1 ).ToString( "yyyy" ) ) )
            //        {
            //            throw new Exception( AccountSql.SelectMessage( "COMMON", "00001045" ) );
            //        }
            //        else
            //        {
            //            throw new Exception( AccountSql.SelectMessage( "COMMON", "00001046" ) );
            //        }
            //    }
            //    if( EnrollmentType == 4 )
            //    {
            //        DateTime aux = DateTime.Today;
            //        DateTime aux2 = DateTime.Today;

            //        if( DateTime.Today.AddDays( 3 ).DayOfWeek == DayOfWeek.Sunday )
            //            aux = DateTime.Today.AddDays( 4 );
            //        else if( DateTime.Today.AddDays( 3 ).DayOfWeek == DayOfWeek.Saturday )
            //            aux = DateTime.Today.AddDays( 5 );
            //        else
            //            aux = DateTime.Today.AddDays( 3 );

            //        if( DateTime.Today.AddDays( 60 ).DayOfWeek == DayOfWeek.Sunday )
            //            aux2 = DateTime.Today.AddDays( 58 );
            //        else if( DateTime.Today.AddDays( 60 ).DayOfWeek == DayOfWeek.Saturday )
            //            aux2 = DateTime.Today.AddDays( 59 );
            //        else
            //            aux2 = DateTime.Today.AddDays( 60 );

            //        //if( RequestedFlowStartDate < aux || RequestedFlowStartDate > aux2 )
            //        //{
            //        //    throw new Exception( AccountSql.SelectMessage( "COMMON", "00001041" ) );
            //        //}
            //    }
            //    if( EnrollmentType == 6 )
            //    {
            //        DateTime aux = DateTime.Today;
            //        if( DateTime.Today.AddDays( 5 ).DayOfWeek == DayOfWeek.Sunday )
            //            aux = DateTime.Today.AddDays( 6 );
            //        else if( DateTime.Today.AddDays( 3 ).DayOfWeek == DayOfWeek.Saturday )
            //            aux = DateTime.Today.AddDays( 7 );
            //        else
            //            aux = DateTime.Today.AddDays( 5 );
            //        //if( RequestedFlowStartDate < aux )
            //        //{
            //        //    throw new Exception( AccountSql.SelectMessage( "COMMON", "00001042" ) );
            //        //}

            //        if( DateTime.Today.AddDays( 14 ).DayOfWeek == DayOfWeek.Sunday )
            //            aux = DateTime.Today.AddDays( 19 );
            //        else
            //            aux = DateTime.Today.AddDays( 18 );

            //        if( RequestedFlowStartDate > aux )
            //        {
            //            throw new Exception( AccountSql.SelectMessage( "COMMON", "00001052" ) );
            //        }
            //    }
            //    if( EnrollmentType == 5 )
            //    {
            //        DateTime aux = DateTime.Today;
            //        if( DateTime.Today.AddDays( -15 ).DayOfWeek == DayOfWeek.Sunday )
            //            aux = DateTime.Today.AddDays( -20 );
            //        else if( DateTime.Today.AddDays( -15 ).DayOfWeek == DayOfWeek.Monday )
            //            aux = DateTime.Today.AddDays( -21 );
            //        else
            //            aux = DateTime.Today.AddDays( -19 );
            //        if( RequestedFlowStartDate < aux )
            //        {
            //            throw new Exception( AccountSql.SelectMessage( "COMMON", "00001043" ) );
            //        }
            //    }
            //}
			decimal rate = 0;
			if( DateDeal != null )
			{
				CrossProductPriceSalesChannel price = CrossProductPriceFactory.GetSalesChannelPrice( priceID );

				if( price != null )
				{
					rate = price.Price;
				}
				else
				{
					ProductRate objRate = ProductRateFactory.GetAccountProductRate( Product, RateId, DateDeal );
					rate = objRate.Rate;
				}
			}
			else
			{
				ProductRate objRate = ProductRateFactory.GetAccountProductRate( Product, RateId, DateTime.Today );
				rate = objRate.Rate;
			}
            //if( Rate < rate && Product.Category == ProductCategory.Fixed
            //    && Product.IsFlexible )
            //{
            //    throw new Exception( AccountSql.SelectMessage( "COMMON", "00000045" ) );
            //}

			//decimal customCap = 0;
			//customCap = GetCustomCap( contract.Product.ProductId, contract.RateId );

			//if( (contract.Rate > rate + customCap) && contract.Product.IsFlexible )
			//{
			//    throw new Exception( AccountSql.SelectMessage( "DEAL", "00000044" ) );
			//}

            //if( DateDeal < DateTime.Today.AddDays( -365 ) || DateDeal > DateTime.Today )
            //{
            //    throw new Exception( AccountSql.SelectMessage( "DEAL", "00000047" ) );
            //}
		}

		private static void ValidateExpress( string username, int GracePeriod, string ContractType, string Status, string ContractNumber, DateTime DateDeal, string ProductId, int RateId )
		{
			int gracePeriod = GracePeriod;

			if( GracePeriod == 0 && ContractType == "VOICE" )
			{
				// product and rate ids will be generated later - IT106
				gracePeriod = GetGracePeriodByProductIdAndRateId( username, ProductId, RateId );
			}

            // As per Michael Cofer
            //if( (ContractType == "VOICE" || ContractType == "PAPER" || ContractType == "PRE-PRINTED") && (gracePeriod != 0) )
            //{
            //    //if( DateDeal.AddDays( gracePeriod ) <= DateTime.Today )
            //    //{
            //    //    throw new Exception( AccountSql.SelectMessage( "DEAL", "00000036" ) );
            //    //}
            //}

			if( Status == "SENT" )
			{
				throw new Exception( AccountSql.SelectMessage( "DEAL", "00000042" ) );
			}

           
		}


		private static void ValidateLinkAccount( int CustomerNameLink, int OwnerNameLink, int CustomerAddressLink, int BillingAddressLink, int ServiceAddressLink, int CustomerContactLink, int BillingContactLink, int AccountNameLink )
		{
			if( AccountNameLink == 0 )
				throw new Exception( AccountSql.SelectMessage( "DEAL", "00000039" ) ); //Raju- should ask Anderson
			ValidateLink( CustomerNameLink, OwnerNameLink, CustomerAddressLink, BillingAddressLink, ServiceAddressLink, CustomerContactLink, BillingContactLink );
		}

		private static void ValidateLink( int CustomerNameLink, int OwnerNameLink, int CustomerAddressLink, int BillingAddressLink, int ServiceAddressLink, int CustomerContactLink, int BillingContactLink )
		{
			if( CustomerNameLink == 0 || OwnerNameLink == 0 )
			{
                throw new Exception(AccountSql.SelectMessage("DEAL", "00000039")); //Raju- should ask Anderson
			}

            // AS per discussion with Michael Cofer
            //if( CustomerAddressLink == 0 || BillingAddressLink == 0 || ServiceAddressLink == 0 )
            //{
            //    throw new Exception( AccountSql.SelectMessage( "DEAL", "00000037" ) );
            //}

            //if( CustomerContactLink == 0 || BillingContactLink == 0 )
            //{
            //    throw new Exception( AccountSql.SelectMessage( "DEAL", "00000038" ) ); //As per Michael Cofer
            //}
		}

		private static void ValidateGeneral( string username, CompanyAccountType Type, string AdditionalIdNumber, string AdditionalIdNumberType, string SalesChannelRole, string SalesRep )
		{
			if( Type == CompanyAccountType.SOHO )
			{
				if( AdditionalIdNumberType != "TAX ID" )
					throw new Exception( "Tax ID is required for SOHO accounts." ); //Raju- Should confirm this one with Anderson
			}

            // AS per Michael Cofer

            //if( String.IsNullOrEmpty( AdditionalIdNumber ) && AdditionalIdNumberType != "NONE" )
            //{
            //    throw new Exception( AccountSql.SelectMessage( "DEAL", "00000029" ) );
            //}
            //if( (String.IsNullOrEmpty( AdditionalIdNumberType ) || AdditionalIdNumberType == "NONE")
            //    && (!String.IsNullOrEmpty( AdditionalIdNumber )) && (AdditionalIdNumber != "NONE") )
            //{
            //    throw new Exception( AccountSql.SelectMessage( "DEAL", "00000028" ) );
            //}
            //if( String.IsNullOrEmpty( SalesChannelRole ) || SalesChannelRole == "NONE" )
            //{
            //    throw new Exception( AccountSql.SelectMessage( "DEAL", "00000032" ) );
            //}

			if( !CheckRole( username, SalesChannelRole ) && !CheckRole( username, "LibertyPowerEmployes" ) )
				throw new Exception( AccountSql.SelectMessage( "DEAL", "00000041" ) );

            //if( String.IsNullOrEmpty( SalesRep ) )
            //{
            //    throw new Exception( AccountSql.SelectMessage( "DEAL", "00000031" ) );
            //}
		}

		private static void ValidateName( string CustomerName, string OwnerName )
		{
            // AS per Michael Cofer
            //if( string.IsNullOrEmpty( CustomerName ) || string.IsNullOrEmpty( OwnerName ) )
            //{
            //    throw new Exception( AccountSql.SelectMessage( "COMMON", "00000078" ) );
            //}
		}

		private static void ValidateContact( string CustomerFirstName, string CustomerLastName, string BillingFirstName, string BillingLastName,
			string CustomerTitle, string BillingTitle, string CustomerPhone, string BillingPhone )
		{
            // As per Michael Cofer
            //if( string.IsNullOrEmpty( CustomerFirstName ) || string.IsNullOrEmpty( BillingFirstName ) )
            //{
            //    // throw new Exception( AccountSql.SelectMessage( "COMMON", "00000071" ) );
            //}
            //if( string.IsNullOrEmpty( CustomerLastName ) || string.IsNullOrEmpty( BillingLastName ) )
            //{
            //    // throw new Exception( AccountSql.SelectMessage( "COMMON", "00000072" ) );
            //}
            //if( string.IsNullOrEmpty( CustomerTitle ) || string.IsNullOrEmpty( BillingTitle ) )
            //{
            //    // throw new Exception( AccountSql.SelectMessage( "COMMON", "00000073" ) );
            //}
            //if (string.IsNullOrEmpty(CustomerPhone) || CustomerPhone.Length < 10 || CustomerPhone.Length > 10 ||
            //    string.IsNullOrEmpty(BillingPhone) || BillingPhone.Length < 10   || BillingPhone.Length>10)
            //{
            //    throw new Exception(AccountSql.SelectMessage("COMMON", "00000074"));
            //}
		}

		public static void ValidateAccounts( string username, List<ProspectAccount> accounts )
        {  
            // AS per discussion with Michael Cofer
            //if( accounts.Count < 1 )
            //{
            //    throw new Exception( AccountSql.SelectMessage( "DEAL", "00000040" ) );
            //}

			foreach( ProspectAccount acc in accounts )
			{
				try
				{
					//usp_contract_account_val
					if( !string.IsNullOrEmpty( acc.AccountNumber ) )
					{
                        //As per Michael Cofer- Validate Account only if something is entered
						//throw new Exception( AccountSql.SelectMessage( "DEAL", "00000033" ) );

                        if (acc.Utility.Code == "CMD" && (acc.AccountNumber.Length <= 13 || !acc.AccountNumber.StartsWith("0")))
                        {
                            throw new Exception(AccountSql.SelectMessage("DEAL", "00000055"));
                        }

                        if (acc.Utility.AccountNumberLength > 0 && acc.AccountNumber.Length != acc.Utility.AccountNumberLength)
                        {
                            throw new Exception(AccountSql.SelectMessage("DEAL", "00000034"));
                        }

                        if (!string.IsNullOrEmpty(acc.Utility.AccountNumberPrefix) && acc.Utility.AccountNumberPrefix != "0" && !acc.AccountNumber.StartsWith(acc.Utility.AccountNumberPrefix))
                        {
                            throw new Exception(AccountSql.SelectMessage("DEAL", "00000035"));
                        }
					}

					//if( CheckIfAccountWasSentByAnotherContract( acc.AccountNumber, acc.ContractNumber ) )
					//{
					//    throw new Exception( AccountSql.SelectMessage( "DEAL", "00000002" ) );
					//}

                    // AS per discussion with Michael Cofer
                    //if( CheckAccountActive( username, acc.AccountNumber, acc.Utility.Code ) )
                    //{
                    //    throw new Exception( AccountSql.SelectMessage( "COMMON", "00001013" ) );
                    //}

                    //if( LibertyPower.DataAccess.SqlAccess.LibertyPowerSql.AccountSqlLP.CheckIfAccountIsDoNotEnroll( acc.AccountNumber ) )
                    //{
                    //    throw new Exception( "Account is in Do Not Enroll list." );
                    //}

					
					//end of usp_contract_account_val

					//[usp_contract_link_val]				
					ValidateLinkAccount( acc.CustomerNameLink, acc.OwnerNameLink, acc.CustomerAddressLink, acc.BillingAddressLink, acc.ServiceAddressLink, acc.CustomerContactLink, acc.BillingContactLink, acc.AccountNameLink );
					//end of [usp_contract_link_val]

					//usp_contract_general_val
					CompanyAccountType AccountType = ConvertAccountType( (LibertyPower.Business.CustomerAcquisition.ProductManagement.AccountType) Enum.Parse( typeof( LibertyPower.Business.CustomerAcquisition.ProductManagement.AccountType ), acc.AccountType, true ) );


					ValidateGeneral( username, AccountType, acc.AdditionalIdNumber, acc.AdditionalIdNumberType, acc.SalesChannelRole, acc.SalesRep );

					//end of usp_contract_general_val

					//[usp_contract_pricing_val]				
					if( acc.Market == null || acc.Market.Code == "NN" )
					{
						throw new Exception( AccountSql.SelectMessage( "DEAL", "00000017" ) );
					}

					if( acc.Utility == null )
					{
						throw new Exception( AccountSql.SelectMessage( "DEAL", "00000006" ) );
					}

					if( acc.Product == null )
					{
						throw new Exception( AccountSql.SelectMessage( "COMMON", "00000032" ) );
					}

					if( (acc.RateId == 0) && (acc.Product.Category == LibertyPower.Business.CustomerAcquisition.ProductManagement.ProductCategory.Fixed) )
					{
						throw new Exception( AccountSql.SelectMessage( "COMMON", "00000042" ) );
					}

                    // As per Michael Cofer
                    //if( (acc.Rate <= 0) && (acc.Product.Category == LibertyPower.Business.CustomerAcquisition.ProductManagement.ProductCategory.Fixed) )
                    //{
                    //    throw new Exception( AccountSql.SelectMessage( "COMMON", "00000045" ) );
                    //}

					if( (acc.TermMonths <= 0) && acc.ContractType == "CORPORATE" )
					{
						throw new Exception( AccountSql.SelectMessage( "DEAL", "00000030" ) );
					}

                    //if( acc.Market.Code != "TX" && acc.EnrollmentType != 1 )
                    //{
                    //    throw new Exception( AccountSql.SelectMessage( "RISK", "00000103" ) );
                    //}
                    //if( acc.Market.Code == "TX" )
                    //{
                    //    if( acc.RequestedFlowStartDate.DayOfWeek == DayOfWeek.Sunday || acc.RequestedFlowStartDate.DayOfWeek == DayOfWeek.Saturday )
                    //    {
                    //        throw new Exception( AccountSql.SelectMessage( "COMMON", "00001053" ) );
                    //    }
                    //    if( acc.EnrollmentType == 8 )
                    //    {
                    //        if( Convert.ToDateTime( acc.RequestedFlowStartDate.ToString( "MM/" ) + "01/" + acc.RequestedFlowStartDate.ToString( "yyyy" ) ) <
                    //            Convert.ToDateTime( DateTime.Today.AddMonths( 1 ).ToString( "MM/" ) + "01/" + DateTime.Today.AddMonths( 1 ).ToString( "yyyy" ) ) ||
                    //            Convert.ToDateTime( acc.RequestedFlowStartDate.ToString( "MM/" ) + "01/" + acc.RequestedFlowStartDate.ToString( "yyyy" ) ) >
                    //            Convert.ToDateTime( DateTime.Today.AddMonths( 12 ).ToString( "MM/" ) + "01/" + DateTime.Today.AddMonths( 1 ).ToString( "yyyy" ) ) )
                    //        {
                    //            throw new Exception( AccountSql.SelectMessage( "COMMON", "00001045" ) );
                    //        }
                    //        else
                    //        {
                    //            throw new Exception( AccountSql.SelectMessage( "COMMON", "00001046" ) );
                    //        }

                    //    }
                    //    if( acc.EnrollmentType == 4 )
                    //    {
                    //        DateTime aux = DateTime.Today;
                    //        DateTime aux2 = DateTime.Today;

                    //        if( DateTime.Today.AddDays( 3 ).DayOfWeek == DayOfWeek.Sunday )
                    //            aux = DateTime.Today.AddDays( 4 );
                    //        else if( DateTime.Today.AddDays( 3 ).DayOfWeek == DayOfWeek.Saturday )
                    //            aux = DateTime.Today.AddDays( 5 );
                    //        else
                    //            aux = DateTime.Today.AddDays( 3 );

                    //        if( DateTime.Today.AddDays( 60 ).DayOfWeek == DayOfWeek.Sunday )
                    //            aux2 = DateTime.Today.AddDays( 58 );
                    //        else if( DateTime.Today.AddDays( 60 ).DayOfWeek == DayOfWeek.Saturday )
                    //            aux2 = DateTime.Today.AddDays( 59 );
                    //        else
                    //            aux2 = DateTime.Today.AddDays( 60 );

                    //        if( acc.RequestedFlowStartDate < aux || acc.RequestedFlowStartDate > aux2 )
                    //        {
                    //            throw new Exception( AccountSql.SelectMessage( "COMMON", "00001041" ) );
                    //        }
                    //    }
                    //    if( acc.EnrollmentType == 6 )
                    //    {
                    //        DateTime aux = DateTime.Today;
                    //        if( DateTime.Today.AddDays( 5 ).DayOfWeek == DayOfWeek.Sunday )
                    //            aux = DateTime.Today.AddDays( 6 );
                    //        else if( DateTime.Today.AddDays( 3 ).DayOfWeek == DayOfWeek.Saturday )
                    //            aux = DateTime.Today.AddDays( 7 );
                    //        else
                    //            aux = DateTime.Today.AddDays( 5 );
                    //        if( acc.RequestedFlowStartDate < aux )
                    //        {
                    //            throw new Exception( AccountSql.SelectMessage( "COMMON", "00001042" ) );
                    //        }

                    //        if( DateTime.Today.AddDays( 14 ).DayOfWeek == DayOfWeek.Sunday )
                    //            aux = DateTime.Today.AddDays( 19 );
                    //        else
                    //            aux = DateTime.Today.AddDays( 18 );

                    //        if( acc.RequestedFlowStartDate > aux )
                    //        {
                    //            throw new Exception( AccountSql.SelectMessage( "COMMON", "00001052" ) );
                    //        }
                    //    }
                    //    if( acc.EnrollmentType == 5 )
                    //    {
                    //        DateTime aux = DateTime.Today;
                    //        if( DateTime.Today.AddDays( -15 ).DayOfWeek == DayOfWeek.Sunday )
                    //            aux = DateTime.Today.AddDays( -20 );
                    //        else if( DateTime.Today.AddDays( -15 ).DayOfWeek == DayOfWeek.Monday )
                    //            aux = DateTime.Today.AddDays( -21 );
                    //        else
                    //            aux = DateTime.Today.AddDays( -19 );
                    //        //if( acc.RequestedFlowStartDate < aux )
                    //        //{
                    //        //    throw new Exception( AccountSql.SelectMessage( "COMMON", "00001043" ) );
                    //        //}
                    //    }
                    //}
					decimal rate = 0;
					Int64 priceID = acc.PriceID;
					if( acc.DateDeal != null )
					{
						CrossProductPriceSalesChannel price = CrossProductPriceFactory.GetSalesChannelPrice( priceID );

						if( price != null )
						{
							rate = price.Price;
						}
						else
						{
							ProductRate objRate = ProductRateFactory.GetAccountProductRate( acc.Product, acc.RateId, acc.DateDeal );
							rate = objRate.Rate;
						}
					}
					else
					{
						ProductRate objRate = ProductRateFactory.GetAccountProductRate( acc.Product, acc.RateId, DateTime.Today );
						rate = objRate.Rate;
					}
					if( acc.Rate < rate && acc.Product.Category == ProductCategory.Fixed
						&& acc.Product.IsFlexible && !acc.Product.IsCustom )
					{
						throw new Exception( AccountSql.SelectMessage( "COMMON", "00000045" ) );
					}

					//decimal customCap = 0;
					//customCap = GetCustomCap( acc.Product.ProductId, acc.RateId );

					//if( (acc.Rate > rate + customCap) && acc.Product.IsFlexible )
					//{
					//    throw new Exception( AccountSql.SelectMessage( "DEAL", "00000044" ) );
					//}

                    //if( acc.DateDeal < DateTime.Today.AddDays( -365 ) || acc.DateDeal > DateTime.Today )
                    //{
                    //    throw new Exception( AccountSql.SelectMessage( "DEAL", "00000047" ) );
                    //}
					//end of [usp_contract_pricing_val]

					//usp_contract_contact_val
					ValidateContact( acc.CustomerFirstName, acc.CustomerLastName, acc.BillingFirstName, acc.BillingLastName, acc.CustomerTitle, acc.BillingTitle, acc.CustomerPhone, acc.BillingPhone );
					//end of usp_contract_contact_val

					//usp_contract_name_val
					ValidateName( acc.CustomerName, acc.OwnerName );
					//end of usp_contract_name_val
				}
				catch( Exception e )
				{
					acc.ErrorMsg = e.Message;
					throw new Exception( e.Message );
				}
			}
		}

		public static bool CheckRole( string username, string role )
		{
			bool flag = false;

			DataSet ds = AccountSql.GetUserAndRoles( username, role );
			if( ds.Tables[0].Rows.Count > 0 )
			{
				flag = true;
			}

			return flag;
		}

		//change name to isAccountActive, criai uma propriedade na accoutn class para substituir esse metodo
		private static bool CheckAccountActive( string username, string accountNumber, string utilityCode )
		{
			bool flag = false;
			DataSet ds = AccountSql.GetCompanyAccountByNumber( username, accountNumber, utilityCode );

			if( ds.Tables[0].Rows.Count > 0 )
			{
				string status = ds.Tables[0].Rows[0]["status"].ToString().Trim() + ds.Tables[0].Rows[0]["sub_status"].ToString().Trim();

				if( !status.Contains( "91100010" ) && !status.Contains( "99999810" ) && !status.Contains( "99999910" ) )
				{
					flag = true;
				}
			}

			return flag;
		}

		public static int GetGracePeriodByProductIdAndRateId( string username, string productId, int rateId )
		{
			DataSet ds = AccountSql.GetProductRate( username, productId, rateId );
			int gracePeriod = 0;
			if( ds.Tables[0].Rows.Count > 0 )
			{
				DateTime effDate = Convert.ToDateTime( ds.Tables[0].Rows[0]["eff_date"] );
				DateTime dueDate = Convert.ToDateTime( ds.Tables[0].Rows[0]["due_date"] );
				if( effDate <= DateTime.Today && dueDate >= DateTime.Today )
				{
					gracePeriod = Convert.ToInt32( ds.Tables[0].Rows[0]["grace_period"] );
				}
			}

			return gracePeriod;
		}

		//change name  to CheckCopntractExists
		private static bool CheckContractExists( string contractNumber )
		{
			bool flag = false;
			DataSet ds = AccountSql.GetContract( contractNumber );
			if( ds.Tables[0].Rows.Count > 0 )
			{
				flag = true;
			}

			return flag;
		}
	}
}
