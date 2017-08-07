using System;
using System.Security.Cryptography;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using LibertyPower.Business.CustomerManagement.OnlineDataSynchronization;
using TB=LibertyPower.DataAccess.SqlAccess.CustomerManagementEF;

namespace LibertyPower.Business.CustomerManagement.OnlineDataSynchronization
{
    /// <summary>
    /// Factory class used to create specific meta data objects for use by the Document Service
    /// </summary>
    /// <remarks>
    /// This factory class is the primary constructor of document meta data related to the positional document
    /// management system. It can construct lists of the following objects:
    /// <list type="bullet">
    ///     <item>
    ///         <term>WSDocuments</term>
    ///         <description>A data contract describing document properties</description>
    ///     </item>
    ///     <item>
    ///         <term>WSDocumentType</term>
    ///         <description>A data contract describing document type properties</description>
    ///     </item>
    ///     <item>
    ///         <term>WSDocumentField</term>
    ///         <description>A data contract describing the properties of a document field</description>
    ///     </item>
    ///     <item>
    ///         <term>WSDocumentFieldLocation</term>
    ///         <description>a data contract describing the properties of a document field location</description>
    ///     </item>
    ///     <item>
    ///         <term>WSDocumentMap</term>
    ///         <description>A data contract describing the properties of a document mapping</description>
    ///     </item>
    /// </list>
    /// </remarks>
    public static class TabletDocumentFactory
    {

        #region Documents
        /// <summary>
        /// Gets a filtered list of position based document templates meta data objects, filtered by channel id.
        /// </summary>
        /// <param name="channelID">An integer channel id (required)</param>
        /// <returns>A list of CRMWebServices.WSEntities.Documents.WSDocument objects</returns>
        public static List<TabletDocument> GetDocuments( int channelID )
        {
            //Local variables
            GENIEEntities db = new GENIEEntities();

            //Try block. Retrieve  a list of T_document entity objects, filtered by 
            //sales channel id. This will limit the list somewhat.
            try
            {
                var docs = from d in db.GetDocumentsByChannel( (int?)channelID )
                           select new TabletDocument
                           {

                               DocOrientation = d.DocOrientation,
                               DocumentID = (int)d.DocumentID,
                               DocumentTypeID = d.DocumentTypeID,
                               DocumentVersion = d.DocumentVersion,
                               FileName = d.FileName,
                               LanguageID = d.LanguageID,
                               ModifiedDate = d.ModifiedDate
                           };

                //return the list of documents
                return docs.ToList<TabletDocument>();

            }
            catch (Exception ex)
            {

                throw new ApplicationException( ex.Message, ex.InnerException );
            }



        }



        /// <summary>
        /// Gets a filtered list of position based document templates meta data objects, filtered by channel id and market id.
        /// </summary>
        /// <param name="channelID">An integer channel id (required)</param>
        /// <param name="marketID">An integer market id (required)</param>
        /// <returns>A list of CRMWebServices.WSEntities.Documents.WSDocument objects</returns>
        public static List<TabletDocument> GetDocuments( int channelID, int marketID )
        {
            //Try block. Retrieve the base list of T_Document Entity objects by channel id, then filter by market id
            try
            {
                var db = new LibertyPower.Business.CustomerManagement.OnlineDataSynchronization.GENIEEntities();
                var docs = from d in db.GetDocumentsByChannelAndMarket( (int?)channelID, (int?)marketID )
                           select new TabletDocument
                           {

                               DocumentID = (int)d.DocumentID,
                               DocumentTypeID = d.DocumentTypeID,
                               DocumentVersion = d.DocumentVersion,
                               DocOrientation = d.DocOrientation,
                               FileName = d.FileName,
                               LanguageID = d.LanguageID,
                               ModifiedDate = d.ModifiedDate

                           };

                return docs.ToList<TabletDocument>();
            }
            catch (Exception ex)
            {

                throw new ApplicationException( ex.Message, ex.InnerException );
            }
            //return the list
        }

