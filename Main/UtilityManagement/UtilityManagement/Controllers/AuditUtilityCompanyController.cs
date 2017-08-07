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
    public class AuditUtilityCompanyController : ControllerBaseWithoutUtilDropDown
    {
        #region private variables
        private const string CLASS = "AuditUtilityCompanyController";
        #endregion


        #region public constructors
        public AuditUtilityCompanyController() : base()
        {
            ViewBag.PageName = "AuditUtilityCompany";
            ViewBag.IndexPageName = "AuditUtilityCompany";
            ViewBag.PageDisplayName = "Audit Utility Company";
        }
        #endregion


        #region actions
        ////
        //// GET: /AuditUtilityCompany/
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
        //        return View(new List<zAuditUtilityCompany>());
        //    }
        //}

        public override ActionResult GetBlankResponse()
        {
            return View(new List<zAuditUtilityCompany>());
        }
        //
        // GET: /AuditUtilityCompany/Details/5
        public ActionResult Details(Guid id)
        {
            zAuditUtilityCompany zauditutilitycompany = _db.zAuditUtilityCompanies.Find(id);
            if (zauditutilitycompany == null)
            {
                return HttpNotFound();
            }
            return View(zauditutilitycompany);
        }

        //
        // GET: /AuditUtilityCompany/Create
        public ActionResult Create()
        {
            return View();
        }

        //
        // POST: /AuditUtilityCompany/Create
        [HttpPost]
        public ActionResult Create(zAuditUtilityCompany zauditutilitycompany)
        {
            if (ModelState.IsValid)
            {
                zauditutilitycompany.Id = Guid.NewGuid();
                _db.zAuditUtilityCompanies.Add(zauditutilitycompany);
                _db.SaveChanges();
                return RedirectToAction("Index");
            }

            return View(zauditutilitycompany);
        }

        //
        // GET: /AuditUtilityCompany/Edit/5
        public ActionResult Edit(Guid id)
        {
            zAuditUtilityCompany zauditutilitycompany = _db.zAuditUtilityCompanies.Find(id);
            if (zauditutilitycompany == null)
            {
                return HttpNotFound();
            }
            return View(zauditutilitycompany);
        }

        //
        // POST: /AuditUtilityCompany/Edit/5
        [HttpPost]
        public ActionResult Edit(zAuditUtilityCompany zauditutilitycompany)
        {
            if (ModelState.IsValid)
            {
                _db.Entry(zauditutilitycompany).State = EntityState.Modified;
                _db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(zauditutilitycompany);
        }

        //
        // GET: /AuditUtilityCompany/Delete/5
        public ActionResult Delete(Guid id)
        {
            zAuditUtilityCompany zauditutilitycompany = _db.zAuditUtilityCompanies.Find(id);
            if (zauditutilitycompany == null)
            {
                return HttpNotFound();
            }
            return View(zauditutilitycompany);
        }

        //
        // POST: /AuditUtilityCompany/Delete/5
        [HttpPost, ActionName("Delete")]
        public ActionResult DeleteConfirmed(Guid id)
        {
            zAuditUtilityCompany zauditutilitycompany = _db.zAuditUtilityCompanies.Find(id);
            _db.zAuditUtilityCompanies.Remove(zauditutilitycompany);
            _db.SaveChanges();
            return RedirectToAction("Index");
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

        private List<zAuditUtilityCompany> ObtainResponse()
        {
            var response = _db.zAuditUtilityCompanies.OrderBy(x => x.Id).ToList();
            if (Session[Common.SORTCOLUMNNAME] == null)
                Session[Common.SORTCOLUMNNAME] = "Id";
            if (Session[Common.SORTDIRECTION] == null)
                Session[Common.SORTDIRECTION] = Common.ASC;
            switch (Session[Common.SORTCOLUMNNAME].ToString())
            {
                case "Id":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.zAuditUtilityCompanies.OrderByDescending(x => x.Id).ToList();
                    else
                        response = _db.zAuditUtilityCompanies.OrderBy(x => x.Id).ToList();
                    break;
                case "IdPrev":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.zAuditUtilityCompanies.OrderByDescending(x => x.IdPrevious).ToList();
                    else
                        response = _db.zAuditUtilityCompanies.OrderBy(x => x.IdPrevious).ToList();
                    break;
                case "UtilityCode":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.zAuditUtilityCompanies.OrderByDescending(x => x.UtilityCode).ToList();
                    else
                        response = _db.zAuditUtilityCompanies.OrderBy(x => x.UtilityCode).ToList();
                    break;
                case "UtilityCodePrev":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.zAuditUtilityCompanies.OrderByDescending(x => x.UtilityCodePrevious).ToList();
                    else
                        response = _db.zAuditUtilityCompanies.OrderBy(x => x.UtilityCodePrevious).ToList();
                    break;
                case "Inactive":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.zAuditUtilityCompanies.OrderByDescending(x => x.Inactive).ToList();
                    else
                        response = _db.zAuditUtilityCompanies.OrderBy(x => x.Inactive).ToList();
                    break;
                case "InactivePrev":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.zAuditUtilityCompanies.OrderByDescending(x => x.InactivePrevious).ToList();
                    else
                        response = _db.zAuditUtilityCompanies.OrderBy(x => x.InactivePrevious).ToList();
                    break;
                case "CreatedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.zAuditUtilityCompanies.OrderByDescending(x => x.CreatedBy).ToList();
                    else
                        response = _db.zAuditUtilityCompanies.OrderBy(x => x.CreatedBy).ToList();
                    break;
                case "CreatedByPrev":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.zAuditUtilityCompanies.OrderByDescending(x => x.CreatedByPrevious).ToList();
                    else
                        response = _db.zAuditUtilityCompanies.OrderBy(x => x.CreatedByPrevious).ToList();
                    break;
                case "CreatedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.zAuditUtilityCompanies.OrderByDescending(x => x.CreatedDate).ToList();
                    else
                        response = _db.zAuditUtilityCompanies.OrderBy(x => x.CreatedDate).ToList();
                    break;
                case "CreatedDatePrev":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.zAuditUtilityCompanies.OrderByDescending(x => x.CreatedDatePrevious).ToList();
                    else
                        response = _db.zAuditUtilityCompanies.OrderBy(x => x.CreatedDatePrevious).ToList();
                    break;
                case "LastModifiedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.zAuditUtilityCompanies.OrderByDescending(x => x.LastModifiedBy).ToList();
                    else
                        response = _db.zAuditUtilityCompanies.OrderBy(x => x.LastModifiedBy).ToList();
                    break;
                case "LastModifiedByPrev":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.zAuditUtilityCompanies.OrderByDescending(x => x.LastModifiedByPrevious).ToList();
                    else
                        response = _db.zAuditUtilityCompanies.OrderBy(x => x.LastModifiedByPrevious).ToList();
                    break;
                case "LastModifiedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.zAuditUtilityCompanies.OrderByDescending(x => x.LastModifiedDate).ToList();
                    else
                        response = _db.zAuditUtilityCompanies.OrderBy(x => x.LastModifiedDate).ToList();
                    break;
                case "LastModifiedDatePrev":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.zAuditUtilityCompanies.OrderByDescending(x => x.LastModifiedDatePrevious).ToList();
                    else
                        response = _db.zAuditUtilityCompanies.OrderBy(x => x.LastModifiedDatePrevious).ToList();
                    break;
                case "ChangeVersionClick":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.zAuditUtilityCompanies.OrderByDescending(x => x.SYS_CHANGE_VERSION).ToList();
                    else
                        response = _db.zAuditUtilityCompanies.OrderBy(x => x.SYS_CHANGE_VERSION).ToList();
                    break;
                case "CreationVersionClick":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.zAuditUtilityCompanies.OrderByDescending(x => x.SYS_CHANGE_CREATION_VERSION).ToList();
                    else
                        response = _db.zAuditUtilityCompanies.OrderBy(x => x.SYS_CHANGE_CREATION_VERSION).ToList();
                    break;
                case "ChangeOperationClick":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.zAuditUtilityCompanies.OrderByDescending(x => x.SYS_CHANGE_OPERATION).ToList();
                    else
                        response = _db.zAuditUtilityCompanies.OrderBy(x => x.SYS_CHANGE_OPERATION).ToList();
                    break;
                case "ChangeColumnsClick":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.zAuditUtilityCompanies.OrderByDescending(x => x.SYS_CHANGE_COLUMNS).ToList();
                    else
                        response = _db.zAuditUtilityCompanies.OrderBy(x => x.SYS_CHANGE_COLUMNS).ToList();
                    break;
            }
            return response;
        }

        public override ActionResult ObtainActionResult()
        {
            var response = _db.zAuditUtilityCompanies.OrderBy(x => x.Id).ToList();
            if (Session[Common.SORTCOLUMNNAME] == null)
                Session[Common.SORTCOLUMNNAME] = "Id";
            if (Session[Common.SORTDIRECTION] == null)
                Session[Common.SORTDIRECTION] = Common.ASC;
            switch (Session[Common.SORTCOLUMNNAME].ToString())
            {
                case "Id":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.zAuditUtilityCompanies.OrderByDescending(x => x.Id).ToList();
                    else
                        response = _db.zAuditUtilityCompanies.OrderBy(x => x.Id).ToList();
                    break;
                case "IdPrev":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.zAuditUtilityCompanies.OrderByDescending(x => x.IdPrevious).ToList();
                    else
                        response = _db.zAuditUtilityCompanies.OrderBy(x => x.IdPrevious).ToList();
                    break;
                case "UtilityCode":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.zAuditUtilityCompanies.OrderByDescending(x => x.UtilityCode).ToList();
                    else
                        response = _db.zAuditUtilityCompanies.OrderBy(x => x.UtilityCode).ToList();
                    break;
                case "UtilityCodePrev":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.zAuditUtilityCompanies.OrderByDescending(x => x.UtilityCodePrevious).ToList();
                    else
                        response = _db.zAuditUtilityCompanies.OrderBy(x => x.UtilityCodePrevious).ToList();
                    break;
                case "Inactive":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.zAuditUtilityCompanies.OrderByDescending(x => x.Inactive).ToList();
                    else
                        response = _db.zAuditUtilityCompanies.OrderBy(x => x.Inactive).ToList();
                    break;
                case "InactivePrev":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.zAuditUtilityCompanies.OrderByDescending(x => x.InactivePrevious).ToList();
                    else
                        response = _db.zAuditUtilityCompanies.OrderBy(x => x.InactivePrevious).ToList();
                    break;
                case "CreatedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.zAuditUtilityCompanies.OrderByDescending(x => x.CreatedBy).ToList();
                    else
                        response = _db.zAuditUtilityCompanies.OrderBy(x => x.CreatedBy).ToList();
                    break;
                case "CreatedByPrev":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.zAuditUtilityCompanies.OrderByDescending(x => x.CreatedByPrevious).ToList();
                    else
                        response = _db.zAuditUtilityCompanies.OrderBy(x => x.CreatedByPrevious).ToList();
                    break;
                case "CreatedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.zAuditUtilityCompanies.OrderByDescending(x => x.CreatedDate).ToList();
                    else
                        response = _db.zAuditUtilityCompanies.OrderBy(x => x.CreatedDate).ToList();
                    break;
                case "CreatedDatePrev":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.zAuditUtilityCompanies.OrderByDescending(x => x.CreatedDatePrevious).ToList();
                    else
                        response = _db.zAuditUtilityCompanies.OrderBy(x => x.CreatedDatePrevious).ToList();
                    break;
                case "LastModifiedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.zAuditUtilityCompanies.OrderByDescending(x => x.LastModifiedBy).ToList();
                    else
                        response = _db.zAuditUtilityCompanies.OrderBy(x => x.LastModifiedBy).ToList();
                    break;
                case "LastModifiedByPrev":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.zAuditUtilityCompanies.OrderByDescending(x => x.LastModifiedByPrevious).ToList();
                    else
                        response = _db.zAuditUtilityCompanies.OrderBy(x => x.LastModifiedByPrevious).ToList();
                    break;
                case "LastModifiedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.zAuditUtilityCompanies.OrderByDescending(x => x.LastModifiedDate).ToList();
                    else
                        response = _db.zAuditUtilityCompanies.OrderBy(x => x.LastModifiedDate).ToList();
                    break;
                case "LastModifiedDatePrev":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.zAuditUtilityCompanies.OrderByDescending(x => x.LastModifiedDatePrevious).ToList();
                    else
                        response = _db.zAuditUtilityCompanies.OrderBy(x => x.LastModifiedDatePrevious).ToList();
                    break;
                case "ChangeVersionClick":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.zAuditUtilityCompanies.OrderByDescending(x => x.SYS_CHANGE_VERSION).ToList();
                    else
                        response = _db.zAuditUtilityCompanies.OrderBy(x => x.SYS_CHANGE_VERSION).ToList();
                    break;
                case "CreationVersionClick":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.zAuditUtilityCompanies.OrderByDescending(x => x.SYS_CHANGE_CREATION_VERSION).ToList();
                    else
                        response = _db.zAuditUtilityCompanies.OrderBy(x => x.SYS_CHANGE_CREATION_VERSION).ToList();
                    break;
                case "ChangeOperationClick":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.zAuditUtilityCompanies.OrderByDescending(x => x.SYS_CHANGE_OPERATION).ToList();
                    else
                        response = _db.zAuditUtilityCompanies.OrderBy(x => x.SYS_CHANGE_OPERATION).ToList();
                    break;
                case "ChangeColumnsClick":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = _db.zAuditUtilityCompanies.OrderByDescending(x => x.SYS_CHANGE_COLUMNS).ToList();
                    else
                        response = _db.zAuditUtilityCompanies.OrderBy(x => x.SYS_CHANGE_COLUMNS).ToList();
                    break;
            }
            return View(response);
        }
        #endregion
    }
}