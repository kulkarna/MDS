using LibertyPower.Business.CustomerAcquisition.DailyPricing;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Collections.Generic;

namespace FrameworkTest
{


	/// <summary>
	///This is a test class for DataArchiverTest and is intended
	///to contain all DataArchiverTest Unit Tests
	///</summary>
	[TestClass()]
	public class DataArchiverTest
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

		[TestMethod]
		public void ArchiveProductCrossPriceHistory()
		{
			List<string> errors = null;
			int productCrossPriceSetID = 508;

			Assert.IsTrue( DataArchiver.ArchiveProductCrossPrices( productCrossPriceSetID, out errors ) );
			Assert.IsTrue( errors == null || errors.Count == 0 );
		}

		[TestMethod]
		public void ArchivePrices()
		{
			Assert.IsTrue( DataArchiver.ArchivePrices() );
		}

	}
}
