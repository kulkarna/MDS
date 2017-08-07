using DataAccessLayerEntityFramework;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Utilities;
using UserInterfaceValidationExtensions;

namespace UtilityManagement.Controllers
{
    [ValidateInputAttribute(false)]
    public class RequestModeTypeToRequestModeTypeGenreController : ControllerBase
    {

        public RequestModeTypeToRequestModeTypeGenreController() : base()
        {
            ViewBag.PageName = "RequestModeTypeToRequestModeTypeGenre";
            ViewBag.IndexPageName = "RequestModeTypeToRequestModeTypeGenre";
            ViewBag.PageDisplayName = "Request Mode Type To Request Mode Type Genre";
        }

        //
        // GET: /RequestModeTypeToRequestModeTypeGenre/
        public ActionResult Index()
        {
            var requestmodetypetorequestmodetypegenres = _db.RequestModeTypeToRequestModeTypeGenres.Include(r => r.RequestModeType).Include(r => r.RequestModeTypeGenre);
            return View(requestmodetypetorequestmodetypegenres.ToList());
        }

        //
        // GET: /RequestModeTypeToRequestModeTypeGenre/Details/5
        public ActionResult Details(Guid id)
        {
            RequestModeTypeToRequestModeTypeGenre requestmodetypetorequestmodetypegenre = _db.RequestModeTypeToRequestModeTypeGenres.Find(id);
            if (requestmodetypetorequestmodetypegenre == null)
            {
                return HttpNotFound();
            }
            return View(requestmodetypetorequestmodetypegenre);
        }

        //
        // GET: /RequestModeTypeToRequestModeTypeGenre/Create
        public ActionResult Create()
        {
            Session["IsPostBack"] = "false";
            RequestModeTypeToRequestModeTypeGenre requestModeTypeToRequestModeTypeGenre = new RequestModeTypeToRequestModeTypeGenre()
            {
                CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                CreatedDate = DateTime.Now,
                LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                LastModifiedDate = DateTime.Now
            };

            ViewBag.RequestModeTypeId = GetRequestModeTypeSelectList();
            ViewBag.RequestModeTypeGenreId = new SelectList( _db.RequestModeTypeGenres.OrderBy(x => x.Name), "Id", "Name");
            return View(requestModeTypeToRequestModeTypeGenre);
        }

        //
        // POST: /RequestModeTypeToRequestModeTypeGenre/Create
        [HttpPost]
        public ActionResult Create(RequestModeTypeToRequestModeTypeGenre requestmodetypetorequestmodetypegenre)
        {
            Session["IsPostBack"] = "true";
            if (ModelState.IsValid)
            {
                requestmodetypetorequestmodetypegenre.Id = Guid.NewGuid();
                requestmodetypetorequestmodetypegenre.CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                requestmodetypetorequestmodetypegenre.CreatedDate = DateTime.Now;
                requestmodetypetorequestmodetypegenre.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                requestmodetypetorequestmodetypegenre.LastModifiedDate = DateTime.Now;
                if (requestmodetypetorequestmodetypegenre.IsRequestModeTypeToRequestModeTypeGenreValidationValid())
                {
                    _db.RequestModeTypeToRequestModeTypeGenres.Add(requestmodetypetorequestmodetypegenre);
                    _db.SaveChanges();
                    return RedirectToAction("Index");
                }
            }

            ViewBag.RequestModeTypeId = GetRequestModeTypeSelectList(requestmodetypetorequestmodetypegenre.RequestModeTypeId);
            ViewBag.RequestModeTypeGenreId = new SelectList( _db.RequestModeTypeGenres.OrderBy(x => x.Name), "Id", "Name", requestmodetypetorequestmodetypegenre.RequestModeTypeGenreId);
            return View(requestmodetypetorequestmodetypegenre);
        }

        //
        // GET: /RequestModeTypeToRequestModeTypeGenre/Edit/5
        public ActionResult Edit(Guid id)
        {
            Session["IsPostBack"] = "false";
            RequestModeTypeToRequestModeTypeGenre requestmodetypetorequestmodetypegenre = _db.RequestModeTypeToRequestModeTypeGenres.Find(id);
            if (requestmodetypetorequestmodetypegenre == null)
            {
                return HttpNotFound();
            }
            Session["CreatedBy"] = requestmodetypetorequestmodetypegenre.CreatedBy;
            Session["CreatedDate"] = requestmodetypetorequestmodetypegenre.CreatedDate;
            ViewBag.RequestModeTypeId = GetRequestModeTypeSelectList(requestmodetypetorequestmodetypegenre.RequestModeTypeId);
            ViewBag.RequestModeTypeGenreId = new SelectList( _db.RequestModeTypeGenres.OrderBy(x => x.Name), "Id", "Name", requestmodetypetorequestmodetypegenre.RequestModeTypeGenreId);
            return View(requestmodetypetorequestmodetypegenre);
        }

        //
        // POST: /RequestModeTypeToRequestModeTypeGenre/Edit/5
        [HttpPost]
        public ActionResult Edit(RequestModeTypeToRequestModeTypeGenre requestmodetypetorequestmodetypegenre)
        {
            Session["IsPostBack"] = "true";
            if (ModelState.IsValid)
            {
                requestmodetypetorequestmodetypegenre.CreatedBy = Session["CreatedBy"] == null ? "NULL USER NAME" : Session["CreatedBy"].ToString();
                requestmodetypetorequestmodetypegenre.CreatedDate = Session["CreatedDate"] == null ? DateTime.Now : (DateTime)Session["CreatedDate"];
                requestmodetypetorequestmodetypegenre.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                requestmodetypetorequestmodetypegenre.LastModifiedDate = DateTime.Now;
                if (requestmodetypetorequestmodetypegenre.IsRequestModeTypeToRequestModeTypeGenreValidationValid())
                {
                    _db.Entry(requestmodetypetorequestmodetypegenre).State = EntityState.Modified;
                    _db.SaveChanges();
                return RedirectToAction("Index");
            }
                Session["CreatedBy"] = requestmodetypetorequestmodetypegenre.CreatedBy;
                Session["CreatedDate"] = requestmodetypetorequestmodetypegenre.CreatedDate;
            }
            ViewBag.RequestModeTypeId = GetRequestModeTypeSelectList(requestmodetypetorequestmodetypegenre.RequestModeTypeId);
            ViewBag.RequestModeTypeGenreId = new SelectList(_db.RequestModeTypeGenres.OrderBy(x => x.Name), "Id", "Name", requestmodetypetorequestmodetypegenre.RequestModeTypeGenreId);
            return View(requestmodetypetorequestmodetypegenre);
        }

        //
        // GET: /RequestModeTypeToRequestModeTypeGenre/Delete/5
        public ActionResult Delete(Guid id)
        {
            RequestModeTypeToRequestModeTypeGenre requestmodetypetorequestmodetypegenre = _db.RequestModeTypeToRequestModeTypeGenres.Find(id);
            if (requestmodetypetorequestmodetypegenre == null)
            {
                return HttpNotFound();
            }
            return View(requestmodetypetorequestmodetypegenre);
        }

        //
        // POST: /RequestModeTypeToRequestModeTypeGenre/Delete/5
        [HttpPost, ActionName("Delete")]
        public ActionResult DeleteConfirmed(Guid id)
        {
            RequestModeTypeToRequestModeTypeGenre requestmodetypetorequestmodetypegenre = _db.RequestModeTypeToRequestModeTypeGenres.Find(id);
            _db.RequestModeTypeToRequestModeTypeGenres.Remove(requestmodetypetorequestmodetypegenre);
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