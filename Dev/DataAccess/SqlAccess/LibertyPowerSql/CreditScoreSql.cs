using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    public class CreditScoreSql
    {
        /// <summary>
        /// Method to insert a new Credit Score Criteria Header
        /// </summary>
        /// <param name="creditAgencyID">Id of the Credit Agency</param>
        /// <param name="effectiveDate">Effective Date</param>
        /// <param name="user">User who creates the Credit Score Criteria</param>
        public static void InsertCreditScoreCriteriaHeader(int creditAgencyID, DateTime effectiveDate, string user, ref int id, int criteriaSetId)
        {
            string connStr = Helper.ConnectionString;

            using (SqlConnection connection = new SqlConnection(connStr))
            {
                string SQL = "usp_CreditScoreCriteriaHeaderInsert";
                SqlCommand insertCommand = new SqlCommand(SQL, connection);
                insertCommand.CommandType = CommandType.StoredProcedure;
                insertCommand.Parameters.AddWithValue("@CreditAgencyID", creditAgencyID);
                insertCommand.Parameters.AddWithValue("@EffectiveDate", effectiveDate);
                insertCommand.Parameters.AddWithValue("@CreatedBy", user);
                //if (criteriaSetId == null)
                //    insertCommand.Parameters.AddWithValue("@CriteriaSetId", DBNull.Value);
                //else
                    insertCommand.Parameters.AddWithValue("@CriteriaSetId", criteriaSetId);

                SqlParameter returnID = new SqlParameter("@return_value", DbType.Int32);
                returnID.Direction = ParameterDirection.ReturnValue;

                insertCommand.Parameters.Add(returnID);
                connection.Open();
                insertCommand.ExecuteNonQuery();
                id = (int)insertCommand.Parameters["@return_value"].Value;
                connection.Close();
            }
        }
        /// <summary>
        /// Inserts a Detail row of a Credit Score Criteria
        /// </summary>
        /// <param name="creditScoreCriteriaHeaderID">Id of the Header</param>
        /// <param name="accontTypeID">Acoount type Id</param>
        /// <param name="lowUsage">low usage value</param>
        /// <param name="highUsage">high usage value</param>
        /// <param name="lowRange">low valid range</param>
        /// <param name="HighRange">high valid range</param>
        public static void InsertCreditScoreCriteriaDetail(int creditScoreCriteriaHeaderID, string accontTypeGroup, int lowUsage, int? highUsage, int lowRange, int? highRange)
        {
            string connStr = Helper.ConnectionString;

            using (SqlConnection connection = new SqlConnection(connStr))
            {
                object infinity = DBNull.Value;

                string SQL = "usp_CreditScoreCriteriaDetailInsert";
                SqlCommand insertCommand = new SqlCommand(SQL, connection);
                insertCommand.CommandType = CommandType.StoredProcedure;
                insertCommand.Parameters.AddWithValue("@CreditScoreCriteriaHeaderID", creditScoreCriteriaHeaderID);
                insertCommand.Parameters.AddWithValue("@AccountTypeGroup", accontTypeGroup);
                insertCommand.Parameters.AddWithValue("@LowUsage", lowUsage);
                insertCommand.Parameters.AddWithValue("@HighUsage", highUsage.HasValue ? highUsage: infinity);
                insertCommand.Parameters.AddWithValue("@LowRange", lowRange);
                insertCommand.Parameters.AddWithValue("@HighRange", highRange);
                                
                connection.Open();
                insertCommand.ExecuteNonQuery();
                connection.Close();
            }
        }

        /// <summary>
        /// Gets the CreditScoreCriteria by CredidAgency
        /// </summary>
        /// <param name="creditAgencyID">Id of a credit agency</param>
        /// <param name="status">0=gets only the non expired records, 1=Gets the latest record, >1=Gets all</param>
        /// <returns>Dataset containing </returns>
        public static DataSet GetCreditScoreCriteriaByCreditAgencyAndCriteriaSet(int creditAgencyID, int status, int? criteriaSetId)
        {
            string connStr = Helper.ConnectionString;
            DataSet ds = new DataSet();

            using (SqlConnection connection = new SqlConnection(connStr))
            {
                string SQL = "usp_CreditScoreCriteriaHeaderSelectList";
                using (SqlDataAdapter da = new SqlDataAdapter(SQL, connStr))
                {
                    da.SelectCommand.CommandType = CommandType.StoredProcedure;
                    da.SelectCommand.Parameters.AddWithValue("@p_CreditAgencyID", creditAgencyID);
                    da.SelectCommand.Parameters.AddWithValue("@p_status", status);
                    if(criteriaSetId == null)
                        da.SelectCommand.Parameters.AddWithValue("@p_CriteriaSetId", DBNull.Value); 
                    else
                        da.SelectCommand.Parameters.AddWithValue("@p_CriteriaSetId", criteriaSetId); 

                    da.Fill(ds);
                }
            }
            return ds;

        }

        /// <summary>
        /// Gets all Credit Score Criteria Headers
        /// </summary>
        /// <returns>DataSet</returns>
        public static DataSet GetCreditScoreCriteriaList(int criteriaSetId)
        {
            string connStr = Helper.ConnectionString;
            DataSet ds = new DataSet();

            using (SqlConnection connection = new SqlConnection(connStr))
            {
                string SQL = "usp_CreditScoreCriteriaHeaderSelectList";
                using (SqlDataAdapter da = new SqlDataAdapter(SQL, connStr))
                {
                    da.SelectCommand.CommandType = CommandType.StoredProcedure;
                    da.SelectCommand.Parameters.AddWithValue("@p_status", 2);
                    da.SelectCommand.Parameters.AddWithValue("@p_CriteriaSetId", criteriaSetId);

                    da.Fill(ds);
                }
            }
            return ds;
        }

        /// <summary>
        /// Gets the Credit Score Criteria Header
        /// </summary>
        /// <param name="creditScoreCriteriaId">CreditScoreCriteriaHeader Id</param>
        /// <returns>DataSet</returns>
        public static DataSet GetCreditScoreCriteriaHeader(int creditScoreCriteriaId)
        {
            string connStr = Helper.ConnectionString;
            DataSet ds = new DataSet();

            using (SqlConnection connection = new SqlConnection(connStr))
            {
                string SQL = "usp_CreditScoreCriteriaHeaderSelect";
                using (SqlDataAdapter da = new SqlDataAdapter(SQL, connStr))
                {
                    da.SelectCommand.CommandType = CommandType.StoredProcedure;
                    da.SelectCommand.Parameters.AddWithValue("@p_CreditScoreCriteriaHeaderID", creditScoreCriteriaId);

                    da.Fill(ds);
                }
            }
            return ds;
        }

        /// <summary>
        /// Gets the Details of a Credit Score Criteria by the ID of the Header
        /// </summary>
        /// <param name="creditScoreCriteriaID">Id of the CreditScoreCriteriaHeader table</param>
        /// <returns>DataSet</returns>
        public static DataSet GetCreditScoreCriteriaDetailsById(int creditScoreCriteriaID)
        {
            string connStr = Helper.ConnectionString;
            DataSet ds = new DataSet();

            using (SqlConnection connection = new SqlConnection(connStr))
            {
                string SQL = "usp_CreditScoreCriteriaDetailsSelect";
                using (SqlDataAdapter da = new SqlDataAdapter(SQL, connStr))
                {
                    da.SelectCommand.CommandType = CommandType.StoredProcedure;
                    da.SelectCommand.Parameters.AddWithValue("@p_CreditScoreCriteriaHeaderID", creditScoreCriteriaID);
                    da.Fill(ds);
                }
            }
            return ds;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="CreditScoreCriteriaHeaderId"></param>
        /// <param name="expirationDate"></param>
        /// <param name="user"></param>
        public static void UpdateCreditScoreCriteria(int CreditScoreCriteriaHeaderId, DateTime expirationDate, string user)
        {
            string connStr = Helper.ConnectionString;

            using (SqlConnection connection = new SqlConnection(connStr))
            {
                string SQL = "usp_CreditScoreCriteriaHeaderUpdate";
                SqlCommand updateCommand = new SqlCommand(SQL, connection);
                updateCommand.CommandType = CommandType.StoredProcedure;
                updateCommand.Parameters.AddWithValue("@CreditScoreCriteriaHeaderID", CreditScoreCriteriaHeaderId);
                updateCommand.Parameters.AddWithValue("@ExpirationDate", expirationDate);
                updateCommand.Parameters.AddWithValue("@ModifiedBy", user);
                connection.Open();
                updateCommand.ExecuteNonQuery();
                connection.Close();
            }
        }
		/// <summary>
		/// Inserts a record in the CreditScoreHistoryTable
		/// </summary>
		/// <param name="CustomerName"></param>
		/// <param name="StreetAddress"></param>
		/// <param name="City"></param>
		/// <param name="State"></param>
		/// <param name="ZipCode"></param>
		/// <param name="DateAcquired"></param>
		/// <param name="AgencyReferenceID"></param>
		/// <param name="CreditAgencyID"></param>
		/// <param name="Score"></param>
		/// <param name="ScoreType"></param>
		/// <param name="FullXMLReport"></param>
		/// <param name="Source"></param>
		/// <param name="CustomerID"></param>
		/// <param name="Contract_nbr"></param>
		/// <param name="Account_nbr"></param>
		/// <param name="Username"></param>
		/// <param name="DateCreated"></param>
		public static void InsertCreditScoreHistory(string CustomerName, string StreetAddress, string City, string State, string ZipCode,
													DateTime DateAcquired, int AgencyReferenceID, int CreditAgencyID, decimal? Score, string ScoreType,
													string FullXMLReport, string Source, int CustomerID, string Contract_nbr, string Account_nbr,
													string Username, DateTime DateCreated)
		{
			string connStr = Helper.ConnectionString;
			object pCustomerName = DBNull.Value;
			object pStreetAddress = DBNull.Value;
			object pCity = DBNull.Value;
			object pState = DBNull.Value;
			object pZipCode = DBNull.Value;
			object pFullXMLReport = DBNull.Value;
			object pContractNumber = DBNull.Value;
			object pAccountNumber = DBNull.Value;
			object pScore = DBNull.Value;

			if (CustomerName != null)
				pCustomerName = CustomerName;
			if (StreetAddress != null)
				pStreetAddress = StreetAddress;
			if (City != null)
				pCity = City;
			if (State != null)
				pState = State;
			if (ZipCode != null)
				pZipCode = ZipCode;
			if (FullXMLReport != null)
				pFullXMLReport = FullXMLReport;
			if (Contract_nbr != null)
				pContractNumber = Contract_nbr;
			if (Account_nbr != null)
				pAccountNumber = Account_nbr;
			if (Score != null)
				pScore = Score;

			using (SqlConnection connection = new SqlConnection(connStr))
			{
				string SQL = "usp_CreditScoreHistoryInsert";
				SqlCommand insertCommand = new SqlCommand(SQL, connection);
				insertCommand.CommandType = CommandType.StoredProcedure;
				insertCommand.Parameters.AddWithValue("@p_CustomerName", pCustomerName);
				insertCommand.Parameters.AddWithValue("@p_StreetAddress", pStreetAddress);
				insertCommand.Parameters.AddWithValue("@p_City", pCity);
				insertCommand.Parameters.AddWithValue("@p_State", pState);
				insertCommand.Parameters.AddWithValue("@p_ZipCode", pZipCode);
				insertCommand.Parameters.AddWithValue("@p_DateAcquired", DateAcquired);
				insertCommand.Parameters.AddWithValue("@p_AgencyReferenceID", AgencyReferenceID);
				insertCommand.Parameters.AddWithValue("@p_CreditAgencyID", CreditAgencyID);
				insertCommand.Parameters.AddWithValue("@p_Score", pScore);
				insertCommand.Parameters.AddWithValue("@p_ScoreType", ScoreType);
				insertCommand.Parameters.AddWithValue("@p_FullXMLReport", pFullXMLReport);
				insertCommand.Parameters.AddWithValue("@p_Source", Source);
				insertCommand.Parameters.AddWithValue("@p_CustomerID", CustomerID);
				insertCommand.Parameters.AddWithValue("@p_Contract_nbr", pContractNumber);
				insertCommand.Parameters.AddWithValue("@p_Account_nbr", pAccountNumber);
				insertCommand.Parameters.AddWithValue("@p_Username", Username);
				insertCommand.Parameters.AddWithValue("@p_DateCreated", DateCreated);
				connection.Open();
				insertCommand.ExecuteNonQuery();
				connection.Close();
			}

		}
		/// <summary>
		/// Gets the last record from the History table matching the BusinessName and Address
		/// </summary>
		/// <param name="businessName"></param>
		/// <param name="streetAddress"></param>
		/// <param name="city"></param>
		/// <param name="state"></param>
		/// <param name="zipCode"></param>
		/// <returns></returns>
		public static DataSet GetLastCreditScoreHistory(string businessName, string streetAddress, string city, string state, string zipCode)
		{
			string connStr = Helper.ConnectionString;
			DataSet ds = new DataSet();

			using (SqlConnection connection = new SqlConnection(connStr))
			{
				string SQL = "usp_CreditScoreHistorySel_byAddress";
				using (SqlDataAdapter da = new SqlDataAdapter(SQL, connStr))
				{
					da.SelectCommand.CommandType = CommandType.StoredProcedure;
					da.SelectCommand.Parameters.AddWithValue("@p_CustomerName", businessName);
					da.SelectCommand.Parameters.AddWithValue("@p_StreetAddress", streetAddress);
					da.SelectCommand.Parameters.AddWithValue("@p_City", city);
					da.SelectCommand.Parameters.AddWithValue("@p_State", state);
					da.SelectCommand.Parameters.AddWithValue("@p_ZipCode", zipCode);
					da.Fill(ds);
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets the last record from the history given a (contract or account) and a score 
		/// </summary>
		/// <param name="contractNumber"></param>
		/// <param name="accountNumber"></param>
		/// <param name="score"></param>
		/// <returns></returns>
		public static DataSet GetLastCreditScoreHistory(string contractNumber, string accountNumber, decimal? score)
		{
			string connStr = Helper.ConnectionString;
			DataSet ds = new DataSet();

			object pContractNumber = DBNull.Value;
			object pAccountNumber = DBNull.Value;

			if (contractNumber != string.Empty)
				pContractNumber = contractNumber;

			if (accountNumber != string.Empty)
				pAccountNumber = accountNumber;

			using (SqlConnection connection = new SqlConnection(connStr))
			{
				string SQL = "usp_CreditScoreHistorySel";
				using (SqlDataAdapter da = new SqlDataAdapter(SQL, connStr))
				{
					da.SelectCommand.CommandType = CommandType.StoredProcedure;
					da.SelectCommand.Parameters.AddWithValue("@p_contract_nbr", pContractNumber);
					da.SelectCommand.Parameters.AddWithValue("@p_account_nbr", pAccountNumber);
					da.SelectCommand.Parameters.AddWithValue("@p_score", score);
					da.Fill(ds);
				}
			}
			return ds;
		}

        #region old_code
        public static DataSet CreditScoreCriteriaSelect(int creditAgencyID, int accountTypeID)
        {
            string connStr = Helper.ConnectionString;
            DataSet ds = new DataSet();

            using (SqlConnection connection = new SqlConnection(connStr))
            {
                string SQL = "usp_CreditScoreCriteriaSelectList";
                using (SqlDataAdapter da = new SqlDataAdapter(SQL, connStr))
                {
                    da.SelectCommand.CommandType = CommandType.StoredProcedure;
                    da.SelectCommand.Parameters.AddWithValue("@p_CreditAgencyID", creditAgencyID);
                    da.SelectCommand.Parameters.AddWithValue("@p_AccountTypeID", accountTypeID);
                    da.Fill(ds);
                }
            }
            return ds;
        }

        public static DataSet CreditScoreCriteriaSelectById(int creditScoreCriteriaID)
        {
            string connStr = Helper.ConnectionString;
            DataSet ds = new DataSet();

            using (SqlConnection connection = new SqlConnection(connStr))
            {
                string SQL = "usp_CreditScoreCriteriaSelect";
                using (SqlDataAdapter da = new SqlDataAdapter(SQL, connStr))
                {
                    da.SelectCommand.CommandType = CommandType.StoredProcedure;
                    da.SelectCommand.Parameters.AddWithValue("@p_CreditScoreCriteriaID", creditScoreCriteriaID);
                    da.Fill(ds);
                }
            }
            return ds;
        }

        /// <summary>
        /// Deletes a CreditScoreCriteria
        /// </summary>
        /// <param name="CreditScoreCriteriaId">Id of the CreditScoreCriteria </param>
        public static void DeleteCreditScoreCriteria(int CreditScoreCriteriaId)
        {
            string connStr = Helper.ConnectionString;

            using (SqlConnection connection = new SqlConnection(connStr))
            {
                string SQL = "usp_CreditScoreCriteriaDelete";
                SqlCommand deleteCommand = new SqlCommand(SQL, connection);
                deleteCommand.CommandType = CommandType.StoredProcedure;
                deleteCommand.Parameters.AddWithValue("@CreditScoreCriteriaId", CreditScoreCriteriaId);
                connection.Open();
                deleteCommand.ExecuteNonQuery();
                connection.Close();
            }
        }


        #endregion

        public static DataSet GetAddressSpells()
        {
            string connStr = Helper.ConnectionString;
            DataSet ds = new DataSet();
            using (SqlConnection connection = new SqlConnection(connStr))
            {
                string SQL = "usp_AddressSpellSelect";
                using (SqlDataAdapter da = new SqlDataAdapter(SQL, connStr))
                {
                    da.SelectCommand.CommandType = CommandType.StoredProcedure;
                    da.Fill(ds);
                }
            }
            return ds;
        }

        public static DataSet GetCriteriaSetById(int id)
        {
            string connStr = Helper.ConnectionString;
            DataSet ds = new DataSet();

            using (SqlConnection connection = new SqlConnection(connStr))
            {
                string SQL = "usp_CriteriaSetSelect";
                using (SqlDataAdapter da = new SqlDataAdapter(SQL, connStr))
                {
                    da.SelectCommand.CommandType = CommandType.StoredProcedure;
                    da.SelectCommand.Parameters.AddWithValue("@p_Id", id);
                    da.Fill(ds);
                }
            }
            return ds;
        }

    }
}
