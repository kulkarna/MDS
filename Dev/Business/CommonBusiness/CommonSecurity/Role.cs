using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CommonBusiness.SecurityManager
{
    public class Role
    {
        #region Constructors
		internal Role(int roleID, string roleName, DateTime dateCreated,
			DateTime dateModified,
			int createdBy, int modifiedBy)
			: this(roleID, roleName, null, dateCreated, dateModified, createdBy, modifiedBy)
		{ }

		internal Role(int roleID, string roleName, string description, DateTime dateCreated,
			DateTime dateModified,
			int createdBy, int modifiedBy)
		{
			this.RoleID = roleID;
			this.RoleName = roleName;
			this.Description = description;

			this.DateCreated = dateCreated;

			this.CreatedBy = createdBy;
			this.ModifiedBy = modifiedBy;
			this.DateModified = dateModified;
		}

        public Role() { 
        }
        #endregion

        #region Properties

        private int roleID;
        private string roleName;
		private string description;
        private DateTime dateCreated;
        private DateTime dateModified;
        private int modifiedBy;
        private int createdBy;


        private ActivityList activitiesOfRole;
    
        public ActivityList ActivitiesOfRole
        {
			get
			{
				if (activitiesOfRole == null)
					activitiesOfRole = ActivityFactory.GetActivitiesOfRole(this.RoleID);

				return activitiesOfRole;
			}
            set { activitiesOfRole = value; }
        }
        public int RoleID
        {
            get { return roleID; }
            set { roleID = value; }
        }
        

        public string RoleName
        {
            get { return roleName; }
            set { roleName = value; }
        }

		public string Description
		{
			get { return description; }
			set { description = value; }
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

        public override string ToString()
        {
            return this.RoleName;
        }
        
    }
}
