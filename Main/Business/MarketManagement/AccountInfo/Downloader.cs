using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.IO;
using System.Net;
using System.Text;
using System.Xml;
using System.Xml.Linq;
//using Ionic.Zip;
using ICSharpCode.SharpZipLib.Zip;

using LibertyPower.Business.CommonBusiness.FileManager;

namespace LibertyPower.Business.MarketManagement.AccountInfo
{
	public class Downloader
	{
		/// <summary>
		/// a list that will hold the report names and their urls
		/// </summary>

		List<FileProperties> listOfFiles = new List<FileProperties>();

		/// <summary>
		/// a list of the files to parse
		/// </summary>
		public List<FileLog> FileLogs;

		/// <summary>
		/// path to copy the files to
		/// </summary>
		public string ToPath;

		/// <summary>
		/// path where to keep the unzipped files
		/// </summary>
		public string UnzipPath;

		private FileManager fileManager;

		/// <summary>
		/// Create a new instance of the downloader class for each list of repots
		/// </summary>
		/// <param name="dataFile">PAth of the XML file that contains the list of the reports and their URLs</param>
		public Downloader( string dataFile )
		{
			FileLogs = new List<FileLog>();

			string content = "";

			//temp solution: the original file has the namespace with the element name: couldn't read the file white this was embedded.
			//the solution for now is to strip the namespace from the element names
			using( StreamReader s = new StreamReader( dataFile ) )
			{
				content = s.ReadToEnd().Replace( "ns1:", "" );
			}

			using( StreamWriter sw = new StreamWriter( dataFile ) )
			{
				sw.Write( content );
			}

			XNamespace xname = "http://www.ercot.com/schema/2007-06/nodal/ews";
			var reports = from r in XElement.Load( dataFile ).Elements( "Report" )
						  select new
						  {
							  url = r.Element( "URL" ).Value,
							  name = r.Element( "fileName" ).Value,
							  format = r.Element( "format" ).Value,
							  size = r.Element( "size" ).Value
						  };

			foreach( var report in reports )
			{
				if( report.format.ToLower() != "zip" )
					continue;
				listOfFiles.Add( new FileProperties { URL = report.url, Format = report.format, Name = report.name, Size = report.size } );
			}

			// create managed file
			fileManager = FileManagerFactory.GetFileManager(
				ConfigurationManager.AppSettings["FileManagerContextKey"].ToString(),
				ConfigurationManager.AppSettings["FileManagerBusinessPurpose"].ToString(),
				ConfigurationManager.AppSettings["FileManagerRoot"].ToString(),
				0 );
		}

		/// <summary>
		/// download all the files present in the working folder
		/// </summary>
		/// <param name="message">error message</param>
		/// <returns>false if not successful</returns>
		public bool DownloadFiles( string certCommonName, out string Message )
		{
			Message = string.Empty;
			try
			{
				// to ignore cert errors
				ServicePointManager.ServerCertificateValidationCallback += new System.Net.Security.RemoteCertificateValidationCallback( delegate { return true; } );
				//ServicePointManager.CertificatePolicy = new AcceptAllCertificatePolicy();
				//bool atLeastOneFileFound = false;
				FileHelper.DirectotyCreate( ToPath );

				//first loop through each file and download the files we need
				//foreach( KeyValuePair<string, string> item in dcListOfURL )
				foreach( FileProperties fp in listOfFiles )
				{
					//first check if the file has been downloaded and processed already
					if( !AccountInfoFactory.IsDownloadedAndProcessed( fp.Name ) )
					{
						if( FileHelper.FileExists( ToPath + fp.Name ) )
							continue;

						HttpWebRequest request = (HttpWebRequest) WebRequest.Create( fp.URL );
						request.Method = "GET";
						request.ClientCertificates.Add( SecurityHelper.GetCert( certCommonName ) ); //add cert 
						using( Stream str = request.GetResponse().GetResponseStream() )
						{
							//copy the stream to local disk
							byte[] inBuf = new byte[int.Parse( fp.Size )];
							int bytesToRead = (int) inBuf.Length;
							int bytesRead = 0;

							while( bytesToRead > 0 )
							{
								int n = str.Read( inBuf, bytesRead, bytesToRead );
								if( n == 0 )
									break;
								bytesRead += n;
								bytesToRead -= n;
							}
							using( FileStream fstr = new FileStream( ToPath + fp.Name, FileMode.OpenOrCreate,
							FileAccess.Write ) )
							{
								fstr.Write( inBuf, 0, bytesRead );
							}
						}

						/*
						using( WebClient Client = new WebClient() )
						{
							if( !FileHelper.FileExists( ToPath + item.Value ) )
							{
								Client.DownloadFile(item.Key, ToPath + item.Value );
								//atLeastOneFileFound = true;
							}
						}*/
					}
				}

				return true;
			}
			catch( Exception ex )
			{
				Message = ex.Message;
				AccountInfoFactory.Errors.Add( "Unable to download files: " + ex.Message );
				return false;
			}
		}