        /// <summary>
        /// Gets a filtered list of position based document templates meta data objects, filtered by channel id, market id, and product id.
        /// </summary>
        /// <param name="channelID">An integer Channel ID</param>
        /// <param name="marketID">An integer Market ID</param>
        /// <param name="productID">An Integer Product ID</param>
        /// <returns></returns>
        public static List<TabletDocument> GetDocuments( int channelID, int marketID, int productID )
        {
            //Local variables

            //Try block. Retrieve a list of Documents by channel id, then filter by market id and product id
            try
            {
                var db = new LibertyPower.Business.CustomerManagement.OnlineDataSynchronization.GENIEEntities();
                var docs = from d in db.GetDocumentsByChannelAndMarketAndProduct( (int?)channelID, (int?)marketID, (int?)productID )
                           select new TabletDocument
                           {

                               DocumentID = (int)d.DocumentID,
                               DocOrientation = d.DocOrientation,
                               DocumentTypeID = d.DocumentTypeID,
                               DocumentVersion = d.DocumentVersion,
                               FileName = d.FileName,
                               LanguageID = d.LanguageID,
                               ModifiedDate = d.ModifiedDate
                           };

                return docs.ToList<TabletDocument>();
            }
            catch (Exception ex)
            {

                throw new ArgumentException( ex.Message, ex.InnerException );
            }

            //return the list
        }

        #endregion

        #region Document Types

        /// <summary>
        /// Gets a list of relevant document types, based on the documents belonging to a sales channel
        /// </summary>
        /// <param name="channelID">A sales channel ID : int</param>
        /// <returns>A list of DocumentType objects</returns>
        public static List<TabletDocumentType> GetDocumentTypes()
        {
            // Local variables
            // We will need a list of DocumentType objects to return. Instantiate to return at least something else but
            // a null.
            var list = new List<TabletDocumentType>();
            //The GENIEEntities context serves as the in-memory data base representation.
            var db = new LibertyPower.Business.CustomerManagement.OnlineDataSynchronization.GENIEEntities();

            // Try block. Retrieve all the document types, based on what documents were assigned to the channel in question.
            try
            {
                list = (from t in db.LK_DocumentType
                        select new TabletDocumentType
                        {

                            DocumentTypeID = t.DocumentTypeID,
                            DocumentType = t.DocumentType,
                            MaxRecords = t.MaxRecords,
                            Sequence = t.Sequence
                        }).ToList<TabletDocumentType>();

                return list;
            }
            catch (Exception ex)
            {
                // Make sure you throw an ApplicationException on error.
                throw new ApplicationException( ex.Message, ex.InnerException );
            }


        }


        #endregion

        #region Document Fields

        /// <summary>
        /// Gets a list of document fields belonging to sales channel assigned documents
        /// </summary>
        /// <param name="channelID">A Sales Channel ID : int</param>
        /// <returns>A list of DocumentType objects</returns>
        public static List<TabletDocumentField> GetDocumentFields( int channelID )
        {
            List<TabletDocumentField> fields = new List<TabletDocumentField>();

            var db = new LibertyPower.Business.CustomerManagement.OnlineDataSynchronization.GENIEEntities();

            try
            {
                fields = (from f in db.GetFieldsByChannel( channelID )
                          select new TabletDocumentField
                          {
                              FieldID = f.FieldID,
                              FieldName = f.FieldName,
                              FieldTypeID = f.FieldTypeID,
                              ColumnName = f.ColumnName,
                              Prompt1 = f.Prompt1,
                              Prompt2 = f.Prompt2
                          }).ToList<TabletDocumentField>();

                db.Dispose();
            }
            catch (Exception ex)
            {

                throw new ApplicationException( ex.Message, ex.InnerException );
            }

            return fields;
        }

        /// <summary>
        /// Gets a list of document fields belonging to sales channel assigned documents, filtered by 
        ///  market id.
        /// </summary>
        /// <param name="channelID">A Sales Channel ID : int</param>
        /// <param name="marketID">A Market ID : int</param>
        /// <returns>A list of DocumentType objects</returns>
        public static List<TabletDocumentField> GetDocumentFields( int channelID, int marketID )
        {
            List<TabletDocumentField> fields = new List<TabletDocumentField>();

            var db = new LibertyPower.Business.CustomerManagement.OnlineDataSynchronization.GENIEEntities();

            try
            {
                fields = (from f in db.GetFieldsByChannelAndMarket( channelID, marketID )
                          select new TabletDocumentField
                          {
                              FieldID = f.FieldID,
                              FieldName = f.FieldName,
                              FieldTypeID = f.FieldTypeID,
                              ColumnName = f.ColumnName,
                              Prompt1 = f.Prompt1,
                              Prompt2 = f.Prompt2
                          }).ToList<TabletDocumentField>();

                db.Dispose();
            }
            catch (Exception ex)
            {

                throw new ApplicationException( ex.Message, ex.InnerException );
            }

            return fields;
        }

