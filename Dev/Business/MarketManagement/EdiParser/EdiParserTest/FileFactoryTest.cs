using LibertyPower.Business.MarketManagement.EdiParser.FileParser;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Text;
using System.IO;
using System.Configuration;

namespace EdiParserTest
{
    
    
    /// <summary>
    ///This is a test class for FileFactoryTest and is intended
    ///to contain all FileFactoryTest Unit Tests
    ///</summary>
	[TestClass()]
	public class FileFactoryTest
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
		///A test for CopyFilesFromManagesStorage
		///</summary>
		[TestMethod()]
		public void CopyFilesFromManagesStorageTest()
		{
			string[] fileGuids = new string[] { "314fe721-468c-4b69-bbb1-e9775ae5eaa5", "d251dd1e-742e-4ef7-924e-d87613054f05", "ddd25e19-7244-4234-891e-cf434df48aa0", "91782702-d6e9-4767-ab56-c80f20176027" }; 
			string copyToDirectory = ConfigurationManager.AppSettings["FtpDirectory"];
			FileFactory.CopyFilesFromManagedStorage( fileGuids, copyToDirectory );
			Assert.Inconclusive( "A method that does not return a value cannot be verified." );
		}
	}
}
