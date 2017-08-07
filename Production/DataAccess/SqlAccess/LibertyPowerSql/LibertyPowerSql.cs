using System;
using System.Data;
using System.Data.SqlClient;
using System.Text;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
	[Serializable]
	public static class LibertyPowerSql
	{


        /// <summary>
        /// Gets account data for specified account number and utility code
        /// </summary>
        /// <param name="accountNumber">Indentifier of account</param>
        /// <param name="utilityCode">Identifier of utility</param>
        /// <returns>Returns a DataSet containing account data for specified account number and utility code</returns>
        public static DataSet AccountsExistsInOfferEngineAndServiceAccount(string accountNumber, string utilityCode)
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_AccountsExistsInOfferEngineAndServiceAccount";

                    cmd.Parameters.Add(new SqlParameter("@AccountNumber", accountNumber));
                    cmd.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
                }
            }
            return ds;
        }
		/// <summary>
		/// Gets account data for specified account number and utility code
		/// </summary>
		/// <param name="accountNumber">Indentifier of account</param>
		/// <param name="utilityCode">Identifier of utility</param>
		/// <returns>Returns a DataSet containing account data for specified account number and utility code</returns>
		public static DataSet GetAccount( string accountNumber, string utilityCode )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountByAccountNumberUtilitySelect";

					cmd.Parameters.Add( new SqlParameter( "@AccountNumber", accountNumber ) );
					cmd.Parameters.Add( new SqlParameter( "@UtilityCode", utilityCode ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}
		public static DataSet GetAccounts( string accountNumbersCSVList, string utilityCodesCSVList )
		{
			const int bufferSize = 3900;
			DataSet accumulatedData = new DataSet();
			StringBuilder accountsStringBuilder = new StringBuilder( 200 );
			StringBuilder utilitiesStringBuilder = new StringBuilder( 200 );

			// If accounts or utilities list is empty, return
			if( string.IsNullOrEmpty( accountNumbersCSVList ) || string.IsNullOrEmpty( utilityCodesCSVList ) )
			{
				return accumulatedData;
			}

			accountNumbersCSVList = accountNumbersCSVList.Replace( " ", "" ).Trim();
			utilityCodesCSVList = utilityCodesCSVList.Replace( " ", "" ).Trim();

			// Strip off the last comma
			if( accountNumbersCSVList.EndsWith( "," ) )
			{
				accountNumbersCSVList = accountNumbersCSVList.Substring( 0, accountNumbersCSVList.Length - 1 );
			}

			// Strip off the last comma
			if( utilityCodesCSVList.EndsWith( "," ) )
			{
				utilityCodesCSVList = utilityCodesCSVList.Substring( 0, utilityCodesCSVList.Length - 1 );
			}

			string[] accountsArray = accountNumbersCSVList.Split( ',' );
			string[] utilitiesArray = utilityCodesCSVList.Split( ',' );

			// If the number of accounts does not equal the number of utilities, error.
			if( accountsArray.Length != utilitiesArray.Length )
			{
				throw new ArgumentException( "The number of accounts and utilities must match." );
			}

			// For each item in the accounts/utilities arrays
			for( int i = 0; i < accountsArray.Length; i++ )
			{
				accountsStringBuilder.Append( accountsArray[i] );
				accountsStringBuilder.Append( "," );

				utilitiesStringBuilder.Append( utilitiesArray[i] );
				utilitiesStringBuilder.Append( "," );

				// If we have reached (bufferSize) of data, pass to the database and get account info
				if( accountsStringBuilder.Length >= bufferSize || utilitiesStringBuilder.Length >= bufferSize )
				{
					accumulatedData = GetAccountsDataSet( accumulatedData, accountsStringBuilder.ToString(), utilitiesStringBuilder.ToString() );

					// Clear both string builders
					accountsStringBuilder.Remove( 0, accountsStringBuilder.Length );
					utilitiesStringBuilder.Remove( 0, utilitiesStringBuilder.Length );
				}
			}

			// Get the remainder of the account info.  This is the data that did not reach the (bufferSize) limit
			if( accountsStringBuilder.Length > 0 )
			{
				accumulatedData = GetAccountsDataSet( accumulatedData, accountsStringBuilder.ToString(), utilitiesStringBuilder.ToString() );
			}
			return accumulatedData;
		}
		private static DataSet GetAccountsDataSet( DataSet accumulatedData, string accounts, string utilities )
		{
			DataSet newData = new DataSet();

			using( SqlConnection selectConnection = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand command = new SqlCommand() )
				{
					command.Connection = selectConnection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = "usp_VRE_AccountsSelect";
					command.CommandTimeout = 120;
					command.Parameters.Add( new SqlParameter( "AccountNumberList", accounts ) );
					command.Parameters.Add( new SqlParameter( "UtilityCodeList", utilities ) );

					using( SqlDataAdapter da = new SqlDataAdapter( command ) )
					{
						da.Fill( newData );

						if( accumulatedData.Tables.Count == 0 )
						{
							// First time this is run, nothing to merge yet
							accumulatedData = newData;
						}
						else
						{
							// Merge the new records with the existing ones
							accumulatedData.Tables[0].Merge( newData.Tables[0] );
						}
					}
				}
			}
			return accumulatedData;
		}

        public static DataSet GetUploadedAccounts(string accountNumbersCSVList, string utilityCodesCSVList)
        {
            const int bufferSize = 3900;
            DataSet accumulatedData = new DataSet();
            StringBuilder accountsStringBuilder = new StringBuilder(200);
            StringBuilder utilitiesStringBuilder = new StringBuilder(200);

            // If accounts or utilities list is empty, return
            if (string.IsNullOrEmpty(accountNumbersCSVList) || string.IsNullOrEmpty(utilityCodesCSVList))
            {
                return accumulatedData;
            }

            accountNumbersCSVList = accountNumbersCSVList.Replace(" ", "").Trim();
            utilityCodesCSVList = utilityCodesCSVList.Replace(" ", "").Trim();

            // Strip off the last comma
            if (accountNumbersCSVList.EndsWith(","))
            {
                accountNumbersCSVList = accountNumbersCSVList.Substring(0, accountNumbersCSVList.Length - 1);
            }

            // Strip off the last comma
            if (utilityCodesCSVList.EndsWith(","))
            {
                utilityCodesCSVList = utilityCodesCSVList.Substring(0, utilityCodesCSVList.Length - 1);
            }

            string[] accountsArray = accountNumbersCSVList.Split(',');
            string[] utilitiesArray = utilityCodesCSVList.Split(',');

            // If the number of accounts does not equal the number of utilities, error.
            if (accountsArray.Length != utilitiesArray.Length)
            {
                throw new ArgumentException("The number of accounts and utilities must match.");
            }

            // For each item in the accounts/utilities arrays
            for (int i = 0; i < accountsArray.Length; i++)
            {
                accountsStringBuilder.Append(accountsArray[i]);
                accountsStringBuilder.Append(",");

                utilitiesStringBuilder.Append(utilitiesArray[i]);
                utilitiesStringBuilder.Append(",");

                // If we have reached (bufferSize) of data, pass to the database and get account info
                if (accountsStringBuilder.Length >= bufferSize || utilitiesStringBuilder.Length >= bufferSize)
                {
                    accumulatedData = GetUploadedAccountsDataSet(accumulatedData, accountsStringBuilder.ToString(), utilitiesStringBuilder.ToString());

                    // Clear both string builders
                    accountsStringBuilder.Remove(0, accountsStringBuilder.Length);
                    utilitiesStringBuilder.Remove(0, utilitiesStringBuilder.Length);
                }
            }

            // Get the remainder of the account info.  This is the data that did not reach the (bufferSize) limit
            if (accountsStringBuilder.Length > 0)
            {
                accumulatedData = GetUploadedAccountsDataSet(accumulatedData, accountsStringBuilder.ToString(), utilitiesStringBuilder.ToString());
            }
            return accumulatedData;
        }
        private static DataSet GetUploadedAccountsDataSet(DataSet accumulatedData, string accounts, string utilities)
        {
            DataSet newData = new DataSet();

            using (SqlConnection selectConnection = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = selectConnection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "usp_VRE_UploadedAccountsSelect";
                    command.CommandTimeout = 120;
                    command.Parameters.Add(new SqlParameter("AccountNumberList", accounts));
                    command.Parameters.Add(new SqlParameter("UtilityCodeList", utilities));

                    using (SqlDataAdapter da = new SqlDataAdapter(command))
                    {
                        da.Fill(newData);

                        if (accumulatedData.Tables.Count == 0)
                        {
                            // First time this is run, nothing to merge yet
                            accumulatedData = newData;
                        }
                        else
                        {
                            // Merge the new records with the existing ones
                            accumulatedData.Tables[0].Merge(newData.Tables[0]);
                        }
                    }
                }
            }
            return accumulatedData;
        }

		/// <summary>
		/// Gets account data for specified accountId
		/// </summary>
		/// <param name="accountId">Internal id</param>
		/// <returns>Returns a DataSet containing account data for specified accountId</returns>
		public static DataSet GetAccount( string accountId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountByAccountIdSelect";

					cmd.Parameters.Add( new SqlParameter( "@AccountId", accountId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Gets account data for specified accountId
		/// </summary>
		/// <param name="accountId">Internal id</param>
		/// <returns>Returns a DataSet containing account data for specified accountId</returns>
		public static DataSet GetAccount( int accountID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountByAccountIdSelect";

					cmd.Parameters.Add( new SqlParameter( "@AccountId", accountID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

        /// <summary>
        /// Gets account data for specified AccountIdLegacy
        /// </summary>
        /// <param name="AccountIdLegacy">Legacy id</param>
        /// <returns>Returns a DataSet containing account data for specified AccountIdLegacy</returns>
        public static DataSet GetAccountByLegacyId(string accountIdLegacy)
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_AccountByLegacyAccountIdSelect";

                    cmd.Parameters.Add(new SqlParameter("@LegacyAccountId", accountIdLegacy));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
                }
            }
            return ds;
        }

		/// <summary>
		/// Gets the utility code based on the utility DUNS number
		/// </summary>
		/// <param name="utilityDuns">Utility DUNS number</param>
		/// <returns>Returns a dataset containing the utility code.</returns>
		public static DataSet GetUtilityCodeByDuns( string utilityDuns )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_UtilityCodeByDunsSelect";

					cmd.Parameters.Add( new SqlParameter( "@UtilityDuns", utilityDuns ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets product types
		/// </summary>
		/// <returns>Returns a dataset containing product types.</returns>
		public static DataSet GetProductTypes()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ProductTypesSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}
        /// <summary>
        /// Gets product types
        /// </summary>
        /// <returns>Returns a dataset containing product types.</returns>
        public static DataSet GetAllProductBrand()
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_ProductBrandList";
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }
		/// <summary>
		/// Gets account types
		/// </summary>
		/// <returns>Returns a dataset containing account types.</returns>
		public static DataSet GetAccountTypes()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountTypesSelect";
					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

        public static DataSet GetAllProductAccountType()
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_AccountList";
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }
		/// <summary>
		/// Gets account types for sales channel
		/// </summary>
		/// <param name="channelID">Sales channel record identifier</param>
		/// <returns>Returns a dataset containing account types for sales channel.</returns>
		public static DataSet GetAccountTypesForSalesChannel( int channelID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_SalesChannelAccountTypesSelect";

					cmd.Parameters.Add( new SqlParameter( "@ChannelID", channelID ) );
					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets market account types for sales channel
		/// </summary>
		/// <param name="accountTypeID">Account type record identifier</param>
		/// <returns>Returns a dataset containing market account types for sales channel.</returns>
		public static DataSet GetSegmentMarketListForAccountType( int accountTypeID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_SalesChannelAccountTypesByAccountTypeSelect";

					cmd.Parameters.Add( new SqlParameter( "@AccountTypeID", accountTypeID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Inserts account type for sales channel
		/// </summary>
		/// <param name="channelID">Sales channel record identifier</param>
		/// <param name="accountTypeID">Account type record identifier</param>
		/// <param name="marketID">Market record identifier</param>
		/// <returns>Returns a dataset containing inserted data with record identifier.</returns>
		public static DataSet InsertAccountTypeForSalesChannel( int channelID, int accountTypeID, int marketID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_SalesChannelAccountTypeInsert";

					cmd.Parameters.Add( new SqlParameter( "@ChannelID", channelID ) );
					cmd.Parameters.Add( new SqlParameter( "@AccountTypeID", accountTypeID ) );
					cmd.Parameters.Add( new SqlParameter( "@MarketID", marketID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Deletes account types for sales channel
		/// </summary>
		/// <param name="channelID">Sales channel record identifier</param>
		/// <param name="marketID">Market record identifier</param>
		public static void DeleteAccountTypesForSalesChannel( int channelID, int marketID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_SalesChannelAccountTypesDelete";

					cmd.Parameters.Add( new SqlParameter( "@ChannelID", channelID ) );
					cmd.Parameters.Add( new SqlParameter( "@MarketID", marketID ) );

					cn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}

		/// <summary>
		/// Gets account type for specified identity
		/// </summary>
		/// <param name="identity">Record identifier</param>
		/// <returns>Returns a dataset containing the account type for specified identity.</returns>
		public static DataSet GetAccountType( int identity )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountTypeSelect";

					cmd.Parameters.Add( new SqlParameter( "@Identity", identity ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets the type of the account.
		/// </summary>
		/// <param name="accountType">Type of the account.</param>
		/// <returns></returns>
		public static DataSet GetAccountType( string accountType )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountTypeSelectByAccountType";

					cmd.Parameters.Add( new SqlParameter( "@AccountType", accountType ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets channel types
		/// </summary>
		/// <returns>Returns a dataset containing channel types.</returns>
		public static DataSet GetChannelTypes()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ChannelTypesSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets channel type for specified identity
		/// </summary>
		/// <param name="identity">Record identifier</param>
		/// <returns>Returns a dataset containing the channel type for specified identity.</returns>
		public static DataSet GetChannelType( int identity )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ChannelTypeSelect";

					cmd.Parameters.Add( new SqlParameter( "@Identity", identity ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets channel type for specified name
		/// </summary>
		/// <param name="name">The name of a channel type.</param>
		/// <returns>Returns a dataset containing the channel type for specified name.</returns>
		public static DataSet GetChannelType( string name )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ChannelTypeSelectByName";

					cmd.Parameters.Add( new SqlParameter( "@Name", name ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets channel groups
		/// </summary>
		/// <returns>Returns a dataset containing channel groups.</returns>
		public static DataSet GetChannelGroups()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 3600;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ChannelGroupsSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets the channel group.
		/// </summary>
		/// <param name="channelGroupId">The channel group id.</param>
		/// <returns></returns>
		public static DataSet GetChannelGroup( int channelGroupId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ChannelGroupSelect";


					cmd.Parameters.Add( new SqlParameter( "@ChannelGroupID", channelGroupId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets the channel group.
		/// </summary>
		/// <param name="channelGroupId">The channel group id.</param>
		/// <returns></returns>
		public static DataSet GetChannelGroup( string channelGroupName )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 120;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ChannelGroupSelectByName";


					cmd.Parameters.Add( new SqlParameter( "@ChannelGroupName", channelGroupName ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Inserts the channel group.
		/// </summary>
		/// <param name="name">The name.</param>
		/// <param name="description">The description.</param>
		/// <param name="channelTypeID">The channel type ID.</param>
		/// <param name="commissionRate">The commission rate.</param>
		/// <returns></returns>
		public static DataSet InsertChannelGroup( string name, string description, int channelTypeID, decimal commissionRate, bool isActive )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ChannelGroupInsert";

					cmd.Parameters.Add( new SqlParameter( "@Name", name ) );
					cmd.Parameters.Add( new SqlParameter( "@Description", description ) );
					cmd.Parameters.Add( new SqlParameter( "@ChannelTypeID", channelTypeID ) );
					cmd.Parameters.Add( new SqlParameter( "@CommissionRate", commissionRate ) );
					cmd.Parameters.Add( new SqlParameter( "@Active", isActive ) );


					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Updates the channel group.
		/// </summary>
		/// <param name="channelGroupID">The channel group ID.</param>
		/// <param name="description">The description.</param>
		/// <param name="channelTypeID">The channel type ID.</param>
		/// <param name="commissionRate">The commission rate.</param>
		/// <returns></returns>
		public static DataSet UpdateChannelGroup( int channelGroupID, string description, int channelTypeID, decimal commissionRate, bool isActive )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ChannelGroupUpdate";

					cmd.Parameters.Add( new SqlParameter( "@ChannelGroupID", channelGroupID ) );
					cmd.Parameters.Add( new SqlParameter( "@Description", description ) );
					cmd.Parameters.Add( new SqlParameter( "@ChannelTypeID", channelTypeID ) );
					cmd.Parameters.Add( new SqlParameter( "@CommissionRate", commissionRate ) );
					cmd.Parameters.Add( new SqlParameter( "@Active", isActive ) );
					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Inserts utility mapping record, returning inserted data with record identifier
		/// </summary>
		/// <param name="accountNumber">Account number</param>
		/// <param name="utilityId">Utility record identifier</param>
		/// <param name="message">Message</param>
		/// <param name="severityLevel">Severity level (Enum numeric value)</param>
		/// <param name="lpcApplication">LPC application (Enum numeric value)</param>
		/// <param name="dateCreated">Date created</param>
		/// <returns>Returns a dataset containing inserted data with record identifier.</returns>
		public static DataSet InsertUtilityMappingLog( string accountNumber, int utilityId, string message, int severityLevel, int lpcApplication, DateTime dateCreated )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_UtilityMappingLogInsert";
					cmd.Parameters.Add( new SqlParameter( "@AccountNumber", accountNumber ) );
					cmd.Parameters.Add( new SqlParameter( "@UtilityID", utilityId ) );
					cmd.Parameters.Add( new SqlParameter( "@Message", message ) );
					cmd.Parameters.Add( new SqlParameter( "@SeverityLevel", severityLevel ) );
					cmd.Parameters.Add( new SqlParameter( "@LpcApplication", lpcApplication ) );
					cmd.Parameters.Add( new SqlParameter( "@DateCreated", dateCreated ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets utility mapping log record for specified record identifier.
		/// </summary>
		/// <param name="identity">Record identifier</param>
		/// <returns>Returns a dataset containing the utility mapping log record for specified record identifier.</returns>
		public static DataSet GetUtilityMappingLog( int identity )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_UtilityMappingLogSelect";

					cmd.Parameters.Add( new SqlParameter( "@Identity", identity ) );
					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets utility mapping log records for LPC application from date specified.
		/// </summary>
		/// <param name="lpcApplication">LPC application</param>
		/// <param name="dateFrom">Date from</param>
		/// <returns>Returns a dataset containing utility mapping log records for LPC application from date specified..</returns>
		public static DataSet GetUtilityMappingLogs( int lpcApplication, DateTime dateFrom )
		{
			DataSet ds = new DataSet();
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_UtilityMappingLogByApplicationSelect";

					cmd.Parameters.Add( new SqlParameter( "@LpcApplication", lpcApplication ) );
					cmd.Parameters.Add( new SqlParameter( "@DateFrom", dateFrom ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}
		/// <summary>
		/// Logs the accounts that needed to have their dates adjusted to be sent to ISTA
		/// </summary>
		/// <param name="accountId"></param>
		/// <param name="dateTime"></param>
		/// <param name="startDate"></param>
		public static void LogAccountDateError( string accountId, string rateChangeType, DateTime intendedStartDate, DateTime actualStartDate )
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountDateErrorLogInsert";
					cmd.Parameters.Add( new SqlParameter( "@AccountID", accountId ) );
					cmd.Parameters.Add( new SqlParameter( "@RateChangeType", rateChangeType ) );
					cmd.Parameters.Add( new SqlParameter( "@IntendedStartDate", intendedStartDate ) );
					cmd.Parameters.Add( new SqlParameter( "@ActualStartDate", actualStartDate ) );

					cn.Open();
					cmd.ExecuteScalar();
				}
			}
		}

		public static void InsertMarket( string marketCode, string description, int wholesaleMarketID, string pucCertificationNumber,
			DateTime dateCreated, string username, string inactiveInd, DateTime activeDate, int changeStamp, int transferOwnershipEnabled, int enableTieredPricing )
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_MarketInsert";

					cmd.Parameters.Add( new SqlParameter( "@MarketCode", marketCode ) );
					cmd.Parameters.Add( new SqlParameter( "@RetailMktDescp", description ) );
					cmd.Parameters.Add( new SqlParameter( "@WholesaleMktId", wholesaleMarketID ) );
					cmd.Parameters.Add( new SqlParameter( "@PucCertification", pucCertificationNumber ) );
					cmd.Parameters.Add( new SqlParameter( "@DateCreated", dateCreated ) );
					cmd.Parameters.Add( new SqlParameter( "@Username", username ) );
					cmd.Parameters.Add( new SqlParameter( "@InactiveInd", inactiveInd ) );
					cmd.Parameters.Add( new SqlParameter( "@ActiveDate", activeDate ) );
					cmd.Parameters.Add( new SqlParameter( "@Chgstamp", changeStamp ) );
					cmd.Parameters.Add( new SqlParameter( "@TransferOwnershipEnabled", transferOwnershipEnabled ) );
					cmd.Parameters.Add( new SqlParameter( "@EnableTieredPricing", enableTieredPricing ) );

					cn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}

		public static void UpdateMarket( int identity, string marketCode, string description, int wholesaleMarketID, string pucCertificationNumber,
			string username, string inactiveInd, DateTime activeDate, int changeStamp, int transferOwnershipEnabled, int enableTieredPricing )
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_MarketUpdate";

					cmd.Parameters.Add( new SqlParameter( "@ID", identity ) );
					cmd.Parameters.Add( new SqlParameter( "@MarketCode", marketCode ) );
					cmd.Parameters.Add( new SqlParameter( "@RetailMktDescp", description ) );
					cmd.Parameters.Add( new SqlParameter( "@WholesaleMktId", wholesaleMarketID ) );
					cmd.Parameters.Add( new SqlParameter( "@PucCertification", pucCertificationNumber ) );
					cmd.Parameters.Add( new SqlParameter( "@Username", username ) );
					cmd.Parameters.Add( new SqlParameter( "@InactiveInd", inactiveInd ) );
					cmd.Parameters.Add( new SqlParameter( "@ActiveDate", activeDate ) );
					cmd.Parameters.Add( new SqlParameter( "@Chgstamp", changeStamp ) );
					cmd.Parameters.Add( new SqlParameter( "@TransferOwnershipEnabled", transferOwnershipEnabled ) );
					cmd.Parameters.Add( new SqlParameter( "@EnableTieredPricing", enableTieredPricing ) );

					cn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}

		public static DataSet GetMarket( int identity )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_MarketSelect";

					cmd.Parameters.Add( new SqlParameter( "@MarketID", identity ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetMarkets()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_MarketsSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetWholesaleMarkets()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_WholesaleMarketsSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static void UpdateContractEstimatedAnnualUsage( string contractNumber, int estimatedAnnualUsage )
		{
			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ContractEstimatedAnnualUsageUpdate";

					cmd.Parameters.Add( new SqlParameter( "@ContractNumber", contractNumber ) );
					cmd.Parameters.Add( new SqlParameter( "@EstimatedAnnualUsage", estimatedAnnualUsage ) );

					conn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}

		public static void UpdateAccountContractRatePriceID( string accountNumber, Int64 priceID )
		{
			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountContractRatePriceIDUpdate";

					cmd.Parameters.Add( new SqlParameter( "@AccountNumber", accountNumber ) );
					cmd.Parameters.Add( new SqlParameter( "@PriceID", priceID ) );

					conn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}

		public static void UpdateAccountContractRatePriceData( string contractNumber, string accountNumber, string productId, Int64 rateID, decimal rate, Int64 priceID )
		{
			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountContractRatePriceDataUpdate";

					cmd.Parameters.Add( new SqlParameter( "@ContractNumber", contractNumber ) );
					cmd.Parameters.Add( new SqlParameter( "@AccountNumber", accountNumber ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductID", productId ) );
					cmd.Parameters.Add( new SqlParameter( "@RateID", rateID ) );
					cmd.Parameters.Add( new SqlParameter( "@Rate", rate ) );
					cmd.Parameters.Add( new SqlParameter( "@PriceID", priceID ) );

					conn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}

		public static void UpdateEnrollmentAcceptLog( int AccountId )
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_EnrollmentAcceptedLogUpd";
					cmd.Parameters.Add( new SqlParameter( "@AccountId", AccountId ) );

					cn.Open();
					cmd.ExecuteScalar();
				}
			}
		}

		public static DataSet GetISTAUserInfo( string libertyUserName )
		{
			DataSet ds = new DataSet();
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_IstaPopUp_GetUserInfoSelect";
					cmd.Parameters.Add( new SqlParameter( "@libertyUserName", libertyUserName ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}

			return ds;
		}



		public static void UpdateISTAUserInfo( string libertyUserName, string IstaUsername, string IstaPassword )
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_IstaPopUp_GetUserInfoInsert";
					cmd.Parameters.Add( new SqlParameter( "@libertyUserName", libertyUserName ) );
					cmd.Parameters.Add( new SqlParameter( "@IstaUsername", IstaUsername ) );
					cmd.Parameters.Add( new SqlParameter( "@IstaPassword", IstaPassword ) );

					cn.Open();
					cmd.ExecuteScalar();
				}
			}
		}

		public static string GetISTAUserInfo()
		{
			throw new NotImplementedException();
		}

		/// <summary>
		/// Inserts WIPTask and WIPTaskHeader records for the contract
		/// </summary>
		/// <param name="ContractNumber"></param>
		/// <param name="ContractType"></param>
		/// <param name="Username"></param>
		public static void InsertWIPTasks( string ContractNumber, string Username )
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_WorkflowStartItem";
					cmd.Parameters.Add( new SqlParameter( "@pContractNumber", ContractNumber ) );
					cmd.Parameters.Add( new SqlParameter( "@pCreatedBy", Username ) );

					cn.Open();
					cmd.ExecuteScalar();
				}
			}
		}

		public static bool IsFeatureInUse( string FeatureName, string ProcessName )
		{
			bool isFeatureInUse = false;
			string sql = @"select dbo.ufn_GetApplicationFeatureSetting(@FeatureName,@ProcessName)";
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.Text;
					cmd.CommandText = sql;

					cmd.Parameters.AddWithValue( "@FeatureName", FeatureName );
					cmd.Parameters.AddWithValue( "@ProcessName", ProcessName );

					cn.Open();
					isFeatureInUse = Convert.ToBoolean( cmd.ExecuteScalar() );
				}
			}

			return isFeatureInUse;
		}

		public static DataSet IsPassThrough( string accountNumber )
		{
			DataSet ds = new DataSet();
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_IsPassThrough";

					cmd.Parameters.Add( new SqlParameter( "@AccountNumber", accountNumber ) );
					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static DataSet GetMultiTermByAccountIdLegacy( string accountIdLegacy )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 60;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_MultiTermByAccountIdLegacySelect";

					cmd.Parameters.Add( new SqlParameter( "@AccountIdLegacy", accountIdLegacy ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetAccountsByContractNumber( string contractNumber )
		{
			var ds = new DataSet();
			using( var cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( var cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 60;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_GetAccountsByContractNumber";

					cmd.Parameters.Add( new SqlParameter( "@ContractNumber", contractNumber ) );

					using( var da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetAccountInfoByContractId( int contractId, int accountId )
		{
			var ds = new DataSet();
			using( var cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( var cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandTimeout = 60;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_GetAccountInfoByContractId";

					cmd.Parameters.Add( new SqlParameter( "@ContractID", contractId ) );
					cmd.Parameters.Add( new SqlParameter( "@AccountID", accountId ) );

					using( var da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

        public static DataSet GetAccountRawByNumberAndUtility(string accountNumber, string utilityCode)
        {
            var ds = new DataSet();
            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_AccountSelectByNumberAndUtility";
                    cmd.Parameters.Add(new SqlParameter("@AccountNumber", accountNumber));
                    cmd.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));
                    
                    using (var da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
                }
            }
            return ds;
        }

		public static void DeleteAccountContractRate( int accountContractRateID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountContractRateDelete";

					cmd.Parameters.Add( new SqlParameter( "@AccountContractRateID", accountContractRateID ) );

					cn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}

        /// <summary>
        /// returns a list of tasks from the workflow queue
        /// </summary>
        /// <param name="status"> pending, pendingsys</param>
        /// <param name="filter">Price Validation, Letter</param>
        /// <returns></returns>
        public static DataSet WIPTaskSelect(string status, string typeFilter, string user)
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandTimeout = 60;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_WIPTaskSelect";

                    cmd.Parameters.Add(new SqlParameter("@p_username", user));
                    cmd.Parameters.Add(new SqlParameter("@p_view", status));
                    cmd.Parameters.Add(new SqlParameter("@p_check_type_filter", typeFilter));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }

        /// <summary>
        /// Update a task in the queue
        /// </summary>
        /// <param name="contract"></param>
        /// <param name="status"></param>
        /// <param name="typeFilter"></param>
        /// <param name="request"></param>
        /// <param name="comment"></param>
        /// <returns></returns>
        public static DataSet WIPTaskUpdate(string contract, string status, string typeFilter, string user, string request, string comment = "")
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandTimeout = 60;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_WIPTaskUpdateStatus";

                    cmd.Parameters.Add(new SqlParameter("@p_username", user));
                    cmd.Parameters.Add(new SqlParameter("@p_comment", comment));
                    cmd.Parameters.Add(new SqlParameter("@p_approval_status", status));
                    cmd.Parameters.Add(new SqlParameter("@p_check_type", typeFilter));
                    cmd.Parameters.Add(new SqlParameter("@p_contract_nbr", contract));
                    cmd.Parameters.Add(new SqlParameter("@p_check_request_id", request));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }

		//public static void DeleteAccountContractRate( int accountContractRateID )
		//{
		//	DataSet ds = new DataSet();

		//	using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
		//	{
		//		using( SqlCommand cmd = new SqlCommand() )
		//		{
		//			cmd.Connection = cn;
		//			cmd.CommandType = CommandType.StoredProcedure;
		//			cmd.CommandText = "usp_AccountContractRateDelete";

		//			cmd.Parameters.Add( new SqlParameter( "@AccountContractRateID", accountContractRateID ) );

		//			cn.Open();
		//			cmd.ExecuteNonQuery();
		//		}
		//	}
		//}

		/// <summary>
		/// Gets orders APi COnfiguration-- July 10 2015
		/// </summary>
		/// <returns>Returns a dataset that contains an account type for specified accountType</returns>
		public static DataSet GetOrdersAPIConfiguration()
		{
			var ds = new DataSet();
			using( var conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( var cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_GetOrderAPIConfiguration";
					using( var da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

        public static void LogRenewalSubmission(string accountNumber, string utilityId, decimal rate, decimal meterCharge, DateTime rateEffectiveDate, DateTime rateEndDate, string rateCode, bool? with814Option, string TxError)
        {
            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_LogRenewalSubmission";
                    cmd.Parameters.Add(new SqlParameter("@accountNumber", accountNumber));
                    cmd.Parameters.Add(new SqlParameter("@utilityId", utilityId));
                    cmd.Parameters.Add(new SqlParameter("@rate", rate));
                    cmd.Parameters.Add(new SqlParameter("@meterCharge", meterCharge));
                    cmd.Parameters.Add(new SqlParameter("@rateEffectiveDate", rateEffectiveDate));
                    cmd.Parameters.Add(new SqlParameter("@rateEndDate", rateEndDate));
                    cmd.Parameters.Add(new SqlParameter("@rateCode", rateCode));
                    cmd.Parameters.Add(new SqlParameter("@with814Option", with814Option));
                    cmd.Parameters.Add(new SqlParameter("@TxError", TxError));

                    cn.Open();
                    cmd.ExecuteScalar();
                }
            }
        }


	}
}

