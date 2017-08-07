using System.Text.RegularExpressions;

namespace FrameworkTest
{

	using System;
	using System.IO;
	using System.Text;
	using System.Data;
	using System.Data.SqlClient;
	using System.Collections.Generic;
	using LibertyPower.Business.MarketManagement.UsageManagement;
	using Microsoft.VisualStudio.TestTools.UnitTesting;
	using LibertyPower.Business.MarketManagement.UtilityManagement;
	using LibertyPower.Business.CommonBusiness.TimeSeries;
	using System.Diagnostics;
	using System.Configuration;
	using LibertyPower.Business.MarketManagement.IdrUsageManagement;
	using LibertyPower.Business.CustomerManagement.AccountManagement;

	/// <summary>
	///This is a test class for UsageFactoryTest and is intended
	///to contain all UsageFactoryTest Unit Tests
	///</summary>
	[TestClass()]
	public class UsageManagementTest
	{
		#region Scrapers

		internal static void WriteFile( string content, string path )
		{
			try
			{
				string fileName = System.IO.Path.GetFileName( path );

				string dir = path.Replace( fileName, "" );

				if( System.IO.Directory.Exists( dir ) == false )
					System.IO.Directory.CreateDirectory( dir );

				if( System.IO.File.Exists( path ) )
					System.IO.File.Delete( path );

				StreamWriter writer = new StreamWriter( path );

				writer.Write( content );
				writer.Flush();
				writer.Close();
			}
			catch
			{
				Console.WriteLine( "Error writing output file: " + path );
			}
		}

		internal static string ReadFile( string path )
		{
			string contents = "";

			try
			{

				StreamReader streamReader = new StreamReader( path );

				streamReader.BaseStream.Position = 0;

				//Copy bytes to a new stream
				MemoryStream stream = new MemoryStream();
				for( int i = 0; i < streamReader.BaseStream.Length; i++ )
				{
					byte b = (byte) streamReader.BaseStream.ReadByte();
					stream.WriteByte( b );
				}

				stream.Position = 0;

				streamReader.Close();

				Encoding encoding = new UTF8Encoding();

				contents = encoding.GetString( stream.ToArray() );
			}
			catch
			{
				Console.WriteLine( "Error reading file:" + path );
			}

			return contents;
		}

		internal static string BytesToByteString( byte[] bytes )
		{
			StringBuilder builder = new StringBuilder();
			for( int i = 0; i < bytes.Length; i++ )
			{
				if( i == 0 )
				{
					builder.Append( bytes[i] );
				}
				else
				{
					builder.Append( bytes[i] );
				}
			}
			return builder.ToString();
		}

		//[TestMethod()]
		//public void CreateRefreshFiles()
		//{
		//    string binTarget = @"E:\DevRoot\SG2010\Framework\Source\LibertyPower_IT059\Apps\OfferEngine\OfferEngine\bin\";

		//    string[] files = System.IO.Directory.GetFiles(binTarget, "*.dll");
		//    foreach (string file in files)
		//    {
		//        string fileName = System.IO.Path.GetFileName(file);
		//        string path = string.Format("{0}.refresh", file);
		//        //if (System.IO.File.Exists(path) == true)
		//        //    System.IO.File.Delete(path);
		//        if (System.IO.File.Exists(path) == false)
		//        {
		//            string content = string.Format(@"..\..\..\..\Reference\{0}", fileName);
		//            WriteFile(content, path);
		//        }
		//    }

		//    binTarget = @"E:\DevRoot\SG2010\Framework\Source\LibertyPower_IT059\Apps\RateManagement\bin\";

		//    files = System.IO.Directory.GetFiles(binTarget, "*.dll");
		//    foreach (string file in files)
		//    {
		//        string fileName = System.IO.Path.GetFileName(file);
		//        string path = string.Format("{0}.refresh", file);
		//        //if (System.IO.File.Exists(path) == true)
		//        //    System.IO.File.Delete(path);
		//        if (System.IO.File.Exists(path) == false)
		//        {
		//            string content = string.Format(@"..\..\..\Reference\{0}", fileName);
		//            WriteFile(content, path);
		//        }
		//    }
		//}

		[TestMethod()]
		public void GetUtilityMapping()
		{
			UtilityClassMappingList mapping1 = UtilityMappingFactory.GetUtilityMapping( 0, 0, 0, -1 );
			UtilityClassMappingList mapping2 = UtilityMappingFactory.GetUtilityMapping();

			Assert.IsNotNull( mapping1 );
			Assert.IsNotNull( mapping2 );
			Assert.IsTrue( mapping1.Count > 0 );
			Assert.IsTrue( mapping2.Count > 0 );
			Assert.IsTrue( mapping1.Count == mapping2.Count );
		}

		/// <summary>
		///A test for GetSnapshot
		///</summary>
		[TestMethod()]
		public void GetSnapshotTest()
		{

			string account = "08000056310003018920";
			string utility = "JCP&L";
			string user = string.Empty; // TODO: Initialize to an appropriate value
			string zone = "B";
			string profile = "SCD2";
			string userName = System.Security.Principal.WindowsIdentity.GetCurrent().Name;
			userName = (string) userName.Split( '\\' ).GetValue( 1 );

			DateTime from = new DateTime( 2010, 01, 01 );
			DateTime to = new DateTime( 2012, 03, 1 );

			UsageList usageList = UsageFactory.GetRawUsage( account, utility, from, to, userName );
			UsageList actual;
			actual = UsageFactory.GetSnapshot( usageList, account, utility, user, zone, profile );
			Assert.IsNotNull( actual );
		}

		////////////////////////////////////////////////////////////
		[TestMethod()]
		public void GetAccountBillingHistoryTest()
		{
			string acct = "677266156900044";
			string utils = "CONED";
			DateTime from = new DateTime( 2006, 11, 23 );
			DateTime to = new DateTime( 2006, 12, 22 );

			decimal total = 5028.0000m;
			int days = 30;
			string createdBy = "USAGE ACQUIRE SCRPR";

			UsageList list = AccountBillingInfoFactory.GetList( acct, utils, from, to );

			Assert.IsNotNull( list );

			foreach( Usage item in list )
			{
				Assert.AreEqual( total, item.TotalKwh, "Invalid total kwh" );
				Assert.AreEqual( days, item.Days, "Invalid # of Days" );
				Assert.AreEqual( createdBy, item.CreatedBy, "Invalid Created by" );
			}
		}

		[TestMethod()]
		public void GetUsage()
		{
			string acct, utility, zone, loadshape;
			DateTime from = new DateTime( 2008, 01, 01 );
			DateTime to = new DateTime( 2011, 01, 01 );
			string userName = System.Security.Principal.WindowsIdentity.GetCurrent().Name;
			userName = (string) userName.Split( '\\' ).GetValue( 1 );
			UsageList list = new UsageList(), snapshot = new UsageList();

			acct = "1129941118";
			string[] accts = acct.Split( ',' );
			utility = "NIMO";
			string[] utils = utility.Split( ',' );
			loadshape = "SC2D";
			string[] lsids = loadshape.Split( ',' );
			zone = "B";
			string[] zones = zone.Split( ',' );
			//UtilityAccount account = new UtilityAccount( "1930009004020" );
			//account.UtilityCode = "UI";
			//account.ZoneCode = "R";
			//account.LoadShapeId = "CONN";
			UsageList cleanList = new UsageList();

			//Debug.Print("Start... " + String.Format("{0:yyyy/MM/dd hh:mm:ss}", DateTime.Now));
			for( int cnt = 0; cnt <= accts.GetUpperBound( 0 ); cnt++ )
			{
				//Debug.Print("Before GetRawUsage: " + String.Format("{0:yyyy/MM/dd hh:mm:ss}", DateTime.Now) + ", account: " + accts[cnt]);
				if( list == null | list.Count == 0 )
				{
					list = UsageFactory.GetRawUsage( accts[cnt], utils[cnt], from, to, userName );
					snapshot = UsageFactory.GetSnapshot( list, accts[cnt], utils[cnt], userName, zones[cnt], lsids[cnt] );

					if( snapshot != null )
						cleanList.AddRange( snapshot );
				}
				else
				{
					UsageList addUsg = new UsageList();
					addUsg = UsageFactory.GetRawUsage( accts[cnt], utils[cnt], from, to, userName );
					snapshot = UsageFactory.GetSnapshot( addUsg, accts[cnt], utils[cnt], userName, zones[cnt], lsids[cnt] );

					if( snapshot != null )
						cleanList.AddRange( snapshot );
				}
				//Debug.Print("After GetSnapshot: " + String.Format("{0:yyyy/MM/dd hh:mm:ss}", DateTime.Now) + ", rown: " + list.Count);
			}
			//Debug.Print("End... " + String.Format("{0:yyyy/MM/dd hh:mm:ss}", DateTime.Now));

			//*** NOTE: next 29 lines are for test ony ***
			if( cleanList != null )
			{
				string dealdo = String.Format( "{0:yyyy/MM/dd hh:mm}", DateTime.Now );

				foreach( Usage item in cleanList )
				{
					DataSet ds1 = new DataSet();

					using( SqlConnection conn = new SqlConnection( "Data Source=(local);user id=sa;password=lighthouse;Initial Catalog=LibertyPower; Connect Timeout=200; pooling='true'; Max Pool Size=200" ) )
					{
						using( SqlCommand cmd = new SqlCommand() )
						{
							cmd.Connection = conn;
							cmd.CommandType = CommandType.StoredProcedure;
							cmd.CommandText = "usp_RowsPerDealInsert_Test";

							cmd.Parameters.Add( new SqlParameter( "accountNumber", item.AccountNumber ) );
							cmd.Parameters.Add( new SqlParameter( "DealId", dealdo ) );
							cmd.Parameters.Add( new SqlParameter( "RowId", item.ID ) );

							using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
							{
								da.Fill( ds1 );
							}
						}
					}
				}
			}

		}

		// ------------------------------------------------------------------------------------
		[TestMethod()]
		public void TestAmerenScraper()
		{
			string userName = System.Security.Principal.WindowsIdentity.GetCurrent().Name;
			userName = (string) userName.Split( '\\' ).GetValue( 1 );

			string accountNumber = "5181831008", exceptions = "";
			WebAccountList actual;

			actual = ScraperFactory.RunAmerenScraper( accountNumber, userName, out exceptions );
			Assert.IsNotNull( actual );
			if( actual != null )
				Assert.IsTrue( actual.Count > 0 );
		}

		// ------------------------------------------------------------------------------------
		[TestMethod()]
		public void TestBgeScraper()
		{
			string userName = System.Security.Principal.WindowsIdentity.GetCurrent().Name;
			userName = (string) userName.Split( '\\' ).GetValue( 1 );

			string accountNumber = "9047849836", exceptions = "";
			Bge actual;

			actual = ScraperFactory.RunBgeScraper( accountNumber, userName, out exceptions );
			Assert.IsNotNull( actual );
			if( actual != null )
				Assert.IsTrue( actual.WebUsageList.Count > 0 );
		}

		// ------------------------------------------------------------------------------------
		[TestMethod()]
		public void TestCenhudScraper()
		{
			string userName = System.Security.Principal.WindowsIdentity.GetCurrent().Name;
			userName = (string) userName.Split( '\\' ).GetValue( 1 );

			string accountNumber = "5609177500", exceptions = "";
			Cenhud actual;

			actual = ScraperFactory.RunCenhudScraper( accountNumber, userName, out exceptions );
			Assert.IsNotNull( actual );
			if( actual != null )
				Assert.IsTrue( actual.WebUsageList.Count > 0 );
		}

		// ------------------------------------------------------------------------------------
		[TestMethod()]
		public void TestCmpScraper()
		{
			string userName = System.Security.Principal.WindowsIdentity.GetCurrent().Name;
			userName = (string) userName.Split( '\\' ).GetValue( 1 );

			string accountNumber = "04411059126012", exceptions = "";
			Cmp actual;

			actual = ScraperFactory.RunCmpScraper( accountNumber, userName, out exceptions );
			Assert.IsNotNull( actual );
			if( actual != null )
				Assert.IsTrue( actual.WebUsageList.Count > 0 );
		}

		// ------------------------------------------------------------------------------------
		[TestMethod()]
		public void TestComedScraper()
		{
			string userName = System.Security.Principal.WindowsIdentity.GetCurrent().Name;
			userName = (string) userName.Split( '\\' ).GetValue( 1 );

			string accountNumber = "5268135007", exceptions = "", meterNum = "141298117";
			Comed actual;

			actual = ScraperFactory.RunComedScraper( accountNumber, userName, out exceptions, meterNum );
			Assert.IsNotNull( actual );
			if( actual != null )
				Assert.IsTrue( actual.WebUsageList.Count > 0 );
		}

		// ------------------------------------------------------------------------------------
		[TestMethod()]
		public void TestConedScrapedData()
		{
			string userName = System.Security.Principal.WindowsIdentity.GetCurrent().Name;
			userName = (string) userName.Split( '\\' ).GetValue( 1 );

			string accountNumber = "233901043000031", exceptions = "";
			Coned actual;

			actual = ScraperFactory.RunConedScraper( accountNumber, userName, out exceptions );
			Assert.IsNotNull( actual );
			if( actual != null )
				Assert.IsTrue( actual.WebUsageList.Count > 0 );
		}

		// ------------------------------------------------------------------------------------
		[TestMethod()]
		public void TestNimoScraper()
		{
			string userName = System.Security.Principal.WindowsIdentity.GetCurrent().Name;
			userName = (string) userName.Split( '\\' ).GetValue( 1 );

			string accountNumber = "0507607105", exceptions = "";
			Nimo actual;

			actual = ScraperFactory.RunNimoScraper( accountNumber, userName, out exceptions );
			Assert.IsNotNull( actual );
			if( actual != null )
				Assert.IsTrue( actual.WebUsageList.Count > 0 );
		}

