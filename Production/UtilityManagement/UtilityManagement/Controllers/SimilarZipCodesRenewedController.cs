using DataAccessLayerEntityFramework;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web.Mvc;
using UserInterfaceValidationExtensions;
using Utilities;

namespace UtilityManagement.Controllers
{
    [ValidateInputAttribute(false)]
    public class SimilarZipCodesRenewedController : ControllerBase
    {
        #region private variables and constants
        private const string CLASS = "SimilarZipCodesRenewedController";
        #endregion

        #region public constructors
        public SimilarZipCodesRenewedController()
            : base()
        {
            ViewBag.PageName = "SimilarZipCodesRenewed";
            ViewBag.IndexPageName = "SimilarZipCodesRenewed";
            ViewBag.PageDisplayName = "Similar Zip Codes Renewed";
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
        //        return View(new List<UtilityManagement.Models.ZipCodesWithSimilarDemographicDataItem>());
        //    }
        //}

        public override ActionResult GetBlankResponse()
        {
            return View(new List<UtilityManagement.Models.ZipCodesWithSimilarDemographicDataItem>());
        }

        public JsonResult IndexTimeSliceSelection(string timeSliceId)
        {
            string method = "IndexTimeSliceSelection(string timeSliceId)";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));
                Session["SimilarZipCodes_TimeSliceId_Set"] = timeSliceId;
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return null;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return null;
            }
        }
        #endregion


        #region private and protected methods
        protected override void Dispose(bool disposing)
        {
            _db.Dispose();
            base.Dispose(disposing);
        }

        private UtilityManagement.Models.SimilarZipCodesModel ObtainResponse()
        {
            UtilityManagement.Models.SimilarZipCodesModel response = new Models.SimilarZipCodesModel();
            response.SimilarZipCodeList = new List<Models.SimilarZipCodesItem>();
            string querySimilarZipCode = "select [ZipCode5], Description, [2014 Median Household Income], [2014 Population Density], [2014 Median Age],[2014 Median Net Worth],[2014 Median Net Worth] from [SimilarZipCodesMedianAgeIncomeNetWorthPopulationDensityRenew] (nolock) a inner join dbo.zipcode (nolock) z on a.zipcodeid = z.id inner join dbo.[USState] (nolock) u on z.StateId = u.id where u.StateAbbreviation in ('NY','ME','MA','MD','PA','RI','CT','VT','NH','OH','IL','DE','NJ','TX') order by [2014 population density] desc";
            System.Data.DataSet dsSimilarZipCodes = new System.Data.DataSet();

            using (System.Data.SqlClient.SqlConnection connection = new System.Data.SqlClient.SqlConnection("Data Source=LPCD7X64-065;Initial Catalog=Lp_DemographicData;Persist Security Info=True;User ID=LibertyPowerUtilityManagementUser;Password=L1b3rtyP0w3r;MultipleActiveResultSets=True;Application Name=EntityFramework"))
            {
                using (System.Data.SqlClient.SqlCommand cmd = new System.Data.SqlClient.SqlCommand(querySimilarZipCode, connection))
                {
                    System.Data.SqlClient.SqlDataAdapter adapter = new System.Data.SqlClient.SqlDataAdapter(cmd);
                    adapter.SelectCommand.CommandType = System.Data.CommandType.Text;
                    adapter.Fill(dsSimilarZipCodes);
                }
            }
            if (dsSimilarZipCodes != null && dsSimilarZipCodes.Tables != null && dsSimilarZipCodes.Tables.Count > 0 && dsSimilarZipCodes.Tables[0] != null && dsSimilarZipCodes.Tables[0].Rows != null && dsSimilarZipCodes.Tables[0].Rows.Count > 0)
            {
                foreach (DataRow dataRow in dsSimilarZipCodes.Tables[0].Rows) 
                {
                    decimal populationDensity  = 0;
                    decimal.TryParse(dataRow["2014 Population Density"].ToString(),out populationDensity);
                    decimal medianAge  = 0;
                    decimal.TryParse(dataRow["2014 Median Age"].ToString(),out medianAge);
                    decimal medianNetWorth  = 0;
                    decimal.TryParse(dataRow["2014 Median Net Worth"].ToString(),out medianNetWorth);
                    decimal medianHouseholdIncome  = 0;
                    decimal.TryParse(dataRow["2014 Median Household Income"].ToString(),out medianHouseholdIncome);
                    UtilityManagement.Models.SimilarZipCodesItem similarZipCodesItem = new Models.SimilarZipCodesItem()
                    {
                        Description = dataRow["Description"].ToString(),
                        MedianAge = medianAge,
                        MedianHouseholdIncome = medianHouseholdIncome,
                        MedianNetWorth = medianNetWorth,
                        PopulationDensity = populationDensity,
                        ZipCode = dataRow["ZipCode5"].ToString()
                    };
                    response.SimilarZipCodeList.Add(similarZipCodesItem);
                }
            }
            return response;
        }

        public override ActionResult ObtainActionResult()
        {
            UtilityManagement.Models.SimilarZipCodesModel response = new Models.SimilarZipCodesModel();
            response.SimilarZipCodeList = new List<Models.SimilarZipCodesItem>();
            string querySimilarZipCode = "select [ZipCode5], Description, [2014 Median Household Income], [2014 Population Density], [2014 Median Age],[2014 Median Net Worth],[2014 Median Net Worth] from [SimilarZipCodesMedianAgeIncomeNetWorthPopulationDensityRenew] (nolock) a inner join dbo.zipcode (nolock) z on a.zipcodeid = z.id inner join dbo.[USState] (nolock) u on z.StateId = u.id where u.StateAbbreviation in ('NY','ME','MA','MD','PA','RI','CT','VT','NH','OH','IL','DE','NJ','TX') order by [2014 population density] desc";
            System.Data.DataSet dsSimilarZipCodes = new System.Data.DataSet();

            using (System.Data.SqlClient.SqlConnection connection = new System.Data.SqlClient.SqlConnection("Data Source=LPCD7X64-065;Initial Catalog=Lp_DemographicData;Persist Security Info=True;User ID=LibertyPowerUtilityManagementUser;Password=L1b3rtyP0w3r;MultipleActiveResultSets=True;Application Name=EntityFramework"))
            {
                using (System.Data.SqlClient.SqlCommand cmd = new System.Data.SqlClient.SqlCommand(querySimilarZipCode, connection))
                {
                    System.Data.SqlClient.SqlDataAdapter adapter = new System.Data.SqlClient.SqlDataAdapter(cmd);
                    adapter.SelectCommand.CommandType = System.Data.CommandType.Text;
                    adapter.Fill(dsSimilarZipCodes);
                }
            }
            if (dsSimilarZipCodes != null && dsSimilarZipCodes.Tables != null && dsSimilarZipCodes.Tables.Count > 0 && dsSimilarZipCodes.Tables[0] != null && dsSimilarZipCodes.Tables[0].Rows != null && dsSimilarZipCodes.Tables[0].Rows.Count > 0)
            {
                foreach (DataRow dataRow in dsSimilarZipCodes.Tables[0].Rows)
                {
                    decimal populationDensity = 0;
                    decimal.TryParse(dataRow["2014 Population Density"].ToString(), out populationDensity);
                    decimal medianAge = 0;
                    decimal.TryParse(dataRow["2014 Median Age"].ToString(), out medianAge);
                    decimal medianNetWorth = 0;
                    decimal.TryParse(dataRow["2014 Median Net Worth"].ToString(), out medianNetWorth);
                    decimal medianHouseholdIncome = 0;
                    decimal.TryParse(dataRow["2014 Median Household Income"].ToString(), out medianHouseholdIncome);
                    UtilityManagement.Models.SimilarZipCodesItem similarZipCodesItem = new Models.SimilarZipCodesItem()
                    {
                        Description = dataRow["Description"].ToString(),
                        MedianAge = medianAge,
                        MedianHouseholdIncome = medianHouseholdIncome,
                        MedianNetWorth = medianNetWorth,
                        PopulationDensity = populationDensity,
                        ZipCode = dataRow["ZipCode5"].ToString()
                    };
                    response.SimilarZipCodeList.Add(similarZipCodesItem);
                }
            }

            return View(response);
        }
        #endregion
    }
}