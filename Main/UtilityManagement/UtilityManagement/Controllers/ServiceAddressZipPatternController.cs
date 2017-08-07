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
    public class ServiceAddressZipPatternController : ControllerBase
    {
        #region private variables and constants
        private const string CLASS = "ServiceAddressZipPatternController";
        private const string UTILITYMANAGEMENT_SERVADDRZIPPAT_INDEX = "UTILITYMANAGEMENT_SERVADDRZIPPAT_INDEX";
        private const string UTILITYMANAGEMENT_SERVADDRZIPPAT_CREATE = "UTILITYMANAGEMENT_SERVADDRZIPPAT_CREATE";
        private const string UTILITYMANAGEMENT_SERVADDRZIPPAT_EDIT = "UTILITYMANAGEMENT_SERVADDRZIPPAT_EDIT";
        private const string UTILITYMANAGEMENT_SERVADDRZIPPAT_DETAIL = "UTILITYMANAGEMENT_SERVADDRZIPPAT_DETAIL";
        private const string UTILITYMANAGEMENT_SERVADDRZIPPAT_UPLD = "UTILITYMANAGEMENT_SERVADDRZIPPAT_UPLD";
        private const string UTILITYMANAGEMENT_SERVADDRZIPPAT_DOWNLD = "UTILITYMANAGEMENT_SERVADDRZIPPAT_DOWNLD";
        #endregion

        #region public constructors
        public ServiceAddressZipPatternController() : base()
        {
            ViewBag.PageName = "ServiceAddressZipPattern";
            ViewBag.IndexPageName = "ServiceAddressZipPattern";
            ViewBag.PageDisplayName = "Service Address Zip Pattern";
        }
        #endregion

        #region public methods
        //
        // GET: /ServiceAddressZipPattern/
        public ActionResult Index()
        {
            string method = "Index()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_SERVADDRZIPPAT_INDEX))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_SERVADDRZIPPAT_INDEX });
                }

                var response = ObtainResponse();

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));
                return View(response);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new List<ServiceAddressZipPattern>());
            }
        }

        //
        // GET: /ServiceAddressZipPattern/Details/5
        public ActionResult Details(Guid id)
        {
            string method = string.Format("Details(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_SERVADDRZIPPAT_DETAIL))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_SERVADDRZIPPAT_DETAIL });
                }

                ServiceAddressZipPattern serviceAddressZipPattern = _db.ServiceAddressZipPatterns.Find(id);

                if (serviceAddressZipPattern == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} serviceAddressZipPattern:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, serviceAddressZipPattern));
                return View(serviceAddressZipPattern);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new ServiceAddressZipPattern());
            }
        }

        //
        // GET: /ServiceAddressZipPattern/Create
        public ActionResult Create()
        {
            string method = "Create()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_SERVADDRZIPPAT_CREATE))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_SERVADDRZIPPAT_CREATE });
                }

                Session[Common.ISPOSTBACK] = "false";
                ServiceAddressZipPattern serviceAddressZipPattern = new ServiceAddressZipPattern()
                {
                    CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                    CreatedDate = DateTime.Now,
                    LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                    LastModifiedDate = DateTime.Now
                };
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} serviceAddressZipPattern:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, serviceAddressZipPattern));
                return View(serviceAddressZipPattern);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new ServiceAddressZipPattern());
            }
        }

        //
        // POST: /ServiceAddressZipPattern/Create
        [HttpPost]
        public ActionResult Create(ServiceAddressZipPattern serviceAddressZipPattern)
        {
            string method = string.Format("Create(ServiceAddressZipPattern serviceAddressZipPattern:{0})", serviceAddressZipPattern == null ? "NULL VALUE" : serviceAddressZipPattern.ToString());
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                Session[Common.ISPOSTBACK] = "true";
                serviceAddressZipPattern.CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                serviceAddressZipPattern.CreatedDate = DateTime.Now;
                serviceAddressZipPattern.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                serviceAddressZipPattern.LastModifiedDate = DateTime.Now; 
                if (ModelState.IsValid)
                {
                    serviceAddressZipPattern.Id = Guid.NewGuid();

                    ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(serviceAddressZipPattern.UtilityCompanyId.ToString());
                    if (_db.ServiceAddressZipPatterns.Where(x => x.UtilityCompanyId == serviceAddressZipPattern.UtilityCompanyId).Count() == 0 && serviceAddressZipPattern.IsServiceAddressZipPatternValid())
                    {
                        _db.ServiceAddressZipPatterns.Add(serviceAddressZipPattern);
                        _db.SaveChanges();
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Index");
                    }
                }
                Session[Common.CREATEDBY] = serviceAddressZipPattern.CreatedBy;
                Session[Common.CREATEDDATE] = serviceAddressZipPattern.CreatedDate;
                Session["LastModifiedBy"] = serviceAddressZipPattern.LastModifiedBy;
                Session["LastModifiedDate"] = serviceAddressZipPattern.LastModifiedDate;
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(serviceAddressZipPattern.UtilityCompanyId.ToString());
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT CREATED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(serviceAddressZipPattern);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new ServiceAddressZipPattern());
            }
        }

        //
        // GET: /ServiceAddressZipPattern/Edit/5
        public ActionResult Edit(Guid id)
        {
            string method = string.Format("Edit(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                // security check
                if (!IsUserAuthorizedForThisActivity(Session[Common.MESSAGEID].ToString(), UTILITYMANAGEMENT_SERVADDRZIPPAT_EDIT))
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Invalid User!!! {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index", "UnauthorizedUser", new { activityName = UTILITYMANAGEMENT_SERVADDRZIPPAT_EDIT });
                }

                Session[Common.ISPOSTBACK] = "false";
                ServiceAddressZipPattern serviceAddressZipPattern = _db.ServiceAddressZipPatterns.Find(id);
                if (serviceAddressZipPattern == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }
                Session[Common.CREATEDBY] = serviceAddressZipPattern.CreatedBy;
                Session[Common.CREATEDDATE] = serviceAddressZipPattern.CreatedDate;
                Guid utilityCompanyId = _db.ServiceAddressZipPatterns.Where(x => x.Id == id).FirstOrDefault().UtilityCompanyId;
                Session["ServiceAddressZipPattern_UtilityCompanyId"] = utilityCompanyId;
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(utilityCompanyId.ToString());
                
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} serviceAddressZipPattern:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, serviceAddressZipPattern));
                return View(serviceAddressZipPattern);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                ServiceAddressZipPattern requestmodetype = _db.ServiceAddressZipPatterns.Find(id);
                return View(requestmodetype);
            }
        }

        //
        // POST: /ServiceAddressZipPattern/Edit/5
        [HttpPost]
        public ActionResult Edit(ServiceAddressZipPattern serviceAddressZipPattern)
        {
            string method = string.Format("Edit(ServiceAddressZipPattern serviceAddressZipPattern:{0})", serviceAddressZipPattern == null ? "NULL VALUE" : serviceAddressZipPattern.ToString());
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                Session[Common.ISPOSTBACK] = "true";
                serviceAddressZipPattern.UtilityCompanyId = (Guid)Session["ServiceAddressZipPattern_UtilityCompanyId"];
                serviceAddressZipPattern.CreatedBy = Session[Common.CREATEDBY] == null ? "NULL USER NAME" : Session[Common.CREATEDBY].ToString();
                serviceAddressZipPattern.CreatedDate = Session[Common.CREATEDDATE] == null ? DateTime.Now : (DateTime)Session[Common.CREATEDDATE];
                serviceAddressZipPattern.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                serviceAddressZipPattern.LastModifiedDate = DateTime.Now;
                serviceAddressZipPattern.UtilityCompany = _db.UtilityCompanies.Where(x => x.Id == serviceAddressZipPattern.UtilityCompanyId).FirstOrDefault();
                if (ModelState.IsValid && serviceAddressZipPattern.IsServiceAddressZipPatternValid())
                {
                    _db.Entry(serviceAddressZipPattern).State = EntityState.Modified;
                    _db.SaveChanges();
                    _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return RedirectToAction("Index");
                }
                Session[Common.CREATEDBY] = serviceAddressZipPattern.CreatedBy;
                Session[Common.CREATEDDATE] = serviceAddressZipPattern.CreatedDate;
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(serviceAddressZipPattern.UtilityCompanyId.ToString());

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT EDITED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(serviceAddressZipPattern);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(serviceAddressZipPattern);
            }
        }
        #endregion


        #region private and protected methods
        protected override void Dispose(bool disposing)
        {
            _db.Dispose();
            base.Dispose(disposing);
        }

        private List<ServiceAddressZipPattern> ObtainResponse()
        {
            List<ServiceAddressZipPattern> response = _db.ServiceAddressZipPatterns.Where(x => x.UtilityCompany.Inactive == false).ToList();

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
                case "ServiceAddressZipPattern":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.ServiceAddressZipPatternImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.ServiceAddressZipPattern1).ToList();
                    }
                    else
                    {
                        ViewBag.ServiceAddressZipPatternImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.ServiceAddressZipPattern1).ToList();
                    }
                    break;
                case "ServiceAddressZipPatternDescription":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.ServiceAddressZipPatternDescriptionImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.ServiceAddressZipPatternDescription).ToList();
                    }
                    else
                    {
                        ViewBag.ServiceAddressZipPatternDescriptionImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.ServiceAddressZipPatternDescription).ToList();
                    }
                    break;
                case "ServiceAddressZipAddLeadingZero":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.ServiceAddressZipAddLeadingZeroImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.ServiceAddressZipAddLeadingZero).ToList();
                    }
                    else
                    {
                        ViewBag.ServiceAddressZipAddLeadingZeroImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.ServiceAddressZipAddLeadingZero).ToList();
                    }
                    break;
                case "ServiceAddressZipTruncateLast":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.ServiceAddressZipTruncateLastImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.ServiceAddressZipTruncateLast).ToList();
                    }
                    else
                    {
                        ViewBag.ServiceAddressZipTruncateLastImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.ServiceAddressZipTruncateLast).ToList();
                    }
                    break;
                case "ServiceAddressZipRequiredForEDIRequest":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.ServiceAddressZipRequiredForEDIRequestImageUrl = Common.DOWNARROW;
                        response = response.OrderByDescending(x => x.ServiceAddressZipRequiredForEDIRequest).ToList();
                    }
                    else
                    {
                        ViewBag.ServiceAddressZipRequiredForEDIRequestImageUrl = Common.UPARROW;
                        response = response.OrderBy(x => x.ServiceAddressZipRequiredForEDIRequest).ToList();
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
            var alreadySelectedUtilityCompanies = from uc in _db.UtilityCompanies where (from sazp in _db.ServiceAddressZipPatterns select sazp.UtilityCompanyId).Contains(uc.Id) select uc;
            var leftOverUtilityCompanies = allUtilityCompanies.Except(alreadySelectedUtilityCompanies);
            utilityList.AddRange(leftOverUtilityCompanies.OrderBy(x => x.UtilityCode));
            return utilityList;
        }
        #endregion
    }
}