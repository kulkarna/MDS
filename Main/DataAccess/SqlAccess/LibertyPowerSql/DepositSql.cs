﻿using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    public class DepositSql
    {
        /// <summary>
        /// Inserts a new record in the DepositAgencyRequirementsHeader table
        /// </summary>
        /// <param name="agencyID">Agency´s id</param>
        /// <param name="createdBy">who creates the record</param>
        /// <param name="dateCreated">date created</param>
        /// <param name="id">ID generated by the sql server</param>
        public static void InsertAgencyScoreRequirement(int agencyID, string createdBy, DateTime dateCreated, ref int id)
        {
            string connStr = Helper.ConnectionString;

            using (SqlConnection connection = new SqlConnection(connStr))
            {
                string SQL = "usp_DepositAgencyRequirementHeaderInsert";
                SqlCommand insertCommand = new SqlCommand(SQL, connection);
                insertCommand.CommandType = CommandType.StoredProcedure;
                insertCommand.Parameters.AddWithValue("@p_agencyID", agencyID);
                insertCommand.Parameters.AddWithValue("@p_dateCreated", dateCreated);
                insertCommand.Parameters.AddWithValue("@p_createdBy", createdBy);

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
        /// Insert detail records in the DepositAgencyRequirementsDetail table
        /// </summary>
        /// <param name="DepositAgencyRequirementID">The Id of the Header table</param>
        /// <param name="lowScore">low score</param>
        /// <param name="highScore">high score</param>
        /// <param name="deposit">value to deposit</param>
        public static void InsertAgencyScoreRequirementDetails(int DepositAgencyRequirementID, int lowScore, int? highScore, decimal deposit, string accountTypeGroup)
        {
            string connStr = Helper.ConnectionString;

            using (SqlConnection connection = new SqlConnection(connStr))
            {
                string SQL = "usp_DepositAgencyRequirementDetailInsert";
                SqlCommand insertCommand = new SqlCommand(SQL, connection);
                insertCommand.CommandType = CommandType.StoredProcedure;
                insertCommand.Parameters.AddWithValue("@p_DepositAgencyRequirementID", DepositAgencyRequirementID);
                insertCommand.Parameters.AddWithValue("@p_lowScore", lowScore);
                insertCommand.Parameters.AddWithValue("@p_highScore", highScore);
                insertCommand.Parameters.AddWithValue("@p_deposit", deposit);
				insertCommand.Parameters.AddWithValue("@p_AccountTypeGroup", accountTypeGroup);
                
                connection.Open();
                insertCommand.ExecuteNonQuery();
                connection.Close();
            }
        }

        public static void UpdateAgencyScoreRequirement(int DepositAgencyRequirementID, DateTime expireDate, string user)
        {
            string connStr = Helper.ConnectionString;

            using (SqlConnection connection = new SqlConnection(connStr))
            {
                string SQL = "usp_DepositAgencyRequirementHeaderUpdate";
                SqlCommand insertCommand = new SqlCommand(SQL, connection);
                insertCommand.CommandType = CommandType.StoredProcedure;
                insertCommand.Parameters.AddWithValue("@DepositAgencyRequirementID", DepositAgencyRequirementID);
                insertCommand.Parameters.AddWithValue("@DateExpired", expireDate);
                insertCommand.Parameters.AddWithValue("@expiredBy", user);
               
                connection.Open();
                insertCommand.ExecuteNonQuery();
                connection.Close();
            }
        }
        /// <summary>
        /// Gets a DepositAgencyRequirement By Id
        /// </summary>
        /// <param name="DepositAgencyRequirementID">Id of the table</param>
        /// <returns>Dataset</returns>
        public static DataSet GetDepositAgencyRequirementById(int DepositAgencyRequirementID)
        {
            string connStr = Helper.ConnectionString;
            DataSet ds = new DataSet();

            using (SqlConnection connection = new SqlConnection(connStr))
            {
                string SQL = "usp_DepositAgencyRequirementHeaderSelect";
                using (SqlDataAdapter da = new SqlDataAdapter(SQL, connStr))
                {
                    da.SelectCommand.CommandType = CommandType.StoredProcedure;
                    da.SelectCommand.Parameters.AddWithValue("@p_id", DepositAgencyRequirementID);
                    da.Fill(ds);
                }
            }
            return ds;
        }

        /// <summary>
        /// Gets a record from the DepositAgencyRequirements table depending on the status
        /// 0 (Gets only non expired records), = 1 (Gets the last record) > 1 (Gets all records)
        /// </summary>
        /// <param name="AgencyID">Agency´s Id</param>
        /// <param name="status">status to get records</param>
        /// <returns>dataset</returns>
        public static DataSet GetDepositAgencyRequirements(int AgencyID, int status)
        {
            string connStr = Helper.ConnectionString;
            DataSet ds = new DataSet();

            using (SqlConnection connection = new SqlConnection(connStr))
            {
                string SQL = "usp_DepositAgencyRequirementSelectList";
                using (SqlDataAdapter da = new SqlDataAdapter(SQL, connStr))
                {
                    da.SelectCommand.CommandType = CommandType.StoredProcedure;
                    da.SelectCommand.Parameters.AddWithValue("@p_agencyID", AgencyID);
                    da.SelectCommand.Parameters.AddWithValue("@p_status", status);
                    da.Fill(ds);
                }
            }
            return ds;

        }

        public static DataSet GetAgencyRequirementsList()
        {
            string connStr = Helper.ConnectionString;
            DataSet ds = new DataSet();
            const int GETALLRECORDS = 2;
            using (SqlConnection connection = new SqlConnection(connStr))
            {
                string SQL = "usp_DepositAgencyRequirementSelectList";
                using (SqlDataAdapter da = new SqlDataAdapter(SQL, connStr))
                {
                    da.SelectCommand.CommandType = CommandType.StoredProcedure;
                    da.SelectCommand.Parameters.AddWithValue("@p_status", GETALLRECORDS);
                    da.Fill(ds);
                }
            }
            return ds;
        }

        /// <summary>
        /// Gets the Records from the DepositAgencyRequirementsDetails given the Id of the header´s table 
        /// </summary>
        /// <param name="depositAgencyRequirementID">Id of the Header´s table</param>
        /// <returns></returns>
        public static DataSet GetDepositAgencyRequirementsDetails(int depositAgencyRequirementID)
        {
            string connStr = Helper.ConnectionString;
            DataSet ds = new DataSet();

            using (SqlConnection connection = new SqlConnection(connStr))
            {
                string SQL = "usp_DepositAgencyRequirementDetailSelect";
                using (SqlDataAdapter da = new SqlDataAdapter(SQL, connStr))
                {
                    da.SelectCommand.CommandType = CommandType.StoredProcedure;
                    da.SelectCommand.Parameters.AddWithValue("@p_DepositAgencyRequirementID", depositAgencyRequirementID);
                    da.Fill(ds);
                }
            }
            return ds;
        }

		public static DataSet GetDepositRateRule(string marketId, string utilityId)
		{
			string connStr = Helper.ConnectionString;
			DataSet ds = new DataSet();

			using (SqlConnection connection = new SqlConnection(connStr))
			{
				string SQL = "usp_DepositRateRule_SelectByMarket_Utility";
				using (SqlDataAdapter da = new SqlDataAdapter(SQL, connStr))
				{
					da.SelectCommand.CommandType = CommandType.StoredProcedure;
					da.SelectCommand.Parameters.AddWithValue("@p_Retail_market_id", marketId);
					da.SelectCommand.Parameters.AddWithValue("@p_utility_id", utilityId);
					da.Fill(ds);
				}
			}
			return ds;
		}

		public static DataSet GetDepositRateRuleList()
		{
			string connStr = Helper.ConnectionString;
			DataSet ds = new DataSet();

			using (SqlConnection connection = new SqlConnection(connStr))
			{
				string SQL = "usp_DepositRateRule_SelectList";
				using (SqlDataAdapter da = new SqlDataAdapter(SQL, connStr))
				{
					da.SelectCommand.CommandType = CommandType.StoredProcedure;
					da.Fill(ds);
				}
			}
			return ds;
		}


		//TODO: This method is calling an temporary stored procedure. Need to use the OOP way
		public static Decimal GetDepositRateRule(string accountNumber)
		{
			string connStr = Helper.ConnectionString;
			decimal rate = 0M;

			using (SqlConnection connection = new SqlConnection(connStr))
			{
				string SQL = "usp_DepositRateRule_GetRateByAccountNumber";
				SqlCommand command = new SqlCommand(SQL, connection);
				command.CommandType = CommandType.StoredProcedure;
				command.Parameters.AddWithValue("@p_account_number", accountNumber);
				connection.Open();
				rate = Convert.ToDecimal(command.ExecuteScalar());
				connection.Close();
			}
			return rate;
		}

		public static void InsertDepositRateRule(string retailMarketID, string utilityID, decimal rate, DateTime dateCreated, string createdBy, DateTime? dateExpired, string expiredBy)
		{
			string connStr = Helper.ConnectionString;

			using (SqlConnection connection = new SqlConnection(connStr))
			{
				string SQL = "usp_DepositRateRuleInsert";
				SqlCommand insertCommand = new SqlCommand(SQL, connection);
				insertCommand.CommandType = CommandType.StoredProcedure;
				insertCommand.Parameters.AddWithValue("@p_retail_market_id", retailMarketID);
				insertCommand.Parameters.AddWithValue("@p_utility_id", utilityID);
				insertCommand.Parameters.AddWithValue("@p_rate", rate);
				insertCommand.Parameters.AddWithValue("@p_date_created", dateCreated);
				insertCommand.Parameters.AddWithValue("@p_created_by", createdBy);
				if (dateExpired.HasValue)
				{
					insertCommand.Parameters.AddWithValue("@p_date_expired", dateExpired);
					insertCommand.Parameters.AddWithValue("@p_expired_by", expiredBy);
				}

				connection.Open();
				insertCommand.ExecuteNonQuery();
				connection.Close();
			}
		}

		public static void ExpireDepositRateRule(int id, DateTime dateExpired, string expiredBy)
		{
			string connStr = Helper.ConnectionString;

			using (SqlConnection connection = new SqlConnection(connStr))
			{
				string SQL = "usp_DepositRateRuleExpire";
				SqlCommand insertCommand = new SqlCommand(SQL, connection);
                insertCommand.CommandType = CommandType.StoredProcedure;
				insertCommand.Parameters.AddWithValue("@p_date_expired", dateExpired);
				insertCommand.Parameters.AddWithValue("@p_expired_by", expiredBy);
				insertCommand.Parameters.AddWithValue("@p_DepositRateRuleID", id);
				connection.Open();
				insertCommand.ExecuteNonQuery();
				connection.Close();
			}
		}

    }
}
