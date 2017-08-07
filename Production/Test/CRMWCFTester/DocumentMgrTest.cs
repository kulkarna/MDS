using System;
using System.Collections.Generic;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using CRMEntity = LibertyPower.Business.CustomerManagement.CRMBusinessObjects;
using DocumentRepository.Code;
using DocumentRepository;
using docRepoClasses = DocumentRepository.Classes;
using CRMWebServices;
using System.Data;
using System.IO;
namespace CRMWCFTester
{
    [TestClass]
    public class DocumentMgrTest
    {
        [TestMethod]
        public void GetApkFile()
        {
            var s = LibertyPower.Business.CustomerManagement.OnlineDataSynchronization.TabletDocumentFactory.GetTabletLatestAPK( false );

            Assert.IsNotNull( s );
        }

        [TestMethod]
        public void GetFilledTemplate()
        {
            docRepoClasses.ContractDetail contractDetail = new docRepoClasses.ContractDetail();
            //string testDataPath = AppDomain.CurrentDomain.BaseDirectory.ToString();
            //Please change the below to point to proper path
            string testDataPath = @"E:\TFS\Portfolio\Framework\LPAlpha\Test\CRMWCFTester\SampleFiles\";
            var license = new Aspose.Words.License();
            //Please change the below to point to proper path
            string licPath = @"E:\TFS\Portfolio\Framework\LPAlpha\Test\CRMWCFTester\License\Aspose.Words.lic";
            license.SetLicense( licPath );

            ////testDataPath = testDataPath.Remove(testDataPath.IndexOf("bin")) + @"SampleFiles\";
            contractDetail.ReadXmlSchema( testDataPath + @"DocMgmtTestData.xsd" );
            contractDetail.ReadXml( testDataPath + @"DocMgmtTestData.xml" );




            DataSet contractDetailDS = contractDetail.DefaultViewManager.DataSet;
            DataCleansingFunctions.PrePrintDataCorrections( ref contractDetailDS );
            //Chop up full tables to get "First[TableName]" and "More[TableName]" tables for merge fields
            DataTableFunctions.AddTableSlicesToDataSet( ref contractDetailDS );


            //Apply exiting transformations and data cleaning stuff.
            if (contractDetail == null || contractDetail.Tables.Count < 1 || contractDetail.Tables[0].Rows.Count < 1)
            {
                //Assert.Fail("No data found for ContractNumber:" + contract.Number);
                Assert.Fail( "No sample data available for specified parameters." );
            }


            docRepoClasses.Result result = LetterFunctions.GenerateDocumentWithDataset( (int)DocumentRepository.Classes.DocumentType.CN_Contract, contractDetail, false, true, "System\\documentmanager" );

            //only asserting exception string is empty
            string execptionString = result.ExceptionString.ToString();
            Assert.IsFalse( !string.IsNullOrEmpty( execptionString ) );

            //var asposeDocument = new Aspose.Words.Document(documentPath);

            //string finalPath = System.IO.Path.ChangeExtension(documentPath, ".PDF");
            //asposeDocument.Save(finalPath, Aspose.Words.SaveFormat.Pdf);


            ////this result will return the path to the file

            //FileStream fs = File.OpenRead(finalPath);
            //byte[] byteArr = new byte[fs.Length];
            //fs.Read(byteArr, 0, byteArr.Length);
            //result.Value = byteArr;
            //return result;

        }


        [TestMethod]
        public void GetZippedFiles()
        {
            docRepoClasses.ContractDetail contractDetail = new docRepoClasses.ContractDetail();
            docRepoClasses.ContractDetail contractDetail2 = new docRepoClasses.ContractDetail();
            string testDataPath = AppDomain.CurrentDomain.BaseDirectory.ToString();
            testDataPath = testDataPath.Remove( testDataPath.IndexOf( "bin" ) ) + @"SampleFiles\";
            contractDetail.ReadXmlSchema( testDataPath + @"DocMgmtTestData.xsd" );
            contractDetail.ReadXml( testDataPath + @"DocMgmtTestData.xml" );

            List<docRepoClasses.ContractDetail> lstContractDetails = new List<docRepoClasses.ContractDetail>();


            DataSet contractDetailDS = contractDetail.DefaultViewManager.DataSet;
            DataCleansingFunctions.PrePrintDataCorrections( ref contractDetailDS );
            //Chop up full tables to get "First[TableName]" and "More[TableName]" tables for merge fields
            DataTableFunctions.AddTableSlicesToDataSet( ref contractDetailDS );


            //Apply exiting transformations and data cleaning stuff.
            if (contractDetail == null || contractDetail.Tables.Count < 1 || contractDetail.Tables[0].Rows.Count < 1)
            {
                //Assert.Fail("No data found for ContractNumber:" + contract.Number);
                Assert.Fail( "No sample data available for specified parameters." );
            }

            contractDetail2 = contractDetail;

            lstContractDetails.Add( contractDetail );
            lstContractDetails.Add( contractDetail2 );



            docRepoClasses.Result ZipResult = LetterFunctions.GenerateZippedDocuments( (int)DocumentRepository.Classes.DocumentType.CN_Contract, lstContractDetails, "", true );


            if (!string.IsNullOrEmpty( ZipResult.ExceptionString ))
            {
                Assert.Fail( "Error occured getting zip package." );
            }

            //generate the file from the byte array
            FileStream fs = File.OpenWrite( @"c:\extractedfile.zip" );
            byte[] byteArr = (byte[])ZipResult.Value;

            const int bufSize = 0x1000;
            byte[] buf = new byte[bufSize];

            fs.Write( byteArr, 0, byteArr.Length );

            //file is found
            Assert.IsTrue( File.Exists( @"c:\extractedfile.zip" ) );

        }


