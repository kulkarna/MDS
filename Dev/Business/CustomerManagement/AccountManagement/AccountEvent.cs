using System;
using System.Data;
using System.Configuration;
using System.Collections.Generic;
using System.Text;
using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	/// <summary>
	/// Event object that contains a CompanyAccount and AccountEventType objects
	/// </summary>
    public class AccountEvent
    {
		/// <summary>
		/// Constructor
		/// </summary>
		/// <param name="account">CompanyAccount object</param>
		/// <param name="eventType">AccountEventType object</param>
		public AccountEvent( CompanyAccount account, AccountEventType eventType )
		{
			this.Account = account;
			this.EventType = eventType;

			DataSet ds = AccountEventSql.SelectAccountEventEffectiveDate( Convert.ToInt32( this.EventType ) );
			if( ds.Tables[0].Rows.Count > 0 )
				this.EventEffectiveDate = ds.Tables[0].Rows[0]["EventEffectiveDateValue"].ToString();
			else // default
				this.EventEffectiveDate = "ContractDate";
		}

		public CompanyAccount Account
		{
			get;
			set;
		}

		public AccountEventType EventType
		{
			get;
			set;
		}

		public string EventEffectiveDate
		{
			get;
			set;
		}
    }
}
