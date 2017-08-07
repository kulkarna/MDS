using LibertyPower.Business.CustomerManagement.OnlineDataSynchronization;
using System;
using System.Collections.Generic;
using System.Data.Objects;
using System.IO;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;
using System.Data.Linq;
using System.Reflection;
using DM = LibertyPower.Business.CommonBusiness.DocumentManager;
using LibertyPower.DataAccess.SqlAccess.CustomerManagementEF;

namespace LibertyPower.Business.CustomerManagement.OnlineDataSynchronization
{
    public partial class GENIEEntities
    {




        /// <summary>
        /// Method to retrieve a package of document mapping data from the Genie database using EF 4
        /// </summary>
        /// <returns>GenieDocumentData</returns>
        public static GenieDocumentData GetGenieDocumentData()
        {
            GenieDocumentData data = null;
            using (GENIEEntities db = new GENIEEntities())
            {
                try
                {
                    data = new GenieDocumentData();
                    //Load document types
                    data.DocumentTypes = db.LK_DocumentType;

                    //Load document fields 
                    data.DocumentFields = db.LK_DocumentField;

                    //Load the documents
                    data.Documents = db.T_Documents;

                    //Load the DocumentFieldLocation
                    data.DocumentFieldLocations = db.T_DocumentFieldLocation;

                    //Load the document maps
                    data.DocumentMaps = db.M_DocumentMap;

                    ////Load the Account types
                    //data.AccountTypes = db.LK_AccountType;

                    ////Load the Markets
                    //data.Markets = db.LK_Market;

                    ////Load the brands
                    //data.Brands = db.LK_Brand;
                }
                catch (Exception ex)
                {
                    throw new ApplicationException("An unexpected error occured in GENIEEntities. Please see the inner exception for details", ex);
                }
            }

            return data;
        }
        public static GenieDocumentData GetGenieDocumentData(int marketId, int productBrandId)
        {
            GenieDocumentData data = null;
            using (GENIEEntities db = new GENIEEntities())
            {
                try
                {
                    data = new GenieDocumentData();
                    //db.ExecuteStoreQuery<M_DocumentMap>("GetDocumentsByMarketAndProduct",System.Data.Objects.MergeOption.AppendOnly,marketId,productBrandId);

                    //Load Document Maps                    
                    var retval = (from map in db.M_DocumentMap
                                  join a in db.LK_AccountType on map.AccountTypeID equals a.AccountTypeID into inv
                                  from acct in inv.DefaultIfEmpty()
                                  join b in db.LK_Brand on map.BrandID equals b.BrandID into inv1
                                  from brand in inv1.DefaultIfEmpty()
                                  join k in db.LK_Market on map.MarketID equals k.MarketID into inv2
                                  from market in inv2.DefaultIfEmpty()
                                  join fl in db.T_DocumentFieldLocation on map.DocumentID equals fl.DocumentID
                                  join f in db.LK_DocumentField on fl.FieldID equals f.FieldID
                                  join d in db.T_Documents on map.DocumentID equals d.DocumentID
                                  //from d in db.T_Documents
                                  //where (map.DocumentID == d.DocumentID) || (d.DocumentTypeID > 3)
                                  join dt in db.LK_DocumentType on d.DocumentTypeID equals dt.DocumentTypeID
                                  where ((brand.LPBrandID == productBrandId && market.LPMarketID == marketId)
                                  ||
                                  (map.MarketID == 0 && map.BrandID == 0 && map.AccountTypeID == 0)
                                  ||
                                  (market.LPMarketID == marketId && brand.LPBrandID == productBrandId && map.AccountTypeID == 0)
                                  ||
                                  (market.LPMarketID == marketId && map.BrandID == 0))
                                  &&
                                  db.LK_Brand.Any(item => item.LPBrandID == productBrandId)
                                  &&
                                  db.LK_Market.Any(item => item.LPMarketID == marketId)
                                  select new { m = map, acct, brand, market, fl, f, d, dt }).ToList();

                    //Load the document types
                    data.DocumentTypes = (from t in db.LK_DocumentType select t).ToList();
                    if (retval != null && retval.Count() > 0)
                    {
                        retval.Select(item => new { map = item.m, acct = item.acct }).ToList().
                            ForEach(item => { item.map.AccountTypeID = item.acct != null ? item.acct.LPAccountTypeID : 0; });
                        //Load Mappings

                        data.DocumentMaps = retval.Select(item => item.m).Distinct(new DocumentMapComparer());

                        //Load Documents
                        // data.Documents = retval.Select(item => item.d).Distinct(new DocumentComparer());
                        //var Docs = retval.Select(item => item.d).Distinct(new DocumentComparer());
                        //Docs.ToList().AddRange((from t in db.T_Documents where t.DocumentTypeID == 7 select t).ToList());
                        //data.Documents = Docs;
                        data.Documents = retval.Select(item => item.d).Distinct(new DocumentComparer()).ToList().Concat((from t in db.T_Documents where t.DocumentTypeID == 7 select t).ToList());

                        //Load Document field locations
                        data.DocumentFieldLocations =
                            retval.Select(item => item.fl).Distinct(new DocumentFieldLocationComparer());

                        //Load the document fields
                        data.DocumentFields =
                            retval.Select(item => item.f).Distinct(new DocumentFieldComparer());
                    }

                }
                catch (Exception ex)
                {
                    throw new ApplicationException("An unexpected error occured in GENIEEntities. Please see the inner exception for details", ex);
                }
            }

            return data;
        }

