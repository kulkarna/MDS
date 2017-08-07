using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Mvc;
using SmucRunBusinessLayer;
using SmucRunDataAccessLayer;

using UtilityLogging;
using UtilityUnityLogging;
using Utilities;

namespace SmucEdiScraperAccountLookup.Controllers
{
    public class ScraperController : Controller
    {
        #region private variables
        private const string NAMESPACE = "SmucEdiScraperAccountLookup.Controllers";
        private const string CLASS = "ScraperController";

        private ILogger _logger = null;
        private IBusinessLayer _businessLayer = null;
        private IDal _dal = null;
        #endregion


        #region public constructors
        public ScraperController()
        {
            string messageId = Guid.NewGuid().ToString();
            string method = "ScraperController()";
            try
            {
                _logger = UnityLoggerGenerator.GenerateLogger();
                _dal = new Dal(messageId, _logger);
                _businessLayer = new BusinessLayer(messageId, _logger, _dal);
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
            }
        }
        #endregion


        #region public methods
        [AllowAnonymous]
        public ActionResult Index(string messageId)
        {
            string method = "Index(messageId)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                ViewBag.Message = "SMUC Scraper";

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                return View();
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                return View("Error");
            }
        }

        [AllowAnonymous]
        [HttpPost]
        public ActionResult Index()
        {
            string messageId = Guid.NewGuid().ToString();
            string method = "Index() [HttpPost]";
            DateTime beginDate = DateTime.Now;
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (Request != null && Request.Files != null && Request.Files.Count > 0 && Request.Files[0] != null)
                {
                    HttpPostedFileBase file = Request.Files[0];
                    BinaryReader binaryReader = new BinaryReader(file.InputStream);
                    byte[] byteArray = binaryReader.ReadBytes((int)file.InputStream.Length);

                    _businessLayer.BulkScraperRequest(messageId, byteArray);

                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} TimeElapsed:{3} return View() END", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginDate).Milliseconds.ToString()));
                return View();
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                return View("Error");
            }
        }
        #endregion
    }
}
