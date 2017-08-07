using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CommonBusiness.SecurityManager
{
    public class AppName
    {
        //       ApplicationKey
        //AppKey
        //AppDescription
        //DateCreated


        #region Properties

        private string appDescription;
        private DateTime dateCreated;
        private DateTime dateModified;
        private int modifiedBy;
        private int createdBy;
        private int applicationKey;
        private string appKey;

        public int ApplicationKey
        {
            get { return applicationKey; }
            set { applicationKey = value; }
        }


        public string AppKey
        {
            get { return appKey; }
            set { appKey = value; }
        }

        public string AppDescription
        {
            get { return appDescription; }
            set { appDescription = value; }
        }

        public DateTime DateCreated
        {
            get { return dateCreated; }
            set { dateCreated = value; }
        }

        public DateTime DateModified
        {
            get { return dateModified; }
            set { dateModified = value; }
        }


        public int CreatedBy
        {
            get { return createdBy; }
            set { createdBy = value; }
        }


        public int ModifiedBy
        {
            get { return modifiedBy; }
            set { modifiedBy = value; }
        }

        #endregion

        #region Constructors
        public AppName()
        {
        }
        public AppName(int applicationKey, string appKey, string appDescription,
                         DateTime dateCreated, DateTime dateModified,
                         int modifiedBy, int createdBy)
        {
            this.appDescription = appDescription;
            this.appKey = appKey;
            this.applicationKey= applicationKey;
            this.createdBy= createdBy;
            this.dateCreated = dateCreated;
            this.dateModified = dateModified;
            this.modifiedBy = modifiedBy;
            

        }
        #endregion

    }
}