        public static List<TabletDocument> GetFlyerDocuments(int channelID)
        {
            //Load the document Types
            var documentType = DM.DocumentManager.GetDocumentTypes();
            string documentTypeCode = "Campaign Flyer";
            int documentTypeID=0;

            documentTypeID = (from dtype in documentType
             where (dtype.Type == documentTypeCode)
             select dtype.Id).FirstOrDefault();

            List<TabletDocument> tabletDocument = new List<TabletDocument>();

            //There is no document type of Campaign flyer
            if (documentTypeID == 0)
                return tabletDocument;

            using (LibertyPowerEntities lp = new LibertyPowerEntities())
            {
                try
                {
                    DateTime currentDateTime = DateTime.Now;
                    var flyers = (from tabletdocument in lp.TabletDocuments
                                  where (tabletdocument.DocumentTypeID == documentTypeID &&
                                  tabletdocument.ChannelID == channelID &&
                                  currentDateTime < tabletdocument.EffectiveEndDate &&
                                  currentDateTime >= tabletdocument.EffectiveStartDate)
                                  select  tabletdocument ).ToList();

                    if (flyers.Count() > 0)
                    {
                        tabletDocument = flyers.Select(document => new TabletDocument
                        {
                            DocumentID = document.ID,
                            FileName = document.Name,
                            DocumentTypeID = document.DocumentTypeID,
                            DocOrientation = "P",
                            ModifiedDate = document.ModifiedDate,
                            DocumentVersion = "VER1",
                            LanguageID = 1,
                            EffectiveStartDate = document.EffectiveStartDate,
                            EffectiveEndDate = document.EffectiveEndDate
                        }).ToList();
                    }

                }
                catch (Exception ex)
                {
                    throw new ApplicationException("An unexpected error occured in GENIEEntities.GetFlyerDocument Please see the inner exception for details", ex);
                }
             
            }
             return tabletDocument;
        }

        /// <summary>
        /// Method to retrieve the file name of a resource file based on the file id number
        /// </summary>
        /// <param name="fileID">File ID  : int</param>
        /// <returns>FileName : string</returns>
        public static string GetFileName(int fileID)
        {
            GENIEEntities db = new GENIEEntities();

            try
            {
                return db.T_Documents.Where(d => d.DocumentID == fileID).SingleOrDefault().FileName.ToString();
            }
            catch (Exception ex)
            {

                throw new ApplicationException(ex.Message, ex.InnerException);
            }
        }

