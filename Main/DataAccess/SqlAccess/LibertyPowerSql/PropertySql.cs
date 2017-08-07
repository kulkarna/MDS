using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Data.SqlClient;
using System.Web;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    public static class PropertySql
    {
        private static bool IsValidId(int? id)
        {
            if (id != null)
                if (id != 0)
                    return true;

            return false;
        }

        /// <summary>
        /// Getting all the registered property
        /// </summary>
        /// <returns></returns>
        public static DataTable GetProperty(int? id = null)
        {
            DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PropertySelect";

                    if (IsValidId(id))
                        cmd.Parameters.Add(new SqlParameter("id", id));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }

            if (ds.Tables.Count > 0)
                return ds.Tables[0];
            else
                return null;
        }

        /// <summary>
        /// Get the list of external entities by type
        /// </summary>
        /// <param name="externalEntityId"></param>
        /// <returns></returns>
        public static DataTable GetExternalEntityById(int externalEntityId)
        {
            DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_ExternalEntityByIdSelect";

                    cmd.Parameters.Add(new SqlParameter("ID", externalEntityId));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }

            if (ds.Tables.Count > 0)
                return ds.Tables[0];
            else
                return null;
        }

        /// <summary>
        /// Get the list of external entities by type
        /// </summary>
        /// <param name="entityTypeId"></param>
        /// <param name="entityKey"></param>
        /// <param name="includeInactive"></param>
        /// <returns></returns>
        public static DataTable GetExternalEntityByEntityKey(int? entityTypeId, int? entityKey = null, bool includeInactive = false)
        {
            DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_ExternalEntityByEntitySelect";

                    if (IsValidId(entityKey))
                        cmd.Parameters.Add(new SqlParameter("entityKey", entityKey));

                    if (IsValidId(entityTypeId))
                        cmd.Parameters.Add(new SqlParameter("entityTypeId", entityTypeId));

                    cmd.Parameters.Add(new SqlParameter("includeInactive", includeInactive));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }

            if (ds.Tables.Count > 0)
                return ds.Tables[0];
            else
                return null;
        }

        /// <summary>
        /// List the property types by property id
        /// </summary>
        /// <param name="Id">id of the property</param>
        /// <returns></returns>
        public static DataTable GetPropertyType(int? Id = null, bool includeInactive = false)
        {
            DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PropertyTypeSelect";

                    if (IsValidId(Id))
                        cmd.Parameters.Add(new SqlParameter("Id", Id));

                    cmd.Parameters.Add(new SqlParameter("includeInactive", includeInactive));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }

            if (ds.Tables.Count > 0)
                return ds.Tables[0];
            else
                return null;
        }

        /// <summary>
        /// List the property types by property id
        /// </summary>
        /// <param name="propertyId">id of the property</param>
        /// <returns></returns>
        public static DataTable GetPropertyTypeByProperty(int propertyId, bool includeInactive = false)
        {
            DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PropertyTypeSelect";

                    cmd.Parameters.Add(new SqlParameter("propertyId", propertyId));
                    cmd.Parameters.Add(new SqlParameter("includeInactive", includeInactive));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }

            if (ds.Tables.Count > 0)
                return ds.Tables[0];
            else
                return null;
        }

        /// <summary>
        /// List the property types by property id
        /// </summary>
        /// <param name="externalEntityId"></param>
        /// /// <param name="propertyID"></param>
        /// <returns></returns>
        public static DataTable GetPropertyRuleByEntity(int? externalEntityId = null, int? propertyID = null, bool includeInactive = false)
        {
            DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PropertyRuleByEntitySelect";

                    if (IsValidId(externalEntityId))
                        cmd.Parameters.Add(new SqlParameter("externalEntityId", externalEntityId));

                    if (IsValidId(propertyID))
                        cmd.Parameters.Add(new SqlParameter("propertyID", propertyID));

                    cmd.Parameters.Add(new SqlParameter("includeInactive", includeInactive));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }

            if (ds.Tables.Count > 0)
                return ds.Tables[0];
            else
                return null;
        }

        /// <summary>
        /// List all internal values mapped for that combination of Property and PropertyType
        /// </summary>
        /// <param name="propertyId">id of the property</param>
        /// <param name="propertyTypeId">id of the property type (null accepted)</param>
        /// <param name="includeInactive"></param>
        /// <returns></returns>
        public static DataTable GetPropertyInternalRefByProperty(int? propertyId, int? propertyTypeId, bool includeInactive = false)
        {
            DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PropertyInternalRefByPropSelect";

                    if (IsValidId(propertyId))
                        cmd.Parameters.Add(new SqlParameter("propertyId", propertyId));

                    if (IsValidId(propertyTypeId))
                        cmd.Parameters.Add(new SqlParameter("propertyTypeId", propertyTypeId));

                    cmd.Parameters.Add(new SqlParameter("includeInactive", includeInactive));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }

            if (ds.Tables.Count > 0)
                return ds.Tables[0];
            else
                return null;
        }

        /// <summary>
        /// Get Internal value
        /// </summary>
        /// <param name="Id"></param>
        /// <returns></returns>
        public static DataTable GetPropertyInternalRef(int Id)
        {
            DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PropertyInternalRefByIDSelect";

                    cmd.Parameters.Add(new SqlParameter("Id", Id));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }

            if (ds.Tables.Count > 0)
                return ds.Tables[0];
            else
                return null;
        }

	    /// <summary>
	    /// Get Internal value for a give type/value
	    /// </summary>
	    /// <param name="propertyTypeId">Profile or location</param>
	    /// <param name="propertyValue">Value of profile or location</param>
	    /// <returns></returns>
	    public static DataTable GetPropertyInternalRef( int propertyTypeId, string propertyValue )
		{
			var ds = new DataSet();

			using( var conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( var cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_PropertyInternalRefByValueSelect";

					cmd.Parameters.Add( new SqlParameter( "propertyId", propertyTypeId ) );
					cmd.Parameters.Add( new SqlParameter( "propValue", propertyValue ) );

					using( var da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds.Tables.Count > 0 ? ds.Tables[0] : null;
		}

        /// <summary>
        /// Get all mapped values of to the combination Internal Value, PropertyId and PropertyTypeId
        /// </summary>
        /// <param name="externalEntityId">internal value id</param>
        /// <param name="propertyId">property id</param>
        /// <param name="propertyTypeId">property type id</param>
        /// <param name="includeInactive"></param>
        /// <returns></returns>
        public static DataTable GetPropertyValuesByExternalEnt(int externalEntityId, int? propertyId = null, int? propertyTypeId = null, bool includeInactive = false)
        {
            DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PropertyValueByExtEntSelect";

                    cmd.Parameters.Add(new SqlParameter("externalEntityId", externalEntityId));

                    if (IsValidId(propertyId))
                        cmd.Parameters.Add(new SqlParameter("propertyId", propertyId));

                    if (IsValidId(propertyTypeId))
                        cmd.Parameters.Add(new SqlParameter("propertyTypeId", propertyTypeId));

                    cmd.Parameters.Add(new SqlParameter("includeInactive", includeInactive));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }

            if (ds.Tables.Count > 0)
                return ds.Tables[0];
            else
                return null;
        }

        public static DataTable GetPropertyValuesByExternalEnt( int targetEntityId, int? propertyId = null, int? propertyTypeId = null,int? sourceEntityId = null, bool includeInactive = false)
        {
            DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PropertyValueByExtEntSelect";

                    cmd.Parameters.Add(new SqlParameter("externalEntityId", targetEntityId));

                    if (IsValidId(propertyId))
                        cmd.Parameters.Add(new SqlParameter("propertyId", propertyId));

                    if (IsValidId(propertyTypeId))
                        cmd.Parameters.Add(new SqlParameter("propertyTypeId", propertyTypeId));

                    cmd.Parameters.Add(new SqlParameter("includeInactive", includeInactive));

                    if (IsValidId(sourceEntityId))
                        cmd.Parameters.Add(new SqlParameter("sourceExtEntityId", sourceEntityId));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }

            if (ds.Tables.Count > 0)
                return ds.Tables[0];
            else
                return null;
        }

        /// <summary>
        /// Insert a new internal value
        /// </summary>
        /// <param name="value">text value</param>
        /// <param name="propertyId">id of related property</param>
        /// <param name="propertyTypeId">id of related property type</param>
        /// <param name="inactive"></param>
        /// <param name="user"></param>
        /// <returns></returns>
        public static int SavePropertyInternalRef(int? id, string value, int propertyId, int? propertyTypeId, bool inactive, int user)
        {
            int newId = 0;

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("value", value));
                    cmd.Parameters.Add(new SqlParameter("propertyId", propertyId));

                    if (IsValidId(propertyTypeId))
                        cmd.Parameters.Add(new SqlParameter("propertyTypeId", propertyTypeId));

                    cmd.Parameters.Add(new SqlParameter("inactive", inactive));
                    cmd.Parameters.Add(new SqlParameter("createdBy", user));

                    if (!IsValidId(id))
                    {
                        cmd.CommandText = "usp_PropertyInternalRefInsert";
                        cmd.Connection.Open();
                        newId = Convert.ToInt32(cmd.ExecuteScalar());
                    }
                    else
                    {
                        cmd.Parameters.Add(new SqlParameter("id", id));
                        cmd.CommandText = "usp_PropertyInternalRefUpdate";
                        cmd.Connection.Open();
                        cmd.ExecuteNonQuery();
                    }

                    if (cmd.Connection.State == ConnectionState.Open)
                        cmd.Connection.Close();
                }
            }

            return newId;
        }

        /// <summary>
        /// Insert a new External Entity
        /// </summary>
        /// <param name="entityKey">Foreign Key that represents the PriamryKey of the entity</param>
        /// <param name="entityType">External Entity Type</param>
        /// <param name="showAs">value from enumeration EShowAs</param>
        /// <param name="inactive"></param>
        /// <param name="user"></param>
        /// <returns></returns>
        public static int SaveExternalEntity(int? id, int entityKey, int entityType, int showAs, bool inactive, int user)
        {
            int newId = 0;

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("entityKey", entityKey));
                    cmd.Parameters.Add(new SqlParameter("entityType", entityType));
                    cmd.Parameters.Add(new SqlParameter("showAs", showAs));
                    cmd.Parameters.Add(new SqlParameter("inactive", inactive));

                    if (!IsValidId(id))
                    {
                        cmd.CommandText = "usp_ExternalEntityInsert";
                        cmd.Parameters.Add(new SqlParameter("createdBy", user));
                        cmd.Connection.Open();
                        newId = Convert.ToInt32(cmd.ExecuteScalar());
                    }
                    else
                    {
                        cmd.CommandText = "usp_ExternalEntityUpdate";
                        cmd.Parameters.Add(new SqlParameter("id", id));
                        cmd.Parameters.Add(new SqlParameter("modifiedBy", user));
                        cmd.Connection.Open();
                        cmd.ExecuteNonQuery();
                        newId = (int)id;
                    }

                    if (cmd.Connection.State == ConnectionState.Open)
                        cmd.Connection.Close();
                }
            }
            return newId;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="id"></param>
        /// <param name="value"></param>
        /// <param name="internalRefId"></param>
        /// <param name="propertyId"></param>
        /// <param name="propertyTypeId"></param>
        /// <param name="inactive"></param>
        /// <param name="user"></param>
        /// <returns></returns>
        public static int SavePropertyValue(int? id, string value, int internalRefId, int propertyId, int propertyTypeId, bool inactive, int user)
        {
            int newId = 0;

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;


                    cmd.Parameters.Add(new SqlParameter("value", value));
                    cmd.Parameters.Add(new SqlParameter("internalRefId", internalRefId));
                    cmd.Parameters.Add(new SqlParameter("inactive", inactive));
                    cmd.Parameters.Add(new SqlParameter("propertyId", propertyId));
                    cmd.Parameters.Add(new SqlParameter("propertyTypeId", propertyTypeId));

                    if (!IsValidId(id))
                    {
                        cmd.Parameters.Add(new SqlParameter("createdBy", user));

                        cmd.CommandText = "usp_PropertyValueInsert";
                        cmd.Connection.Open();
                        newId = Convert.ToInt32(cmd.ExecuteScalar());
                    }
                    else
                    {
                        cmd.Parameters.Add(new SqlParameter("id", id));
                        cmd.Parameters.Add(new SqlParameter("modifiedBy", user));

                        cmd.CommandText = "usp_PropertyValueUpdate";
                        cmd.Connection.Open();
                        cmd.ExecuteNonQuery();
                        newId = (int)id;
                    }

                    if (cmd.Connection.State == ConnectionState.Open)
                        cmd.Connection.Close();
                }
            }

            return newId;
        }

        public static void RemovePropertyValueMapping(int extEntityId, int propertyValue)
        {
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PropertyValueMappingRemove";

                    cmd.Parameters.Add(new SqlParameter("extEntityId", extEntityId));
                    cmd.Parameters.Add(new SqlParameter("propertyValueId", propertyValue));

                    cmd.Connection.Open();
                    cmd.ExecuteNonQuery();

                    if (cmd.Connection.State == ConnectionState.Open)
                        cmd.Connection.Close();
                }
            }
        }

        public static void InsertPropertyValueMapping(int extEntityId, int propertyValue, int propInternalRef, int createdBy)
        {
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PropertyValueMappingInsert";

                    cmd.Parameters.Add(new SqlParameter("extEntityId", extEntityId));
                    cmd.Parameters.Add(new SqlParameter("propertyValueId", propertyValue));
                    cmd.Parameters.Add(new SqlParameter("propInternalRef", propInternalRef));
                    cmd.Parameters.Add(new SqlParameter("createdBy", createdBy));

                    cmd.Connection.Open();
                    cmd.ExecuteNonQuery();

                    if (cmd.Connection.State == ConnectionState.Open)
                        cmd.Connection.Close();
                }
            }
        }

        public static DataSet GetPropertyValue(int? Id)
        {
            DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PropertyValueSelect";

                    if (IsValidId(Id))
                        cmd.Parameters.Add(new SqlParameter("Id", Id));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }

            return ds;
        }

        public static DataSet GetPropertyValueByIntRef(int internalRefId, int? targetEntity = null, int? propertyId = null, int? propertyTypeid = null, bool includeInactive = false)
        {
            DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PropertyValueByIntRefSelect";

                    cmd.Parameters.Add(new SqlParameter("internalRefId", internalRefId));

                    if (IsValidId(targetEntity))
                        cmd.Parameters.Add(new SqlParameter("extEntityId", targetEntity));

                    if (IsValidId(propertyId))
                        cmd.Parameters.Add(new SqlParameter("propertyId", propertyId));

                    if (IsValidId(propertyTypeid))
                        cmd.Parameters.Add(new SqlParameter("propertyTypeid", propertyTypeid));

                    cmd.Parameters.Add(new SqlParameter("includeInactive", includeInactive));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }

            return ds;
        }


        public static DataSet GetPropertyValueByIntRef(int propertyId, string internalValue, int? targetEntity, bool includeInactive = false)
        {
            DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PropertyValueByIntValSelect";

                    cmd.Parameters.Add(new SqlParameter("propertyId", propertyId));
                    cmd.Parameters.Add(new SqlParameter("internalValue", internalValue));

                    if (IsValidId(targetEntity))
                        cmd.Parameters.Add(new SqlParameter("extEntityId", targetEntity));
                    cmd.Parameters.Add(new SqlParameter("includeInactive", includeInactive));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }

            return ds;
        }

        public static DataSet GetPropertyValueByValue(string sourceValue, int? propertyId = null, int? propertyTypeId = null, int? sourceEntity = null, int? targetEntity = null, bool includeInactive = false)
        {
            DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PropertyValueByValueSelect";

                    cmd.Parameters.Add(new SqlParameter("srcValue", sourceValue));

                    if (IsValidId(propertyId))
                        cmd.Parameters.Add(new SqlParameter("propertyId", propertyId));

                    if (IsValidId(propertyTypeId))
                        cmd.Parameters.Add(new SqlParameter("propertyTypeId", propertyTypeId));

                    if (IsValidId(sourceEntity))
                        cmd.Parameters.Add(new SqlParameter("srcEntityId", sourceEntity));

                    if (IsValidId(targetEntity))
                        cmd.Parameters.Add(new SqlParameter("trgtEntityId", targetEntity));
                    cmd.Parameters.Add(new SqlParameter("includeInactive", includeInactive));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }

            return ds;
        }

        public static DataSet GetPropertyValueUnMapped(int? propertyId, int? propertyTypeId)
        {
            DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PropertyValueUnMappedSelect";

                    if (IsValidId(propertyId))
                        cmd.Parameters.Add(new SqlParameter("propertyId", propertyId));

                    if (IsValidId(propertyTypeId))
                        cmd.Parameters.Add(new SqlParameter("propertyTypeId", propertyTypeId));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }

            return ds;
        }

        //public static DataSet GetPropertyInternalValueBySource(int propertyId, int sourceEntity, string sourceValue)
        //{
        //    DataSet ds = new DataSet();

        //    using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
        //    {
        //        using (SqlCommand cmd = new SqlCommand())
        //        {
        //            cmd.Connection = conn;
        //            cmd.CommandType = CommandType.StoredProcedure;
        //            cmd.CommandText = "usp_PropertyInternalRefSelectBySrcVal";

        //            cmd.Parameters.Add(new SqlParameter("propertyId", propertyId));
        //            cmd.Parameters.Add(new SqlParameter("srcEntityId", sourceEntity));
        //            cmd.Parameters.Add(new SqlParameter("srcValue", sourceValue));

        //            using (SqlDataAdapter da = new SqlDataAdapter(cmd))
        //            {
        //                da.Fill(ds);
        //            }
        //        }
        //    }

        //    return ds;
        //}

        //public static DataSet GetPropertyInternalValueByValue(int propertyId, string propertyValue)
        //{
        //    DataSet ds = new DataSet();

        //    using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
        //    {
        //        using (SqlCommand cmd = new SqlCommand())
        //        {
        //            cmd.Connection = conn;
        //            cmd.CommandType = CommandType.StoredProcedure;
        //            cmd.CommandText = "usp_PropertyInternalRefSelectByValue";

        //            cmd.Parameters.Add(new SqlParameter("propertyId", propertyId));
        //            cmd.Parameters.Add(new SqlParameter("propValue", propertyValue));

        //            using (SqlDataAdapter da = new SqlDataAdapter(cmd))
        //            {
        //                da.Fill(ds);
        //            }
        //        }
        //    }

        //    return ds;
        //}
        public static DataSet GetPropertyInternalRefByExtValue(int sourceExtEntityId, string extValue, int propertyId, bool includeInactive = false)
        {
            DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PropertyInternalRefByExtValueSelect";

                    cmd.Parameters.Add(new SqlParameter("PropertyID", propertyId));
                    cmd.Parameters.Add(new SqlParameter("ExternalEntityID", sourceExtEntityId));
                    cmd.Parameters.Add(new SqlParameter("ExternalValue", extValue));
                    cmd.Parameters.Add(new SqlParameter("includeInactive", includeInactive));
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }


        public static DataSet GetPropertyInternalRefByExtEntity(int extEntityId, int? propertyId = null, int? propertyTypeId = null, bool includeInactive = false)
        {
            DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PropertyInternalRefByExtEntSelect";

                    cmd.Parameters.Add(new SqlParameter("externalEntityId", extEntityId));

                    if (IsValidId(propertyId))
                        cmd.Parameters.Add(new SqlParameter("propertyId", propertyId));

                    if (IsValidId(propertyTypeId))
                        cmd.Parameters.Add(new SqlParameter("propertyTypeId", propertyTypeId));

                    cmd.Parameters.Add(new SqlParameter("includeInactive", includeInactive));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }

        public static DataSet GetPropertyInternalRefByEntityKey(int entityTypeId, int entityKey, int? propertyId = null, int? propertyTypeId = null, bool includeInactive = false)
        {
            DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PropertyInternalRefByEntKeySelect";

                    cmd.Parameters.Add(new SqlParameter("entityKey", entityKey));
                    cmd.Parameters.Add(new SqlParameter("entityTypeId", entityTypeId));

                    if (IsValidId(propertyId))
                        cmd.Parameters.Add(new SqlParameter("propertyId", propertyId));

                    if (IsValidId(propertyTypeId))
                        cmd.Parameters.Add(new SqlParameter("propertyTypeId", propertyTypeId));

                    cmd.Parameters.Add(new SqlParameter("includeInactive", includeInactive));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }

        public static void InactivateProperty(int id, bool inactiveInd, int modifiedBy)
        {
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PropertyInactiveUpdate";

                    cmd.Parameters.Add(new SqlParameter("id", id));
                    cmd.Parameters.Add(new SqlParameter("inactive", inactiveInd));
                    cmd.Parameters.Add(new SqlParameter("modifiedBy", modifiedBy));

                    cmd.Connection.Open();
                    cmd.ExecuteNonQuery();

                    if (cmd.Connection.State == ConnectionState.Open)
                        cmd.Connection.Close();
                }
            }
        }

        public static void InactivateExternalEntity(int id, bool inactiveInd, int modifiedBy)
        {
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_ExternalEntityInactiveUpdate";

                    cmd.Parameters.Add(new SqlParameter("id", id));
                    cmd.Parameters.Add(new SqlParameter("inactive", inactiveInd));
                    cmd.Parameters.Add(new SqlParameter("modifiedBy", modifiedBy));

                    cmd.Connection.Open();
                    cmd.ExecuteNonQuery();

                    if (cmd.Connection.State == ConnectionState.Open)
                        cmd.Connection.Close();
                }
            }
        }


        public static void InactivateExternalEntityValue(int id, bool inactiveInd, int modifiedBy)
        {
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_ExternalEntityValueInactiveUpdate";

                    cmd.Parameters.Add(new SqlParameter("id", id));
                    cmd.Parameters.Add(new SqlParameter("inactive", inactiveInd));
                    cmd.Parameters.Add(new SqlParameter("modifiedBy", modifiedBy));

                    cmd.Connection.Open();
                    cmd.ExecuteNonQuery();

                    if (cmd.Connection.State == ConnectionState.Open)
                        cmd.Connection.Close();
                }
            }
        }

        /// <summary>
        /// Get the list of external entities by type
        /// </summary>
        /// <param name="propertyValueId"></param>
        /// <param name="includeInactive"></param>
        /// <returns></returns>
        public static DataTable GetExternalEntityByPropValue(int propertyValueId, bool includeInactive = false)
        {
            DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_ExternalEntityByPropValueSelect";

                    cmd.Parameters.Add(new SqlParameter("propertyValueId", @propertyValueId));
                    
                    cmd.Parameters.Add(new SqlParameter("includeInactive", includeInactive));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }

            if (ds.Tables.Count > 0)
                return ds.Tables[0];
            else
                return null;
        }

        /// <summary>
        /// Get the list of external entities by type
        /// </summary>
        /// <param name="internalRefID"></param>
        /// <param name="includeInactive"></param>
        /// <returns></returns>
        public static DataTable GetExternalEntityByIntRef(int internalRefID, int? intRefPropertyId, int? intRefPropertyTypeId, bool includeInactive = false)
        {
            DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_ExternalEntityByIntRefSelect";

                    if (IsValidId(internalRefID))
                        cmd.Parameters.Add(new SqlParameter("internalRefId", internalRefID));

                    if (IsValidId(intRefPropertyId))
                        cmd.Parameters.Add(new SqlParameter("intRefPropertyId", intRefPropertyId));

                    if (IsValidId(intRefPropertyTypeId))
                        cmd.Parameters.Add(new SqlParameter("intRefPropertyTypeId", intRefPropertyTypeId));

                    cmd.Parameters.Add(new SqlParameter("includeInactive", includeInactive));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }

            if (ds.Tables.Count > 0)
                return ds.Tables[0];
            else
                return null;
        }

        public static DataTable GetExternalEntityType(int? id)
        {
            DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_ExternalEntityTypeSelect";

                    cmd.Parameters.Add(new SqlParameter("Id", id));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }

            if (ds.Tables.Count > 0)
                return ds.Tables[0];
            else
                return null;
        }

        public static DataTable GetExternalEntityTypeByProperty(int propertyId, bool includeInactive = false)
        {
            DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_ExternalEntityTypeByPropSelect";

                    cmd.Parameters.Add(new SqlParameter("propertyId", propertyId));
                    
                    cmd.Parameters.Add(new SqlParameter("includeInactive", includeInactive));
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }

            if (ds.Tables.Count > 0)
                return ds.Tables[0];
            else
                return null;
        }

        public static DataSet GetExternalEntityMapView(int? extEntityID, int? propValueID, int? propertyId, int? propertyTypeId, bool includeInactive = false)
        {
            DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_ExternalEntityMapViewSelect";

                    //if (IsValidId(extEntityID))
                        cmd.Parameters.Add(new SqlParameter("externalEntityId", extEntityID));

                    //if (IsValidId(propValueID))
                        cmd.Parameters.Add(new SqlParameter("propertyValueId", propValueID));

                    //if (IsValidId(propertyId))
                        cmd.Parameters.Add(new SqlParameter("propertyId", propertyId));

                    //if (IsValidId(propertyTypeId))
                        cmd.Parameters.Add(new SqlParameter("propertyTypeId", @propertyTypeId));

                    cmd.Parameters.Add(new SqlParameter("includeInactive", includeInactive));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }

            return ds;
        }

        public static DataSet GetInternalRefMapView(int? internalRefID, int? intRefPropertyId, int? intRefPropertyTypeId, bool includeInactive = false)
        {
            DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_ExternalEntityMapViewByIRSelect";

                    //if (IsValidId(internalRefID))
                        cmd.Parameters.Add(new SqlParameter("internalRefId", internalRefID));

                    //if (IsValidId(intRefPropertyId))
                        cmd.Parameters.Add(new SqlParameter("intRefPropertyId", intRefPropertyId));

                    //if (IsValidId(intRefPropertyTypeId))
                        cmd.Parameters.Add(new SqlParameter("intRefPropertyTypeId", intRefPropertyTypeId));

                    cmd.Parameters.Add(new SqlParameter("includeInactive", includeInactive));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }

            return ds;
        }

    }



}
