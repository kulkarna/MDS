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
    public class BillingAccountPatternController : ControllerBaseWithoutUtilDropDown
    {
        #region private variables and constants
        private const string CLASS = "BillingAccountPatternController";
        private const string UTILITYMANAGEMENT_BILLINGACCTPAT_INDEX = "UTILITYMANAGEMENT_BILLINGACCTPAT_INDEX";
        private const string UTILITYMANAGEMENT_BILLINGACCTPAT_CREATE = "UTILITYMANAGEMENT_BILLINGACCTPAT_CREATE";
        private const string UTILITYMANAGEMENT_BILLINGACCTPAT_EDIT = "UTILITYMANAGEMENT_BILLINGACCTPAT_EDIT";
        private const string UTILITYMANAGEMENT_BILLINGACCTPAT_DETAIL = "UTILITYMANAGEMENT_BILLINGACCTPAT_DETAIL";
        private const string UTILITYMANAGEMENT_BILLINGACCTPAT_UPLD = "UTILITYMANAGEMENT_BILLINGACCTPAT_UPLD";
        private const string UTILITYMANAGEMENT_BILLINGACCTPAT_DOWNLD = "UTILITYMANAGEMENT_BILLINGACCTPAT_DOWNLD";
        #endregion

        #region public constructors
        public BillingAccountPatternController() : base()
        {
            ViewBag.PageName = "BillingAccountPattern";
            ViewBag.IndexPageName = "BillingAccountPattern";
            ViewBag.PageDisplayName = "Billing Account Pattern";
        }
        #endregion

        public override string ActivityGetIndex { get { return UTILITYMANAGEMENT_BILLINGACCTPAT_INDEX; } }

        public override ActionResult GetBlankResponse()
        {
            return View(new List<BillingAccountPattern>());
        }

        #region public methods
        //
        // GET: /BillingAccountPattern/
        public override ActionResult Index()
        {
            string method = "Index()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_BILLINGACCTPAT_INDEX))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_BILLINGACCTPAT_INDEX });
                }

                var response = ObtainResponse();

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));
                return View(response);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new List<BillingAccountPattern>());
            }
        }

        //
        // GET: /BillingAccountPattern/Details/5
        public ActionResult Details(Guid id)
        {
            string method = string.Format("Details(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_BILLINGACCTPAT_DETAIL))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_BILLINGACCTPAT_DETAIL });
                }

                BillingAccountPattern billingAccountPattern = _db.BillingAccountPatterns.Find(id);

                if (billingAccountPattern == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} billingAccountPattern:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, billingAccountPattern));
                return View(billingAccountPattern);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new BillingAccountPattern());
            }
        }

        //
        // GET: /BillingAccountPattern/Create
        public ActionResult Create()
        {
            string method = "Create()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_BILLINGACCTPAT_CREATE))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_BILLINGACCTPAT_CREATE });
                }

                Session[Common.ISPOSTBACK] = "false";
                BillingAccountPattern billingAccountPattern = new BillingAccountPattern()
                {
                    CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                    CreatedDate = DateTime.Now,
                    LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                    LastModifiedDate = DateTime.Now
                };
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} billingAccountPattern:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, billingAccountPattern));
                return View(billingAccountPattern);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new BillingAccountPattern());
            }
        }

        //
        // POST: /BillingAccountPattern/Create
        [HttpPost]
        public ActionResult Create(BillingAccountPattern billingAccountPattern)
        {
            string method = string.Format("Create(BillingAccountPattern billingAccountPattern:{0})", billingAccountPattern == null ? "NULL VALUE" : billingAccountPattern.ToString());
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                Session[Common.ISPOSTBACK] = "true";
                billingAccountPattern.CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                billingAccountPattern.CreatedDate = DateTime.Now;
                billingAccountPattern.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                billingAccountPattern.LastModifiedDate = DateTime.Now;
                if (ModelState.IsValid)
                {
                    billingAccountPattern.Id = Guid.NewGuid();
                    ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(billingAccountPattern.UtilityCompanyId.ToString());
                    if (_db.BillingAccountPatterns.Where(x=>x.UtilityCompanyId == billingAccountPattern.UtilityCompanyId).Count() == 0)
                    {
                        _db.BillingAccountPatterns.Add(billingAccountPattern);
                        _db.SaveChanges();
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Index");
                    }
                }

                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(billingAccountPattern.UtilityCompanyId.ToString());
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT CREATED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(billingAccountPattern);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new BillingAccountPattern());
            }
        }

        //
        // GET: /BillingAccountPattern/Edit/5
        public ActionResult Edit(Guid id)
        {
            string method = string.Format("Edit(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));


                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_BILLINGACCTPAT_EDIT))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_BILLINGACCTPAT_EDIT });
                }
                
                Session[Common.ISPOSTBACK] = "false";
                BillingAccountPattern billingAccountPattern = _db.BillingAccountPatterns.Find(id);
                if (billingAccountPattern == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }
                Session[Common.CREATEDBY] = billingAccountPattern.CreatedBy;
                Session[Common.CREATEDDATE] = billingAccountPattern.CreatedDate;
                Guid utilityCompanyId = _db.BillingAccountPatterns.Where(x => x.Id == id).FirstOrDefault().UtilityCompanyId;
                Session["BillingAccountPattern_UtilityCompanyId"] = utilityCompanyId;
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(utilityCompanyId.ToString());
                
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} billingAccountPattern:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, billingAccountPattern));
                return View(billingAccountPattern);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                BillingAccountPattern requestmodetype = _db.BillingAccountPatterns.Find(id);
                return View(requestmodetype);
            }
        }

        //
        // POST: /BillingAccountPattern/Edit/5
        [HttpPost]
        public ActionResult Edit(BillingAccountPattern billingAccountPattern)
        {
            string method = string.Format("Edit(BillingAccountPattern billingAccountPattern:{0})", billingAccountPattern == null ? "NULL VALUE" : billingAccountPattern.ToString());
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                Session[Common.ISPOSTBACK] = "true";
                billingAccountPattern.UtilityCompanyId = (Guid)Session["BillingAccountPattern_UtilityCompanyId"];
                billingAccountPattern.UtilityCompany = _db.UtilityCompanies.Where(x => x.Id == billingAccountPattern.UtilityCompanyId).FirstOrDefault();
                billingAccountPattern.CreatedBy = Session[Common.CREATEDBY] == null ? "NULL USER NAME" : Session[Common.CREATEDBY].ToString();
                billingAccountPattern.CreatedDate = Session[Common.CREATEDDATE] == null ? DateTime.Now : (DateTime)Session[Common.CREATEDDATE];
                billingAccountPattern.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                billingAccountPattern.LastModifiedDate = DateTime.Now;
                if (ModelState.IsValid)
                {
                    _db.Entry(billingAccountPattern).State = EntityState.Modified;
                    _db.SaveChanges();
                    _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index");
                }
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(billingAccountPattern.UtilityCompanyId.ToString());

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT EDITED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(billingAccountPattern);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(billingAccountPattern);
            }
        }
        #endregion


        #region private and protected methods
        protected override void Dispose(bool disposing)
        {
            _db.Dispose();
            base.Dispose(disposing);
        }

        private List<BillingAccountPattern> ObtainResponse()
        {
            List<BillingAccountPattern> response = _db.BillingAccountPatterns.Where(x => x.UtilityCompany.Inactive == false).ToList();

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
                case "BillingAccountPattern":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.BillingAccountPatternImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.BillingAccountPattern1).ToList();
                    }
                    else
                    {
                        ViewBag.BillingAccountPatternImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.BillingAccountPattern1).ToList();
                    }
                    break;
                case "BillingAccountPatternDescription":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.BillingAccountPatternDescriptionImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.BillingAccountPatternDescription).ToList();
                    }
                    else
                    {
                        ViewBag.BillingAccountPatternDescriptionImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.BillingAccountPatternDescription).ToList();
                    }
                    break;
                case "BillingAccountAddLeadingZero":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.BillingAccountAddLeadingZeroImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.BillingAccountAddLeadingZero).ToList();
                    }
                    else
                    {
                        ViewBag.BillingAccountAddLeadingZeroImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.BillingAccountAddLeadingZero).ToList();
                    }
                    break;
                case "BillingAccountTruncateLast":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.BillingAccountTruncateLastImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.BillingAccountTruncateLast).ToList();
                    }
                    else
                    {
                        ViewBag.BillingAccountTruncateLastImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.BillingAccountTruncateLast).ToList();
                    }
                    break;
                case "BillingAccountRequiredForEDIRequest":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.BillingAccountRequiredForEDIRequestImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.BillingAccountRequiredForEDIRequest).ToList();
                    }
                    else
                    {
                        ViewBag.BillingAccountRequiredForEDIRequestImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.BillingAccountRequiredForEDIRequest).ToList();
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
            var alreadySelectedUtilityCompanies = from uc in _db.UtilityCompanies where (from bap in _db.BillingAccountPatterns select bap.UtilityCompanyId).Contains(uc.Id) select uc;
            var leftOverUtilityCompanies = allUtilityCompanies.Except(alreadySelectedUtilityCompanies);
            utilityList.AddRange(leftOverUtilityCompanies.OrderBy(x => x.UtilityCode));
            return utilityList;
        }
        #endregion
    }
}