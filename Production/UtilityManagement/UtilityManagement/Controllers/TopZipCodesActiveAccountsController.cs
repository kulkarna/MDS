using DataAccessLayerEntityFramework;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web.Mvc;
using UserInterfaceValidationExtensions;
using Utilities;
using System.Web.UI.DataVisualization.Charting;
using System.IO;
using UtilityManagement.ChartHelpers;

namespace UtilityManagement.Controllers
{
    [ValidateInputAttribute(false)]
    public class TopZipCodesActiveAccountsController : ControllerBase
    {
        #region private variables and constants
        private const string CLASS = "TopZipCodesController";
        #endregion

        #region public constructors
        public TopZipCodesActiveAccountsController()
            : base()
        {
            ViewBag.PageName = "TopZipCodesActiveAccounts";
            ViewBag.IndexPageName = "TopZipCodesActiveAccounts";
            ViewBag.PageDisplayName = "Top Active Account Zip Codes";
        }
        #endregion

        #region public methods
        ////
        //// GET: /UtilityCompany/
        //public ActionResult Index()
        //{
        //    string method = "Index()";
        //    try
        //    {
        //        VerifyMessageIdAndErrorMessageSession();
        //        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

        //        var response = ObtainResponse();

        //        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));
        //        return View(response);
        //    }
        //    catch (Exception exc)
        //    {
        //        ErrorHandler(exc, method);
        //        return View(new List<UtilityManagement.Models.Top25ZipCodesItem>());
        //    }
        //}

        public override ActionResult GetBlankResponse()
        {
            return View(new List<UtilityManagement.Models.Top25ZipCodesItem>());
        }

        #endregion


        #region private and protected methods
        protected override void Dispose(bool disposing)
        {
            _db.Dispose();
            base.Dispose(disposing);
        }

        public ActionResult HuChart()
        {
            var salesChart = new Chart()
            {
                Width = 600,
                Height = 400
            };

            var builder = new Top25ZipCodesChartBuilder(salesChart);
            builder.CategoryName = "Data";
            builder.OrderYear = 2013;
            builder.BuildChart();

            salesChart.Titles[0].Visible = false;

            // Save the chart to a MemoryStream
            var imgStream = new MemoryStream();
            salesChart.SaveImage(imgStream, ChartImageFormat.Png);
            imgStream.Seek(0, SeekOrigin.Begin);

            // Return the contents of the Stream to the client
            return File(imgStream, "image/png");
        }

