using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    [Serializable]
    public static class PEOfferDetailFileDataSql
    {

        /// <summary>
        /// Selects an OfferDetailFileData
        /// </summary>
        /// <param name=OfferDetailFileDataId></param>
        /// <returns>A dataset with all attributes</returns>
        public static DataSet SelectOfferDetailFileData(Int32 offerDetailFileDataId, Int32 contractPriceId, DateTime flowStart, Int32 term, String group, String utilityList, String zoneList, String numberOfAccounts, Decimal price, Decimal termUsage, Decimal termPeakUsage, Decimal termOffPeakUsage, Decimal atcBlockEnergy, Decimal peakBlockEnergy, Decimal offPeakBlockEnergy, Decimal atcSupplierPremium, Decimal peakSupplierPremium, Decimal offPeakSupplierPremium, Decimal atcShapingPremium, Decimal peakShapingPremium, Decimal offPeakShapingPremium, Decimal atcIntradayAdjustment, Decimal peakIntradayAdjustment, Decimal offPeakIntradayAdjustment, Decimal atcEnergyLoss, Decimal peakEnergyLoss, Decimal offPeakEnergyLoss, Decimal ancillaryService, Decimal replacementReserve, Decimal rps, Decimal voluntaryRenewables, Decimal uCap, Decimal tCap, Decimal arrCharge, Decimal schedulingFee, Decimal billingTransactionCost, Decimal porFee, Decimal financeFee, Decimal paymentTermPremium, Decimal summaryBillingPremium, Decimal mtmAdder, Decimal arCreditReserve, Decimal mtmCreditReserve, Decimal executionRisk, Decimal bandwidthPremium, Decimal defaultMarkup, Decimal commission, Decimal embeddedTax, Decimal individualUserDefinedPricingComponents )
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEOfferDetailFileDataSelect";

                    cmd.Parameters.Add(new SqlParameter("@OfferDetailFileDataId", offerDetailFileDataId));
                    cmd.Parameters.Add(new SqlParameter("@ContractPriceId", contractPriceId));
                    cmd.Parameters.Add(new SqlParameter("@FlowStart", flowStart));
                    cmd.Parameters.Add(new SqlParameter("@Term", term));
                    cmd.Parameters.Add(new SqlParameter("@Group", group));
                    cmd.Parameters.Add(new SqlParameter("@UtilityList", utilityList));
                    cmd.Parameters.Add(new SqlParameter("@ZoneList", zoneList));
                    cmd.Parameters.Add(new SqlParameter("@NumberOfAccounts", numberOfAccounts));
                    cmd.Parameters.Add(new SqlParameter("@Price", price));
                    cmd.Parameters.Add(new SqlParameter("@TermUsage", termUsage));
                    cmd.Parameters.Add(new SqlParameter("@TermPeakUsage", termPeakUsage));
                    cmd.Parameters.Add(new SqlParameter("@TermOffPeakUsage", termOffPeakUsage));
                    cmd.Parameters.Add(new SqlParameter("@AtcBlockEnergy", atcBlockEnergy));
                    cmd.Parameters.Add(new SqlParameter("@PeakBlockEnergy", peakBlockEnergy));
                    cmd.Parameters.Add(new SqlParameter("@OffPeakBlockEnergy", offPeakBlockEnergy));
                    cmd.Parameters.Add(new SqlParameter("@AtcSupplierPremium", atcSupplierPremium));
                    cmd.Parameters.Add(new SqlParameter("@PeakSupplierPremium", peakSupplierPremium));
                    cmd.Parameters.Add(new SqlParameter("@OffPeakSupplierPremium", offPeakSupplierPremium));
                    cmd.Parameters.Add(new SqlParameter("@AtcShapingPremium", atcShapingPremium));
                    cmd.Parameters.Add(new SqlParameter("@PeakShapingPremium", peakShapingPremium));
                    cmd.Parameters.Add(new SqlParameter("@OffPeakShapingPremium", offPeakShapingPremium));
                    cmd.Parameters.Add(new SqlParameter("@AtcIntradayAdjustment", atcIntradayAdjustment));
                    cmd.Parameters.Add(new SqlParameter("@PeakIntradayAdjustment", peakIntradayAdjustment));
                    cmd.Parameters.Add(new SqlParameter("@OffPeakIntradayAdjustment", offPeakIntradayAdjustment));
                    cmd.Parameters.Add(new SqlParameter("@AtcEnergyLoss", atcEnergyLoss));
                    cmd.Parameters.Add(new SqlParameter("@PeakEnergyLoss", peakEnergyLoss));
                    cmd.Parameters.Add(new SqlParameter("@OffPeakEnergyLoss", offPeakEnergyLoss));
                    cmd.Parameters.Add(new SqlParameter("@AncillaryService", ancillaryService));
                    cmd.Parameters.Add(new SqlParameter("@ReplacementReserve", replacementReserve));
                    cmd.Parameters.Add(new SqlParameter("@Rps", rps));
                    cmd.Parameters.Add(new SqlParameter("@VoluntaryRenewables", voluntaryRenewables));
                    cmd.Parameters.Add(new SqlParameter("@UCap", uCap));
                    cmd.Parameters.Add(new SqlParameter("@TCap", tCap));
                    cmd.Parameters.Add(new SqlParameter("@ArrCharge", arrCharge));
                    cmd.Parameters.Add(new SqlParameter("@SchedulingFee", schedulingFee));
                    cmd.Parameters.Add(new SqlParameter("@BillingTransactionCost", billingTransactionCost));
                    cmd.Parameters.Add(new SqlParameter("@PorFee", porFee));
                    cmd.Parameters.Add(new SqlParameter("@FinanceFee", financeFee));
                    cmd.Parameters.Add(new SqlParameter("@PaymentTermPremium", paymentTermPremium));
                    cmd.Parameters.Add(new SqlParameter("@SummaryBillingPremium", summaryBillingPremium));
                    cmd.Parameters.Add(new SqlParameter("@MtmAdder", mtmAdder));
                    cmd.Parameters.Add(new SqlParameter("@ArCreditReserve", arCreditReserve));
                    cmd.Parameters.Add(new SqlParameter("@MtmCreditReserve", mtmCreditReserve));
                    cmd.Parameters.Add(new SqlParameter("@ExecutionRisk", executionRisk));
                    cmd.Parameters.Add(new SqlParameter("@BandwidthPremium", bandwidthPremium));
                    cmd.Parameters.Add(new SqlParameter("@DefaultMarkup", defaultMarkup));
                    cmd.Parameters.Add(new SqlParameter("@Commission", commission));
                    cmd.Parameters.Add(new SqlParameter("@EmbeddedTax", embeddedTax));
                    cmd.Parameters.Add(new SqlParameter("@IndividualUserDefinedPricingComponents", individualUserDefinedPricingComponents));
                     

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }
        /// <summary>
        /// Inserts an OfferDetailFileData
        /// </summary>
        /// <param name=OfferDetailFileData></param>
        public static int InsertOfferDetailFileData(Int32 contractPriceId, DateTime flowStart, Int32 term, String group, String utilityList, String zoneList, String numberOfAccounts, Decimal price, Decimal termUsage, Decimal termPeakUsage, Decimal termOffPeakUsage, Decimal atcBlockEnergy, Decimal peakBlockEnergy, Decimal offPeakBlockEnergy, Decimal atcSupplierPremium, Decimal peakSupplierPremium, Decimal offPeakSupplierPremium, Decimal atcShapingPremium, Decimal peakShapingPremium, Decimal offPeakShapingPremium, Decimal atcIntradayAdjustment, Decimal peakIntradayAdjustment, Decimal offPeakIntradayAdjustment, Decimal atcEnergyLoss, Decimal peakEnergyLoss, Decimal offPeakEnergyLoss, Decimal ancillaryService, Decimal replacementReserve, Decimal rps, Decimal voluntaryRenewables, Decimal uCap, Decimal tCap, Decimal arrCharge, Decimal schedulingFee, Decimal billingTransactionCost, Decimal porFee, Decimal financeFee, Decimal paymentTermPremium, Decimal summaryBillingPremium, Decimal mtmAdder, Decimal arCreditReserve, Decimal mtmCreditReserve, Decimal executionRisk, Decimal bandwidthPremium, Decimal defaultMarkup, Decimal commission, Decimal embeddedTax, Decimal individualUserDefinedPricingComponents )
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEOfferDetailFileDataInsert";

                    cmd.Parameters.Add(new SqlParameter("@ContractPriceId", contractPriceId));
                    cmd.Parameters.Add(new SqlParameter("@FlowStart", flowStart));
                    cmd.Parameters.Add(new SqlParameter("@Term", term));
                    cmd.Parameters.Add(new SqlParameter("@Group", group));
                    cmd.Parameters.Add(new SqlParameter("@UtilityList", utilityList));
                    cmd.Parameters.Add(new SqlParameter("@ZoneList", zoneList));
                    cmd.Parameters.Add(new SqlParameter("@NumberOfAccounts", numberOfAccounts));
                    cmd.Parameters.Add(new SqlParameter("@Price", price));
                    cmd.Parameters.Add(new SqlParameter("@TermUsage", termUsage));
                    cmd.Parameters.Add(new SqlParameter("@TermPeakUsage", termPeakUsage));
                    cmd.Parameters.Add(new SqlParameter("@TermOffPeakUsage", termOffPeakUsage));
                    cmd.Parameters.Add(new SqlParameter("@AtcBlockEnergy", atcBlockEnergy));
                    cmd.Parameters.Add(new SqlParameter("@PeakBlockEnergy", peakBlockEnergy));
                    cmd.Parameters.Add(new SqlParameter("@OffPeakBlockEnergy", offPeakBlockEnergy));
                    cmd.Parameters.Add(new SqlParameter("@AtcSupplierPremium", atcSupplierPremium));
                    cmd.Parameters.Add(new SqlParameter("@PeakSupplierPremium", peakSupplierPremium));
                    cmd.Parameters.Add(new SqlParameter("@OffPeakSupplierPremium", offPeakSupplierPremium));
                    cmd.Parameters.Add(new SqlParameter("@AtcShapingPremium", atcShapingPremium));
                    cmd.Parameters.Add(new SqlParameter("@PeakShapingPremium", peakShapingPremium));
                    cmd.Parameters.Add(new SqlParameter("@OffPeakShapingPremium", offPeakShapingPremium));
                    cmd.Parameters.Add(new SqlParameter("@AtcIntradayAdjustment", atcIntradayAdjustment));
                    cmd.Parameters.Add(new SqlParameter("@PeakIntradayAdjustment", peakIntradayAdjustment));
                    cmd.Parameters.Add(new SqlParameter("@OffPeakIntradayAdjustment", offPeakIntradayAdjustment));
                    cmd.Parameters.Add(new SqlParameter("@AtcEnergyLoss", atcEnergyLoss));
                    cmd.Parameters.Add(new SqlParameter("@PeakEnergyLoss", peakEnergyLoss));
                    cmd.Parameters.Add(new SqlParameter("@OffPeakEnergyLoss", offPeakEnergyLoss));
                    cmd.Parameters.Add(new SqlParameter("@AncillaryService", ancillaryService));
                    cmd.Parameters.Add(new SqlParameter("@ReplacementReserve", replacementReserve));
                    cmd.Parameters.Add(new SqlParameter("@Rps", rps));
                    cmd.Parameters.Add(new SqlParameter("@VoluntaryRenewables", voluntaryRenewables));
                    cmd.Parameters.Add(new SqlParameter("@UCap", uCap));
                    cmd.Parameters.Add(new SqlParameter("@TCap", tCap));
                    cmd.Parameters.Add(new SqlParameter("@ArrCharge", arrCharge));
                    cmd.Parameters.Add(new SqlParameter("@SchedulingFee", schedulingFee));
                    cmd.Parameters.Add(new SqlParameter("@BillingTransactionCost", billingTransactionCost));
                    cmd.Parameters.Add(new SqlParameter("@PorFee", porFee));
                    cmd.Parameters.Add(new SqlParameter("@FinanceFee", financeFee));
                    cmd.Parameters.Add(new SqlParameter("@PaymentTermPremium", paymentTermPremium));
                    cmd.Parameters.Add(new SqlParameter("@SummaryBillingPremium", summaryBillingPremium));
                    cmd.Parameters.Add(new SqlParameter("@MtmAdder", mtmAdder));
                    cmd.Parameters.Add(new SqlParameter("@ArCreditReserve", arCreditReserve));
                    cmd.Parameters.Add(new SqlParameter("@MtmCreditReserve", mtmCreditReserve));
                    cmd.Parameters.Add(new SqlParameter("@ExecutionRisk", executionRisk));
                    cmd.Parameters.Add(new SqlParameter("@BandwidthPremium", bandwidthPremium));
                    cmd.Parameters.Add(new SqlParameter("@DefaultMarkup", defaultMarkup));
                    cmd.Parameters.Add(new SqlParameter("@Commission", commission));
                    cmd.Parameters.Add(new SqlParameter("@EmbeddedTax", embeddedTax));
                    cmd.Parameters.Add(new SqlParameter("@IndividualUserDefinedPricingComponents", individualUserDefinedPricingComponents));
                     
                    conn.Open();
                    return Convert.ToInt32( cmd.ExecuteScalar() );

                }
            }
        }
    }
}