		// ------------------------------------------------------------------------------------
		[TestMethod()]
		public void TestNysegScraper()
		{
			string userName = System.Security.Principal.WindowsIdentity.GetCurrent().Name;
			userName = (string) userName.Split( '\\' ).GetValue( 1 );

			string accountNumber = "N01000000142117", exceptions = "";
			Nyseg actual;

			actual = ScraperFactory.RunNysegScraper( accountNumber, userName, out exceptions );
			Assert.IsNotNull( actual );
			if( actual != null )
				Assert.IsTrue( actual.WebUsageList.Count > 0 );
		}

		// ------------------------------------------------------------------------------------
		[TestMethod()]
		public void TestPecoScraper()
		{
			string userName = System.Security.Principal.WindowsIdentity.GetCurrent().Name;
			userName = (string) userName.Split( '\\' ).GetValue( 1 );

			string accountNumber = "0025088037", exceptions = "", postalCode = "19067";
			Peco actual;

			actual = ScraperFactory.RunPecoScraper( accountNumber, userName, out exceptions, postalCode );
			Assert.IsNotNull( actual );
			if( actual != null )
				Assert.IsTrue( actual.WebUsageList.Count > 0 );
		}

		// ------------------------------------------------------------------------------------
		[TestMethod()]
		public void TestRgeScraper()
		{
			string userName = System.Security.Principal.WindowsIdentity.GetCurrent().Name;
			userName = (string) userName.Split( '\\' ).GetValue( 1 );

			string accountNumber = "R01000051666287", exceptions = "";
			Rge actual;

			actual = ScraperFactory.RunRgeScraper( accountNumber, userName, out exceptions );
			Assert.IsNotNull( actual );
			if( actual != null )
				Assert.IsTrue( actual.WebUsageList.Count > 0 );
		}

		#endregion

		#region it022

		// ------------------------------------------------------------------------------------
		[TestMethod()]
		public void renameFileNames()
		{
			string sourceDir = "D:\\Temp\\TestFiles\\ManagedFiles\\";

			// Process the list of files found in the directory.
			string[] fileEntries = Directory.GetFiles( sourceDir );
			string File2;
			Int16 ctr = 0;

			foreach( string File1 in fileEntries )
			{
				int idx = File1.IndexOf( "LIBPPOWERX12COPY" );
				int len = File1.Length;
				Debug.WriteLine( "Original File: " + sourceDir + File1 );
				File2 = File1.Substring( idx, len - idx );
				try
				{
					if( File1.Length != sourceDir.Length + File2.Length )
					{
						// do the next 2 lines if you want to rename the file to "version" 2 - 03/14/2012..
						if( File2.Contains( ".txt" ) )
							File2 = File2.Substring( 0, File2.Length - 4 ) + "-2" + ".txt";

						System.IO.File.Move( File1, sourceDir + File2 );
						Debug.WriteLine( "Renamed File: " + sourceDir + File2 );
					}
				}
				catch( Exception ex )
				{
					string mes = "Error with file " + File2 + " described as: " + ex.Message;
					Debug.WriteLine( mes );
				}
				ctr++;
			}

			Debug.WriteLine( ctr );
		}

		// ------------------------------------------------------------------------------------
		[TestMethod()]
		public void updateProductionBinFolder()
		{
			// should not change..
			string referenceFolder = "D:\\DevRoot\\SG2010\\Framework\\Source\\Reference\\";

			// change the follwing 2 (always)
			string productionBin = "\\\\LPCNOCSQL1\\Libertypower\\Prod\\DealCapture\\bin\\";
			string backUpFoder = "Q:\\Common\\Eduardo\\BackUps\\deal capture-bin\\";

			string[] filesInFolder = Directory.GetFiles( productionBin );
			string fileRaw;

			foreach( string file in filesInFolder )
			{
				if( file.EndsWith( ".dll" ) )
				{
					fileRaw = file.Substring( productionBin.Length, file.Length - productionBin.Length );

					try
					{
						Debug.WriteLine( "File Name: " + fileRaw );
						System.IO.File.Delete( backUpFoder + fileRaw );
						System.IO.File.Copy( file, backUpFoder + fileRaw );
						Debug.WriteLine( "Backing T: " + backUpFoder + fileRaw );
						System.IO.File.Delete( file );
						System.IO.File.Copy( referenceFolder + fileRaw, file );
						Debug.WriteLine( "Moving To: " + file );
					}
					catch( Exception ex )
					{
						string mes = "Error with file " + file + " described as: " + ex.Message;
						Debug.WriteLine( mes );
					}
				}
			}

		}

		/// <summary>
		///A test for CalculateAnnualUsage
		///</summary>
		[TestMethod()]
		public void CalculateAnnualUsageTest()
		{
			string account = "3016812024";
			string utility = "SCE";

			string user = System.Security.Principal.WindowsIdentity.GetCurrent().Name;
			user = (string) user.Split( '\\' ).GetValue( 1 );

			string process_id = "FMWK TEST";
			bool isRenewal = false; // TODO: Initialize to an appropriate value
			string accountId = "2011-0066554";
			bool expected = false; // TODO: Initialize to an appropriate value
			bool actual;

			actual = CompanyAccountFactory.CalculateAnnualUsage( account, utility, user, process_id, isRenewal, accountId );

			Assert.AreEqual( expected, actual );
			Assert.Inconclusive( "Verify the correctness of this test method." );
		}

		// ------------------------------------------------------------------------------------
		[TestMethod()]
		public void GetRawSnapshot()
		{
			UsageList usageList = new UsageList(); // TODO: Initialize to an appropriate value
			string account = "3016812024";
			string[] accts = account.Split( ',' );
			string utility = "SCE";
			string[] utils = utility.Split( ',' );
			string user = System.Security.Principal.WindowsIdentity.GetCurrent().Name;
			UsageList expected = new UsageList();
			UsageList actual;

			DateTime from = new DateTime( 2007, 01, 01 );
			DateTime to = new DateTime( 2011, 10, 04 );
			bool calendarizeMe = false;

			for( int cnt = 0; cnt <= accts.GetUpperBound( 0 ); cnt++ )
			{
				Debug.WriteLine( "account: " + accts[cnt] );
				if( usageList == null | usageList.Count == 0 )
				{
					usageList = UsageFactory.GetRawUsage( accts[cnt], utils[cnt], from, to, user );
					calendarizeMe = UsageFactory.RequiresCalendarization( usageList );			// IT059
					actual = UsageFactory.GetSnapshot( usageList, accts[cnt], utils[cnt], user );

					if( actual != null )
						expected.AddRange( actual );
				}
				else
				{
					UsageList addUsg = new UsageList();
					addUsg = UsageFactory.GetRawUsage( accts[cnt], utils[cnt], from, to, user );
					calendarizeMe = UsageFactory.RequiresCalendarization( usageList );			// IT059
					actual = UsageFactory.GetSnapshot( addUsg, accts[cnt], utils[cnt], user );

					if( actual != null )
						expected.AddRange( actual );
				}
			}

			//*** NOTE: next line is for test ony ***
			AuditResponse( expected, "RawSnpsht - " + account + " (" + calendarizeMe + ") <- Calendarize?" );

			Assert.AreEqual( expected, usageList );
			Assert.Inconclusive( "Verify the correctness of this test method." );
		}

		[TestMethod()]
		public void torchAccounts()
		{
			string strSql, strWhere;
			string iso = "ERCOT,MISO,NEISO,NYISO,PJM";
			string[] isos = iso.Split( ',' );

			for( int i = 0; i <= isos.GetUpperBound( 0 ); i++ )
			{
				strSql = "select distinct UtilityIds Utility, AccountNo AccountNumber from lp_historical_info..[TorchAccts_07-22-2_Ignacio] (nolock)";
				strWhere = " where ISO = '" + isos[i] + "' order by 1, 2";
				Debug.WriteLine( "TORCH -> " + DateTime.Now + " ALL - " + isos[i] + ".." );

				DataSet ds = new DataSet();
				Debug.WriteLine( "TORCH -> " + DateTime.Now + " cmdText: " + strSql + strWhere );

				using( SqlConnection conn = new SqlConnection( ConfigurationManager.ConnectionStrings["HistoricalInfo"].ConnectionString ) )
				{
					using( SqlCommand cmd = new SqlCommand() )
					{
						cmd.Connection = conn;
						cmd.CommandType = CommandType.Text;
						cmd.CommandText = strSql + strWhere;

						using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
							da.Fill( ds );
					}
				}

				PrepareTorchData( "ALL", isos[i], ds );
			}
		}

		private void PrepareTorchData( string process, string market, DataSet ds )
		{
			// ----------------
			UsageList usageList = new UsageList(); // TODO: Initialize to an appropriate value
			UsageList expected = new UsageList();
			string account = "", utility = "";
			string user = System.Security.Principal.WindowsIdentity.GetCurrent().Name;
			UsageList actual;
			Int16 i = 0;

			DateTime from = new DateTime( 2010, 01, 01 );
			DateTime to = new DateTime( 2012, 10, 01 );

			try
			{
				foreach( DataRow row in ds.Tables[0].Rows )
				{
					if( usageList == null | usageList.Count == 0 )
					{
						account = (string) row["AccountNumber"];
						utility = (string) row["Utility"];

						try
						{
							usageList = UsageFactory.GetRawUsage( account, utility, from, to, user );
							actual = UsageFactory.GetSnapshot( usageList, account, utility, user );

							if( actual != null && actual.Count != 0 )
								expected.AddRange( actual );
						}
						catch( Exception ex )
						{
							string str = ex.Message;
							Debug.WriteLine( "TORCH ERROR 1 -> " + DateTime.Now + " on account " + account + ", Utility: " + utility + ": " + str );
						}
					}
					else
					{
						account = (string) row["AccountNumber"];
						utility = (string) row["Utility"];

						UsageList addUsg = new UsageList();
						try
						{
							addUsg = UsageFactory.GetRawUsage( account, utility, from, to, user );
							actual = UsageFactory.GetSnapshot( addUsg, account, utility, user );

							if( actual != null && actual.Count != 0 )
								expected.AddRange( actual );
						}
						catch( Exception ex )
						{
							string str = ex.Message;
							Debug.WriteLine( "TORCH ERROR -> " + DateTime.Now + " on account " + account + ", Utility: " + utility + ": " + str );
						}
					}

					if( i == 200 )
					{
						Debug.WriteLine( "TORCH -> " + DateTime.Now + " Account: " + account + ", Utility: " + utility );
						i = 0;
					}
					i++;
				}
			}
			catch( Exception ex )
			{
				string str = ex.Message;
				Debug.WriteLine( "TORCH ERROR (2) -> " + DateTime.Now + " on account " + account + ", Utility: " + utility + ": " + str );
			}

			//*** NOTE: next line is for test ony ***
			Debug.WriteLine( "TORCH -> " + DateTime.Now + " AuditResponse.." );
			AuditResponse( expected, process + ":" + market );

		}

		[TestMethod()]
		public void PrepareIT022Data()
		{
			try
			{
				string strSql, strWhere;
				// run usp_GetIstaMeterReads pre.txt ............
				Debug.WriteLine( "IT022 -> " + DateTime.Now + " M2M - NEISO" );
//				PrepareM2MData( "M2M", "NEISO" );
				Debug.WriteLine( "IT022 -> " + DateTime.Now + " SCHEDULE - NEISO" );
//				PrepareM2MData( "SCHEDULE", "NEISO" );
				// run usp_GetIstaMeterReads post.txt ............

				Debug.WriteLine( "IT022 -> " + DateTime.Now + " M2M - ERCOT" );
//				PrepareM2MData( "M2M", "ERCOT" );
				Debug.WriteLine( "IT022 -> " + DateTime.Now + " M2M - PJM" );
//				PrepareM2MData( "M2M", "PJM" );
				Debug.WriteLine( "IT022 -> " + DateTime.Now + " M2M - CAISO" );
//				PrepareM2MData( "M2M", "CAISO" );
				Debug.WriteLine( "IT022 -> " + DateTime.Now + " M2M - MISO" );
//				PrepareM2MData( "M2M", "MISO" );
				Debug.WriteLine( "IT022 -> " + DateTime.Now + " M2M - NYISO" );
//				PrepareM2MData( "M2M", "NYISO" );

				Debug.WriteLine( "IT022 -> " + DateTime.Now + " SCHEDULE - ERCOT" );
//				PrepareM2MData( "SCHEDULE", "ERCOT" );
				Debug.WriteLine( "IT022 -> " + DateTime.Now + " SCHEDULE - PJM" );
//				PrepareM2MData( "SCHEDULE", "PJM" );
				Debug.WriteLine( "IT022 -> " + DateTime.Now + " SCHEDULE - MISO" );
//				PrepareM2MData( "SCHEDULE", "MISO" );
				Debug.WriteLine( "IT022 -> " + DateTime.Now + " SCHEDULE - NYISO" );
//				PrepareM2MData( "SCHEDULE", "NYISO" );

				strSql = "select distinct UtilityCode Utility, '' AccountName, u.AccountNumber from	libertypower..UsageConsolidated u (nolock)";
				strWhere = " where utilitycode in (select distinct t3.utilitycode from libertypower..utility t3 where WholeSaleMktID = 'PJM') order by 1, 3";
				Debug.WriteLine( "IT022 -> " + DateTime.Now + " ALL - PJM.." );
				PrepareM2MData( "ALL", "PJM", strSql + strWhere );
			}
			catch( Exception ex )
			{
				string str = ex.Message;
				Debug.WriteLine( "IT022 -> " + DateTime.Now + " Error.." + str );
			}

			Debug.WriteLine( "IT022 -> " + DateTime.Now + " DONE.." );
		}

