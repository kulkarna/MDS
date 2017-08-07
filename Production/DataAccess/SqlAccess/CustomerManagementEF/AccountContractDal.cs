//using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Text;

//namespace LibertyPower.DataAccess.SqlAccess.CustomerManagementEF
//{
//    public static class AccountContractDal
//    {

//        #region Account Contract

//        //public static AccountContract GetAccountContract( int accountContractID )
//        //{
//        //    AccountContract a = CommonDal.LPGetNonTrackedEntity<AccountContract>( w => w.AccountContractID == accountContractID );
//        //    return a;
//        //}

//        //public static bool InsertAccountContract( AccountContract ac )
//        //{
//        //    using( LibertyPowerEntities dal = new LibertyPowerEntities() )
//        //    {
//        //        dal.AccountContracts.AddObject( ac );
//        //        dal.SaveChanges();
//        //    }
//        //    return true;
//        //}

//        #endregion Account Contract

//        #region Account Contract Commission

//        //public static AccountContractCommission GetAccountContractCommission( int accountContractID )
//        //{
//        //    AccountContractCommission a = CommonDal.LPGetNonTrackedEntity<AccountContractCommission>( w => w.AccountContractID == accountContractID );
//        //    return a;
//        //}

//        //public static bool InsertAccountContractCommission( AccountContractCommission ac )
//        //{
//        //    using( LibertyPowerEntities dal = new LibertyPowerEntities() )
//        //    {
//        //        dal.AccountContractCommissions.AddObject( ac );
//        //        dal.SaveChanges();
//        //    }
//        //    return true;
//        //}

//        #endregion Account Contract Commission

//        #region Account Contract Rate

//        //public static List<AccountContractRate> GetAccountContractRates( int accountContractID )
//        //{
//        //    List<AccountContractRate> a = null;
//        //    using( LibertyPowerEntities dal = new LibertyPowerEntities() )
//        //    {
//        //        var query = dal.CreateObjectSet<AccountContractRate>();
//        //        query.MergeOption = System.Data.Objects.MergeOption.NoTracking;
//        //        a = query.Where( w => w.AccountContractID == accountContractID ).ToList();
//        //    }
//        //    return a;
//        //}

//        //public static bool InsertAccountContractRate( AccountContractRate ac )
//        //{
//        //    using( LibertyPowerEntities dal = new LibertyPowerEntities() )
//        //    {
//        //        dal.AccountContractRates.AddObject( ac );
//        //        dal.SaveChanges();
//        //    }
//        //    return true;
//        //}

//        #endregion Account Contract Rate

//        #region Account Contract Status

//        //public static AccountStatus GetAccountStatus( int accountContractID )
//        //{
//        //    AccountStatus a = CommonDal.LPGetNonTrackedEntity<AccountStatus>( w => w.AccountContractID == accountContractID );
//        //    return a;
//        //}

//        //public static bool InsertAccountStatus( AccountStatus ac )
//        //{
//        //    using( LibertyPowerEntities dal = new LibertyPowerEntities() )
//        //    {
//        //        dal.AccountStatuses.AddObject( ac );
//        //        dal.SaveChanges();
//        //    }
//        //    return true;
//        //}

//        #endregion Account Contract Status


//    }
//}