        public static string GetAppSetting(string configKey)
        {
            GENIEEntities db = new GENIEEntities();

            try
            {
                return db.Configurations.Where(c => c.ConfigurationName == configKey).SingleOrDefault().ConfigurationValue.ToString();
            }
            catch (Exception ex)
            {

                throw new ApplicationException(ex.Message, ex.InnerException);
            }
        }

        /// <summary>
        /// Method to retrieve the serialized byte array of a resource file
        /// </summary>
        /// <param name="filePath">Complete file path : string</param>
        /// <returns>Byte array : byte[]</returns>
        public static byte[] GetFile(string filePath)
        {
            byte[] buffer = null;

            try
            {
                using (FileStream fs = new FileStream(filePath, System.IO.FileMode.Open, System.IO.FileAccess.Read,
                                                        System.IO.FileShare.Read))
                {
                    buffer = new byte[fs.Length];
                    fs.Read(buffer, 0, (int)fs.Length);
                }

                return buffer;

            }
            catch (Exception ex)
            {

                throw new ApplicationException(ex.Message, ex.InnerException);
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public static List<T_Documents> GetDocuments()
        {
            GENIEEntities db = new GENIEEntities();
            try
            {
                return db.T_Documents.ToList();
            }
            catch (Exception ex)
            {
                throw new ApplicationException(ex.Message, ex.InnerException);
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public static List<LK_DocumentType> GetDocumentTypes()
        {
            GENIEEntities db = new GENIEEntities();

            try
            {
                return db.LK_DocumentType.ToList();
            }
            catch (Exception ex)
            {

                throw new ApplicationException(ex.Message, ex.InnerException);
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public static List<M_DocumentMap> GetDocumentMaps()
        {
            GENIEEntities db = new GENIEEntities();

            try
            {
                return db.M_DocumentMap.ToList();
            }
            catch (Exception ex)
            {

                throw new ApplicationException(ex.Message, ex.InnerException);
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public static List<LK_DocumentField> GetDocumentFields()
        {
            GENIEEntities db = new GENIEEntities();

            try
            {
                return db.LK_DocumentField.ToList();
            }
            catch (Exception ex)
            {

                throw new ApplicationException(ex.Message, ex.InnerException);
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public static List<T_DocumentFieldLocation> GetDocumentFieldLocations()
        {
            GENIEEntities db = new GENIEEntities();

            try
            {
                return db.T_DocumentFieldLocation.ToList();
            }
            catch (Exception ex)
            {

                throw new ApplicationException(ex.Message, ex.InnerException);
            }
        }
    }
    public class DocumentFieldLocationComparer : IEqualityComparer<T_DocumentFieldLocation>
    {
        public bool Equals(T_DocumentFieldLocation x, T_DocumentFieldLocation y)
        {
            return x.FieldID == y.FieldID && x.DocumentID == y.DocumentID;
        }

        public int GetHashCode(T_DocumentFieldLocation obj)
        {
            return obj.GetHashCode();
        }
    }
    public class DocumentFieldComparer : IEqualityComparer<LK_DocumentField>
    {
        public bool Equals(LK_DocumentField x, LK_DocumentField y)
        {
            return x.FieldID == y.FieldID && x.FieldName == y.FieldName && x.FieldTypeID == y.FieldTypeID;
        }

        public int GetHashCode(LK_DocumentField obj)
        {
            return obj.GetHashCode();
        }
    }
    public class DocumentComparer : IEqualityComparer<T_Documents>
    {
        public bool Equals(T_Documents x, T_Documents y)
        {
            return x.DocumentID == y.DocumentID && x.DocumentTypeID == y.DocumentTypeID && x.LanguageID == y.LanguageID;
        }

        public int GetHashCode(T_Documents obj)
        {
            return obj.GetHashCode();
        }
    }
    public class DocumentMapComparer : IEqualityComparer<M_DocumentMap>
    {
        public bool Equals(M_DocumentMap x, M_DocumentMap y)
        {
            return x.DocumentMapID == y.DocumentMapID && x.DocumentID == y.DocumentID && x.BrandID == y.BrandID && x.MarketID == y.MarketID;
        }

        public int GetHashCode(M_DocumentMap obj)
        {
            return obj.GetHashCode();
        }
    }


}
