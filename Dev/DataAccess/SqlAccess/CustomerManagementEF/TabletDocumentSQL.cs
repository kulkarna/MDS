using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;

namespace LibertyPower.DataAccess.SqlAccess.CustomerManagementEF
{
    public static class TabletDocumentSQL
    {
        /// <summary>
        /// Inserts a TabletDocument contract into TabletContractSubmission table
        /// </summary>
        /// <param name="ContractNumber"></param>
        /// <param name="FileName"></param>
        /// <param name="DocumentTypeID"></param>
        /// <param name="SalesAgentID"></param>
        /// <returns></returns>
        public static bool InsertTabletDocument(string ContractNumber, string FileName, int? DocumentTypeID, int? SalesAgentID, bool isGasFile)
        {
            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_TabletDocumentSubmissionInsert";

                    cmd.Parameters.Add(new SqlParameter("@ContractNumber", ContractNumber));
                    cmd.Parameters.Add(new SqlParameter("@FileName", FileName));
                    cmd.Parameters.Add(new SqlParameter("@DocumentTypeID", DocumentTypeID));
                    cmd.Parameters.Add(new SqlParameter("@SalesAgentID", SalesAgentID));
                    cmd.Parameters.Add(new SqlParameter("@IsGasFile", isGasFile));
                    cn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            return true;
        }

        /// <summary>
        /// Updates a TabletContractSubmission record
        /// </summary>
        /// <param name="TabletDocumentSubmissionID"></param>
        /// <param name="ContractNumber"></param>
        /// <param name="FileName"></param>
        /// <param name="DocumentTypeID"></param>
        /// <param name="SalesAgentID"></param>
        /// <returns></returns>
        public static bool UpdateTabletDocument(int TabletDocumentSubmissionID, string ContractNumber, string FileName, int? DocumentTypeID, int? SalesAgentID, bool isGasFile)
        {
            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_TabletDocumentSubmissionUpdate";

                    cmd.Parameters.Add(new SqlParameter("@TabletDocumentSubmissionID", TabletDocumentSubmissionID));
                    cmd.Parameters.Add(new SqlParameter("@ContractNumber", ContractNumber));
                    cmd.Parameters.Add(new SqlParameter("@FileName", FileName));
                    cmd.Parameters.Add(new SqlParameter("@DocumentTypeID", DocumentTypeID));
                    cmd.Parameters.Add(new SqlParameter("@SalesAgentID", SalesAgentID));
                    cmd.Parameters.Add(new SqlParameter("@IsGasFile", isGasFile));
                    cn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            return true;
        }

        /// <summary>
        /// Gets all the TabletDocumentSubmission records for a contract number
        /// </summary>
        /// <param name="ContractNumber"></param>
        /// <returns></returns>
        public static DataSet GetTabletDocumentsByContractNumber(string ContractNumber)
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_TabletDocumentSubmissionSelect";

                    cmd.Parameters.Add(new SqlParameter("@ContractNumber", ContractNumber));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
                }
            }
            return ds;
        }

        /// <summary>
        /// Verifies if all the documents sent from the tablet were received on Liberty Power side
        /// </summary>
        /// <param name="ContractNumber"></param>
        /// <returns></returns>
        public static bool HaveAllTabletDocumentsBeenSubmitted(string ContractNumber)
        {
            bool hasMissingDocuments = false;
            using (SqlConnection cn = new SqlConnection(ConnectionStringHelper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_ValidateTabletSubmissionDocuments";

                    cmd.Parameters.Add(new SqlParameter("@ContractNumber", ContractNumber));

                    SqlParameter missingDocuments = new SqlParameter("@MissingDocuments", SqlDbType.Bit);
                    missingDocuments.Direction = ParameterDirection.Output;

                    cmd.Parameters.Add(missingDocuments);

                    cn.Open();
                    cmd.ExecuteNonQuery();

                    hasMissingDocuments = Convert.ToBoolean(missingDocuments.Value);
                }
            }

            return !hasMissingDocuments;
        }
    }
}
