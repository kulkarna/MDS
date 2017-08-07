using System;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
	public sealed class Helper
	{
		private static string ConnStringName = "LibertyPower";

		static Helper()
		{
			connectionString = SetConnectionString( ConnStringName );
			dcConnectionString = SetConnectionString( DCConnStringName );
			enConnectionString = SetConnectionString( ENConnStringName );
			cmConnectionString = SetConnectionString( CMConnStringName );
			msdbConnectionString = SetConnectionString( MsdbConnStringName );
            try
            {
                lpAccountConnectionString = SetConnectionString(lpAccountConnStringName);
                lpHistoryConnectionString = SetConnectionString(lpHistoryConnStringName);
            }
            catch { }
		}

		private static string SetConnectionString( string connStringName )
		{
			if( ConfigurationManager.ConnectionStrings[connStringName] == null )
			{
				throw new NullReferenceException( string.Format( "Connection string {0} setting is missing in the Configuration file.", connStringName ) );
			}

			return ConfigurationManager.ConnectionStrings[connStringName].ConnectionString;
		}
        private static string lpAccountConnStringName = "Account";

        private static string lpAccountConnectionString = string.Empty;

        public static string LpAccountConnectionString
        {
            get
            {
                return lpAccountConnectionString;
            }
        }
        private static string lpHistoryConnStringName = "History";

        private static string lpHistoryConnectionString = string.Empty;

        public static string LpHistoryConnectionString
        {
            get
            {
                return lpHistoryConnectionString;
            }
        }
		private static string connectionString = string.Empty;

		public static string ConnectionString
		{
			get
			{
				return connectionString;
			}
		}


		private static string DCConnStringName = "DealCapture";

		private static string dcConnectionString = string.Empty;

		public static string DCConnectionString
		{
			get
			{
				return dcConnectionString;
			}
		}


		private static string ENConnStringName = "Enrollment";

		private static string enConnectionString = string.Empty;

		public static string EnrollmentConnectionString
		{
			get
			{
				return enConnectionString;
			}
		}


		private static string CMConnStringName = "Common";

		private static string cmConnectionString = string.Empty;

		public static string CommonConnectionString
		{
			get
			{
				return cmConnectionString;
			}
		}

		private static string ReportsConnStringName = "Reports"; //LP_RPTObjects

		public static string ReportsConnectionString
		{
			get
			{
				if( ConfigurationManager.ConnectionStrings[ReportsConnStringName] == null )
				{
					throw new NullReferenceException( string.Format( "Reports Connection string {0} setting is missing in the Configuration file.", ReportsConnStringName ) );
				}
				else
				{
					return ConfigurationManager.ConnectionStrings[ReportsConnStringName].ConnectionString;
				}
			}
		}

		private static string MsdbConnStringName = "MSDB";

		private static string msdbConnectionString = string.Empty;

		public static string MsdbConnectionString
		{
			get
			{
				return msdbConnectionString;
			}
		}
	}
}
