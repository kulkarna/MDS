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
    public class NameKeyPatternController : ControllerBaseWithoutUtilDropDown
    {
        #region private variables and constants
        private const string CLASS = "NameKeyPatternController";
        private const string UTILITYMANAGEMENT_NAMEKEYPATTERN_INDEX = "UTILITYMANAGEMENT_NAMEKEYPATTERN_INDEX";
        private const string UTILITYMANAGEMENT_NAMEKEYPATTERN_CREATE = "UTILITYMANAGEMENT_NAMEKEYPATTERN_CREATE";
        private const string UTILITYMANAGEMENT_NAMEKEYPATTERN_EDIT = "UTILITYMANAGEMENT_NAMEKEYPATTERN_EDIT";
        private const string UTILITYMANAGEMENT_NAMEKEYPATTERN_DETAIL = "UTILITYMANAGEMENT_NAMEKEYPATTERN_DETAIL";
        private const string UTILITYMANAGEMENT_NAMEKEYPATTERN_UPLD = "UTILITYMANAGEMENT_NAMEKEYPATTERN_UPLD";
        private const string UTILITYMANAGEMENT_NAMEKEYPATTERN_DOWNLD = "UTILITYMANAGEMENT_NAMEKEYPATTERN_DOWNLD";
        #endregion

        #region public constructors
        public NameKeyPatternController() : base()
        {
            ViewBag.PageName = "NameKeyPattern";
            ViewBag.IndexPageName = "NameKeyPattern";
            ViewBag.PageDisplayName = "Name Key Pattern";
        }
        #endregion

        #region public methods
        //
        // GET: /NameKeyPattern/
        public override ActionResult Index()
        {
            string method = "Index()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_NAMEKEYPATTERN_INDEX))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_NAMEKEYPATTERN_INDEX });
                }

                var response = ObtainResponse();

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));
                return View(response);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new List<NameKeyPattern>());
            }
        }

        public override string ActivityGetIndex { get { return UTILITYMANAGEMENT_NAMEKEYPATTERN_INDEX; } }

        public override ActionResult GetBlankResponse()
        {
            return View(new List<NameKeyPattern>());
        }


        //
        // GET: /NameKeyPattern/Details/5
        public ActionResult Details(Guid id)
        {
            string method = string.Format("Details(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_NAMEKEYPATTERN_DETAIL))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_NAMEKEYPATTERN_DETAIL });
                }

                NameKeyPattern nameKeyPattern = _db.NameKeyPatterns.Find(id);

                if (nameKeyPattern == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} nameKeyPattern:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, nameKeyPattern));
                return View(nameKeyPattern);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new NameKeyPattern());
            }
        }

        //
        // GET: /NameKeyPattern/Create
        public ActionResult Create()
        {
            string method = "Create()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_NAMEKEYPATTERN_CREATE))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_NAMEKEYPATTERN_CREATE });
                }

                Session[Common.ISPOSTBACK] = "false";
                NameKeyPattern nameKeyPattern = new NameKeyPattern()
                {
                    CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                    CreatedDate = DateTime.Now,
                    LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                    LastModifiedDate = DateTime.Now
                };
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} nameKeyPattern:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, nameKeyPattern));
                return View(nameKeyPattern);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new NameKeyPattern());
            }
        }

        //
        // POST: /NameKeyPattern/Create
        [HttpPost]
        public ActionResult Create(NameKeyPattern nameKeyPattern)
        {
            string method = string.Format("Create(NameKeyPattern nameKeyPattern:{0})", nameKeyPattern == null ? "NULL VALUE" : nameKeyPattern.ToString());
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                Session[Common.ISPOSTBACK] = "true";
                nameKeyPattern.CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                nameKeyPattern.CreatedDate = DateTime.Now;
                nameKeyPattern.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                nameKeyPattern.LastModifiedDate = DateTime.Now;
                if (ModelState.IsValid)
                {
                    nameKeyPattern.Id = Guid.NewGuid();
                    ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(nameKeyPattern.UtilityCompanyId.ToString());
                    if (_db.NameKeyPatterns.Where(x=>x.UtilityCompanyId == nameKeyPattern.UtilityCompanyId).Count() == 0)
                    {
                        _db.NameKeyPatterns.Add(nameKeyPattern);
                        _db.SaveChanges();
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Index");
                    }
                }

                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(nameKeyPattern.UtilityCompanyId.ToString());
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT CREATED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(nameKeyPattern);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new NameKeyPattern());
            }
        }

        //
        // GET: /NameKeyPattern/Edit/5
        public ActionResult Edit(Guid id)
        {
            string method = string.Format("Edit(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_NAMEKEYPATTERN_EDIT))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_NAMEKEYPATTERN_EDIT });
                }
                
                Session[Common.ISPOSTBACK] = "false";
                NameKeyPattern nameKeyPattern = _db.NameKeyPatterns.Find(id);
                if (nameKeyPattern == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }
                Session[Common.CREATEDBY] = nameKeyPattern.CreatedBy;
                Session[Common.CREATEDDATE] = nameKeyPattern.CreatedDate;
                Guid utilityCompanyId = _db.NameKeyPatterns.Where(x => x.Id == id).FirstOrDefault().UtilityCompanyId;
                Session["NameKeyPattern_UtilityCompanyId"] = utilityCompanyId;
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(utilityCompanyId.ToString());
                
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} nameKeyPattern:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, nameKeyPattern));
                return View(nameKeyPattern);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                NameKeyPattern requestmodetype = _db.NameKeyPatterns.Find(id);
                return View(requestmodetype);
            }
        }

        //
        // POST: /NameKeyPattern/Edit/5
        [HttpPost]
        public ActionResult Edit(NameKeyPattern nameKeyPattern)
        {
            string method = string.Format("Edit(NameKeyPattern nameKeyPattern:{0})", nameKeyPattern == null ? "NULL VALUE" : nameKeyPattern.ToString());
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                Session[Common.ISPOSTBACK] = "true";
                nameKeyPattern.UtilityCompanyId = (Guid)Session["NameKeyPattern_UtilityCompanyId"];
                nameKeyPattern.CreatedBy = Session[Common.CREATEDBY] == null ? "NULL USER NAME" : Session[Common.CREATEDBY].ToString();
                nameKeyPattern.CreatedDate = Session[Common.CREATEDDATE] == null ? DateTime.Now : (DateTime)Session[Common.CREATEDDATE];
                nameKeyPattern.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                nameKeyPattern.LastModifiedDate = DateTime.Now;
                nameKeyPattern.UtilityCompany = _db.UtilityCompanies.Where(x => x.Id == nameKeyPattern.UtilityCompanyId).FirstOrDefault();
                if (ModelState.IsValid)
                {
                    _db.Entry(nameKeyPattern).State = EntityState.Modified;
                    _db.SaveChanges();
                    _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index");
                }
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(nameKeyPattern.UtilityCompanyId.ToString());

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT EDITED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(nameKeyPattern);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(nameKeyPattern);
            }
        }
        #endregion


        #region private and protected methods
        protected override void Dispose(bool disposing)
        {
            _db.Dispose();
            base.Dispose(disposing);
        }

        private List<NameKeyPattern> ObtainResponse()
        {
            List<NameKeyPattern> response = _db.NameKeyPatterns.Where(x => x.UtilityCompany.Inactive == false).ToList();

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
                case "NameKeyPattern":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.NameKeyPatternImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.NameKeyPattern1).ToList();
                    }
                    else
                    {
                        ViewBag.NameKeyPatternImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.NameKeyPattern1).ToList();
                    }
                    break;
                case "NameKeyPatternDescription":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.NameKeyPatternDescriptionImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.NameKeyPatternDescription).ToList();
                    }
                    else
                    {
                        ViewBag.NameKeyPatternDescriptionImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.NameKeyPatternDescription).ToList();
                    }
                    break;
                case "NameKeyAddLeadingZero":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.NameKeyAddLeadingZeroImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.NameKeyAddLeadingZero).ToList();
                    }
                    else
                    {
                        ViewBag.NameKeyAddLeadingZeroImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.NameKeyAddLeadingZero).ToList();
                    }
                    break;
                case "NameKeyTruncateLast":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.NameKeyTruncateLastImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.NameKeyTruncateLast).ToList();
                    }
                    else
                    {
                        ViewBag.NameKeyTruncateLastImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.NameKeyTruncateLast).ToList();
                    }
                    break;
                case "NameKeyRequiredForEDIRequest":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.NameKeyRequiredForEDIRequestImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.NameKeyRequiredForEDIRequest).ToList();
                    }
                    else
                    {
                        ViewBag.NameKeyRequiredForEDIRequestImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.NameKeyRequiredForEDIRequest).ToList();
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
            
            var allUtilityCompanies = _db.UtilityCompanies.Where (x => x.Inactive == false);
            var alreadySelectedUtilityCompanies = from uc in _db.UtilityCompanies where (from nkp in _db.NameKeyPatterns select nkp.UtilityCompanyId).Contains(uc.Id) select uc;
            var leftOverUtilityCompanies = allUtilityCompanies.Except(alreadySelectedUtilityCompanies);
            utilityList.AddRange(leftOverUtilityCompanies.OrderBy(x => x.UtilityCode));
            return utilityList;
        }


        #endregion
    }
}