using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using DATA;
using LibertyPower.Business.MarketManagement.EdiParser.FileParser;
using LibertyPower.Business.MarketManagement.UtilityManagement;
using UsageFileProcessor.Entities;
using UsageFileProcessor.Services;

namespace UsageFileProcessor.Repository
{
    public class SqlRepository : IRepository
    {
        private string lpTransactionsConnectionString;

        public SqlRepository()
        {
            lpTransactionsConnectionString = ConfigurationManager.ConnectionStrings[ConfigurationManager.AppSettings.Get("ConnectionStringNameLpTransactions")].ConnectionString;
        }

        public int InsertAccount(ParserAccount account)
         {
            var fileAccountId = 0;

            var @params = new ArrayList();
            @params.Add(new SqlParameter("@FileGuid", Guid.Empty));
            @params.Add(new SqlParameter("@CustomerName", account.CustomerName));
            @params.Add(new SqlParameter("@AccountNumber", account.AccountNumber));
            @params.Add(new SqlParameter("@MarketCode", account.RetailMarketCode));
            @params.Add(new SqlParameter("@UtilityCode", account.UtilityCode));
            @params.Add(new SqlParameter("@MeterType", account.MeterType));
            @params.Add(new SqlParameter("@RateClass", account.RateClass));
            @params.Add(new SqlParameter("@Voltage", account.Voltage));
            @params.Add(new SqlParameter("@ZoneCode", account.ZoneCode));
            @params.Add(new SqlParameter("@Tcap", account.Tcap));
            @params.Add(new SqlParameter("@Icap", account.Icap));
            @params.Add(new SqlParameter("@LoadShapeId", account.LoadShapeId));
            @params.Add(new SqlParameter("@Losses", account.LossFactor));
            @params.Add(new SqlParameter("@NameKey", account.NameKey ?? string.Empty));
            @params.Add(new SqlParameter("@StratumVariable", account.StratumVariable));
            @params.Add(new SqlParameter("@RateCode", account.RateCode));
            @params.Add(new SqlParameter("@BillGroup", account.BillGroup));
            @params.Add(new SqlParameter("@LoadProfile", account.LoadProfile));
            @params.Add(new SqlParameter("@SupplyGroup", account.SupplyGroup));
            @params.Add(new SqlParameter("@BillingAccountNumber", account.BillingAccount));
            @params.Add(new SqlParameter("@TarrifCode", account.TariffCode));
            @params.Add(new SqlParameter("@Grid", account.Grid));
            @params.Add(new SqlParameter("@LbmpZone", account.LBMPZone));
            @params.Add(new SqlParameter("@DateCreated", DateTime.Now));
            @params.Add(new SqlParameter("@CreatedBy", 1));

            foreach (SqlParameter p in from SqlParameter p in @params where p.Value == null select p)
                p.Value = DBNull.Value;

            var ds = DAO.GetInstance(lpTransactionsConnectionString).
                    ExecuteStoredProcedure("usp_FileAccountInsert", @params, DAO.SPDatabase.lp_transactions);
            if (DataSetService.HasRow(ds))
                fileAccountId = Convert.ToInt32(ds.Tables[0].Rows[0]["ID"]);
            
            return fileAccountId;
        
         }

        public void InsertUsage(int fileAccountId, Usage usage)
        {
            int usageTypeId = Convert.ToInt16(usage.UsageType);
            int usageSourceId = Convert.ToInt16(UsageSource.User);
            

            var @params = new ArrayList();
            @params.Add(new SqlParameter("@FileAccountID", fileAccountId));
            @params.Add(new SqlParameter("@UtilityCode", usage.UtilityCode));
            @params.Add(new SqlParameter("@AccountNumber", usage.AccountNumber));
            @params.Add(new SqlParameter("@UsageType", usageTypeId));
            @params.Add(new SqlParameter("@UsageSource", usageSourceId));
            @params.Add(new SqlParameter("@FromDate", usage.BeginDate));
            @params.Add(new SqlParameter("@ToDate", usage.EndDate));
            @params.Add(new SqlParameter("@TotalKwh", usage.TotalKwh));
            @params.Add(new SqlParameter("@DaysUsed", usage.Days));
            @params.Add(new SqlParameter("@MeterNumber", usage.MeterNumber ?? string.Empty));
            @params.Add(new SqlParameter("@OnPeakKwh", usage.OnPeakKwh));
            @params.Add(new SqlParameter("@OffPeakKwh", usage.OffPeakKwh));
            @params.Add(new SqlParameter("@IntermediateKwh", usage.IntermediateKwh));
            @params.Add(new SqlParameter("@BillingDemandKW", usage.BillingDemandKw));
            @params.Add(new SqlParameter("@MonthlyPeakDemandKW", usage.MonthlyPeakDemandKw));
            @params.Add(new SqlParameter("@MonthlyOffPeakDemandKw", usage.MonthlyOffPeakDemandKw));
            @params.Add(new SqlParameter("@DateCreated", DateTime.Now));

            foreach (SqlParameter p in from SqlParameter p in @params where p.Value == null select p)
                p.Value = DBNull.Value;

            DAO.GetInstance(lpTransactionsConnectionString).
                ExecuteStoredProcedure("usp_FileUsageInsert", @params, DAO.SPDatabase.lp_transactions);
        }

        public void InsertAddresses(int fileAccountId, ParserAccount account)
        {

            var @params = new ArrayList();

            if (account.ServiceAddress != null)
            {
                @params.Add(new SqlParameter("@FileAccountID", fileAccountId));
                @params.Add(new SqlParameter("@Address1", account.ServiceAddress.Street));
                @params.Add(new SqlParameter("@Address2", DBNull.Value));
                @params.Add(new SqlParameter("@City", account.ServiceAddress.CityName));
                @params.Add(new SqlParameter("@State", account.ServiceAddress.State));
                @params.Add(new SqlParameter("@PostalCode", account.ServiceAddress.PostalCode));
                @params.Add(new SqlParameter("@AddressType", Convert.ToInt16(AddressType.ServiceAddress)));
                @params.Add(new SqlParameter("@DateCreated", DateTime.Now));

                foreach (SqlParameter p in from SqlParameter p in @params where p.Value == null select p)
                    p.Value = DBNull.Value;

                DAO.GetInstance(lpTransactionsConnectionString).
                    ExecuteStoredProcedure("usp_FileAddressInsert", @params, DATA.DAO.SPDatabase.lp_transactions);
   
            }

            @params.Clear();

            if (account.BillingAddress == null) return;

            @params.Add(new SqlParameter("@FileAccountID", fileAccountId));
            @params.Add(new SqlParameter("@Address1", account.BillingAddress.Street));
            @params.Add(new SqlParameter("@Address2", DBNull.Value));
            @params.Add(new SqlParameter("@City", account.BillingAddress.CityName));
            @params.Add(new SqlParameter("@State", account.BillingAddress.State));
            @params.Add(new SqlParameter("@PostalCode", account.BillingAddress.PostalCode));
            @params.Add(new SqlParameter("@AddressType", Convert.ToInt16(AddressType.BillingAddress)));
            @params.Add(new SqlParameter("@DateCreated", DateTime.Now));

            foreach (SqlParameter p in from SqlParameter p in @params where p.Value == null select p)
                p.Value = DBNull.Value;

            DAO.GetInstance(lpTransactionsConnectionString).
                ExecuteStoredProcedure("usp_FileAddressInsert", @params, DAO.SPDatabase.lp_transactions);
        }
    }
}