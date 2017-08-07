using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.IO;
using LibertyPower.DataAccess.TextAccess;
using LibertyPower.Business.MarketManagement.EdiParser.FileParser;
using LibertyPower.Business.MarketManagement.EdiParser.FormatParser;

namespace EdiParserTest
{
    
    
    /// <summary>
    ///This is a test class for ParserTest and is intended
    ///to contain all ParserTest Unit Tests
    ///</summary>
	[TestClass()]
	public class ParserTest
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
		///A test for ProcessFile
		///</summary>
		[TestMethod()]
		public void ParseFilesTest()
		{
			//string directoryPath = @"C:\Docs\Projects\EDI\TestFiles";
			//string xmlName = @"C:\Docs\Projects\EDI\EdiFile.xml";

			//FileInfoDetailedList files = FileLister.CreateFilesToParse( directoryPath );
			//EdiFile fileRows = new EdiFile();

			//foreach( FileInfoDetailed fileContents in files )
			//{
			//    fileRows = Processor.ProcessFile( fileContents );
			//}

			//SerializeFileEdi( fileRows, xmlName );

			//Assert.Inconclusive( "A method that does not return a value cannot be verified." );
		}

		private void SerializeFileEdi( EdiFile fileEdi, string fileName )
		{
			CustomXmlSerializer serializer = new CustomXmlSerializer();
			System.Text.StringBuilder xml = serializer.WriteText( fileEdi );

			string xmlString = xml.ToString();
			xmlString = xmlString.Replace( "\"", @"""" ).Replace( "`2", "" );

			TextWriter textWriter = new StreamWriter( fileName );
			textWriter.Write( xmlString );
			textWriter.Close();
		}
	}
}