        /// <summary>
        /// This test method is a part 1 of a 2 part test. In the first part, the zip file is generated, in part 2 it is retreived.
        /// </summary>
        [TestMethod]
        public void GenerateZipFileOnly()
        {

            docRepoClasses.ContractDetail contractDetail = new docRepoClasses.ContractDetail();
            docRepoClasses.ContractDetail contractDetail2 = new docRepoClasses.ContractDetail();
            string testDataPath = AppDomain.CurrentDomain.BaseDirectory.ToString();
            testDataPath = testDataPath.Remove( testDataPath.IndexOf( "bin" ) ) + @"SampleFiles\";
            contractDetail.ReadXmlSchema( testDataPath + @"DocMgmtTestData.xsd" );
            contractDetail.ReadXml( testDataPath + @"DocMgmtTestData.xml" );

            List<docRepoClasses.ContractDetail> lstContractDetails = new List<docRepoClasses.ContractDetail>();


            DataSet contractDetailDS = contractDetail.DefaultViewManager.DataSet;
            DataCleansingFunctions.PrePrintDataCorrections( ref contractDetailDS );
            //Chop up full tables to get "First[TableName]" and "More[TableName]" tables for merge fields
            DataTableFunctions.AddTableSlicesToDataSet( ref contractDetailDS );


            //Apply exiting transformations and data cleaning stuff.
            if (contractDetail == null || contractDetail.Tables.Count < 1 || contractDetail.Tables[0].Rows.Count < 1)
            {
                //Assert.Fail("No data found for ContractNumber:" + contract.Number);
                Assert.Fail( "No sample data available for specified parameters." );
            }

            contractDetail2 = contractDetail;

            lstContractDetails.Add( contractDetail );
            lstContractDetails.Add( contractDetail2 );

            docRepoClasses.Result ZipResult = LetterFunctions.GenerateZippedDocuments( (int)DocumentRepository.Classes.DocumentType.CN_Contract, lstContractDetails, "", true, false );

            string tempZip = string.Empty;
            tempZip = ZipResult.Value.ToString();

            if (!string.IsNullOrEmpty( ZipResult.ExceptionString ))
            {
                Assert.Fail( "Error occured getting zip package." );
            }


            //file is returned..
            Assert.IsFalse( string.IsNullOrEmpty( tempZip ) );
        }


        /// <summary>
        /// Part 2 of the test. 
        /// </summary>
        /// <param name="fileId"></param>
        [TestMethod]
        public void GetPreviouslyGeneratedZip()
        {
            string fileId = "e74a6db71c594b34987579df9cd8e484.zip";

            docRepoClasses.Result ZipResult = LetterFunctions.GetGeneratedZipPakcage( fileId );

            //generate the file from the byte array
            FileStream fs = File.OpenWrite( @"c:\extractedfile.zip" );
            byte[] byteArr = (byte[])ZipResult.Value;

            const int bufSize = 0x1000;
            byte[] buf = new byte[bufSize];

            fs.Write( byteArr, 0, byteArr.Length );

            //file is found
            Assert.IsTrue( File.Exists( @"c:\extractedfile.zip" ) );
        }


        [TestMethod]
        public void GetFilledTemplate_PA()
        {
            docRepoClasses.ContractDetail contractDetail = new docRepoClasses.ContractDetail();
            string testDataPath = AppDomain.CurrentDomain.BaseDirectory.ToString();
            testDataPath = testDataPath.Remove( testDataPath.IndexOf( "bin" ) ) + @"SampleFiles\";
            contractDetail.ReadXmlSchema( testDataPath + @"DocMgmtTestData.xsd" );
            contractDetail.ReadXml( testDataPath + @"DocMgmtTestData_pa.xml" );

            CRMTestingClient testAPI = new CRMTestingClient();

            CRMEntity.Customer customer = testAPI.GetTestCustomer();
            CRMEntity.Contract contract = testAPI.GenerateRandomBasicContract();



            DataSet contractDetailDS = contractDetail.DefaultViewManager.DataSet;
            DataCleansingFunctions.PrePrintDataCorrections( ref contractDetailDS );
            //Chop up full tables to get "First[TableName]" and "More[TableName]" tables for merge fields
            DataTableFunctions.AddTableSlicesToDataSet( ref contractDetailDS );


            //Apply exiting transformations and data cleaning stuff.
            if (contractDetail == null || contractDetail.Tables.Count < 1 || contractDetail.Tables[0].Rows.Count < 1)
            {
                //Assert.Fail("No data found for ContractNumber:" + contract.Number);
                Assert.Fail( "No sample data available for specified parameters." );
            }


            docRepoClasses.Result result = LetterFunctions.GenerateDocumentWithDataset( (int)DocumentRepository.Classes.DocumentType.CN_Contract, contractDetail, true, true, "System\\documentmanager" );

            //only asserting exception string is empty
            string execptionString = result.ExceptionString.ToString();
            Assert.IsFalse( string.IsNullOrEmpty( execptionString ) );
            byte[] pdfData = (byte[])result.Value;

            //var asposeDocument = new Aspose.Words.Document(documentPath);


            ////this result will return the path to the file

            FileStream createFS = new FileStream( "d:\testfile.pdf", FileMode.Create, FileAccess.Write );
            createFS.Write( pdfData, 0, pdfData.Length );
            createFS.Close();

            //byte[] byteArr = new byte[fs.Length];
            //fs.Read(byteArr, 0, byteArr.Length);
            //result.Value = byteArr;
            //return result;

        }
    }
}
