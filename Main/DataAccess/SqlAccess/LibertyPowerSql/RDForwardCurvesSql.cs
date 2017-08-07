using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{

    public class RDForwardCurvesSql
    {
        #region Block Energy

        /// <summary>
        /// Inserts a BlockEnergyCurve
        /// </summary>
        /// <param name=BlockEnergyCurve></param>
        public static int InsertBlockEnergyCurve( Guid fileContextGuid, DateTime marketTradeDate, DateTime curveDate, decimal price, string curveName, int createdBy )
        {
            DataSet ds = new DataSet();
            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEBlockEnergyCurveInsert";
                    cmd.Parameters.Add( new SqlParameter( "@FileContextGuid", fileContextGuid ) );
                    cmd.Parameters.Add( new SqlParameter( "@MarketTradeDate", marketTradeDate ) );
                    cmd.Parameters.Add( new SqlParameter( "@CurveDate", curveDate ) );
                    cmd.Parameters.Add( new SqlParameter( "@Price", price ) );
                    cmd.Parameters.Add( new SqlParameter( "@CurveName", curveName ) );
                    cmd.Parameters.Add( new SqlParameter( "@CreatedBy", createdBy ) );
                    conn.Open();
                    return Convert.ToInt32( cmd.ExecuteScalar() );
                }
            }
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
        public static DataSet SelectBlockEnergyCurve( Guid? fileContextGuid, string iso, string zoneCode, DateTime beginDate, DateTime endDate, string curveType, bool? filterOldRecords )
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEBlockEnergyCurveSelect";

                    cmd.Parameters.Add( new SqlParameter( "@Iso", iso ) );
                    cmd.Parameters.Add( new SqlParameter( "@ZoneCode", zoneCode ) );
                    cmd.Parameters.Add( new SqlParameter( "@BeginDate", beginDate ) );
                    cmd.Parameters.Add( new SqlParameter( "@EndDate", endDate ) );
                    cmd.Parameters.Add( new SqlParameter( "@CurveType", curveType ) );
                    cmd.Parameters.Add( new SqlParameter( "@FileContextGuid", fileContextGuid ) );
                    cmd.Parameters.Add( new SqlParameter( "@FilterOldRecords", filterOldRecords ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        #endregion Block Energy

        #region Embeded Tax Rate Curve File

        /// <summary>
        /// Gets embedded tax rates
        /// </summary>
        /// <param name="fileContextGuid">When specified only records pertaining to this file will be retreived</param>
        /// <param name="retailMarketCode">Market identifier</param>
        /// <param name="filterOldRecords">If true Brings back only the most current records</param>
        /// <returns></returns>
        public static DataSet SelectEmbeddedTaxRates( Guid? fileContextGuid, string retailMarketCode, bool? filterOldRecords )
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEEmbeddedTaxRateCurveSelect";

                    cmd.Parameters.Add( new SqlParameter( "@RetailMarketCode", retailMarketCode ) );
                    cmd.Parameters.Add( new SqlParameter( "@FileContextGuid", fileContextGuid ) );
                    cmd.Parameters.Add( new SqlParameter( "@FilterOldRecords", filterOldRecords ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        /// <summary>
        /// Inserts a EmbeddedTaxRateCurve
        /// </summary>
        /// <param name=EmbeddedTaxRateCurve></param>
        public static int InsertEmbeddedTaxRateCurve( Guid fileContextGuid, string market, decimal rate, int createdBy )
        {
            DataSet ds = new DataSet();
            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEEmbeddedTaxRateCurveInsert";
                    cmd.Parameters.Add( new SqlParameter( "@FileContextGuid", fileContextGuid ) );
                    cmd.Parameters.Add( new SqlParameter( "@Market", market ) );
                    cmd.Parameters.Add( new SqlParameter( "@Rate", rate ) );
                    cmd.Parameters.Add( new SqlParameter( "@CreatedBy", createdBy ) );
                    conn.Open();
                    return Convert.ToInt32( cmd.ExecuteScalar() );
                }
            }
        }


        #endregion Embeded Tax Rate Curve File

        #region AR Credit Reserve Factor

        public static DataSet SelectARCreditReserveFactorCurve( Guid? fileContextGuid, int? term, int? internalCreditRating, int? relativeStartMonth, bool? filterOldRecords )
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEARCreditReserveFactorCurveSelect";

                    cmd.Parameters.Add( new SqlParameter( "@Term", term ) );
                    cmd.Parameters.Add( new SqlParameter( "@InternalCreditRating", internalCreditRating ) );
                    cmd.Parameters.Add( new SqlParameter( "@FileContextGuid", fileContextGuid ) );
                    cmd.Parameters.Add( new SqlParameter( "@FilterOldRecords", filterOldRecords ) );
                    cmd.Parameters.Add( new SqlParameter( "@RelativeStartMonth", relativeStartMonth ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }


        /// <summary>
        /// Gets a list of all internal credit rating values.
        /// </summary>
        /// <returns></returns>
        
        public static DataSet SelectARCreditReserveInternalCreditRating()
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEARCreditReserveInternalCreditRatingSelect";

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }


        /// <summary>
        /// Inserts a CreditReserveFactorCurve
        /// </summary>
        /// <param name=CreditReserveFactorCurve></param>
        public static int InsertARCreditReserveFactorCurve( Guid fileContextGuid, int internalCreditRating, int relativeStartMonth, int term, decimal arCreditReserveFactor, int createdBy )
        {
            DataSet ds = new DataSet();
            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEARCreditReserveFactorCurveInsert";

                    cmd.Parameters.Add( new SqlParameter( "@FileContextGuid", fileContextGuid ) );
                    cmd.Parameters.Add( new SqlParameter( "@InternalCreditRating", internalCreditRating ) );
                    cmd.Parameters.Add( new SqlParameter( "@RelativeStartMonth", relativeStartMonth ) );
                    cmd.Parameters.Add( new SqlParameter( "@Term", term ) );
                    cmd.Parameters.Add( new SqlParameter( "@ArCreditReserveFactor", arCreditReserveFactor ) );
                    cmd.Parameters.Add( new SqlParameter( "@CreatedBy", createdBy ) );

                    conn.Open();
                    return Convert.ToInt32( cmd.ExecuteScalar() );
                }
            }
        }



        #endregion AR Credit Reserve Factor

        #region Daily Profile

        /// <summary>
        /// Selects daily profiles based on utility, load shape id, zone, and date range.
        /// </summary>
        /// <param name="iso">ISO identifier</param>
        /// <param name="loadShapeId">Load shape identifier</param>
        /// <param name="zoneCode">Zone identifier</param>
        /// <param name="beginDate">Begin date</param>
        /// <param name="endDate">End Date</param>
        /// <returns>Returns a dataset containing daily profile based on utility, load shape id, zone, and date range.</returns>
        public static DataSet SelectDailyProfileCurve( Guid? fileContextGuid, string iso, string zoneCode, string loadShapeId, DateTime beginDate, DateTime endDate, bool? filterOldRecords )
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
                    cmd.Parameters.Add( new SqlParameter( "@FileContextGuid", fileContextGuid ) );
                    cmd.Parameters.Add( new SqlParameter( "@FilterOldRecords", filterOldRecords ) );
                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        /// <summary>
        /// Inserts a DailyProfileCurve
        /// </summary>
        /// <param name=DailyProfileCurve></param>
        public static int InsertDailyProfileCurve( Guid fileContextGuid, string utilityCode, string loadShapeId, string zoneId, DateTime date, decimal dailyProfileValue, decimal peakPercentage, decimal peakDemandFactor, int createdBy )
        {
            DataSet ds = new DataSet();
            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEDailyProfileCurveInsert";
                    cmd.Parameters.Add( new SqlParameter( "@FileContextGuid", fileContextGuid ) );
                    cmd.Parameters.Add( new SqlParameter( "@UtilityCode", utilityCode ) );
                    cmd.Parameters.Add( new SqlParameter( "@LoadShapeId", loadShapeId ) );
                    cmd.Parameters.Add( new SqlParameter( "@ZoneId", zoneId ) );
                    cmd.Parameters.Add( new SqlParameter( "@Date", date ) );
                    cmd.Parameters.Add( new SqlParameter( "@DailyProfileValue", dailyProfileValue ) );
                    cmd.Parameters.Add( new SqlParameter( "@PeakPercentage", peakPercentage ) );
                    cmd.Parameters.Add( new SqlParameter( "@PeakDemandFactor", peakDemandFactor ) );
                    cmd.Parameters.Add( new SqlParameter( "@CreatedBy", createdBy ) );
                    conn.Open();
                    return Convert.ToInt32( cmd.ExecuteScalar() );
                }
            }
        }


        #endregion Daily Profile

        #region Default Markup
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
        /// <returns>Returns a dataset containing the default markup based on market, utility, zone, pricing type, product type, term and annualized usage in Mwh.</returns>
        public static DataSet SelectDefaultMarkup( string market, string utilityCode, string zoneCode, string pricingType, string productType, int? term,
                                                   int? relativeStartMonth, decimal? mwh, Guid? fileContextGuid, bool? filterOldRecords )
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEDefaultMarkupCurveSelect";

                    cmd.Parameters.Add( new SqlParameter( "@Market", market ) );
                    cmd.Parameters.Add( new SqlParameter( "@UtilityCode", utilityCode ) );
                    cmd.Parameters.Add( new SqlParameter( "@ZoneCode", zoneCode ) );
                    cmd.Parameters.Add( new SqlParameter( "@PricingType", pricingType ) );
                    cmd.Parameters.Add( new SqlParameter( "@ProductType", productType ) );
                    cmd.Parameters.Add( new SqlParameter( "@Term", term ) );
                    cmd.Parameters.Add( new SqlParameter( "@RelativeStartMonth", relativeStartMonth ) );
                    cmd.Parameters.Add( new SqlParameter( "@Mwh", mwh ) );
                    cmd.Parameters.Add( new SqlParameter( "@FileContextGuid", fileContextGuid ) );
                    cmd.Parameters.Add( new SqlParameter( "@FilterOldRecords", filterOldRecords ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        /// <summary>
        /// Inserts a DefaultMarkupCurve
        /// </summary>
        /// <param name=DefaultMarkupCurve></param>
        public static int InsertDefaultMarkupCurve( Guid filecontextGuid, string market, string utilityCode, string zoneId, string pricingType, int minSize, int maxSize, int minRelativeStartMonth, int maxRelativeStartMonth, string productType, int minterm, int maxTerm, decimal markup, int createdBy )
        {
            DataSet ds = new DataSet();
            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEDefaultMarkupCurveInsert";

                    cmd.Parameters.Add( new SqlParameter( "@FileContextGuid", filecontextGuid ) );
                    cmd.Parameters.Add( new SqlParameter( "@Market", market ) );
                    cmd.Parameters.Add( new SqlParameter( "@Utility", utilityCode ) );
                    cmd.Parameters.Add( new SqlParameter( "@Zone", zoneId ) );
                    cmd.Parameters.Add( new SqlParameter( "@PricingType", pricingType ) );
                    cmd.Parameters.Add( new SqlParameter( "@MinSize", minSize ) );
                    cmd.Parameters.Add( new SqlParameter( "@MaxSize", maxSize ) );
                    cmd.Parameters.Add( new SqlParameter( "@MinRelativeStartMonth", minRelativeStartMonth ) );
                    cmd.Parameters.Add( new SqlParameter( "@MaxRelativeStartMonth", maxRelativeStartMonth ) );
                    cmd.Parameters.Add( new SqlParameter( "@ProductType", productType ) );
                    cmd.Parameters.Add( new SqlParameter( "@Minterm", minterm ) );
                    cmd.Parameters.Add( new SqlParameter( "@MaxTerm", maxTerm ) );
                    cmd.Parameters.Add( new SqlParameter( "@Markup", markup ) );
                    cmd.Parameters.Add( new SqlParameter( "@CreatedBy", createdBy ) );

                    conn.Open();
                    return Convert.ToInt32( cmd.ExecuteScalar() );
                }
            }
        }

        /// <summary>
        /// Gets all pricing type values.
        /// </summary>
        /// <returns></returns>
        [Obsolete( "Use SelectDefaultMarkup and add some filters to get this, this query has duplicate results" )]
        public static DataSet GetAllPricingTypes()
        {
            DataSet ds = new DataSet();
            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEDefaultMarkupPricingTypeSelect";

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                    {
                        da.Fill( ds );
                    }
                }
            }
            return ds;
        }

        #endregion Default Markup

        #region Mark to Market Credit Reserve Factor
        /// <summary>
        /// Selects mark-to-market credit reserve factor based on internal credit rating and peak exposure month.
        /// </summary>
        /// <param name="internalCreditRating">Internal credit rating</param>
        /// <param name="peakExposureMonth">Peak exposure month</param>
        /// <returns>Returns a dataset containing the mark-to-market credit reserve factor based on internal credit rating and peak exposure month.</returns>
        public static DataSet SelectMarkToMarketCreditReserveFactorCurve( Guid? fileContextGuid, int? internalCreditRating, int? peakExposureMonth, bool? filterOldRecords )
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEMarkToMarketCreditReserveFactorCurveSelect";

                    cmd.Parameters.Add( new SqlParameter( "@InternalCreditRating", internalCreditRating ) );
                    cmd.Parameters.Add( new SqlParameter( "@PeakExposureMonth", peakExposureMonth ) );
                    cmd.Parameters.Add( new SqlParameter( "@FileContextGuid", fileContextGuid ) );
                    cmd.Parameters.Add( new SqlParameter( "@FilterOldRecords", filterOldRecords ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        /// <summary>
        /// Inserts a MarkToMarketCreditReserveFactorCurve
        /// </summary>
        /// <param name=MarkToMarketCreditReserveFactorCurve></param>
        public static int InsertMarkToMarketCreditReserveFactorCurve( Guid fileContextGuid, int internalCreditRating, int peakExposureMonth, decimal creditReserveFactor, int createdBy )
        {
            DataSet ds = new DataSet();
            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEMarkToMarketCreditReserveFactorCurveInsert";

                    cmd.Parameters.Add( new SqlParameter( "@FileContextGuid", fileContextGuid ) );
                    cmd.Parameters.Add( new SqlParameter( "@InternalCreditRating", internalCreditRating ) );
                    cmd.Parameters.Add( new SqlParameter( "@PeakExposureMonth", peakExposureMonth ) );
                    cmd.Parameters.Add( new SqlParameter( "@CreditReserveFactor", creditReserveFactor ) );
                    cmd.Parameters.Add( new SqlParameter( "@CreatedBy", createdBy ) );

                    conn.Open();
                    return Convert.ToInt32( cmd.ExecuteScalar() );

                }
            }
        }

        #endregion Mark to Market Credit Reserve Factor

        #region Mark to Market Price Shock
        /// <summary>
        /// Selects the peak shock factor based on ISO, zone, peak exposure month and remaining term.
        /// </summary>
        /// <param name="iso">ISO identifier</param>
        /// <param name="zoneCode">Zone identifier</param>
        /// <param name="peakExposureMonth">Peak exposure month</param>
        /// <param name="remainingTerm">Remaining term</param>
        /// <returns>Returns a dataset containing the peak shock factor based on ISO, zone, peak exposure month and remaining term.</returns>
        public static DataSet SelectPriceShockFactorCurve( Guid? fileContextGuid, string iso, string zoneCode, int? peakExposureMonth, int? remainingTerm, bool? filterOldRecords )
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEMarkToMarketPriceShockCurveSelect";
                    cmd.Parameters.Add( new SqlParameter( "@Iso", iso ) );
                    cmd.Parameters.Add( new SqlParameter( "@ZoneCode", zoneCode ) );
                    cmd.Parameters.Add( new SqlParameter( "@PeakExposureMonth", peakExposureMonth ) );
                    cmd.Parameters.Add( new SqlParameter( "@RemainTerm", remainingTerm ) );
                    cmd.Parameters.Add( new SqlParameter( "@FileContextGuid", fileContextGuid ) );
                    cmd.Parameters.Add( new SqlParameter( "@FilterOldRecords", filterOldRecords ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        /// <summary>
        /// Inserts a MarkToMarketPriceShockCurve
        /// </summary>
        /// <param name=MarkToMarketPriceShockCurve></param>
        public static int InsertMarkToMarketPriceShockCurve( Guid fileContextGuid, string zoneId, int peakExposureMonth, int remainTerm, decimal priceShockFactor, int createdBy )
        {
            DataSet ds = new DataSet();
            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEMarkToMarketPriceShockCurveInsert";

                    cmd.Parameters.Add( new SqlParameter( "@FileContextGuid", fileContextGuid ) );
                    cmd.Parameters.Add( new SqlParameter( "@ZoneId", zoneId ) );
                    cmd.Parameters.Add( new SqlParameter( "@PeakExposureMonth", peakExposureMonth ) );
                    cmd.Parameters.Add( new SqlParameter( "@RemainTerm", remainTerm ) );
                    cmd.Parameters.Add( new SqlParameter( "@PriceShockFactor", priceShockFactor ) );
                    cmd.Parameters.Add( new SqlParameter( "@CreatedBy", createdBy ) );

                    conn.Open();
                    return Convert.ToInt32( cmd.ExecuteScalar() );
                }
            }
        }


        #endregion

        #region Mark to Market Energy Adder
        /// <summary>
        /// Selects the energy adder for relative month month range.
        /// </summary>
        /// <param name="relativeMonthBegin">Relative begin month (integer value)</param>
        /// <param name="relativeMonthEnd">Relative end month (integer value)</param>
        /// <returns>Returns a dataset containing the energy adder for relative month range.</returns>
        public static DataSet SelectMarkToMarketEnergyAdderCurve( Guid? fileContextGuid, int relativeMonthBegin, int relativeMonthEnd, bool? filterOldRecords )
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEMarkToMarketEnergyAdderCurveSelect";

                    cmd.Parameters.Add( new SqlParameter( "@RelativeMonthBegin", relativeMonthBegin ) );
                    cmd.Parameters.Add( new SqlParameter( "@RelativeMonthEnd", relativeMonthEnd ) );
                    cmd.Parameters.Add( new SqlParameter( "@FileContextGuid", fileContextGuid ) );
                    cmd.Parameters.Add( new SqlParameter( "@FilterOldRecords", filterOldRecords ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        /// <summary>
        /// Inserts a MarkToMarketEnergyAdderCurve
        /// </summary>
        /// <param name=MarkToMarketEnergyAdderCurve></param>
        public static int InsertMarkToMarketEnergyAdderCurve( Guid fileContextGuid, int relativeMonth, decimal adder, int createdBy )
        {
            DataSet ds = new DataSet();
            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEMarkToMarketEnergyAdderCurveInsert";
                    cmd.Parameters.Add( new SqlParameter( "@FileContextGuid", fileContextGuid ) );
                    cmd.Parameters.Add( new SqlParameter( "@RelativeMonth", relativeMonth ) );
                    cmd.Parameters.Add( new SqlParameter( "@Adder", adder ) );
                    cmd.Parameters.Add( new SqlParameter( "@CreatedBy", createdBy ) );

                    conn.Open();
                    return Convert.ToInt32( cmd.ExecuteScalar() );

                }
            }
        }

        #endregion

        #region Mark to Market Exposure / PeakExposure Month

        /// <summary>
        /// Selects peak exposure month based on relative start month and term.
        /// </summary>
        /// <param name="relativeMonth">Relative start month</param>
        /// <param name="term">Term (in months)</param>
        /// <returns>Returns a dataset containing the peak exposure month based on relative start month and term.</returns>
        public static DataSet SelectPeakExposureMonthCurve( Guid? fileContextGuid, int? relativeMonth, int? term, bool? filterOldRecords )
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEPeakExposureMonthSelect";

                    cmd.Parameters.Add( new SqlParameter( "@FileContextGuid", fileContextGuid ) );
                    cmd.Parameters.Add( new SqlParameter( "@FilterOldRecords", filterOldRecords ) );
                    cmd.Parameters.Add( new SqlParameter( "@RelativeStartMonth", relativeMonth ) );
                    cmd.Parameters.Add( new SqlParameter( "@Term", term ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        /// <summary>
        /// Inserts a PeakExposureMonthCurve
        /// </summary>
        /// <param name=PeakExposureMonthCurve></param>
        public static int InsertPeakExposureMonthCurve( Guid fileContextGuid, int relativeStartMonth, int term, int peakExposureMonth, int createdBy )
        {
            DataSet ds = new DataSet();
            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEPeakExposureMonthCurveInsert";
                    cmd.Parameters.Add( new SqlParameter( "@FileContextGuid", fileContextGuid ) );
                    cmd.Parameters.Add( new SqlParameter( "@RelativeStartMonth", relativeStartMonth ) );
                    cmd.Parameters.Add( new SqlParameter( "@Term", term ) );
                    cmd.Parameters.Add( new SqlParameter( "@PeakExposureMonth", peakExposureMonth ) );
                    cmd.Parameters.Add( new SqlParameter( "@CreatedBy", createdBy ) );

                    conn.Open();
                    return Convert.ToInt32( cmd.ExecuteScalar() );

                }
            }
        }


        #endregion

        #region Payment Day
        /// <summary>
        /// Gets Payment days data
        /// </summary>
        /// <param name="fileContextGuid">When specified only records pertaining to this file will be retreived</param>
        /// <param name="utilityCode">When not null will get records exclusively for that utility code</param>
        /// <param name="filterOldRecords">If true Brings back only the most current records</param>
        /// <returns></returns>
        public static DataSet SelectPaymentDayCurve( Guid? fileContextGuid, string utilityCode, bool? filterOldRecords )
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEPaymentDayCurveSelect";

                    cmd.Parameters.Add( new SqlParameter( "@UtilityCode", utilityCode ) );
                    cmd.Parameters.Add( new SqlParameter( "@FileContextGuid", fileContextGuid ) );
                    cmd.Parameters.Add( new SqlParameter( "@FilterOldRecords", filterOldRecords ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        /// <summary>
        /// Inserts a PaymentDayCurve
        /// </summary>
        /// <param name=PaymentDayCurve></param>
        public static int InsertPaymentDayCurve( Guid fileContextGuid, string utilityCode, int costPaymentDays, int stopDeliveryDays, int createdBy )
        {
            DataSet ds = new DataSet();
            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEPaymentDayCurveInsert";

                    cmd.Parameters.Add( new SqlParameter( "@FileContextGuid", fileContextGuid ) );
                    cmd.Parameters.Add( new SqlParameter( "@UtilityCode", utilityCode ) );
                    cmd.Parameters.Add( new SqlParameter( "@CostPaymentDays", costPaymentDays ) );
                    cmd.Parameters.Add( new SqlParameter( "@StopDeliveryDays", stopDeliveryDays ) );
                    cmd.Parameters.Add( new SqlParameter( "@CreatedBy", createdBy ) );

                    conn.Open();
                    return Convert.ToInt32( cmd.ExecuteScalar() );

                }
            }
        }


        #endregion Payment Day

        #region Peak and Off-Peak Hour

        /// <summary>
        /// Selects  Peak And Off Peak Hour Curve
        /// </summary>
        /// <param name="iso"></param>
        /// <returns></returns>
        public static DataSet SelectPeakAndOffPeakHourCurve( Guid? fileContextGuid, string iso, DateTime? beginDate, DateTime? endDate, bool? filterOldRecords )
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEPeakAndOffPeakHourCurveSelect";

                    cmd.Parameters.Add( new SqlParameter( "@FileContextGuid", fileContextGuid ) );
                    cmd.Parameters.Add( new SqlParameter( "@Iso", iso ) );
                    cmd.Parameters.Add( new SqlParameter( "@BeginDate", beginDate ) );
                    cmd.Parameters.Add( new SqlParameter( "@EndDate", endDate ) );
                    cmd.Parameters.Add( new SqlParameter( "@FilterOldRecords", filterOldRecords ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        /// <summary>
        /// Inserts a PeakAndOffPeakHourCurve
        /// </summary>
        /// <param name=PeakAndOffPeakHourCurve></param>
        public static int InsertPeakAndOffPeakHourCurve( Guid fileContextGuid, string iso, int month, int year, int peakHour, int offPeakHour, int createdBy )
        {
            DataSet ds = new DataSet();
            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEPeakAndOffPeakHourCurveInsert";

                    cmd.Parameters.Add( new SqlParameter( "@FileContextGuid", fileContextGuid ) );
                    cmd.Parameters.Add( new SqlParameter( "@Iso", iso ) );
                    cmd.Parameters.Add( new SqlParameter( "@Month", month ) );
                    cmd.Parameters.Add( new SqlParameter( "@Year", year ) );
                    cmd.Parameters.Add( new SqlParameter( "@PeakHour", peakHour ) );
                    cmd.Parameters.Add( new SqlParameter( "@OffPeakHour", offPeakHour ) );
                    cmd.Parameters.Add( new SqlParameter( "@CreatedBy", createdBy ) );

                    conn.Open();
                    return Convert.ToInt32( cmd.ExecuteScalar() );

                }
            }
        }

        #endregion Peak and Off-Peak Hour

        #region Scheduling Fee

        /// <summary>
        /// Selects a SchedulingFeeCurve
        /// </summary>
        /// <param name=SchedulingFeeCurveId></param>
        /// <returns>A dataset with all attributes</returns>
        public static DataSet SelectSchedulingFeeCurve( Guid? fileContextGuid, DateTime beginDate, DateTime endDate, bool? filterOldRecords )
        {
            DataSet ds = new DataSet();
            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PESchedulingFeeCurveSelect";

                    cmd.Parameters.Add( new SqlParameter( "@BeginDate", beginDate ) );
                    cmd.Parameters.Add( new SqlParameter( "@EndDate", endDate ) );
                    cmd.Parameters.Add( new SqlParameter( "@FileContextGuid", fileContextGuid ) );
                    cmd.Parameters.Add( new SqlParameter( "@FilterOldRecords", filterOldRecords ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                    {
                        da.Fill( ds );
                    }
                }
            }
            return ds;
        }

        /// <summary>
        /// Inserts a SchedulingFeeCurve
        /// </summary>
        /// <param name=SchedulingFeeCurve></param>
        public static int InsertSchedulingFeeCurve( Guid fileContextGuid, int month, int year, decimal fee, int createdBy )
        {
            DataSet ds = new DataSet();
            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PESchedulingFeeCurveInsert";
                    cmd.Parameters.Add( new SqlParameter( "@FileContextGuid", fileContextGuid ) );
                    cmd.Parameters.Add( new SqlParameter( "@Month", month ) );
                    cmd.Parameters.Add( new SqlParameter( "@Year", year ) );
                    cmd.Parameters.Add( new SqlParameter( "@Fee", fee ) );
                    cmd.Parameters.Add( new SqlParameter( "@CreatedBy", createdBy ) );

                    conn.Open();
                    return Convert.ToInt32( cmd.ExecuteScalar() );

                }
            }
        }



        #endregion Scheduling Fee

        #region Shaping Factor


        /// <summary>
        /// Selects shaping premium factors based on iso, load shape id, zone, beginDate and endDate
        /// </summary>
        /// <param name="iso">ISO identifier</param>
        /// <param name="zoneCode">Zone identifier</param>
        /// <param name="loadShapeId">Load shape ID</param>
        /// <param name="beginDate">Begin date of curve</param>
        /// <param name="endDate">End date of curve</param>
        /// <returns>Returns a dataset containing shaping premium factors based on iso, load shape id, zone, beginDate and endDate.</returns>
        public static DataSet SelectShapingFactorCurve( Guid? fileContextGuid, string iso, string zoneCode, string loadShapeId, DateTime? beginDate, DateTime? endDate, bool? filterOldRecords )
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEShapingFactorCurveSelect";

                    cmd.Parameters.Add( new SqlParameter( "@Iso", iso ) );
                    cmd.Parameters.Add( new SqlParameter( "@ZoneCode", zoneCode ) );
                    cmd.Parameters.Add( new SqlParameter( "@LoadShapeId", loadShapeId ) );
                    cmd.Parameters.Add( new SqlParameter( "@BeginDate", beginDate ) );
                    cmd.Parameters.Add( new SqlParameter( "@EndDate", endDate ) );
                    cmd.Parameters.Add( new SqlParameter( "@FileContextGuid", fileContextGuid ) );
                    cmd.Parameters.Add( new SqlParameter( "@FilterOldRecords", filterOldRecords ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        /// <summary>
        /// Inserts a ShapingFactorCurve
        /// </summary>
        /// <param name=ShapingFactorCurve></param>
        public static int InsertShapingFactorCurve( Guid fileContextGuid, String loadShapeId, String zoneId, Int32 month, Int32 year, Decimal peakFactor, Decimal offPeakFactor, int createdBy )
        {
            DataSet ds = new DataSet();
            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEShapingFactorCurveInsert";

                    cmd.Parameters.Add( new SqlParameter( "@FileContextGuid", fileContextGuid ) );
                    cmd.Parameters.Add( new SqlParameter( "@LoadShapeId", loadShapeId ) );
                    cmd.Parameters.Add( new SqlParameter( "@ZoneId", zoneId ) );
                    cmd.Parameters.Add( new SqlParameter( "@Month", month ) );
                    cmd.Parameters.Add( new SqlParameter( "@Year", year ) );
                    cmd.Parameters.Add( new SqlParameter( "@PeakFactor", peakFactor ) );
                    cmd.Parameters.Add( new SqlParameter( "@OffPeakFactor", offPeakFactor ) );
                    cmd.Parameters.Add( new SqlParameter( "@CreatedBy", createdBy ) );

                    conn.Open();
                    return Convert.ToInt32( cmd.ExecuteScalar() );

                }
            }
        }


        #endregion Shaping Factor

        #region Supplier Premium Factor

        /// <summary>
        /// Selects supplier premium factors based on ISO, zone, curve date and curve type.
        /// </summary>
        /// <param name="iso">ISO identifier</param>
        /// <param name="zoneCode">Zone identifier</param>
        /// <param name="beginDate">Begin date of curve</param>
        /// <param name="endDate">End date of curve</param>
        /// <param name="curveType">Type of curve (peak, off-peak)</param>
        /// <returns>Returns a dataset containing supplier premium factors based on ISO, zone, curve date and curve type.</returns>
        public static DataSet SelectSupplierPremiumFactorCurve( Guid? fileContextGuid, string iso, string zoneCode, DateTime beginDate, DateTime endDate, string curveType, bool? filterOldRecords )
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PESupplierPremiumFactorCurveSelect";

                    cmd.Parameters.Add( new SqlParameter( "@Iso", iso ) );
                    cmd.Parameters.Add( new SqlParameter( "@ZoneCode", zoneCode ) );
                    cmd.Parameters.Add( new SqlParameter( "@BeginDate", beginDate ) );
                    cmd.Parameters.Add( new SqlParameter( "@EndDate", endDate ) );
                    cmd.Parameters.Add( new SqlParameter( "@CurveType", curveType ) );
                    cmd.Parameters.Add( new SqlParameter( "@FileContextGuid", fileContextGuid ) );
                    cmd.Parameters.Add( new SqlParameter( "@FilterOldRecords", filterOldRecords ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        /// <summary>
        /// Inserts a SupplierPremiumFactorCurve
        /// </summary>
        /// <param name=SupplierPremiumFactorCurve></param>
        public static int InsertSupplierPremiumFactorCurve( Guid fileContextGuid, DateTime curveDate, decimal factor, string curveName, int createdBy )
        {
            DataSet ds = new DataSet();
            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PESupplierPremiumFactorCurveInsert";

                    cmd.Parameters.Add( new SqlParameter( "@FileContextGuid", fileContextGuid ) );
                    cmd.Parameters.Add( new SqlParameter( "@CurveDate", curveDate ) );
                    cmd.Parameters.Add( new SqlParameter( "@Factor", factor ) );
                    cmd.Parameters.Add( new SqlParameter( "@CurveName", curveName ) );
                    cmd.Parameters.Add( new SqlParameter( "@CreatedBy", createdBy ) );

                    conn.Open();
                    return Convert.ToInt32( cmd.ExecuteScalar() );

                }
            }
        }

        #endregion Supplier Premium Factor

        #region Voluntary Renewables Price
        /// <summary>
        /// Selects the voluntary renewables prices for the specified plan and date range.
        /// </summary>
        /// <param name="plan">Plan name</param>
        /// <param name="beginDate">Begin date of curve</param>
        /// <param name="endDate">End date of curve</param>
        /// <returns>Returns a dataset that contains the voluntary renewables prices for the 
        /// specified plan and date range.</returns>
        public static DataSet SelectVoluntaryRenewablesPriceCurve( Guid? fileContextGuid, string plan, DateTime? beginDate, DateTime? endDate, bool? filterOldRecords )
        {
            DataSet ds = new DataSet();

            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEVoluntaryRenewablesPriceCurveSelect";

                    cmd.Parameters.Add( new SqlParameter( "@Plan", plan ) );
                    cmd.Parameters.Add( new SqlParameter( "@BeginDate", beginDate ) );
                    cmd.Parameters.Add( new SqlParameter( "@EndDate", endDate ) );
                    cmd.Parameters.Add( new SqlParameter( "@FileContextGuid", fileContextGuid ) );
                    cmd.Parameters.Add( new SqlParameter( "@FilterOldRecords", filterOldRecords ) );

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        /// <summary>
        /// Inserts a VoluntaryRenewablesPriceCurve
        /// </summary>
        /// <param name=VoluntaryRenewablesPriceCurve></param>
        public static int InsertVoluntaryRenewablesPriceCurve( Guid fileContextGuid, string planName, int month, int year, decimal price, int createdBy )
        {
            DataSet ds = new DataSet();
            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEVoluntaryRenewablesPriceCurveInsert";

                    cmd.Parameters.Add( new SqlParameter( "@FileContextGuid", fileContextGuid ) );
                    cmd.Parameters.Add( new SqlParameter( "@PlanName", planName ) );
                    cmd.Parameters.Add( new SqlParameter( "@Month", month ) );
                    cmd.Parameters.Add( new SqlParameter( "@Year", year ) );
                    cmd.Parameters.Add( new SqlParameter( "@Price", price ) );
                    cmd.Parameters.Add( new SqlParameter( "@CreatedBy", createdBy ) );

                    conn.Open();
                    return Convert.ToInt32( cmd.ExecuteScalar() );
                }
            }
        }

        /// <summary>
        /// Gets all Plan Names Voluntary Renewables.
        /// </summary>
        /// <returns></returns>
        public static DataSet GetAllPlanNames()
        {
            DataSet ds = new DataSet();
            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEVoluntaryRenewablesPlanNameSelect";

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                    {
                        da.Fill( ds );
                    }
                }
            }
            return ds;
        }

        #endregion Voluntary Renewables Price

        #region Execution Risk Size Factor / Size Category Factor
        /// <summary>
        /// Gets the execution risk size factor.
        /// </summary>
        /// <param name="annualizedUsage">Annualized usage</param>
        /// <returns>Returns a dataset containing the execution risk size factor.</returns>
        public static DataSet SelectExecutionRiskSizeFactor( Guid? fileContextGuid, int? annualizedUsage, bool? filterOldRecords )
        {
            DataSet ds = new DataSet();
            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEExecutionRiskSizeFactorCurveSelect";
                    cmd.Parameters.Add( new SqlParameter( "@FileContextGuid", fileContextGuid ) );
                    cmd.Parameters.Add( new SqlParameter( "@AnnualizedUsage", annualizedUsage ) );
                    cmd.Parameters.Add( new SqlParameter( "@FilterOldRecords", filterOldRecords ) );
                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        /// <summary>
        /// Inserts a ExecutionRiskSizeFactorCurve
        /// </summary>
        /// <param name=SizeCategoryFactorSize></param>
        public static int InsertExecutionRiskSizeFactorCurve( Guid fileContextGuid, int min, int max, decimal executionRiskSizeFactor, int createdBy )
        {
            DataSet ds = new DataSet();
            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEExecutionRiskSizeFactorCurveInsert";
                    cmd.Parameters.Add( new SqlParameter( "@FileContextGuid", fileContextGuid ) );
                    cmd.Parameters.Add( new SqlParameter( "@Min", min ) );
                    cmd.Parameters.Add( new SqlParameter( "@Max", max ) );
                    cmd.Parameters.Add( new SqlParameter( "@ExecutionRiskSizeFactor", executionRiskSizeFactor ) );
                    cmd.Parameters.Add( new SqlParameter( "@CreatedBy", createdBy ) );
                    conn.Open();
                    return Convert.ToInt32( cmd.ExecuteScalar() );
                }
            }
        }


        #endregion Execution Risk Size Factor / Size Category Factor

    }


}