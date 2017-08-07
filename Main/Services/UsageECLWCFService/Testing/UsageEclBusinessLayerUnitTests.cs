using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using LibertyPower.MarketDataServices.UsageEclBusinessLayer;
using LibertyPower.MarketDataServices.UsageEclDataMapper;
using LibertyPower.MarketDataServices.UsageEclRepository;
using LibertyPower.MarketDataServices.UsageEclWcfServiceData;
//using Common.Logging;
using Utilities;
using UtilityLogging;
using UtilityUnityLogging;

namespace Testing
{
    [TestClass]
    public class UsageEclBusinessLayerUnitTests
    {
        [TestMethod]
        public void BusinessLayerTest()
        {
            string messageId = Guid.NewGuid().ToString();
            ILogger _logger = UnityLoggerGenerator.GenerateLogger();
            //ILogger log = LogManager.GetCurrentClassLogger();
            DataMapper dataMapper = new DataMapper(messageId, _logger);
            IRepository repository = new SqlRepository(messageId, _logger);
            IBusinessLayer businessLayer = new BusinessLayer(messageId, repository, dataMapper);
            IsIdrEligibleResponse isIdrEligibleResponse = businessLayer.IsIdrEligible(messageId, "123", 1);
            Assert.IsNotNull(isIdrEligibleResponse);
            Assert.IsTrue(isIdrEligibleResponse.Code == "0000", "Code not equal to 0000");
            Assert.IsTrue(isIdrEligibleResponse.IsSuccess, "IsSuccess is not true");
            Assert.IsTrue(!isIdrEligibleResponse.IsIdrEligibleFlag, "IsIdrEligibleFlag true when it should not be");
            Assert.IsTrue(isIdrEligibleResponse.Message == "Success", "Message not equal to Success");
            Assert.IsTrue(isIdrEligibleResponse.MessageId == messageId, "MessageId not equal to messageId");
        }

        [TestMethod]
        public void BusinessLayerTestNegativeOne()
        {
            string messageId = Guid.NewGuid().ToString();
            ILogger _logger = UnityLoggerGenerator.GenerateLogger();
            //ILog log = LogManager.GetCurrentClassLogger();
            DataMapper dataMapper = new DataMapper(messageId, _logger);
            IRepository repository = new UsageEclBusinessLayerTestRepositoryReturningNegativeOneMock();
            IBusinessLayer businessLayer = new BusinessLayer(messageId, repository, dataMapper);
            IsIdrEligibleResponse isIdrEligibleResponse = businessLayer.IsIdrEligible(messageId, "123", 1);
            Assert.IsNotNull(isIdrEligibleResponse);
            Assert.IsTrue(isIdrEligibleResponse.Code == "0000", "Code not equal to 0000");
            Assert.IsTrue(isIdrEligibleResponse.IsSuccess, "IsSuccess is not true");
            Assert.IsTrue(!isIdrEligibleResponse.IsIdrEligibleFlag, "IsIdrEligibleFlag true when it should not be");
            Assert.IsTrue(isIdrEligibleResponse.Message == "Success", "Message not equal to Success");
            Assert.IsTrue(isIdrEligibleResponse.MessageId == messageId, "MessageId not equal to messageId");
        }

        [TestMethod]
        public void BusinessLayerTestOne()
        {
            string messageId = Guid.NewGuid().ToString();
            ILogger _logger = UnityLoggerGenerator.GenerateLogger();
            //ILog log = LogManager.GetCurrentClassLogger();
            DataMapper dataMapper = new DataMapper(messageId, _logger);
            IRepository repository = new UsageEclBusinessLayerTestRepositoryReturningOneMock();
            IBusinessLayer businessLayer = new BusinessLayer(messageId, repository, dataMapper);
            IsIdrEligibleResponse isIdrEligibleResponse = businessLayer.IsIdrEligible(messageId, "123", 1);
            Assert.IsNotNull(isIdrEligibleResponse);
            Assert.IsTrue(isIdrEligibleResponse.Code == "0000", "Code not equal to 0000");
            Assert.IsTrue(isIdrEligibleResponse.IsSuccess, "IsSuccess is not true");
            Assert.IsTrue(isIdrEligibleResponse.IsIdrEligibleFlag, "IsIdrEligibleFlag not true");
            Assert.IsTrue(isIdrEligibleResponse.Message == "Success", "Message not equal to Success");
            Assert.IsTrue(isIdrEligibleResponse.MessageId == messageId, "MessageId not equal to messageId");
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