		// ------------------------------------------------------------------------------------
		private void PrepareM2MData( string process, string market, string cmdText )
		{
			DataSet ds = new DataSet();
			Debug.WriteLine( "IT022 -> " + DateTime.Now + " cmdText: " + cmdText );

			// "Data Source=LPCNOCSQL1;user id=sa;password=Sp@c3ch@1r;Initial Catalog=lp_historical_info; Connect Timeout=0; pooling='true'; Max Pool Size=200"
			using( SqlConnection conn = new SqlConnection( ConfigurationManager.ConnectionStrings["HistoricalInfo"].ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
//					cmd.CommandType = CommandType.StoredProcedure;
//					cmd.CommandText = "usp_it022_prep";
					cmd.CommandType = CommandType.Text;
					cmd.CommandText = cmdText;

//					cmd.Parameters.Add( new SqlParameter( "process", process ) );
//					cmd.Parameters.Add( new SqlParameter( "market", market ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );

				}
			}

			// ----------------
			UsageList usageList = new UsageList(); // TODO: Initialize to an appropriate value
			UsageList expected = new UsageList();
			string account, utility;
			string user = System.Security.Principal.WindowsIdentity.GetCurrent().Name;
			UsageList actual;

			DateTime from = new DateTime( 2007, 01, 01 );
			DateTime to = new DateTime( 2011, 10, 01 );

			try
			{
				foreach( DataRow row in ds.Tables[0].Rows )
				{
					if( usageList == null | usageList.Count == 0 )
					{
						account = (string) row["AccountNumber"];
						utility = (string) row["Utility"];

						usageList = UsageFactory.GetRawUsage( account, utility, from, to, user );
						actual = UsageFactory.GetSnapshot( usageList, account, utility, user );

						if( actual != null && actual.Count != 0 )
							expected.Add( actual[0] );
					}
					else
					{
						account = (string) row["AccountNumber"];
						utility = (string) row["Utility"];

						UsageList addUsg = new UsageList();
						addUsg = UsageFactory.GetRawUsage( account, utility, from, to, user );
						actual = UsageFactory.GetSnapshot( addUsg, account, utility, user );

						if( actual != null && actual.Count != 0 )
							expected.Add( actual[0] );
					}
				}
			}
			catch( Exception ex )
			{
				string str = ex.Message;
			}

			//*** NOTE: next line is for test ony ***
			Debug.WriteLine( "IT022 -> " + DateTime.Now + " AuditResponse.." );
			AuditResponse( expected, process + ":" + market );

//			Assert.AreEqual( expected, usageList );
//			Assert.Inconclusive( "Verify the correctness of this test method." );
		}