        /// <summary>
        /// Gets a list of document fields belonging to sales channel assigned documents, filtered by 
        /// market id and product id.
        /// </summary>
        /// <param name="channelID">A Sales Channel ID : int</param>
        /// <param name="marketID">A Market ID : int</param>
        /// <param name="productID">A Product ID : int</param>
        /// <returns>A list of DocumentType objects</returns>
        public static List<TabletDocumentField> GetDocumentFields( int channelID, int marketID, int productID )
        {
            List<TabletDocumentField> fields = new List<TabletDocumentField>();

            var db = new LibertyPower.Business.CustomerManagement.OnlineDataSynchronization.GENIEEntities();

            try
            {
                fields = (from f in db.GetFieldsByChannelAndMarketAndProduct( channelID, marketID, productID )
                          select new TabletDocumentField
                          {
                              FieldID = f.FieldID,
                              FieldName = f.FieldName,
                              FieldTypeID = f.FieldTypeID,
                              ColumnName = f.ColumnName,
                              Prompt1 = f.Prompt1,
                              Prompt2 = f.Prompt2

                          }).ToList<TabletDocumentField>();
            }
            catch (Exception ex)
            {

                throw new ApplicationException( ex.Message, ex.InnerException );
            }

            return fields;
        }

        #endregion

        #region Document Field Locations

        /// <summary>
        /// Gets a list of document field locations belonging to sales channel assigned documents.
        /// </summary>
        /// <param name="channelID">A sales channel ID : int</param>
        /// <returns>A list of DocumentFieldLocation objects</returns>
        public static List<TabletDocumentFieldLocation> GetDocumentFieldLocations( int channelID )
        {
            List<TabletDocumentFieldLocation> list = new List<TabletDocumentFieldLocation>();

            var db = new LibertyPower.Business.CustomerManagement.OnlineDataSynchronization.GENIEEntities();

            try
            {
                list = (from l in db.GetFieldLocationsByChannel( channelID )
                        select new TabletDocumentFieldLocation
                        {
                            DocumentID = l.DocumentID,
                            FieldID = l.FieldID,
                            LocationX = l.LocationX,
                            LocationY = l.LocationY
                        }).ToList<TabletDocumentFieldLocation>();

                db.Dispose();
            }
            catch (Exception ex)
            {

                throw new ApplicationException( ex.Message, ex.InnerException );
            }

            return list;
        }

        /// <summary>
        /// Gets a list of document field locations belonging to sales channel assigned documents, filtered by market ID.
        /// </summary>
        /// <param name="channelID">A sales channel ID : int</param>
        /// <param name="marketID">A market ID : int</param>
        /// <returns>A list of DocumentFieldLocation objects</returns>
        public static List<TabletDocumentFieldLocation> GetDocumentFieldLocations( int channelID, int marketID )
        {
            List<TabletDocumentFieldLocation> list = new List<TabletDocumentFieldLocation>();

            var db = new LibertyPower.Business.CustomerManagement.OnlineDataSynchronization.GENIEEntities();

            try
            {
                list = (from l in db.GetFieldLocationsByChannelAndMarket( channelID, marketID )
                        select new TabletDocumentFieldLocation
                        {
                            DocumentID = l.DocumentID,
                            FieldID = l.FieldID,
                            LocationX = l.LocationX,
                            LocationY = l.LocationY
                        }).ToList<TabletDocumentFieldLocation>();

                db.Dispose();
            }
            catch (Exception ex)
            {

                throw new ApplicationException( ex.Message, ex.InnerException );
            }

            return list;
        }

        /// <summary>
        /// Gets a list of document field locations belonging to sales channel assigned documents, 
        /// filtered by market ID, and product ID.
        /// </summary>
        /// <param name="channelID">A sales channel ID : int</param>
        /// <param name="marketID">A market ID : int</param>
        /// <param name="productID">A product ID : int</param>
        /// <returns>A list of DocumentFieldLocation objects</returns>
        public static List<TabletDocumentFieldLocation> GetDocumentFieldLocations( int channelID, int marketID, int productID )
        {
            List<TabletDocumentFieldLocation> list = new List<TabletDocumentFieldLocation>();

            var db = new LibertyPower.Business.CustomerManagement.OnlineDataSynchronization.GENIEEntities();

            try
            {
                list = (from l in db.GetFieldLocationsByChannelAndMarketAndProduct( channelID, marketID, productID )
                        select new TabletDocumentFieldLocation
                        {
                            DocumentID = l.DocumentID,
                            FieldID = l.FieldID,
                            LocationX = l.LocationX,
                            LocationY = l.LocationY
                        }).ToList<TabletDocumentFieldLocation>();

                db.Dispose();
            }
            catch (Exception ex)
            {

                throw new ApplicationException( ex.Message, ex.InnerException );
            }

            return list;
        }

