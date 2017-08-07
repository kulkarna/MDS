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
    public class ICapTCapRefreshPeriodController : ControllerBaseWithoutUtilDropDown
    {
        #region private variables and constants
        private const string CLASS = "ICapTCapRefreshPeriodController";
        private const string UTILITYMANAGEMENT_ICAPTCAPREFPER_INDEX = "UTILITYMANAGEMENT_ICAPTCAPREFPER_INDEX";
        private const string UTILITYMANAGEMENT_ICAPTCAPREFPER_CREATE = "UTILITYMANAGEMENT_ICAPTCAPREFPER_CREATE";
        private const string UTILITYMANAGEMENT_ICAPTCAPREFPER_EDIT = "UTILITYMANAGEMENT_ICAPTCAPREFPER_EDIT";
        private const string UTILITYMANAGEMENT_ICAPTCAPREFPER_DETAIL = "UTILITYMANAGEMENT_ICAPTCAPREFPER_DETAIL";
        private const string UTILITYMANAGEMENT_ICAPTCAPREFPER_UPLD = "UTILITYMANAGEMENT_ICAPTCAPREFPER_UPLD";
        private const string UTILITYMANAGEMENT_ICAPTCAPREFPER_DOWNLD = "UTILITYMANAGEMENT_ICAPTCAPREFPER_DOWNLD";
        #endregion

        #region public constructors
        public ICapTCapRefreshPeriodController() : base()
        {
            ViewBag.PageName = "ICapTCapRefreshPeriod";
            ViewBag.IndexPageName = "ICapTCapRefreshPeriod";
            ViewBag.PageDisplayName = "I-Cap T-Cap Refresh Period";
        }
        #endregion

        #region public methods
        //
        // GET: /ICapTCapRefreshPeriod/
        public override ActionResult Index()
        {
            string method = "Index()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_ICAPTCAPREFPER_INDEX))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_ICAPTCAPREFPER_INDEX });
                }

                var response = ObtainResponse();

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));
                return View(response);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new List<ICapTCapRefresh>());
            }
        }

        public override string ActivityGetIndex { get { return UTILITYMANAGEMENT_ICAPTCAPREFPER_INDEX; } }

        public override ActionResult GetBlankResponse()
        {
            return View(new List<ICapTCapRefresh>());
        }

        //
        // GET: /ICapTCapRefreshPeriod/Details/5
        public ActionResult Details(Guid id)
        {
            string method = string.Format("Details(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_ICAPTCAPREFPER_DETAIL))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_ICAPTCAPREFPER_DETAIL });
                }

                ICapTCapRefresh iCapTCapRefreshPeriod = _db.ICapTCapRefreshes.Find(id);

                if (iCapTCapRefreshPeriod == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} iCapTCapRefreshPeriod:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, iCapTCapRefreshPeriod));
                return View(iCapTCapRefreshPeriod);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new ICapTCapRefresh());
            }
        }

        //
        // GET: /ICapTCapRefreshPeriod/Create
        public ActionResult Create()
        {
            string method = "Create()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_ICAPTCAPREFPER_CREATE))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_ICAPTCAPREFPER_CREATE });
                }

                Session[Common.ISPOSTBACK] = "false";
                ICapTCapRefresh iCapTCapRefreshPeriod = new ICapTCapRefresh()
                {
                    CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                    CreatedDate = DateTime.Now,
                    LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                    LastModifiedDate = DateTime.Now
                };
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} iCapTCapRefreshPeriod:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, iCapTCapRefreshPeriod));
                return View(iCapTCapRefreshPeriod);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new ICapTCapRefresh());
            }
        }

        //
        // POST: /ICapTCapRefreshPeriod/Create
        [HttpPost]
        public ActionResult Create(ICapTCapRefresh iCapTCapRefreshPeriod)
        {
            string method = string.Format("Create(ICapTCapRefreshPeriod iCapTCapRefreshPeriod:{0})", iCapTCapRefreshPeriod == null ? "NULL VALUE" : iCapTCapRefreshPeriod.ToString());
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                Session[Common.ISPOSTBACK] = "true";
                iCapTCapRefreshPeriod.CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                iCapTCapRefreshPeriod.CreatedDate = DateTime.Now;
                iCapTCapRefreshPeriod.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                iCapTCapRefreshPeriod.LastModifiedDate = DateTime.Now;
                if (ModelState.IsValid)
                {
                    iCapTCapRefreshPeriod.Id = Guid.NewGuid();
                    ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(iCapTCapRefreshPeriod.UtilityCompanyId.ToString());
                    if (_db.ICapTCapRefreshes.Where(x=>x.UtilityCompanyId == iCapTCapRefreshPeriod.UtilityCompanyId).Count() == 0)
                    {
                        _db.ICapTCapRefreshes.Add(iCapTCapRefreshPeriod);
                        _db.SaveChanges();
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Index");
                    }
                }

                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(iCapTCapRefreshPeriod.UtilityCompanyId.ToString());
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT CREATED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(iCapTCapRefreshPeriod);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new ICapTCapRefresh());
            }
        }

        //
        // GET: /ICapTCapRefreshPeriod/Edit/5
        public ActionResult Edit(Guid id)
        {
            string method = string.Format("Edit(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_ICAPTCAPREFPER_EDIT))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_ICAPTCAPREFPER_EDIT });
                }

                Session[Common.ISPOSTBACK] = "false";
                ICapTCapRefresh iCapTCapRefreshPeriod = _db.ICapTCapRefreshes.Find(id);
                if (iCapTCapRefreshPeriod == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }
                Session[Common.CREATEDBY] = iCapTCapRefreshPeriod.CreatedBy;
                Session[Common.CREATEDDATE] = iCapTCapRefreshPeriod.CreatedDate;
                Guid utilityCompanyId = _db.ICapTCapRefreshes.Where(x => x.Id == id).FirstOrDefault().UtilityCompanyId;
                Session["ICapTCapRefreshPeriod_UtilityCompanyId"] = utilityCompanyId;
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(utilityCompanyId.ToString());
                
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} iCapTCapRefreshPeriod:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, iCapTCapRefreshPeriod));
                return View(iCapTCapRefreshPeriod);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                ICapTCapRefresh requestmodetype = _db.ICapTCapRefreshes.Find(id);
                return View(requestmodetype);
            }
        }

        //
        // POST: /ICapTCapRefreshPeriod/Edit/5
        [HttpPost]
        public ActionResult Edit(ICapTCapRefresh iCapTCapRefresh)
        {
            string method = string.Format("Edit(ICapTCapRefresh iCapTCapRefresh:{0})", iCapTCapRefresh == null ? "NULL VALUE" : iCapTCapRefresh.ToString());
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                Session[Common.ISPOSTBACK] = "true";
                if (ModelState.IsValid)
                {
                    iCapTCapRefresh.UtilityCompanyId = (Guid)Session["ICapTCapRefreshPeriod_UtilityCompanyId"];
                    iCapTCapRefresh.CreatedBy = Session[Common.CREATEDBY] == null ? "NULL USER NAME" : Session[Common.CREATEDBY].ToString();
                    iCapTCapRefresh.CreatedDate = Session[Common.CREATEDDATE] == null ? DateTime.Now : (DateTime)Session[Common.CREATEDDATE];
                    iCapTCapRefresh.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                    iCapTCapRefresh.LastModifiedDate = DateTime.Now;
                    iCapTCapRefresh.UtilityCompany = _db.UtilityCompanies.Where(x => x.Id == iCapTCapRefresh.UtilityCompanyId).FirstOrDefault();
                    if (iCapTCapRefresh.IsICapTCapRefreshValid())
                    {
                        _db.Entry(iCapTCapRefresh).State = EntityState.Modified;
                        _db.SaveChanges();
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Index");
                    }
                    Session[Common.CREATEDBY] = iCapTCapRefresh.CreatedBy;
                    Session[Common.CREATEDDATE] = iCapTCapRefresh.CreatedDate;
                }
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(iCapTCapRefresh.UtilityCompanyId.ToString());

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT EDITED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(iCapTCapRefresh);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(iCapTCapRefresh);
            }
        }
        #endregion


        #region private and protected methods
        protected override void Dispose(bool disposing)
        {
            _db.Dispose();
            base.Dispose(disposing);
        }

        private List<ICapTCapRefresh> ObtainResponse()
        {
            List<ICapTCapRefresh> response = _db.ICapTCapRefreshes.Where(x => x.UtilityCompany.Inactive == false).ToList();

            if (Session[Common.SORTCOLUMNNAME] == null)
                Session[Common.SORTCOLUMNNAME] = "UtilityCode";
            if (Session[Common.SORTDIRECTION] == null)
                Session[Common.SORTDIRECTION] = Common.ASC;

            switch (Session[Common.SORTCOLUMNNAME].ToString())
            {
                case "UtilityCode":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.UtilityCodeImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.UtilityCompany.UtilityCode).ToList();
                    }
                    else
                    {
                        ViewBag.UtilityCodeImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.UtilityCompany.UtilityCode).ToList();
                    }
                    break;
                case "ICapEffectiveDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.ICapTCapRefreshPeriodImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.ICapEffectiveDate).ToList();
                    }
                    else
                    {
                        ViewBag.ICapTCapRefreshPeriodImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.ICapEffectiveDate).ToList();
                    }
                    break;
                case "ICapNextRefresh":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.ICapTCapRefreshPeriodDescriptionImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.ICapNextRefresh).ToList();
                    }
                    else
                    {
                        ViewBag.ICapTCapRefreshPeriodDescriptionImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.ICapNextRefresh).ToList();
                    }
                    break;
                case "TCapEffectiveDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.BillingAccountAddLeadingZeroImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.TCapEffectiveDate).ToList();
                    }
                    else
                    {
                        ViewBag.BillingAccountAddLeadingZeroImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.TCapEffectiveDate).ToList();
                    }
                    break;
                case "TCapNextRefresh":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.BillingAccountTruncateLastImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.TCapNextRefresh).ToList();
                    }
                    else
                    {
                        ViewBag.BillingAccountTruncateLastImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.TCapNextRefresh).ToList();
                    }
                    break;
                case "Inactive":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.InactiveImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.Inactive).ToList();
                    }
                    else
                    {
                        ViewBag.InactiveImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.Inactive).ToList();
                    }
                    break;
                case "CreatedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.CreatedByImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.CreatedBy).ToList();
                    }
                    else
                    {
                        ViewBag.CreatedByImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.CreatedBy).ToList();
                    }
                    break;
                case "CreatedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.CreatedDateImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.CreatedDate).ToList();
                    }
                    else
                    {
                        ViewBag.CreatedDateImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.CreatedDate).ToList();
                    }
                    break;
                case "LastModifiedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.LastModifiedByImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.LastModifiedBy).ToList();
                    }
                    else
                    {
                        ViewBag.LastModifiedByImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.LastModifiedBy).ToList();
                    }
                    break;
                case "LastModifiedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.LastModifiedDateImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.LastModifiedDate).ToList();
                    }
                    else
                    {
                        ViewBag.LastModifiedDateImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.LastModifiedDate).ToList();
                    }
                    break;
            }
            return response;
        }

        //public ActionResult ObtainActionResult()
        //{
        //    List<ICapTCapRefresh> response = _db.ICapTCapRefreshes.Where(x => x.UtilityCompany.Inactive == false).ToList();

        //    if (Session[Common.SORTCOLUMNNAME] == null)
        //        Session[Common.SORTCOLUMNNAME] = "UtilityCode";
        //    if (Session[Common.SORTDIRECTION] == null)
        //        Session[Common.SORTDIRECTION] = Common.ASC;

        //    switch (Session[Common.SORTCOLUMNNAME].ToString())
        //    {
        //        case "UtilityCode":
        //            if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
        //            {
        //                ViewBag.UtilityCodeImageUrl = Common.DOWNARROW;
        //                response = response.OrderByDescending(x => x.UtilityCompany.UtilityCode).ToList();
        //            }
        //            else
        //            {
        //                ViewBag.UtilityCodeImageUrl = Common.UPARROW;
        //                response = response.OrderBy(x => x.UtilityCompany.UtilityCode).ToList();
        //            }
        //            break;
        //        case "ICapEffectiveDate":
        //            if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
        //            {
        //                ViewBag.ICapTCapRefreshPeriodImageUrl = Common.DOWNARROW;
        //                response = response.OrderByDescending(x => x.ICapEffectiveDate).ToList();
        //            }
        //            else
        //            {
        //                ViewBag.ICapTCapRefreshPeriodImageUrl = Common.UPARROW;
        //                response = response.OrderBy(x => x.ICapEffectiveDate).ToList();
        //            }
        //            break;
        //        case "ICapNextRefresh":
        //            if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
        //            {
        //                ViewBag.ICapTCapRefreshPeriodDescriptionImageUrl = Common.DOWNARROW;
        //                response = response.OrderByDescending(x => x.ICapNextRefresh).ToList();
        //            }
        //            else
        //            {
        //                ViewBag.ICapTCapRefreshPeriodDescriptionImageUrl = Common.UPARROW;
        //                response = response.OrderBy(x => x.ICapNextRefresh).ToList();
        //            }
        //            break;
        //        case "TCapEffectiveDate":
        //            if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
        //            {
        //                ViewBag.BillingAccountAddLeadingZeroImageUrl = Common.DOWNARROW;
        //                response = response.OrderByDescending(x => x.TCapEffectiveDate).ToList();
        //            }
        //            else
        //            {
        //                ViewBag.BillingAccountAddLeadingZeroImageUrl = Common.UPARROW;
        //                response = response.OrderBy(x => x.TCapEffectiveDate).ToList();
        //            }
        //            break;
        //        case "TCapNextRefresh":
        //            if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
        //            {
        //                ViewBag.BillingAccountTruncateLastImageUrl = Common.DOWNARROW;
        //                response = response.OrderByDescending(x => x.TCapNextRefresh).ToList();
        //            }
        //            else
        //            {
        //                ViewBag.BillingAccountTruncateLastImageUrl = Common.UPARROW;
        //                response = response.OrderBy(x => x.TCapNextRefresh).ToList();
        //            }
        //            break;
        //        case "Inactive":
        //            if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
        //            {
        //                ViewBag.InactiveImageUrl = Common.DOWNARROW;
        //                response = response.OrderByDescending(x => x.Inactive).ToList();
        //            }
        //            else
        //            {
        //                ViewBag.InactiveImageUrl = Common.UPARROW;
        //                response = response.OrderBy(x => x.Inactive).ToList();
        //            }
        //            break;
        //        case "CreatedBy":
        //            if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
        //            {
        //                ViewBag.CreatedByImageUrl = Common.DOWNARROW;
        //                response = response.OrderByDescending(x => x.CreatedBy).ToList();
        //            }
        //            else
        //            {
        //                ViewBag.CreatedByImageUrl = Common.UPARROW;
        //                response = response.OrderBy(x => x.CreatedBy).ToList();
        //            }
        //            break;
        //        case "CreatedDate":
        //            if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
        //            {
        //                ViewBag.CreatedDateImageUrl = Common.DOWNARROW;
        //                response = response.OrderByDescending(x => x.CreatedDate).ToList();
        //            }
        //            else
        //            {
        //                ViewBag.CreatedDateImageUrl = Common.UPARROW;
        //                response = response.OrderBy(x => x.CreatedDate).ToList();
        //            }
        //            break;
        //        case "LastModifiedBy":
        //            if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
        //            {
        //                ViewBag.LastModifiedByImageUrl = Common.DOWNARROW;
        //                response = response.OrderByDescending(x => x.LastModifiedBy).ToList();
        //            }
        //            else
        //            {
        //                ViewBag.LastModifiedByImageUrl = Common.UPARROW;
        //                response = response.OrderBy(x => x.LastModifiedBy).ToList();
        //            }
        //            break;
        //        case "LastModifiedDate":
        //            if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
        //            {
        //                ViewBag.LastModifiedDateImageUrl = Common.DOWNARROW;
        //                response = response.OrderByDescending(x => x.LastModifiedDate).ToList();
        //            }
        //            else
        //            {
        //                ViewBag.LastModifiedDateImageUrl = Common.UPARROW;
        //                response = response.OrderBy(x => x.LastModifiedDate).ToList();
        //            }
        //            break;
        //    }
        //    return View(response);
        //}

        protected override List<UtilityCompany> GetUtilityCompanyList()
        {
            List<UtilityCompany> utilityList = new List<UtilityCompany>();

            var allUtilityCompanies = _db.UtilityCompanies.Where(x => x.Inactive == false);
            var alreadySelectedUtilityCompanies = from uc in _db.UtilityCompanies where (from bap in _db.ICapTCapRefreshes select bap.UtilityCompanyId).Contains(uc.Id) select uc;
            var leftOverUtilityCompanies = allUtilityCompanies.Except(alreadySelectedUtilityCompanies);
            utilityList.AddRange(leftOverUtilityCompanies.OrderBy(x => x.UtilityCode));
            return utilityList;
        }
        #endregion
    }
}