		// ------------------------------------------------------------------------------------
		private void AuditResponse( UsageList snapshot, string process )
		{
			//*** NOTE: next 30 lines are for test ony ***
			if( snapshot != null )
			{
				string dealdo = String.Format( "{0:yyyy/MM/dd hh:mm}", DateTime.Now ) + " - " + process;
//				string acct = "";
				Debug.WriteLine( "Deal ID... " + dealdo );

				using( SqlConnection conn = new SqlConnection( "Data Source=SQLPROD;user id=sa;password=Sp@c3ch@1r;Initial Catalog=LibertyPower; Connect Timeout=200; pooling='true'; Max Pool Size=200" ) )
				{
					conn.Open();
					using( SqlCommand cmd = new SqlCommand() )
					{
						cmd.Connection = conn;
						cmd.CommandType = CommandType.StoredProcedure;
						cmd.CommandText = "usp_RowsPerDealInsert_Test";

						cmd.Parameters.Add( "accountNumber", SqlDbType.VarChar, 30 );
						cmd.Parameters.Add( new SqlParameter( "DealId", dealdo ) );
						cmd.Parameters.Add( "RowId", SqlDbType.VarChar, 10 );
						cmd.Parameters.Add( "isEstimated", SqlDbType.VarChar, 1 );

						foreach( Usage item in snapshot )
						{
							// log 1 record per account..
//							if( acct != item.AccountNumber )
//							{
							cmd.Parameters["accountNumber"].Value = item.AccountNumber;
							cmd.Parameters["RowId"].Value = item.ID;
							cmd.Parameters["isEstimated"].Value = item.UsageType == UsageType.Estimated ? "1" : "0";

							cmd.ExecuteScalar();
//							}
//							acct = item.AccountNumber;
						}
					}
				}

				Debug.WriteLine( "Done with this guy... @: (" + DateTime.Now + ") - " + dealdo );
			}
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		///A test for GetSnapshot
		///</summary>
		[TestMethod()]
		public void GetSnapshotWithEstimatesTest()
		{
			UsageList usageList = new UsageList(); // TODO: Initialize to an appropriate value
			string account = "0840279398";	//242882199993,242882199993,205525899881,205525899881,207423199984,0000001714004,0000001714008,0000002098001,0000002098001,08000034140000001825,08000498440000005574,08002109900000137790,08011577500000930668,08011577580000896566,08011601800003210328,08016324110000690225,08020636470000807102,2514608007,2514624001,6338525005,6338527009,6338668023,6338673006,6573932015,1570037009,1570040006,1570042000,1584302000,1584348006,1584391007,1584396002,5351864004,6564497003,6564497003,1129941118,3275125108,3345106124,4038812103,4903157008,6051353145,8550146200,8551305105,8552543109,11557330047,15402760019,23910311002,23910511007,23910591009,23911101006,23911171009,27746010019,27792960018,27794740020,27796790015,28312880017,11557330047,13314910178,13315130032,15402760019,15403690017,26490941015,26493721000,27305930011,N01000000129494,N01000001189919,N01000001200856,N01000003047487,N01000004872578,N01000005438742,N01000020141396,N01000020192282,N01000020637690,N01000020640827,N01000020651717,N01000020658332,N01000020682720,0759057004,1027131005,2739095000,7180727027,7455828008,7739366009,9242915036,9263915018,9274465001,9277597000,9877159011,9944351007,10443720002054542,10443720002054542,10443720003503439,10443720007693399,10443720007693461,10443720007700685,10443720007700716,10443720007717309,10443720008914580,10443720008956189,10443720008966912,10443720008967065,10443720009088683,7739366009,7898932027,8735790064,9274465001,0100906916,1438138016,1438251033,1542181068,1542259666,1550168031,1606122065,1607261078,1607262084,1607263082,0041138005,0041138005,1516116001,1516190007,1516194005,1517018031,1517038006,9782090009,9782136019,9783080007,9783080007,9783121156,9784170028,9784170028,9785002001,9785018009,9786010007,9786010007,9786016009,9787193014,9787690009,9787690009,9788113010,9788113010,9788143009,9793095001,9793114029,9793137004,9803295006,9804094003,9804768017,9806016007,9806016007,9806047066,9808641008,9808641008,9809195005,10443720003503439,10443720007693399,10443720007693461,10443720007700685,10443720007700716,10443720007717498,10443720007752702,10443720007752795,10443720007753012,10443720007910092,10443720008682436,10443720008774799,10443720008858530,10443720008967065,10443720003503439,10443720007693399,10443720007693461,10443720007700685,10443720007700716,10443720007717498,10443720008570791,10443720008603559,10443720008679456,10443720008679520,10443720008682436,10443720008774799,10443720008858530,10443720008967065";
			string[] accts = account.Split( ',' );
			string utility = "BGE";	//DELDE,DELMD,DUQ,JCP&L,MECO,NECO,NIMO,NSTAR-BOS,NSTAR-CAMB,NSTAR-COMM,NYSEG,O&R,ONCOR,ORNJ";
			string[] utils = utility.Split( ',' );
			string user = System.Security.Principal.WindowsIdentity.GetCurrent().Name;
			string zone = "ALL";
			string profile = "G";	//DEDGL,MDDGL,GL,GSCL,G-1,A16,1SC1,G-1,G-2,G-2,31,NJ301-STRATA-1,BUSHILF_COAST,DCGTHV";
			string[] lsids = profile.Split( ',' );
			UsageList expected = new UsageList();
			UsageList actual, oeList;

			DateTime from = new DateTime( 2007, 01, 01 );
			DateTime to = new DateTime( 2011, 10, 01 );

			for( int cnt = 0; cnt <= accts.GetUpperBound( 0 ); cnt++ )
			{
				if( usageList == null | usageList.Count == 0 )
				{
					usageList = UsageFactory.GetRawUsage( accts[cnt], utils[cnt], from, to, user );
					oeList = remove2008Meters( usageList );
					actual = UsageFactory.GetSnapshot( oeList, accts[cnt], utils[cnt], user, zone, lsids[cnt] );

					if( actual != null && actual.Count > 0 )
						expected.AddRange( actual );
				}
				else
				{
					UsageList addUsg = new UsageList();
					addUsg = UsageFactory.GetRawUsage( accts[cnt], utils[cnt], from, to, user );
					oeList = remove2008Meters( addUsg );
					actual = UsageFactory.GetSnapshot( oeList, accts[cnt], utils[cnt], user, zone, lsids[cnt] );

					if( actual != null && actual.Count > 0 )
						expected.AddRange( actual );
				}
			}

			//*** NOTE: next line is for test ony ***
			AuditResponse( expected, "SnpshtWithEst -> " + account );

			Assert.AreEqual( expected, usageList );
			Assert.Inconclusive( "Verify the correctness of this test method." );
		}

		// for OE only
		private UsageList remove2008Meters( UsageList list )
		{
			UsageList newList = new UsageList();

			foreach( Usage meterRead in list )
			{
				if( meterRead.BeginDate >= Convert.ToDateTime( "01/01/2009" ) )
					newList.Add( meterRead );
			}
			return newList;
		}

		[TestMethod()]
		public void RunMultipleScrapers()
		{
			try
			{
				Debug.WriteLine( "IT022 -> " + DateTime.Now + " AMEREN" );
				RunScrapers( "AMEREN", "0007024221,0022005713,0055006810,0071000715,0071009538,0081126009,0113006014,0142001116,0198078009,0207001812,0213456892,0238106009,0300113035,0307000615,0307095005,0307095005,0322005423,0326005816,0368071005,0369631373,0392001411,0396001822,0407150014,0408775017,0415008011,0416156019,0434046015,0437150574,0443995027,0446408067,0450781930,0453073030,0459141008,0464000712,0475006222,0479052003,0485001725,0488150005,0513157030,0525405132,0534006413,0555002029,0556456251,0557399008,0563009311,0567068007,0591039067,0596139056,0602002118,0605056009,0606005731,0644986012,0655112015,0658121054,0667307211,0690048173,0705000157,0705004411,0706467044,0717136006,0718286011,0767100003,0781003226,0781344000,0803771852,0807007813,0808035014,0850771372,0861008819,0885001316,0908028011,0936762575,0938514028,0941001004,0944977008,0981005211,1014979016,1015008410,1025001719,1055006917,1066008119,1071002026,1078148151,1086969007,1098837930,1099140048,1123168034,1153004413,1160124119,1173002137,1195077005,1212008011,1221793930,1232007724,1245003533,1322002229,1323727052,1393026008,1405307536,1413038019,1413670003,1416994256,1429596652,1441183610,1441660970,1442510024,1453564810,1455005411,1456008817,1471216253,1491011007,1516005811,1536008914,1543006324,1604095059,1613003220,1647679533,1656035515,1662179378,1664322254,1670049002,1673394098,1676490003,1676801935,1678312336,1683139015,1703009811,1705003411,1705008915,1707002016,1713123054,1714784007,1736001114,1744968173,1754037008,1761008017,1795994002,1805006611,1819336490,1824005221,1844918895,1854000526,1859156019,1861008916,1876835539 ,1906156018,1907171026,1908752174,1914822098,1933130004,1953006922,1955005018,1958604810,1960518009,1966164003,1972451003,1976672971,1984859934,1992267853,2015235370,2015637007,2016317048,2019705079,2099647857,2112000412,2117009733,2160124118,2162603212,2163046055,2163820253,2185006617,2190107027,2200505692,2228264006,2230863855,2258659006,2265036657,2267037938,2271002913,2287220657,2288089138,2295320178 ,2309510113,2324295293,2325273296,2325716978,2334006817,2342835032,2354005512,2355124043,2375006543,2375318056,2390057014,2412432815,2442158002,2451013017,2469233291,2473816975,2515073935,2523107378,2556008813,2559913937,2601903056,2636453458,2639294892,2647413294,2662717009,2677725132,2703009918,2707007118,2708357933,2733137046,2744834094,2810974002,2812415050,2833002910,2853050330,2871005622,2880740026,2901829612,2918050019,2927008816,2934004120,2961472652,2964004813,3001904173,3002640492,3013008413,3024007313,3042393772,3061168490,3076007126,3112618255,3120782098,3122000410,3123006029,3126619164,3132364972,3140105773,3155124000,3162408003,3165006921,3175005734,3195034014,3250096003,3263269454,3265695532,3267538012,3271007418,3282001910,3283652812,3295003215,3298548015,3302446009,3336005028,3342317118,3354002319,3358087005,3371001813,3383006323,3394400493,3396576003,3402000345,3404008218,3408683211,3424005816,3434006814,3437006112,3459024061,3491130029,3511646003,3527471018,3528439053,3543006518,3543524174,3549952813,3550691452 ,3555002222,3561008313,3571002719,3586202412,3591130972,3602002311,3602213183,3608594571,3614006811,3634119859,3668632490,3688626414,3703009016,3713359217 ,3725731372,3743567212,3744929455,3747053009,3759028006,3771001413,3774983534,3800896338,3802003218,3814810895 ,3822619187,3864003913,3891000152 ,3909380811,3920037628,3938531532,3960123110,3961008011,3964004910,3971420494,3993077047,3994718415,4030192010,4046007431,4054002715,4054195008,4055710261,4068081023,4083004525,4086003716,4104937013,4112008314,4147967373,4157355531,4158216119,4163074021,4171435215,4176542250,4185150003,4208874259,4255000417,4271002118,4306700974,4308862732,4310547009,4335256971,4342317117,4347100117,4367173616,4381000714,4394484035,4404008315,4460997775,4461008510,4473002129,4481000614,4489138417,4494008511,4505261936,4507007414,4521988007,4562002021,4562449451,4565421018,4574702573,4580696970,4581006116,4594004120,4594008411,4597557053,4612006716,4632005412,4633078252,4633994039,4637102119,4638033013,4641792651,4647041292,4665007615,4681905054,4683325007,4690739057,4702671210,4703009113,4715000321,4722005411,4780258574,4791009207,4811674895,4863009044,4887364818,4915009015,4916001360,4918243051,4942296173,4945004277 ,4953008339,4962104002,4963009328,5001470004,5026081002,5046001025,5056746738,5058093010,5082003411,5083002410,5109950576,5129840658,5132035648,5146449005,5156282095,5161738255,5196002526,5226005323,5248086007,5260124113,5342147933,5383371532,5404008412,5410846013,5413006111,5419348017,5430466895,5446008226,5448299051,5461008617,5473005410,5482915535,5502138005,5503523051,5512617111,5524111698,5561004618,5567013008,5573143054,5591006132,5616005110,5636000417,5652618418,5655705111,5663004211,5672009510,5674835455 ,5706007215,5707007311,5713884013,5736201118,5750652818,5761008317,5762004131,5775007522,5777858813,5783000612,5796106412,5825823536,5830629774,5833262253,5873391690,5894006112,5897007007,5907003810,5916001476,5927784975,5937009116,5954775774,6002217116,6002738009,6014463050,6029765295,6039328016,6055112058,6073007120,6074340972,6082003517,6083459934,6119171531,6125005415,6135984179,6136113000,6159349375,6181041030,6198146573,6201110737,6209380172,6217319224,6243005041,6255005125 ,6262003542,6287817135,6335649617,6341835021,6351463074,6361008814,6363009150,6366001614,6371001115,6379057004,6385005727,6403435853,6403720973,6418802008,6429624813,6435386015,6442008019,6495244495,6522003629,6526800171,6529858737,6542008917,6565241452,6571009611,6572009717,6591009414,6607738737,6609510121,6623007015,6649067053,6653444013,6667016315,6671000716,6671002910,6690027216,6694007418,6703009219,6706007312,6727008317,6728314145,6747008315,6757079531,6761712894,6761712894,6762005219,6762417113,6763006412,6774009719,6796001015,6807800656,6822006041,6825006918,6848436894,6850242652,6854830732,6942286066,6953003118,6960123118,6970744492,6973001715,6975000819,6983564018,7008054010,7023000014,7032006322,7035755024,7035833299,7045005414,7065001933,7075358575,7087224894,7114073692,7116743535,7124007610,7135006528,7142118253,7149405937,7159799379,7167146005,7168555374,7174856172,7183396009,7216146652,7216811932,7233808978,7239000971,7253953933,7255794735,7272006832,7274435009,7279630733,7282104413,7319517209,7324196975,7333004497,7342317114,7345940023,7349208031,7355915372 ,7364970009,7381000025,7387124014,7422005013,7425006319,7433659019,7471001112,7507001006,7508437455,7522805138,7523005018,7547006212,7571922008,7574215375,7593006421,7609510120,7628644012,7633913935,7658495698,7664001210,7681006219,7700635859,7703009316,7719613007,7721998570,7741945297,7743993775,7761008510,7771002917,7774009816,7777405007,7791866000,7796829452 ,7814009213,7822081459,7825006025,7833002327,7840080014,7841263538,7852501010,7855004514,7881831010,7901736174,7926511010,7935705008,7941349375,7954797534,7977245007,7986007514,8005006014,8012213135,8024040816,8065001040,8075942005,8093798003,8105000330,8106782412,8122006419,8123003278,8145731859,8152925138,8164857297,8171002535,8177629615,8182004718,8183007116,8190863007,8192120011,8207365618,8223006451,8225575377,8227348495,8233316179,8239310573,8254565618,8285002711,8286003969,8298140655,8346004229,8364039775,8372301298,8376988976,8384676003,8409645934,8412008430,8413044336,8415005025,8418090007,8423018514,8440042732,8445006218,8459319211,8494770014,8505000019,8510144178,8513363210,8532070492,8541498004,8570399691,8581568014,8592866895,8594009130,8605186095,8606700651,8616514095,8626002912,8637007718,8639188975,8681006316,8694005445,8698708179,8702021623,8715577455,8747607372,8761191534,8771001917,8771490577,8772410126,8781865136,8783000913,8792664494,8801575856,8803671052,8806862250,8822030218,8831831032,8834231005,8855004611,8858064818,8860849004,8864004418,8865031546,8866009123,8872717614,8876004519,8882001958,8887489299,8898430250,8904000540,8912004610,8912676001,8916158571,8919073372 ,8920820045,8930525694,8935000330,8939146015,8942087010,8944004524,8962530413,8975305123,8978292658 ,8982908816,8991423699,9001046023,9019904179,9019904179,9052927002,9053007520,9060124113,9075609614,9134873930,9137554895,9155005419,9167564658,9177750410,9191211129,9195700048,9217209616,9246106012,9250325135,9253828015,9254849036,9261926894,9293768576,9315961457,9316008012,9336010748,9337005636,9371704657,9373009227,9373940005,9374413939,9396006114,9410729618,9423558573,9431912979,9436138495,9465005118,9473006932,9502007429,9503640652,9506007812,9565894896,9580508018,9612009415,9621402099,9635668007,9647003113,9687585936,9694007718,9695607167,9713008323,9725525296,9733937023,9746406116,9761008714,9761008714,9771002112,9785001211,9833905939,9837700811,9862003216,9864004514,9869901054,9882001047,9922004618,9925436174,9925983698,9933384651,9934007022,9967887296,9972758096" );

				Debug.WriteLine( "IT022 -> " + DateTime.Now + " COMED" );
//				RunScrapers( "COMED", "1274587022,1277068033,1278153022,1288082012,1291129051,1296000015,1302273008,1303115023,1305043048,1306339061,1306340000,1306341007,1310072006,1311639014,1345051024,1346224012,1347036123,1360425002,1361522000,1363712002,1363796017,1365735076,1365736082,1368135069,1371029089,1378046024,1383420041,1383536044,1383537032,1396072022,1409046010,1446167050,1453082017,1453653016,1461649026,1461660034,1463135043,1466717010,1473007047,1473488006,1477354010,1481036016,1481037013,1481040010,1485008018,1527689024,1527699002,1528167054,1528307003,1528373007,1543013039,1545825019,1550097018,1563144062,1563831033,1564119018,1569133018,1587066083,1605008134,1611039172,1616605023,1616608088,1619206004,1623007055,1633055027,1633094006,1633219012,1635030082,1638042002,1647439013,1649238050,1691145044,1698053049,1699004013,1699005010,1701039055,1716439003,1722039028,1722040021,1723337005,1731566038,1733499012,1733598010,1767689084,1767695019,1784465006,1787237013,1788228063,1789271022,1791476073,1791595000,1792274046,1795492037,1799619025,1800490056,1802732011,1807613020,1807614027,1809689040,1809708004,1819619014,1851364005,1862283011,1862352020,1862363005,1862758022,1862759038,1863246003,1863634030,1868033033,1868509032,1891681003,1893101008,1896431012,1896432019,1896442006,1896443012,1896465009,1896500003,1896501000,1942021035,1949386039,1949439008,1952818013,1962214009,1970337011,1981656018,1998019007,2011013033,2023052022,2027066102,2044691001,2044731028,2049038077,2053127041,2053168079,2058238003,2058256010,2058278016,2058304002,2059632005,2059719043,2059738011,2059739027,2059740020,2059749005,2063156009,2069690000,2071080005,2083088020,2102359000,2107041012,2112130062,2116740037,2120017023,2120353006,2121693009,2122137000,2123156018,2126084064,2131664029,2136389003,2136729007,2142472019,2145109022,2149174052,2149357006,2196010047,2199002065,2199079048,2210459020,2210460014,2210461020,2210462027,2214086023,2215033008,2216289013,2216431008,2216435006,2216438043,2222770016,2226081092,2229382050,2230328026,2230615006,2230763007,2239631006,2247013030,2265171008,2271013106,2279692001,2304386009,2304387006,2304392007,2304394001,2306372012,2307412015,2307413012,2311526022,2321187019,2353059008,2358135012,2359111016,2372318004,2382794016,2392416001,2392442001,2392468005,2397141054,2398291008,2401170065,2403299009,2403347019,2403352001,2403356009,2403366050,2447358001,2451085155,2460119128,2473051028,2476782011,2476784033,2476785012,2479340006,2479383001,2479397041,2479399036,2479735005,2481387028,2481389022,2517121007,2523043087,2529006015,2531049048,2537446005,2537451015,2541364007,2548555006,2573608029,2577015048,2604065038,2614268023,2615173069,2616403002,2637254018,2637505001,2640396034,2640517024,2641038022,2641039001,2643038084,2643260031,2643280033,2643322009,2643323024,2650594006,2650595003,2655153069,2659410029,2659411008,2659413002,2700026028,2700274006,2704364029,2708359006,2723282042,2725403030,2726379006,2730759049,2734165007,2739131065,2741176047,2741623050,2741663009,2754160008,2774061060,2783521015,2783522012,2788398007,2788399013,2796325009,2796341021,2796364006,2807625012,2807627007,2807628004,2808057036,2811619031,2817739014,2817740026,2817741014,2818722004,2818765045,2831062010,2831111009,2852044021,2871462012,2884419007,2886587017,2887036019,2901718074,2901761039,2902244000,2902596063,2909294026,2909301017,2909303011,2923137019,2942158056,2955157027,2977803037,2983634002,2985095030,2985107035,2985349033,2985353000,2993093022,2994293035,3027445006,3050122009,3055568050,3056629070,3057142018,3057177011,3059247016,3063113069,3069023082,3069085037,3072499036,3072515008,3072572003,3072573000,3072576010,3072585000,3073071023,3078072011,3079034006,3090108001,3110421034,3110429003,3111004037,3118091047,3126504053,3132213045,3135519008,3140787018,3150733013,3150735017,3150780003,3153464006,3153586034,3160072018,3181054001,3206317010,3212818019,3212819016,3213137022,3213398007,3213482013,3224210023,3229220029,3234016028,3234054000,3234059014,3234190010,3234205007,3235611054,3240536031,3240537001,3240552008,3244422001,3244638009,3265051002,3279528007,3288615004,3300112022,3308131010,3313225047,3316452000,3316459045,3316462015,3322473006,3325196015,3363437015,3372609010,3375730003,3380042001,3390324029,3400598015,3406568020,3408157007,3409378019,3409379025,3410692057,3447070012,3447302000,3447482003,3467635019,3468132008,3468327007,3477552009,3479198003,3493644002,3505064034,3513090039,3544467033,3549044012,3556457038,3559764021,3563720000,3570354025,3578718021,3579063043,3623329030,3623366006,3623559001,3630033021,3630355013,3631231021,3637488006,3637533042,3637573000,3637579020,3639052004,3664064012,3665531003,3666574011,3684134006,3699318014,3699368014,3713104023,3721467048,3721499040,3721500039,3729752035,3733121020,3733295007,3733467067,3743068012,3745732006,3749535012,3750070031,3750340001,3750367002,3777059009,3783090052,3795551024,3806444005,3806445002,3816237012,3816646002,3816656044,3841101016,3866544017,3878748016,3879603034,3879646011,3881221006,3881225004,3881226001,3881227017,3881231002,3881232009,3881278005,3881524011,3892317013,3899097023,3903206005,3906071004,3918717006,3918743015,3919465001,3958391022,3958684040,3960449024,3963001053,3963634034,3965356015,3966475028,3981161034,4002279007,4002495056,4015168013,4042652035,4043260013,4048387037,4049736007,4051246009,4056059015,4065143039,4074540028,4077415031,4087015025,4098003040,4098028001,4113084016,4124090002,4130745009,4130757018,4131237006,4131308000,4131388080,4131409002,4131410014,4131423011,4131428007,4131566002,4154280005,4167210008,4171281006,4171284061,4203672015,4210665002,4210666009,4210667006,4210775003,4211670016,4215009004,4215091075,4223066022,4230323014,4230325018,4238531018,4239171043,4240140027,4253711003,4266007009,4278120071,4287002068,4294089011,4299469000,4299475008,4299692009,4299693006,4299695000,4299696007,4303129002,4309511004,4371066067,4383044008,4383457023,4384582025,4387607001,4400727026,4411644001,4411645008,4411646005,4418751018,4418752006,4420139004,4455113045,4463133079,4467128010,4468586025,4473301007,4491081062,4545029065,4545424006,4552750020,4557419006,4561662006,4566148010,4566514032,4571638021,4571639000,4572171007,4582057023,4585419034,4588221018,4601075016,4603128001,4622572010,4623007003,4623134210,4637204056,4645346018,4645762012,4648695045,4656049020,4673728002,4693038045,4729001007,4729745013,4735206018,4753121027,4758019013,4791479013,4803068013,4803782009,4804822002,4804827025,4805787002,4815376048,4835061002,4882091076,4897619040,4897665042,4898255040,4898260078,4903587006,4903597002,4903620006,4905214024,4905296053,4909056000,4912075019,4915746042,4926258008,4927228013,4953060032,4965602013,4968321051,4968459023,4968572012,4968618004,4973034010,4975534004,4975636021,4980586001,5052068037,5052090039,5052095016,5052805003,5055634024,5055635049,5055638004,5060693026,5067563030,5075733000,5086124008,5086125005,5127570017,5127636010,5134213009,5134254000,5136001007,5136008024,5136608024,5140219017,5140666034,5143392013,5143401008,5143405006,5144056007,5144387007,5145529009,5148265011,5149035071,5149547012,5151458039,5154595002,5155696026,5156606017,5156623036,5164770008,5167041004,5170329035,5173813016,5177178027,5205113010,5211129042,5218624013,5219134063,5226182033,5226797007,5228136039,5229716059,5239685007,5241452018,5243401037,5250603005,5251843021,5253024033,5281018018,5302318051,5306371009,5307713001,5310496028,5310659007,5320655002,5323280007,5330350005,5335449016,5342322002,5373107044,5400627040,5401620045,5416286028,5451076006,5470524009,5490150014,5490171013,5503619015,5511127026,5513080035,5546656003,5556572005,5556605009,5561042023,5562700006,5592428062,5603064012,5640175001,5640201015,5640263006,5645087033,5645220010,5653543031,5659167017,5666569049,5671666000,5679186009,5681057031,5681106020,5684161005,5703002005,5703032067,5721006010,5724007000,5732109022,5742180048,5747021008,5748150008,5748612030,5749156031,5810664008,5810665005,5816726034,5827340013,5827343005,5831423007,5836328007,5836331013,5866085024,5868116013,5868163021,5892433014,5915417074,5931161013,5961095013,5992315004,5996500045,5996501033,5996519017,5996696055,5996704025,6001491010,6006785008,6010062018,6016259006,6045052011,6051048096,6064092008,6074514002,6083197000,6086526003,6090544037,6091378019,6091379016,6094505009,6143288024,6148230000,6151093002,6155168055,6157079033,6174047053,6180654028,6184247010,6185649027,6225770012,6225771019,6241602037,6246379015,6247147071,6249099014,6254813008,6259016045,6261247032,6266466019,6317664007,6323076013,6324270015,6340669030,6342610008,6342625009,6350657006,6387190021,6389366087,6395168033,6400612031,6412122042,6432094003,6436483015,6436489008,6436730000,6436731007,6437030054,6446034015,6447084037,6463158005,6483336005,6514774028,6518140000,6558066010,6567067016,6589138050,6589583019,6595377018,6601665012,6607196016,6638797025,6645365024,6651247000,6651248007,6651249004,6651250007,6651253044,6651254023,6651255002,6651256018,6651257015,6651259028,6651260003,6651264029,6651268027,6651269033,6651270018,6651271015,6651272021,6651273019,6651275022,6651276010,6651277017,6651278005,6651281011,6651282009,6653026027,6655802025,6655803004,6661202004,6676766006,6678011031,6678114028,6679199016,6679694007,6679695004,6724001027,6729183033,6735251024,6824673016,6825751019,6828259021,6858618001,6858619026,6897613004,6906037014,6911079006,6911362033,6913187029,6923149040,6934097011,6975339001,6998079008,7000664001,7022524024,7025365018,7026109005,7070633043,7071017016,7071579039,7073485049,7080037044,7080632003,7088602007,7091470028,7092676006,7096297029,7101641031,7109711003,7143106000,7151017012,7161021028,7166770017,7185073024,7189630016,7245480047,7247161009,7247249008,7247569032,7247570008,7250526005,7252162054,7270305020,7322062016,7325698009,7335546076,7350743008,7350759015,7350765013,7350768014,7357519046,7363422018,7363423006,7407686021,7435671003,7438088037,7438094044,7447446001,7479206013,7485442061,7491020035,7494005049,7494054033,7494403054,7494522045,7497648037,7509144000,7521140015,7527452005,7542107010,7585033028,7588233002,7613587015,7614321039,7646204049,7647240012,7676002008,7677456000,7725003008,7753802075,7759373000,7783105034,7822258003,7830603003,7837015001,7839777004,7850017021,7865725012,7903140015,7941001044,7944508022,7994663005,7998385020,8004024022,8010182044,8032176059,8032430012,8032431019,8067150054,8078340000,8097758022,8112748006,8113013011,8158021024,8174627026,8202402068,8202465001,8202466008,8235114000,8235128004,8235129010,8235130004,8246146018,8250010049,8251489020,8269002000,8325206020,8335360022,8337732008,8342414008,8366178018,8430215024,8433198066,8438029020,8453659006,8453665004,8483133024,8486676017,8496199018,8500581035,8504530061,8507548001,8529080017,8571106037,8586691034,8589094000,8589730001,8594803011,8661076024,8666706036,8668060006,8668215001,8673036003,8678367003,8682230064,8687167002,8689287025,8689290004,8689297003,8691411004,8691463008,8738200003,8738201000,8750157047,8759513005,8760116021,8763116014,8786619027,8787350036,8788208004,8840521028,8840737026,8843357002,8843529008,8843535042,8843536003,8843538007,8855747025,8855750031,8859573021,8859665042,8868344001,8871831013,8874128031,8921138005,8931605004,8934405006,8937333025,8939239048,8941160021,8941750016,8949223052,8949224040,8997526000,9026088021,9030783002,9037611018,9037612015,9082450010,9099211023,9109078023,9126625017,9126626005,9126627011,9126637008,9126638005,9172742003,9176056008,9182156028,9183642005,9202072052,9206464010,9255134027,9256115017,9279221009,9294238037,9342109021,9342306011,9354286015,9356643072,9363461008,9363463002,9373318014,9373799000,9377712045,9410150023,9426810003,9436634033,9436637016,9447263004,9458429045,9458431018,9478041001,9483083002,9502559041,9518379013,9531646026,9531688015,9587773009,9604792037,9608624012,9613299003,9678219021,9683353003,9683500020,9692648024,9699329068,9699334023,9703685035,9746513001,9756641003,9762667004,9771139004,9810134018,9837112007,9863263020,9874090006" );

				Debug.WriteLine( "IT022 -> " + DateTime.Now + " CONED" );
//				RunScrapers( "CONED", "212696221500001,212701160800030,212734305300020,212734305400028,212806648500019,212811647000037,212830739510042,233506514900005,233531314200000,233554110330037,233563889000028,233566110600003,233566111100011,233618603902055,233618641517006,233634162500008,233639361100062,233658050400104,233658122614021,233662838200000,233663497900013,233663684400033,233663761108020,233663761152002,233666675500042,233670450000012,233685033800159,233706869200023,233727764400013,233727818200005,233742423800024,233742423802038,233742492800038,233743675600021,233750463000017,233751899000027,233754900200016,233754900400004,233795597800048,233818465000036,233819907700019,233834518000014,233847807202000,233854089490030,233854095105051,233867816200019,233872711600008,233872753950030,233877654800002,233883009542067,233883204500019,233886633600003,233887912300034,233887913100011,233887913200043,233898355000080,233901276926019,252522408911004,252538485000016,252586454700009,252606447025007,252618051200008,252658636822017,252662335000024,252704034600009,252704034602005,252704039700002,252704039702008,252704039800018,252704100000019,252704100080003,252704100500000,252704100600008,252704105100004,252705378500028,252718061400026,252722010010001,252722366000010,252805107000058,252815350000069,252820460010008,252820460020007,252835740600014,255530108500032,255542043500027,255624619000077,255642437700025,255652344600010,255652344700018,255654368900003,255679131000021,255679240026016,255679259000001,255679259706011,255679981016028,255684162600111,255738362300011,255740497000003,255740508300012,255740508400010,255744017326013,255787024300091,255787026000046,255804411450023,255816437400030,255821329700208,255826458475019,255828536650019,255838209802003,255902715730130,255906000110049,255906205800055,255921036910007,255922023000067,255930420000077,255930425000015,255933347602009,255934440666073,255934441591015,255948084100017,255954207600008,255954232599027,255954232700021,255954411400062,255964005900005,255964053104005,255964064501017,255968026998005,255996171500011,266111211208008,266111951600018,266111952600017,266115153600023,266116134000093,266119054000010,266125096150010,266125157600036,266125287000016,266125294000041,266125295000032,266125295500031,266125663000010,266125686500012,266125700000056,266125737000012,266125891500005,266136189000053,266136198400062,266140020102003,266141393000014,266141474500007,266202178200029,266210050400013,266211040910004,266222242400009,266241259500006,266241260500029,266241299002005,266241444500010,266241562500032,266241563200012,266241563300002,266302033000026,266302033200022,266302033400028,266309030400083,266309045400060,266326099000034,266330161500004,266331456002003,266332912400088,266333156500005,266406116020007,266411985600012,266415106600058,266432129000018,266440022400003,266440023000000,266540423000029,266540423502016,266540424000036,266540468000017,266540472500002,266540604000012,266540609100007,266540733000032,266602101100008,266879711300117,266882348181090,266882376000048,266882417000080,266882511901043,266882511982068,266890457000019,266896461500001,266918132300007,266928031500003,266934058410027,266934078200069,266968731100027,291011015460004,299011612300019,299011919030012,299021001500004,299021010500003,299021102100019,299031015210011,299031022000009,299031905801010,299031905810003,299041013200005,299041041000005,299041070000009,299051901600000,299051916400008,299081006600001,299081080200009,299091004000021,299091004100029,299091004200019,299101005900010,299101005900028,299111906000000,299121952500001,299151032600000,299151035500009,299151918010001,299171924500001,299211056600003,299211210200005,301039024000006,301045407500009,301045423500017,301087021200012,301125644300015,301129114700027,301139455500050,301145007430001,301179032000141,301179191200003,301207702500056,301215438500019,301215439000001,301235394500001,301235557000062,301241416500003,301245021000002,301251389000006,302009446000040,302009649000052,302021048500087,302021057500085,302023051100011,302023051101019,302023051102017,302039103100007,302103072578096,302103077000120,302103078000004,302107152100036,302109054410000,302123162000025,302129180611032,302131122004011,302131128300009,302131146400013,302131342010004,302139149703002,302157070600005,302157071000015,302157072100004,302159501000003,302159517500038,302161011000044,302173551000003,302173552000010,302183046000054,302191040000020,302191116000029,302193062500069,302207595505013,302207596000105,302255228600008,302263194000179,302265174020028,302265177000019,302269359000011,302277156300005,302293232800009,302355674110005,302395002505013,302395002520020,302395700500035,302411100000078,302415092340012,302451159700004,302451818601031,313045217600029,313065475000027,313065592000025,313065638500020,313065654060008,313065722000002,313065789500027,313065844500046,313087553000018,313097068500006,313097069000006,313159252000001,313159253600007,313189005700011,313203070700028,313203071500005,313203134000019,313221070000009,313221072000007,313221074000005,313245200500018,313247011000014,313265234210004,313265234250018,313265234290006,313265234359009,313277047500067,313299283000008,313299283500007,313309186000037,313315214001004,313315283000044,313315548000003,313341050500008,313375070000029,313397073000129,313405048000007,313409090000006,313413134400057,313451206510015,313473078500049,313491101700006,313491120400000,313509082900004,313527071200038,313537003500074,313537025000004,313537025600019,313537040000021,313537080001038,313537113000015,313537247800025,313537281500036,313541091500004,313541100000004,313541102000002,313541142000004,313541390000003,313569130000017,313573011200076,313573011500038,313573012510044,313573013500143,313573031000019,313605001100013,313673200500011,313673214000016,313673269500019,313673270000017,313713098501018,313713122200017,313717053405008,313741049600019,313741050000000,313747060700000,313747115100016,313747156500033,313747180000034,313747194500037,313787116000005,313787160500009,313787180000006,313787205000007,313787207000013,313851080700014,313851420000000,313851421000009,314017104500009,314081010000025,314089097000040,314089121700045,314137265500026,314159558400003,314165129400000,314165129572022,314165138200003,314165145780005,314165164900013,314165165010010,314165165033012,314165167800012,314179200000001,314179255000013,314179327500008,314179365500001,314179452500013,314195151001004,314227026200014,314227030100002,314227067000018,314227072600000,314269095900009,314269100000027,314269103500023,314269105000022,314269105500021,314269109000028,314269113500013,314269114500012,314307030500011,314311280000003,314311305500003,314399125500006,314399125700002,314399125900008,314445075100006,314445143000014,314445180200014,314445208500015,314445214500025,314445232510014,314445232555001,314499373900005,314503000300024,314503001300007,314503005500057,314503006000008,314685013500003,314701000400014,314709108100006,314709128500011,314709129100001,314709141100005,314709142000014,314709154000035,314713166000009,314713171000002,314749012000017,314749012101013,314749700001004,314749701340005,314769000500000,314843051000150,314867020000017,325017039510013,325113001600013,325113072500126,325135074000060,325153146200014,325211018300013,325251048000084,325265003201008,325265004000003,325275013700006,325275049500008,325275060000094,325315141607044,325325052500047,325327000300025,325327001000004,325339039320015,325343098900089,325343101400036,325351299200159,325359075000065,326011003500141,326013335000006,326013505660019,326013611000001,326023108000042,326025102000043,326051062500103,326055031500029,326055055500012,326085002100079,326093037500024,326115095019124,326115095110006,326129144000100,326143099600004,326151108610005,326167044500068,326181120500041,326195082000071,326231067800019,326245026000099,326251060000037,326285102500059,326325037000021,326343395000004,326363114210015,326365083110001,326371085000125,326373109600013,326375120000016,326387188700007,326395005500138,326411021581117,326411032500049,326411054500042,326415056600023,326415056800003,326463032500073,326471148000003,326471148200009,326475051110006,326475101410000,326475107000110,326525034000011,326527067000124,326527100000016,326535000600074,326541191500016,326543114500073,326557118610001,326577089000057,326593064100010,326639067000135,326655121110009,326687054500047,326687098500052,326719001805003,393011000600009,393011007200001,393011464200007,393021224300005,393021450000022,393021520000010,393031405000001,393041402600000,393041402650005,393041402705007,393041402800006,393081013500041,393081083900006,393091006000008,393111040000077,393121350000013,393141001900007,393151000400024,393151000700001,393151090000007,393191001800004,393191203300001,401001118500084,401001154500022,401001193500009,401011286001005,401023397500023,401027166000016,401101049020028,401101111800034,401113167000054,401113168501027,401113170000042,401113182000089,401113224500112,401209226000000,401213172600037,401215208800044,401233326000058,401233326500065,401233327000073,402015101500017,402017166500114,402103264553013,402109019000051,402123066300033,402123188220002,402137248500005,402137255500021,402305152700032,402305153000036,402305251800022,402323168000099,402323177501012,403007358500021,403009288570025,403019026200090,403019142800021,403029135000067,403109209100033,403125111500003,411015409000032,411021034000025,411037826000031,411125335000004,411139177800009,411139520000000,411207166500029,411211264000031,411211267000038,411211268500028,411211705500037,411215252000002,411215252500001,411215253000001,411215263000009,411215469000019,411241120000024,412033295500014,412037349000046,412133097700018,412313446700006,412313446800004,413003613700009,413005684500002,413013421500020,413013996000000,413021020000003,413031269300014,413031277700007,413037142500043,413107990002002,413107990004008,413111256500014,413127646500001,413133347105017,413133353600000,413133711500025,413133736000035,413241127500057,413341075245026,413341387000036,413411248000036,413411441000056,413411700000011,414003081000006,414007185000002,414025620000015,414103626000048,414113204000005,414117855000008,414131569000048,414139152100000,414219083000030,414219320500032,414419325300061,415007932000056,415007932001013,415021496500013,415041244000009,415041245700003,415041245800001,415041245900009,415041245919009,415041245920007,415041245921005,415041245922003,415041245924009,415041245931004,415041246002037,415041246003019,415041963800001,415115297905007,415117179500039,416017135800003,416017919500001,416041352100012,416101230000006,416101230500005,416101231000005,416101231500004,416101232000004,416101232500003,416101233000003,416101233500002,416101234000002,416101234500001,416101235500000,416101236000000,416101236500009,416101238000024,416101238500007,416101240000012,416129009602009,416205190000003,416205279500006,416205755000000,417013675000004,417029295000042,417031159000001,417121220000021,417121702000010,417221004000013,421009141500001,421009142000001,421009148500020,421039087100060,421041026500038,421131055800050,421213002600039,421213003200003,421431103000038,422003168000044,422003185000027,422005075020007,422011117500089,422011118500161,422017176200008,422033049500060,422033058800047,422033059000175,422033062000261,422033063500301,422033067000100,422125121000033,422311030000013,423005062000094,423005062400112,423021027500060,423105165501012,423105166500021,423129142000062,423131040000012,423131070200011,423131070400009,423131070560018,423131070570017,423131070590064,423201075500077,423233119600035,423301040600034,424023104500020,424023170000079,424029012905045,424035091100051,424101100400013,424133001640041,424133001680070,424203117600005,424203117702025,424205066000004,424221071000020,424229008500111,424237001500053,425005033900016,425005034500005,425011071200061,425011079000042,425019026000015,425037082010009,425123113000019,425123113500018,425123114000018,425123114500017,425123115000025,425123115500024,425207077000048,425219030300001,425239011000040,425407082500004,426005048000009,426005111002015,426005112301010,426005112500017,426009086000053,426027024000001,426037149000018,426041022000038,426111083050014,426125054998076,426233003500041,426233037100016,426239042300004,426303106500006,426313057000039,426313164500012,426313165000046,426333000501016,426333000502022,426333006000054,426403060076017,427005076400054,427011080025002,427019560500014,427023007600031,427025032510051,427101183500017,427105046000040,427105047028016,427105047100005,427105047110012,427105110070002,427111082100009,427111082110008,427119019500001,427203011500019,427203013100016,427203013500017,427203016501087,427203017500021,427203020500117,427203204500032,427205010900058,427205013200126,427205013210000,427205013700083,427205018000117,427205019200005,427219150400019,427225022000044,431011038700056,431015608000029,431033390001014,431033390500015,431041151000083,432001020600033,432009123000001,432017183900028,432041239700018,432041513000085,432109651000009,432109651000025,432127382000023,432127407500007,432129051000029,432217668500018,433017429000020,433021085600057,433023305900010,433037662000024,433037691000003,433037694500017,433037712000008,433041171000012,433041174200023,433113105903007,433113106500000,433113165000009,433113182600005,433117285300017,433117310500011,433117447000000,433123395615047,433205100510009,434003218500015,434007260500005,434009312500009,434013119000023,434013125200005,434013125600006,434013126510014,434013502000010,434025626110004,434027175000040,434035521500068,434037645501006,434039192500043,434039192502007,434039193000035,434039193500059,434101006500047,434117163240045,434123129500043,434125137800034,434135223000076,435003240000041,435009241000021,435015250000018,435021004601002,435021005800033,435039016000047,435041030024011,435041202010053,435041202200001,435105504500028,435111507500007,435111515500007,435111523500007,435119009000012,435121515600061,435123340500037,435127629000023,435133102000019,435139204902010,435319052900106,436003160000012,436007321500000,436009079000001,436009082500005,436009090500013,436009383000002,436025128000073,436039222000038,436039244500049,436041153000011,436125467500087,436125467710033,436127001500045,436205182550011,436213123000047,436213123500020,436213129800002,436213130000006,436213365700015,436337117000000,437011266000009,437015170900014,437015171300032,437015171400014,437019375500009,437019415500001,437019672500033,437033065000055,437037028000078,437105620000000,437127298000021,437127351601012,441001000370010,441001000371018,441001000377031,441001000378013,441001046500000,441001053521121,441001055000108,441013813531027,441023018700095,441023116200048,441025108500004,441025119500001,441027321000002,441027332000009,441041053200029,441103081500026,441103082400002,441103102300042,441109012793002,441125060200013,441125062000056,441125189762018,441125189768015,441131015500051,441131016000077,441131016500126,441131017000084,441131017001116,441131017100074,441131017200015,441131017400078,441133167100003,441137069000104,441211064000102,441307000610119,442001090000070,442005103500026,442027082007112,442029015100030,442031374000025,442105060000026,442115045900018,442115046081040,442115048500054,442119093191025,442123036600118,442129000101009,442129000150006,442129000220031,442129054080018,442129093205014,442129199100002,443005085200008,443023070000028,443023161500019,443025283000026,443027032500116,443031091500017,443103053510001,443103053720014,443103053721038,443103053741002,443111120500004,443117000521051,443117008910025,443125268000049,443125268200029,443125269500021,444011302567004,444013001500021,444017091100006,444113020000001,444125048950009,444213062000040,445019090506059,445023095150038,445027066200078,445031113100000,445035070500037,445111081158006,445121123000025,445121164600030,445121165100014,445121173500031,445121182000023,445123105500006,445123122000006,445221001700025,446021055450009,446033205000006,446033209500001,446033211000065,446033221515029,446041137000069,446109127533074,446115087500011,446123074600000,446209052800090,446209052903019,446237061500047,446237062000054,447009120500014,447017053600008,447129015000050,447129015500067,447129019680048,447129019685013,447129019690021,447129019692043,447129070510019,447129080000027,447129080500018,447235105500071,451013022100041,451013030500018,451017200700019,451035015000029,451035030000020,451103130500016,451113099000015,451115064715006,451125022200066,451135050000007,451135050400017,451135060000013,451137038600031,451137038700013,451137066310008,451137066311006,451137066312004,451137197500006,451203070105030,451203549500001,451235003000011,451241166000012,451319019900008,451319040000018,451333101900016,451333110000014,451519001234023,451531152000103,451709121800015,451809049700089,452009174000012,452017132000040,452017136500029,452017150001029,452017150300009,452103018500087,452111198500009,452119022600069,452119022800057,452129080000003,452211126500012,452213109000010,452213126500000,452215030000019,452215030500000,452215030501008,452215030502006,452215030503004,452215030504002,452215030505009,452215030508003,452215030509001,452215031002006,452215031003004,452215031004002,452215031005009,452215031006007,452215031008003,452215031009001,452215031501007,452215031503003,452215031504001,452215031505008,452215031507004,452215031508002,452215031509000,452215032001007,452215032003003,452215032005008,452215032007004,452215032008002,452215032009000,452215032501006,452215032502004,452215032503002,452215032505007,452215032507003,452217060930024,452229015501008,452231247500006,452231248000006,452231248500005,452231249000005,452237063000013,452313068500024,452411032400022,452415022000015,452415036000019,452415088700011,452431281500009,452431289500001,453015065000010,453039015000011,453041038400012,453041039100017,453137079800050,453137093000026,453141093001000,453211020000019,453211040500055,453211052100000,453219061500102,453219135000014,453311026500010,453331089000013,453519026800012,453619050100014,453709030500019,461307003001022,461401054000056,462009040900013,462023099500079,462029116800012,462033082000003,462039032000019,462133080730021,462203026570003,462415009000119,463003068511009,463015132000009,463113049000004,463113049100010,463129217000006,463133109603091,463141090000003,471015000400034,471025116500106,471105032581008,471121139000032,471121145500017,471137013800032,471403000500005,471403036000020,471403036500052,471403037000052,471403037500093,471403258500004,471403259000004,472001222800028,472015060800023,472031071500080,472103083000027,472117202001039,472301033000010,472305010000042,472331022701096,472331022703092,473011075700018,473011075800016,473201019500042,473201019510017,473201114900006,473201115000004,473223049992056,473307009000057,473307009300010,473407157700001,473535060500017,473535072000014,474105089740041,474141204400005,474203092000030,474203093000054,474203127010020,474211053500013,474211054200084,474219141400021,474231044500013,474305071300016,474311083906014,474311083909034,474311083910016,474311083911014,474311084500048,474311085000097,474321106500041,474325130700014,481017100500075,481021043082019,481021043500002,481321112000029,481325347700014,481407005800029,482101033500037,482101069000050,482125217800129,482403140000004,483123031500016,483237161000025,483335030000059,484115178500030,484229263000101,484325001700018,484325034700019,494021016000001,494021141000009,494021401730006,494024603800015,494024610000005,494031207300003,494032388500007,494032409500028,494041001500013,494043667400017,494051011800006,494051033600004,494051039500000,494051046000002,494051106500024,494052205000007,494073709600001,494073709700009,494081303300001,494081303400009,494101004100003,494102307800000,494103518500009,494112308797022,494121207500015,494123709800000,494151220500007,494151280000005,494152520500002,494152614200006,494161407100018,494171007400007,494171102840008,494173704900008,494192210010029,494213703600009,497518002500008,499028136000006,511007049500025,511013020100017,511013026500004,511018043700099,511024000901001,511024001200049,511024003700038,511024006800009,511024008100051,511024008401004,511118018300014,511121223701018,511121796667000,511121796672000,511133458150019,511138039300041,511138165510009,511213058500027,511234002901020,511234002902010,511234003000038,511238000103000,511319030400028,511337248300012,511337248301010,511337248302018,511337248303016,511337248304014,511337248305011,511337248306019,511337248307017,511337248308015,511337248309013,511337248311019,511337248312017,511337248313015,511337248314013,511337248315010,511337248316018,511337248317016,511337248318014,511337248319012,511337248320010,511337248321000,511408388000009,511408388500016,511436023900002,511437075701009,511506017900034,511506027501004,511513042700074,511513044001026,511513044200016,511513044400012,511513044800070,511517023701043,511603124700017,511608072600010,511609018100016,511701398500038,511701400000043,511735028801010,511751027510023,511751741000012,511772222500007,511772247005016,511895007600039,522003003200022,522003005310043,522003029500066,522016012900010,522017037501015,522019009010009,522103016000052,522104017200071,522107408900001,522111011900002,522111012000000,522119011300016,522201047600013,522202053600061,522304011700031,522304011800039,522304020100017,522309014700011,522311035600022,522311038957023,522311937800027,522320017570038,522320017585010,522320059710039,522403048000058,522404022560000,522408055100006,522412000501045,522413028602070,522414006610002,522419009200032,522419032850001,522508034901018,522508034903014,522512055300027,522603050575000,522613030300031,522618005301005,522618026100022,522618029400007,522618029500004,522619010500003,522621142510009,522707100300010,522708049800003,522714040800000,522714040910023,522719019400005,522895033704075,522980591900008,544543091000002,544543719000046,544544049500002,544545466000004,544545466500045,544545467500085,544554174500008,544562083500027,544582782001002,544582782004006,544603028400038,544604038700045,544606003300057,544609052900017,544627039004000,544701022700005,544701025400108,544701025700044,544701027508015,544707316500001,544707331500002,544707332500001,544707360000007,544707363500003,544707364000045,544709083000009,544710097511106,544710097515057,544710097516030,544710097523051,544710097528019,544713419400008,544717018909012,544837416000014,544837417500004,544837417503016,544837417800008,544850521500000,544860463520007,544860668100001,544860668500002,544863288500022,544863586500021,544880121500001,544880121600009,544880122000001,544880125700003,544880125800001,544880125900009,555540075510002,555552627504029,555556326520004,555601058772009,555602078004001,555604116402031,555606016100011,555610043200000,555613040600024,555615026910004,555615027110000,555615027120009,555615027130008,555616035200015,555703039277015,555706048710017,555713024550003,555716037706033,555716075200022,555716076915008,555838208500019,555858205500010,555858275500007,555858276500006,555859146000029,555859146500028,555859190000040,555859194004006,555859197502006,555869265000023,555869265500063,555884414000022,577310324500012,577325019500002,577411525500064,577411659000014,577411829500026,577411839550029,577414516000011,577417544583049,577417545030008,577426177500006,577516051006037,577516051010005,577516051500005,577518224500011,577518942800008,577524337800017,577708035300012,577709012600069,577810041904017,577810060956054,577810080100006,588018611000029,588028242500024,588040036500003,588050021645002,588050021651000,588050021655001,588063103050025,588493223000008,588493334000004,588506302000050,588507002000010,588507209506033,588511039600040,588513046403004,588704094512008,588704247700005,588713192500005,588714318000003,588721060500015,588721517600012,588722110500005,588725064000021,588725096500014,588725307600009,588807047400013,588809011420001,588818015211019,588903026100003,588906062303019,588906115000000,588909054000080,588911037545025,588912343000010,588916053600034,588919011801017,590002210010007,590003310010012,590003513000000,590004510007006,590004510018003,590004510020009,590004510022013,590004510023011,590004510025016,590004510026014,590004548260007,590005220000025,590008510523003,590012310000006,590012452710008,590013312020000,590013312030009,590013312040008,590013430100007,590017950020008,590017950500017,590020234200032,590020761600018,590021540110006,590516169310001,611004214500004,611004215000004,611006267500005,611006268100003,611014095000057,611018098000089,611020670500007,611039001000008,611046161000009,611054014450009,611098782501006,611142120181046,611186066302157,611188029200064,611370194900021,611402060707048,611402090500090,611402136300018,611402136301016,611402136303020,611402136304036,611402136305025,611402136306015,611402136307021,611402136308011,611402136309019,611402136310017,611402136311015,611402136312021,611402136314001,611402136315008,611402136316014,611402136317004,611402136318036,611402136319042,611402136320024,611402206300013,611402206500026,611402206600016,611402206700014,611402206800020,611402207000026,611402207100024,611402396800046,611404352800069,611404358730013,611404776930054,611406245900022,611406246203020,611407118600038,611407274070018,611412161400021,622008079800059,622009005000004,622015152000002,622020745100004,622020828500013,622033092000008,622038118000007,622046473000009,622104090603026,622106090500003,622116125501009,622142654500006,622262107000006,622314338100004,622320197405012,633002101705003,633056569200006,633070062400062,633096350700012,633100272100002,633134520200009,633190098000023,633216010100169,633248034500009,633278674000010,633286496000035,633324346500019,644114247000012,644150093500010,644242906000013,644242908000011,644244550500025,644250139000007,644274158801020,644276196100000,644919131402003,655004059000000,655004164501009,655004167200021,655004168000057,655010000100005,655070628000011,655070661500018,655074350000009,655074351000008,655081522000007,655081540000005,655082003201007,655082270326008,655082270327006,655082270328004,655082270329010,655082270410000,655082270420009,655082270430008,655082270440007,655082270600014,655084164801047,655084597500059,655092032200086,655144136500042,655144144000068,655232118400008,655250067710003,655250130605008,655250145400007,655252142800007,655252143900004,655252144602005,655252144637001,655252144655011,655262036300014,655290133400007,655290138500009,655296002104018,655308032600004,655308032601002,655374200700000,655376093600007,655378245716004,655612006102032,655703074340024,655704025710000,655704027310007,655704028510001,655704031210003,655704031310001,655704034610001,655704034700000,655704036510001,655704038120007,655704043940001,655704101830003,655709025800016,655714191400005,655715026000035,655801030200009,655801033150003,655801065100009,655801089315013,655801090302018,655801095335005,655801128740007,655801168901014,655802081201029,655802081600006,655802123101013,655802137601008,655802138320012,655803088430009,655803088720003,655807564500003,655809040000004,655809217900028,655811517000004,655814229100047,655814229225026,655814229230026,655819060820017,655819070860003,655819071600002,655819149700032,655819188812003,655819195902003,655819356300005,655819559500005,666044007700001,666050151100146,666050151400033,666058105500006,666076432000037,666092040000004,666092101200089,666106125300087,666110252500048,666124712600017,666138794500002,666138799000008,666164330000000,666164577500001,666176880500023,666184136900088,666196199700007,666206024000034,666214032302038,666242078981076,666242094704007,666242094706002,666242113600079,666274592100032,666306119102032,666335463900030,666364922500017,666372164500009,666412008700041,666414028715082,666418629507020,666430000400055,666436043400010,666438153200081,666438153300089,666450099700025,677033024500004,677108089141009,677108089800026,677116120500059,677128265400060,677156160900074,677182084200045,677182088900038,677194037000067,677266156900044,677269267181033,677314184601034,677334074000048,677334095001033,677334095002031,677334095501016,677334095502014,677550446600039,677550449100045,677650624500017,677700217000006,677700598000021,677700598001029,677700624500002,677702199100002,677702199200000,677702446000005,677702446500012,688008117800021,688008118200007,688008118700071,688022464000010,688034087700132,688070469000006,688085117500009,688085118000009,688085195000005,688087040500007,688108106000003,688108106500002,688109049000001,688113199000001,688144057800117,688204583500050,688300308500001,688314087700039,688314087800045,688334432000026,688334479500060,688420208102003,688424260000014,688436088204016,688436293225012,688436631000044,688460196103019,688476170500053,688482047600068,696021603003000,696021620400007,696021670200000,696031104500008,696041102200006,696041102300004,696041470000004,696081830000005,696111054601012,696111080015013,696121009000004,696131506200007,696211214000004,699028910200002,700120511000001,700150415520010,700215269000003,700240462000014,700240462500013,700240564300007,700320102900037,700320103100025,700320120000034,700320120100057,700340035000010,700340035150013,700340035200016,700340035210015,700340505000011,700345035000183,700365617000005,700365617500012,700505522600007,700505525601010,700520012400008,700520023010002,700520023050073,700520023110000,700520023150063,700520023200066,700520026500025,700525145800008,700525286110027,700525286115026,700530161500011,700560088600008,700575007530037,700580355500020,700580356000046,700625706915003,700640198000131,700640199000072,700795313000000,700810147500016,700845042600008,700855359000007,700855361000003,700855361020001,700875020000020,700925022510003,700925022515002,701025084305001,701065025150017,701065025320016,701065025330015,701070041880019,701130110000004,701135040000024,701180040000012,701180040500011,701180041000052,701185590000007,701230390780042,701245088610012,701245088670016,701245088675015,701265227500015,701270210900016,701270210905023,701280070000088,701290240000009,701325400800010,701330037000034,701360013342019,701405008000005,701405010000027,701405055000015,701425107920002,701440502020001,701440502025000,701440502105000,701440502110000,701450381000099,701450382000007,701470303900010,701470304010017,701525202500003,701575017310015,701575043600025,701575120825024,701585113000105,701610300000013,701630235000003,701645354000105,701705170000059,701725573925017,701750470570013,701755407521013,701755407525014,701820339300009,701855224000082,701905433175058,701945225014024,701945225015021,702105319010003,702105320000084,702135035000046,702135035500037,702135040000023,702135049030013,702135049040012,702135336700005,702135400505017,702140310500025,702140311000058,702145052000027,702160263240049,702160263580048,702160264190011,702160264195010,702165043090010,702165043095035,702165043100058,702165043365065,702165043500026,702165140800030,702165140810039,797501010000010,797504032500009,797507014300009,797510007000016,797511030000007,797512005000014,797514021000044,797520005500008,799022083000009" );

				Debug.WriteLine( "IT022 -> " + DateTime.Now + " NIMO" );
//				RunScrapers( "NIMO", "0006056015,0018043000,0018127001,0019128020,0020000104,0036170000,0042074000,0063003010,0076038018,0077099006,0079136002,0081119002,0083685107,0086088002,0107082002,0125111104,0132001006,0134932102,0146076002,0148083005,0163685103,0196112008,0213085002,0217158006,0222446102,0225013016,0227092006,0246366138,0260165017,0265177106,0267117000,0308080006,0332147029,0357651140,0376075008,0425028011,0463670215,0472153003,0477509103,0495184131,0507607105,0579016014,0636298167,0737670156,0793733105,0831401113,0891022012,1037621114,1074709006,1103005019,1111036028,1173840108,1196409169,1241368106,1295225107,1398833130,1413120038,1434972103,1443761163,1492518109,1494989213,1517603101,1552515117,1690121111,1706324102,1811304132,1846136008,1903025008,1921013033,1996397160,1997670104,2073733116,2178050016,2257670118,2282511122,2409886113,2414893102,2491293104,2508735119,2621009007,2728662415,2734988108,2772525123,2784261036,2807526103,2878776108,2879057139,2954923134,2991006003,3002488130,3011434122,3034988105,3071352123,3080052001,3126392124,3159102103,3161226109,3167062010,3167163012,3214923102,3226395109,3252170007,3253835105,3351578010,3374984141,3394039101,3411059010,3434022119,3441089008,3448716133,3567156033,3580199107,3601315103,3613701119,3660199103,3676070011,3687002010,3741315107,3812543108,3812554110,3841156002,3875178101,3914972118,3926298109,3972516129,4123766123,4200199108,4285100105,4358834101,4366324105,4423634202,4433710111,4458101001,4459191009,4508693109,4609940109,4670072021,4706399102,4747607105,4758807111,4843672126,4956305109,4998834123,5003657113,5057107011,5122560119,5140163001,5189925107,5242511123,5478001049,5669890103,5792529102,5863764108,5955102105,5988045008,5995102116,5995102125,6148700105,6194967136,6206357115,6210139116,6228678168,6324882104,6483042017,6514989145,6518841100,6530128142,6606707006,6625054011,6664913102,6683669101,6754932106,6803634206,6858733227,6885099101,7015238102,7106302100,7202531116,7283678103,7623784124,7730139104,7750139100,7758838100,7903718102,7907609113,8041730025,8128779115,8174020125,8257652116,8398890141,8407537122,8415080132,8447513106,8452543107,8552543109,8624913102,8630134108,8710094105,8722508105,8765163119,8865088131,8878732102,8883659101,8915175109,8953786115,8992543109,9058791128,9095175106,9115175104,9121338108,9127608127,9218791200,9243727110,9328680216,9337652284,9527513112,9586280112,9626280116,9675177124,9753780101,9835240133,9887561103,9954963117,9980002130" );

				Debug.WriteLine( "IT022 -> " + DateTime.Now + " NYSEG" );
//				RunScrapers( "NYSEG", "N01000000033738,N01000000052738,N01000000060178,N01000000061515,N01000000064352,N01000000077214,N01000000082446,N01000000084947,N01000000091090,N01000000092650,N01000000093963,N01000000096883,N01000000101741,N01000000112110,N01000000126052,N01000000129494,N01000000129882,N01000000130435,N01000000132423,N01000000132910,N01000000144188,N01000000144501,N01000000158162,N01000000158493,N01000000167189,N01000000181214,N01000000182154,N01000000198820,N01000000202390,N01000000204719,N01000000209437,N01000000215095,N01000000215715,N01000000228478,N01000000231043,N01000000238931,N01000000244368,N01000000246348,N01000000247155,N01000000248872,N01000000259820,N01000000260802,N01000000276535,N01000000278754,N01000000280180,N01000000301853,N01000000309625,N01000000312496,N01000000338574,N01000000368480,N01000000411389,N01000000416800,N01000000416826,N01000000420158,N01000000428516,N01000000500199,N01000000543447,N01000000581702,N01000000610568,N01000000613000,N01000000695114,N01000000733865,N01000000747147,N01000000755553,N01000000794362,N01000000926436,N01000000994012,N01000001077726,N01000001144096,N01000001173194,N01000001181205,N01000001189919,N01000001239664,N01000001392828,N01000001413335,N01000001428523,N01000001571785,N01000001615202,N01000001670926,N01000001690825,N01000001697895,N01000001723493,N01000001847649,N01000001890920,N01000001997139,N01000002015527,N01000002040897,N01000002057420,N01000002165355,N01000002304103,N01000002422988,N01000002459642,N01000002688075,N01000002700078,N01000002771632,N01000002785988,N01000002966844,N01000003012234,N01000003047487,N01000003086600,N01000003115268,N01000003158029,N01000003255759,N01000003273984,N01000003276409,N01000003297165,N01000003315801,N01000003368073,N01000003507498,N01000003552312,N01000003686672,N01000003691292,N01000003825940,N01000003891363,N01000003954021,N01000003978897,N01000004009411,N01000004050936,N01000004051744,N01000004127122,N01000004150025,N01000004270682,N01000004417747,N01000004437125,N01000004624110,N01000004645305,N01000004674297,N01000004997664,N01000005059803,N01000005090030,N01000005265111,N01000005285770,N01000005612098,N01000005675145,N01000005791421,N01000005814157,N01000005861901,N01000005885041,N01000005953534,N01000006100333,N01000006147797,N01000006203186,N01000006227870,N01000006239222,N01000006356190,N01000006437628,N01000006487516,N01000006492979,N01000006507313,N01000006513956,N01000006531008,N01000006648414,N01000006716070,N01000006790752,N01000006839930,N01000006880579,N01000006923775,N01000007062581,N01000007295124,N01000007646565,N01000007786031,N01000007826829,N01000007867187,N01000007877004,N01000008243107,N01000008320293,N01000008909962,N01000008967416,N01000009063470,N01000009147620,N01000009157892,N01000009367905,N01000009410168,N01000009478785,N01000009709338,N01000009862558,N01000009943283,N01000009978081,N01000010043909,N01000010099372,N01000010113926,N01000010256642,N01000010398139,N01000010460194,N01000010608628,N01000010741353,N01000010819746,N01000010832475,N01000010870699,N01000010971141,N01000010980357,N01000011022332,N01000011051364,N01000011097821,N01000011108487,N01000011114741,N01000011159407,N01000011212057,N01000011237716,N01000011281680,N01000011293289,N01000011453362,N01000011667490,N01000011702073,N01000011965696,N01000012036034,N01000012109559,N01000012138111,N01000012176434,N01000012276549,N01000012308359,N01000012347092,N01000012423141,N01000012613980,N01000012685715,N01000012771549,N01000012802112,N01000012966602,N01000013330394,N01000013600630,N01000013702337,N01000013725304,N01000013732763,N01000013924030,N01000013925847,N01000014016539,N01000014037576,N01000014039648,N01000014422562,N01000014431795,N01000014492698,N01000014598940,N01000014673545,N01000014793863,N01000014800155,N01000014914550,N01000014948855,N01000015044985,N01000015080989,N01000015143548,N01000015171820,N01000015181639,N01000015182264,N01000015191067,N01000015207046,N01000015270812,N01000015295017,N01000015388945,N01000015421118,N01000015579311,N01000015597289,N01000015646938,N01000015689227,N01000015726631,N01000015742414,N01000015754369,N01000015779101,N01000015802044,N01000015825961,N01000015839251,N01000015889561,N01000015898299,N01000016176257,N01000016189599,N01000016220543,N01000016391997,N01000016567265,N01000016616039,N01000016764813,N01000016794356,N01000016884942,N01000017001819,N01000017024928,N01000017112855,N01000017222803,N01000017311176,N01000017318973,N01000017440215,N01000017484411,N01000017845173,N01000017896218,N01000018059899,N01000018080879,N01000018133892,N01000018181784,N01000018185033,N01000018275099,N01000018531558,N01000018568329,N01000018599126,N01000018630327,N01000018660118,N01000018689596,N01000018731364,N01000018891218,N01000019074079,N01000019112515,N01000019600600,N01000019859800,N01000019893106,N01000020013470,N01000020094371,N01000020239463,N01000020309910,N01000020459061,N01000020556874,N01000020580353,N01000020598223,N01000020637690,N01000020682720,N01000020780953,N01000059313122,N01000059322214,N01000059401851,N01000059415331,N01000059427633,N01000059462903,N01000059471854,N01000059580712,N01000059581694,N01000059641373,N01000059641381" );

				Debug.WriteLine( "IT022 -> " + DateTime.Now + " PECO" );
//				RunScrapers( "PECO", "0045101502,0171046156,0252900400,0325000305,0345122072,0515059024,0530162059,0633101185,0787401702,0853112008,1102200305,1404501604,1811700100,1894800301,1911400405,2331400600,2387000401,2388200700,2431500108,2431501900,2431800604,2520600107,2640301409,2697601004,2739822025,2741000506,2778026012,2963001202,3050300900,3050301507,3316201200,3423601406,3588701405,3614689096,3669000606,3978301206,4192901706,4288000604,4597000804,4597300400,4609700409,4787531000,4906501801,4986900506,5215801206,5215901009,5288600803,5525000305,5676400507,5834400502,6059101801,6107401208,6240600108,6462800703,6718100509,6772001105,6857500609,7042691035,7081200706,7263300601,7282901203,7336201204,7336701600,7392700908,7441701403,7757792007,7906800101,7948100404,7954000902,7998600306,8206600802,8271700707,8522200904,8580801406,8588401617,8620000506,8930800404,8939200303,8964401004,9192146061,9316701708,9544101907,9544200408,9544300103,9813600305,9853400606,9916801508" );

				Debug.WriteLine( "IT022 -> " + DateTime.Now + " RGE" );
//				RunScrapers( "RGE", "R01000000086033,R01000000094425,R01000002289445,R01000017211053,R01000017211061,R01000032240798,R01000033034042,R01000033642992,R01000033672239,R01000034343004,R01000034982983,R01000036923910,R01000037803327,R01000040103780,R01000041360702,R01000041492968,R01000045292760,R01000046688651,R01000047211545,R01000047580436,R01000049230709,R01000050340769,R01000050712207,R01000050967991,R01000050985118,R01000051031623,R01000051046167,R01000051046183,R01000051046191,R01000051134161,R01000051206878,R01000051309698,R01000051467157,R01000051575322,R01000051579167,R01000051658904,R01000051660306,R01000051660611,R01000051660926,R01000051664837,R01000051666246,R01000051666261,R01000051666287,R01000051666295,R01000051666303,R01000051720613,R01000051737526,R01000051750974,R01000051851178,R01000051852424,R01000051853380,R01000051858645,R01000051859015,R01000052107778,R01000052113719,R01000052415791,R01000052419926,R01000052522513,R01000052629565,R01000052631728,R01000052939881,R01000052998002,R01000052998135,R01000053047601,R01000053236725,R01000053463022,R01000053601027,R01000053640686,R01000053989497,R01000054192521,R01000054265822,R01000054477856,R01000054540968,R01000054548946,R01000054651260,R01000054679824,R01000054737820,R01000054779178,R01000054825625,R01000054830955,R01000054925193,R01000054944491,R01000054979794,R01000054984547,R01000054988019,R01000055013023,R01000055027056,R01000055092480,R01000055127666,R01000055127906,R01000055129910,R01000055268544,R01000056410277,R01000056444300,R01000056654387,R01000057169823,R01000057239774,R01000057454944,R01000057474165,R01000057506255,R01000057533341,R01000057538902,R01000057638165,R01000057680852,R01000057688541,R01000057728685,R01000057730947,R01000057732836,R01000057781908,R01000057799801,R01000057870834,R01000057915258,R01000057977092,R01000058007568,R01000058106303,R01000058162587,R01000058230608,R01000058288960,R01000058460932,R01000058510140,R01000058544396,R01000058598467,R01000058780537,R01000059008185,R01000059096412,R01000059181123,R01000059181131,R01000059335786,R01000059361006,R01000059370288,R01000059387084,R01000059519793,R01000059544361,R01000059584508" );

			}
			catch( Exception ex )
			{
				string str = ex.Message;
				Debug.WriteLine( "IT022 -> " + DateTime.Now + " Error.." + str );
			}

			Debug.WriteLine( "IT022 -> " + DateTime.Now + " DONE.." );
		}

		// ------------------------------------------------------------------------------------
		public void RunScrapers( string utility, string account )
		{
			string[] accts = account.Split( ',' );
			string exceptions = "";
			int i = 0;
			object actual;

			try
			{
				for( i = 0; i < accts.GetUpperBound( 0 ); i++ )
					actual = ScraperFactory.RunScraper( accts[i], utility, "", out exceptions );

			}
			catch( Exception ex )
			{
				string msg = ex.Message;
				Debug.WriteLine( "RunScrapers error with acct " + accts[i] + ", :" + msg );
			}

			Debug.Print( "Errors: " + exceptions );
		}

		// ------------------------------------------------------------------------------------
		[TestMethod()]
		public void TestScrapers()
		{
			string utility = "ameren";
			string accountNumber = "3858348170", exceptions = "";
			object actual;

			actual = ScraperFactory.RunScraper( accountNumber, utility, "", out exceptions );
			Debug.Print( "Errors: " + exceptions );
		}

		#endregion

		#region usage calendarization
		[TestMethod()]
		public void TestUsageCalendarization1()
		{
			DateTime start = new DateTime( 2010, 1, 1 );
			DateTime end = new DateTime( 2011, 7, 15 );
			UsageList histList = null;

			try
			{
				histList = UsageFactory.GetRawUsage( "5181831008", "AMEREN", start, end, "TestCase" );

				var hasMultipleMeters = UsageFactory.HasMultipleMeters( histList );

				var usageLists = UsageFactory.SplitMultipleMeters( histList );

				var timeSeriesCollection = new List<TimeSeries>();

				foreach( var list in usageLists )
				{
					var timeSeries = UsageFactory.UsageListToTimeSeries( list );
					Assert.IsNotNull( timeSeries );
					timeSeriesCollection.Add( timeSeries );
				}

				var calendarizedTimeSeries = TimeSeries.Aggregate( timeSeriesCollection );

				var monthlyCalendarizedUsage = TimeSeries.SampleDailyToMonthly( calendarizedTimeSeries );

				Assert.IsTrue( monthlyCalendarizedUsage != null && monthlyCalendarizedUsage.Count > 0 );
				Assert.IsTrue( timeSeriesCollection.Count > 0 );
				Assert.IsTrue( hasMultipleMeters );
			}
			catch( Exception )
			{

			}

			Assert.IsTrue( histList != null );
		}

		[TestMethod()]
		public void TestRegularExpressions()
		{
			const string DisplaySucess = "RegEx successful - Index: [{0}]; Length: [{1}]; Pattern to look for: [{2}]; Subject string to look in: [{3}]; Match result: [{4}]";

			string pattern = "a*;      a{1,3};       a{4};  a?;           a+;           cat*;         cat*;  aa|aaa|aaaa;  cat;   \\.(xls|csv|xlsx)$;                             (dog)*;                     \\.(xls|csv|xlsx)$;  \\.(xls|csv|xlsx)$;  \\.(xls|csv|xlsx)$";
			string[] patterns = pattern.Replace( "\t", "" ).Split( ';' );
			string subject = "zaaa;    zaaaaa;       zaaaaa;       zaaaaa;       zaaaaa;       catcatcat;    cattt; aaa;                 dogcat;       FR06-1 - COSTCO.com 2623277100.Xls;       dogcatdogcat; COMED.XLSX;                PPL_20091009.csv;    PPL_2009.csv1009.txt";
			string[] subjects = subject.Replace( "\t", "" ).Split( ';' );

			// note(s)
			// in Regex, the pattern|subject a*|zaaaaa is interpreted the following way: "does the letter z match the letter a repeated 0 times" (i.e. it only checked 'z');
			//            the answer is yes/true (also called an "empty match");
			// |   -> alternative (i.e. OR statement)
			// ()  -> group by
			// {}  -> repeated number of times (i.e. a{1,3} means search for pattern "a" repeated 1 to 3 times) -> i.e. this takes care of "empty matches" describes above..
			//            while single digit repeat x number of times (i.e. a{1} means search for pattern "a" repeated 1 time); OR max == min if max is not specified..
			// ?   -> shortcut to curly brackets "{}" (i.e. with minimum specified as 0, so could get same "empty match" results).. so "a?" says look for pattern "a" 0 to 0 times..
			// +   -> another shortcut to curly brackets "{}" (i.e. with minimum specified as 1).. so "a+" says look for pattern "a" 1 to max number of repeats..

			// moraleja: don't use kleene star "*" nor question marks "?" in Regex   ;-)

			Debug.WriteLine( "RegEx Start ****" );
			for( int i = 0; i <= subjects.GetUpperBound( 0 ); i++ )
			{
				var regEx = new Regex( patterns[i] );
				var match = regEx.Match( subjects[i] );

				if( match.Success )
				{
					Debug.WriteLine( i + " -> " + DisplaySucess, match.Index, match.Length, patterns[i], subjects[i], subjects[i].Substring( match.Index, match.Length ) );
				}
				else
				{
					Debug.WriteLine( i + " -> RegEx failure - Pattern to look for: [" + patterns[i] + "]; Subject string to look in: [" + subjects[i] + "]" );
				}
			}

			Debug.WriteLine( "RegEx End ****" );
		}

		[TestMethod()]
		public void TestRegularExpressions2()
		{
			const string DisplaySucess = "RegEx successful - Index: [{0}]; Length: [{1}]; Pattern to look for: [{2}]; Subject string to look in: [{3}]; Match result: [{4}]";

			string pattern = "\\Acat;  \\Acat;       ^cat;                (?m)^cat;            (?m)\\Acat;            [abc]; [^0-9];       \\d;   \\b";
			string[] patterns = pattern.Replace( "\t", "" ).Split( ';' );
			string subject = "catdog;  dogcat;       dog\ncat\ncat;       dog\ncat\ncat;       dog\ncat\ncat;       cambur;       cam10bur9;    cam10bur9;    con las tablas por la testa";
			string[] subjects = subject.Replace( "\t", "" ).Split( ';' );

			// note(s)
			// ?   -> more on "?".. "?" is also called an optional search (i.e. in "(dog)?|cat", dog is optional but cat is requiered). Making matters worst, no alternative that come
			//            after an optional alternative will be matched, so if "(dog)?|cat" is the pattern and "catzzzdog" is the subject then Regex will only find dog on position 6.. (:|
			// \A  -> is an Anchor-Pattern that requires the pattern that follows to be excatly at the beggining of the string (index = 0) so.. "cat" "dogcat" returns true at 
			//            index 3 but "\Acat" "dogcat" returns false since "d" <> "c"
			// ^   -> called circumflex is another Anchor-Pattern which acts simmilar to "\A" but cheks the beginning of each line (rather than just at the begining of the string)
			// (?m)       -> is called a multiline-pattern; use it with "^" so Regex can search at the beginning of each line for the pattern
			// $   -> is another Anchor-Pattern that checks for pattern at the end of the string (i.e. no other characters may follow the match, except for a single newline); you can 
			//            also use "(?m)" to mean search end of newline instead of end of string (i.e. "(?m)cat$" finds cat in "dogcat/n/n" but "cat$" does not find cat in same subject)
			// \Z  -> same as "\A" but for end of line (at the string level)..
			// []  -> character-class is used in a pattern to match any characters contained within it (i.e. "[abc]" matches any a, b or c that appear in a subject); it assumes each 
			//            entry within it is a character (no concatanation). A dash can be included to denote range so "[a-z0-9]" denote any letter from a to z or number from 0 to 9;
			//            sometimes is easier to say what you don't want to match by adding a "^" in front of the search pattern (i.e. "[^0-9] says don't give me any numbers)
			// \d  -> matches any decimal from 0 to 9
			// \D  -> is the negation of "\d" (so any character not including decimals)
			// \s  -> matchaes any whitespace
			// \S  -> is the negation of "\s"
			// \w  -> matches any of the characters found in words (i.e. "[a-zA-Z0-9]" + the underscore character)
			// \W  -> is the negation of "\w" (i.e. "[^a-zA-Z0-9_]")
			// \b  -> gives you the boudaries within words (i.e. any non word like a whitespace, end of line, etc.)
			// .   -> wild-character, it will match any character except newline (even spaces); concatenate in order to find sequences (i.e. "..." finds "abc" and "123" in 
			//            "abc123"; ditto for .{3})

			// moraleja: don't use "\A" when searching (unless you really want to search the 1st character) in Regex   ;-)

			Debug.WriteLine( "RegEx Start ****" );
			for( int i = 0; i <= subjects.GetUpperBound( 0 ); i++ )
			{
				var regEx = new Regex( patterns[i] );
				var match = regEx.Match( subjects[i] );

				while( match.Success )
				{
					Debug.WriteLine( i + " -> " + DisplaySucess, match.Index, match.Length, patterns[i], subjects[i], subjects[i].Substring( match.Index, match.Length ) );
					match = match.NextMatch();
				}
			}

			Debug.WriteLine( "RegEx End ****" );
		}

		[TestMethod()]
		public void TestUsageCalendarization2()
		{
			var start = new DateTime( 2010, 1, 1 );
			var end = new DateTime( 2011, 7, 15 );

			string[] amerenAccounts = new string[] { "5181831008" };

			foreach( string accountNumber in amerenAccounts )
			{
				var histList = UsageFactory.GetRawUsage( accountNumber, "AMEREN", start, end, "TestCase" );
				bool hasMultipleMeters = UsageFactory.HasMultipleMeters( histList );

				if( hasMultipleMeters )
				{
					UsageFiller.removeLingeringInactive( histList );
					var calendarizedUsage = UsageFactory.CalendarizeUsage( histList );
					Assert.IsTrue( calendarizedUsage != null && calendarizedUsage.Count > 0 );
				}
			}

		}

		[TestMethod()]
		public void Test8760FileUpload()
		{
			string userName = System.Security.Principal.WindowsIdentity.GetCurrent().Name;
			userName = (string) userName.Split( '\\' ).GetValue( 1 );

			FileReader.Process8760Files( "D:\\Temp\\TestFiles\\ManagedFiles", userName );
		}

		#endregion
	}
}