        #endregion

        #region Document Mappings


        public static List<TabletDocumentMap> GetDocumentMaps( int channelID )
        {
            List<TabletDocumentMap> list = new List<TabletDocumentMap>();

            var db = new LibertyPower.Business.CustomerManagement.OnlineDataSynchronization.GENIEEntities();

            try
            {
                list = (from m in db.GetDocumentMapsByChannel( channelID )
                        select new TabletDocumentMap
                        {
                            AccountTypeID = m.AccountTypeID,
                            BrandID = m.BrandID,
                            DocumentID = m.DocumentID,
                            DocumentMapID = m.DocumentMapID,
                            MarketID = m.MarketID,
                            TemplateTypeID = m.TemplateTypeID
                        }).ToList<TabletDocumentMap>();

                db.Dispose();
            }
            catch (Exception ex)
            {

                throw new ApplicationException( ex.Message, ex.InnerException );
            }

            return list;
        }


        public static List<TabletDocumentMap> GetDocumentMaps( int channelID, int marketID )
        {
            List<TabletDocumentMap> list = new List<TabletDocumentMap>();

            var db = new LibertyPower.Business.CustomerManagement.OnlineDataSynchronization.GENIEEntities();

            try
            {
                list = (from m in db.GetDocumentMapsByChannelAndMarket( channelID, marketID )
                        select new TabletDocumentMap
                        {
                            AccountTypeID = m.AccountTypeID,
                            BrandID = m.BrandID,
                            DocumentID = m.DocumentID,
                            DocumentMapID = m.DocumentMapID,
                            MarketID = m.MarketID,
                            TemplateTypeID = m.TemplateTypeID
                        }).ToList<TabletDocumentMap>();

                db.Dispose();
            }
            catch (Exception ex)
            {

                throw new ApplicationException( ex.Message, ex.InnerException );
            }

            return list;
        }


        public static List<TabletDocumentMap> GetDocumentMaps( int channelID, int marketID, int productID )
        {
            List<TabletDocumentMap> list = new List<TabletDocumentMap>();

            var db = new LibertyPower.Business.CustomerManagement.OnlineDataSynchronization.GENIEEntities();

            try
            {
                list = (from m in db.GetDocumentMapsByChannelAndMarketAndProduct( channelID, marketID, productID )
                        select new TabletDocumentMap
                        {
                            AccountTypeID = m.AccountTypeID,
                            BrandID = m.BrandID,
                            DocumentID = m.DocumentID,
                            DocumentMapID = m.DocumentMapID,
                            MarketID = m.MarketID,
                            TemplateTypeID = m.TemplateTypeID
                        }).ToList<TabletDocumentMap>();

                db.Dispose();
            }
            catch (Exception ex)
            {

                throw new ApplicationException( ex.Message, ex.InnerException );
            }

            return list;
        }
        #endregion

        public static string MD5Hash( this string input )
        {
            using (MD5 hash = MD5.Create())
            {
                byte[] data = hash.ComputeHash( Encoding.UTF8.GetBytes( input ) );

                StringBuilder sb = new StringBuilder();

                for (int i = 0; i < data.Length; i++)
                {
                    sb.Append( data[i].ToString( "x2" ) );
                }

                return sb.ToString();
            }
        }

