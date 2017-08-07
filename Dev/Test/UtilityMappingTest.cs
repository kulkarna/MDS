namespace FrameworkTest
{

	using System;
	using System.IO;
	using System.Text;
	using System.Data;
	using System.Data.SqlClient;
	using System.Collections;
	using System.Linq;
	using System.Collections.Generic;
	using LibertyPower.DataAccess.WorkbookAccess;
	using LibertyPower.Business.MarketManagement.UsageManagement;
	using Microsoft.VisualStudio.TestTools.UnitTesting;
	using LibertyPower.Business.MarketManagement.UtilityManagement;
	using LibertyPower.Business.CommonBusiness.TimeSeries;
	using LibertyPower.Business.CustomerAcquisition.RateManagement;
	using System.Diagnostics;

	/// <summary>
	///This is a test class for UsageFactoryTest and is intended
	///to contain all UsageFactoryTest Unit Tests
	///</summary>
	[TestClass()]
	public class UtilityMappingTest
	{
		[TestMethod()]
		public void UtilityMappingTest_1()
		{
			var mapping = UtilityMappingFactory.GetUtilityMapping();

			//var listDeterminants = UtilityMappingFactory.GetUtilityClassMappingDeterminants("AMEREN");
			//var listResultants = UtilityMappingFactory.GetUtilityClassMappingResultants(0);
			//Assert.IsTrue(listResultants != null);
			//Given an AccountVO object and a utilityMap, and a webAccount object, reassign the appropriate fields in the
			//AccountVO object
		}

		#region ERCOT Curve Test

		[TestMethod()]
		public void TestErcot()
		{
			//// Load Entire Account Profile Map
			ErcotAccountProfileMapCollection _accounts = VariableRateDeterminantsFactory.GetErcotAccountProfileMapCollection();
			Assert.IsTrue( _accounts.Count > 0 );

			// Load  Account Profile Map by account number (ESSID)
			//ErcotAccountProfileMapCollection _accountsByAccountNumber = VariableRateDeterminantsFactory.GetErcotAccountProfileMapCollectionByAccountNumber( "1008901010537342070100" );
			//Assert.IsTrue( _accountsByAccountNumber.Count > 0 );

			//string profileID = _accountsByAccountNumber[0].ProfileID;
			//string zoneID = _accountsByAccountNumber[0].ZoneID;

			// Test 3 methods on account profile collection
			string profileID = _accounts.GetProfileID( "10032789478547251" );
			string zoneID = _accounts.GetZoneID( "10032789478547251" );
			string lossCode = _accounts.GetLossCodeID( "10032789478547251" );

			//Assert.IsFalse(string.IsNullOrEmpty(_profileID));
			//Assert.IsFalse(string.IsNullOrEmpty(_zoneID));
			//Assert.IsFalse(string.IsNullOrEmpty(_lossCode));
			DateTime start = new DateTime( 2011, 1, 2 );
			DateTime end = new DateTime( 2011, 3, 4 );
			// Price collection
			ErcotPriceCollection _ercotPrices = VariableRateDeterminantsFactory.GetErcotPrices( start, end );
			Assert.IsTrue( _ercotPrices.Count > 0 );

			TimeSeries _timeSeries = new TimeSeries();
			_timeSeries = VariableRateDeterminantsFactory.GetErcotPriceDataByZone( zoneID, start, end, _ercotPrices );
			Assert.IsTrue( _timeSeries.Count > 0 );

			// Load Interval profile collection
			ErcotIntervalProfileCollection _ercotIntervalProfiles = VariableRateDeterminantsFactory.GetErcotIntervalProfiles( start, end );
			Assert.IsTrue( _ercotIntervalProfiles.Count > 0 );

			TimeSeries _timeSeries2 = new TimeSeries();
			_timeSeries2 = VariableRateDeterminantsFactory.GetErcotIntervalProfileDataByProfile( profileID, start, end, _ercotIntervalProfiles );
			Assert.IsTrue( _timeSeries2.Count > 0 );

			// Load Hub collection
			ErcotHubPriceCollection _ercotHubPrices = VariableRateDeterminantsFactory.GetErcotHubPrices( start, end );
			Assert.IsTrue( _ercotHubPrices.Count > 0 );

			TimeSeries _timeSeries3 = new TimeSeries();
			_timeSeries3 = VariableRateDeterminantsFactory.GetErcotHubPriceDataByZone( zoneID, start, end, _ercotHubPrices );
			Assert.IsTrue( _timeSeries3.Count > 0 );
			try
			{
				TimeSeries answer1 = _timeSeries + _timeSeries2;
				TimeSeries answer2 = answer1 + _timeSeries3;
			}
			catch( TimeSeriesException )
			{
				Assert.Fail();
			}
			Assert.IsTrue( true );
			//// Test Price By Zone collection method
			//ErcotPriceCollection _ercotPriceByZoneMapSubCollection = _ercotPriceByZoneMapCollection.FilterErcotPriceCollection("WEST", new DateTime(2011, 1, 1), new DateTime(2011, 3, 1));
			//// Test
			//ErcotIntervalProfileCollection _ercotIntervalProfileMapSubCollection = _ercotIntervalProfileMapCollection.FilterErcotIntervalProfileCollection("BUSMEDLF_SOUTH", new DateTime(2011, 1, 1), new DateTime(2011, 3, 1));
			//// Test
			//ErcotHubPriceCollection _ercotHubPriceByZoneMapSubCollection = _ercotHubPriceByZoneMapCollection.FilterErcotHubPriceCollection("WEST", new DateTime(2011, 1, 1), new DateTime(2011, 3, 1));

			//Assert.IsTrue(_ercotPriceByZoneMapSubCollection.Count > 0);
			//Assert.IsTrue(_ercotIntervalProfileMapSubCollection.Count > 0);
			//Assert.IsTrue(_ercotHubPriceByZoneMapSubCollection.Count > 0);


		}

		[TestMethod()]
		public void TestErcotWithVariousZonesAndProfiles()
		{

			#region Loading Various Accounts

			//// Load by Account number
			//// 1008901023818006250106 | HOUSTON | BUSHILF_COAST
			//ErcotAccountProfileMapCollection _accountsByAccountNumber = VariableRateDeterminantsFactory.GetErcotAccountProfileMapCollectionByAccountNumber( "1008901023818006250106" );
			//// 1008901020147763163100 | HOUSTON | BUSLOLF_COAST
			//ErcotAccountProfileMapCollection _accountsByAccountNumber = VariableRateDeterminantsFactory.GetErcotAccountProfileMapCollectionByAccountNumber( "1008901020147763163100" );
			//// 1008901009130030520100 | HOUSTON | BUSMEDLF_COAST
			//ErcotAccountProfileMapCollection _accountsByAccountNumber = VariableRateDeterminantsFactory.GetErcotAccountProfileMapCollectionByAccountNumber( "1008901009130030520100" );

			//// 10400512577570001 | NORTH | BUSLOLF_NCENT
			//ErcotAccountProfileMapCollection _accountsByAccountNumber = VariableRateDeterminantsFactory.GetErcotAccountProfileMapCollectionByAccountNumber( "10400512577570001" );
			//// 10443720004426970 | NORTH | BUSMEDLF_NCENT
			//ErcotAccountProfileMapCollection _accountsByAccountNumber = VariableRateDeterminantsFactory.GetErcotAccountProfileMapCollectionByAccountNumber( "10443720004426970" );
			//// 10443720008103872 | NORTH | BUSNODEM_EAST
			//ErcotAccountProfileMapCollection _accountsByAccountNumber = VariableRateDeterminantsFactory.GetErcotAccountProfileMapCollectionByAccountNumber( "10443720008103872" );

			//// 10032789469449660 | SOUTH | BUSHILF_SOUTH
			//ErcotAccountProfileMapCollection _accountsByAccountNumber = VariableRateDeterminantsFactory.GetErcotAccountProfileMapCollectionByAccountNumber( "10032789469449660" );
			//// 10032789460322710 | SOUTH | BUSLOLF_COAST
			//ErcotAccountProfileMapCollection _accountsByAccountNumber = VariableRateDeterminantsFactory.GetErcotAccountProfileMapCollectionByAccountNumber( "10032789460322710" );
			//// 10032789408180281 | SOUTH | BUSMEDLF_COAST
			//ErcotAccountProfileMapCollection _accountsByAccountNumber = VariableRateDeterminantsFactory.GetErcotAccountProfileMapCollectionByAccountNumber( "10032789408180281" );

			//// 10443720002192797 | WEST | BUSLOLF_NCENT
			//ErcotAccountProfileMapCollection _accountsByAccountNumber = VariableRateDeterminantsFactory.GetErcotAccountProfileMapCollectionByAccountNumber( "10443720002192797" );
			//// 10443720006014013 | WEST | BUSMEDLF_FWEST
			//ErcotAccountProfileMapCollection _accountsByAccountNumber = VariableRateDeterminantsFactory.GetErcotAccountProfileMapCollectionByAccountNumber( "10443720006014013" );
			//// 10443720005589095 | WEST | BUSMEDLF_NORTH
			//ErcotAccountProfileMapCollection _accountsByAccountNumber = VariableRateDeterminantsFactory.GetErcotAccountProfileMapCollectionByAccountNumber( "10443720005589095" );

			#endregion

			#region Load All Distinct Zones Collected from accounts and zones views

			List<string> zones = new List<string>();

			zones.Add( "AEN" );
			zones.Add( "CPS" );
			zones.Add( "HOUSTON" );
			zones.Add( "LCRA" );
			zones.Add( "MCPEL_H07" );
			zones.Add( "MCPEL_H08" );
			zones.Add( "MCPEL_H09" );
			zones.Add( "MCPEL_H10" );
			zones.Add( "MCPEL_N07" );
			zones.Add( "MCPEL_N08" );
			zones.Add( "MCPEL_N09" );
			zones.Add( "MCPEL_N10" );
			zones.Add( "MCPEL_S07" );
			zones.Add( "MCPEL_S08" );
			zones.Add( "MCPEL_S09" );
			zones.Add( "MCPEL_S10" );
			zones.Add( "MCPEL_W07" );
			zones.Add( "MCPEL_W08" );
			zones.Add( "MCPEL_W09" );
			zones.Add( "MCPEL_W10" );
			zones.Add( "NORTH" );
			zones.Add( "RAYBN" );
			zones.Add( "SOUTH" );
			zones.Add( "WEST" );

			#endregion

			#region Load All Distinct Profiles Collected from accounts and profiles views

			List<string> profiles = new List<string>();

			profiles.Add( "BUSHILF_COAST" );
			profiles.Add( "BUSHILF_EAST" );
			profiles.Add( "BUSHILF_FWEST" );
			profiles.Add( "BUSHILF_NCENT" );
			profiles.Add( "BUSHILF_NORTH" );
			profiles.Add( "BUSHILF_SCENT" );
			profiles.Add( "BUSHILF_SOUTH" );
			profiles.Add( "BUSHILF_WEST" );
			profiles.Add( "BUSHIPV_COAST" );
			profiles.Add( "BUSHIPV_EAST" );
			profiles.Add( "BUSHIPV_FWEST" );
			profiles.Add( "BUSHIPV_NCENT" );
			profiles.Add( "BUSHIPV_NORTH" );
			profiles.Add( "BUSHIPV_SCENT" );
			profiles.Add( "BUSHIPV_SOUTH" );
			profiles.Add( "BUSHIPV_WEST" );
			profiles.Add( "BUSHIWD_COAST" );
			profiles.Add( "BUSHIWD_EAST" );
			profiles.Add( "BUSHIWD_FWEST" );
			profiles.Add( "BUSHIWD_NCENT" );
			profiles.Add( "BUSHIWD_NORTH" );
			profiles.Add( "BUSHIWD_SCENT" );
			profiles.Add( "BUSHIWD_SOUTH" );
			profiles.Add( "BUSHIWD_WEST" );
			profiles.Add( "BUSIDRRQ_COAST" );
			profiles.Add( "BUSIDRRQ_EAST" );
			profiles.Add( "BUSIDRRQ_FWEST" );
			profiles.Add( "BUSIDRRQ_NCENT" );
			profiles.Add( "BUSIDRRQ_NORTH" );
			profiles.Add( "BUSIDRRQ_SCENT" );
			profiles.Add( "BUSIDRRQ_SOUTH" );
			profiles.Add( "BUSIDRRQ_WEST" );
			profiles.Add( "BUSLOLF_COAST" );
			profiles.Add( "BUSLOLF_EAST" );
			profiles.Add( "BUSLOLF_FWEST" );
			profiles.Add( "BUSLOLF_NCENT" );
			profiles.Add( "BUSLOLF_NORTH" );
			profiles.Add( "BUSLOLF_SCENT" );
			profiles.Add( "BUSLOLF_SOUTH" );
			profiles.Add( "BUSLOLF_WEST" );
			profiles.Add( "BUSLOPV_COAST" );
			profiles.Add( "BUSLOPV_EAST" );
			profiles.Add( "BUSLOPV_FWEST" );
			profiles.Add( "BUSLOPV_NCENT" );
			profiles.Add( "BUSLOPV_NORTH" );
			profiles.Add( "BUSLOPV_SCENT" );
			profiles.Add( "BUSLOPV_SOUTH" );
			profiles.Add( "BUSLOPV_WEST" );
			profiles.Add( "BUSLOWD_COAST" );
			profiles.Add( "BUSLOWD_EAST" );
			profiles.Add( "BUSLOWD_FWEST" );
			profiles.Add( "BUSLOWD_NCENT" );
			profiles.Add( "BUSLOWD_NORTH" );
			profiles.Add( "BUSLOWD_SCENT" );
			profiles.Add( "BUSLOWD_SOUTH" );
			profiles.Add( "BUSLOWD_WEST" );
			profiles.Add( "BUSMEDLF_COAST" );
			profiles.Add( "BUSMEDLF_EAST" );
			profiles.Add( "BUSMEDLF_FWEST" );
			profiles.Add( "BUSMEDLF_NCENT" );
			profiles.Add( "BUSMEDLF_NORTH" );
			profiles.Add( "BUSMEDLF_SCENT" );
			profiles.Add( "BUSMEDLF_SOUTH" );
			profiles.Add( "BUSMEDLF_WEST" );
			profiles.Add( "BUSMEDPV_COAST" );
			profiles.Add( "BUSMEDPV_EAST" );
			profiles.Add( "BUSMEDPV_FWEST" );
			profiles.Add( "BUSMEDPV_NCENT" );
			profiles.Add( "BUSMEDPV_NORTH" );
			profiles.Add( "BUSMEDPV_SCENT" );
			profiles.Add( "BUSMEDPV_SOUTH" );
			profiles.Add( "BUSMEDPV_WEST" );
			profiles.Add( "BUSMEDWD_COAST" );
			profiles.Add( "BUSMEDWD_EAST" );
			profiles.Add( "BUSMEDWD_FWEST" );
			profiles.Add( "BUSMEDWD_NCENT" );
			profiles.Add( "BUSMEDWD_NORTH" );
			profiles.Add( "BUSMEDWD_SCENT" );
			profiles.Add( "BUSMEDWD_SOUTH" );
			profiles.Add( "BUSMEDWD_WEST" );
			profiles.Add( "BUSNODEM_COAST" );
			profiles.Add( "BUSNODEM_EAST" );
			profiles.Add( "BUSNODEM_FWEST" );
			profiles.Add( "BUSNODEM_NCENT" );
			profiles.Add( "BUSNODEM_NORTH" );
			profiles.Add( "BUSNODEM_SCENT" );
			profiles.Add( "BUSNODEM_SOUTH" );
			profiles.Add( "BUSNODEM_WEST" );
			profiles.Add( "BUSNODPV_COAST" );
			profiles.Add( "BUSNODPV_EAST" );
			profiles.Add( "BUSNODPV_FWEST" );
			profiles.Add( "BUSNODPV_NCENT" );
			profiles.Add( "BUSNODPV_NORTH" );
			profiles.Add( "BUSNODPV_SCENT" );
			profiles.Add( "BUSNODPV_SOUTH" );
			profiles.Add( "BUSNODPV_WEST" );
			profiles.Add( "BUSNODWD_COAST" );
			profiles.Add( "BUSNODWD_EAST" );
			profiles.Add( "BUSNODWD_FWEST" );
			profiles.Add( "BUSNODWD_NCENT" );
			profiles.Add( "BUSNODWD_NORTH" );
			profiles.Add( "BUSNODWD_SCENT" );
			profiles.Add( "BUSNODWD_SOUTH" );
			profiles.Add( "BUSNODWD_WEST" );
			profiles.Add( "BUSOGFLT_COAST" );
			profiles.Add( "BUSOGFLT_EAST" );
			profiles.Add( "BUSOGFLT_FWEST" );
			profiles.Add( "BUSOGFLT_NCENT" );
			profiles.Add( "BUSOGFLT_NORTH" );
			profiles.Add( "BUSOGFLT_SCENT" );
			profiles.Add( "BUSOGFLT_SOUTH" );
			profiles.Add( "BUSOGFLT_WEST" );
			profiles.Add( "BUSOGFPV_COAST" );
			profiles.Add( "BUSOGFPV_EAST" );
			profiles.Add( "BUSOGFPV_FWEST" );
			profiles.Add( "BUSOGFPV_NCENT" );
			profiles.Add( "BUSOGFPV_NORTH" );
			profiles.Add( "BUSOGFPV_SCENT" );
			profiles.Add( "BUSOGFPV_SOUTH" );
			profiles.Add( "BUSOGFPV_WEST" );
			profiles.Add( "BUSOGFWD_COAST" );
			profiles.Add( "BUSOGFWD_EAST" );
			profiles.Add( "BUSOGFWD_FWEST" );
			profiles.Add( "BUSOGFWD_NCENT" );
			profiles.Add( "BUSOGFWD_NORTH" );
			profiles.Add( "BUSOGFWD_SCENT" );
			profiles.Add( "BUSOGFWD_SOUTH" );
			profiles.Add( "BUSOGFWD_WEST" );
			profiles.Add( "NMFLAT_COAST" );
			profiles.Add( "NMFLAT_EAST" );
			profiles.Add( "NMFLAT_FWEST" );
			profiles.Add( "NMFLAT_NCENT" );
			profiles.Add( "NMFLAT_NORTH" );
			profiles.Add( "NMFLAT_SCENT" );
			profiles.Add( "NMFLAT_SOUTH" );
			profiles.Add( "NMFLAT_WEST" );
			profiles.Add( "NMLIGHT_COAST" );
			profiles.Add( "NMLIGHT_EAST" );
			profiles.Add( "NMLIGHT_FWEST" );
			profiles.Add( "NMLIGHT_NCENT" );
			profiles.Add( "NMLIGHT_NORTH" );
			profiles.Add( "NMLIGHT_SCENT" );
			profiles.Add( "NMLIGHT_SOUTH" );
			profiles.Add( "NMLIGHT_WEST" );
			profiles.Add( "RESHIPV_COAST" );
			profiles.Add( "RESHIPV_EAST" );
			profiles.Add( "RESHIPV_FWEST" );
			profiles.Add( "RESHIPV_NCENT" );
			profiles.Add( "RESHIPV_NORTH" );
			profiles.Add( "RESHIPV_SCENT" );
			profiles.Add( "RESHIPV_SOUTH" );
			profiles.Add( "RESHIPV_WEST" );
			profiles.Add( "RESHIWD_COAST" );
			profiles.Add( "RESHIWD_EAST" );
			profiles.Add( "RESHIWD_FWEST" );
			profiles.Add( "RESHIWD_NCENT" );
			profiles.Add( "RESHIWD_NORTH" );
			profiles.Add( "RESHIWD_SCENT" );
			profiles.Add( "RESHIWD_SOUTH" );
			profiles.Add( "RESHIWD_WEST" );
			profiles.Add( "RESHIWR_COAST" );
			profiles.Add( "RESHIWR_EAST" );
			profiles.Add( "RESHIWR_FWEST" );
			profiles.Add( "RESHIWR_NCENT" );
			profiles.Add( "RESHIWR_NORTH" );
			profiles.Add( "RESHIWR_SCENT" );
			profiles.Add( "RESHIWR_SOUTH" );
			profiles.Add( "RESHIWR_WEST" );
			profiles.Add( "RESLOPV_COAST" );
			profiles.Add( "RESLOPV_EAST" );
			profiles.Add( "RESLOPV_FWEST" );
			profiles.Add( "RESLOPV_NCENT" );
			profiles.Add( "RESLOPV_NORTH" );
			profiles.Add( "RESLOPV_SCENT" );
			profiles.Add( "RESLOPV_SOUTH" );
			profiles.Add( "RESLOPV_WEST" );
			profiles.Add( "RESLOWD_COAST" );
			profiles.Add( "RESLOWD_EAST" );
			profiles.Add( "RESLOWD_FWEST" );
			profiles.Add( "RESLOWD_NCENT" );
			profiles.Add( "RESLOWD_NORTH" );
			profiles.Add( "RESLOWD_SCENT" );
			profiles.Add( "RESLOWD_SOUTH" );
			profiles.Add( "RESLOWD_WEST" );
			profiles.Add( "RESLOWR_COAST" );
			profiles.Add( "RESLOWR_EAST" );
			profiles.Add( "RESLOWR_FWEST" );
			profiles.Add( "RESLOWR_NCENT" );
			profiles.Add( "RESLOWR_NORTH" );
			profiles.Add( "RESLOWR_SCENT" );
			profiles.Add( "RESLOWR_SOUTH" );
			profiles.Add( "RESLOWR_WEST" );

			#endregion


			// Set Dates
			DateTime start = new DateTime( 2011, 1, 1 );
			DateTime end = new DateTime( 2011, 3, 27 );

			// Get all prices/interval profiles/hub prices
			ErcotPriceCollection _ercotPrices = VariableRateDeterminantsFactory.GetErcotPrices( start, end );
			ErcotIntervalProfileCollection _ercotIntervalProfiles = VariableRateDeterminantsFactory.GetErcotIntervalProfiles( start, end );
			ErcotHubPriceCollection _ercotHubPrices = VariableRateDeterminantsFactory.GetErcotHubPrices( start, end );

			Debug.WriteLine( "Ercot Prices Count: " + _ercotPrices.Count );
			Debug.WriteLine( "Ercot Interval Profile Count: " + _ercotIntervalProfiles.Count );
			Debug.WriteLine( "Ercot Hub Prices Count: " + _ercotHubPrices.Count );

			// Loop through each distinct zone/profile
			foreach( string zone in zones )
			{
				Debug.WriteLine( " Zone: " + zone );
				Debug.WriteLine( " ---------------------------" );

				foreach( string profile in profiles )
				{
					Debug.WriteLine( "  Profile: " + profile );
					Debug.WriteLine( "  ---------------------------" );

					TimeSeries _dayAheadTimeSeries = VariableRateDeterminantsFactory.GetErcotPriceDataByZone( zone, start, end, _ercotPrices );
					TimeSeries _intervalProfileTimeSeries = VariableRateDeterminantsFactory.GetErcotIntervalProfileDataByProfile( profile, start, end, _ercotIntervalProfiles );
					TimeSeries _hubPriceTimeSeries = VariableRateDeterminantsFactory.GetErcotHubPriceDataByZone( zone, start, end, _ercotHubPrices );

					Debug.WriteLine( "   _dayAheadTimeSeries Count: " + _dayAheadTimeSeries.Count );
					Debug.WriteLine( "   _intervalProfileTimeSeries Count: " + _intervalProfileTimeSeries.Count );
					Debug.WriteLine( "   _hubPriceTimeSeries Count: " + _hubPriceTimeSeries.Count );
					Debug.WriteLine( "" );

					// Verify Time series objects can be added together
					try
					{
						TimeSeries answer1 = null;
						TimeSeries answer2 = null;

						if( _dayAheadTimeSeries.Count > 0 && _intervalProfileTimeSeries.Count > 0 )
						{
							answer1 = _dayAheadTimeSeries + _intervalProfileTimeSeries;
							Debug.WriteLine( "    Answer1 computed. Count: " + answer1.Count );
						}

						if( answer1 != null && answer1.Count > 0 && _hubPriceTimeSeries.Count > 0 )
						{
							answer2 = answer1 + _hubPriceTimeSeries;
							Debug.WriteLine( "    Answer2 computed. Count: " + answer2.Count );
						}


					}
					catch( TimeSeriesException )
					{
						Assert.Fail();
					}
				}
			}






			Assert.IsTrue( true );
		}


		//private string sampleRoot = @"E:\DevRoot\SG2010\Framework\Source\LibertyPower_IT059\Test\Sample Files\";
		private string[] sampleFiles =
        {
                "UtilitiesAndZoneMapping-ProductionFromPricing.xlsx"
        };

		[TestMethod()]
		public void TestUtilitiesDeterminantsSaving()
		{

			//string fileName = sampleRoot + sampleFiles[0];

			//if( System.IO.File.Exists( fileName ) == false )
			//    return;

			//DataSet ds = LibertyPower.DataAccess.WorkbookAccess.ExcelAccess.GetWorkbook( fileName ); // TODO: Refactor to use GetWorkbookEx

			//Assert.IsNotNull( ds );

			//var error = "";

			//var metaMap = UtilityMappingFactory.ParseMappingDeterminants( ds, out error );

			//Assert.IsNotNull( metaMap );

			//UtilityMappingFactory.UpdateMappingDeterminants( metaMap );

		}
		#endregion
	}
}
