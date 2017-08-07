namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
	using System;
	using System.Configuration;
	using System.Data;
	using System.Data.SqlClient;

	/// <summary>
	/// DAL Class for Sales Channels.
	/// </summary>
	[Serializable]
	public static class SalesChannelSql
	{
		/// <summary>
		/// Creates the sales channel.
		/// </summary>
		/// <param name="ChannelName">Name of the channel.</param>
		/// <param name="ChannelDescription">The channel description.</param>
		/// <param name="CreatedBY">The created BY.</param>
		/// <param name="EntityID">The entity ID.</param>
		/// <param name="ActiveDirectoryLoginID">The active directory login ID.</param>
		/// <param name="ChannelDevelopmentManagerID">The channel development manager ID.</param>
		/// <returns></returns>
		[Obsolete( "Support of legacy code. Accepts a value for ActiveDirectoryLoginID but the value is no longer stored or used." )]
		public static DataSet CreateSalesChannel( string ChannelName, string ChannelDescription, int CreatedBY, int EntityID, string ActiveDirectoryLoginID, int? ChannelDevelopmentManagerID )
		{
            return CreateSalesChannel(ChannelName, ChannelDescription, CreatedBY, EntityID, ChannelDevelopmentManagerID, false, true, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, 0, false, false, false, false, false, false, 0, 0, false, string.Empty, false, string.Empty);
		}

		/// <summary>
		/// Creates the sales channel.
		/// </summary>
		/// <param name="ChannelName">Name of the channel.</param>
		/// <param name="ChannelDescription">The channel description.</param>
		/// <param name="createdBy">The created by.</param>
		/// <param name="EntityID">The entity ID.</param>
		/// <param name="ChannelDevelopmentManagerID">The channel development manager ID.</param>
		/// <param name="HasManagedUsers"><c>true</c> if Channel uses Agents.</param>
		/// <param name="Inactive"><c>true</c> if Channel is Inactive.</param>
		/// <returns></returns>
		public static DataSet CreateSalesChannel( string ChannelName, string ChannelDescription, int createdBy, int EntityID, int? ChannelDevelopmentManagerID, bool HasManagedUsers, bool isInactive )
		{
            return CreateSalesChannel(ChannelName, ChannelDescription, createdBy, EntityID, ChannelDevelopmentManagerID, HasManagedUsers, isInactive, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, 0, false, false, false, false, false, false, 0, 0, false, string.Empty, false, string.Empty);
		}

		/// <summary>
		/// Creates the sales channel
		/// </summary>
		/// <param name="ChannelName">Name of the channel.</param>
		/// <param name="ChannelDescription">The channel description.</param>
		/// <param name="createdBy">The created by.</param>
		/// <param name="EntityID">The entity ID.</param>
		/// <param name="ChannelDevelopmentManagerID">The channel development manager ID.</param>
		/// <param name="HasManagedUsers"><c>true</c> if Channel uses Agents.</param>
		/// <param name="Inactive"><c>true</c> if Channel is Inactive.</param>
		/// <param name="contactFirstName">CP Contact First Name</param>
		/// <param name="contactLastName">CP Contact Last Name</param>
		/// <param name="contactAddress1">CP Contact Address</param>
		/// <param name="contactAddress2">CP Contact Address</param>
		/// <param name="contactCity">Cp Contact City</param>
		/// <param name="contactState">CP Contact State</param>
		/// <param name="contactZip">CP Contact Zip</param>
		/// <param name="contactEmail">CP Contact Email</param>
		/// <param name="contactPhone">CP Contact Phone</param>
		/// <param name="contactFax">Cp Contact Fax</param>
		/// <param name="renewalGracePeriod">Period to renew customer</param>
		/// <param name="allowRetentionSave">Indicate if CP allows accounts to be saved in retention</param>
		/// <param name="alwaysTransfer">Indicates if calls from accounts for CP should be forwarded to the CP</param>
		/// <param name="allowRenewalOnDefault">Indicates if account can be renewed while on the Default product</param>
		/// <param name="allowInfoOnWelcomeLetter">Indicates if CP contact info should be included in Welcome Letter</param>
		/// <param name="allowInfoOnRenewalLetter">Indicates if CP contact info should be included in Renewal Letter</param>
		/// <param name="allowInfoOnRenewalNotice">Indicates if CP contact info should be included in Renewal Notice</param>
		/// <param name="salesStatus">Sales status of CP</param>
		/// <param name="legalStatus">Contract Status of CP</param>
		/// <returns></returns>
		public static DataSet CreateSalesChannel( string ChannelName, string ChannelDescription, int createdBy, int EntityID
			, int? ChannelDevelopmentManagerID, bool HasManagedUsers, bool isInactive, string contactFirstName, string contactLastName
			, string contactAddress1, string contactAddress2, string contactCity, string contactState, string contactZip
			, string contactEmail, string contactPhone, string contactFax, int renewalGracePeriod, bool allowRetentionSave
			, bool alwaysTransfer, bool allowRenewalOnDefault, bool allowInfoOnWelcomeLetter, bool allowInfoOnRenewalLetter
            , bool allowInfoOnRenewalNotice, int salesStatus, int legalStatus, bool DoNotTransfer, string DoNotTransferComment
            , bool Affinity, string AffinityProgram)
		
	{
			string SQL = "usp_SalesChannelInsert";
            string cnnString = Helper.ConnectionString; //ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
			DataSet ds = new DataSet();
			using( SqlDataAdapter da = new SqlDataAdapter( SQL, cnnString ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				SqlParameter p1 = new SqlParameter( "@createdBy", createdBy );
				SqlParameter p2 = new SqlParameter( "@ChannelName", ChannelName );
				SqlParameter p3 = new SqlParameter( "@EntityID", EntityID );
				SqlParameter p4 = new SqlParameter( "@ChannelDescription", (ChannelDescription != null) ? (object) ChannelDescription : DBNull.Value );
				SqlParameter p5 = new SqlParameter( "@ChannelDevelopmentManagerID", (ChannelDevelopmentManagerID == null) ? DBNull.Value : (object) ChannelDevelopmentManagerID );
				SqlParameter p6 = new SqlParameter( "@HasManagedUsers", HasManagedUsers );
				SqlParameter p7 = new SqlParameter( "@Inactive", isInactive );

				SqlParameter p8 = new SqlParameter( "@ContactFirstName", (contactFirstName != null) ? (object) contactFirstName : DBNull.Value );
				SqlParameter p9 = new SqlParameter( "@ContactLastName", (contactLastName != null) ? (object) contactLastName : DBNull.Value );
				SqlParameter p10 = new SqlParameter( "@ContactAddress1", (contactAddress1 != null) ? (object) contactAddress1 : DBNull.Value );
				SqlParameter p11 = new SqlParameter( "@ContactAddress2", (contactAddress2 != null) ? (object) contactAddress2 : DBNull.Value );
				SqlParameter p12 = new SqlParameter( "@ContactCity", (contactCity != null) ? (object) contactCity : DBNull.Value );
				SqlParameter p13 = new SqlParameter( "@ContactState", (contactState != null) ? (object) contactState : DBNull.Value );
				SqlParameter p14 = new SqlParameter( "@ContactZip", (contactZip != null) ? (object) contactZip : DBNull.Value );
				SqlParameter p15 = new SqlParameter( "@ContactEmail", (contactEmail != null) ? (object) contactEmail : DBNull.Value );
				SqlParameter p16 = new SqlParameter( "@ContactPhone", (contactPhone != null) ? (object) contactPhone : DBNull.Value );
				SqlParameter p17 = new SqlParameter( "@ContactFax", (contactFax != null) ? (object) contactFax : DBNull.Value );

				SqlParameter p18 = new SqlParameter( "@RenewalGracePeriod", renewalGracePeriod );
				SqlParameter p19 = new SqlParameter( "@AllowRetentionSave", allowRetentionSave );
				SqlParameter p20 = new SqlParameter( "@AlwaysTransfer", alwaysTransfer );
				SqlParameter p21 = new SqlParameter( "@AllowRenewalOnDefault", allowRenewalOnDefault );

				SqlParameter p22 = new SqlParameter( "@AllowInfoOnWelcomeLetter", allowInfoOnWelcomeLetter );
				SqlParameter p23 = new SqlParameter( "@AllowInfoOnRenewalLetter", allowInfoOnRenewalLetter );
				SqlParameter p24 = new SqlParameter( "@AllowInfoOnRenewalNotice", allowInfoOnRenewalNotice );
				SqlParameter p25 = new SqlParameter( "@SalesStatus", salesStatus );
                SqlParameter p26 = new SqlParameter("@LegalStatus", legalStatus);
                SqlParameter p27 = new SqlParameter("@DoNotTransfer", DoNotTransfer);
                SqlParameter p28 = new SqlParameter("@DoNotTransferComment", DoNotTransferComment);
                SqlParameter p29 = new SqlParameter("@Affinity", Affinity);
                SqlParameter p30 = new SqlParameter("@AffinityProgram", AffinityProgram);

				da.SelectCommand.Parameters.Add( p1 );
				da.SelectCommand.Parameters.Add( p2 );
				da.SelectCommand.Parameters.Add( p3 );
				da.SelectCommand.Parameters.Add( p4 );
				da.SelectCommand.Parameters.Add( p5 );
				da.SelectCommand.Parameters.Add( p6 );
				da.SelectCommand.Parameters.Add( p7 );

				da.SelectCommand.Parameters.Add( p8 );
				da.SelectCommand.Parameters.Add( p9 );
				da.SelectCommand.Parameters.Add( p10 );
				da.SelectCommand.Parameters.Add( p11 );
				da.SelectCommand.Parameters.Add( p12 );
				da.SelectCommand.Parameters.Add( p13 );
				da.SelectCommand.Parameters.Add( p14 );
				da.SelectCommand.Parameters.Add( p15 );
				da.SelectCommand.Parameters.Add( p16 );

				da.SelectCommand.Parameters.Add( p17 );
				da.SelectCommand.Parameters.Add( p18 );
				da.SelectCommand.Parameters.Add( p19 );
				da.SelectCommand.Parameters.Add( p20 );
				da.SelectCommand.Parameters.Add( p21 );
				da.SelectCommand.Parameters.Add( p22 );
				da.SelectCommand.Parameters.Add( p23 );
				da.SelectCommand.Parameters.Add( p24 );
				da.SelectCommand.Parameters.Add( p25 );
                da.SelectCommand.Parameters.Add(p26);
                da.SelectCommand.Parameters.Add(p27);
                da.SelectCommand.Parameters.Add(p28);
                da.SelectCommand.Parameters.Add(p29);
                da.SelectCommand.Parameters.Add(p30);

				da.Fill( ds );
			}

			return ds;
		}

		
		/// <summary>
		/// Updates the sales channel.
		/// </summary>
		/// <param name="ChannelID">The channel ID.</param>
		/// <param name="ChannelName">Name of the channel.</param>
		/// <param name="ChannelDescription">The channel description.</param>
		/// <param name="ModifiedBY">The modified BY.</param>
		/// <param name="ActiveDirectoryLoginID">The active directory login ID.</param>
		/// <param name="ChannelDevelopmentManagerID">The channel development manager ID.</param>
		/// <param name="ChannelGroupId">The channel group id.</param>
		/// <returns></returns>
		public static DataSet UpdateSalesChannel( int ChannelID, string ChannelName, string ChannelDescription, int ModifiedBY, string ActiveDirectoryLoginID, int? ChannelDevelopmentManagerID, int ChannelGroupId )
		{
			return UpdateSalesChannel( ChannelID, ChannelName, ChannelDescription, ModifiedBY, ChannelDevelopmentManagerID, false, true );
		}


		/// <summary>
		/// Updates the sales channel.
		/// </summary>
		/// <param name="ChannelID">The channel ID.</param>
		/// <param name="ChannelName">Name of the channel.</param>
		/// <param name="ChannelDescription">The channel description.</param>
		/// <param name="ModifiedBY">The modified BY.</param>
		/// <param name="ChannelDevelopmentManagerID">The channel development manager ID.</param>
		/// <param name="ChannelGroupId">The channel group id.</param>
		/// <param name="HasManagedUsers"><c>true</c> if Channel uses Agents.</param>
		/// <param name="isInactive">if set to <c>true</c> [is inactive].</param>
		/// <returns></returns>
		[Obsolete( "ChannelGroupId is no longer used by this function. Use the alternate overload method." )]
		public static DataSet UpdateSalesChannel( int ChannelID, string ChannelName, string ChannelDescription, int ModifiedBY, int? ChannelDevelopmentManagerID, int ChannelGroupId, bool HasManagedUsers, bool isInactive )
		{
			return UpdateSalesChannel( ChannelID, ChannelName, ChannelDescription, ModifiedBY, ChannelDevelopmentManagerID, HasManagedUsers, isInactive );
		}

		/// <summary>
		/// Updates the sales channel.
		/// </summary>
		/// <param name="ChannelID">The channel ID.</param>
		/// <param name="ChannelName">Name of the channel.</param>
		/// <param name="ChannelDescription">The channel description.</param>
		/// <param name="ModifiedBY">The modified BY.</param>
		/// <param name="ChannelDevelopmentManagerID">The channel development manager ID.</param>
		/// <param name="HasManagedUsers">if set to <c>true</c> [has managed users].</param>
		/// <param name="isInactive">if set to <c>true</c> [is inactive].</param>
		/// <returns></returns>
		public static DataSet UpdateSalesChannel( int ChannelID, string ChannelName, string ChannelDescription, int ModifiedBY, int? ChannelDevelopmentManagerID, bool HasManagedUsers, bool isInactive )
		{
            return UpdateSalesChannel(ChannelID, ChannelName, ChannelDescription, ModifiedBY, ChannelDevelopmentManagerID, HasManagedUsers, isInactive, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, 0, false, false, false, false, false, false, 0, 0, false, string.Empty, false, string.Empty);
		}

		/// <summary>
		/// Updates the sales channel.
		/// </summary>
		/// <param name="ChannelID">The channel ID.</param>
		/// <param name="ChannelName">Name of the channel.</param>
		/// <param name="ChannelDescription">The channel description.</param>
		/// <param name="ModifiedBY">The modified BY.</param>
		/// <param name="ChannelDevelopmentManagerID">The channel development manager ID.</param>
		/// <param name="HasManagedUsers">if set to <c>true</c> [has managed users].</param>
		/// <param name="isInactive">if set to <c>true</c> [is inactive].</param>
		/// <param name="contactFirstName">CP Contact First Name</param>
		/// <param name="contactLastName">CP Contact Last Name</param>
		/// <param name="contactAddress1">CP Contact Address</param>
		/// <param name="contactAddress2">CP Contact Address</param>
		/// <param name="contactCity">Cp Contact City</param>
		/// <param name="contactState">CP Contact State</param>
		/// <param name="contactZip">CP Contact Zip</param>
		/// <param name="contactEmail">CP Contact Email</param>
		/// <param name="contactPhone">CP Contact Phone</param>
		/// <param name="contactFax">CP Contact Fax</param>
		/// <param name="renewalGracePeriod">Period to renew customer</param>
		/// <param name="allowRetentionSave">Indicate if CP allows accounts to be saved in retention</param>
		/// <param name="alwaysTransfer">Indicates if calls from accounts for CP should be forwarded to the CP</param>
		/// <param name="allowRenewalOnDefault">Indicates if account can be renewed while on the Default product</param>
		/// <param name="allowInfoOnWelcomeLetter">Indicates if CP contact info should be included in Welcome Letter</param>
		/// <param name="allowInfoOnRenewalLetter">Indicates if CP contact info should be included in Renewal Letter</param>
		/// <param name="allowInfoOnRenewalNotice">Indicates if CP contact info should be included in Renewal Notice</param>
		/// <param name="salesStatus">Sales status of CP</param>
		/// <param name="legalStatus">Contract Status of CP</param>
		/// <returns></returns>
		public static DataSet UpdateSalesChannel( int ChannelID, string ChannelName, string ChannelDescription, int ModifiedBY, int? ChannelDevelopmentManagerID, bool HasManagedUsers, bool isInactive
            , string contactFirstName, string contactLastName, string contactAddress1, string contactAddress2, string contactCity, string contactState, string contactZip, string contactEmail, string contactPhone, string contactFax
            , int renewalGracePeriod, bool allowRetentionSave, bool alwaysTransfer, bool allowRenewalOnDefault, bool allowInfoOnWelcomeLetter, bool allowInfoOnRenewalLetter, bool allowInfoOnRenewalNotice
            , int salesStatus, int legalStatus, bool DoNotTransfer, string DoNotTransferComment, bool Affinity, string AffinityProgram )
		{

			string SQL = "usp_SalesChannelUpdate";
            string cnnString = Helper.ConnectionString; // ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
			DataSet ds = new DataSet();
			using( SqlDataAdapter da = new SqlDataAdapter( SQL, cnnString ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				SqlParameter p1 = new SqlParameter( "@ChannelID", ChannelID );
				SqlParameter p2 = new SqlParameter( "@ChannelName", ChannelName );
				SqlParameter p3 = new SqlParameter( "@ModifiedBY", ModifiedBY );
				SqlParameter p4 = new SqlParameter( "@ChannelDevelopmentManagerID", (ChannelDevelopmentManagerID != null) ? (object) ChannelDevelopmentManagerID : DBNull.Value );
				SqlParameter p5 = new SqlParameter( "@ChannelDescription", (ChannelDescription != null) ? (object) ChannelDescription : DBNull.Value );
				SqlParameter p6 = new SqlParameter( "@HasManagedUsers", HasManagedUsers );
				SqlParameter p7 = new SqlParameter( "@Inactive", isInactive );

				SqlParameter p8 = new SqlParameter( "@ContactFirstName", (contactFirstName != null) ? (object) contactFirstName : DBNull.Value );
				SqlParameter p9 = new SqlParameter( "@ContactLastName", (contactLastName != null) ? (object) contactLastName : DBNull.Value );
				SqlParameter p10 = new SqlParameter( "@ContactAddress1", (contactAddress1 != null) ? (object) contactAddress1 : DBNull.Value );
				SqlParameter p11 = new SqlParameter( "@ContactAddress2", (contactAddress2 != null) ? (object) contactAddress2 : DBNull.Value );
				SqlParameter p12 = new SqlParameter( "@ContactCity", (contactCity != null) ? (object) contactCity : DBNull.Value );
				SqlParameter p13 = new SqlParameter( "@ContactState", (contactState != null) ? (object) contactState : DBNull.Value );
				SqlParameter p14 = new SqlParameter( "@ContactZip", (contactZip != null) ? (object) contactZip : DBNull.Value );
				SqlParameter p15 = new SqlParameter( "@ContactEmail", (contactEmail != null) ? (object) contactEmail : DBNull.Value );
				SqlParameter p16 = new SqlParameter( "@ContactPhone", (contactPhone != null) ? (object) contactPhone : DBNull.Value );
				SqlParameter p17 = new SqlParameter( "@ContactFax", (contactFax != null) ? (object) contactFax : DBNull.Value );

				SqlParameter p18 = new SqlParameter( "@RenewalGracePeriod", renewalGracePeriod );
				SqlParameter p19 = new SqlParameter( "@AllowRetentionSave", allowRetentionSave );
				SqlParameter p20 = new SqlParameter( "@AlwaysTransfer", alwaysTransfer );
				SqlParameter p21 = new SqlParameter( "@AllowRenewalOnDefault", allowRenewalOnDefault );
				SqlParameter p22 = new SqlParameter( "@AllowInfoOnWelcomeLetter", allowInfoOnWelcomeLetter );
				SqlParameter p23 = new SqlParameter( "@AllowInfoOnRenewalLetter", allowInfoOnRenewalLetter );
				SqlParameter p24 = new SqlParameter( "@AllowInfoOnRenewalNotice", allowInfoOnRenewalNotice );
				SqlParameter p25 = new SqlParameter( "@SalesStatus", salesStatus );
                SqlParameter p26 = new SqlParameter( "@LegalStatus", legalStatus);
                SqlParameter p27 = new SqlParameter("@DoNotTransfer", DoNotTransfer);
                SqlParameter p28 = new SqlParameter("@DoNotTransferComment", DoNotTransferComment);
                SqlParameter p29 = new SqlParameter("@Affinity", Affinity);
                SqlParameter p30 = new SqlParameter("@AffinityProgram", AffinityProgram);

				da.SelectCommand.Parameters.Add( p1 );
				da.SelectCommand.Parameters.Add( p2 );
				da.SelectCommand.Parameters.Add( p3 );
				da.SelectCommand.Parameters.Add( p4 );
				da.SelectCommand.Parameters.Add( p5 );
				da.SelectCommand.Parameters.Add( p6 );
				da.SelectCommand.Parameters.Add( p7 );

				da.SelectCommand.Parameters.Add( p8 );
				da.SelectCommand.Parameters.Add( p9 );
				da.SelectCommand.Parameters.Add( p10 );
				da.SelectCommand.Parameters.Add( p11 );
				da.SelectCommand.Parameters.Add( p12 );
				da.SelectCommand.Parameters.Add( p13 );
				da.SelectCommand.Parameters.Add( p14 );
				da.SelectCommand.Parameters.Add( p15 );
				da.SelectCommand.Parameters.Add( p16 );

				da.SelectCommand.Parameters.Add( p17 );
				da.SelectCommand.Parameters.Add( p18 );
				da.SelectCommand.Parameters.Add( p19 );
				da.SelectCommand.Parameters.Add( p20 );
				da.SelectCommand.Parameters.Add( p21 );
				da.SelectCommand.Parameters.Add( p22 );
				da.SelectCommand.Parameters.Add( p23 );
				da.SelectCommand.Parameters.Add( p24 );
				da.SelectCommand.Parameters.Add( p25 );
                da.SelectCommand.Parameters.Add(p26);
                da.SelectCommand.Parameters.Add(p27);
                da.SelectCommand.Parameters.Add(p28);
                da.SelectCommand.Parameters.Add(p29);
                da.SelectCommand.Parameters.Add(p30);
				da.Fill( ds );
			}

			return ds;
		}

		/// <summary>
		/// Gets the sales channel.
		/// </summary>
		/// <param name="ChannelID">The channel ID.</param>
		/// <returns></returns>
		public static DataSet GetSalesChannel( int ChannelID )
		{

			string SQL = "usp_SalesChannelGet";
		    string cnnString = Helper.ConnectionString; // ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
			DataSet ds = new DataSet();
			using( SqlDataAdapter da = new SqlDataAdapter( SQL, cnnString ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				SqlParameter p1 = new SqlParameter( "@ChannelID", ChannelID );
				da.SelectCommand.Parameters.Add( p1 );
				da.Fill( ds );
			}

			return ds;
		}

		/// <summary>
        /// Gets the sales channel agent list.
        /// </summary>
        /// <param name="ChannelID">The channel ID.</param>
        /// <returns></returns>
        public static DataSet GetSalesChannelAgentList(int ChannelID)
        {

            string SQL = "usp_SalesChannelUserListByChannelID";
            string cnnString = Helper.ConnectionString; // ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
            DataSet ds = new DataSet();
            using (SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString))
            {
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                SqlParameter p1 = new SqlParameter("@ChannelID", ChannelID);
                da.SelectCommand.Parameters.Add(p1);
                da.Fill(ds);
            }

            return ds;
        }

		/// <summary>
		/// Gets the sales channel.
		/// </summary>
		/// <param name="ChannelName">Name of the channel.</param>
		/// <returns></returns>
		public static DataSet GetSalesChannel( string ChannelName )
		{
			string SQL = "usp_SalesChannelGetByName";
		    string cnnString = Helper.ConnectionString; //ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
			DataSet ds = new DataSet();
			using( SqlDataAdapter da = new SqlDataAdapter( SQL, cnnString ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				SqlParameter p1 = new SqlParameter( "@ChannelName", ChannelName );
				da.SelectCommand.Parameters.Add( p1 );
				da.Fill( ds );
			}
			return ds;
		}

		/// <summary>
		/// Gets the sales channels.
		/// </summary>
		/// <returns></returns>
		public static DataSet GetSalesChannels()
		{

			string SQL = "usp_SalesChannelGetAll";
		    string cnnString = Helper.ConnectionString; //ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
			DataSet ds = new DataSet();
			using( SqlDataAdapter da = new SqlDataAdapter( SQL, cnnString ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				da.Fill( ds );
			}

			return ds;
		}

        public static DataSet GetSalesChannelsWithAuthorizedMarkets()
        {
            string SQL = "usp_SalesChannelNameWithMarketsSelect";
            string cnnString = Helper.ConnectionString; //ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
            DataSet ds = new DataSet();
            using (SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString))
            {
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                da.Fill(ds);
            }

            return ds;
        }

		/// <summary>
		/// Gets all active sales channels
		/// </summary>
		/// <returns>Returns a dataset containing all active sales channels.</returns>
		public static DataSet GetActiveSalesChannels()
		{
			return GetActiveSalesChannels( null );
		}

		/// <summary>
		/// Gets all active sales channels
		/// </summary>
		/// <param name="channelGroupDate">The channel group date.</param>
		/// <returns>
		/// Returns a dataset containing all active sales channels.
		/// </returns>
		public static DataSet GetActiveSalesChannels(DateTime? channelGroupDate)
		{
			string SQL = "usp_SalesChannelsActiveSelect";
            string cnnString = Helper.ConnectionString; //ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
			DataSet ds = new DataSet();
			using( SqlDataAdapter da = new SqlDataAdapter( SQL, cnnString ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;

				da.SelectCommand.Parameters.Add( new SqlParameter( "@GroupDate", (object) channelGroupDate ?? (object) DBNull.Value ) );
				
				da.Fill( ds );
			}

			return ds;
			}

        /// <summary>
        /// Gets all active sales channels
        /// </summary>
      
        /// <returns>
        /// Returns a dataset containing tablet sales channels.
        /// </returns>
        public static DataSet GetTabletSalesChannels()
        {
            string SQL = "usp_GetTabletSalesChannels";
            string cnnString = Helper.ConnectionString; 
            DataSet ds = new DataSet();
            using (SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString))
            {
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                da.Fill(ds);
            }

            return ds;
        }      
		/// <summary>
		/// Gets active sales channels for given account type.
		/// </summary>
		/// <param name="accountTypeID">Account type record identifier</param>
		/// <returns>Returns a dataset conatining active sales channels for given account type.</returns>
		public static DataSet GetActiveSalesChannelsByAccountType( int accountTypeID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_SalesChannelsActiveByAccountTypeSelect";

					cmd.Parameters.Add( new SqlParameter( "@AccountTypeID", accountTypeID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets the liberty power sales channel.
		/// </summary>
		/// <returns></returns>
		public static DataSet GetLibertyPowerSalesChannel()
		{

			string SQL = "usp_SalesChannelGetLibertyPower";
            string cnnString = Helper.ConnectionString; //ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
			DataSet ds = new DataSet();
			using( SqlDataAdapter da = new SqlDataAdapter( SQL, cnnString ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				da.Fill( ds );
			}

			return ds;
		}

		/// <summary>
		/// Gets the pricing sheet distribution list.
		/// </summary>
		/// <param name="salesChannel">The sales channel.</param>
		/// <returns></returns>
		public static DataSet GetPricingSheetDistributionList( int salesChannel )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingDistributionByChannelID";

					cmd.Parameters.Add( new SqlParameter( "@ChannelID", salesChannel ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Deletes the pricing sheet distribution list.
		/// </summary>
		/// <param name="salesChannel">The sales channel.</param>
		/// <returns></returns>
		public static DataSet DeletePricingSheetDistributionList( int salesChannel )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingDistributionDeleteByChannelID";

					cmd.Parameters.Add( new SqlParameter( "@ChannelID", salesChannel ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets the pricing sheet distribution list insert.
		/// </summary>
		/// <param name="salesChannel">The sales channel.</param>
		/// <param name="email">The email.</param>
		/// <param name="createdById">The created by id.</param>
		/// <returns></returns>
		public static DataSet InsertPricingSheetDistributionList( int salesChannel, string email, int createdById )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingDistributionInsert";

					cmd.Parameters.Add( new SqlParameter( "@ChannelID", salesChannel ) );
					cmd.Parameters.Add( new SqlParameter( "@Email", email ) );
					cmd.Parameters.Add( new SqlParameter( "@CreatedBy", createdById ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Inserts the daily pricing file type sales channel.
		/// </summary>
		/// <param name="fileTypeId">The file type id.</param>
		/// <param name="salesChannel">The sales channel.</param>
		/// <param name="createdById">The created by id.</param>
		/// <returns></returns>
		public static DataSet InsertDailyPricingFileTypeSalesChannel( int fileTypeId, int salesChannelId, int createdById )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingFileTypeSalesChannelInsert";

					cmd.Parameters.Add( new SqlParameter( "@ChannelID", salesChannelId ) );
					cmd.Parameters.Add( new SqlParameter( "@DailyPricingFileTypeID", fileTypeId ) );
					cmd.Parameters.Add( new SqlParameter( "@CreatedBy", createdById ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}


		/// <summary>
		/// Gets the daily pricing file type by sales channel.
		/// </summary>
		/// <param name="salesChannelId">The sales channel id.</param>
		/// <returns></returns>
		public static DataSet GetDailyPricingFileTypeBySalesChannel( int salesChannelId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingFileTypeGetByChannelID";

					cmd.Parameters.Add( new SqlParameter( "@ChannelID", salesChannelId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Deletes the daily pricing file type by sales channel.
		/// </summary>
		/// <param name="salesChannelId">The sales channel id.</param>
		/// <returns></returns>
		public static DataSet DeleteDailyPricingFileTypeBySalesChannel( int salesChannelId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingFileTypeDeleteByChannelID";

					cmd.Parameters.Add( new SqlParameter( "@ChannelID", salesChannelId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}


		/// <summary>
		/// Gets the type of the daily pricing file.
		/// </summary>
		/// <returns></returns>
		public static DataSet GetDailyPricingFileType()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_DailyPricingFileTypeGetAll";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets the channel group settings.
		/// </summary>
		/// <param name="channelId">The channel id.</param>
		/// <returns></returns>
		public static DataSet GetChannelGroupSettings( int channelId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_SalesChannelChannelGroupGetByChannelID";

					cmd.Parameters.Add( new SqlParameter( "@ChannelID", channelId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets the channel group settings for a specific date.
		/// </summary>
		/// <param name="channelId">The channel id.</param>
		/// <param name="pricingDate">The pricing date.</param>
		/// <returns></returns>
		public static DataSet GetChannelGroupSettings( int channelId, DateTime pricingDate )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_SalesChannelChannelGroupGetCurrentByChannelID";

					cmd.Parameters.Add( new SqlParameter( "@ChannelID", channelId ) );
					cmd.Parameters.Add( new SqlParameter( "@PricingDate", pricingDate ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Inserts the sales channel channel group.
		/// </summary>
		/// <param name="channelId">The channel id.</param>
		/// <param name="channelGroupId">The channel group id.</param>
		/// <param name="effectiveDate">The effective date.</param>
		/// <param name="expirationDate">The expiration date.</param>
		/// <param name="userId">The user id.</param>
		public static void InsertSalesChannelChannelGroup( int channelId, int channelGroupId, DateTime effectiveDate, DateTime? expirationDate, int userId )
		{
			int recordsAffected;

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_SalesChannelChannelGroupInsert";

					cmd.Parameters.Add( new SqlParameter( "@ChannelID", channelId ) );
					cmd.Parameters.Add( new SqlParameter( "@ChannelGroupID", channelGroupId ) );
					cmd.Parameters.Add( new SqlParameter( "@EffectiveDate", effectiveDate ) );
					cmd.Parameters.Add( new SqlParameter( "@ExpirationDate", (object) expirationDate ?? (object) DBNull.Value ) );
					cmd.Parameters.Add( new SqlParameter( "@UserID", userId ) );

					cn.Open();
					recordsAffected = cmd.ExecuteNonQuery();
				}
			}
		}

		/// <summary>
		/// Deletes the sales channel channel group.
		/// </summary>
		/// <param name="salesChannelChannelGroupID">The sales channel channel group ID.</param>
		/// <param name="channelId">The channel id.</param>
		public static void DeleteSalesChannelChannelGroup( int salesChannelChannelGroupID, int channelId )
		{
			int recordsAffected;

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_SalesChannelChannelGroupDelete";

					cmd.Parameters.Add( new SqlParameter( "@SalesChannelChannelGroupID", salesChannelChannelGroupID ) );
					cmd.Parameters.Add( new SqlParameter( "@ChannelID", channelId ) );

					cn.Open();
					recordsAffected = cmd.ExecuteNonQuery();
				}
			}
		}

        /// <summary>
        /// Gets the sales channel by manager.
        /// </summary>
        /// <param name="managerUserId">The user ID of the manager.</param>
        /// <returns></returns>
        public static DataSet GetSalesChannelsByManagerUserId( int managerUserId )
        {
            DataSet ds = new DataSet();
            using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_SalesChannelGetbyManagerUserId";
                    cmd.Parameters.Add( new SqlParameter( "@ManagerUserId", managerUserId ) );
                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                        da.Fill( ds );
                }
            }
            return ds;
        }

        /// <summary>
        /// Gets the Legal Statuses.
        /// </summary>
        /// <returns></returns>
        public static DataSet GetLegalStatuses()
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_LegalStatusSelectAll";

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
                }
            }
            return ds;
        }

        /// <summary>
        /// Gets the sales statuses.
        /// </summary>
        /// <returns></returns>
        public static DataSet GetSalesStatuses()
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_SalesStatusSelectAll";
					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Inserts pricing options for specified sales channel ID.
		/// </summary>
		/// <param name="channelID">Sales channel record identifier</param>
		/// <param name="enableTieredPricing">Flag indicating if tiered pricing is enabled</param>
		/// <param name="quoteTolerance">Quote tolerance</param>
		/// <returns>Returns a dataset containing pricing options for specified sales channel ID including record identifier.</returns>
		public static DataSet InsertPricingOptions( int channelID, int enableTieredPricing, decimal quoteTolerance )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_SalesChannelPricingOptionsInsert";

					cmd.Parameters.Add( new SqlParameter( "@ChannelID", channelID ) );
					cmd.Parameters.Add( new SqlParameter( "@EnableTieredPricing", enableTieredPricing ) );
					cmd.Parameters.Add( new SqlParameter( "@QuoteTolerance", quoteTolerance ) );

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
                }
            }
            return ds;
		}

		/// <summary>
		/// Updates pricing options for specified channel ID.
		/// </summary>
		/// <param name="channelID">Sales channel record identifier</param>
		/// <param name="enableTieredPricing">Flag indicating if tiered pricing is enabled</param>
		/// <param name="quoteTolerance">Quote tolerance</param>
		public static void UpdatePricingOptions( int channelID, int enableTieredPricing, decimal quoteTolerance )
		{
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_SalesChannelPricingOptionsUpdate";

					cmd.Parameters.Add( new SqlParameter( "@ChannelID", channelID ) );
					cmd.Parameters.Add( new SqlParameter( "@EnableTieredPricing", enableTieredPricing ) );
					cmd.Parameters.Add( new SqlParameter( "@QuoteTolerance", quoteTolerance ) );

					cn.Open();
					cmd.ExecuteNonQuery();
				}
			}
        }             

        /// <summary>
        /// Gets a sales channel by the provided device ID
        /// </summary>
        /// <param name="deviceID">A string device id</param>
        /// <returns>Dataset containing the SalesChannel data</returns>
        public static DataSet GetSalesChannelByDeviceID( string deviceID )
        {

            //string SQL = "usp_SalesChannelGet";
            string SQL = "usp_SalesChannelGetByDeviceID";
            string cnnString = Helper.ConnectionString; // ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
            DataSet ds = new DataSet();
            using (SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString))
            {
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                SqlParameter p1 = new SqlParameter("@DeviceID", deviceID);
                
                da.SelectCommand.Parameters.Add(p1);
                
                da.Fill(ds);
            }

            return ds;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="channelID"></param>
        /// <returns></returns>
        public static DataSet GetSalesChannelMarkets(int channelID)
        {
            DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = conn.CreateCommand())
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_SalesChannelsSelectedMarketsSelect";
                    cmd.Parameters.Add(new SqlParameter("@ChannelID", channelID));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        if (conn.State != ConnectionState.Open)
                        {
                            conn.Open();
                        }

                        da.Fill(ds);
                    }
                }
            }

            return ds;
        }

        public static DataSet GetSalesChannelProducts(int channelID)
        {
            DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = conn.CreateCommand())
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_SalesChannelSelectedProductsSelect";
                    cmd.Parameters.Add(new SqlParameter("@ChannelID", channelID));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        if (conn.State != ConnectionState.Open)
                        {
                            conn.Open();
                        }

                        da.Fill(ds);
                    }
                }
            }

            return ds;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="p1"></param>
        /// <param name="p2"></param>
        /// <param name="p3"></param>
        /// <param name="p4"></param>
        //public static void UpdateProductConfig(int channelID, int marketID, int productBrandID, bool isSelected)
        //{
        //    try
        //    {
        //        using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
        //        {
        //            using (SqlCommand cmd = conn.CreateCommand())
        //            {
        //                cmd.CommandType = CommandType.StoredProcedure;
        //                cmd.CommandText = "usp_SalesChannelSelectedProductUpdate";
        //                cmd.Parameters.Add(new SqlParameter("@ChannelID", channelID));
        //                cmd.Parameters.Add(new SqlParameter("@MarketID", marketID));
        //                cmd.Parameters.Add(new SqlParameter("@ProductBrandID", productBrandID));
        //                cmd.Parameters.Add(new SqlParameter("@IsSelected", isSelected));

        //                if (conn.State != ConnectionState.Open)
        //                {
        //                    conn.Open();
        //                }

        //                cmd.ExecuteNonQuery();
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {

        //        throw new ApplicationException(ex.Message, ex);
        //    }
        //}




        /// <summary>
        /// Deletes a product brand config item from the database for the selected channel
        /// </summary>
        /// <param name="channelID"></param>
        /// <param name="marketID"></param>
        /// <param name="productBrandID"></param>
        public static void DeleteSelectedProduct(int channelID, int marketID, int productBrandID)
        {
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = conn.CreateCommand())
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_SalesChannelSelectedProductDelete";
                    cmd.Parameters.Add(new SqlParameter("@ChannelID", channelID));
                    cmd.Parameters.Add(new SqlParameter("@MarketID", marketID));
                    cmd.Parameters.Add(new SqlParameter("@ProductBrandID", productBrandID));

                    if (conn.State != ConnectionState.Open)
                    {
                        conn.Open();
                    }

                    cmd.ExecuteNonQuery();
                }
            }
        }

        /// <summary>
        /// Inserts a product brand config item into the database for the selected channel
        /// </summary>
        /// <param name="channelID"></param>
        /// <param name="marketID"></param>
        /// <param name="productBrandID"></param>
        public static void InsertSelectedProduct(int channelID, int marketID, int productBrandID, int createdBy, DateTime createdDate)
        {
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = conn.CreateCommand())
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_SalesChannelSelectedProductInsert";
                    cmd.Parameters.Add(new SqlParameter("@ChannelID", channelID));
                    cmd.Parameters.Add(new SqlParameter("@MarketID", marketID));
                    cmd.Parameters.Add(new SqlParameter("@ProductBrandID", productBrandID));
					cmd.Parameters.Add( new SqlParameter( "@CreatedBy", createdBy ) );
					cmd.Parameters.Add( new SqlParameter( "@CreatedDate", createdDate ) );


                    if (conn.State != ConnectionState.Open)
                    {
                        conn.Open();
                    }

                    cmd.ExecuteNonQuery();
                }
            }
        }
	}//End of class
}
