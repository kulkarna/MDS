using System;
using System.Collections.Generic;
using LibertyPower.Business.MarketManagement.IdrUsageManagement;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace IdrUsageTests.Parsers
{
	[TestClass]
	public class IdrRawDataTestFixture
	{
		[TestMethod, ExpectedException(typeof(Exception))]
		public void MergeFailByDifferentAccountNumbers()
		{
			//Arrange
			var data1 = new IdrRawData { Account = "123", UtilityCode = "ABC" };
			var data2 = new IdrRawData { Account = "124", UtilityCode = "ABC" }; 

			//Act
			data1.Merge( data2 );

			//Assert. Will fail.
		}

		[TestMethod, ExpectedException( typeof( Exception ) )]
		public void MergeFailByDifferentUtilityCode()
		{
			//Arrange
			var data1 = new IdrRawData { Account = "123", UtilityCode = "ABC" };
			var data2 = new IdrRawData { Account = "123", UtilityCode = "ABD" };

			//Act
			data1.Merge( data2 );

			//Assert. Will fail.
		}

		[TestMethod]
		public void MergeTwoEmptySets()
		{
			//Arrange
			var data1 = new IdrRawData { Account = "123", UtilityCode = "ABC", Data = new List<IdrDataEntry>() };
			var data2 = new IdrRawData { Account = "123", UtilityCode = "ABC", Data = new List<IdrDataEntry>() };

			//Act
			data1.Merge( data2 );

			//Assert.
			Assert.IsNotNull(data1.Data);
			Assert.AreEqual(0, data1.Data.Count);
		}

		[TestMethod]
		public void MergeWithFirstBeingEmptySet()
		{
			//Arrange
			var data1 = new IdrRawData { Account = "123", UtilityCode = "ABC", Data = new List<IdrDataEntry>() };
			var data2 = new IdrRawData { Account = "123", UtilityCode = "ABC", Data = new List<IdrDataEntry> 
				{ 
					new IdrDataEntry { Date = new DateTime(2012, 1, 1) }, 
					new IdrDataEntry { Date = new DateTime(2012, 1, 2) }, 
					new IdrDataEntry { Date = new DateTime(2012, 1, 3) }, 
					new IdrDataEntry { Date = new DateTime(2012, 1, 4) }
				}};

			//Act
			data1.Merge( data2 );

			//Assert.
			Assert.IsNotNull( data1.Data );
			Assert.AreEqual( 4, data1.Data.Count );
			Assert.AreEqual( new DateTime( 2012, 1, 1 ), data1.Data[0].Date );
			Assert.AreEqual( new DateTime( 2012, 1, 2 ), data1.Data[1].Date );
			Assert.AreEqual( new DateTime( 2012, 1, 3 ), data1.Data[2].Date );
			Assert.AreEqual( new DateTime( 2012, 1, 4 ), data1.Data[3].Date );
		}

		[TestMethod]
		public void MergeSecondFirstBeingEmptySet()
		{
			//Arrange
			var data1 = new IdrRawData
			{
				Account = "123",
				UtilityCode = "ABC",
				Data = new List<IdrDataEntry> 
				{ 
					new IdrDataEntry { Date = new DateTime(2012, 1, 1) }, 
					new IdrDataEntry { Date = new DateTime(2012, 1, 2) }, 
					new IdrDataEntry { Date = new DateTime(2012, 1, 3) }, 
					new IdrDataEntry { Date = new DateTime(2012, 1, 4) }
				}
			};
			var data2 = new IdrRawData { Account = "123", UtilityCode = "ABC", Data = new List<IdrDataEntry>() };

			//Act
			data1.Merge( data2 );

			//Assert.
			Assert.IsNotNull( data1.Data );
			Assert.AreEqual( 4, data1.Data.Count );
			Assert.AreEqual( new DateTime( 2012, 1, 1 ), data1.Data[0].Date );
			Assert.AreEqual( new DateTime( 2012, 1, 2 ), data1.Data[1].Date );
			Assert.AreEqual( new DateTime( 2012, 1, 3 ), data1.Data[2].Date );
			Assert.AreEqual( new DateTime( 2012, 1, 4 ), data1.Data[3].Date );
		}

		[TestMethod]
		public void MergeFirstSetEarlyTestPrecedenceOfSecondSet()
		{
			//Arrange
			var data1 = new IdrRawData
			{
				Account = "123",
				UtilityCode = "ABC",
				Data = new List<IdrDataEntry> 
				{ 
					new IdrDataEntry { Date = new DateTime(2012, 1, 1), Values = new List<decimal?> { 1 } }, 
					new IdrDataEntry { Date = new DateTime(2012, 1, 2), Values = new List<decimal?> { 2 } }, 
					new IdrDataEntry { Date = new DateTime(2012, 1, 3), Values = new List<decimal?> { 2 } }, 
					new IdrDataEntry { Date = new DateTime(2012, 1, 4), Values = new List<decimal?> { 2 } }
				}
			};
			var data2 = new IdrRawData
			{
				Account = "123",
				UtilityCode = "ABC",
				Data = new List<IdrDataEntry> 
				{ 
					new IdrDataEntry { Date = new DateTime(2012, 1, 3), Values = new List<decimal?> { 3 } }, 
					new IdrDataEntry { Date = new DateTime(2012, 1, 4), Values = new List<decimal?> { 4 } }, 
					new IdrDataEntry { Date = new DateTime(2012, 1, 5), Values = new List<decimal?> { 5 } }, 
					new IdrDataEntry { Date = new DateTime(2012, 1, 6), Values = new List<decimal?> { 6 } }
				}
			};


			//Act
			data1.Merge( data2 );

			//Assert.
			Assert.IsNotNull( data1.Data );
			Assert.AreEqual( 6, data1.Data.Count );
			Assert.AreEqual( new DateTime( 2012, 1, 1 ), data1.Data[0].Date );
			Assert.AreEqual( new DateTime( 2012, 1, 2 ), data1.Data[1].Date );
			Assert.AreEqual( new DateTime( 2012, 1, 3 ), data1.Data[2].Date );
			Assert.AreEqual( new DateTime( 2012, 1, 4 ), data1.Data[3].Date );
			Assert.AreEqual( new DateTime( 2012, 1, 5 ), data1.Data[4].Date );
			Assert.AreEqual( new DateTime( 2012, 1, 6 ), data1.Data[5].Date );

			for (var i = 0; i < data1.Data.Count; i++ )
				Assert.AreEqual(i + 1M, data1.Data[i].Values[0]);
		}

		[TestMethod]
		public void MergeSecondSetEarlyTestPrecedenceOfSecondSet()
		{
			//Arrange
			var data1 = new IdrRawData
			{
				Account = "123",
				UtilityCode = "ABC",
				Data = new List<IdrDataEntry> 
				{ 
					new IdrDataEntry { Date = new DateTime(2012, 1, 3), Values = new List<decimal?> { 1 } }, 
					new IdrDataEntry { Date = new DateTime(2012, 1, 4), Values = new List<decimal?> { 1 } }, 
					new IdrDataEntry { Date = new DateTime(2012, 1, 5), Values = new List<decimal?> { 5 } }, 
					new IdrDataEntry { Date = new DateTime(2012, 1, 6), Values = new List<decimal?> { 6 } }
				}
			};

			var data2 = new IdrRawData
			{
				Account = "123",
				UtilityCode = "ABC",
				Data = new List<IdrDataEntry> 
				{ 
					new IdrDataEntry { Date = new DateTime(2012, 1, 1), Values = new List<decimal?> { 1 } }, 
					new IdrDataEntry { Date = new DateTime(2012, 1, 2), Values = new List<decimal?> { 2 } }, 
					new IdrDataEntry { Date = new DateTime(2012, 1, 3), Values = new List<decimal?> { 3 } }, 
					new IdrDataEntry { Date = new DateTime(2012, 1, 4), Values = new List<decimal?> { 4 } }
				}
			};

			//Act
			data1.Merge( data2 );

			//Assert.
			Assert.IsNotNull( data1.Data );
			Assert.AreEqual( 6, data1.Data.Count );
			Assert.AreEqual( new DateTime( 2012, 1, 1 ), data1.Data[0].Date );
			Assert.AreEqual( new DateTime( 2012, 1, 2 ), data1.Data[1].Date );
			Assert.AreEqual( new DateTime( 2012, 1, 3 ), data1.Data[2].Date );
			Assert.AreEqual( new DateTime( 2012, 1, 4 ), data1.Data[3].Date );
			Assert.AreEqual( new DateTime( 2012, 1, 5 ), data1.Data[4].Date );
			Assert.AreEqual( new DateTime( 2012, 1, 6 ), data1.Data[5].Date );

			for( var i = 0; i < data1.Data.Count; i++ )
				Assert.AreEqual( i + 1M, data1.Data[i].Values[0] );
		}
	}
}