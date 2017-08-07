using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;

namespace LibertyPower.DataAccess.WebServiceAccess.IstaWebService.DataAccess
{
    /// <summary>
    /// Executes data access operations related to utilities.
    /// </summary>
    interface IUtilityDAO
    {
        /// <summary>
        /// Returns the name-key pattern of the utility with the supplied id.
        /// </summary>
        /// <param name="utilityId">Id of the utility.</param>
        /// <returns>The name-key pattern of the utility.</returns>
        string GetNameKeyPattern(int utilityId);
    }

    sealed class UtilityDAO : IUtilityDAO
    {
        private readonly ICommandRunner runner;

        public UtilityDAO(ICommandRunner runner = null)
        {
            this.runner = runner ?? new CommandRunner();
        }

        public string GetNameKeyPattern(int utilityId)
        {
            var parameter = new SqlParameter("@UtilityID", utilityId);
            var ds = runner.ExecuteProcedure("usp_UtilityManagementCacheByUtilityIdSelect", parameter);

            if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                return ds.Tables[0].Rows[0]["NameKeyPattern"].ToString();

            return null;
        }
    }
}
