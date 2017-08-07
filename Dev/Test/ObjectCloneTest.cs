using LibertyPower.Business.CommonBusiness.CommonShared;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Collections.Generic;
using LibertyPower.Business.MarketManagement.MarketParsing;
using LibertyPower.Business.CommonBusiness.FileManager;
using LibertyPower.Business.MarketManagement.UtilityManagement;
using LibertyPower.Business.MarketManagement.EdiParser.FileParser;
using System.Data;
using LibertyPower.Business.CommonBusiness.CommonRules;
using LibertyPower.Business.CommonBusiness.CommonEntity;
using LibertyPower.DataAccess.ExcelAccess;
using System.Xml.Linq;
using HtmlAgilityPack;
using System.Collections;
using System.Runtime.Serialization;

namespace FrameworkTest
{
    
    
    /// <summary>
    ///This is a test class for ObjectCloneTest and is intended
    ///to contain all ObjectCloneTest Unit Tests
    ///</summary>
    [TestClass()]
    public class ObjectCloneTest
    {


        private TestContext testContextInstance;

        /// <summary>
        ///Gets or sets the test context which provides
        ///information about and functionality for the current test run.
        ///</summary>
        public TestContext TestContext
        {
            get
            {
                return testContextInstance;
            }
            set
            {
                testContextInstance = value;
            }
        }

        #region Additional test attributes
        // 
        //You can use the following additional attributes as you write your tests:
        //
        //Use ClassInitialize to run code before running the first test in the class
        //[ClassInitialize()]
        //public static void MyClassInitialize(TestContext testContext)
        //{
        //}
        //
        //Use ClassCleanup to run code after all tests in a class have run
        //[ClassCleanup()]
        //public static void MyClassCleanup()
        //{
        //}
        //
        //Use TestInitialize to run code before running each test
        //[TestInitialize()]
        //public void MyTestInitialize()
        //{
        //}
        //
        //Use TestCleanup to run code after each test has run
        //[TestCleanup()]
        //public void MyTestCleanup()
        //{
        //}
        //
        #endregion


    }
}
