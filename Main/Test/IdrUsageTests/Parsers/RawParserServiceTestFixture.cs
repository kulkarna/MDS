using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using LibertyPower.Business.MarketManagement.IdrUsageManagement;
using LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers;

namespace IdrUsageTests.Parsers
{
	/// <summary>
	/// Summary description for RawParserServiceTestFixture
	/// </summary>
	[TestClass]
	public class RawParserServiceTestFixture
	{
		[TestMethod]
		public void ConvertTokWhWhenkWhDataIsFound()
		{
			//Arrange
			var data = new List<IdrRawData> { 
				new IdrRawData { Interval = 60, Data = new List<IdrDataEntry>
				{ 
					new IdrDataEntry { Unit = "kWh", Values = new List<decimal?> { 1, 2, 3, 4, 5, 6, 7, 8 } } ,
					new IdrDataEntry { Unit = "kW", Values = new List<decimal?> { -1, -2, -3, -4, -5, -6, -7, -8 } } } 
				} 
			};

			//Act
			var result = RawParserService.ConvertTokWh( data );

			//Assert
			Assert.IsNotNull( result );
			Assert.IsTrue(result.All(d => d.Data.All(e => e.Unit == "kWh")));
			Assert.IsTrue(result.All(d => d.Data.SelectMany(e => e.Values).All(v => v > 0)));
		}

		[TestMethod]
		public void ConvertTokWhWhenNokWhDataIsFound()
		{
			//Arrange
			var data = new List<IdrRawData> { 
				new IdrRawData { Interval = 30, Data = new List<IdrDataEntry>
				{ 
					new IdrDataEntry { Unit = "kW", Values = new List<decimal?> { 1, 1, 1, 1, 1, 1, 1, 1, 1 } } ,
					new IdrDataEntry { Unit = "kW", Values = new List<decimal?> { 1, 1, 1, 1, 1, 1, 1, 1, 1 } } } 
				} 
			};

			//Act
			var result = RawParserService.ConvertTokWh( data );

			//Assert
			Assert.IsNotNull( result );
			Assert.IsTrue( result.All( d => d.Data.All( e => e.Unit == "kWh" ) ) );
			Assert.IsTrue( result.All( d => d.Data.SelectMany( e => e.Values ).All( v => v == 0.5M ) ) ); // 30 * 1 / 60 = 0.5
		}

		[TestMethod]
		public void ConvertTokWhMultipleDataEntries()
		{
			//Arrange
			var data = new List<IdrRawData> { 
				new IdrRawData { Interval = 30, Data = new List<IdrDataEntry>
				{ 
					new IdrDataEntry { Unit = "kW", Values = new List<decimal?> { 1, 1, 1, 1, 1, 1, 1, 1, 1 } } } 
				},
				new IdrRawData { Interval = 30, Data = new List<IdrDataEntry>
				{ 
					new IdrDataEntry { Unit = "kWh", Values = new List<decimal?> { 0.5M, 0.5M, 0.5M, 0.5M, 0.5M, 0.5M, 0.5M, 0.5M, 0.5M } } } 
				} 
			};

			//Act
			var result = RawParserService.ConvertTokWh( data );

			//Assert
			Assert.IsNotNull( result );
			Assert.IsTrue( result.All( d => d.Data.All( e => e.Unit == "kWh" ) ) );
			Assert.IsTrue( result.All( d => d.Data.SelectMany( e => e.Values ).All( v => v == 0.5M ) ) ); // 30 * 1 / 60 = 0.5
		}

		[TestMethod]
		public void ConvertTokWhKeepNulls()
		{
			//Arrange
			var data = new List<IdrRawData> { 
				new IdrRawData { Interval = 30, Data = new List<IdrDataEntry>
				{ 
					new IdrDataEntry { Unit = "kW", Values = new List<decimal?> { 1, 1, 1, 1, null, 1, 1, null, 1 } } } 
				},
				new IdrRawData { Interval = 30, Data = new List<IdrDataEntry>
				{ 
					new IdrDataEntry { Unit = "kWh", Values = new List<decimal?> { 0.5M, null, 0.5M, null, 0.5M, 0.5M, 0.5M, 0.5M, 0.5M } } } 
				} 
			};

			//Act
			var result = RawParserService.ConvertTokWh( data );

			//Assert
			Assert.IsNotNull( result );
			Assert.IsTrue( result.All( d => d.Data.All( e => e.Unit == "kWh" ) ) );
			Assert.IsTrue( result.All( d => d.Data.SelectMany( e => e.Values ).All( v => v == 0.5M || v == null) ) ); // 30 * 1 / 60 = 0.5
			Assert.AreEqual(4,  result.Sum( d => d.Data.SelectMany( e => e.Values ).Count(v => v == null )) );
		}

		[TestMethod]
		public void ConvertTokWhNoValidConversionUnit()
		{
			//Arrange
			var data = new List<IdrRawData> { 
				new IdrRawData { Interval = 30, Data = new List<IdrDataEntry>
				{ 
					new IdrDataEntry { Unit = "kPower", Values = new List<decimal?> { 1, 1, 1, 1, null, 1, 1, null, 1 } } } 
				},
				new IdrRawData { Interval = 30, Data = new List<IdrDataEntry>
				{ 
					new IdrDataEntry { Unit = "kWh", Values = new List<decimal?> { 0.5M, null, 0.5M, null, 0.5M, 0.5M, 0.5M, 0.5M, 0.5M } } } 
				} 
			};

			//Act
			var result = RawParserService.ConvertTokWh( data );

			//Assert
			Assert.IsNotNull( result );
			Assert.IsTrue( result.All( d => d.Data.All( e => e.Unit == "kWh" ) ) );
			Assert.IsTrue( result.All( d => d.Data.SelectMany( e => e.Values ).All( v => v == 0.5M || v == null ) ) ); // 30 * 1 / 60 = 0.5

			//Ignore kPower entry. Don't know how to convert that.
			Assert.AreEqual( 1, result.Count );
			Assert.AreEqual( 2, result.Sum( d => d.Data.SelectMany( e => e.Values ).Count( v => v == null ) ) );
		}
	}
}