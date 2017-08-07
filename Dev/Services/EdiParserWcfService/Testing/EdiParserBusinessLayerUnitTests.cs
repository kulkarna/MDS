using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using LibertyPower.MarketDataServices.EdiParserBusinessLayer;
using LibertyPower.MarketDataServices.EdiParserDataMapper;
using LibertyPower.MarketDataServices.EdiParserRepository;
using LibertyPower.MarketDataServices.EdiParserWcfServiceData;
//using Common.Logging;
using Utilities;
using UtilityLogging;
using UtilityUnityLogging;

namespace Testing
{
    [TestClass]
    public class EdiParserBusinessLayerUnitTests
    {
        [TestMethod]
        public void BusinessLayerTest()
        {
            string messageId = Guid.NewGuid().ToString();
           
            ILogger log =  UnityLoggerGenerator.GenerateLogger();
          
            DataMapper dataMapper = new DataMapper(messageId, log);
            IRepository repository = new SqlRepository(messageId, log);
            IBusinessLayer businessLayer = new BusinessLayer(messageId, repository, dataMapper);
            GetBillGroupMostRecentResponse GetBillGroupMostRecentResponse = businessLayer.GetBillGroupMostRecent(messageId, "123", "1");
            Assert.IsNotNull(GetBillGroupMostRecentResponse);
            Assert.IsTrue(GetBillGroupMostRecentResponse.Code == "0000", "Code not equal to 0000");
            Assert.IsTrue(GetBillGroupMostRecentResponse.IsSuccess, "IsSuccess is not true");
            //Assert.IsTrue(!GetBillGroupMostRecentResponse.IsIdrEligibleFlag, "IsIdrEligibleFlag true when it should not be");
            Assert.IsTrue(GetBillGroupMostRecentResponse.Message == "Success", "Message not equal to Success");
            Assert.IsTrue(GetBillGroupMostRecentResponse.MessageId == messageId, "MessageId not equal to messageId");
        }

        [TestMethod]
        public void BusinessLayerTestNegativeOne()
        {
            string messageId = Guid.NewGuid().ToString();
            ILogger log = UnityLoggerGenerator.GenerateLogger();
            DataMapper dataMapper = new DataMapper(messageId, log);
            IRepository repository = new EdiParserBusinessLayerTestRepositoryReturningNegativeOneMock();
            IBusinessLayer businessLayer = new BusinessLayer(messageId, repository, dataMapper);
            GetBillGroupMostRecentResponse GetBillGroupMostRecentResponse = businessLayer.GetBillGroupMostRecent(messageId, "123", "1");
            Assert.IsNotNull(GetBillGroupMostRecentResponse);
            Assert.IsTrue(GetBillGroupMostRecentResponse.Code == "0000", "Code not equal to 0000");
            Assert.IsTrue(GetBillGroupMostRecentResponse.IsSuccess, "IsSuccess is not true");
            //Assert.IsTrue(!GetBillGroupMostRecentResponse.IsIdrEligibleFlag, "IsIdrEligibleFlag true when it should not be");
            Assert.IsTrue(GetBillGroupMostRecentResponse.Message == "Success", "Message not equal to Success");
            Assert.IsTrue(GetBillGroupMostRecentResponse.MessageId == messageId, "MessageId not equal to messageId");
        }

        [TestMethod]
        public void BusinessLayerTestOne()
        {
            string messageId = Guid.NewGuid().ToString();
            ILogger log = UnityLoggerGenerator.GenerateLogger();
            DataMapper dataMapper = new DataMapper(messageId, log);
            IRepository repository = new EdiParserBusinessLayerTestRepositoryReturningOneMock();
            IBusinessLayer businessLayer = new BusinessLayer(messageId, repository, dataMapper);
            GetBillGroupMostRecentResponse GetBillGroupMostRecentResponse = businessLayer.GetBillGroupMostRecent(messageId, "123", "1");
            Assert.IsNotNull(GetBillGroupMostRecentResponse);
            Assert.IsTrue(GetBillGroupMostRecentResponse.Code == "0000", "Code not equal to 0000");
            Assert.IsTrue(GetBillGroupMostRecentResponse.IsSuccess, "IsSuccess is not true");
            //Assert.IsTrue(GetBillGroupMostRecentResponse.BillGroup, "BillGroup notfound");
            Assert.IsTrue(GetBillGroupMostRecentResponse.Message == "Success", "Message not equal to Success");
            Assert.IsTrue(GetBillGroupMostRecentResponse.MessageId == messageId, "MessageId not equal to messageId");
        }

        [TestMethod]
        public void TestMethod1()
        {
            DataTableColumns dataTableColumns = new DataTableColumns("Id,INTEGER;One,STRING");
            Type typeString = dataTableColumns.GetTypeFromString("STRING");
            Type typeInteger = dataTableColumns.GetTypeFromString("INTEGER");

            string values = "1,a;2,b;3,c";
            DataSet dataSetFromValues = dataTableColumns.GenerateDataSet(values);


            List<List<string>> table = new List<List<string>>();
            List<string> row = new List<string>();
            row.Add("1");
            row.Add("a");
            table.Add(row);
            List<string> row1 = new List<string>();
            row1.Add("2");
            row1.Add("b");
            table.Add(row1);

            DataSet dataSet = dataTableColumns.GenerateDataSet(table);

            ////Type type = GetTypeFromString(dataColumnDefinition.DataType);
            //DataTable dataTable = new DataTable();
            //dataTable.Columns.Add(1, typeInteger);
            //dataTable.Columns.Add("a", typeString);

            //Assert.IsInstanceOfType(type,typeof(string));
            string s = string.Empty;
        }
    }



}