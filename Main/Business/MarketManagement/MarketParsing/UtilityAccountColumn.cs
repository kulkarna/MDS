namespace LibertyPower.Business.MarketManagement.MarketParsing
{
    using System;
    using System.Collections.Generic;
    using System.Text;
    using System.Text.RegularExpressions;

    public class ParserColumn
    {
        #region Fields

        private string context;
        private int createdBy;
        private DateTime dateCreated;
        private DateTime dateLastModified;
        string fieldName;
        private int lastModifiedBy;
        private bool valueRequired;

        #endregion Fields

        #region Constructors

        internal ParserColumn(string name, bool valueRequired, string context, int createdBy, DateTime dateCreated, int lastModifiedBy, DateTime dateLastModified)
        {
            this.fieldName = name;
            this.valueRequired = valueRequired;
            this.createdBy = createdBy;
            this.dateCreated = dateCreated;
            this.lastModifiedBy = lastModifiedBy;
            this.dateLastModified = dateLastModified;
            this.context = context;
        }

        internal ParserColumn(string name)
        {
            this.fieldName = name;
        }

        #endregion Constructors

        #region Properties

        /// <summary>
        /// Retrieves the UserID of the user that created this object's database record
        /// </summary>
        public int CreatedBy
        {
            get
            {
                return createdBy;
            }
        }

        /// <summary>
        /// Date this object was 1st created
        /// </summary>
        public DateTime DateCreated
        {
            get
            {
                return dateCreated;
            }
        }

        /// <summary>
        /// Datethis object was last modified
        /// </summary>
        public DateTime DateLastModified
        {
            get
            {
                return dateLastModified;
            }
        }

        public string FieldContext
        {
            get
            {
                return context;
            }
        }

        public string FieldName
        {
            get
            {
                return fieldName;
            }
        }

        /// <summary>
        /// Retrieves the UserID of the last user to modify this object's database record
        /// </summary>
        public int LastModifiedBy
        {
            get
            {
                return lastModifiedBy;
            }
        }

        public bool ValueRequired
        {
            get
            {
                return valueRequired;
            }
        }

        #endregion Properties
    }
}