using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;
namespace LibertyPower.Business.CommonBusiness.SecurityManager
{
   public class AppNameFactory
    {
       /// <summary>
       /// create an entry for an application with a unique appkey ie..OMS, Enrollment..
       /// </summary>
       /// <param name="appName">Description of the application</param>
        /// <param name="appKey">unique application name in the appName table in liberty power.</param>
       /// <param name="createdBy">user id of the user performing the new entry</param>
       /// <returns>return a dataset of values for the new entry</returns>
        public static AppName CreateAppNameForExternalUser(string appName, string appKey, int createdBy)
        {
            
            DataSet ds = SecuritySql.CreateAppNameForUser(appName, appKey, createdBy);
            return GetAppNameForExternalUser(ds.Tables[0].Rows[0]);
        }

       /// <summary>
       /// return a loaded appname object from a datarow.
       /// the row must contain the following:
        /// AppDescription
        /// AppKey
        /// ApplicationKey-identity column for the table.
        /// CreatedBy
        /// ModifiedBy
       /// </summary>
       /// <param name="dr"></param>
       /// <returns></returns>
        public static AppName GetAppNameForExternalUser(DataRow dr)
        {
                        
            AppName a = new AppName();
            a.AppDescription = Convert.ToString(dr["AppDescription"]);
            a.AppKey = Convert.ToString(dr["AppKey"]);
            int tmpKey;
             bool result= int.TryParse(Convert.ToString( dr["ApplicationKey"]), out tmpKey );
             a.ApplicationKey = tmpKey;

             int tmpKey2;
             bool result2 = int.TryParse(Convert.ToString(dr["CreatedBy"]), out tmpKey2);
             int tmpKey3;
             bool result3 = int.TryParse(Convert.ToString(dr["ModifiedBy"]), out tmpKey3);

             a.CreatedBy = tmpKey2;
             a.ModifiedBy = tmpKey3;

            a.DateCreated = (DateTime) dr["DateCreated"];
            a.DateModified = (DateTime)dr["DateModified"];
            
            
            return a;
        }
       /// <summary>
       /// Retrieve a dataset of the names for all applications. Then load a list of Appname objects.
       /// 
       /// </summary>
       /// <returns></returns>
       public static AppNameList GetAllAppNamesForExternalUser()
       {
           DataSet ds = SecuritySql.GetAppNamesForUsers();
           if (SecurityCommon.IsValidDataset(ds))
           {
               AppNameList appList = new AppNameList();
               foreach (DataRow dr in ds.Tables[0].Rows)
               {
                   AppName a = GetAppNameForExternalUser(dr);
                   appList.Add(a);
               }
               return appList;
           }
           else
           {
               return null;
           }
       }
       /// <summary>
       /// Update the appName which is a description field, the modified by, and the datemodified for a single appname entry.
       /// </summary>
       /// <param name="appName">description for an appName entry</param>
       /// <param name="appKey">unique short description</param>
       /// <param name="modifiedBy"></param>
       /// <returns></returns>
       public static AppName UpdateAppNameForExternalUser(string appName, string appKey, int modifiedBy)
       {
           DataSet ds = SecuritySql.UpdateAppNameForUser(appName, appKey, modifiedBy);
           return GetAppNameForExternalUser(ds.Tables[0].Rows[0]);
       }
    }
}
