using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using LibertyPower.DataAccess.SqlAccess.CommonSql;
using LibertyPower.Business.CommonBusiness.CommonHelper;

namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	[Serializable]
	public static class ServiceClassFactory
	{

		/// <summary>
		/// Gets the service class by code.
		/// </summary>
		/// <param name="serviceClassCode">The service class code.</param>
		/// <param name="market">The market.</param>
		/// <param name="utility">The utility.</param>
		/// <returns></returns>
		public static ServiceClass GetServiceClass( string serviceClassCode, string market, string utility )
		{
			ServiceClass serviceClass = null;
			DataSet ds = ServiceClassSql.ServiceClassGetByCode( serviceClassCode, market, utility );
			if( DataSetHelper.HasRow( ds ) )
			{
				serviceClass = LoadServiceClass( ds.Tables[0].Rows[0] );
			}

			return serviceClass;
		}

        /// <summary>
        /// Gets All service classes.
        /// </summary>
        /// <returns>
        /// Returns a service class list for All service classes.
        /// </returns>
        public static ServiceClassList GetServiceClasses(string lastDateCreated = null)
        {
            ServiceClassList list = new ServiceClassList();

            DataSet ds = LibertyPower.DataAccess.SqlAccess.CommonSql.ServiceClassSql.GetServiceClasses(lastDateCreated);
            if (DataSetHelper.HasRow(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                    list.Add(LoadServiceClass(dr));
            }

            return list;
        }

		public static Dictionary<int, ServiceClass> GetServiceClassesDictionary()
		{
			Dictionary<int, ServiceClass> dct = new Dictionary<int, ServiceClass>();
			ServiceClass scOut;

			DataSet ds = LibertyPower.DataAccess.SqlAccess.CommonSql.ServiceClassSql.GetServiceClasses();
			if( DataSetHelper.HasRow( ds ) )
			{
				foreach( DataRow dr in ds.Tables[0].Rows )
				{
					ServiceClass sc = LoadServiceClass( dr );
					if( !dct.TryGetValue( sc.Identity, out scOut ) )
						dct.Add( sc.Identity, sc ); 
				}
			}
			dct.Add( -1, GetServiceClassAllOthers() );

			return dct;
		}

		/// <summary>
		/// Gets service classes for specified utility identity.
		/// </summary>
		/// <param name="utilityIdentity">Utility record identifier</param>
		/// <returns>Returns a service class list for specified utility identity.</returns>
		public static ServiceClassList GetServiceClassesByUtilityIdentity( int utilityIdentity )
		{
			ServiceClassList list = new ServiceClassList();

			list.Add( GetServiceClassAllOthers() );

			DataSet ds = LibertyPower.DataAccess.SqlAccess.CommonSql.ServiceClassSql.GetServiceClassesByUtilityIdentity( utilityIdentity );
			if( DataSetHelper.HasRow( ds ) )
			{
				foreach( DataRow dr in ds.Tables[0].Rows )
					list.Add( LoadServiceClass( dr ) );
			}
			//else if( utilityIdentity > 0 )
			//    throw new ServiceClassNotFoundException( "No service class found for utility." );

			return list;
		}

		/// <summary>
		/// Gets service class object for all others
		/// </summary>
		/// <returns>Returns a service class object for all others.</returns>
		public static ServiceClass GetServiceClassAllOthers()
		{
			ServiceClass sc = new ServiceClass();
			sc.Identity = -1;
			sc.Code = "All Others";

			return sc;
		}

		/// <summary>
		/// Gets the service class by ID.
		/// </summary>
		/// <param name="serviceClassID">The service class ID.</param>
		/// <returns></returns>
		public static ServiceClass GetServiceClass( int serviceClassID )
		{
			ServiceClass serviceClass = null;
			DataSet ds = ServiceClassSql.ServiceClassGetById( serviceClassID );
			if( DataSetHelper.HasRow( ds ) )
			{
				serviceClass = LoadServiceClass( ds.Tables[0].Rows[0] );
			}

			return serviceClass;
		}

		/// <summary>
		/// Loads the service class.
		/// </summary>
		/// <param name="dataRow">The data row.</param>
		/// <returns></returns>
		private static ServiceClass LoadServiceClass( DataRow dataRow )
		{
			ServiceClass s = new ServiceClass();
			s.Identity = Convert.ToInt32( dataRow["service_rate_class_id"] );
			s.Code = Convert.ToString( dataRow["service_rate_class"] );
			s.MarketCode = (dataRow["retail_mkt_id"] == DBNull.Value) ? null : Convert.ToString( dataRow["retail_mkt_id"] );
			s.UtilityCode = (dataRow["utility_id"] == DBNull.Value) ? null : Convert.ToString( dataRow["utility_id"] );
			s.RateCodeFileMapping = (dataRow["ratecode_file_mapping"] == DBNull.Value) ? null : Convert.ToString( dataRow["ratecode_file_mapping"] );
			s.IstaMapping = (dataRow["ista_mapping"] == DBNull.Value) ? null : Convert.ToString( dataRow["ista_mapping"] );
			s.DateCreated = (dataRow["date_created"] == DBNull.Value) ? s.DateCreated : Convert.ToDateTime( dataRow["date_created"] );

			return s;
		}

		/// <summary>
		/// Creates a service class object from data row.
		/// </summary>
		/// <param name="dataRow">Data row</param>
		/// <returns>Returns a service class object from data row.</returns>
		public static ServiceClass CreateServiceClass( DataRow dr )
		{
			ServiceClass s = new ServiceClass();
			s.Identity = Convert.ToInt32( dr["ServiceClassID"] );
			s.Code = dr["ServiceClass"].ToString();
			s.UtilityCode = dr["UtilityCode"].ToString();
			s.DisplayName = String.Format( "{0} - {1}", s.UtilityCode, s.Code );
			return s;
		}

		public static ServiceClassList GetServiceClassList( string utilityCode )
		{
			ServiceClassList serviceClasses = new ServiceClassList();
			ServiceClass sc = new ServiceClass();
			sc.Identity = 0;
			sc.Code = "All Service Classes";
			serviceClasses.Add( sc );

			DataSet ds = ServiceClassSql.GetServiceClassesByUtility( utilityCode );
			if( DataSetHelper.HasRow( ds ) )
			{
				foreach( DataRow dr in ds.Tables[0].Rows )
					serviceClasses.Add( LoadServiceClass( dr ) );
			}
			return serviceClasses;
		}
	}
}
