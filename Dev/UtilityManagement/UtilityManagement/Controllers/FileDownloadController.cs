using CuteWebUI;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Web.Mvc;
using System.Web.UI.WebControls;
using UtilityManagement.Models;

namespace UtilityManagement.Controllers
{
    public class FileDownloadController : ControllerBase
    {
        FileDownloadModel downloadFiles = new FileDownloadModel();
        const string TEXT_CSV = "text/csv";
        const string UTILITY_COMPANIES_CSV = "UtilityCompanies.csv";
        const string STRATA_PATTERNS_CSV = "StrataPatterns.csv";
        const string SERVICE_ADDRESS_ZIP_PATTERNS_CSV = "ServiceAddressZipPatterns.csv";
        const string SERVICE_ACCOUNT_PATTERNS_CSV = "ServiceAccountPatterns.csv";
        const string REQUEST_MODE_IDR_CSV = "RequestModeIdr.csv";
        const string REQUEST_MODE_ICAP_CSV = "RequestModeICap.csv";
        const string REQUEST_MODE_HISTORICAL_USAGE_CSV = "RequestModeHistoricalUsage.csv";
        const string NAME_KEY_PATTERNS_CSV = "NameKeyPatterns.csv";
        const string METER_NUMBER_PATTERNS_CSV = "MeterNumberPatterns.csv";
        const string ICAP_TCAP_REFRESH_CSV = "ICapTCapRefresh.csv";
        const string BILLING_ACCOUNT_PATTERNS_CSV = "BillingAccountPatterns.csv";


        //
        // GET: /DownloadFiles/

        public ActionResult Index()
        {
            var files = downloadFiles.GetFiles();
            using (CuteWebUI.MvcUploader uploader = new CuteWebUI.MvcUploader(System.Web.HttpContext.Current))
            {
                uploader.UploadUrl = Response.ApplyAppPathModifier("~/UploadHandler.ashx");
                uploader.Name = "myuploader";
                uploader.AllowedFileExtensions = "*.jpg,*.gif,*.png,*.bmp,*.zip,*.rar";
                uploader.InsertText = "Select a file to upload";
                ViewData["uploaderhtml"] = uploader.Render();
            }
            return View(files);
        }

        private ActionResult ProcessDownloadData(List<string> dataList, string fileName)
        {
            StringBuilder result = new StringBuilder();
            foreach (string row in dataList)
            {
                result.AppendLine(row);
            }
            var data = Encoding.UTF8.GetBytes(result.ToString());
            return File(data, TEXT_CSV, fileName);
        }

        public ActionResult Download(string id)
        {
            switch (id)
            {
                case "1":
                    return ProcessDownloadData(_db.usp_DownloadData_UtilityCompany().ToList(), UTILITY_COMPANIES_CSV);
                case "2":
                    return ProcessDownloadData(_db.usp_DownloadData_StrataPattern().ToList(), STRATA_PATTERNS_CSV);
                case "3":
                    return ProcessDownloadData(_db.usp_DownloadData_ServiceAddressZipPattern().ToList(), SERVICE_ADDRESS_ZIP_PATTERNS_CSV);
                case "4":
                    return ProcessDownloadData(_db.usp_DownloadData_ServiceAccountPattern().ToList(), SERVICE_ACCOUNT_PATTERNS_CSV);
                case "5":
                    return ProcessDownloadData(_db.usp_DownloadData_RequestModeIdr().ToList(), REQUEST_MODE_IDR_CSV);
                case "6":
                    return ProcessDownloadData(_db.usp_DownloadData_RequestModeICap().ToList(), REQUEST_MODE_ICAP_CSV);
                case "7":
                    return ProcessDownloadData(_db.usp_DownloadData_RequestModeHistoricalUsage().ToList(), REQUEST_MODE_HISTORICAL_USAGE_CSV);
                case "8":
                    return ProcessDownloadData(_db.usp_DownloadData_NameKeyPattern().ToList(), NAME_KEY_PATTERNS_CSV);
                case "9":
                    return ProcessDownloadData(_db.usp_DownloadData_MeterNumberPattern().ToList(), METER_NUMBER_PATTERNS_CSV);
                case "10":
                    return ProcessDownloadData(_db.usp_DownloadData_ICapTCapRefresh().ToList(), ICAP_TCAP_REFRESH_CSV);
                case "11":
                    return ProcessDownloadData(_db.usp_DownloadData_BillingAccountPattern().ToList(), BILLING_ACCOUNT_PATTERNS_CSV);
            }
            return null;
        }

        public ActionResult Start_uploading_manually(string myuploader)
        {
            using (MvcUploader uploader = new MvcUploader(System.Web.HttpContext.Current))
            {
                uploader.UploadUrl = Response.ApplyAppPathModifier("~/UploadHandler.ashx");
                //the data of the uploader will render as <input type='hidden' name='myuploader'> 
                uploader.Name = "myuploader";
                uploader.AllowedFileExtensions = "*.jpg,*.gif,*.png,*.bmp,*.zip,*.rar";
                uploader.MaxSizeKB = 1024;
                uploader.ManualStartUpload = true;
                uploader.InsertText = "Browse Files (Max 1M)";

                //prepair html code for the view
                ViewData["uploaderhtml"] = uploader.Render();

                //if it's HTTP POST:
                if (!string.IsNullOrEmpty(myuploader))
                {
                    //for single file , the value is guid string
                    Guid fileguid = new Guid(myuploader);
                    MvcUploadFile file = uploader.GetUploadedFile(fileguid);
                    if (file != null)
                    {

                        string s = string.Empty;

                        //you should validate it here:
                        //now the file is in temporary directory, you need move it to target location
                        //file.MoveTo("~/myfolder/" + file.FileName);
                        //set the output message
                        ViewData["UploadedMessage"] = "The file " + file.FileName + " has been processed.";
                    }
                }
            }
            return View();
        }

    }
}
