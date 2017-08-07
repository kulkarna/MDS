namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    using System;
    using System.Data;
    using System.Net;
    using System.Data.SqlClient;

    /// <summary>
    /// Returns datasets related to the pricing engine.
    /// </summary>
    [Serializable]
    public static class PricingEngineSql
    {
        /// <summary>
        /// Selects daily profiles based on utility, load shape id, zone, and date range.
        /// </summary>
        /// <param name="iso">ISO identifier</param>
        /// <param name="loadShapeId">Load shape identifier</param>
        /// <param name="zoneCode">Zone identifier</param>
        /// <param name="beginDate">Begin date</param>
        /// <param name="endDate">End Date</param>
        /// <returns>Returns a dataset containing daily profile based on utility, load shape id, zone, and date range.</returns>
        public static DataSet SelectDailyProfileCurves( string iso,
            string zoneCode, string loadShapeId, DateTime beginDate, DateTime endDate )
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEDailyProfileCurveSelect";

                    cmd.Parameters.Add( new SqlParameter( "@Iso", iso ) );
                    cmd.Parameters.Add( new SqlParameter( "@ZoneCode", zoneCode ) );
                    cmd.Parameters.Add( new SqlParameter( "@LoadShapeId", loadShapeId ) );
                    cmd.Parameters.Add( new SqlParameter( "@BeginDate", beginDate ) );
                    cmd.Parameters.Add( new SqlParameter( "@EndDate", endDate ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        /// <summary>
        /// Selects default markup based on market, utility, zone, pricing type,
        /// product type, term and annualized usage in Mwh.
        /// </summary>
        /// <param name="market">Market identifier</param>
        /// <param name="utilityCode">Utility identifier</param>
        /// <param name="zoneCode">Zone identifier</param>
        /// <param name="pricingType">Pricing type</param>
        /// <param name="productType">Product type</param>
        /// <param name="term">Term (in months)</param>
        /// <param name="relativeStartMonth">Relative start month</param>
        /// <param name="mwh">Usage in megawatt hours</param>
        /// <returns>Returns a dataset containing the default markup based on market, 
        /// utility, zone, pricing type, product type, term and annualized usage in Mwh.</returns>
        public static DataSet SelectDefaultMarkup( string market, string utilityCode,
            string zoneCode, string pricingType, string productType, int term,
            int relativeStartMonth, decimal mwh )
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEDefaultMarkupSelect";

                    cmd.Parameters.Add( new SqlParameter( "@Market", market ) );
                    cmd.Parameters.Add( new SqlParameter( "@UtilityCode", utilityCode ) );
                    cmd.Parameters.Add( new SqlParameter( "@ZoneCode", zoneCode ) );
                    cmd.Parameters.Add( new SqlParameter( "@PricingType", pricingType ) );
                    cmd.Parameters.Add( new SqlParameter( "@ProductType", productType ) );
                    cmd.Parameters.Add( new SqlParameter( "@Term", term ) );
                    cmd.Parameters.Add( new SqlParameter( "@RelativeStartMonth", relativeStartMonth ) );
                    cmd.Parameters.Add( new SqlParameter( "@Mwh", mwh ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        /// <summary>
        /// Selects block energy prices based on ISO, zone, curve dates and curve type.
        /// </summary>
        /// <param name="iso">ISO identifier</param>
        /// <param name="zoneCode">Zone identifier</param>
        /// <param name="beginDate">Begin date of curve</param>
        /// <param name="endDate">End date of curve</param>
        /// <param name="curveType">Type of curve (peak, off-peak)</param>
        /// <returns>Returns a dataset containing block energy prices based on ISO, zone, curve dates and curve type.</returns>
        public static DataSet SelectBlockEnergyCurves( string iso, string zoneCode,
            DateTime beginDate, DateTime endDate, string curveType )
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEBlockEnergyCurvesSelect";

                    cmd.Parameters.Add( new SqlParameter( "@Iso", iso ) );
                    cmd.Parameters.Add( new SqlParameter( "@ZoneCode", zoneCode ) );
                    cmd.Parameters.Add( new SqlParameter( "@BeginDate", beginDate ) );
                    cmd.Parameters.Add( new SqlParameter( "@EndDate", endDate ) );
                    cmd.Parameters.Add( new SqlParameter( "@CurveType", curveType ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        /// <summary>
        /// Selects supplier premium factors based on ISO, zone, curve date and curve type.
        /// </summary>
        /// <param name="iso">ISO identifier</param>
        /// <param name="zoneCode">Zone identifier</param>
        /// <param name="beginDate">Begin date of curve</param>
        /// <param name="endDate">End date of curve</param>
        /// <param name="curveType">Type of curve (peak, off-peak)</param>
        /// <returns>Returns a dataset containing supplier premium factors based on ISO, zone, curve date and curve type.</returns>
        public static DataSet SelectSupplierPremiums( string iso, string zoneCode,
            DateTime beginDate, DateTime endDate, string curveType )
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PESupplierPremiumFactorsSelect";

                    cmd.Parameters.Add( new SqlParameter( "@Iso", iso ) );
                    cmd.Parameters.Add( new SqlParameter( "@ZoneCode", zoneCode ) );
                    cmd.Parameters.Add( new SqlParameter( "@BeginDate", beginDate ) );
                    cmd.Parameters.Add( new SqlParameter( "@EndDate", endDate ) );
                    cmd.Parameters.Add( new SqlParameter( "@CurveType", curveType ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        /// <summary>
        /// Selects shaping premium factors based on load shape id, zone, month, and year
        /// </summary>
        /// <param name="iso">ISO identifier</param>
        /// <param name="zoneCode">Zone identifier</param>
        /// <param name="loadShapeId">Load shape ID</param>
        /// <param name="beginDate">Begin date of curve</param>
        /// <param name="endDate">End date of curve</param>
        /// <returns>Returns a dataset containing shaping premium factors based on load shape id, zone, month, and year.</returns>
        public static DataSet SelectShapingPremiums( string iso, string zoneCode, string loadShapeId,
             DateTime beginDate, DateTime endDate )
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEShapingFactorCurvesSelect";

                    cmd.Parameters.Add( new SqlParameter( "@Iso", iso ) );
                    cmd.Parameters.Add( new SqlParameter( "@ZoneCode", zoneCode ) );
                    cmd.Parameters.Add( new SqlParameter( "@LoadShapeId", loadShapeId ) );
                    cmd.Parameters.Add( new SqlParameter( "@BeginDate", beginDate ) );
                    cmd.Parameters.Add( new SqlParameter( "@EndDate", endDate ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        /// <summary>
        /// Selects latest value from snapshot report.
        /// </summary>
        /// <param name="symbol">Symbol that represents contract type, month, and year</param>
        /// <param name="reportDate">Trade date</param>
        /// <returns>Returns a dataset containing the latest value from snapshot report.</returns>
        public static DataSet SelectLatestEnergyTradingMarketCurveReport( string symbol, DateTime tradeDate )
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEEnergyTradingMarketCurveReportsLatestSelect";

                    cmd.Parameters.Add( new SqlParameter( "@Symbol", symbol ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        /// <summary>
        /// Selects month symbol to be used as part of report symbol.
        /// </summary>
        /// <param name="month">Month (integer value)</param>
        /// <returns>Returns a dataset containing the month symbol to be used as part of report symbol.</returns>
        public static DataSet SelectTickerSymbolByMonth( int month )
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PETickerSymbolByMonthSelect";

                    cmd.Parameters.Add( new SqlParameter( "@Month", month ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        /// <summary>
        /// Selects loss factor based on utility, service class, voltage, month, and year.
        /// </summary>
        /// <param name="utilityCode">Utility identifier</param>
        /// <param name="serviceClass">Service class</param>
        /// <param name="voltage">Voltage</param>
        /// <param name="month">Month (integer value)</param>
        /// <param name="year">Year (integer value)</param>
        /// <returns>Returns a dataset containing the loss factor based on utility, 
        /// service class, voltage, month, and year.</returns>
        public static DataSet SelectLossFactor( string utilityCode, string serviceClass,
            string voltage, int month, int year )
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PELossFactorSelect";

                    cmd.Parameters.Add( new SqlParameter( "@UtilityCode", utilityCode ) );
                    cmd.Parameters.Add( new SqlParameter( "@ServiceClass", serviceClass ) );
                    cmd.Parameters.Add( new SqlParameter( "@Voltage", voltage ) );
                    cmd.Parameters.Add( new SqlParameter( "@Month", month ) );
                    cmd.Parameters.Add( new SqlParameter( "@Year", year ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        /// <summary>
        /// Selects the ancillary service price for the specified iso, zone, month, and year.
        /// </summary>
        /// <param name="iso">Iso</param>
        /// <param name="zoneCode">Zone identifier</param>
        /// <param name="beginDate">Begin date of curve</param>
        /// <param name="endDate">End date of curve</param>
        /// <returns>Returns a dataset containing the ancillary service price for the specified 
        /// iso, zone, month, and year.</returns>
        public static DataSet SelectAncillaryServicePrices( string iso, string zoneCode,
            DateTime beginDate, DateTime endDate )
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEAncillaryServicePricesSelect";

                    cmd.Parameters.Add( new SqlParameter( "@Iso", iso ) );
                    cmd.Parameters.Add( new SqlParameter( "@ZoneCode", zoneCode ) );
                    cmd.Parameters.Add( new SqlParameter( "@BeginDate", beginDate ) );
                    cmd.Parameters.Add( new SqlParameter( "@EndDate", endDate ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        /// <summary>
        /// Selects the renewable portfolio standard price for the specified market, month, and year.
        /// </summary>
        /// <param name="marketCode">Market identifier</param>
        /// <param name="beginDate">Begin date of curve</param>
        /// <param name="endDate">End date of curve</param>
        /// <returns>Returns a dataset that contains the renewable portfolio standard prices for the 
        /// specified market and date range.</returns>
        public static DataSet SelectRenewablePortfolioStandardPrices( string marketCode, DateTime beginDate, DateTime endDate )
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PERenewablePortfolioStandardPricesSelect";

                    cmd.Parameters.Add( new SqlParameter( "@Market", marketCode ) );
                    cmd.Parameters.Add( new SqlParameter( "@BeginDate", beginDate ) );
                    cmd.Parameters.Add( new SqlParameter( "@EndDate", endDate ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        /// <summary>
        /// Selects the voluntary renewables prices for the specified plan and date range.
        /// </summary>
        /// <param name="plan">Plan name</param>
        /// <param name="beginDate">Begin date of curve</param>
        /// <param name="endDate">End date of curve</param>
        /// <returns>Returns a dataset that contains the voluntary renewables prices for the 
        /// specified plan and date range.</returns>
        public static DataSet SelectVoluntaryRenewablesPrices( string plan, DateTime beginDate, DateTime endDate )
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEVoluntaryRenewablesPricesSelect";

                    cmd.Parameters.Add( new SqlParameter( "@Plan", plan ) );
                    cmd.Parameters.Add( new SqlParameter( "@BeginDate", beginDate ) );
                    cmd.Parameters.Add( new SqlParameter( "@EndDate", endDate ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        /// <summary>
        /// Selects the U-Cap prices for the specified iso, zone and date range.
        /// </summary>
        /// <param name="iso">Iso</param>
        /// <param name="zoneCode">Zone identifier</param>
        /// <param name="beginDate">Begin date of curve</param>
        /// <param name="endDate">End date of curve</param>
        /// <returns>Returns a dataset containing the U-Cap prices for the specified 
        /// iso, zone and date range.</returns>
        public static DataSet SelectUnforcedCapacityPrices( string iso, string zoneCode, DateTime beginDate, DateTime endDate )
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEUCapPricesSelect";

                    cmd.Parameters.Add( new SqlParameter( "@Iso", iso ) );
                    cmd.Parameters.Add( new SqlParameter( "@ZoneCode", zoneCode ) );
                    cmd.Parameters.Add( new SqlParameter( "@BeginDate", beginDate ) );
                    cmd.Parameters.Add( new SqlParameter( "@EndDate", endDate ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        /// <summary>
        /// Selects the U-Cap factor for the specified iso, zone, month, and year.
        /// </summary>
        /// <param name="iso">Iso</param>
        /// <param name="zoneCode">Zone identifier</param>
        /// <param name="month">Month (integer value)</param>
        /// <param name="year">Year (integer value)</param>
        /// <returns>Returns a dataset containing the U-Cap factor for the specified 
        /// iso, zone, month, and year.</returns>
        public static DataSet SelectUnforcedCapacityFactor( string iso, string zoneCode, int month, int year )
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEUCapFactorSelect";

                    cmd.Parameters.Add( new SqlParameter( "@Iso", iso ) );
                    cmd.Parameters.Add( new SqlParameter( "@ZoneCode", zoneCode ) );
                    cmd.Parameters.Add( new SqlParameter( "@Month", month ) );
                    cmd.Parameters.Add( new SqlParameter( "@Year", year ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        /// <summary>
        /// Selects the U-Cap factors for the specified iso, zone and date range.
        /// </summary>
        /// <param name="iso">Iso</param>
        /// <param name="zoneCode">Zone identifier</param>
        /// <param name="beginDate">Begin date of curve</param>
        /// <param name="endDate">End date of curve</param>
        /// <returns>Returns a dataset containing the U-Cap factors for the specified 
        /// iso, zone and date range.</returns>
        public static DataSet SelectUnforcedCapacityFactors( string iso, string zoneCode, DateTime beginDate, DateTime endDate )
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEUCapFactorsSelect";

                    cmd.Parameters.Add( new SqlParameter( "@Iso", iso ) );
                    cmd.Parameters.Add( new SqlParameter( "@ZoneCode", zoneCode ) );
                    cmd.Parameters.Add( new SqlParameter( "@BeginDate", beginDate ) );
                    cmd.Parameters.Add( new SqlParameter( "@EndDate", endDate ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }



        /// <summary>
        /// Selects the T-Cap price for the specified iso, zone, month, and year.
        /// </summary>
        /// <param name="iso">Iso</param>
        /// <param name="zoneCode">Zone identifier</param>
        /// <param name="month">Month (integer value)</param>
        /// <param name="year">Year (integer value)</param>
        /// <returns>Returns a dataset containing the T-Cap price for the specified 
        /// iso, zone, month, and year.</returns>
        public static DataSet SelectTransmissionCapacityPrice( string iso, string zoneCode, int month, int year )
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PETCapPriceSelect";

                    cmd.Parameters.Add( new SqlParameter( "@Iso", iso ) );
                    cmd.Parameters.Add( new SqlParameter( "@ZoneCode", zoneCode ) );
                    cmd.Parameters.Add( new SqlParameter( "@Month", month ) );
                    cmd.Parameters.Add( new SqlParameter( "@Year", year ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        /// <summary>
        /// Selects the T-Cap factor for the specified iso, zone, month, and year.
        /// </summary>
        /// <param name="iso">Iso</param>
        /// <param name="zoneCode">Zone identifier</param>
        /// <param name="month">Month (integer value)</param>
        /// <param name="year">Year (integer value)</param>
        /// <returns>Returns a dataset containing the T-Cap factor for the specified 
        /// iso, zone, month, and year.</returns>
        public static DataSet SelectTransmissionCapacityFactor( string iso, string zoneCode, int month, int year )
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PETCapFactorSelect";

                    cmd.Parameters.Add( new SqlParameter( "@Iso", iso ) );
                    cmd.Parameters.Add( new SqlParameter( "@ZoneCode", zoneCode ) );
                    cmd.Parameters.Add( new SqlParameter( "@Month", month ) );
                    cmd.Parameters.Add( new SqlParameter( "@Year", year ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        /// <summary>
        /// Selects the auction revenue right price for the specified iso, zone, month, and year.
        /// </summary>
        /// <param name="iso">Iso</param>
        /// <param name="zoneCode">Zone identifier</param>
        /// <param name="beginDate">Begin date of curve</param>
        /// <param name="endDate">End date of curve</param>
        /// <returns>Returns a dataset containing the auction revenue right price for the specified 
        /// iso, zone, month, and year.</returns>
        public static DataSet SelectAuctionRevenueRights( string iso, string zoneCode, DateTime beginDate, DateTime endDate )
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEAuctionRevenueRightsSelect";

                    cmd.Parameters.Add( new SqlParameter( "@Iso", iso ) );
                    cmd.Parameters.Add( new SqlParameter( "@ZoneCode", zoneCode ) );
                    cmd.Parameters.Add( new SqlParameter( "@BeginDate", beginDate ) );
                    cmd.Parameters.Add( new SqlParameter( "@EndDate", endDate ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        /// <summary>
        /// Selects the scheduling fee for the specified month and year.
        /// </summary>
        /// <param name="month">Month (integer value)</param>
        /// <param name="year">Year (integer value)</param>
        /// <returns>Returns a dataset containing the scheduling fee for the specified month and year.</returns>
        public static DataSet SelectSchedulingFee( int month, int year )
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PESchedulingFeeSelect";

                    cmd.Parameters.Add( new SqlParameter( "@Month", month ) );
                    cmd.Parameters.Add( new SqlParameter( "@Year", year ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        /// <summary>
        /// Selects the scheduling fees for date range.
        /// </summary>
        /// <param name="beginDate">Begin date of curve</param>
        /// <param name="endDate">End date of curve</param>
        /// <returns>Returns a dataset containing the scheduling fees for date range.</returns>
        public static DataSet SelectSchedulingFees( DateTime beginDate, DateTime endDate )
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PESchedulingFeesSelect";

                    cmd.Parameters.Add( new SqlParameter( "@BeginDate", beginDate ) );
                    cmd.Parameters.Add( new SqlParameter( "@EndDate", endDate ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        /// <summary>
        /// Selects the energy adder for relative month month range.
        /// </summary>
        /// <param name="relativeMonth">Relative month (integer value)</param>
        /// <returns>Returns a dataset containing the energy adder for relative month range.</returns>
        [Obsolete( "Use Energy Added Select Method Instead" )]
        public static DataSet SelectMarkToMarketEnergyAdders( int relativeMonthBegin, int relativeMonthEnd )
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEMarkToMarketEnergyAddersSelect";

                    cmd.Parameters.Add( new SqlParameter( "@RelativeMonthBegin", relativeMonthBegin ) );
                    cmd.Parameters.Add( new SqlParameter( "@RelativeMonthEnd", relativeMonthEnd ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        /// <summary>
        /// Select billing transaction cost based on billing type.
        /// </summary>
        /// <param name="billingType">Billing type (ex. Supplier Consolidated, Dual Billing,
        /// Rate Ready, Bill Ready</param>
        /// <returns>Returns a dataset containing the billing transaction cost based on billing type.</returns>
        public static DataSet SelectBillingTransactionCost( string billingType )
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEBillingTransactionCostSelect";

                    cmd.Parameters.Add( new SqlParameter( "@BillingType", billingType ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        /// <summary>
        /// Selects finance fee based on market.
        /// </summary>
        /// <param name="market">Market identifier</param>
        /// <returns>Returns a dataset containing the finance fee based on market.</returns>
        public static DataSet SelectFinanceFee( string market )
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEFinanceFeeSelect";

                    cmd.Parameters.Add( new SqlParameter( "@Market", market ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        /// <summary>
        /// Selects peak exposure month based on relative start month and term.
        /// </summary>
        /// <param name="relativeMonth">Relative start month</param>
        /// <param name="term">Term (in months)</param>
        /// <returns>Returns a dataset containing the peak exposure month 
        /// based on relative start month and term.</returns>
        public static DataSet SelectPeakExposureMonth( int relativeMonth, int term )
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEPeakExposureMonthSelect";

                    cmd.Parameters.Add( new SqlParameter( "@RelativeStartMonth", relativeMonth ) );
                    cmd.Parameters.Add( new SqlParameter( "@Term", term ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        /// <summary>
        /// Selects the peak shock factor based on ISO, zone, peak exposure month and remaining term.
        /// </summary>
        /// <param name="iso">ISO identifier</param>
        /// <param name="zoneCode">Zone identifier</param>
        /// <param name="peakExposureMonth">Peak exposure month</param>
        /// <param name="remainingTerm">Remaining term</param>
        /// <returns>Returns a dataset containing the peak shock factor based on ISO, zone, 
        /// peak exposure month and remaining term.</returns>
        public static DataSet SelectPriceShockFactor( string iso, string zoneCode,
            int peakExposureMonth, int remainingTerm )
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEPriceShockFactorSelect";

                    cmd.Parameters.Add( new SqlParameter( "@Iso", iso ) );
                    cmd.Parameters.Add( new SqlParameter( "@ZoneCode", zoneCode ) );
                    cmd.Parameters.Add( new SqlParameter( "@PeakExposureMonth", peakExposureMonth ) );
                    cmd.Parameters.Add( new SqlParameter( "@RemainTerm", remainingTerm ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        /// <summary>
        /// Selects mark-to-market credit reserve factor based on internal credit rating and peak exposure month.
        /// </summary>
        /// <param name="internalCreditRating">Internal credit rating</param>
        /// <param name="peakExposureMonth">Peak exposure month</param>
        /// <returns>Returns a dataset containing the mark-to-market credit reserve factor based on 
        /// internal credit rating and peak exposure month.</returns>
        [Obsolete( "Use Curve's Select method instead" )]
        public static DataSet SelectMarkToMarketCreditReserveFactor( int internalCreditRating, int peakExposureMonth )
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEMarkToMarketCreditReserveFactorSelect";

                    cmd.Parameters.Add( new SqlParameter( "@InternalCreditRating", internalCreditRating ) );
                    cmd.Parameters.Add( new SqlParameter( "@PeakExposureMonth", peakExposureMonth ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        /// <summary>
        /// Selects accounts receivable credit reserve factor based on internal credit rating, 
        /// term and relative start month.
        /// </summary>
        /// <param name="term">Term (in months)</param>
        /// <param name="internalCreditRating">Internal credit rating</param>
        /// <param name="relativeStartMonth">Relative start month</param>
        /// <returns>Returns a dataset containing the accounts receivable credit reserve factor based on 
        /// internal credit rating, term and relative start month.</returns>
        //TODO: Remove this function 
        [Obsolete( "Use PEARCreditReserveFactorSql DAL instead" )]
        public static DataSet SelectAccountsReceivableCreditReserveFactor_86Me( int term,
            int internalCreditRating, int relativeStartMonth )
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEAccountsReceivableCreditReserveFactorSelect";

                    cmd.Parameters.Add( new SqlParameter( "@Term", term ) );
                    cmd.Parameters.Add( new SqlParameter( "@InternalCreditRating", internalCreditRating ) );
                    cmd.Parameters.Add( new SqlParameter( "@RelativeStartMonth", relativeStartMonth ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        /// <summary>
        /// Selects the mark-to-market credit risk policy factor.
        /// </summary>
        /// <returns>Returns a dataset containing the mark-to-market credit risk policy factor.</returns>
        public static DataSet SelectMarkToMarketCreditRiskPolicyFactor()
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEMarkToMarketCreditRiskPolicyFactorSelect";

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        /// <summary>
        /// Selects the accounts receivable credit risk policy factor.
        /// </summary>
        /// <returns>Returns a dataset containing the accounts receivable credit risk policy factor.</returns>
        public static DataSet SelectAccountsReceivableCreditRiskPolicyFactor()
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEAccountsReceivableCreditRiskPolicyFactorSelect";

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        /// <summary>
        /// Selects POR type and rate based on utility.
        /// </summary>
        /// <param name="utilityCode">Utility identifier</param>
        /// <returns>Returns a dataset containing the POR type and rate based on utility.</returns>
        public static DataSet SelectPor( string utilityCode )
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEPorSelect";

                    cmd.Parameters.Add( new SqlParameter( "@UtilityCode", utilityCode ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        /// <summary>
        /// Determines if service class exists.
        /// </summary>
        /// <param name="serviceClass">Service class</param>
        /// <returns>Returns a dataset that determines if service class exists.</returns>
        public static DataSet SelectServiceClass( string serviceClass )
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEServiceClassSelect";

                    cmd.Parameters.Add( new SqlParameter( "@ServiceClass", serviceClass ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        /// <summary>
        /// Selects payment day data (cost payment days, stop delivery days).
        /// </summary>
        /// <param name="utilityCode">Utility identifier</param>
        /// <returns>Returns a dataset that contains the payment day data (cost payment days, stop delivery days).</returns>
        public static DataSet SelectPaymentDayData( string utilityCode )
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEPaymentDaySelect";

                    cmd.Parameters.Add( new SqlParameter( "@UtilityCode", utilityCode ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        /// <summary>
        /// Gets latest report data for Snapshot Report or Baseline Report.
        /// </summary>
        /// <param name="symbol">Ticker symbol</param>
        /// <returns>Returns a dataset containing the latest report data for Snapshot Report or Baseline Report.</returns>
        public static DataSet SelectLatestEnergyTradingMarketCurveReport( string symbol )
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEEnergyTradingMarketCurveReportsLatestSelect";

                    cmd.Parameters.Add( new SqlParameter( "@Symbol", symbol ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        /// <summary>
        /// Gets latest report data for Snapshot Report or Baseline Report after specified date.
        /// </summary>
        /// <param name="symbol">Ticker symbol</param>
        /// <param name="date">Date to pull latest after.</param>
        /// <returns>Returns a dataset containing the latest report data for Snapshot Report or Baseline Report after specified date.</returns>
        public static DataSet SelectLatestEnergyTradingMarketCurveReportAfterDate( string symbol, DateTime date )
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEEnergyTradingMarketCurveReportsLatestAfterDateSelect";

                    cmd.Parameters.Add( new SqlParameter( "@Symbol", symbol ) );
                    cmd.Parameters.Add( new SqlParameter( "@Date", date ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        /// <summary>
        /// Inserts report data for Snapshot Report or Baseline Report.
        /// </summary>
        /// <param name="symbol">Ticker symbol</param>
        /// <param name="lastPrice">Last price</param>
        /// <param name="tradeDate">Trade date and time</param>
        /// <param name="lastPriceType">Last price type (Actual or Filled)</param>
        /// <param name="timeStamp">Timestamp of insert</param>
        /// <returns>Returns a dataset containing the inserted report data for Snapshot Report or Baseline Report.</returns>
        public static DataSet InsertEnergyTradingMarketCurveReport( string symbol, decimal lastPrice,
            DateTime tradeDate, string lastPriceType, DateTime timeStamp )
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEEnergyTradingMarketCurveReportsInsert";

                    cmd.Parameters.Add( new SqlParameter( "@Symbol", symbol ) );
                    cmd.Parameters.Add( new SqlParameter( "@LastPrice", lastPrice ) );
                    cmd.Parameters.Add( new SqlParameter( "@TradeDate", tradeDate ) );
                    cmd.Parameters.Add( new SqlParameter( "@LastPriceType", lastPriceType ) );
                    cmd.Parameters.Add( new SqlParameter( "@TimeStamp", timeStamp ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        /// <summary>
        /// Gets all ticker symbols for specified contract type.
        /// </summary>
        /// <param name="contractType">ProphetX contract type 
        /// (QNG - Snapshot Report Curve, NG - Closing Business Day Report Curve)</param>
        /// <returns>Returns a dataset that contains all ticker symbols for specified contract type.</returns>
        public static DataSet SelectTickerSymbols( string contractType )
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PETickerSymbolsSelect";

                    cmd.Parameters.Add( new SqlParameter( "@ContractType", contractType ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        /// <summary>
        /// Retrieves prices and associated data from ProphetX web service for symbols passed in.
        /// </summary>
        /// <param name="webServiceUrl">ProphetX web service URL</param>
        /// <param name="userId">User ID for ProphetX web service</param>
        /// <param name="password">Password for for ProphetX web service (can be empty string)</param>
        /// <param name="Id">ID for for ProphetX web service (can be empty string)</param>
        /// <param name="requestType">ProphetX web service request type; Full(or F) to return the standard full 
        /// set of FIDs or Short(or S) to return a smaller set of FIDs normally used for refreshes. 
        /// A comma seperated FID (numeric) list is also supported. Any other parameter returns every FID.</param>
        /// <param name="symbols">Comma delimited ticker symbols</param>
        /// <returns>Returns a dataset containing the prices and associated data from ProphetX web service for symbols passed in.</returns>
        public static DataSet GetProphetXQuotes( string webServiceUrl, string userId, string password, string Id, string requestType, string symbols )
        {
            string format = "{0}userID={1}&Password={2}&ID={3}&Type={4}&Symbol={5}";
            DataSet ds = new DataSet();

            HttpWebRequest request = WebRequest.Create( String.Format( format, webServiceUrl, userId, password, Id, requestType, symbols ) ) as HttpWebRequest;
            using( HttpWebResponse response = request.GetResponse() as HttpWebResponse )
                ds.ReadXml( response.GetResponseStream() );

            return ds;
        }

        /// <summary>
        /// Gets the execution risk time window.
        /// </summary>
        /// <returns>Returns a dataset containing the execution risk time window.</returns>
        public static DataSet SelectExecutionRiskTimeWindow()
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEExecutionRiskTimeWindowSelect";

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        /// <summary>
        /// Gets the execution risk size factor.
        /// </summary>
        /// <param name="annualizedUsage">Annualized usage</param>
        /// <returns>Returns a dataset containing the execution risk size factor.</returns>
        [Obsolete( "Use Curve Select method instead" )]
        public static DataSet SelectExecutionRiskSizeFactor( int annualizedUsage )
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEExecutionRiskSizeFactorSelect";

                    cmd.Parameters.Add( new SqlParameter( "@AnnualizedUsage", annualizedUsage ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        /// <summary>
        /// Gets intraday hourly price differences based on execution risk time window and intraday volatility.
        /// </summary>
        /// <param name="intradayVolatility">Intraday volatility (low, medium, high)</param>
        /// <param name="startDate">Beginning of date range (calculated based on execution risk time window)</param>
        /// <param name="endDate">End of date range</param>
        /// <returns>Returns a dataset containing the intraday hourly price differences based on 
        /// start and end date with execution risk time window factored into dates and intraday volatility.</returns>
        public static DataSet SelectIntradayHourlyPriceDifference( string intradayVolatility, DateTime startDate, DateTime endDate )
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEIntradayHourlyPriceDifferenceSelect";

                    cmd.Parameters.Add( new SqlParameter( "@IntradayVolatility", intradayVolatility ) );
                    cmd.Parameters.Add( new SqlParameter( "@StartDate", startDate ) );
                    cmd.Parameters.Add( new SqlParameter( "@EndDate", endDate ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        /// <summary>
        /// Gets other pricing components for specified contract.
        /// </summary>
        /// <param name="TermsAndPricesID">Terms and Prices (Term x FlowStartDate) identifier</param>
        /// <returns>Returns a dataset containing other pricing components for specified contract.</returns>
        public static DataSet SelectOtherPricingComponentsByContract( string termAndPricesID )
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEOtherPricingComponentsByContractSelect";

                    cmd.Parameters.Add( new SqlParameter( "@TERMS_AND_PRICES_ID", termAndPricesID ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        public static DataSet InsertPricingContract( string offerId, DateTime flowStartDate, int term, string grouping )
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEPricingContractInsert";

                    cmd.Parameters.Add( new SqlParameter( "@OfferID", offerId ) );
                    cmd.Parameters.Add( new SqlParameter( "@FlowStartDate", flowStartDate ) );
                    cmd.Parameters.Add( new SqlParameter( "@Term", term ) );
                    cmd.Parameters.Add( new SqlParameter( "@Grouping", grouping ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        /// <summary>
        /// Gets embedded tax for specified market
        /// </summary>
        /// <param name="retailMarketCode">Market identifier</param>
        /// <returns>Returns a dataset containing the embedded tax for specified market.</returns>
        [Obsolete( "Use the Curve's Select DAL instead" )]
        public static DataSet SelectEmbeddedTax( string retailMarketCode )
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEEmbeddedTaxSelect";

                    cmd.Parameters.Add( new SqlParameter( "@RetailMarketCode", retailMarketCode ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        /// <summary>
        /// Inserts a new record in the PEOtherPricingComponents Table
        /// </summary>
        /// <param name="termAndPriceId">Term x FlowStartDate (Contract Id)</param>
        /// <param name="description">Other Pricing Component Description</param>
        /// <param name="unit">Unit</param>
        /// <param name="price">Price in dollars</param>
        /// <param name="comment">Addicional comment</param>
        /// <returns>Identity id</returns>
        public static int InsertOtherPricingComponents( string termAndPriceId, string description, string unit, decimal price, string comment )
        {
            DataSet ds = new DataSet();
            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEOtherPricingComponentsInsert";

                    cmd.Parameters.Add( new SqlParameter( "@Terms_and_prices_id", termAndPriceId ) );
                    cmd.Parameters.Add( new SqlParameter( "@DollarAmount", price ) );
                    cmd.Parameters.Add( new SqlParameter( "@Unit", unit ) );
                    cmd.Parameters.Add( new SqlParameter( "@CostDescription", description ) );
                    cmd.Parameters.Add( new SqlParameter( "@Comment", comment ) );
                    conn.Open();
                    return Convert.ToInt32( cmd.ExecuteScalar() );

                }
            }
        }

        /// <summary>
        /// Deletes a record from PEOtherPricingComponents Table
        /// </summary>
        /// <param name="id">Id (identity)</param>
        public static void DeleteOtherPricingComponent( int id )
        {
            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEOtherPricingComponentsDelete";
                    cmd.Parameters.Add( new SqlParameter( "@id", id ) );
                    conn.Open();
                    cmd.ExecuteNonQuery();
                    conn.Close();
                }
            }
        }

        /// <summary>
        /// Selects all other pricing components descriptions
        /// </summary>
        /// <returns>Dataset</returns>
        public static DataSet SelectOtherPricingComponentsDescriptions()
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEOtherPricingComponentsDescriptionSelectList";

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

    }
}
