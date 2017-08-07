using System;
using System.Data;
using LibertyPower.Business.MarketManagement.IdrUsageManagement;
using LibertyPower.Business.MarketManagement.IdrUsageManagement.ImportedData;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace IdrUsageTests
{
	[TestClass]
	public class Imported8760FileTestFixture
	{
		[TestMethod]
		public void MapDataEmptyDataset()
		{
			//Arrange
			var mapper = new Imported8760File();

			var content = new DataTable();

			//Act
			var account = mapper.MapData( content );

			//Assert
			Assert.IsNotNull(account);
			Assert.IsNull(account.Exception);
			Assert.IsNull( account.ExceptionSummary );
			Assert.IsNull( account.IdrCsvList );
			Assert.IsNull( account.IdrList );
			Assert.IsNull( account.MeterNumber );
			Assert.IsNull( account.RecorderNumber );
			Assert.IsNull( account.UtilityCode );
		}

		[TestMethod]
		public void MapDataAtLeast365DaysFail()
		{
			//Arrange
			const string accountNumber = "1234567891";
			const string utilityCode = "UTILITY";
			const string meterNumber = "1234567891";

			var mapper = new Imported8760File();

			var content = TestHelper.CreateBaseDataTable();

			var row = TestHelper.CreateRow( content, utilityCode, accountNumber, meterNumber, DateTime.Today );

			content.Rows.Add(row);

            content.Rows.RemoveAt(0);

			//Act
			var account = mapper.MapData( content );

			//Assert
			Assert.IsNotNull( account );
			Assert.IsNull( account.IdrCsvList );
			Assert.IsNull( account.IdrList );
			Assert.AreEqual( accountNumber, account.AccountNumber );
			Assert.AreEqual( meterNumber, account.MeterNumber );
			Assert.AreEqual( utilityCode, account.UtilityCode );
			Assert.IsTrue( string.IsNullOrEmpty(account.RecorderNumber) );

			Assert.IsFalse( string.IsNullOrEmpty( account.Exception ) );
			Assert.AreEqual( "There are less than 365 days' worth of IDR Data.", account.Exception );

			Assert.IsFalse( string.IsNullOrEmpty( account.ExceptionSummary ) );
			Assert.AreEqual( "Not enough IDR Data. ", account.ExceptionSummary );
		}

		[TestMethod]
		public void MapDataAtLeast365DaysPass()
		{
			//Arrange
			const string accountNumber = "1234567891";
			const string utilityCode = "UTILITY";
			const string meterNumber = "1234567891";

			var mapper = new Imported8760File();

			var content = TestHelper.CreateBaseDataTable();

			for( var date = DateTime.Today; date < DateTime.Today.AddDays( 365 ); date = date.AddDays( 1 ) )
				content.Rows.Add( TestHelper.CreateRow( content, utilityCode, accountNumber, meterNumber, date ) );

            content.Rows.RemoveAt(0);

			//Act
			var account = mapper.MapData( content );

			//Assert
			Assert.IsNotNull( account );
			Assert.IsNull( account.IdrCsvList );
			Assert.AreEqual( accountNumber, account.AccountNumber );
			Assert.AreEqual( meterNumber, account.MeterNumber );
			Assert.AreEqual( utilityCode, account.UtilityCode );
			Assert.IsTrue( string.IsNullOrEmpty( account.RecorderNumber ) );
			
			Assert.IsNotNull( account.IdrList );
			Assert.AreEqual( 365, account.IdrList.Count );

			Assert.IsTrue( string.IsNullOrEmpty( account.Exception ) );

			Assert.IsTrue( string.IsNullOrEmpty( account.ExceptionSummary ) );
		}

		[TestMethod]
		public void MapDataConsecutiveDaysFail()
		{
			//Arrange
			const string accountNumber = "1234567891";
			const string utilityCode = "UTILITY";
			const string meterNumber = "1234567891";

			var mapper = new Imported8760File();

			var content = TestHelper.CreateBaseDataTable();

			for( var date = DateTime.Today; date < DateTime.Today.AddDays( 365 ); date = date.AddDays( 1 ) )
				content.Rows.Add( TestHelper.CreateRow( content, utilityCode, accountNumber, meterNumber, date ) );

			//Duplicate date of an entry but keep the number of entries 365. Validation should fail.
			content.Rows[10][5] = content.Rows[11][5];

            content.Rows.RemoveAt(0);

			//Act
			var account = mapper.MapData( content );

			//Assert
			Assert.IsNotNull( account );
			Assert.IsNull( account.IdrCsvList );
			Assert.IsNull( account.IdrList );
			Assert.AreEqual( accountNumber, account.AccountNumber );
			Assert.AreEqual( meterNumber, account.MeterNumber );
			Assert.AreEqual( utilityCode, account.UtilityCode );
			Assert.IsTrue( string.IsNullOrEmpty( account.RecorderNumber ) );

			Assert.IsFalse( string.IsNullOrEmpty( account.Exception ) );
			Assert.AreEqual( "There must be at least 365 consective days per account.", account.Exception );

			Assert.IsFalse( string.IsNullOrEmpty( account.ExceptionSummary ) );
			Assert.AreEqual( "Not enough consecutive IDR Data. ", account.ExceptionSummary );
		}

		[TestMethod]
		public void MapDataNegativeValuesFail()
		{
			//Arrange
			const string accountNumber = "1234567891";
			const string utilityCode = "UTILITY";
			const string meterNumber = "1234567891";

			var mapper = new Imported8760File();

			var content = TestHelper.CreateBaseDataTable();

			for( var date = DateTime.Today; date < DateTime.Today.AddDays( 365 ); date = date.AddDays( 1 ) )
				content.Rows.Add( TestHelper.CreateRow( content, utilityCode, accountNumber, meterNumber, date ) );

			//Negative values on data. Validation should fail.
			content.Rows[10][6] =  "-234";

            content.Rows.RemoveAt(0);

			//Act
			var account = mapper.MapData( content );

			//Assert
			Assert.IsNotNull( account );
			Assert.IsNull( account.IdrCsvList );
			Assert.IsNull( account.IdrList );
			Assert.AreEqual( accountNumber, account.AccountNumber );
			Assert.AreEqual( meterNumber, account.MeterNumber );
			Assert.AreEqual( utilityCode, account.UtilityCode );
			Assert.IsTrue( string.IsNullOrEmpty( account.RecorderNumber ) );

			Assert.IsFalse( string.IsNullOrEmpty( account.Exception ) );
			Assert.AreEqual( "A Negative value was found in row: 11.", account.Exception );

			Assert.IsFalse( string.IsNullOrEmpty( account.ExceptionSummary ) );
			Assert.AreEqual( "Negative Value(s). ", account.ExceptionSummary );
		}
	}
}
