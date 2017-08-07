using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using LibertyPower.Business.CommonBusiness.CommonEntity;
using LibertyPower.Business.CustomerManagement.CRMBusinessObjects;
using LibertyPower.Business.MarketManagement.UtilityManagement;
using MType = LibertyPower.Business.CommonBusiness.CommonEntity.MeterType;

namespace LibertyPower.Business.MarketManagement.AccountInfoConsolidation
{
	public class AccountData
	{
		#region Properties

		/// <summary>
		/// Account number we want to synchronize its data
		/// </summary>
		public string AccountNumber { get; set; }

		/// <summary>
		/// Utility code of the account
		/// </summary>
		public string UtilityCode { get; set; }

		/// <summary>
		/// Zone of the account
		/// </summary>
		protected string Zone { get; set; }

		/// <summary>
		/// Profile of the account
		/// </summary>
		internal string Profile { get; set; }

		/// <summary>
		/// Stratum of the account
		/// </summary>
		protected string Stratum { get; set; }

		/// <summary>
		/// Service class of the account
		/// </summary>
		protected string ServiceClass { get; set; }

		/// <summary>
		/// Billing cycle ID of the account
		/// </summary>
		protected string BillingCycle { get; set; }

		protected string Icap { get; set; }

		protected string Tcap { get; set; }

		protected MType.EMeterType? MeterType { get; set; }

		private List<string> _ercotUtilities = new List<string> { "AEPCE", "AEPNO", "CTPEN", "TXNMP", "ONCOR", "TXU-SESCO", "ONCOR-SESCO", "SHARYLAND", "TXU" };
		private List<string> _noProfileUtilities = new List<string> { "CONED" };
		/// <summary>
		/// Message: error or sucess message
		/// </summary>
		public string Message { get; set; }

		private AccountDataSource.ESource Source { get; set; }

		#endregion Properties

		#region Constructor

		public AccountData( string accountNumber, string utilityCode, AccountDataSource.ESource source )
		{
			AccountNumber = accountNumber;
			UtilityCode = utilityCode;
			Source = source;
		}

		public AccountData( string accountNumber, string utilityCode )
		{
			AccountNumber = accountNumber;
			UtilityCode = utilityCode;
			AccountDataSource.ESource eSource;
			Enum.TryParse( utilityCode, true, out eSource );
			Source = eSource;
		}

		#endregion Constructor

		#region Get the data
		/// <summary>
		/// Pass an object and get its string value
		/// </summary>
		/// <param name="sValue">object in question</param>
		/// <returns>string value (it can be null)</returns>
		protected string GetStringValue( object sValue )
		{
			if( sValue != DBNull.Value && sValue.ToString().Trim() != string.Empty )
				return sValue.ToString().Trim().ToUpper();
			return null;
		}

		protected string GetProfileValue( string profile )
		{
			if( string.IsNullOrEmpty(profile))
				return null;

			if (_noProfileUtilities.Contains(UtilityCode.ToUpper()))
			{
				return null;
			}
			/*UtilityList utilities;
			try
			{
				utilities = UtilityFactory.GetUtilitiesByWholesaleMarketId( 2 );
			}
			catch( Exception )
			{
				utilities = new UtilityList();
			}
			
			var utility = from u in utilities
						  where u.Code == UtilityCode
						  select u;
			//For Ercot Accounts, the profile should be only the first 2 sections of the whole string
			if( utility.Any() )*/
			if( _ercotUtilities.Contains( UtilityCode.ToUpper() ) )
			{
				string[] profileSections = profile.Split( '_' );
				if( profileSections.Length > 1 )
					return profileSections[0] + "_" + profileSections[1];
				return profile;
			}
			return profile;
		}

        //Ayane-2017-04-05: This method below is getting replaced by the new one more below.
        ///// <summary>
        ///// Pass an object (ICAP or TCAP values) and only return its value if it is different than -1
        ///// </summary>
        ///// <param name="cValue">object in question</param>
        //// <returns></returns>
        //protected string GetCleanCapValue(object cValue)
        //{
        //    if (cValue != DBNull.Value && cValue.ToString().Trim() != string.Empty)
        //    {
        //        double cap;
        //        double.TryParse(cValue.ToString().Trim(), out cap);
        //        return cap < 0 ? null : cap.ToString();
        //    }
        //    return null;
        //}

        /// <summary>
        /// Gets the clean value of an object (ICAP or TCAP values).
        /// </summary>
        /// 
        /// <param name="cValue">Value to convert</param>
        /// 
        /// <returns> The string value of the object. Null if the object's value is -1, null or empty</returns>
        protected string GetCleanCapValue(object cValue)
        {
            if (cValue != DBNull.Value && cValue.ToString().Trim() != string.Empty)
            {
                double cap;
                double.TryParse(cValue.ToString().Trim(), out cap);

                return cap < 0 ? null : ConvertVeryLargeNumber.ToString(cap);
            }

            return null;
        }

