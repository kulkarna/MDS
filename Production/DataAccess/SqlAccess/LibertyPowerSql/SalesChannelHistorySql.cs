using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
	public static class SalesChannelHistorySql
	{

		/// <summary>
		/// Creates the salesChannelHistory record.
		/// </summary>
		/// <param name="ChannelID">The channel ID.</param>
		/// <param name="ChannelName">Name of the channel.</param>
		/// <param name="ChannelDescription">The channel description.</param>
		/// <param name="ModifiedBy">The modified by.</param>
		/// <param name="EntityID">The entity ID.</param>
		/// <param name="ChannelDevelopmentManagerID">The channel development manager ID.</param>
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
		public static DataSet CreateSalesChannelHistory(int ChannelID, string ChannelName, string ChannelDescription, int ModifiedBy, int EntityID,
											int? ChannelDevelopmentManagerID, bool isInactive, string contactFirstName, string contactLastName
			, string contactAddress1, string contactAddress2, string contactCity, string contactState, string contactZip
			, string contactEmail, string contactPhone, string contactFax, int renewalGracePeriod, bool allowRetentionSave
			, bool alwaysTransfer, bool allowRenewalOnDefault, bool allowInfoOnWelcomeLetter, bool allowInfoOnRenewalLetter
			, bool allowInfoOnRenewalNotice, int salesStatus, int legalStatus )
		{
			string SQL = "usp_SalesChannelHistoryInsert";
			string cnnString = ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
			DataSet ds = new DataSet();
			using (SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString))
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				SqlParameter p1 = new SqlParameter("@ModifiedBy", ModifiedBy);
				SqlParameter p2 = new SqlParameter("@ChannelID", ChannelID);
				SqlParameter p3 = new SqlParameter("@ChannelName", ChannelName);
				SqlParameter p4 = new SqlParameter("@EntityID", EntityID);
				SqlParameter p5 = new SqlParameter("@ChannelDevelopmentManagerID", (ChannelDevelopmentManagerID != null) ? (object)ChannelDevelopmentManagerID : DBNull.Value);
				SqlParameter p6 = new SqlParameter("@ChannelDescription", ChannelDescription);
				SqlParameter p7 = new SqlParameter("@Inactive", isInactive);


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
				SqlParameter p26 = new SqlParameter( "@LegalStatus", legalStatus );

				da.SelectCommand.Parameters.Add(p1);
				da.SelectCommand.Parameters.Add(p2);
				da.SelectCommand.Parameters.Add(p3);
				da.SelectCommand.Parameters.Add(p4);
				da.SelectCommand.Parameters.Add(p5);
				da.SelectCommand.Parameters.Add(p6);
				da.SelectCommand.Parameters.Add(p7);

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
				da.SelectCommand.Parameters.Add( p26 );

				da.Fill(ds);
			}
			return ds;
		}

		/// <summary>
		/// Gets the Sales Channel History records
		/// </summary>
		/// <param name="ChannelID">The channel ID.</param>
		/// <returns></returns>
		public static DataSet GetSalesChannelHistory(int ChannelID)
		{
			string SQL = "usp_SalesChannelHistoryGet";
			string cnnString = ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
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
	}
}
