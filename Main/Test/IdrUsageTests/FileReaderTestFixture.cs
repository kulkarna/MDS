using System;
using System.Data;
using LibertyPower.Business.MarketManagement.IdrUsageManagement;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using LibertyPower.DataAccess.SqlAccess.TransactionsSql.Model;

namespace IdrUsageTests
{
	[TestClass]
	public class FileReaderTestFixture
	{
		[TestMethod]
		public void HasDuplicateAccountsInEmptyDataSetIsFalse()
		{
			//Arrange

			//Act
			var result = FileReader.HasDuplicateAccounts(new DataSet());

			//Assert
			Assert.IsFalse(result);
		}

		[TestMethod]
        public void HasDuplicateAccountsInSingleTabIsFalse()
		{
			//Arrange
			var dataTable = TestHelper.CreateBaseDataTable();

			dataTable.Rows.Add(TestHelper.CreateRow( dataTable, "UTILITY", "12345", string.Empty, DateTime.Today ));
			dataTable.Rows.Add(TestHelper.CreateRow( dataTable, "UTILITY", "12345", string.Empty, DateTime.Today ));

			var dataset = new DataSet();

			dataset.Tables.Add(dataTable);

			//Act
			var result = FileReader.HasDuplicateAccounts( dataset );

			//Assert
			Assert.IsFalse( result );
		}

        [TestMethod]
        public void HasDuplicateAccountsInMultipleTabsIsTrue()
        {
            //Arrange
            var dataTable = TestHelper.CreateBaseDataTable();

            dataTable.Rows.Add(TestHelper.CreateRow(dataTable, "UTILITY", "12345", string.Empty, DateTime.Today));

            var dataset = new DataSet();

            dataset.Tables.Add(dataTable);

            dataTable = TestHelper.CreateBaseDataTable();

            dataTable.Rows.Add(TestHelper.CreateRow(dataTable, "UTILITY", "12345", string.Empty, DateTime.Today));

            dataset.Tables.Add(dataTable);

            //Act
            var result = FileReader.HasDuplicateAccounts(dataset);

            //Assert
            Assert.IsTrue(result);
        }

        [TestMethod]
        public void HasDuplicateAccountsInMultipleTabsIsFalse()
        {
            //Arrange
            var dataTable = TestHelper.CreateBaseDataTable();

            dataTable.Rows.Add(TestHelper.CreateRow(dataTable, "UTILITY", "12345", string.Empty, DateTime.Today));

            var dataset = new DataSet();

            dataset.Tables.Add(dataTable);

            dataTable = TestHelper.CreateBaseDataTable();

            dataTable.Rows.Add(TestHelper.CreateRow(dataTable, "UTILITY", "12346", string.Empty, DateTime.Today));

            dataset.Tables.Add(dataTable);

            //Act
            var result = FileReader.HasDuplicateAccounts(dataset);

            //Assert
            Assert.IsFalse(result);
        }

        [TestMethod]
        public void CheckForDuplicateAccountsInTab()
		{
			//Arrange
			var dataTable = TestHelper.CreateBaseDataTable();

			dataTable.Rows.Add(TestHelper.CreateRow( dataTable, "UTILITY", "12345", string.Empty, DateTime.Today ));
			dataTable.Rows.Add( TestHelper.CreateRow( dataTable, "UTILITY", "12345", string.Empty, DateTime.Today ) );

			//Act
            FileReader.CheckForDuplicateAccountsInTab(dataTable);

			//Assert
		}

        [TestMethod, ExpectedException(typeof(IdrFileProcessingException))]
        public void CheckForDuplicateAccountsInTabFail()
        {
            //Arrange
            var dataTable = TestHelper.CreateBaseDataTable();

            dataTable.Rows.Add(TestHelper.CreateRow(dataTable, "UTILITY", "12345", string.Empty, DateTime.Today));
            dataTable.Rows.Add(TestHelper.CreateRow(dataTable, "UTILITY", "12456", string.Empty, DateTime.Today));

            //Act
            FileReader.CheckForDuplicateAccountsInTab(dataTable);

            //Assert
        }

