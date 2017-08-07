using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;

namespace LibertyPower.DataAccess.SqlAccess.CustomerManagementEF
{
    public static class AccountDal
    {
        #region Account

        //public static Account GetAccount( int accountID )
        //{
        //    Account a = null;
        //    using( var dal = new LibertyPowerEntities() )
        //    {
        //        a = dal.Accounts.Include( "Address" ).Include( "Name" ).First( f => f.AccountID == accountID );
        //    }
        //    return a;
        //}

        //public static Account GetAccount( string accountNumber, int utilityId )
        //{
        //    Account a = CommonDal.LPGetNonTrackedEntity<Account>( w => w.AccountNumber == accountNumber && w.UtilityID.Value == utilityId );
        //    return a;
        //}

        //public static bool InsertAccount( Account account )
        //{
        //    using( LibertyPowerEntities dal = new LibertyPowerEntities() )
        //    {
        //        dal.Accounts.AddObject( account );
        //        dal.SaveChanges();
        //    }
        //    return true;
        //}

        public static bool UpdateAccount( Account account )
        {
            using( LibertyPowerEntities dal = new LibertyPowerEntities() )
            {
                dal.Accounts.Attach( account );
                dal.ObjectStateManager.ChangeObjectState( account, System.Data.EntityState.Modified );
                dal.SaveChanges();
            }
            return true;
        }

        #endregion Account

        #region Account Details

        //public static AccountDetail GetAccountDetail( int accountID )
        //{
        //    AccountDetail a = CommonDal.LPGetNonTrackedEntity<AccountDetail>( w => w.AccountID == accountID );
        //    return a;
        //}

        //public static bool InsertAccountDetail( AccountDetail accountDetail )
        //{
        //    using( LibertyPowerEntities dal = new LibertyPowerEntities() )
        //    {
        //        dal.AccountDetails.AddObject( accountDetail );
        //        dal.SaveChanges();
        //    }
        //    return true;
        //}


        #endregion Account Details

        #region Account Usage

        public static AccountUsage GetAccountUsage( int accountID, DateTime contractStartDate )
        {
            AccountUsage a = CommonDal.LPGetNonTrackedEntity<AccountUsage>( w => w.AccountID == accountID && w.EffectiveDate == contractStartDate );
            return a;
        }

        public static bool InsertAccountUsage( AccountUsage accountUsage )
        {
            using( LibertyPowerEntities dal = new LibertyPowerEntities() )
            {
                dal.AccountUsages.AddObject( accountUsage );
                dal.SaveChanges();
            }
            return true;
        }

        public static List<AccountUsage> GetAccountUsages( int accountID )
        {
            List<AccountUsage> a = null;
            using( LibertyPowerEntities dal = new LibertyPowerEntities() )
            {
                var query = dal.CreateObjectSet<AccountUsage>();
                query.MergeOption = System.Data.Objects.MergeOption.NoTracking;
                a = query.Where( w => w.AccountID == accountID ).ToList();
            }
            return a;
        }

        #endregion Account Usage

        #region Helper Methods

        public static string GetProductIdForResidential( string utilityCode )
        {
            string res = string.Empty;
            using( Lp_commonEntities dal = new Lp_commonEntities() )
            {
                res = (from p in dal.common_product
                       where
                           p.utility_id == utilityCode && p.account_type_id == 2 && p.inactive_ind == "0" &&
                           p.ProductBrandID == 1 && p.is_flexible == 1
                       select p.product_id).FirstOrDefault();
                if( !string.IsNullOrEmpty( res ) )
                    res = res.Trim();
            }
            return res;
        }

        public static bool IsAccountNumberInTheSystem( string accountNumber, int utilityId )
        {
            bool accountNumberExists = false;
            using( LibertyPowerEntities dal = new LibertyPowerEntities() )
            {
                var matches = dal.Accounts.Where( w => w.AccountNumber == accountNumber && w.UtilityID.HasValue && w.UtilityID.Value == utilityId ).FirstOrDefault();
                if( matches != null )
                    accountNumberExists = true;
            }
            return accountNumberExists;
        }