		/// <summary>
		/// unzip the files present in the working folder
		/// </summary>
		/// <param name="unZipExt">extension of the zipped files</param>
		public void UnzipFiles( string unZipExt )
		{
			// get the extension of the files to be downloaded
			string zipEXT = unZipExt;

			//create the UnzipPath in case it doesn't exist
			FileHelper.DirectotyCreate( UnzipPath );

			//get all the files in the ToPath directory that matches the extension and unzip each one of them
			DirectoryInfo d = new DirectoryInfo( ToPath );
			FileInfo[] fi = d.GetFiles( zipEXT );
			foreach( FileInfo f in fi )
				UnzipFile( f.FullName );

			FileHelper.DeleteFilesFromDir( ToPath, zipEXT );
		}

		/// <summary>
		/// unzips a file and add its properties to the FileLogs list
		/// </summary>
		/// <param name="filePath">full file path to unzip</param>
		/// <returns>true if successful</returns>
		private bool UnzipFile( string filePath )
		{
			string fileGuid = string.Empty;
			DateTime dtLoadDate = DateTime.MinValue;
			string unzipFile = string.Empty;

			FileInfo fZip = new FileInfo( filePath );
			if( !fZip.Exists )
				return false;

			try
			{
				/*
				using( ZipFile zip1 = ZipFile.Read( filePath ) )
				{
					//Full file extract code
					foreach (ZipEntry e1 in zip1)
					{
						e1.Extract( UnzipPath, ExtractExistingFileAction.OverwriteSilently );
					}
				}
				*/
				
				using( ZipInputStream ZipStream = new ZipInputStream( File.OpenRead( filePath ) ) )
				{
					ZipEntry theEntry;
					while( (theEntry = ZipStream.GetNextEntry()) != null )
					{
						if( theEntry.IsFile )
						{
							unzipFile = theEntry.Name.Substring( theEntry.Name.LastIndexOf( '/' ) + 1 );
							if( unzipFile != "" )
							{
								string strNewFile = @"" + UnzipPath + @"\" + unzipFile;

								//adds the file to managed storage, returns a file context object
								FileContext fContext = fileManager.AddFile( fZip.FullName,
									bool.Parse( ConfigurationManager.AppSettings["DELETE_ORIGINAL"].ToString() ),
									0 );

								// file identifier in managed storage
								fileGuid = fContext.FileGuid.ToString();

								dtLoadDate = GetLoadDate( unzipFile );
								int idFileLog = AccountInfoFactory.LogFileStatus( fileGuid, fZip.Name, unzipFile,
									"Unzipping", 2, DateTime.Now );

								FileLogs.Add( new FileLog
								{
									ID = idFileLog,
									FGUID = fileGuid,
									ZipFileName = fZip.Name,
									FileName = unzipFile,
									LoadDate = dtLoadDate
								} );

								if( FileHelper.FileExists( strNewFile ) )
								{
									AccountInfoFactory.LogFileStatus( idFileLog, "File already unzipped", 2 );
									continue;
								}

								using( FileStream streamWriter = File.Create( strNewFile ) )
								{
									int size = 2048;
									byte[] data = new byte[2048];
									while( true )
									{
										size = ZipStream.Read( data, 0, data.Length );
										if( size > 0 )
											streamWriter.Write( data, 0, size );
										else
											break;
									}
									streamWriter.Close();
								}
								AccountInfoFactory.LogFileStatus( idFileLog, "Unzipped successfully", 2 );
							}
						}
					}
					ZipStream.Close();
				}
			}

			catch( Exception ex )
			{
				AccountInfoFactory.LogFileStatus( fileGuid, fZip.Name, unzipFile,
									"Unzipping failed: " + ex.Message, 0, DateTime.Now );
				AccountInfoFactory.Errors.Add( "File " + fZip.Name + " failed to unzip: " + ex.Message );

				//delete file
				FileHelper.DeleteFile( @"" + UnzipPath + @"\" + unzipFile );
				return false;
			}

			return true;
		}

		/// <summary>
		/// get the load date of the file
		/// </summary>
		/// <param name="fileName">file name which contains the load date: SHARYLAND____NEW-REPORTS-21-MAR-11</param>
		/// <returns>datetime value of the upload date</returns>
		private DateTime GetLoadDate( string fileName )
		{
			try
			{
				//get the uploadDate of the file
				string[] nameSections = fileName.Split( '.' )[0].Split( '-' );
				if( nameSections.Length != 5 )
					return DateTime.MinValue;

				DateTime dtLoad;
				DateTime.TryParse( string.Join( "-", nameSections, 2, 3 ), out dtLoad );

				return dtLoad;
			}
			catch
			{
				return DateTime.MinValue;
			}
		}
	}

	/* internal class AcceptAllCertificatePolicy : ICertificatePolicy    
	 {        
		 public AcceptAllCertificatePolicy()
		 {        
		 }


		 public bool CheckValidationResult( ServicePoint srvPoint, X509Certificate certificate, WebRequest request, int certificateProblem )
		 {            // *** Always accept           
			 return true;       
		 }   
	 }*/

}