		[TestMethod]
		public void ProcessDataSheetInvalidAccountUtility()
		{
			//Arrange
			const string accountNumber = "123";
			const string utility = "UTILITY"; //Unknown utility. Will fail.
			var dataTable = TestHelper.CreateBaseDataTable();

			dataTable.Rows.Add( TestHelper.CreateRow( dataTable, utility, accountNumber, string.Empty, DateTime.Today ) );

			var fileLog = new IdrFileLogHeader();
			var fileDetail = new IdrFileLogDetail { IdrFileLogHeader = fileLog };

			//Act
			var fileLogDetail = FileReader.ProcessDataSheet(fileDetail, dataTable, "user");

			//Assert
			Assert.IsNotNull(fileLogDetail);
			Assert.IsTrue(fileLogDetail.Status == (byte)FileStatus.Failure);

			//Even when it failed, it should get the account number and utility code.
			Assert.AreEqual(accountNumber, fileLogDetail.AccountNumber);
			Assert.AreEqual( utility, fileLogDetail.UtilityCode );

			//Verify error and summary messages
			Assert.AreEqual("Account number does not match the utility specification, or utility not found. Tab not processed.", fileLogDetail.Information );
			Assert.AreEqual( "Account number or utility mismatch. ", fileLog.Notes);
		}

		[TestMethod]
		public void ProcessDataSheetNotEnoughData()
		{
			//Arrange
			const string accountNumber = "1003151032";
			const string utility = "COMED";
			var dataTable = TestHelper.CreateBaseDataTable();

			dataTable.Rows.Add( TestHelper.CreateRow( dataTable, utility, accountNumber, string.Empty, DateTime.Today ) );

			var fileLog = new IdrFileLogHeader();
			var fileDetail = new IdrFileLogDetail { IdrFileLogHeader = fileLog };

			//Act
			var fileLogDetail = FileReader.ProcessDataSheet( fileDetail, dataTable, "user" );

			//Assert
			Assert.IsNotNull( fileLogDetail );
			Assert.IsTrue( fileLogDetail.Status == (byte) FileStatus.Failure );

			//Even when it failed, it should get the account number and utility code.
			Assert.AreEqual( accountNumber, fileLogDetail.AccountNumber );
			Assert.AreEqual( utility, fileLogDetail.UtilityCode );

			//Verify error and summary messages
			Assert.AreEqual( "There are less than 365 days' worth of IDR Data.", fileLogDetail.Information );
			Assert.AreEqual( "Not enough IDR Data. ", fileLog.Notes );
		}

		[TestMethod]
		public void ProcessDataSheetNegativeNumbers()
		{
			//Arrange
			const string accountNumber = "1003151032";
			const string utility = "COMED";
			var dataTable = TestHelper.CreateBaseDataTable();

			for( var i = 0; i < 365; i++)
				dataTable.Rows.Add( TestHelper.CreateRow( dataTable, utility, accountNumber, string.Empty, DateTime.Today ) );

			//Negative value as part of data.
			dataTable.Rows[10][15] = -1;

			var fileLog = new IdrFileLogHeader();
			var fileDetail = new IdrFileLogDetail { IdrFileLogHeader = fileLog };

			//Act
			var fileLogDetail = FileReader.ProcessDataSheet( fileDetail, dataTable, "user" );

			//Assert
			Assert.IsNotNull( fileLogDetail );
			Assert.IsTrue( fileLogDetail.Status == (byte) FileStatus.Failure );

			//Even when it failed, it should get the account number and utility code.
			Assert.AreEqual( accountNumber, fileLogDetail.AccountNumber );
			Assert.AreEqual( utility, fileLogDetail.UtilityCode );

			//Verify error and summary messages
			Assert.AreEqual( "A Negative value was found in row: 11.", fileLogDetail.Information );
			Assert.AreEqual( "Negative Value(s). ", fileLog.Notes );
		}

		[TestMethod]
		public void ProcessDataSheetInvalidUnit()
		{
			//Arrange
			const string accountNumber = "1003151032";
			const string utility = "COMED";
			var dataTable = TestHelper.CreateBaseDataTable();

			for( var i = 0; i < 365; i++ )
				dataTable.Rows.Add( TestHelper.CreateRow( dataTable, utility, accountNumber, string.Empty, DateTime.Today ) );

			//Blank utility.
			dataTable.Rows[10][4] = "";

			var fileLog = new IdrFileLogHeader();
			var fileDetail = new IdrFileLogDetail { IdrFileLogHeader = fileLog };

			//Act
			var fileLogDetail = FileReader.ProcessDataSheet( fileDetail, dataTable, "user" );

			//Assert
			Assert.IsNotNull( fileLogDetail );
			Assert.IsTrue( fileLogDetail.Status == (byte) FileStatus.Failure );

			//Even when it failed, it should get the account number and utility code.
			Assert.AreEqual( accountNumber, fileLogDetail.AccountNumber );
			Assert.AreEqual( utility, fileLogDetail.UtilityCode );

			//Verify error and summary messages
			Assert.AreEqual( "Invalid unit of measurement found in 8760 Excel Sheet. Tab not processed.", fileLogDetail.Information );
			Assert.AreEqual( "Invalid unit of measurement. ", fileLog.Notes );
		}

