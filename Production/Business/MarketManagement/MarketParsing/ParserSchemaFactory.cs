namespace LibertyPower.Business.MarketManagement.MarketParsing
{
    using System;
    using System.Collections.Generic;
    using System.Data;
    using System.Text;

    using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;

    public static class ParserSchemaFactory
    {
        #region Methods

        internal static ParserSchema CreateParserSchema( string utilityCode, ParserColumnList parserColumns )
        {
            if( utilityCode.Trim().Length == 0 )
                throw new MarketParsingException( "UtilityCode not specified" );

            if( utilityCode.Trim().Length > 50 )
                throw new MarketParsingException( "UtilityCode specified exceeds maximum length of 50 characters" );

            ParserSchema parserSchema = new ParserSchema(utilityCode, parserColumns );

            return parserSchema;
        }

        /// <summary>
        /// Retrieves the minimum message requirements for creating a UtilityAccount for each UtilityCode;
        /// Additionally provides support for validation of minimal message values (not business requirements)
        /// </summary>
        /// 
        /// <returns></returns>
        internal static ParserSchemaDictionary GetParserSchemas()
        {
            ParserSchemaDictionary schemas = null;

            DataSet ds = MarketParsingSql.GetUtilityAccountSchemas();

            if( ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0 )
            {
                DataTable dt = ds.Tables[0];
                string [] utilityCodes = GetDistinctValues(dt, "UtilityCode");

                foreach( string utilityCode in utilityCodes)
                {
                    string select = string.Format("UtilityCode = '{0}'", utilityCode);

                    DataRow[] rows = dt.Select( select );

                    ParserColumnList parserColumnList = new ParserColumnList();

                    foreach( DataRow row in rows )
                    {

                        string fieldName = row["FieldName"].ToString();

                        bool isRequired =  (bool) row["IsRequired"];

                        string context = (string) row["Context"];

                        int createdBy = (int) row["CreatedBy"];

                        DateTime dateCreated = (DateTime) row["DateCreated"];

                        int lastModifiedBy = (int) row["ModifiedBy"];

                        DateTime dateLastModified = (DateTime) row["DateModified"];

                        ParserColumn parserColumn = ParserColumnFactory.GetParserColumn(fieldName, isRequired, context, createdBy, dateCreated, lastModifiedBy, dateLastModified);
                        parserColumnList.Add(parserColumn);

                    }

                    ParserSchema parserSchema = ParserSchemaFactory.CreateParserSchema(utilityCode, parserColumnList );

                    if( schemas == null && parserSchema != null )
                        schemas = new ParserSchemaDictionary();

                    if(schemas!=null && parserSchema !=null)
                        schemas.Add( utilityCode, parserSchema );
                }
            }

            return schemas;
        }

        private static string[] GetDistinctValues( DataTable dt, string columnName )
        {
            if( dt == null || dt.Columns.Contains( columnName ) == false )
                throw new MarketParsingException( "Column not found in DataTable" );

            List <string> fields = new List <string>();
            foreach(DataRow row in dt.Rows)
            {
                if(fields.Contains(row[columnName].ToString()) == false)
                {
                    fields.Add(row[columnName].ToString());
                }
            }
            return fields.ToArray();
        }

        #endregion Methods
    }
}