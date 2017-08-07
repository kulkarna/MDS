using System;
using System.Data;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using LibertyPower.MarketDataServices.UsageEclBusinessLayer;
using LibertyPower.MarketDataServices.UsageEclDataMapper;
using LibertyPower.MarketDataServices.UsageEclRepository;
using LibertyPower.MarketDataServices.UsageEclWcfServiceData;

namespace UsageEclServiceTests
{
    [TestClass]
    public class UsageEclBusinessLayerTest
    {
        [TestMethod]
        public void TestMethod1()
        {
            DataTableColumns dataTableColumns = new DataTableColumns("Id,INTEGER;One,STRING");
            Type typeString = dataTableColumns.GetTypeFromString("STRING");
            Type typeInteger = dataTableColumns.GetTypeFromString("INTEGER");

            
            //List<string> table = new List<string>();
            //List<string> row = new List<string>();
            //row.Add("1");
            //row.Add("a");
           // table.Add(row);
            //List<string> row1 = new List<string>();
           // row1.Add("2");
           // row1.Add("b");
           // table.Add(row1);


            ////Type type = GetTypeFromString(dataColumnDefinition.DataType);
            //DataTable dataTable = new DataTable();
            //dataTable.Columns.Add(1, typeInteger);
            //dataTable.Columns.Add("a", typeString);

            //Assert.IsInstanceOfType(type,typeof(string));
            string s = string.Empty;
        }
    }
}