		[TestMethod]
		public void ProcessDataSheetInvalidAccount()
		{
			//Arrange
			const string accountNumber = "1003151032";
			const string utility = "COMED";
			var dataTable = TestHelper.CreateBaseDataTable();

			for( var i = 0; i < 365; i++ )
				dataTable.Rows.Add( TestHelper.CreateRow( dataTable, utility, accountNumber, string.Empty, DateTime.Today ) );

			//Blank acccount number.
			dataTable.Rows[10][1] = null;

			var fileLog = new IdrFileLogHeader();
			var fileDetail = new IdrFileLogDetail { IdrFileLogHeader = fileLog };

			//Act
			var fileLogDetail = FileReader.ProcessDataSheet( fileDetail, dataTable, "user" );

			//Assert
			Assert.IsNotNull( fileLogDetail );
			Assert.IsTrue( fileLogDetail.Status == (byte) FileStatus.Failure );

			Assert.IsNull( fileLogDetail.AccountNumber );
			Assert.IsNull( fileLogDetail.UtilityCode );

			//Verify error and summary messages
			Assert.AreEqual( "Blank account number was found on this sheet. Tab not processed.", fileLogDetail.Information );
			Assert.AreEqual( "Blank Account Number. ", fileLog.Notes );
		}

		[TestMethod]
		public void ProcessDataSheetInvalidUtility()
		{
			//Arrange
			const string accountNumber = "1003151032";
			const string utility = "COMED";
			var dataTable = TestHelper.CreateBaseDataTable();

			for( var i = 0; i < 365; i++ )
				dataTable.Rows.Add( TestHelper.CreateRow( dataTable, utility, accountNumber, string.Empty, DateTime.Today ) );

			//Blank utility.
			dataTable.Rows[10][0] = null;

			var fileLog = new IdrFileLogHeader();
			var fileDetail = new IdrFileLogDetail { IdrFileLogHeader = fileLog };

			//Act
			var fileLogDetail = FileReader.ProcessDataSheet( fileDetail, dataTable, "user" );

			//Assert
			Assert.IsNotNull( fileLogDetail );
			Assert.IsTrue( fileLogDetail.Status == (byte) FileStatus.Failure );

			Assert.IsNull( fileLogDetail.AccountNumber );
			Assert.IsNull( fileLogDetail.UtilityCode );

			//Verify error and summary messages
			Assert.AreEqual( "Blank utility was found on this sheet. Tab not processed.", fileLogDetail.Information );
			Assert.AreEqual( "Blank Utility. ", fileLog.Notes );
		}

		[TestMethod]
		public void ProcessDataSheetInvalidFileTemplate()
		{
			//Arrange
			const string accountNumber = "1003151032";
			const string utility = "COMED";
			var dataTable = TestHelper.CreateBaseDataTable();

			for( var i = 0; i < 365; i++ )
				dataTable.Rows.Add( TestHelper.CreateRow( dataTable, utility, accountNumber, string.Empty, DateTime.Today ) );

			//Change one column name to break the template.
			dataTable.Rows[0][10] = "Some other column";

			var fileLog = new IdrFileLogHeader();
			var fileDetail = new IdrFileLogDetail { IdrFileLogHeader = fileLog };

			//Act
			var fileLogDetail = FileReader.ProcessDataSheet( fileDetail, dataTable, "user" );

			//Assert
			Assert.IsNotNull( fileLogDetail );
			Assert.IsTrue( fileLogDetail.Status == (byte) FileStatus.Failure );

			Assert.IsNull( fileLogDetail.AccountNumber );
			Assert.IsNull( fileLogDetail.UtilityCode );

			//Verify error and summary messages
			Assert.AreEqual( "Invalid template is used. Please check column name or column order. Tab not processed.", fileLogDetail.Information );
			Assert.AreEqual( "Invalid template. ", fileLog.Notes );
		}

		[TestMethod]
		public void ProcessDataSheetInvalidInterval()
		{
			//Arrange
			const string accountNumber = "1503151033";
			const string utility = "COMED";
			var dataTable = TestHelper.CreateBaseDataTable();

			for( var i = 0; i < 365; i++ )
				dataTable.Rows.Add( TestHelper.CreateRow( dataTable, utility, accountNumber, string.Empty, DateTime.Today ) );

			var fileLog = new IdrFileLogHeader();
			var fileDetail = new IdrFileLogDetail { IdrFileLogHeader = fileLog };

			//Act
			var fileLogDetail = FileReader.ProcessDataSheet( fileDetail, dataTable, "user" );

			//Assert
			Assert.IsNotNull( fileLogDetail );

			//Even when it failed, it should get the account number and utility code.
			Assert.AreEqual( accountNumber, fileLogDetail.AccountNumber );
			Assert.AreEqual( utility, fileLogDetail.UtilityCode );
		}
	}
}
