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
	using LibertyPower.Business.MarketManagement.UsageManagement;
	using Microsoft.VisualStudio.TestTools.UnitTesting;
	using LibertyPower.Business.MarketManagement.UtilityManagement;
	using LibertyPower.Business.CommonBusiness.TimeSeries;
	using LibertyPower.Business.CustomerAcquisition.RateManagement;
	using System.Diagnostics;
	using LibertyPower.Business.CommonBusiness.FileManager;
	using LibertyPower.Business.CustomerAcquisition.PricingConfiguration;
	using LibertyPower.DataAccess.WebServiceAccess.IstaWebService;

	/// <summary>
	///This is a test class for UsageFactoryTest and is intended
	///to contain all UsageFactoryTest Unit Tests
	///</summary>
	[TestClass()]
	public class UtilityMappingTest2
	{
		[TestMethod()]
		public void UtilityMappingImport()
		{

			var importFile = @"C:\DevRoot\SG2010\Framework\Source\LibertyPower_IT059\Test\Sample Files\UtilitiesAndZoneMapping.xlsx";
			var fileManager = FileManagerFactory.GetFileManager( "Test", "Utility Import", @"C:\Test\", 0 );
			var fileContext = fileManager.AddFile( importFile, false, 0 );

			ParserResult result = new ParserResult();

			FileParser utilityMappingFileParser = null;
			utilityMappingFileParser = VariableRateDeterminantsFactory.GetFileParser( PricingFileType.UtilityMapping, fileContext );
			utilityMappingFileParser.UserId = 0;
			utilityMappingFileParser.SaveToPermanentStorage = true;
			result = utilityMappingFileParser.ParseFile();

			FileParser zoneMappingFileParser = null;
			zoneMappingFileParser = VariableRateDeterminantsFactory.GetFileParser( PricingFileType.ZoneMapping, fileContext );
			zoneMappingFileParser.UserId = 0;
			zoneMappingFileParser.SaveToPermanentStorage = true;
			result = zoneMappingFileParser.ParseFile();



		}

		[TestMethod()]
		public void TestUtilityMapLoad()
		{
			UtilityClassMappingList utilityMap = UtilityMappingFactory.GetUtilityMapping();
			UtilityZoneMappingList zoneMap = UtilityMappingFactory.GetUtilityZoneMapping();
			Assert.IsTrue( utilityMap != null );
			Assert.IsTrue( zoneMap != null );
		}

		[TestMethod()]
		public void LossFactorZoneOverlap()
		{
			bool lossFactorIsMappedInUtilityClassMappingsForCONED = UtilityMappingFactory.IsLossFactorMappedInUtilityClassMappings( 18 );
			bool lossFactorIsMappedInUtilityZoneMappingsForCONED = UtilityMappingFactory.IsLossFactorMappedInUtilityZoneMappings( 18 );
			bool zoneIsMappedInUtilityClassMappingsForCONED = UtilityMappingFactory.IsZoneMappedInUtilityClassMappings( 18 );
			bool zoneIsMappedInUtilityZoneMappingsForCONED = UtilityMappingFactory.IsZoneMappedInUtilityZoneMappings( 18 );

			Assert.IsFalse( lossFactorIsMappedInUtilityClassMappingsForCONED );
			Assert.IsTrue( lossFactorIsMappedInUtilityZoneMappingsForCONED );
			Assert.IsFalse( zoneIsMappedInUtilityClassMappingsForCONED );
			Assert.IsTrue( zoneIsMappedInUtilityZoneMappingsForCONED );

			bool lossFactorIsMappedInUtilityClassMappingsForNYSEG = UtilityMappingFactory.IsLossFactorMappedInUtilityClassMappings( 30 );
			bool lossFactorIsMappedInUtilityZoneMappingsForNYSEG = UtilityMappingFactory.IsLossFactorMappedInUtilityZoneMappings( 30 );
			bool zoneIsMappedInUtilityClassMappingsForNYSEG = UtilityMappingFactory.IsZoneMappedInUtilityClassMappings( 30 );
			bool zoneIsMappedInUtilityZoneMappingsForNYSEG = UtilityMappingFactory.IsZoneMappedInUtilityZoneMappings( 30 );

			Assert.IsTrue( lossFactorIsMappedInUtilityClassMappingsForNYSEG );
			Assert.IsFalse( lossFactorIsMappedInUtilityZoneMappingsForNYSEG );
			Assert.IsFalse( zoneIsMappedInUtilityClassMappingsForNYSEG );
			Assert.IsTrue( zoneIsMappedInUtilityZoneMappingsForNYSEG );

			bool lossFactorIsMappedInUtilityClassMappingsForRGE = UtilityMappingFactory.IsLossFactorMappedInUtilityClassMappings( 39 );
			bool lossFactorIsMappedInUtilityZoneMappingsForRGE = UtilityMappingFactory.IsLossFactorMappedInUtilityZoneMappings( 39 );
			bool zoneIsMappedInUtilityClassMappingsForRGE = UtilityMappingFactory.IsZoneMappedInUtilityClassMappings( 39 );
			bool zoneIsMappedInUtilityZoneMappingsForRGE = UtilityMappingFactory.IsZoneMappedInUtilityZoneMappings( 39 );

			Assert.IsTrue( lossFactorIsMappedInUtilityClassMappingsForRGE );
			Assert.IsFalse( lossFactorIsMappedInUtilityZoneMappingsForRGE );
			Assert.IsFalse( zoneIsMappedInUtilityClassMappingsForRGE );
			Assert.IsTrue( zoneIsMappedInUtilityZoneMappingsForRGE );

		}

		[TestMethod()]
		public void TestGetAccounts()
		{
			//string accounts = "10032789499674140,10032789435354411,10032789484627292,10032789408664741,10032789470151102,10032789470151103,10032789493619096,10032789472130151,10032789476129600,10032789498628116,10032789412795049,10032789417920651,10032789485862660,10032789484737095,10032789440358790,10032789430580528,10032789454678161,10032789446998630,10032789403004092,10032789423361740,10032789464766975,10032789438000541,10032789457270940,10032789452255580,10032789493462805,10032789464227512,10032789406862700,10032789492853750,10032789492853751,10032789496915411,10032789404029112,10032789455855921,10032789455855920,10032789438062700,10032789495989200,10032789493020671,10032789405621630,10032789486547121,10032789418161400,10032789437273478,10032789493682855,10032789488871732,10032789499301125,10032789423911661,10032789425083371,10032789471965651,10032789439949281,10032789423075950,10032789473141631,10032789450130380,10032789410103660,10032789474692671,10032789461926560,10032789428795871,10032789411818330,10204049762242470,1020404976211458,"; // 57
			//string utilities = "AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,AEPNO,AEPNO,";

			// 1020404976211458 is not found
			//string accounts = "10032789411818330,10204049762242470,1020404976211458,10032789499674140,";
			//string utilities = "AEPCE,AEPNO,AEPNO,AEPCE,";

			//string accounts = "10032789499674140,10032789435354411,10032789484627292,10032789408664741,10032789470151102,10032789470151103,10032789493619096,10032789472130151,10032789476129600,10032789498628116,";
			//string utilities = "AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,AEPCE,";

			//string accounts = "10032789499674140,";
			//string utilities = "AEPCE,";


			//DataSet ds;
			//ds = LibertyPower.DataAccess.SqlAccess.LibertyPowerSql.LibertyPowerSql.GetAccounts( accounts, utilities );
		}

		[TestMethod()]
		public void TestIstaRateUpdate()
		{
			RateService.UpdateCustomerRate( "10032789495989200", "AEPCE", ProductPlanType.BlockIndexed, 0.0435133343M, 0M, new DateTime( 2011, 1, 17 ), new DateTime( 2011, 2, 17 ) );
		}
	}
}
