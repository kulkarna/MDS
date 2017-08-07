using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using LibertyPower.DataAccess.SqlAccess.CommonSql;
using LibertyPower.DataAccess.SqlAccess.CustomerManagementEF;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
    public class ZipcodeFactory
    {
        /// <summary>
        /// This method is used to get zip codes updated or creaated since a given date.
        /// <param name="modifiedDateTime">The date since we want to track changes.</param>
        /// <returns>IEnumerable<Zipcode></Zipcode><see cref="LibertyPower.Business.CustomerManagement.CRMBusinessObjects.Zipcode"/> Object</returns>
        public static IEnumerable<Zipcode> GetUpdatedZipcodes(DateTime modifiedDateTime)
        {
            LibertyPowerEntities entities = new LibertyPowerEntities();

            return entities.Zips.Where(x => 
                x.ModifiedDate != null && 
                x.ModifiedDate >= modifiedDateTime &&
                x.ZipCode != null && 
                x.UtilityID > 0 && 
                x.State != null &&
                x.MarketID > 0 &&
                x.City != null)
                    .Select(zip => new Zipcode
                    {
                        id = zip.id,
                        Zip = zip.ZipCode,
                        Latitude = zip.Latitude,
                        Longitude = zip.Longitude,
                        State = zip.State,
                        City = zip.City,
                        MarketID = zip.MarketID,
                        UtilityID = zip.UtilityID,
                        ZoneID = zip.ZoneID,
                        County = zip.County,
                        CreatedBy = zip.CreatedBy,
                        CreatedDate = zip.CreatedDate,
                        ModifiedBy = zip.ModifiedBy,
                        ModifiedDate = zip.ModifiedDate
                    }).ToList().AsEnumerable();
        }

        /// <summary>
        /// This method is used to get  zip code details by using a zip code
        /// <param name="Zipcode">Promotion Code.</param>
        /// <returns>IEnumerable<Zipcode></Zipcode><see cref="LibertyPower.Business.CustomerManagement.CRMBusinessObjects.Zipcode"/> Object</returns>
        public static IEnumerable<Zipcode> GetZipcodeData(string zipcode)
        {
            DataSet ds = ZipcodeSql.GetZipcodeData(zipcode);
            List<Zipcode> ziplist = new List<Zipcode>();
            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                for (int i = 0; i < ds.Tables[0].Rows.Count; i++ )
                {
                    Zipcode zip = MapDataRowToZipcode(ds.Tables[0].Rows[i]);
                    ziplist.Add(zip);
                }               
               
            }
            return ziplist;
        }


        private static Zipcode MapDataRowToZipcode(DataRow dataRow)
        {
            Zipcode returnVal = new Zipcode();
            returnVal.id = dataRow.Field<int>("id");
            returnVal.Zip = dataRow.Field<string>("ZipCode");
            returnVal.Latitude = dataRow.Field<double>("Latitude");
            returnVal.Longitude = dataRow.Field<double>("Longitude");
            returnVal.State = dataRow.Field<string>("State");
            returnVal.City = dataRow.Field<string>("City");
            returnVal.MarketID = dataRow.Field<int>("MarketID");
            returnVal.UtilityID = dataRow.Field<int>("UtilityID");
            returnVal.ZoneID = dataRow.Field<int>("ZoneID");                      
            returnVal.RetailMktDescp = dataRow.Field<string>("RetailMktDescp");
            returnVal.UtilityFullName = dataRow.Field<string>("FullName");
            returnVal.UtilityCode = dataRow.Field<string>("UtilityCode");
            returnVal.ZoneCode = dataRow.Field<string>("ZoneCode");  
            return returnVal;
        }
    }
}
