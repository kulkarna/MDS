using LibertyPower.Business.CommonBusiness.DocumentManager;
using LibertyPower.DataAccess.SqlAccess.CustomerManagementEF;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
    public class TabletDocumentFactory
    {
        /// <summary>
        /// Returns a list of TabletDocument objects for a determined contract number
        /// </summary>
        /// <param name="contractNumber"></param>
        /// <returns></returns>
        public static List<TabletDocument> GetTabletDocuments( string contractNumber )
        {
            DataSet ds = TabletDocumentSQL.GetTabletDocumentsByContractNumber( contractNumber );

            List<TabletDocument> tabletDocuments = new List<TabletDocument>();
            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    TabletDocument tabletDocument = new TabletDocument();
                    MapDataRowToTabletDocument( dr, tabletDocument );
                    tabletDocuments.Add( tabletDocument );
                }
            }

            return tabletDocuments;
        }

        /// <summary>
        /// Inserts a TabletDocument record
        /// </summary>
        /// <param name="tabletDocument"></param>
        /// <param name="errors"></param>
        /// <returns></returns>
        public static bool InsertTabletDocument( TabletDocument tabletDocument, out List<GenericError> errors )
        {
            errors = new List<GenericError>();

            //if (!tabletDocument.IsStructureValidForInsert())
            //{
            //    throw new InvalidOperationException("The structure of the TabletDocument Object is not valid");
            //}

            errors = tabletDocument.IsValidForInsert();

            if (errors.Count > 0)
            {
                return false;
            }

            bool result = TabletDocumentSQL.InsertTabletDocument( tabletDocument.ContractNumber, tabletDocument.FileName, tabletDocument.DocumentTypeID, tabletDocument.SalesAgentID, tabletDocument.IsGasFile );

            return result;
        }

        /// <summary>
        /// Maps a datarow to a TabletDocument object
        /// </summary>
        /// <param name="dataRow"></param>
        /// <param name="tabletDocument"></param>
        private static void MapDataRowToTabletDocument( DataRow dataRow, TabletDocument tabletDocument )
        {
            tabletDocument.TabletDocumentSubmissionID = dataRow.Field<int>( "TabletDocumentSubmissionID" );
            tabletDocument.ContractNumber = dataRow.Field<string>( "ContractNumber" );
            tabletDocument.FileName = dataRow.Field<string>( "FileName" );
            tabletDocument.DocumentTypeID = dataRow.Field<int>( "DocumentTypeID" );
            tabletDocument.SalesAgentID = dataRow.Field<int>( "SalesAgentID" );
            tabletDocument.CreatedDate = dataRow.Field<DateTime>( "CreatedDate" );
            tabletDocument.ModifiedDate = dataRow.Field<DateTime>( "ModifiedDate" );
            tabletDocument.IsGasFile = dataRow.Field<bool>( "IsGasFile" );

            DocumentType documentTypeObj = LibertyPower.Business.CommonBusiness.DocumentManager.DocumentManager.GetDocumentType( (int)tabletDocument.DocumentTypeID );
            if (documentTypeObj != null)
                tabletDocument.DocumentTypeName = documentTypeObj.Type;
        }

        /// <summary>
        /// Verifies if all the documents sent from the tablet were received on Liberty Power side
        /// </summary>
        /// <param name="contractNumber"></param>
        /// <returns></returns>
        public static bool HaveAllTabletDocumentsBeenSubmitted( string contractNumber )
        {
            return TabletDocumentSQL.HaveAllTabletDocumentsBeenSubmitted( contractNumber );
        }

    }
}
