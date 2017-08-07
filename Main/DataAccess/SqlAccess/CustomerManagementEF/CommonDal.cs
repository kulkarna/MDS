using System;
using System.Collections.Generic;
using System.Linq;

namespace LibertyPower.DataAccess.SqlAccess.CustomerManagementEF
{
    public static class CommonDal
    {
        #region Generic Functions

        public static T GetNonTrackedEntity<T>( System.Data.Objects.ObjectContext context, Func<T, bool> searchCondition ) where T : class
        {
            T entity;
            var query = context.CreateObjectSet<T>();
            query.MergeOption = System.Data.Objects.MergeOption.NoTracking;
            entity = query.Where( searchCondition ).FirstOrDefault();
            return entity;
        }

        public static List<T> GetNonTrackedEntities<T>( System.Data.Objects.ObjectContext context, Func<T, bool> searchCondition ) where T : class
        {
            List<T> entities;
            var query = context.CreateObjectSet<T>();
            query.MergeOption = System.Data.Objects.MergeOption.NoTracking;
            var results = query.Where( searchCondition );
            if( results != null )
            {
                entities = results.ToList();
            }
            else
            {
                entities = new List<T>();
            }
            return entities;
        }

        public static List<T> GetNonTrackedEntities<T>( System.Data.Objects.ObjectContext context ) where T : class
        {
            List<T> entities;
            var query = context.CreateObjectSet<T>();
            query.MergeOption = System.Data.Objects.MergeOption.NoTracking;
            entities = query.ToList();
            return entities;
        }

        public static T LPGetNonTrackedEntity<T>( Func<T, bool> searchCondition ) where T : class
        {
            T entity;
            using( LibertyPowerEntities dal = new LibertyPowerEntities() )
            {
                entity = GetNonTrackedEntity<T>( dal, searchCondition );
            }
            return entity;
        }

        public static List<T> LPGetNonTrackedEntities<T>() where T : class
        {
            List<T> entities;
            using( LibertyPowerEntities dal = new LibertyPowerEntities() )
            {
                entities = GetNonTrackedEntities<T>( dal );
            }
            return entities;
        }


        public static List<T> LPGetNonTrackedEntities<T>( Func<T, bool> searchCondition ) where T : class
        {
            List<T> entities;
            using( LibertyPowerEntities dal = new LibertyPowerEntities() )
            {
                entities = GetNonTrackedEntities<T>( dal, searchCondition );
            }
            return entities;
        }

        public static T LPAccontGetNonTrackedEntity<T>( Func<T, bool> searchCondition ) where T : class
        {
            T entity;
            using( Lp_AccountEntities dal = new Lp_AccountEntities() )
            {
                entity = GetNonTrackedEntity<T>( dal, searchCondition );
            }
            return entity;
        }

        public static T LPCommonGetNonTrackedEntity<T>( Func<T, bool> searchCondition ) where T : class
        {
            T entity;
            using( Lp_commonEntities dal = new Lp_commonEntities() )
            {
                entity = GetNonTrackedEntity<T>( dal, searchCondition );
            }
            return entity;
        }

        #endregion Generic Functions

        #region LP_Account Methods

        public static account_info GetAccountInfo( int accountId )
        {
            account_info ai = null;
            string legacyAccountNumber = "";
            using( LibertyPowerEntities dal = new LibertyPowerEntities() )
            {
                var matches = from a in dal.Accounts
                              where a.AccountID == accountId
                              select a.AccountIdLegacy;
                if( matches != null && matches.Count() > 0 )
                {
                    legacyAccountNumber = matches.First();
                    ai = LPAccontGetNonTrackedEntity<account_info>( f => f.account_id == legacyAccountNumber );
                }
            }
            return ai;
        }

        public static account_info GetAccountInfo( string legacyAccountNumber )
        {
            account_info ai = LPAccontGetNonTrackedEntity<account_info>( f => f.account_id == legacyAccountNumber );
            return ai;
        }

        public static bool InsertAccountInfo( account_info customer )
        {
            using( Lp_AccountEntities dal = new Lp_AccountEntities() )
            {
                dal.account_info.AddObject( customer );
                dal.SaveChanges();
            }
            return true;
        }

        public static bool UpdateAccountInfo( account_info ai )
        {
            using( Lp_AccountEntities dal = new Lp_AccountEntities() )
            {
                dal.account_info.Attach( ai );
                dal.SaveChanges();
            }
            return true;
        }

        /*
        public static account_address GetAddress( int addressId )
        {
            account_address a = LPAccontGetNonTrackedEntity<account_address>( f => f.AccountAddressID == addressId );
            return a;
        }

        public static account_name GetName( int nameId )
        {
            account_name a = LPAccontGetNonTrackedEntity<account_name>( f => f.AccountNameID == nameId );
            return a;
        }

        public static account_contact GetContact( int contactId )
        {
            account_contact c = LPAccontGetNonTrackedEntity<account_contact>( f => f.AccountContactID == contactId );
            return c;
        }

        public static bool InsertAddress( account_address address )
        {
            using( Lp_AccountEntities dal = new Lp_AccountEntities() )
            {
                dal.account_address.AddObject( address );
                dal.SaveChanges();
            }
            return true;
        }

        public static bool InsertName( account_name accountName )
        {
            using( Lp_AccountEntities dal = new Lp_AccountEntities() )
            {
                accountName.chgstamp = 1;
                dal.account_name.AddObject( accountName );
                dal.SaveChanges();
            }
            return true;
        }

        public static bool InsertContact( account_contact contact )
        {
            using( Lp_AccountEntities dal = new Lp_AccountEntities() )
            {
                dal.account_contact.AddObject( contact );
                dal.SaveChanges();
            }
            return true;
        }
        */


        #endregion LP_Account Methods

        #region LibertyPower Methods

        public static BusinessActivity GetBusinessActivity( int businessActivityID )
        {
            BusinessActivity a = LPGetNonTrackedEntity<BusinessActivity>( f => f.BusinessActivityID == businessActivityID );
            return a;
        }

        public static List<BusinessActivity> GetBusinessActivities( bool? active )
        {
            List<BusinessActivity> businessActivities = null;
            if( active.HasValue )
            {
                businessActivities = CommonDal.LPGetNonTrackedEntities<BusinessActivity>( f => f.Active == active.Value && f.Sequence < 20000 );
            }
            else
            {
                businessActivities = CommonDal.LPGetNonTrackedEntities<BusinessActivity>( f => f.Sequence < 20000 );
            }
            return businessActivities;
        }

        public static BusinessType GetBusinessType( int businessTypeID )
        {
            BusinessType bt = LPGetNonTrackedEntity<BusinessType>( f => f.BusinessTypeID == businessTypeID );
            return bt;
        }

        public static List<BusinessType> GetBusinessTypes( bool? active )
        {
            List<BusinessType> businessTypes = null;
            if( active.HasValue )
            {
                businessTypes = LPGetNonTrackedEntities<BusinessType>( f => f.Active == active.Value && f.Sequence < 20000 );
            }
            else
            {
                businessTypes = LPGetNonTrackedEntities<BusinessType>( f => f.Sequence < 20000 );
            }
            return businessTypes;
        }

        #endregion LibertyPower Methods

    }

}
