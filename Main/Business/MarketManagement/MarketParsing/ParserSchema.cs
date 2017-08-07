namespace LibertyPower.Business.MarketManagement.MarketParsing
{
    using System;
    using System.Collections.Generic;
    using System.Text;

    using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;

    public class ParserSchema
    {
        #region Fields

        private ParserColumnList parserColumns;
        private string utilityCode;

        #endregion Fields

        #region Constructors

        internal ParserSchema( string utilityCode, ParserColumnList parserColumns )
        {
            this.utilityCode = utilityCode;
            this.parserColumns = parserColumns;
        }

        #endregion Constructors

        #region Properties

        /// <summary>
        /// List of required fields for this UtilityCode
        /// </summary>
        public ParserColumnList Columns
        {
            get
            {
                return parserColumns;
            }
        }

        /// <summary>
        /// The UtilityCode of this object
        /// </summary>
        public string UtilityCode
        {
            get
            {
                return utilityCode;
            }
        }

        #endregion Properties

        #region Methods

        /// <summary>
        /// Determines if the specified message is required
        /// </summary>
        /// <param name="fieldName"></param>
        /// <param name="context">only check for fields with matching context</param>
        /// <returns>true if required</returns>
        internal bool IsFieldRequired( string fieldName )
        {
            int index = this.doesFieldExist( fieldName );
            if( index > -1 )
            {
                ParserColumn parserColumn = this.parserColumns[index];
                return parserColumn.ValueRequired;
            }
            return false;
        }

        /// <summary>
        /// Determines if the specified message is required
        /// </summary>
        /// <param name="fieldName"></param>
        /// <param name="context">only check for fields with matching context</param>
        /// <returns>true if required</returns>
        internal bool IsFieldRequired( string fieldName, string context )
        {
            int index = this.doesFieldExist( fieldName, context );
            if( index > -1 )
            {
                ParserColumn parserColumn = this.parserColumns[index];
                return parserColumn.ValueRequired;
            }
            return false;
        }

        /// <summary>
        /// determines if message exists in list
        /// </summary>
        /// <param name="fieldName">fieldName to check existence of</param>
        /// <returns>-1 if not found and index if found</returns>
        private int doesFieldExist( string fieldName )
        {
            for( int i = 0; i < parserColumns.Count; i++ )
            {
                string a = fieldName.ToLower().Trim();
                string b = this.parserColumns[i].FieldName.ToLower().Trim();
                if( string.Compare( a, b ) == 0 )
                    return i;
            }
            return -1;
        }

        /// <summary>
        /// determines if message exists in list
        /// </summary>
        /// <param name="fieldName">fieldName to check existence of</param>
        /// <returns>-1 if not found and index if found</returns>
        private int doesFieldExist( string fieldName, string context )
        {
            for( int i = 0; i < parserColumns.Count; i++ )
            {
                string a = fieldName.ToLower().Trim();
                string b = this.parserColumns[i].FieldName.ToLower().Trim();
                if( string.Compare( a, b ) == 0 )
                    return i;
            }
            return -1;
        }

        #endregion Methods
    }
}