        private UtilityManagement.Models.TopZipCodesActiveAccountsModel ObtainResponse()
        {

            UtilityManagement.Models.TopZipCodesActiveAccountsModel response = new Models.TopZipCodesActiveAccountsModel();
            response.TopZipCodesActiveAccountsItems = new List<Models.TopZipCodesActiveAccountsItem>();

            string queryTopZipCodesActiveAccounts = "SELECT Z.ZipCode, Z.Description, SUM(CASE WHEN  AT.AccountTypeName = 'Residential' THEN NumberOfAccounts END) ResidentialAccountCount, SUM(CASE WHEN  AT.AccountTypeName = 'SOHO' THEN NumberOfAccounts END) SOHOAccountCount, SUM(CASE WHEN  AT.AccountTypeName = 'Commercial' THEN NumberOfAccounts END) CommercialAccountCount, SUM(CASE WHEN  AT.AccountTypeName = 'LCI' THEN NumberOfAccounts END) LCIAccountCount, SUM(CASE WHEN  AT.AccountTypeName = 'Residential' THEN NumberOfAccounts END) + SUM(CASE WHEN  AT.AccountTypeName = 'SOHO' THEN NumberOfAccounts END)ResidentialAndSOHOAccountCount, SUM(CASE WHEN  AT.AccountTypeName = 'Residential' THEN NumberOfAccounts END) + SUM(CASE WHEN  AT.AccountTypeName = 'SOHO' THEN NumberOfAccounts END) + SUM(CASE WHEN  AT.AccountTypeName = 'Commercial' THEN NumberOfAccounts END) MassMarketAccountCount, SUM(CASE WHEN  AT.AccountTypeName = 'LCI' THEN NumberOfAccounts END) + SUM(CASE WHEN  AT.AccountTypeName = 'Commercial' THEN NumberOfAccounts END) CommercialAndLCIAccountCount, SUM(CASE WHEN  AT.AccountTypeName = 'Residential' THEN NumberOfAccounts END) + SUM(CASE WHEN  AT.AccountTypeName = 'SOHO' THEN NumberOfAccounts END) + SUM(CASE WHEN  AT.AccountTypeName = 'Commercial' THEN NumberOfAccounts END) + SUM(CASE WHEN  AT.AccountTypeName = 'LCI' THEN NumberOfAccounts END) TotalAccountCount FROM Lp_DemographicData.dbo.AccountsPerZipCodeByTimeSlice (NOLOCK) A INNER JOIN Lp_DemographicData.dbo.ZipCode (NOLOCK) Z ON A.ZipCodeId = Z.Id INNER JOIN Lp_DemographicData.dbo.USState (NOLOCK) U ON Z.StateId = U.Id INNER JOIN Lp_DemographicData.dbo.AccountDataType (NOLOCK) ADT ON A.AccountDataTypeId = ADT.Id INNER JOIN Lp_DemographicData.dbo.AccountType (NOLOCK) AT ON A.AccountTypeId = AT.Id INNER JOIN Lp_DemographicData.dbo.TimeSlice (NOLOCK) TS ON A.TimeSliceId = TS.Id WHERE TS.TimeSliceBeginDate = (select max(TimeSliceBeginDate) FROM Lp_DemographicData.dbo.TimeSlice (NOLOCK)) AND ADT.AccountDataTypeName = 'ActiveAccounts' GROUP BY Z.ZipCode, Z.Description ORDER BY SUM(CASE WHEN  AT.AccountTypeName = 'Residential' THEN NumberOfAccounts END) DESC, SUM(CASE WHEN  AT.AccountTypeName = 'Residential' THEN NumberOfAccounts END) + SUM(CASE WHEN  AT.AccountTypeName = 'SOHO' THEN NumberOfAccounts END) + SUM(CASE WHEN  AT.AccountTypeName = 'Commercial' THEN NumberOfAccounts END) + SUM(CASE WHEN  AT.AccountTypeName = 'LCI' THEN NumberOfAccounts END) DESC, Z.ZipCode";
            System.Data.DataSet dsTopZipCodesActiveAccounts = new System.Data.DataSet();
            using (System.Data.SqlClient.SqlConnection connection = new System.Data.SqlClient.SqlConnection("Data Source=LPCD7X64-065;Initial Catalog=Lp_DemographicData;Persist Security Info=True;User ID=LibertyPowerUtilityManagementUser;Password=L1b3rtyP0w3r;MultipleActiveResultSets=True;Application Name=EntityFramework"))
            {
                using (System.Data.SqlClient.SqlCommand cmd = new System.Data.SqlClient.SqlCommand(queryTopZipCodesActiveAccounts, connection))
                {
                    System.Data.SqlClient.SqlDataAdapter adapter = new System.Data.SqlClient.SqlDataAdapter(cmd);
                    adapter.SelectCommand.CommandType = System.Data.CommandType.Text;
                    adapter.Fill(dsTopZipCodesActiveAccounts);
                }
            }
            if (dsTopZipCodesActiveAccounts != null && dsTopZipCodesActiveAccounts.Tables != null && dsTopZipCodesActiveAccounts.Tables.Count > 0 && dsTopZipCodesActiveAccounts.Tables[0] != null && dsTopZipCodesActiveAccounts.Tables[0].Rows != null && dsTopZipCodesActiveAccounts.Tables[0].Rows.Count > 0)
            {
                foreach (DataRow dataRow in dsTopZipCodesActiveAccounts.Tables[0].Rows)
                {
                    int residentialAccountCount = 0;
                    int.TryParse(dataRow["ResidentialAccountCount"].ToString(), out residentialAccountCount);
                    int sohoAccountCount = 0;
                    int.TryParse(dataRow["SOHOAccountCount"].ToString(), out sohoAccountCount);
                    int commercialAccountCount = 0;
                    int.TryParse(dataRow["CommercialAccountCount"].ToString(), out commercialAccountCount);
                    int lciAccountCount = 0;
                    int.TryParse(dataRow["LciAccountCount"].ToString(), out lciAccountCount);
                    int residentialAndSohoAccountCount = 0;
                    int.TryParse(dataRow["ResidentialAndSohoAccountCount"].ToString(), out residentialAndSohoAccountCount);
                    int massMarketAccountCount = 0;
                    int.TryParse(dataRow["MassMarketAccountCount"].ToString(), out massMarketAccountCount);
                    int commercialAndLciAccountCount = 0;
                    int.TryParse(dataRow["CommercialAndLCIAccountCount"].ToString(), out commercialAndLciAccountCount);
                    int totalAccountCount = 0;
                    int.TryParse(dataRow["TotalAccountCount"].ToString(), out totalAccountCount);

                    UtilityManagement.Models.TopZipCodesActiveAccountsItem topZipCodesActiveAccountsItem = new Models.TopZipCodesActiveAccountsItem()
                    {
                        ResidentialAccountCount = residentialAccountCount,
                        SohoAccountCount = sohoAccountCount,
                        CommercialAccountCount = commercialAccountCount,
                        LciAccountCount = lciAccountCount,
                        ResidentialAndSohoAccountCount = residentialAndSohoAccountCount,
                        MassMarketAccountCount = massMarketAccountCount,
                        CommercialAndLciAccountCount = commercialAndLciAccountCount,
                        TotalAccountCount = totalAccountCount,
                        ZipCode = dataRow["ZipCode"].ToString(),
                        Description = dataRow["Description"].ToString()
                    };
                    response.TopZipCodesActiveAccountsItems.Add(topZipCodesActiveAccountsItem);
                }
            }
            return response;
        }