        public static bool IsAccountInContract( string accountNumber, int utilityId )
        {
            bool answer = false;
            using (LibertyPowerEntities dal = new LibertyPowerEntities())
            {
                var account = dal.Accounts.Where(w => w.AccountNumber == accountNumber && w.UtilityID.HasValue && w.UtilityID.Value == utilityId).FirstOrDefault();
                if (account != null)
                {

                    var m = account.AccountContracts.Where(w =>
                                account.CurrentContractID.HasValue &&
                                w.ContractID == account.CurrentContractID.Value &&
                                w.Contract.EndDate >= DateTime.Today);

                    if (m != null && m.Count() > 0)
                        answer = true;
                }
            }
            return answer;
        }

        public static bool IsAccountActive( string accountNumber, int utilityId )
        {
            bool answer = false;
            using( LibertyPowerEntities dal = new LibertyPowerEntities() )
            {
                var account = dal.Accounts.Where( w => w.AccountNumber == accountNumber && w.UtilityID.HasValue && w.UtilityID.Value == utilityId ).FirstOrDefault();
                if( account != null )
                {

                    var m = account.AccountContracts.Where( w =>
                                account.CurrentContractID.HasValue &&
                                w.ContractID == account.CurrentContractID.Value &&
                                w.AccountStatus.Count > 0 &&
                                w.AccountStatus.Single().IsActive );

                    if( m != null && m.Count() > 0 )
                        answer = true;
                }
            }
            return answer;
        }

        /// <summary>
        ///  to check if Rollover Renewal Active
        /// </summary>
        /// <param name="accountID"></param>
        /// <returns></returns>
        public static bool IsRolloverRenewalActive(string legacyAccountId)
        {
            bool renewalActiveFlag = false;
            using (LibertyPowerEntities dal = new LibertyPowerEntities())
            {

                renewalActiveFlag = dal.Accounts
                        .Join(dal.AccountContracts, x => x.AccountID, y => y.AccountID,(x, y) => new { Account = x, AccountContract = y })
                        .Join(dal.Contracts, x => x.AccountContract.ContractID, y => y.ContractID,(x, y) => new { AccountContract = x, Contract = y })
                        .Join(dal.ContractDealTypes, x => x.Contract.ContractDealTypeID, y => y.ContractDealTypeID,(x, y) => new { Contract = x, ContractDealType = y })
                        .Join(dal.AccountStatuses, x => x.Contract.AccountContract.AccountContract.AccountContractID, y => y.AccountContractID,(x, y) => new { ContractDealType = x, AccountStatus = y })
                        .Any(item => item.ContractDealType.Contract.AccountContract.Account.AccountIdLegacy == legacyAccountId
                                && item.ContractDealType.ContractDealType.DealType == "RolloverRenewal"
                                && (String.Concat(item.AccountStatus.Status, item.AccountStatus.SubStatus) == "0100010"
                                    || String.Concat(item.AccountStatus.Status,item.AccountStatus.SubStatus) == "0700010"
                                    || String.Concat(item.AccountStatus.Status,item.AccountStatus.SubStatus) == "0700020")
                                );
            }
            return renewalActiveFlag;
        }


        public static string SelectMessage( LpMessageApplication application, string msgId )
        {
            string msg = null;
            using( Lp_commonEntities dal = new Lp_commonEntities() )
            {
                string app = application.ToString();
                if( application == LpMessageApplication.LOAD_FILE_VIEW )
                    app = "LOAD FILE VIEW";
                System.Data.Objects.ObjectParameter outparam = new System.Data.Objects.ObjectParameter( "p_msg_descp", typeof( string ) );
                dal.usp_messages_sel( msgId, outparam, app );
                msg = (string) outparam.Value;
            }
            return msg;
        }
		//Added to get the list of available enrollment statuses

		public static DataTable GetAllAccountStatus(string p_view)
		{
			DataTable restable = new DataTable();
			using( Lp_AccountEntities dal = new Lp_AccountEntities() )
			{
				 restable = (from p in dal.usp_status_sel( p_view )	  
					   select p).CopyToDataTable();
				
			}
			return restable;
		}
        #endregion Helper Methods

    }



}
