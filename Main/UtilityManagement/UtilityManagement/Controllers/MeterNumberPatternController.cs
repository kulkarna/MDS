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
    public class MeterNumberPatternController : ControllerBaseWithoutUtilDropDown
    {
        #region private variables and constants
        private const string CLASS = "MeterNumberPatternController";
        private const string UTILITYMANAGEMENT_METERNUMBERPAT_INDEX = "UTILITYMANAGEMENT_METERNUMBERPAT_INDEX";
        private const string UTILITYMANAGEMENT_METERNUMBERPAT_CREATE = "UTILITYMANAGEMENT_METERNUMBERPAT_CREATE";
        private const string UTILITYMANAGEMENT_METERNUMBERPAT_EDIT = "UTILITYMANAGEMENT_METERNUMBERPAT_EDIT";
        private const string UTILITYMANAGEMENT_METERNUMBERPAT_DETAIL = "UTILITYMANAGEMENT_METERNUMBERPAT_DETAIL";
        private const string UTILITYMANAGEMENT_METERNUMBERPAT_UPLD = "UTILITYMANAGEMENT_METERNUMBERPAT_UPLD";
        private const string UTILITYMANAGEMENT_METERNUMBERPAT_DOWNLD = "UTILITYMANAGEMENT_METERNUMBERPAT_DOWNLD";
        #endregion

        #region public constructors
        public MeterNumberPatternController() : base()
        {
            ViewBag.PageName = "MeterNumberPattern";
            ViewBag.IndexPageName = "MeterNumberPattern";
            ViewBag.PageDisplayName = "Meter Number Pattern";
        }
        #endregion

        #region public methods
        //
        // GET: /MeterNumberPattern/
        public override ActionResult Index()
        {
            string method = "Index()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_METERNUMBERPAT_INDEX))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_METERNUMBERPAT_INDEX });
                }

                var response = ObtainResponse();

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));
                return View(response);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new List<MeterNumberPattern>());
            }
        }

        public override string ActivityGetIndex { get { return UTILITYMANAGEMENT_METERNUMBERPAT_INDEX; } }

        public override ActionResult GetBlankResponse()
        {
            return View(new List<zAuditUtilityCompany>());
        }

        //
        // GET: /MeterNumberPattern/Details/5
        public ActionResult Details(Guid id)
        {
            string method = string.Format("Details(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_METERNUMBERPAT_DETAIL))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_METERNUMBERPAT_DETAIL });
                }

                MeterNumberPattern meterNumberPattern = _db.MeterNumberPatterns.Find(id);

                if (meterNumberPattern == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} meterNumberPattern:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, meterNumberPattern));
                return View(meterNumberPattern);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new MeterNumberPattern());
            }
        }

        //
        // GET: /MeterNumberPattern/Create
        public ActionResult Create()
        {
            string method = "Create()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_METERNUMBERPAT_CREATE))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_METERNUMBERPAT_CREATE });
                }

                Session[Common.ISPOSTBACK] = "false";
                MeterNumberPattern meterNumberPattern = new MeterNumberPattern()
                {
                    CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                    CreatedDate = DateTime.Now,
                    LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                    LastModifiedDate = DateTime.Now
                };
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} meterNumberPattern:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, meterNumberPattern));
                return View(meterNumberPattern);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new MeterNumberPattern());
            }
        }

        //
        // POST: /MeterNumberPattern/Create
        [HttpPost]
        public ActionResult Create(MeterNumberPattern meterNumberPattern)
        {
            string method = string.Format("Create(MeterNumberPattern meterNumberPattern:{0})", meterNumberPattern == null ? "NULL VALUE" : meterNumberPattern.ToString());
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                Session[Common.ISPOSTBACK] = "true";
                meterNumberPattern.CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                meterNumberPattern.CreatedDate = DateTime.Now;
                meterNumberPattern.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                meterNumberPattern.LastModifiedDate = DateTime.Now;
                if (ModelState.IsValid)
                {
                    meterNumberPattern.Id = Guid.NewGuid();
                    ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(meterNumberPattern.UtilityCompanyId.ToString());
                    if (_db.MeterNumberPatterns.Where(x=>x.UtilityCompanyId == meterNumberPattern.UtilityCompanyId).Count() == 0)
                    {
                        _db.MeterNumberPatterns.Add(meterNumberPattern);
                        _db.SaveChanges();
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Index");
                    }
                }

                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(meterNumberPattern.UtilityCompanyId.ToString());
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT CREATED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(meterNumberPattern);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new MeterNumberPattern());
            }
        }

        //
        // GET: /MeterNumberPattern/Edit/5
        public ActionResult Edit(Guid id)
        {
            string method = string.Format("Edit(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_METERNUMBERPAT_EDIT))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_METERNUMBERPAT_EDIT });
                }

                Session[Common.ISPOSTBACK] = "false";
                MeterNumberPattern meterNumberPattern = _db.MeterNumberPatterns.Find(id);
                if (meterNumberPattern == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }
                Session[Common.CREATEDBY] = meterNumberPattern.CreatedBy;
                Session[Common.CREATEDDATE] = meterNumberPattern.CreatedDate;
                Guid utilityCompanyId = _db.MeterNumberPatterns.Where(x => x.Id == id).FirstOrDefault().UtilityCompanyId;
                Session["MeterNumberPattern_UtilityCompanyId"] = utilityCompanyId;
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(utilityCompanyId.ToString());
                
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} meterNumberPattern:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, meterNumberPattern));
                return View(meterNumberPattern);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                MeterNumberPattern requestmodetype = _db.MeterNumberPatterns.Find(id);
                return View(requestmodetype);
            }
        }

        //
        // POST: /MeterNumberPattern/Edit/5
        [HttpPost]
        public ActionResult Edit(MeterNumberPattern meterNumberPattern)
        {
            string method = string.Format("Edit(MeterNumberPattern meterNumberPattern:{0})", meterNumberPattern == null ? "NULL VALUE" : meterNumberPattern.ToString());
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                Session[Common.ISPOSTBACK] = "true";
                meterNumberPattern.UtilityCompanyId = (Guid)Session["MeterNumberPattern_UtilityCompanyId"];
                meterNumberPattern.CreatedBy = Session[Common.CREATEDBY] == null ? "NULL USER NAME" : Session[Common.CREATEDBY].ToString();
                meterNumberPattern.CreatedDate = Session[Common.CREATEDDATE] == null ? DateTime.Now : (DateTime)Session[Common.CREATEDDATE];
                meterNumberPattern.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                meterNumberPattern.LastModifiedDate = DateTime.Now;
                meterNumberPattern.UtilityCompany = _db.UtilityCompanies.Where(x => x.Id == meterNumberPattern.UtilityCompanyId).FirstOrDefault();
                if (ModelState.IsValid)
                {
                    _db.Entry(meterNumberPattern).State = EntityState.Modified;
                    _db.SaveChanges();
                    _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index");
                }
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(meterNumberPattern.UtilityCompanyId.ToString());

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT EDITED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(meterNumberPattern);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(meterNumberPattern);
            }
        }
        #endregion


        #region private and protected methods
        protected override void Dispose(bool disposing)
        {
            _db.Dispose();
            base.Dispose(disposing);
        }

        private List<MeterNumberPattern> ObtainResponse()
        {
            List<MeterNumberPattern> response = _db.MeterNumberPatterns.Where(x => x.UtilityCompany.Inactive == false).ToList();

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
                case "MeterNumberPattern":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.MeterNumberPatternImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.MeterNumberPattern1).ToList();
                    }
                    else
                    {
                        ViewBag.MeterNumberPatternImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.MeterNumberPattern1).ToList();
                    }
                    break;
                case "MeterNumberPatternDescription":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.MeterNumberPatternDescriptionImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.MeterNumberPatternDescription).ToList();
                    }
                    else
                    {
                        ViewBag.MeterNumberPatternDescriptionImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.MeterNumberPatternDescription).ToList();
                    }
                    break;
                case "MeterNumberAddLeadingZero":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.MeterNumberAddLeadingZeroImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.MeterNumberAddLeadingZero).ToList();
                    }
                    else
                    {
                        ViewBag.MeterNumberAddLeadingZeroImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.MeterNumberAddLeadingZero).ToList();
                    }
                    break;
                case "MeterNumberTruncateLast":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.MeterNumberTruncateLastImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.MeterNumberTruncateLast).ToList();
                    }
                    else
                    {
                        ViewBag.MeterNumberTruncateLastImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.MeterNumberTruncateLast).ToList();
                    }
                    break;
                case "MeterNumberRequiredForEDIRequest":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.MeterNumberRequiredForEDIRequestImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.MeterNumberRequiredForEdiRequest).ToList();
                    }
                    else
                    {
                        ViewBag.MeterNumberRequiredForEDIRequestImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.MeterNumberRequiredForEdiRequest).ToList();
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

        public override ActionResult ObtainActionResult()
        {
            List<MeterNumberPattern> response = _db.MeterNumberPatterns.Where(x => x.UtilityCompany.Inactive == false).ToList();

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
                case "MeterNumberPattern":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.MeterNumberPatternImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.MeterNumberPattern1).ToList();
                    }
                    else
                    {
                        ViewBag.MeterNumberPatternImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.MeterNumberPattern1).ToList();
                    }
                    break;
                case "MeterNumberPatternDescription":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.MeterNumberPatternDescriptionImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.MeterNumberPatternDescription).ToList();
                    }
                    else
                    {
                        ViewBag.MeterNumberPatternDescriptionImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.MeterNumberPatternDescription).ToList();
                    }
                    break;
                case "MeterNumberAddLeadingZero":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.MeterNumberAddLeadingZeroImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.MeterNumberAddLeadingZero).ToList();
                    }
                    else
                    {
                        ViewBag.MeterNumberAddLeadingZeroImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.MeterNumberAddLeadingZero).ToList();
                    }
                    break;
                case "MeterNumberTruncateLast":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.MeterNumberTruncateLastImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.MeterNumberTruncateLast).ToList();
                    }
                    else
                    {
                        ViewBag.MeterNumberTruncateLastImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.MeterNumberTruncateLast).ToList();
                    }
                    break;
                case "MeterNumberRequiredForEDIRequest":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.MeterNumberRequiredForEDIRequestImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.MeterNumberRequiredForEdiRequest).ToList();
                    }
                    else
                    {
                        ViewBag.MeterNumberRequiredForEDIRequestImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.MeterNumberRequiredForEdiRequest).ToList();
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
            return View(response);
        }


        protected override List<UtilityCompany> GetUtilityCompanyList()
        {
            List<UtilityCompany> utilityList = new List<UtilityCompany>();

            var allUtilityCompanies = _db.UtilityCompanies.Where(x => x.Inactive == false);
            var alreadySelectedUtilityCompanies = from uc in _db.UtilityCompanies where (from mnp in _db.MeterNumberPatterns select mnp.UtilityCompanyId).Contains(uc.Id) select uc;
            var leftOverUtilityCompanies = allUtilityCompanies.Except(alreadySelectedUtilityCompanies);
            utilityList.AddRange(leftOverUtilityCompanies.OrderBy(x => x.UtilityCode));
            return utilityList;
        }
        #endregion
    }
}