        /// <summary>
        /// Factory Method to get a web service Data contract containing a list of document mapping data
        /// </summary>
        /// <returns>WSDocumentMappingData</returns>
        public static TabletDocumentMappingData GetDocumentMappingData( TabletDocumentInputParams[]documentInputParamsList )
        {
            //instantiate a new return object 
            List<TabletDocumentMappingData> retvalAggregator = null;
            //Now its an array but it will have only one set.Will change later as it requires change in android side too.
            TabletDocumentMappingData finalResult = null;
            List<TabletDocument> flyerDocuments =new List<TabletDocument>();

            if (documentInputParamsList.Count() > 0)
            {
                int channelID = (from input in documentInputParamsList
                                  where (input.ChannelID > 0)
                                  select input.ChannelID).FirstOrDefault();
                if (channelID > 0)
                    flyerDocuments = GENIEEntities.GetFlyerDocuments(channelID);
            }
         
            foreach (TabletDocumentInputParams documentInputParams in documentInputParamsList)
            {
                if (retvalAggregator == null) retvalAggregator = new List<TabletDocumentMappingData>();
                TabletDocumentMappingData wSDocumentMappingData = null;

                GenieDocumentData data = null;
                if (documentInputParams != null)
                    data = GENIEEntities.GetGenieDocumentData
                     ( documentInputParams.MarketID, documentInputParams.BrandID );

                if (data != null && data.DocumentMaps != null)
                {
                    wSDocumentMappingData = new TabletDocumentMappingData();
                    //Load Document Maps
                    wSDocumentMappingData.DocumentMaps = data.DocumentMaps.Select( item => new TabletDocumentMap()
                    {
                        AccountTypeID = item.AccountTypeID,
                        BrandID = item.BrandID,
                        DocumentID = item.DocumentID,
                        DocumentMapID = item.DocumentMapID,
                        MarketID = item.MarketID,
                        TemplateTypeID = item.TemplateTypeID,
                        LPBrandID = documentInputParams.BrandID,
                        LPMarketID = documentInputParams.MarketID
                    } ).ToList();

                    //Load the document types
                    wSDocumentMappingData.DocumentTypes = (from t in data.DocumentTypes
                                                           select new TabletDocumentType
                                                           {
                                                               DocumentTypeID = t.DocumentTypeID,
                                                               DocumentType = t.DocumentType,
                                                               MaxRecords = t.MaxRecords,
                                                               Sequence = t.Sequence
                                                           }).ToList();


                    if (wSDocumentMappingData.DocumentMaps != null && wSDocumentMappingData.DocumentMaps.Count > 0)
                    {
                        //Load Documents
                        wSDocumentMappingData.Documents =
                            data.Documents
                             .Select( document => new TabletDocument
                             {
                                 DocumentID = document.DocumentID,
                                 FileName = document.FileName,
                                 DocumentTypeID = document.DocumentTypeID,
                                 DocOrientation = document.DocOrientation,
                                 ModifiedDate = document.ModifiedDate,
                                 DocumentVersion = document.DocumentVersion,
                                 LanguageID = document.LanguageID
                             } ).ToList();

                        //Load Document field locations
                        wSDocumentMappingData.DocumentFieldLocations =
                            data.DocumentFieldLocations
                            .Select( fieldLocation => new TabletDocumentFieldLocation
                            {
                                DocumentID = fieldLocation.DocumentID,
                                FieldID = fieldLocation.FieldID,
                                LocationX = fieldLocation.LocationX,
                                LocationY = fieldLocation.LocationY
                            } ).ToList();

                        //Load the document fields
                        wSDocumentMappingData.DocumentFields =
                            data.DocumentFields
                            .Select( docField => new TabletDocumentField
                            {
                                FieldID = docField.FieldID,
                                FieldName = docField.FieldName,
                                FieldTypeID = docField.FieldTypeID,
                                ColumnName = docField.ColumnName,
                                Prompt1 = docField.Prompt1,
                                Prompt2 = docField.Prompt2
                            } ).ToList();

                    }

                }

                if (wSDocumentMappingData != null)
                    retvalAggregator.Add( wSDocumentMappingData );
            }
            //Add flyer documents
            if (flyerDocuments.Count>0)
            {
                TabletDocumentMappingData wSDocumentMappingData = new TabletDocumentMappingData();
                if (wSDocumentMappingData.Documents == null)
                    wSDocumentMappingData.Documents = new List<TabletDocument>();
                if (wSDocumentMappingData.DocumentFields == null)
                    wSDocumentMappingData.DocumentFields = new List<TabletDocumentField>();
                if (wSDocumentMappingData.DocumentMaps == null)
                    wSDocumentMappingData.DocumentMaps = new List<TabletDocumentMap>();
                if (wSDocumentMappingData.DocumentFieldLocations == null)
                    wSDocumentMappingData.DocumentFieldLocations = new List<TabletDocumentFieldLocation>();
                if (wSDocumentMappingData.DocumentTypes == null)
                    wSDocumentMappingData.DocumentTypes = new List<TabletDocumentType>();

                wSDocumentMappingData.Documents.AddRange(flyerDocuments);
                retvalAggregator.Add(wSDocumentMappingData);
            }

            if (retvalAggregator != null && retvalAggregator.Count > 0)
            {
                finalResult =
                new TabletDocumentMappingData()
                {
                    DocumentFieldLocations = retvalAggregator.SelectMany
                    ( item => item.DocumentFieldLocations ).Distinct().ToList(),
                    DocumentFields = retvalAggregator.SelectMany
                   ( item => item.DocumentFields ).Distinct().ToList(),
                    Documents = retvalAggregator.SelectMany
                    ( item => item.Documents ).Distinct().ToList(),
                    DocumentMaps = retvalAggregator.SelectMany
                   ( item => item.DocumentMaps ).Distinct().ToList(),
                    DocumentTypes = retvalAggregator.SelectMany
                    ( item => item.DocumentTypes ).Distinct().ToList()

                };

            }
            return finalResult;
        }

