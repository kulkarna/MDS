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
    public class ServiceAccountPatternController : ControllerBase
    {
        #region private variables and constants
        private const string CLASS = "ServiceAccountPatternController";
        private const string UTILITYMANAGEMENT_SERVACCOUNTPAT_INDEX = "UTILITYMANAGEMENT_SERVACCOUNTPAT_INDEX";
        private const string UTILITYMANAGEMENT_SERVACCOUNTPAT_CREATE = "UTILITYMANAGEMENT_SERVACCOUNTPAT_CREATE";
        private const string UTILITYMANAGEMENT_SERVACCOUNTPAT_EDIT = "UTILITYMANAGEMENT_SERVACCOUNTPAT_EDIT";
        private const string UTILITYMANAGEMENT_SERVACCOUNTPAT_DETAIL = "UTILITYMANAGEMENT_SERVACCOUNTPAT_DETAIL";
        private const string UTILITYMANAGEMENT_SERVACCOUNTPAT_UPLD = "UTILITYMANAGEMENT_SERVACCOUNTPAT_UPLD";
        private const string UTILITYMANAGEMENT_SERVACCOUNTPAT_DOWNLD = "UTILITYMANAGEMENT_SERVACCOUNTPAT_DOWNLD";
        #endregion

        #region public constructors
        public ServiceAccountPatternController() : base()
        {
            ViewBag.PageName = "ServiceAccountPattern";
            ViewBag.IndexPageName = "ServiceAccountPattern";
            ViewBag.PageDisplayName = "Service Account Pattern";
        }
        #endregion

        #region public methods
        //
        // GET: /ServiceAccountPattern/
        public ActionResult Index()
        {
            string method = "Index()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_SERVACCOUNTPAT_INDEX))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_SERVACCOUNTPAT_INDEX });
                }

                var response = ObtainResponse();

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));
                return View(response);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new List<ServiceAccountPattern>());
            }
        }

        //
        // GET: /ServiceAccountPattern/Details/5
        public ActionResult Details(Guid id)
        {
            string method = string.Format("Details(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_SERVACCOUNTPAT_DETAIL))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_SERVACCOUNTPAT_DETAIL });
                }

                ServiceAccountPattern serviceAccountPattern = _db.ServiceAccountPatterns.Find(id);

                if (serviceAccountPattern == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} serviceAccountPattern:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, serviceAccountPattern));
                return View(serviceAccountPattern);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new ServiceAccountPattern());
            }
        }

        //
        // GET: /ServiceAccountPattern/Create
        public ActionResult Create()
        {
            string method = "Create()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_SERVACCOUNTPAT_CREATE))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_SERVACCOUNTPAT_CREATE });
                }

                Session[Common.ISPOSTBACK] = "false";
                ServiceAccountPattern serviceAccountPattern = new ServiceAccountPattern()
                {
                    CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])), 
                    CreatedDate = DateTime.Now,
                    LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                    LastModifiedDate = DateTime.Now
                };
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} serviceAccountPattern:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, serviceAccountPattern));
                return View(serviceAccountPattern);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new ServiceAccountPattern());
            }
        }

        //
        // POST: /ServiceAccountPattern/Create
        [HttpPost]
        public ActionResult Create(ServiceAccountPattern serviceAccountPattern)
        {
            string method = string.Format("Create(ServiceAccountPattern serviceAccountPattern:{0})", serviceAccountPattern == null ? "NULL VALUE" : serviceAccountPattern.ToString());
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                Session[Common.ISPOSTBACK] = "true";
                serviceAccountPattern.CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                serviceAccountPattern.CreatedDate = DateTime.Now;
                serviceAccountPattern.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                serviceAccountPattern.LastModifiedDate = DateTime.Now;
                if (ModelState.IsValid)
                {
                    serviceAccountPattern.Id = Guid.NewGuid();
                    ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(serviceAccountPattern.UtilityCompanyId.ToString());
                    if (_db.ServiceAccountPatterns.Where(x=>x.UtilityCompanyId == serviceAccountPattern.UtilityCompanyId).Count() == 0)
                    {
                        _db.ServiceAccountPatterns.Add(serviceAccountPattern);
                        _db.SaveChanges();
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Index");
                    }
                }

                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(serviceAccountPattern.UtilityCompanyId.ToString());
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT CREATED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(serviceAccountPattern);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new ServiceAccountPattern());
            }
        }

        //
        // GET: /ServiceAccountPattern/Edit/5
        public ActionResult Edit(Guid id)
        {
            string method = string.Format("Edit(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_SERVACCOUNTPAT_EDIT))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_SERVACCOUNTPAT_EDIT });
                }
                
                Session[Common.ISPOSTBACK] = "false";
                ServiceAccountPattern serviceAccountPattern = _db.ServiceAccountPatterns.Find(id);
                if (serviceAccountPattern == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }
                Session[Common.CREATEDBY] = serviceAccountPattern.CreatedBy;
                Session[Common.CREATEDDATE] = serviceAccountPattern.CreatedDate;
                Guid utilityCompanyId = _db.ServiceAccountPatterns.Where(x => x.Id == id).FirstOrDefault().UtilityCompanyId;
                Session["ServiceAccountPattern_UtilityCompanyId"] = utilityCompanyId;
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(utilityCompanyId.ToString());
                
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} serviceAccountPattern:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, serviceAccountPattern));
                return View(serviceAccountPattern);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                ServiceAccountPattern requestmodetype = _db.ServiceAccountPatterns.Find(id);
                return View(requestmodetype);
            }
        }

        //
        // POST: /ServiceAccountPattern/Edit/5
        [HttpPost]
        public ActionResult Edit(ServiceAccountPattern serviceAccountPattern)
        {
            string method = string.Format("Edit(ServiceAccountPattern serviceAccountPattern:{0})", serviceAccountPattern == null ? "NULL VALUE" : serviceAccountPattern.ToString());
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                Session[Common.ISPOSTBACK] = "true";
                serviceAccountPattern.UtilityCompanyId = (Guid)Session["ServiceAccountPattern_UtilityCompanyId"];
                serviceAccountPattern.CreatedBy = Session[Common.CREATEDBY] == null ? "NULL USER NAME" : Session[Common.CREATEDBY].ToString();
                serviceAccountPattern.CreatedDate = Session[Common.CREATEDDATE] == null ? DateTime.Now : (DateTime)Session[Common.CREATEDDATE];
                serviceAccountPattern.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                serviceAccountPattern.LastModifiedDate = DateTime.Now;
                serviceAccountPattern.UtilityCompany = _db.UtilityCompanies.Where(x => x.Id == serviceAccountPattern.UtilityCompanyId).FirstOrDefault();
                if (ModelState.IsValid && serviceAccountPattern.IsServiceAccountPatternValid())
                {
                    _db.Entry(serviceAccountPattern).State = EntityState.Modified;
                    _db.SaveChanges();
                    _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index");
                }
                Session[Common.CREATEDBY] = serviceAccountPattern.CreatedBy;
                Session[Common.CREATEDDATE] = serviceAccountPattern.CreatedDate;
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(serviceAccountPattern.UtilityCompanyId.ToString());

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT EDITED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(serviceAccountPattern);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(serviceAccountPattern);
            }
        }
        #endregion


        #region private and protected methods
        protected override void Dispose(bool disposing)
        {
            _db.Dispose();
            base.Dispose(disposing);
        }

        private List<ServiceAccountPattern> ObtainResponse()
        {
            List<ServiceAccountPattern> response = _db.ServiceAccountPatterns.Where(x => x.UtilityCompany.Inactive == false).ToList();

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
                case "ServiceAccountPattern":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.ServiceAccountPatternImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.ServiceAccountPattern1).ToList();
                    }
                    else
                    {
                        ViewBag.ServiceAccountPatternImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.ServiceAccountPattern1).ToList();
                    }
                    break;
                case "ServiceAccountPatternDescription":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.ServiceAccountPatternDescriptionImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.ServiceAccountPatternDescription).ToList();
                    }
                    else
                    {
                        ViewBag.ServiceAccountPatternDescriptionImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.ServiceAccountPatternDescription).ToList();
                    }
                    break;
                case "ServiceAccountAddLeadingZero":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.ServiceAccountAddLeadingZeroImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.ServiceAccountAddLeadingZero).ToList();
                    }
                    else
                    {
                        ViewBag.ServiceAccountAddLeadingZeroImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.ServiceAccountAddLeadingZero).ToList();
                    }
                    break;
                case "ServiceAccountTruncateLast":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.ServiceAccountTruncateLastImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.ServiceAccountTruncateLast).ToList();
                    }
                    else
                    {
                        ViewBag.ServiceAccountTruncateLastImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.ServiceAccountTruncateLast).ToList();
                    }
                    break;
                case "ServiceAccountRequiredForEDIRequest":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.ServiceAccountRequiredForEDIRequestImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.ServiceAccountRequiredForEDIRequest).ToList();
                    }
                    else
                    {
                        ViewBag.ServiceAccountRequiredForEDIRequestImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.ServiceAccountRequiredForEDIRequest).ToList();
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
            var alreadySelectedUtilityCompanies = from uc in _db.UtilityCompanies where (from sap in _db.ServiceAccountPatterns select sap.UtilityCompanyId).Contains(uc.Id) select uc;
            var leftOverUtilityCompanies = allUtilityCompanies.Except(alreadySelectedUtilityCompanies);
            utilityList.AddRange(leftOverUtilityCompanies.OrderBy(x => x.UtilityCode));
            return utilityList;
        }
        #endregion
    }
}