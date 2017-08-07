using System;
using System.Configuration;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;
using LibertyPower.Business.CommonBusiness.FileManager;
using LibertyPower.Business.MarketManagement.EdiParser.FileParser;

namespace EdiFileProcess
{
	public partial class FileViewer : System.Web.UI.Page
	{
		protected void Page_Load( object sender, EventArgs e )
		{
			if( Request.QueryString["fileGuid"] != null )
			{
				try
				{
					string fileGuid = Request.QueryString["fileGuid"];
					GetFile( fileGuid );
				}
				catch( Exception ex )
				{
					Response.Write( "<br><br><center><span style=font-family:Verdana,Arial;font-size:10pt;color:#FF0000>***  File Error ***<br><br>" + ex.Message + "</span></center>" );
				}
			}
		}

		private void GetFile( string fileGuid )
		{
			string fileServerDriveLetter = ConfigurationManager.AppSettings["FileServerDriveLetter"];
			string networkFileServer = ConfigurationManager.AppSettings["NetworkFileServer"];

			FileContext context = FileFactory.GetManagedFileByFileGuid( fileGuid );
			string file = context.FullFilePath.Replace(fileServerDriveLetter, networkFileServer); // replace local drive letter with network path
			string originalFileName = context.OriginalFilename;

			Response.ContentType = "application/text/plain";
			Response.AddHeader( "content-disposition", "attachment; filename=" + originalFileName + "" );

			FileStream stream = new FileStream( file, FileMode.Open );
			long FileSize;
			FileSize = stream.Length;
			byte[] getContent = new byte[(int) FileSize];
			stream.Read( getContent, 0, (int) stream.Length );
			stream.Close();

			Response.BinaryWrite( getContent );
		}
	}
}