		protected string GetCleanBillingValue( object bValue )
		{
			if( bValue != DBNull.Value && bValue.ToString().Trim() != string.Empty )
			{
				return bValue.ToString() == "-1" ? null : bValue.ToString().Trim();
			}
			return null;
		}

		/// <summary>
		/// get the data from the appropriate source
		/// </summary>
		/// <returns>true if read was a success</returns>
		internal virtual bool GetProperties()
		{
			return false;
		}

		/// <summary>
		/// map the values to the internal object for processing
		/// </summary>
		/// <param name="zone">account zone</param>
		/// <param name="profile">account profile</param>
		/// <param name="serviceClass">account service class</param>
		/// <param name="billingCycle">account billing cycle</param>
		/// <param name="icap">account icap</param>
		/// <param name="tcap">account tcap</param>
		/// <returns></returns>
		internal virtual void AssignProperties( string zone, string profile, string serviceClass, string billingCycle, string icap, string tcap )
		{
		}

		#endregion Get the data

		#region Save
		/// <summary>
		/// save the data into the account info
		/// </summary>
		/// <returns>true if save was a success</returns>
		internal bool Save()
		{
			try
			{
				//if none of the data have a value, there is no need to update hte account object
				if( Zone == null && Profile == null && Stratum == null && ServiceClass == null && BillingCycle == null && Icap == null && Tcap == null && !MeterType.HasValue )
				{
					Message = "Synchronization for account " + AccountNumber + @"/" + UtilityCode + " has failed. None of the information has a value";
					return false;
				}

				var utility = UtilityFactory.GetUtilityByCode( UtilityCode.ToUpper() );
				var uId = utility.Identity;

				var account = AccountFactory.GetAccount( AccountNumber, uId );
				if( account == null )
				{
					Message = "Synchronization for account " + AccountNumber + @"/" + UtilityCode + " has failed because the account does not exist.";
					return false;
				}

				var isoId = -1;
				var iso = UtilityFactory.GetISOListWithID( false );
				foreach( var key in iso.Keys.Where( key => iso[key].Trim() == utility.Iso ) )
					isoId = int.Parse( key );

				var extIdU = PropertyFactory.GetExternalEntity( ExternalEntityTypeEnum.Utility, uId ).ID;
				var extIdI = PropertyFactory.GetExternalEntity( ExternalEntityTypeEnum.ISO, isoId ).ID;


				//get the liberty power internal value that represent the current zone
				if( Zone != null )
				{
					account.Zone = Zone;
					PropertyInternalRef pir = PropertyFactory.GetPropertyInternalRef( extIdI, Zone, PropertyEnum.Location, UtilityCode.ToUpper() );
					account.DeliveryLocationRefID = (pir != null) ? pir.ID : 0;
				}
				if (account.DeliveryLocationRefID == null)
					account.DeliveryLocationRefID = 0;

				if( Profile != null )
				{
					account.LoadProfile = Profile;
					//get the liberty power internal value that represent the current profile
					var pir = PropertyFactory.GetPropertyInternalRef( extIdU, Profile, PropertyEnum.Profile );
					account.LoadProfileRefID = (pir != null) ? pir.ID : 0;
				}
				if( account.LoadProfileRefID == null )
					account.LoadProfileRefID = 0;

				if( Stratum != null )
					account.StratumVariable = Stratum;

				if( account.StratumVariable == null )
					account.StratumVariable = string.Empty;

				if( ServiceClass != null )
				{
					account.ServiceRateClass = ServiceClass;
					var pir = PropertyFactory.GetPropertyInternalRef( extIdU, ServiceClass, PropertyEnum.ServiceClass );
					account.ServiceClassRefID = (pir != null) ? pir.ID : 0;
				}
				if( account.ServiceClassRefID == null )
					account.ServiceClassRefID = 0;

				if( BillingCycle != null )
					account.BillingGroup = BillingCycle;

				if( Icap != null )
					account.Icap = Icap;

				if( account.Icap == null )
					account.Icap = string.Empty;

				if( Tcap != null )
					account.Tcap = Tcap;

				if( account.Tcap == null )
					account.Tcap = string.Empty;

				if( MeterType.HasValue )
					account.MeterTypeId = (int) MeterType;

				List<GenericError> errors;
				var bSuccess = AccountFactory.UpdateAccount( account, out errors );

				if( !bSuccess )
					Message = "Synchronization for account " + AccountNumber + @"/" + UtilityCode + " has failed";
				else
					Message = "Synchronization for account " + AccountNumber + @"/" + UtilityCode + " is complete.";

				return bSuccess;
			}
			catch( Exception ex )
			{
				Message = AccountNumber + @"/" + UtilityCode + ":" + MethodBase.GetCurrentMethod().Name + "-" + ex.Message;
				return false;
			}
		}

		#endregion Save

	}

}
