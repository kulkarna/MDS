using LibertyPower.DataAccess.WebServiceAccess.PricesWcf;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using Microsoft.VisualStudio.TestTools.UnitTesting.Web;

using System.IO;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Formatters.Binary;
using System.Collections.Generic;
using System.Linq;
using System.Collections;


using LibertyPower.Business.CustomerAcquisition.SalesChannel;
using LibertyPower.Business.CustomerAcquisition.DailyPricing;

namespace FrameworkTest
{


	/// <summary>
	///This is a test class for PriceServiceTest and is intended
	///to contain all PriceServiceTest Unit Tests
	///</summary>
	[TestClass()]
	public class PriceServiceTest
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


		/// <summary>
		///A test for GetSalesChannelPrices
		///</summary>
		// TODO: Ensure that the UrlToTest attribute specifies a URL to an ASP.NET page (for example,
		// http://.../Default.aspx). This is necessary for the unit test to be executed on the web server,
		// whether you are testing a page, web service, or a WCF service.
		[TestMethod()]
		//[HostType( "ASP.NET" )]
		//[AspNetDevelopmentServerHost( "D:\\TFS\\Framework\\TeamE\\DataAccess\\WebServiceAccess\\PricesWcf", "/" )]
		//[UrlToTest( "http://localhost:51594/PriceService.svc" )]
		public void GetSalesChannelPricesTest()
		{
			//string filename = @"D:\Test\SerializedList.bin";

			//PriceService target = new PriceService(); // TODO: Initialize to an appropriate value
			//int salesChannelID = 27;
			//DateTime priceDate = Convert.ToDateTime( "4/23/2012" );
			//Envelope expected = null; // TODO: Initialize to an appropriate value
			//Envelope actual;

			try
			{
				//List<SalesChannelPrice> list = DailyPricingFactory.ConvertToSalesChannelPrices( DailyPricingFactory.GetSalesChannelPrices( salesChannelID, priceDate ) );


				////Stream stream = File.Open( filename, FileMode.Create );
				////BinaryFormatter bFormatter = new BinaryFormatter();
				////bFormatter.Serialize( stream, list );
				////stream.Close();

				////SalesChannelPriceList objectToSerialize;
				////stream = File.Open( filename, FileMode.Open );
				////bFormatter = new BinaryFormatter();
				////objectToSerialize = (SalesChannelPriceList) bFormatter.Deserialize( stream );
				////stream.Close();

				//IFormatter formatter = new BinaryFormatter();
				//Stream stream = new FileStream( filename, FileMode.Create, FileAccess.Write );
				//formatter.Serialize( stream, list );
			}
			catch( Exception ex )
			{
				string err = ex.Message;
			}


			//actual = target.GetSalesChannelPrices( salesChannelID, priceDate );
			//Assert.AreEqual( expected, actual );
			//Assert.Inconclusive( "Verify the correctness of this test method." );
		}
	}
}
