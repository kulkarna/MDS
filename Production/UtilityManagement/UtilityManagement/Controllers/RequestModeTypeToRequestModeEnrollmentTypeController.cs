using DataAccessLayerEntityFramework;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using UserInterfaceValidationExtensions;
using Utilities;

namespace UtilityManagement.Controllers
{
    [ValidateInputAttribute(false)]
    public class RequestModeTypeToRequestModeEnrollmentTypeController : ControllerBase
    {

        public RequestModeTypeToRequestModeEnrollmentTypeController()
            : base()
        {
            ViewBag.PageName = "RequestModeTypeToRequestModeEnrollmentType";
            ViewBag.IndexPageName = "RequestModeTypeToRequestModeEnrollmentType";
            ViewBag.PageDisplayName = "Request Mode Type To Request Mode Enrollment Type";
        }
        //
        // GET: /RequestModeTypeToRequestModeEnrollmentType/
        public ActionResult Index()
        {
            var requestmodetypetorequestmodeenrollmenttypes = _db.RequestModeTypeToRequestModeEnrollmentTypes.Include(r => r.RequestModeEnrollmentType).Include(r => r.RequestModeType);
            return View(requestmodetypetorequestmodeenrollmenttypes.ToList());
        }

        //
        // GET: /RequestModeTypeToRequestModeEnrollmentType/Details/5
        public ActionResult Details(Guid id)
        {
            RequestModeTypeToRequestModeEnrollmentType requestmodetypetorequestmodeenrollmenttype = _db.RequestModeTypeToRequestModeEnrollmentTypes.Find(id);
            if (requestmodetypetorequestmodeenrollmenttype == null)
            {
                return HttpNotFound();
            }
            return View(requestmodetypetorequestmodeenrollmenttype);
        }

        //
        // GET: /RequestModeTypeToRequestModeEnrollmentType/Create
        public ActionResult Create()
        {
            Session["IsPostBack"] = "false";
            RequestModeTypeToRequestModeEnrollmentType requestModeTypeToRequestModeEnrollmentType = new RequestModeTypeToRequestModeEnrollmentType()
            {
                CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                CreatedDate = DateTime.Now,
                LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                LastModifiedDate = DateTime.Now
            };
            ViewBag.RequestModeEnrollmentTypeId = GetRequestModeEnrollmentTypeSelectList();
            ViewBag.RequestModeTypeId = GetRequestModeTypeSelectList();
            return View(requestModeTypeToRequestModeEnrollmentType);
        }

        //
        // POST: /RequestModeTypeToRequestModeEnrollmentType/Create
        [HttpPost]
        public ActionResult Create(RequestModeTypeToRequestModeEnrollmentType requestmodetypetorequestmodeenrollmenttype)
        {
            Session["IsPostBack"] = "true";
            requestmodetypetorequestmodeenrollmenttype.Id = Guid.NewGuid();
            requestmodetypetorequestmodeenrollmenttype.CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; //  Common.GetUserName(User.Identity.Name);
            requestmodetypetorequestmodeenrollmenttype.CreatedDate = DateTime.Now;
            requestmodetypetorequestmodeenrollmenttype.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; //  Common.GetUserName(User.Identity.Name);
            requestmodetypetorequestmodeenrollmenttype.LastModifiedDate = DateTime.Now;
            if (ModelState.IsValid)
            {
                _db.RequestModeTypeToRequestModeEnrollmentTypes.Add(requestmodetypetorequestmodeenrollmenttype);
                _db.SaveChanges();
                return RedirectToAction("Index");
            }

            ViewBag.RequestModeEnrollmentTypeId = GetRequestModeEnrollmentTypeSelectList(requestmodetypetorequestmodeenrollmenttype.RequestModeEnrollmentTypeId);
            ViewBag.RequestModeTypeId = GetRequestModeTypeSelectList(requestmodetypetorequestmodeenrollmenttype.RequestModeTypeId);
            return View(requestmodetypetorequestmodeenrollmenttype);
        }

        //
        // GET: /RequestModeTypeToRequestModeEnrollmentType/Edit/5
        public ActionResult Edit(Guid id)
        {
            RequestModeTypeToRequestModeEnrollmentType requestmodetypetorequestmodeenrollmenttype = _db.RequestModeTypeToRequestModeEnrollmentTypes.Find(id);
            if (requestmodetypetorequestmodeenrollmenttype == null)
            {
                return HttpNotFound();
            }
            Session["CreatedBy"] = requestmodetypetorequestmodeenrollmenttype.CreatedBy;
            Session["CreatedDate"] = requestmodetypetorequestmodeenrollmenttype.CreatedDate;
            ViewBag.RequestModeEnrollmentTypeId = GetRequestModeEnrollmentTypeSelectList(requestmodetypetorequestmodeenrollmenttype.RequestModeEnrollmentTypeId);
            ViewBag.RequestModeTypeId = GetRequestModeTypeSelectList(requestmodetypetorequestmodeenrollmenttype.RequestModeTypeId);
            return View(requestmodetypetorequestmodeenrollmenttype);
        }

        //
        // POST: /RequestModeTypeToRequestModeEnrollmentType/Edit/5

        [HttpPost]
        public ActionResult Edit(RequestModeTypeToRequestModeEnrollmentType requestmodetypetorequestmodeenrollmenttype)
        {
            if (ModelState.IsValid)
            {
                requestmodetypetorequestmodeenrollmenttype.CreatedBy = Session["CreatedBy"] == null ? GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])) : Session["CreatedBy"].ToString(); 
                requestmodetypetorequestmodeenrollmenttype.CreatedDate = (DateTime)(Session["CreatedDate"] == null ? DateTime.Now : Session["CreatedDate"]);
                requestmodetypetorequestmodeenrollmenttype.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));
                requestmodetypetorequestmodeenrollmenttype.LastModifiedDate = DateTime.Now;

                _db.Entry(requestmodetypetorequestmodeenrollmenttype).State = EntityState.Modified;
                _db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.RequestModeEnrollmentTypeId = GetRequestModeEnrollmentTypeSelectList(requestmodetypetorequestmodeenrollmenttype.RequestModeEnrollmentTypeId);
            ViewBag.RequestModeTypeId = GetRequestModeTypeSelectList(requestmodetypetorequestmodeenrollmenttype.RequestModeTypeId);
            return View(requestmodetypetorequestmodeenrollmenttype);
        }

        //
        // GET: /RequestModeTypeToRequestModeEnrollmentType/Delete/5
        public ActionResult Delete(Guid id)
        {
            RequestModeTypeToRequestModeEnrollmentType requestmodetypetorequestmodeenrollmenttype = _db.RequestModeTypeToRequestModeEnrollmentTypes.Find(id);
            if (requestmodetypetorequestmodeenrollmenttype == null)
            {
                return HttpNotFound();
            }
            return View(requestmodetypetorequestmodeenrollmenttype);
        }

        //
        // POST: /RequestModeTypeToRequestModeEnrollmentType/Delete/5
        [HttpPost, ActionName("Delete")]
        public ActionResult DeleteConfirmed(int id)
        {
            RequestModeTypeToRequestModeEnrollmentType requestmodetypetorequestmodeenrollmenttype = _db.RequestModeTypeToRequestModeEnrollmentTypes.Find(id);
            _db.RequestModeTypeToRequestModeEnrollmentTypes.Remove(requestmodetypetorequestmodeenrollmenttype);
            _db.SaveChanges();
            return RedirectToAction("Index");
        }

        protected override void Dispose(bool disposing)
        {
            _db.Dispose();
            base.Dispose(disposing);
        }
    }
}