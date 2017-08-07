using System;
using IdrRawConverter;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace IdrUsageTests
{
	[TestClass]
	public class CommandLineInterpreterTestFixture
	{
		[TestMethod]
		public void TestCommandLineArgumentsPass()
		{
			//Arrange
			var args = new [] { "-u", "UTILITY", "-a", "123456", "-i", "inputfile.csv", "-o", "outputfile.xls"};

			//Act
			var options = new CommandLineInterpreter().Parse(args);

			//Assert
			Assert.IsNotNull(options);
			Assert.AreEqual( "UTILITY", options.UtilityCode );
			Assert.AreEqual( "123456", options.AccountNumber );
			Assert.AreEqual( "inputfile.csv", options.InputFile );
			Assert.AreEqual( "outputfile.xls", options.OutputFile );
		}

		[TestMethod]
		public void TestCommandLineArgumentsInvalidArgumentsPass()
		{
			//Arrange
			var args = new[] { "-u", "UTILITY", "-x", "123456", "-y", "-o", "outputfile.xls" };

			//Act
			var options = new CommandLineInterpreter().Parse( args );

			//Assert
			Assert.IsNotNull( options );
			Assert.AreEqual( "UTILITY", options.UtilityCode );
			Assert.AreEqual( "outputfile.xls", options.OutputFile );
		}

		[TestMethod]
		public void TestCommandLineArgumentsNoArgumentsPass()
		{
			//Arrange
			var args = new string[] { };

			//Act
			var options = new CommandLineInterpreter().Parse( args );

			//Assert
			Assert.IsNotNull( options );
		}

		[TestMethod, ExpectedException(typeof(Exception))]
		public void TestCommandLineArgumentsInvalidArgumentsFail()
		{
			//Arrange
			var args = new[] { "-u", "-a", "-i", "inputfile.csv", "-o", "outputfile.xls" };

			//Act
			new CommandLineInterpreter().Parse( args );

			//Parse will fail.
		}
	}
}