        private static string Config_LibertyPowerPadAPKID = "LibertyPowerPadAPKID";
      
        public static int GetTabletAPKID()
        {
            int tabletApkId = 0;
            //  get apk id from the config file
            if (System.Configuration.ConfigurationManager.AppSettings.AllKeys.Contains( Config_LibertyPowerPadAPKID ))
            {
                if (!int.TryParse( System.Configuration.ConfigurationManager.AppSettings.Get( Config_LibertyPowerPadAPKID ), out tabletApkId ))
                {
                    throw new ApplicationException( string.Format( "Invalid value for {0}, it must be a valid integer", Config_LibertyPowerPadAPKID ) );
                }
            }
            else
            {
                throw new ApplicationException( string.Format( "Did not find required configuration setting: {0} ", Config_LibertyPowerPadAPKID ) );
            }
            return tabletApkId;
        }

        public static AndroidPackage GetTabletLatestAPK( bool getfile )
        {

            AndroidPackage apk = new AndroidPackage( GetTabletDocumentByDocumentId( GetTabletAPKID(), getfile ) );
            return apk;
        }


        /// <summary>
        /// Returns a complete TabletDocument object with the file prepopulated if the flag is true 
        /// </summary>
        /// <param name="documentId"></param>
        /// <param name="loadFile"></param>
        /// <returns></returns>
        public static TabletDocument GetTabletDocumentByDocumentId( int documentId, bool loadFile )
        {
            TabletDocument document = null;
            Boolean isGenieDocument = TabletDocument.IsGenieDocument(documentId);

            //Local variables
            if (isGenieDocument)
            {
                using (GENIEEntities context = new GENIEEntities())
                {
                    var doc = (from d in context.T_Documents
                               where d.DocumentID == documentId
                               select d).FirstOrDefault();
                    if (doc != null)
                    {
                        document = MapTabletDocument(doc);
                        // Now get the file here:
                        if (loadFile)
                            document.RetrieveTabletFile("");
                    }
                }
            }
            else
            {
                using (TB.LibertyPowerEntities context = new TB.LibertyPowerEntities())
                {
                    var doc = (from tabletdocument in context.TabletDocuments
                               where (tabletdocument.ID == documentId)
                               select tabletdocument).FirstOrDefault();
                    if (doc != null)
                    {
                        document = MapTabletDocument(doc);
                        // Now get the file here:
                        if (loadFile)
                            document.RetrieveTabletFile(doc.FilePath);
                    }
                }
            }
            return document;
        }

        private static TabletDocument MapTabletDocument( T_Documents document )
        {
            TabletDocument newDocument = new TabletDocument();
            newDocument.DocOrientation = document.DocOrientation;
            newDocument.DocumentID = document.DocumentID; ;
            newDocument.DocumentTypeID = document.DocumentTypeID;
            newDocument.DocumentVersion = document.DocumentVersion;
            // newDocument.FileBytes = this is a file
            newDocument.FileName = document.FileName;
            // newDocument.Hash = not sourced yet
            newDocument.LanguageID = document.LanguageID;
            newDocument.ModifiedDate = document.ModifiedDate;
            return newDocument;
        }

        private static TabletDocument MapTabletDocument(TB.TabletDocument document)
        {
            TabletDocument newDocument = new TabletDocument();
            newDocument.DocOrientation = "P";
            newDocument.DocumentID = document.ID; 
            newDocument.DocumentTypeID = document.DocumentTypeID;
            newDocument.DocumentVersion = "VER1";
            // newDocument.FileBytes = this is a file
            newDocument.FileName = document.Name;
            // newDocument.Hash = not sourced yet
            newDocument.LanguageID = 1;
            newDocument.ModifiedDate = document.ModifiedDate;
            newDocument.EffectiveStartDate = document.EffectiveStartDate;
            newDocument.EffectiveEndDate = document.EffectiveEndDate;
            return newDocument;
        }

    }
}
