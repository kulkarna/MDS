using DataAccessLayerEntityFramework;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using UserInterfaceValidationExtensions;
using UtilityLogging;
using UtilityUnityLogging;
using Utilities;
using UtilityManagementRepository;

namespace UtilityManagement.Controllers
{
    [ValidateInputAttribute(false)]
    public class AuditServiceClassController : ControllerBaseWithoutUtilDropDown
    {
        #region private variables
        private Lp_UtilityManagementEntities db = new Lp_UtilityManagementEntities();
        //private ILogger _logger;
        private const string CLASS = "AuditServiceClassController";
        #endregion


        #region public constructors
        public AuditServiceClassController()
        {
            db = new Lp_UtilityManagementEntities();
            _logger = UnityLoggerGenerator.GenerateLogger();
        }
        #endregion


        #region actions
        ////
        //// GET: /AuditServiceClassController/
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
        //        return View(new List<usp_zAuditServiceClass_SELECT_Result>());
        //    }
        //}

        public override ActionResult GetBlankResponse()
        {
            return View(new List<usp_zAuditServiceClass_SELECT_Result>());
        }

        //
        // GET: /AuditServiceClassController/Details/5
        public ActionResult Details(Guid id)
        {
            usp_zAuditServiceClass_SELECT_Result usp_zAuditServiceClass_SELECT_Result = db.usp_zAuditServiceClass_SELECT().Where(x => x.Id == id).FirstOrDefault();
            if (usp_zAuditServiceClass_SELECT_Result == null)
            {
                return HttpNotFound();
            }
            return View(usp_zAuditServiceClass_SELECT_Result);
        }


