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
    public class AuditAccountInfoFieldRequiredController : ControllerBaseWithoutUtilDropDown
    {
        #region private variables
        private const string CLASS = "AuditAccountInfoFieldRequiredController";
        #endregion


        #region public constructors
        public AuditAccountInfoFieldRequiredController() : base()
        {
            ViewBag.PageName = "AuditAccountInfoFieldRequired";
            ViewBag.IndexPageName = "AccountInfoFieldRequired";
            ViewBag.PageDisplayName = "Audit Account Info Field Required";
        }
        #endregion


        #region actions
        //
        // GET: /AuditAccountInfoFieldRequiredController/
        public ActionResult Index()
        {
            string method = "Index()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ObtainResponse();

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));
                return View(response);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new List<usp_zAuditAccountInfoFieldRequired_SELECT_Result>());
            }
        }

        public override ActionResult GetBlankResponse()
        {
            return View(new List<usp_zAuditAccountInfoFieldRequired_SELECT_Result>());
        }

        //
        // GET: /AuditLoadProfileController/Details/5
        public ActionResult Details(Guid id)
        {
            usp_zAuditAccountInfoFieldRequired_SELECT_Result usp_zAuditAccountInfoFieldRequired_SELECT_Result = _db.usp_zAuditAccountInfoFieldRequired_SELECT().Where(x => x.Id == id).FirstOrDefault();
            if (usp_zAuditAccountInfoFieldRequired_SELECT_Result == null)
            {
                return HttpNotFound();
            }
            return View(usp_zAuditAccountInfoFieldRequired_SELECT_Result);
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


        public ActionResult AccountInfoFieldIdClick()
        {
            string method = "AccountInfoFieldIdClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("AccountInfoFieldId");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult AccountInfoFieldIdPrevClick()
        {
            string method = "LoadProfileCodePrevClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("AccountInfoFieldIdPrev");

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


        public ActionResult NameMachineUnfriendlyClick()
        {
            string method = "NameMachineUnfriendlyClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("NameMachineUnfriendly");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult NameMachineUnfriendlyPreviousClick()
        {
            string method = "NameMachineUnfriendlyPreviousClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("NameMachineUnfriendlyPrevious");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult NameUserFriendlyClick()
        {
            string method = "NameUserFriendlyClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("NameUserFriendly");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }


        public ActionResult NameUserFriendlyPreviousClick()
        {
            string method = "NameUserFriendlyPreviousClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("NameUserFriendlyPrevious");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult IsRequiredClick()
        {
            string method = "IsRequiredClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("IsRequired");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult IsRequiredPreviousClick()
        {
            string method = "IsRequiredPreviousClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("IsRequiredPrevious");

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
            _db.Dispose();
            base.Dispose(disposing);
        }


        public override ActionResult ObtainActionResult()
        { 
            var response = _db.usp_zAuditAccountInfoFieldRequired_SELECT().OrderBy(x => x.Id).ToList();
            if (Session[Common.SORTCOLUMNNAME] == null)
                Session[Common.SORTCOLUMNNAME] = "Id";
            if (Session[Common.SORTDIRECTION] == null)
                Session[Common.SORTDIRECTION] = Common.ASC;
            switch (Session[Common.SORTCOLUMNNAME].ToString())
            {
                case "Id":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.Id).ToList();
                    else
                        response = response.OrderBy(x => x.Id).ToList();
                    break;
                case "IdPrev":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.IdPrevious).ToList();
                    else
                        response = response.OrderBy(x => x.IdPrevious).ToList();
                    break;
                case "UtilityCompanyId":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.UtilityCompanyId).ToList();
                    else
                        response = response.OrderBy(x => x.UtilityCode).ToList();
                    break;
                case "UtilityCompanyIdPrev":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.UtilityCompanyIdPrevious).ToList();
                    else
                        response = response.OrderBy(x => x.UtilityCompanyIdPrevious).ToList();
                    break;
                case "UtilityCode":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.UtilityCode).ToList();
                    else
                        response = response.OrderBy(x => x.UtilityCode).ToList();
                    break;
                case "UtilityCodePrev":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.UtilityCodePrevious).ToList();
                    else
                        response = response.OrderBy(x => x.UtilityCodePrevious).ToList();
                    break;
                case "AccountInfoFieldId":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.AccountInfoFieldId).ToList();
                    else
                        response = response.OrderBy(x => x.AccountInfoFieldId).ToList();
                    break;
                case "AccountInfoFieldIdPrevious":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.AccountInfoFieldIdPrevious).ToList();
                    else
                        response = response.OrderBy(x => x.AccountInfoFieldIdPrevious).ToList();
                    break;
                case "NameMachineUnfriendly":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.NameMachineUnfriendly).ToList();
                    else
                        response = response.OrderBy(x => x.NameMachineUnfriendly).ToList();
                    break;
                case "NameMachineUnfriendlyPrevious":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.NameMachineUnfriendlyPrevious).ToList();
                    else
                        response = response.OrderBy(x => x.NameMachineUnfriendlyPrevious).ToList();
                    break;
                case "NameUserFriendly":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.NameUserFriendly).ToList();
                    else
                        response = response.OrderBy(x => x.NameUserFriendly).ToList();
                    break;
                case "NameUserFriendlyPrevious":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.NameUserFriendlyPrevious).ToList();
                    else
                        response = response.OrderBy(x => x.NameUserFriendlyPrevious).ToList();
                    break;
                case "IsRequired":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.IsRequired).ToList();
                    else
                        response = response.OrderBy(x => x.IsRequired).ToList();
                    break;
                case "IsRequiredPrevious":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.IsRequiredPrevious).ToList();
                    else
                        response = response.OrderBy(x => x.IsRequiredPrevious).ToList();
                    break;
                case "Description":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.Description).ToList();
                    else
                        response = response.OrderBy(x => x.Description).ToList();
                    break;
                case "DescriptionPrevious":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.DescriptionPrevious).ToList();
                    else
                        response = response.OrderBy(x => x.DescriptionPrevious).ToList();
                    break;
                case "Inactive":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.Inactive).ToList();
                    else
                        response = response.OrderBy(x => x.Inactive).ToList();
                    break;
                case "InactivePrev":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.InactivePrevious).ToList();
                    else
                        response = response.OrderBy(x => x.InactivePrevious).ToList();
                    break;
                case "CreatedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.CreatedBy).ToList();
                    else
                        response = response.OrderBy(x => x.CreatedBy).ToList();
                    break;
                case "CreatedByPrev":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.CreatedByPrevious).ToList();
                    else
                        response = response.OrderBy(x => x.CreatedByPrevious).ToList();
                    break;
                case "CreatedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.CreatedDate).ToList();
                    else
                        response = response.OrderBy(x => x.CreatedDate).ToList();
                    break;
                case "CreatedDatePrev":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.CreatedDatePrevious).ToList();
                    else
                        response = response.OrderBy(x => x.CreatedDatePrevious).ToList();
                    break;
                case "LastModifiedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.LastModifiedBy).ToList();
                    else
                        response = response.OrderBy(x => x.LastModifiedBy).ToList();
                    break;
                case "LastModifiedByPrev":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.LastModifiedByPrevious).ToList();
                    else
                        response = response.OrderBy(x => x.LastModifiedByPrevious).ToList();
                    break;
                case "LastModifiedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.LastModifiedDate).ToList();
                    else
                        response = response.OrderBy(x => x.LastModifiedDate).ToList();
                    break;
                case "LastModifiedDatePrev":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.LastModifiedDatePrevious).ToList();
                    else
                        response = response.OrderBy(x => x.LastModifiedDatePrevious).ToList();
                    break;
                case "ChangeVersionClick":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.SYS_CHANGE_VERSION).ToList();
                    else
                        response = response.OrderBy(x => x.SYS_CHANGE_VERSION).ToList();
                    break;
                case "CreationVersionClick":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.SYS_CHANGE_CREATION_VERSION).ToList();
                    else
                        response = response.OrderBy(x => x.SYS_CHANGE_CREATION_VERSION).ToList();
                    break;
                case "ChangeOperationClick":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.SYS_CHANGE_OPERATION).ToList();
                    else
                        response = response.OrderBy(x => x.SYS_CHANGE_OPERATION).ToList();
                    break;
                case "ChangeColumnsClick":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.SYS_CHANGE_COLUMNS).ToList();
                    else
                        response = response.OrderBy(x => x.SYS_CHANGE_COLUMNS).ToList();
                    break;
            }
            return View(response);
        }

        private List<usp_zAuditAccountInfoFieldRequired_SELECT_Result> ObtainResponse()
        {
            var response = _db.usp_zAuditAccountInfoFieldRequired_SELECT().OrderBy(x => x.Id).ToList();
            if (Session[Common.SORTCOLUMNNAME] == null)
                Session[Common.SORTCOLUMNNAME] = "Id";
            if (Session[Common.SORTDIRECTION] == null)
                Session[Common.SORTDIRECTION] = Common.ASC;
            switch (Session[Common.SORTCOLUMNNAME].ToString())
            {
                case "Id":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.Id).ToList();
                    else
                        response = response.OrderBy(x => x.Id).ToList();
                    break;
                case "IdPrev":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.IdPrevious).ToList();
                    else
                        response = response.OrderBy(x => x.IdPrevious).ToList();
                    break;
                case "UtilityCompanyId":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.UtilityCompanyId).ToList();
                    else
                        response = response.OrderBy(x => x.UtilityCode).ToList();
                    break;
                case "UtilityCompanyIdPrev":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.UtilityCompanyIdPrevious).ToList();
                    else
                        response = response.OrderBy(x => x.UtilityCompanyIdPrevious).ToList();
                    break;
                case "UtilityCode":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.UtilityCode).ToList();
                    else
                        response = response.OrderBy(x => x.UtilityCode).ToList();
                    break;
                case "UtilityCodePrev":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.UtilityCodePrevious).ToList();
                    else
                        response = response.OrderBy(x => x.UtilityCodePrevious).ToList();
                    break;
                case "AccountInfoFieldId":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.AccountInfoFieldId).ToList();
                    else
                        response = response.OrderBy(x => x.AccountInfoFieldId).ToList();
                    break;
                case "AccountInfoFieldIdPrevious":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.AccountInfoFieldIdPrevious).ToList();
                    else
                        response = response.OrderBy(x => x.AccountInfoFieldIdPrevious).ToList();
                    break;
                case "NameMachineUnfriendly":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.NameMachineUnfriendly).ToList();
                    else
                        response = response.OrderBy(x => x.NameMachineUnfriendly).ToList();
                    break;
                case "NameMachineUnfriendlyPrevious":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.NameMachineUnfriendlyPrevious).ToList();
                    else
                        response = response.OrderBy(x => x.NameMachineUnfriendlyPrevious).ToList();
                    break;
                case "NameUserFriendly":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.NameUserFriendly).ToList();
                    else
                        response = response.OrderBy(x => x.NameUserFriendly).ToList();
                    break;
                case "NameUserFriendlyPrevious":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.NameUserFriendlyPrevious).ToList();
                    else
                        response = response.OrderBy(x => x.NameUserFriendlyPrevious).ToList();
                    break;
                case "IsRequired":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.IsRequired).ToList();
                    else
                        response = response.OrderBy(x => x.IsRequired).ToList();
                    break;
                case "IsRequiredPrevious":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.IsRequiredPrevious).ToList();
                    else
                        response = response.OrderBy(x => x.IsRequiredPrevious).ToList();
                    break;
                case "Description":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.Description).ToList();
                    else
                        response = response.OrderBy(x => x.Description).ToList();
                    break;
                case "DescriptionPrevious":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.DescriptionPrevious).ToList();
                    else
                        response = response.OrderBy(x => x.DescriptionPrevious).ToList();
                    break;
                case "Inactive":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.Inactive).ToList();
                    else
                        response = response.OrderBy(x => x.Inactive).ToList();
                    break;
                case "InactivePrev":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.InactivePrevious).ToList();
                    else
                        response = response.OrderBy(x => x.InactivePrevious).ToList();
                    break;
                case "CreatedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.CreatedBy).ToList();
                    else
                        response = response.OrderBy(x => x.CreatedBy).ToList();
                    break;
                case "CreatedByPrev":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.CreatedByPrevious).ToList();
                    else
                        response = response.OrderBy(x => x.CreatedByPrevious).ToList();
                    break;
                case "CreatedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.CreatedDate).ToList();
                    else
                        response = response.OrderBy(x => x.CreatedDate).ToList();
                    break;
                case "CreatedDatePrev":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.CreatedDatePrevious).ToList();
                    else
                        response = response.OrderBy(x => x.CreatedDatePrevious).ToList();
                    break;
                case "LastModifiedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.LastModifiedBy).ToList();
                    else
                        response = response.OrderBy(x => x.LastModifiedBy).ToList();
                    break;
                case "LastModifiedByPrev":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.LastModifiedByPrevious).ToList();
                    else
                        response = response.OrderBy(x => x.LastModifiedByPrevious).ToList();
                    break;
                case "LastModifiedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.LastModifiedDate).ToList();
                    else
                        response = response.OrderBy(x => x.LastModifiedDate).ToList();
                    break;
                case "LastModifiedDatePrev":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.LastModifiedDatePrevious).ToList();
                    else
                        response = response.OrderBy(x => x.LastModifiedDatePrevious).ToList();
                    break;
                case "ChangeVersionClick":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.SYS_CHANGE_VERSION).ToList();
                    else
                        response = response.OrderBy(x => x.SYS_CHANGE_VERSION).ToList();
                    break;
                case "CreationVersionClick":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.SYS_CHANGE_CREATION_VERSION).ToList();
                    else
                        response = response.OrderBy(x => x.SYS_CHANGE_CREATION_VERSION).ToList();
                    break;
                case "ChangeOperationClick":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.SYS_CHANGE_OPERATION).ToList();
                    else
                        response = response.OrderBy(x => x.SYS_CHANGE_OPERATION).ToList();
                    break;
                case "ChangeColumnsClick":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.SYS_CHANGE_COLUMNS).ToList();
                    else
                        response = response.OrderBy(x => x.SYS_CHANGE_COLUMNS).ToList();
                    break;
            }
            return response;
        }
        #endregion
    }
}