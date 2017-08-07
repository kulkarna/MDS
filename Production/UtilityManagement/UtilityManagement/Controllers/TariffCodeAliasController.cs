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
    public class TariffCodeAliasController : ControllerBase
    {
        #region private variables and constants
        private const string CLASS = "TariffCodeAliasController";
        private const string UTILITYMANAGEMENT_TARIFFCODE_INDEX = "UTILITYMANAGEMENT_TARIFFCODE_INDEX";
        private const string UTILITYMANAGEMENT_TARIFFCODE_CREATE = "UTILITYMANAGEMENT_TARIFFCODE_CREATE";
        private const string UTILITYMANAGEMENT_TARIFFCODE_EDIT = "UTILITYMANAGEMENT_TARIFFCODE_EDIT";
        private const string UTILITYMANAGEMENT_TARIFFCODE_DETAIL = "UTILITYMANAGEMENT_TARIFFCODE_DETAIL";
        private const string UTILITYMANAGEMENT_TARIFFCODE_UPLD = "UTILITYMANAGEMENT_TARIFFCODE_UPLD";
        private const string UTILITYMANAGEMENT_TARIFFCODE_DOWNLD = "UTILITYMANAGEMENT_TARIFFCODE_DOWNLD";
        #endregion

        #region public constructors
        public TariffCodeAliasController()
            : base()
        {
            ViewBag.PageName = "TariffCodeAlias";
            ViewBag.IndexPageName = "TariffCode";
            ViewBag.PageDisplayName = "Tariff Code Alias";
        }
        #endregion

        #region public methods
        //
        // GET: /TariffCodeAlias/
        public ActionResult Index()
        {
            string method = "Index()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_TARIFFCODE_INDEX))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_TARIFFCODE_INDEX });
                }

                var response = _db.TariffCodeAlias.Include(x => x.TariffCode).OrderBy(r => r.TariffCode.TariffCodeId);

                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));
                return View(response);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new List<TariffCode>());
            }
        }

        //
        // GET: /TariffCodeAlias/Details/5
        public ActionResult Details(Guid id)
        {
            string method = string.Format("Details(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_TARIFFCODE_DETAIL))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_TARIFFCODE_DETAIL });
                }

                TariffCodeAlia TariffCodeAlias = _db.TariffCodeAlias.Find(id);
                Guid uci = new Guid(Session["TariffCode_UtilityCompanyId_Set"].ToString());

                if (TariffCodeAlias == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }

                ViewBag.UtilityCode = _db.UtilityCompanies.Where(x => x.Id == uci).FirstOrDefault().UtilityCode;
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} TariffCodeAlias:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, TariffCodeAlias));
                return View(TariffCodeAlias);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new TariffCode());
            }
        }

        [HttpPost]
        public ActionResult Details(TariffCodeAlia TariffCodeAlias, string submitButton)
        {
            string method = string.Format(" Details(TariffCodeAlia TariffCodeAlias{0}, submitButton:{1})", TariffCodeAlias == null ? "NULL VALUE" : TariffCodeAlias.ToString(), Common.NullSafeString(submitButton));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                Guid uci = new Guid(Session["TariffCode_UtilityCompanyId_Set"].ToString());
                switch (submitButton)
                {
                    case "Edit":
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Redirecting to Back to List", Common.NAMESPACE, CLASS, method));
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Edit", "TariffCodeAlias", new { id = TariffCodeAlias.Id });
                }
                ViewBag.UtilityCode = _db.UtilityCompanies.Where(x => x.Id == uci).FirstOrDefault().UtilityCode;
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Redirecting to Back to List", Common.NAMESPACE, CLASS, method));
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return RedirectToAction("Index", "TariffCode");
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new TariffCode());
            }
        }

        //
        // GET: /TariffCodeAlias/Create
        public ActionResult Create()
        {
            string method = "Create()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_TARIFFCODE_CREATE))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_TARIFFCODE_CREATE });
                }

                Guid uci = new Guid(Session["TariffCode_UtilityCompanyId_Set"].ToString());
                Session[Common.ISPOSTBACK] = "false";
                TariffCodeAlia TariffCodeAlias = new TariffCodeAlia()
                {
                    CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                    CreatedDate = DateTime.Now,
                    LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                    LastModifiedDate = DateTime.Now
                };
                ViewBag.TariffCodeId = GetTariffCodeSelectListById(uci);
                ViewBag.UtilityCode = _db.UtilityCompanies.Where(x => x.Id == uci).FirstOrDefault().UtilityCode;
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} TariffCodeAlias:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, TariffCodeAlias));
                return View(TariffCodeAlias);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                TariffCodeAlia TariffCodeAlias = new TariffCodeAlia();
                Guid uci = new Guid(Session["TariffCode_UtilityCompanyId_Set"].ToString());
                ViewBag.TariffCodeId = GetTariffCodeSelectListById(uci);
                ViewBag.UtilityCode = _db.UtilityCompanies.Where(x => x.Id == uci).FirstOrDefault().UtilityCode;
                return View(TariffCodeAlias);
            }
        }

        //
        // POST: /TariffCodeAlias/Create
        [HttpPost]
        public ActionResult Create(TariffCodeAlia tariffCodeAlias, string submitButton)
        {
            string method = string.Format("Create(TariffCodeAlia tariffCodeAlias:{0}, submitButton:{1})", tariffCodeAlias == null ? "NULL VALUE" : tariffCodeAlias.ToString(), submitButton ?? "NULL VALUE");
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                Guid uci = new Guid(Session["TariffCode_UtilityCompanyId_Set"].ToString());
                Session["ErrorMessage"] = null;
                Session[Common.ISPOSTBACK] = "true";
                tariffCodeAlias.Id = Guid.NewGuid();
                tariffCodeAlias.CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                tariffCodeAlias.CreatedDate = DateTime.Now;
                tariffCodeAlias.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                tariffCodeAlias.LastModifiedDate = DateTime.Now;
                if (ModelState.IsValid
                    && tariffCodeAlias.IsTariffCodeAliasValid()
                        && _db.TariffCodeAlias.Where(x => x.TariffCodeId == tariffCodeAlias.TariffCodeId && x.TariffCodeCodeAlias == tariffCodeAlias.TariffCodeCodeAlias && x.Id != tariffCodeAlias.Id).Count<TariffCodeAlia>() == 0)
                {
                    _db.TariffCodeAlias.Add(tariffCodeAlias);
                    _db.SaveChanges();
                    _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "TariffCode");
                }
                Session["ErrorMessage"] = "Invalid Data! Check For Empty Or Duplicate Values.";
                ViewBag.TariffCodeId = GetTariffCodeSelectListById(uci);
                ViewBag.UtilityCode = _db.UtilityCompanies.Where(x => x.Id == uci).FirstOrDefault().UtilityCode;
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT CREATED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(tariffCodeAlias);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                Guid uci = new Guid(Session["TariffCode_UtilityCompanyId_Set"].ToString());
                ViewBag.TariffCodeId = GetTariffCodeSelectListById(uci);
                ViewBag.UtilityCode = _db.UtilityCompanies.Where(x => x.Id == uci).FirstOrDefault().UtilityCode;
                return View(new TariffCode());
            }
        }

        //
        // GET: /TariffCodeAlias/Edit/5
        public ActionResult Edit(Guid id)
        {
            string method = string.Format("Edit(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                Guid uci = new Guid(Session["TariffCode_UtilityCompanyId_Set"].ToString());
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_TARIFFCODE_EDIT))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_TARIFFCODE_EDIT });
                }

                Session[Common.ISPOSTBACK] = "false";
                TariffCodeAlia TariffCodeAlias = _db.TariffCodeAlias.Find(id);
                if (TariffCodeAlias == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }
                Session[Common.CREATEDBY] = TariffCodeAlias.CreatedBy;
                Session[Common.CREATEDDATE] = TariffCodeAlias.CreatedDate;
                Session["TariffCodeId"] = TariffCodeAlias.TariffCodeId;

                ViewBag.TariffCodeId = GetTariffCodeSelectList(uci);
                ViewBag.UtilityCode = _db.UtilityCompanies.Where(x => x.Id == uci).FirstOrDefault().UtilityCode;
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} TariffCodeAlias:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, TariffCodeAlias));

                return View(TariffCodeAlias);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                TariffCodeAlia TariffCodeAlias = _db.TariffCodeAlias.Find(id);
                Guid uci = new Guid(Session["TariffCode_UtilityCompanyId_Set"].ToString());
                ViewBag.TariffCodeId = GetTariffCodeSelectList(uci);
                ViewBag.UtilityCode = _db.UtilityCompanies.Where(x => x.Id == uci).FirstOrDefault().UtilityCode;
                return View(TariffCodeAlias);
            }
        }

        //
        // POST: /TariffCodeAlias/Edit/5
        [HttpPost]
        public ActionResult Edit(TariffCodeAlia tariffCodeAlias, string submitButton)
        {
            string method = string.Format("Edit(TariffCodeAlia tariffCodeAlias:{0})", tariffCodeAlias == null ? "NULL VALUE" : tariffCodeAlias.ToString());
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                Guid uci = new Guid(Session["TariffCode_UtilityCompanyId_Set"].ToString());
                Session["ErrorMessage"] = null;
                Session[Common.ISPOSTBACK] = "true";
                tariffCodeAlias.CreatedBy = Session[Common.CREATEDBY] == null ? "NULL USER NAME" : Session[Common.CREATEDBY].ToString();
                tariffCodeAlias.CreatedDate = Session[Common.CREATEDDATE] == null ? DateTime.Now : (DateTime)Session[Common.CREATEDDATE];
                tariffCodeAlias.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; 
                tariffCodeAlias.LastModifiedDate = DateTime.Now;
                tariffCodeAlias.TariffCodeId = Common.NullSafeGuid(Session["TariffCodeId"]);
                if (ModelState.IsValid
                    && tariffCodeAlias.IsTariffCodeAliasValid()
                    && _db.TariffCodeAlias.Where(x => x.TariffCodeId == tariffCodeAlias.TariffCodeId && x.TariffCodeCodeAlias == tariffCodeAlias.TariffCodeCodeAlias && x.Id != tariffCodeAlias.Id).Count<TariffCodeAlia>() == 0)
                {
                    _db.Entry(tariffCodeAlias).State = EntityState.Modified;
                    _db.SaveChanges();
                    _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "TariffCode");
                }
                Session["ErrorMessage"] = "Invalid Data! Check For Empty Or Duplicate Values.";

                string tariffCodeCodeAlias = tariffCodeAlias.TariffCodeCodeAlias;
                tariffCodeAlias = _db.TariffCodeAlias.Find(tariffCodeAlias.Id);
                tariffCodeAlias.CreatedBy = Session[Common.CREATEDBY] == null ? "NULL USER NAME" : Session[Common.CREATEDBY].ToString();
                tariffCodeAlias.CreatedDate = Session[Common.CREATEDDATE] == null ? DateTime.Now : (DateTime)Session[Common.CREATEDDATE];
                tariffCodeAlias.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; 
                tariffCodeAlias.LastModifiedDate = DateTime.Now;
                tariffCodeAlias.TariffCodeCodeAlias = tariffCodeCodeAlias;
                ViewBag.TariffCodeId = GetTariffCodeSelectList(uci);
                ViewBag.UtilityCode = _db.UtilityCompanies.Where(x => x.Id == uci).FirstOrDefault().UtilityCode;
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT EDITED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(tariffCodeAlias);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                Guid uci = new Guid(Session["TariffCode_UtilityCompanyId_Set"].ToString());
                ViewBag.TariffCodeId = GetTariffCodeSelectList(uci);
                ViewBag.UtilityCode = _db.UtilityCompanies.Where(x => x.Id == uci).FirstOrDefault().UtilityCode;
                return View(tariffCodeAlias);
            }
        }

        public ActionResult TariffCodeIdTitleClick()
        {
            string method = "TariffCodeIdTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("TariffCodeId");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult TariffCodeAliasTitleClick()
        {
            string method = "TariffCodeAliasTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("TariffCodeAlias");

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


        #region private and protected methods
        protected override void Dispose(bool disposing)
        {
            _db.Dispose();
            base.Dispose(disposing);
        }
        #endregion
    }
}