        public ActionResult IdClick()
        {
            string method = "IdClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("Id");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult IdPrevClick()
        {
            string method = "IdPrevClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("IdPrev");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }


        public ActionResult UtilityCompanyIdClick()
        {
            string method = "UtilityCompanyIdClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("UtilityCompanyId");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult UtilityCompanyIdPrevClick()
        {
            string method = "UtilityCompanyIdPrevClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("UtilityCompanyIdPrev");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }


        public ActionResult UtilityCodeClick()
        {
            string method = "UtilityCodeClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("UtilityCode");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult UtilityCodePrevClick()
        {
            string method = "UtilityCodePrevClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("UtilityCodePrev");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }


        public ActionResult ServiceClassCodeClick()
        {
            string method = "ServiceClassCodeClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("ServiceClassCode");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult ServiceClassCodePrevClick()
        {
            string method = "ServiceClassCodePrevClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("ServiceClassCodePrev");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }


        public ActionResult DescriptionClick()
        {
            string method = "DescriptionClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("Description");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult DescriptionPrevClick()
        {
            string method = "DescriptionPrevClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("DescriptionPrev");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }


        public ActionResult AccountTypeIdClick()
        {
            string method = "AccountTypeIdClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("AccountTypeId");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult AccountTypeIdPrevClick()
        {
            string method = "AccountTypeIdPrevClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("AccountTypeIdPrev");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }


        public ActionResult AccountTypeNameClick()
        {
            string method = "AccountTypeNameClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("AccountTypeName");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult AccountTypeNamePrevClick()
        {
            string method = "AccountTypeNamePrevClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("AccountTypeNamePrev");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }


        public ActionResult LpStandardServiceClassClick()
        {
            string method = "LpStandardServiceClassClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("LpStandardServiceClass");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult LpStandardServiceClassPrevClick()
        {
            string method = "LpStandardServiceClassPrevClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("LpStandardServiceClassPrev");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }


        //public ActionResult InactiveTitleClick()
        //{
        //    string method = "InactiveTitleClick()";
        //    try
        //    {
        //        VerifyMessageIdAndErrorMessageSession();
        //        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

        //        var response = ManageSortationSession("Inactive");

        //        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

        //        return response;
        //    }
        //    catch (Exception exc)
        //    {
        //        ErrorHandler(exc, method);
        //        return RedirectToAction("Index");
        //    }
        //}

        public ActionResult InactivePrevClick()
        {
            string method = "InactivePrevClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("InactivePrev");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        //public ActionResult CreatedByTitleClick()
        //{
        //    string method = "CreatedByTitleClick()";
        //    try
        //    {
        //        VerifyMessageIdAndErrorMessageSession();
        //        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

        //        var response = ManageSortationSession("CreatedBy");

        //        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

        //        return response;
        //    }
        //    catch (Exception exc)
        //    {
        //        ErrorHandler(exc, method);
        //        return RedirectToAction("Index");
        //    }
        //}

        public ActionResult CreatedByPrevClick()
        {
            string method = "CreatedByPrevClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("CreatedByPrev");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        //public ActionResult CreatedDateTitleClick()
        //{
        //    string method = "CreatedDateTitleClick()";
        //    try
        //    {
        //        VerifyMessageIdAndErrorMessageSession();
        //        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

        //        var response = ManageSortationSession("CreatedDate");

        //        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

        //        return response;
        //    }
        //    catch (Exception exc)
        //    {
        //        ErrorHandler(exc, method);
        //        return RedirectToAction("Index");
        //    }
        //}

        public ActionResult CreatedDatePrevClick()
        {
            string method = "CreatedDatePrevClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("CreatedDatePrev");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        //public ActionResult LastModifiedByTitleClick()
        //{
        //    string method = "LastModifiedByTitleClick()";
        //    try
        //    {
        //        VerifyMessageIdAndErrorMessageSession();
        //        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

        //        var response = ManageSortationSession("LastModifiedBy");

        //        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

        //        return response;
        //    }
        //    catch (Exception exc)
        //    {
        //        ErrorHandler(exc, method);
        //        return RedirectToAction("Index");
        //    }
        //}

        public ActionResult LastModifiedByPrevClick()
        {
            string method = "LastModifiedByPrevClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("LastModifiedPrevBy");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        //public ActionResult LastModifiedDateTitleClick()
        //{
        //    string method = "LastModifiedDateTitleClick()";
        //    try
        //    {
        //        VerifyMessageIdAndErrorMessageSession();
        //        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

        //        var response = ManageSortationSession("LastModifiedDate");

        //        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

        //        return response;
        //    }
        //    catch (Exception exc)
        //    {
        //        ErrorHandler(exc, method);
        //        return RedirectToAction("Index");
        //    }
        //}

        public ActionResult LastModifiedDatePrevClick()
        {
            string method = "LastModifiedDateClickPrev()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("LastModifiedDatePrev");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult ChangeVersionClick()
        {
            string method = "ChangeVersionClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("ChangeVersionClick");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult CreationVersionClick()
        {
            string method = "CreationVersionClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("CreationVersionClick");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult ChangeOperationClick()
        {
            string method = "ChangeOperationClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("ChangeOperationClick");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult ChangeColumnsClick()
        {
            string method = "ChangeColumnsClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("ChangeColumnsClick");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }
        #endregion


        #region private methods
        protected override void Dispose(bool disposing)
        {
            db.Dispose();
            base.Dispose(disposing);
        }

        //private void VerifyMessageIdAndErrorMessageSession()
        //{
        //    Session[Common.ERRORMESSAGE] = string.Empty;
        //    if (Session[Common.MESSAGEID] == null || string.IsNullOrWhiteSpace(Session[Common.MESSAGEID].ToString()))
        //        Session[Common.MESSAGEID] = Guid.NewGuid().ToString();
        //}

        //private void ErrorHandler(Exception exc, string method)
        //{
        //    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2}  {3}", Common.NAMESPACE, CLASS, method, exc.Message), exc);
        //    _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2}  {3}", Common.NAMESPACE, CLASS, method, Common.END));
        //    Session[Common.ERRORMESSAGE] = exc == null ? "NULL EXCEPTION OBJECT" : exc.Message;
        //}

        //private ActionResult ManageSortationSession(string sortColumn)
        //{
        //    if (Session[Common.SORTCOLUMNNAME].ToString() == sortColumn && Session[Common.SORTDIRECTION].ToString() == Common.ASC)
        //        Session[Common.SORTDIRECTION] = Common.DESC;
        //    else
        //        Session[Common.SORTDIRECTION] = Common.ASC;
        //    Session[Common.SORTCOLUMNNAME] = sortColumn;
        //    return RedirectToAction("Index");
        //}

        private List<usp_zAuditServiceClass_SELECT_Result> ObtainResponse()
        {
            var response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.Id).ToList();
            if (Session[Common.SORTCOLUMNNAME] == null)
                Session[Common.SORTCOLUMNNAME] = "Id";
            if (Session[Common.SORTDIRECTION] == null)
                Session[Common.SORTDIRECTION] = Common.ASC;
            switch (Session[Common.SORTCOLUMNNAME].ToString())
            {
                case "Id":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.Id).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.Id).ToList();
                    break;
                case "IdPrev":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.IdPrevious).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.IdPrevious).ToList();
                    break;
                case "UtilityCompanyId":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.UtilityCompanyId).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.UtilityCode).ToList();
                    break;
                case "UtilityCompanyIdPrev":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.UtilityCompanyIdPrevious).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.UtilityCompanyIdPrevious).ToList();
                    break;
                case "UtilityCode":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.UtilityCode).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.UtilityCode).ToList();
                    break;
                case "UtilityCodePrev":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.UtilityCodePrevious).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.UtilityCodePrevious).ToList();
                    break;
                case "ServiceClassCode":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.ServiceClassCode).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.ServiceClassCode).ToList();
                    break;
                case "ServiceClassCodePrevious":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.ServiceClassCodePrevious).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.ServiceClassCodePrevious).ToList();
                    break;
                case "Description":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.Description).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.Description).ToList();
                    break;
                case "DescriptionPrevious":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.DescriptionPrevious).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.DescriptionPrevious).ToList();
                    break;
                case "AccountTypeId":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.AccountTypeId).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.AccountTypeId).ToList();
                    break;
                case "AccountTypeIdPrevious":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.AccountTypeIdPrevious).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.AccountTypeIdPrevious).ToList();
                    break;
                case "AccountTypeName":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.AccountTypeName).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.AccountTypeName).ToList();
                    break;
                case "AccountTypeNamePrevious":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.AccountTypeNamePrevious).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.AccountTypeNamePrevious).ToList();
                    break;
                case "LpStandardServiceClass":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.LpStandardServiceClass).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.LpStandardServiceClass).ToList();
                    break;
                case "LpStandardServiceClassPrevious":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.LpStandardServiceClassPrevious).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.LpStandardServiceClassPrevious).ToList();
                    break;
                case "Inactive":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.Inactive).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.Inactive).ToList();
                    break;
                case "InactivePrev":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.InactivePrevious).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.InactivePrevious).ToList();
                    break;
                case "CreatedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.CreatedBy).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.CreatedBy).ToList();
                    break;
                case "CreatedByPrev":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.CreatedByPrevious).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.CreatedByPrevious).ToList();
                    break;
                case "CreatedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.CreatedDate).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.CreatedDate).ToList();
                    break;
                case "CreatedDatePrev":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.CreatedDatePrevious).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.CreatedDatePrevious).ToList();
                    break;
                case "LastModifiedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.LastModifiedBy).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.LastModifiedBy).ToList();
                    break;
                case "LastModifiedByPrev":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.LastModifiedByPrevious).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.LastModifiedByPrevious).ToList();
                    break;
                case "LastModifiedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.LastModifiedDate).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.LastModifiedDate).ToList();
                    break;
                case "LastModifiedDatePrev":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.LastModifiedDatePrevious).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.LastModifiedDatePrevious).ToList();
                    break;
                case "ChangeVersionClick":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.SYS_CHANGE_VERSION).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.SYS_CHANGE_VERSION).ToList();
                    break;
                case "CreationVersionClick":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.SYS_CHANGE_CREATION_VERSION).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.SYS_CHANGE_CREATION_VERSION).ToList();
                    break;
                case "ChangeOperationClick":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.SYS_CHANGE_OPERATION).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.SYS_CHANGE_OPERATION).ToList();
                    break;
                case "ChangeColumnsClick":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.SYS_CHANGE_COLUMNS).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.SYS_CHANGE_COLUMNS).ToList();
                    break;
            }
            return response;
        }

        public override ActionResult ObtainActionResult()
        {
            var response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.Id).ToList();
            if (Session[Common.SORTCOLUMNNAME] == null)
                Session[Common.SORTCOLUMNNAME] = "Id";
            if (Session[Common.SORTDIRECTION] == null)
                Session[Common.SORTDIRECTION] = Common.ASC;
            switch (Session[Common.SORTCOLUMNNAME].ToString())
            {
                case "Id":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.Id).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.Id).ToList();
                    break;
                case "IdPrev":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.IdPrevious).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.IdPrevious).ToList();
                    break;
                case "UtilityCompanyId":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.UtilityCompanyId).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.UtilityCode).ToList();
                    break;
                case "UtilityCompanyIdPrev":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.UtilityCompanyIdPrevious).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.UtilityCompanyIdPrevious).ToList();
                    break;
                case "UtilityCode":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.UtilityCode).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.UtilityCode).ToList();
                    break;
                case "UtilityCodePrev":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.UtilityCodePrevious).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.UtilityCodePrevious).ToList();
                    break;
                case "ServiceClassCode":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.ServiceClassCode).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.ServiceClassCode).ToList();
                    break;
                case "ServiceClassCodePrevious":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.ServiceClassCodePrevious).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.ServiceClassCodePrevious).ToList();
                    break;
                case "Description":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.Description).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.Description).ToList();
                    break;
                case "DescriptionPrevious":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.DescriptionPrevious).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.DescriptionPrevious).ToList();
                    break;
                case "AccountTypeId":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.AccountTypeId).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.AccountTypeId).ToList();
                    break;
                case "AccountTypeIdPrevious":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.AccountTypeIdPrevious).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.AccountTypeIdPrevious).ToList();
                    break;
                case "AccountTypeName":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.AccountTypeName).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.AccountTypeName).ToList();
                    break;
                case "AccountTypeNamePrevious":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.AccountTypeNamePrevious).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.AccountTypeNamePrevious).ToList();
                    break;
                case "LpStandardServiceClass":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.LpStandardServiceClass).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.LpStandardServiceClass).ToList();
                    break;
                case "LpStandardServiceClassPrevious":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.LpStandardServiceClassPrevious).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.LpStandardServiceClassPrevious).ToList();
                    break;
                case "Inactive":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.Inactive).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.Inactive).ToList();
                    break;
                case "InactivePrev":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.InactivePrevious).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.InactivePrevious).ToList();
                    break;
                case "CreatedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.CreatedBy).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.CreatedBy).ToList();
                    break;
                case "CreatedByPrev":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.CreatedByPrevious).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.CreatedByPrevious).ToList();
                    break;
                case "CreatedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.CreatedDate).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.CreatedDate).ToList();
                    break;
                case "CreatedDatePrev":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.CreatedDatePrevious).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.CreatedDatePrevious).ToList();
                    break;
                case "LastModifiedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.LastModifiedBy).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.LastModifiedBy).ToList();
                    break;
                case "LastModifiedByPrev":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.LastModifiedByPrevious).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.LastModifiedByPrevious).ToList();
                    break;
                case "LastModifiedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.LastModifiedDate).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.LastModifiedDate).ToList();
                    break;
                case "LastModifiedDatePrev":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.LastModifiedDatePrevious).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.LastModifiedDatePrevious).ToList();
                    break;
                case "ChangeVersionClick":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.SYS_CHANGE_VERSION).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.SYS_CHANGE_VERSION).ToList();
                    break;
                case "CreationVersionClick":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.SYS_CHANGE_CREATION_VERSION).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.SYS_CHANGE_CREATION_VERSION).ToList();
                    break;
                case "ChangeOperationClick":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.SYS_CHANGE_OPERATION).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.SYS_CHANGE_OPERATION).ToList();
                    break;
                case "ChangeColumnsClick":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = db.usp_zAuditServiceClass_SELECT().OrderByDescending(x => x.SYS_CHANGE_COLUMNS).ToList();
                    else
                        response = db.usp_zAuditServiceClass_SELECT().OrderBy(x => x.SYS_CHANGE_COLUMNS).ToList();
                    break;
            }
            return View(response);
        }
        #endregion
    }
}