        public override ActionResult ObtainActionResult()
        {

            UtilityManagement.Models.TopZipCodesActiveAccountsModel response = new Models.TopZipCodesActiveAccountsModel();
            response.TopZipCodesActiveAccountsItems = new List<Models.TopZipCodesActiveAccountsItem>();

            string queryTopZipCodesActiveAccounts = "SELECT Z.ZipCode, Z.Description, SUM(CASE WHEN  AT.AccountTypeName = 'Residential' THEN NumberOfAccounts END) ResidentialAccountCount, SUM(CASE WHEN  AT.AccountTypeName = 'SOHO' THEN NumberOfAccounts END) SOHOAccountCount, SUM(CASE WHEN  AT.AccountTypeName = 'Commercial' THEN NumberOfAccounts END) CommercialAccountCount, SUM(CASE WHEN  AT.AccountTypeName = 'LCI' THEN NumberOfAccounts END) LCIAccountCount, SUM(CASE WHEN  AT.AccountTypeName = 'Residential' THEN NumberOfAccounts END) + SUM(CASE WHEN  AT.AccountTypeName = 'SOHO' THEN NumberOfAccounts END)ResidentialAndSOHOAccountCount, SUM(CASE WHEN  AT.AccountTypeName = 'Residential' THEN NumberOfAccounts END) + SUM(CASE WHEN  AT.AccountTypeName = 'SOHO' THEN NumberOfAccounts END) + SUM(CASE WHEN  AT.AccountTypeName = 'Commercial' THEN NumberOfAccounts END) MassMarketAccountCount, SUM(CASE WHEN  AT.AccountTypeName = 'LCI' THEN NumberOfAccounts END) + SUM(CASE WHEN  AT.AccountTypeName = 'Commercial' THEN NumberOfAccounts END) CommercialAndLCIAccountCount, SUM(CASE WHEN  AT.AccountTypeName = 'Residential' THEN NumberOfAccounts END) + SUM(CASE WHEN  AT.AccountTypeName = 'SOHO' THEN NumberOfAccounts END) + SUM(CASE WHEN  AT.AccountTypeName = 'Commercial' THEN NumberOfAccounts END) + SUM(CASE WHEN  AT.AccountTypeName = 'LCI' THEN NumberOfAccounts END) TotalAccountCount FROM Lp_DemographicData.dbo.AccountsPerZipCodeByTimeSlice (NOLOCK) A INNER JOIN Lp_DemographicData.dbo.ZipCode (NOLOCK) Z ON A.ZipCodeId = Z.Id INNER JOIN Lp_DemographicData.dbo.USState (NOLOCK) U ON Z.StateId = U.Id INNER JOIN Lp_DemographicData.dbo.AccountDataType (NOLOCK) ADT ON A.AccountDataTypeId = ADT.Id INNER JOIN Lp_DemographicData.dbo.AccountType (NOLOCK) AT ON A.AccountTypeId = AT.Id INNER JOIN Lp_DemographicData.dbo.TimeSlice (NOLOCK) TS ON A.TimeSliceId = TS.Id WHERE TS.TimeSliceBeginDate = (select max(TimeSliceBeginDate) FROM Lp_DemographicData.dbo.TimeSlice (NOLOCK)) AND ADT.AccountDataTypeName = 'ActiveAccounts' GROUP BY Z.ZipCode, Z.Description ORDER BY SUM(CASE WHEN  AT.AccountTypeName = 'Residential' THEN NumberOfAccounts END) DESC, SUM(CASE WHEN  AT.AccountTypeName = 'Residential' THEN NumberOfAccounts END) + SUM(CASE WHEN  AT.AccountTypeName = 'SOHO' THEN NumberOfAccounts END) + SUM(CASE WHEN  AT.AccountTypeName = 'Commercial' THEN NumberOfAccounts END) + SUM(CASE WHEN  AT.AccountTypeName = 'LCI' THEN NumberOfAccounts END) DESC, Z.ZipCode";
            System.Data.DataSet dsTopZipCodesActiveAccounts = new System.Data.DataSet();
            using (System.Data.SqlClient.SqlConnection connection = new System.Data.SqlClient.SqlConnection("Data Source=LPCD7X64-065;Initial Catalog=Lp_DemographicData;Persist Security Info=True;User ID=LibertyPowerUtilityManagementUser;Password=L1b3rtyP0w3r;MultipleActiveResultSets=True;Application Name=EntityFramework"))
            {
                using (System.Data.SqlClient.SqlCommand cmd = new System.Data.SqlClient.SqlCommand(queryTopZipCodesActiveAccounts, connection))
                {
                    System.Data.SqlClient.SqlDataAdapter adapter = new System.Data.SqlClient.SqlDataAdapter(cmd);
                    adapter.SelectCommand.CommandType = System.Data.CommandType.Text;
                    adapter.Fill(dsTopZipCodesActiveAccounts);
                }
            }
            if (dsTopZipCodesActiveAccounts != null && dsTopZipCodesActiveAccounts.Tables != null && dsTopZipCodesActiveAccounts.Tables.Count > 0 && dsTopZipCodesActiveAccounts.Tables[0] != null && dsTopZipCodesActiveAccounts.Tables[0].Rows != null && dsTopZipCodesActiveAccounts.Tables[0].Rows.Count > 0)
            {
                foreach (DataRow dataRow in dsTopZipCodesActiveAccounts.Tables[0].Rows)
                {
                    int residentialAccountCount = 0;
                    int.TryParse(dataRow["ResidentialAccountCount"].ToString(), out residentialAccountCount);
                    int sohoAccountCount = 0;
                    int.TryParse(dataRow["SOHOAccountCount"].ToString(), out sohoAccountCount);
                    int commercialAccountCount = 0;
                    int.TryParse(dataRow["CommercialAccountCount"].ToString(), out commercialAccountCount);
                    int lciAccountCount = 0;
                    int.TryParse(dataRow["LciAccountCount"].ToString(), out lciAccountCount);
                    int residentialAndSohoAccountCount = 0;
                    int.TryParse(dataRow["ResidentialAndSohoAccountCount"].ToString(), out residentialAndSohoAccountCount);
                    int massMarketAccountCount = 0;
                    int.TryParse(dataRow["MassMarketAccountCount"].ToString(), out massMarketAccountCount);
                    int commercialAndLciAccountCount = 0;
                    int.TryParse(dataRow["CommercialAndLCIAccountCount"].ToString(), out commercialAndLciAccountCount);
                    int totalAccountCount = 0;
                    int.TryParse(dataRow["TotalAccountCount"].ToString(), out totalAccountCount);

                    UtilityManagement.Models.TopZipCodesActiveAccountsItem topZipCodesActiveAccountsItem = new Models.TopZipCodesActiveAccountsItem()
                    {
                        ResidentialAccountCount = residentialAccountCount,
                        SohoAccountCount = sohoAccountCount,
                        CommercialAccountCount = commercialAccountCount,
                        LciAccountCount = lciAccountCount,
                        ResidentialAndSohoAccountCount = residentialAndSohoAccountCount,
                        MassMarketAccountCount = massMarketAccountCount,
                        CommercialAndLciAccountCount = commercialAndLciAccountCount,
                        TotalAccountCount = totalAccountCount,
                        ZipCode = dataRow["ZipCode"].ToString(),
                        Description = dataRow["Description"].ToString()
                    };
                    response.TopZipCodesActiveAccountsItems.Add(topZipCodesActiveAccountsItem);
                }
            }
            return View(response);
        }
        #endregion
    }
}