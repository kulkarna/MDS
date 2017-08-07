using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Reflection;
using System.Text;
using LibertyPower.Business.CommonBusiness.CommonHelper;
using LibertyPower.DataAccess.SqlAccess.TransactionsSql;

namespace LibertyPower.Business.MarketManagement.AccountInfoConsolidation
{
	public class AccountInfo
	{
		private AccountData _ad;
		public string Message;

		#region Constructor

		public AccountInfo( string accountNumber, string utilityCode, AccountDataSource.ESource source )
		{
			if( source == AccountDataSource.ESource.Unknown )
				return;

			var ads = new AccountDataSource( accountNumber, utilityCode, source );
			_ad = ads.GetAccountDataSource(source);
		}

		public AccountInfo( string accountNumber, string utilityCode )
		{
			AccountDataSource.ESource eSource;
			Enum.TryParse( utilityCode, true, out eSource );
			if (eSource == AccountDataSource.ESource.Unknown)
				return;

			var ads = new AccountDataSource( accountNumber, utilityCode, eSource );
			_ad = ads.GetAccountDataSource( eSource );
		}

		#endregion Constructor

		#region Synchronize
		/// <summary>
		/// Get the data from the scrapers, Edi and copy it to the account table. For each account, get the latest information. then sync the account table with this info
		/// </summary>
		/// <returns></returns>
		public bool Synchronize()
		{
			if (_ad == null)
			{
				Message = "Synchronization has failed. Account/Utility was not found.";
				return false;
			}
			if (_ad.GetProperties())
			{
				bool bSuccess = _ad.Save();
				Message = _ad.Message;
				return bSuccess;
			}
			return false;
		}

		/// <summary>
		/// assign the account the properties passed. then sync the account table with this info
		/// </summary>
		/// <param name="zone">zone</param>
		/// <param name="profile">profile</param>
		/// <param name="serviceClass">service class</param>
		/// <param name="billingCycle">billing cycle</param>
		/// <param name="icap">icap</param>
		/// <param name="tcap">tcap</param>
		/// <returns>true-false</returns>
		public bool Synchronize( string zone, string profile, string serviceClass, string billingCycle, string icap, string tcap )
		{
			if( _ad == null )
			{
				Message = "Synchronization has failed. Account/Utility was not found.";
				return false;
			}
			_ad.AssignProperties( zone, profile, serviceClass, billingCycle, icap, tcap );

			bool bSuccess = _ad.Save();
			Message = _ad.Message;
			return bSuccess;
		}

		#endregion Synchronize

		#region Profile

		public string GetProfileFromScrapers()
		{
			if( _ad == null )
			{
				Message = "Account/Utility was not found.";
				return null;
			}

		    _ad.GetProperties();
		    Message = _ad.Message;
		    return _ad.Profile;

		    //if (_ad.GetProperties())
		    //    return _ad.Profile;

		    //Message = "Account/Utility was not found.";
		    //return null;	
		}

		#endregion Profile


	}
}
