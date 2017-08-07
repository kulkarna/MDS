
namespace FrameworkTest
{
	using System;
	using System.Collections.Generic;
	using System.Data;
	using System.Linq;
	using LibertyPower.Business.CommonBusiness.CommonShared;
	using LibertyPower.Business.CommonBusiness.TimeSeries;
	using LibertyPower.Business.CustomerAcquisition.RateManagement;
	using LibertyPower.DataAccess.WorkbookAccess;
	using Microsoft.VisualStudio.TestTools.UnitTesting;

	[TestClass()]
	public class MiscTesting
	{
		[TestMethod()]
		public void TestExcel2010Import()
		{

			//DataSet ds = new DataSet();

			//ds = ExcelAccess.GetWorkbook( @"c:\2010ExcelFile.xlsx" ); // TODO: Refactor to use GetWorkbookEx

			//Assert.IsTrue( ds.Tables.Count > 0 );

			//Assert.IsTrue( ds.Tables[0].Rows.Count > 0 );
		}

		[TestMethod()]
		public void NumberOfMonthsAccountInDefaultVariableProduct()
		{
			int x = 0;

			VreAccount a1a = new VreAccount( new LibertyPower.Business.MarketManagement.UtilityManagement.Utility( "CL&P" ), new DateTime( 2011, 8, 16 ), new DateTime( 2011, 9, 15 ), 100 );
			a1a.AccountNumber = "1191000004";
			x = a1a.NumberOfMonthsAccountInDefaultVariableProduct;

			VreAccount a1b = new VreAccount( new LibertyPower.Business.MarketManagement.UtilityManagement.Utility( "CL&P" ), new DateTime( 2011, 8, 17 ), new DateTime( 2011, 9, 15 ), 100 );
			a1b.AccountNumber = "1191000004";
			x = a1b.NumberOfMonthsAccountInDefaultVariableProduct;

			VreAccount a2a = new VreAccount( new LibertyPower.Business.MarketManagement.UtilityManagement.Utility( "CL&P" ), new DateTime( 2011, 6, 11 ), new DateTime( 2011, 9, 15 ), 100 );
			a2a.AccountNumber = "1008901023802249330100";
			x = a2a.NumberOfMonthsAccountInDefaultVariableProduct;

			VreAccount a2b = new VreAccount( new LibertyPower.Business.MarketManagement.UtilityManagement.Utility( "CL&P" ), new DateTime( 2011, 6, 12 ), new DateTime( 2011, 9, 15 ), 100 );
			a2b.AccountNumber = "1008901023802249330100";
			x = a2b.NumberOfMonthsAccountInDefaultVariableProduct;

			VreAccount a3a = new VreAccount( new LibertyPower.Business.MarketManagement.UtilityManagement.Utility( "CL&P" ), new DateTime( 2011, 8, 16 ), new DateTime( 2011, 9, 15 ), 100 );
			a3a.AccountNumber = "4631023002";
			x = a3a.NumberOfMonthsAccountInDefaultVariableProduct;

			VreAccount a3b = new VreAccount( new LibertyPower.Business.MarketManagement.UtilityManagement.Utility( "CL&P" ), new DateTime( 2011, 8, 17 ), new DateTime( 2011, 9, 15 ), 100 );
			a3b.AccountNumber = "4631023002";
			x = a3b.NumberOfMonthsAccountInDefaultVariableProduct;


		}

		[TestMethod()]
		public void TestNewMarkup()
		{
			int x = 0;

			LibertyPower.Business.MarketManagement.UtilityManagement.Utility u = new LibertyPower.Business.MarketManagement.UtilityManagement.Utility( "CL&P" );
			VreUtility vreUtility = new VreUtility( "CL&P" );
			vreUtility = ObjectPromotion<VreUtility, LibertyPower.Business.MarketManagement.UtilityManagement.Utility>.Promote( vreUtility, u );

			vreUtility.CostComponentConfig = new CostComponents();
			vreUtility.IsoZones = new IsoZoneCollection();

			MarkupCurveCollection markupCurveCollection = VariableRateDeterminantsFactory.GetMarkupCurve( new DateTime( 2011, 9, 1 ), new DateTime( 2011, 10, 1 ) );
			List<MarkupCurve> markupCurveSubset = markupCurveCollection.Where( s => s.Utility == "CL&P" || VariableRateDeterminantsFactory.IsAllElse( s.Utility ) == true ).ToList();
			vreUtility.MarkupCurve = new MarkupCurveCollection();
			vreUtility.MarkupCurve.AddRange( markupCurveSubset );



			VreAccount a1 = new VreAccount( vreUtility, new DateTime( 2011, 9, 16 ), new DateTime( 2011, 10, 15 ), 100 );

			a1.AccountNumber = "185691002";
			//a1.AnnualUsage = 15000;

			x = a1.NumberOfMonthsAccountInDefaultVariableProduct;

			string error = "";
			TimeSeries ts = a1.VreMarkupCurve( out error );

		}

		[TestMethod()]
		public void TestSizeOfCurves()
		{

			//long start = System.Diagnostics.Process.GetCurrentProcess().WorkingSet64;

			//Debug.WriteLine( "start: " + (start / 1000 / 1000).ToString() );


			// Load Curves
			LibertyPower.Business.CustomerAcquisition.RateManagement.VreCurveManager.LoadCurvesIntoMemoryForTestingSize();


			//long end = System.Diagnostics.Process.GetCurrentProcess().WorkingSet64;

			//Debug.WriteLine( "end: " + (end / 1000 / 1000).ToString() );

		}

	}
}
