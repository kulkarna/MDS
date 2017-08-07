using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;


namespace LibertyPower.DataAccess.SqlAccess.CustomerManagementEF
{

	/// <summary>
	/// Retrieves connection string
	/// </summary>
	public sealed class ConnectionStringHelper
	{
				
		private static string LibertyPowerconnStr = ConfigurationManager.ConnectionStrings["LibertyPower"].ConnectionString;
        private static string DocumentsconnStr = ConfigurationManager.ConnectionStrings["Documents"].ConnectionString;


		/// <summary>
		/// Returns connection string
		/// </summary>
		public static string ConnectionString
		{
			get {
				return ConnectionStringHelper.LibertyPowerconnStr; 
			}
		}

        

        /// <summary>
        /// Returns connection string
        /// </summary>
        public static string DocumentsConnectionString
        {
            get
            {
                return ConnectionStringHelper.DocumentsconnStr;
            }
        }



	
	}
}
