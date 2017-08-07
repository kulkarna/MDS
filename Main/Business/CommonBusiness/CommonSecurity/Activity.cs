using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CommonBusiness.SecurityManager
{
    public class Activity
    {
        #region Properties

        private int activityKey;
        private string activityDesc;
        private string appKey;
        private DateTime dateCreated;
        private DateTime dateModified;
        private int modifiedBy;
        private int createdBy;

        public int ActivityKey
        {
            get { return activityKey; }
            set { activityKey = value; }
        }
        

        public string ActivityDesc
        {
            get { return activityDesc; }
            set { activityDesc = value; }
        }
        

        public string AppKey
        {
            get { return appKey; }
            set { appKey = value; }
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
        private string roleName;

        public string RoleName
        {
            get { return roleName; }
            set { roleName = value; }
        }
	
        #endregion

        #region Constructors
        public Activity() { 
        }
        /// <summary>
        /// load an activity with values from the activity table.
        /// </summary>
        /// <param name="activityKey">internal identity column from the database</param>
        /// <param name="activityDesc">description of the activity</param>
        /// <param name="appKey">unique key of the activity</param>
        /// <param name="dateCreated"></param>
        /// <param name="dateModified"></param>
        /// <param name="createdBy">integer value of the id in the user table.</param>
        /// <param name="modifiedBy"></param>
        internal Activity(int activityKey, string activityDesc, 
            string appKey, DateTime dateCreated, 
            DateTime dateModified,
            int createdBy, int modifiedBy)
        {
            this.activityKey = activityKey;
            this.activityDesc = activityDesc;
            this.appKey = appKey;
            this.dateCreated = dateCreated;
            this.createdBy = createdBy;
            this.modifiedBy = modifiedBy;
            this.DateModified = dateModified;

        }
        /// <summary>
        
        /// </summary>
        /// <param name="roleName">name of the role for this activity in the role table</param>
        /// <param name="activityKey">internal identity column from the database</param>
        /// <param name="activityDesc">description of the activity</param>
        /// <param name="appKey">unique key of the activity</param>
        
        internal Activity(string roleName, int activityKey, string activityDesc, string appKey)
        {
            this.activityDesc = activityDesc;
            this.activityKey = activityKey;
            this.roleName = roleName;
            this.appKey = appKey;

        }
        #endregion

    }
}
