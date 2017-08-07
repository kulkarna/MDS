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
    public class StrataPatternController : ControllerBase
    {
        #region private variables and constants
        private const string CLASS = "StrataPatternController";
        private const string UTILITYMANAGEMENT_STRATAPATTERN_INDEX = "UTILITYMANAGEMENT_STRATAPATTERN_INDEX";
        private const string UTILITYMANAGEMENT_STRATAPATTERN_CREATE = "UTILITYMANAGEMENT_STRATAPATTERN_CREATE";
        private const string UTILITYMANAGEMENT_STRATAPATTERN_EDIT = "UTILITYMANAGEMENT_STRATAPATTERN_EDIT";
        private const string UTILITYMANAGEMENT_STRATAPATTERN_DETAIL = "UTILITYMANAGEMENT_STRATAPATTERN_DETAIL";
        private const string UTILITYMANAGEMENT_STRATAPATTERN_UPLD = "UTILITYMANAGEMENT_STRATAPATTERN_UPLD";
        private const string UTILITYMANAGEMENT_STRATAPATTERN_DOWNLD = "UTILITYMANAGEMENT_STRATAPATTERN_DOWNLD";
        #endregion
        
        #region public constructors
        public StrataPatternController() : base()
        {
            ViewBag.PageName = "StrataPattern";
            ViewBag.IndexPageName = "StrataPattern";
            ViewBag.PageDisplayName = "Strata Pattern";
        }
        #endregion

        #region public methods
        //
        // GET: /StrataPattern/
        public ActionResult Index()
        {
            string method = "Index()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_STRATAPATTERN_INDEX))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_STRATAPATTERN_INDEX });
                }

                var response = ObtainResponse();

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));
                return View(response);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new List<StrataPattern>());
            }
        }

        //
        // GET: /StrataPattern/Details/5
        public ActionResult Details(Guid id)
        {
            string method = string.Format("Details(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_STRATAPATTERN_DETAIL))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_STRATAPATTERN_DETAIL });
                }

                StrataPattern strataPattern = _db.StrataPatterns.Find(id);

                if (strataPattern == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} strataPattern:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, strataPattern));
                return View(strataPattern);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new StrataPattern());
            }
        }

        //
        // GET: /StrataPattern/Create
        public ActionResult Create()
        {
            string method = "Create()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_STRATAPATTERN_CREATE))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_STRATAPATTERN_CREATE });
                }

                Session[Common.ISPOSTBACK] = "false";
                StrataPattern strataPattern = new StrataPattern()
                {
                    CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                    CreatedDate = DateTime.Now,
                    LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                    LastModifiedDate = DateTime.Now
                };
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} strataPattern:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, strataPattern));
                return View(strataPattern);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new StrataPattern());
            }
        }

        //
        // POST: /StrataPattern/Create
        [HttpPost]
        public ActionResult Create(StrataPattern strataPattern)
        {
            string method = string.Format("Create(StrataPattern strataPattern:{0})", strataPattern == null ? "NULL VALUE" : strataPattern.ToString());
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                Session[Common.ISPOSTBACK] = "true";
                strataPattern.CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; 
                strataPattern.CreatedDate = DateTime.Now;
                strataPattern.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; 
                strataPattern.LastModifiedDate = DateTime.Now;
                if (ModelState.IsValid)
                {
                    strataPattern.Id = Guid.NewGuid();
                    ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(strataPattern.UtilityCompanyId.ToString());
                    if (_db.StrataPatterns.Where(x => x.UtilityCompanyId == strataPattern.UtilityCompanyId).Count() == 0 && strataPattern.IsStrataPatternValid())
                    {
                        _db.StrataPatterns.Add(strataPattern);
                        _db.SaveChanges();
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Index");
                    }
                    Session[Common.CREATEDBY] = strataPattern.CreatedBy;
                    Session[Common.CREATEDDATE] = strataPattern.CreatedDate;
                    Session["LastModifiedBy"] = strataPattern.LastModifiedBy;
                    Session["LastModifiedDate"] = strataPattern.LastModifiedDate;
                }

                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(strataPattern.UtilityCompanyId.ToString());
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT CREATED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(strataPattern);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new StrataPattern());
            }
        }

        //
        // GET: /StrataPattern/Edit/5
        public ActionResult Edit(Guid id)
        {
            string method = string.Format("Edit(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_STRATAPATTERN_EDIT))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_STRATAPATTERN_EDIT });
                }

                Session[Common.ISPOSTBACK] = "false";
                StrataPattern strataPattern = _db.StrataPatterns.Find(id);
                if (strataPattern == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }
                Session[Common.CREATEDBY] = strataPattern.CreatedBy;
                Session[Common.CREATEDDATE] = strataPattern.CreatedDate;
                Guid utilityCompanyId = _db.StrataPatterns.Where(x => x.Id == id).FirstOrDefault().UtilityCompanyId;
                Session["StrataPattern_UtilityCompanyId"] = utilityCompanyId;
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(utilityCompanyId.ToString());
                
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} strataPattern:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, strataPattern));
                return View(strataPattern);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                StrataPattern requestmodetype = _db.StrataPatterns.Find(id);
                return View(requestmodetype);
            }
        }

        //
        // POST: /StrataPattern/Edit/5
        [HttpPost]
        public ActionResult Edit(StrataPattern strataPattern)
        {
            string method = string.Format("Edit(StrataPattern strataPattern:{0})", strataPattern == null ? "NULL VALUE" : strataPattern.ToString());
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                Session[Common.ISPOSTBACK] = "true";
                strataPattern.UtilityCompanyId = (Guid)Session["StrataPattern_UtilityCompanyId"];
                strataPattern.CreatedBy = Session[Common.CREATEDBY] == null ? "NULL USER NAME" : Session[Common.CREATEDBY].ToString();
                strataPattern.CreatedDate = Session[Common.CREATEDDATE] == null ? DateTime.Now : (DateTime)Session[Common.CREATEDDATE];
                strataPattern.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                strataPattern.LastModifiedDate = DateTime.Now;
                strataPattern.UtilityCompany = _db.UtilityCompanies.Where(x => x.Id == strataPattern.UtilityCompanyId).FirstOrDefault();
                if (ModelState.IsValid && strataPattern.IsStrataPatternValid())
                {
                    _db.Entry(strataPattern).State = EntityState.Modified;
                    _db.SaveChanges();
                    _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index");
                }
                Session[Common.CREATEDBY] = strataPattern.CreatedBy;
                Session[Common.CREATEDDATE] = strataPattern.CreatedDate;
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(strataPattern.UtilityCompanyId.ToString());

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT EDITED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(strataPattern);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(strataPattern);
            }
        }
        #endregion


        #region private and protected methods
        protected override void Dispose(bool disposing)
        {
            _db.Dispose();
            base.Dispose(disposing);
        }

        private List<StrataPattern> ObtainResponse()
        {
            List<StrataPattern> response = _db.StrataPatterns.Where(x => x.UtilityCompany.Inactive == false).ToList();

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
                case "StrataPattern":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.StrataPatternImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.StrataPattern1).ToList();
                    }
                    else
                    {
                        ViewBag.StrataPatternImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.StrataPattern1).ToList();
                    }
                    break;
                case "StrataPatternDescription":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.StrataPatternDescriptionImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.StrataPatternDescription).ToList();
                    }
                    else
                    {
                        ViewBag.StrataPatternDescriptionImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.StrataPatternDescription).ToList();
                    }
                    break;
                case "StrataAddLeadingZero":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.StrataAddLeadingZeroImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.StrataAddLeadingZero).ToList();
                    }
                    else
                    {
                        ViewBag.StrataAddLeadingZeroImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.StrataAddLeadingZero).ToList();
                    }
                    break;
                case "StrataTruncateLast":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.StrataTruncateLastImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.StrataTruncateLast).ToList();
                    }
                    else
                    {
                        ViewBag.StrataTruncateLastImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.StrataTruncateLast).ToList();
                    }
                    break;
                case "StrataRequiredForEDIRequest":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.StrataRequiredForEDIRequestImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.StrataRequiredForEdiRequest).ToList();
                    }
                    else
                    {
                        ViewBag.StrataRequiredForEDIRequestImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.StrataRequiredForEdiRequest).ToList();
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

        protected override List<UtilityCompany> GetUtilityCompanyList()
        {
            List<UtilityCompany> utilityList = new List<UtilityCompany>();

            var allUtilityCompanies = _db.UtilityCompanies.Where(x => x.Inactive == false);
            var alreadySelectedUtilityCompanies = from uc in _db.UtilityCompanies where (from sp in _db.StrataPatterns select sp.UtilityCompanyId).Contains(uc.Id) select uc;
            var leftOverUtilityCompanies = allUtilityCompanies.Except(alreadySelectedUtilityCompanies);
            utilityList.AddRange(leftOverUtilityCompanies.OrderBy(x => x.UtilityCode));
            return utilityList;
        }
        #endregion
    }
}