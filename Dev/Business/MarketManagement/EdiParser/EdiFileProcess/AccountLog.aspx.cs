using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using LibertyPower.Business.MarketManagement.EdiParser.FileParser;

namespace EdiFileProcess
{
	public partial class AccountLog : System.Web.UI.Page
	{
		protected void Page_Load( object sender, EventArgs e )
		{
			if( Request.QueryString["fileGuid"] != null && Request.QueryString["severity"] != null )
			{
				string fileGuid = Request.QueryString["fileGuid"];
				string severity = Request.QueryString["severity"];
				BindData( fileGuid, severity );
			}
		}

		private void BindData( string fileGuid, string severity )
		{
			EdiAccountLogList list = FileFactory.GetEdiAccountLogs( fileGuid, severity );
			if( list.Count.Equals( 0 ) && !fileGuid.Equals("00000000-0000-0000-0000-000000000000") ) // guid used to clear results
			{
				lblMessage.Visible = true;
			}
			else
			{
				gv.DataSource = list;
				gv.DataBind();

				if( !fileGuid.Equals( "00000000-0000-0000-0000-000000000000" ) )
				{
					lblLogId.Text = "File Log ID " + list[0].EdiFileLogID.ToString();
					lblLogId.Visible = true;
				}
			}
		}

		protected void gv_RowDataBound( object sender, GridViewRowEventArgs e )
		{

		}
	}
}
