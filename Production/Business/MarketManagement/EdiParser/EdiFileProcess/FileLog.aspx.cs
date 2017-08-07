using System;
using System.Configuration;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using LibertyPower.Business.CommonBusiness.CommonHelper;
using LibertyPower.Business.MarketManagement.EdiParser.FileParser;

namespace EdiFileProcess
{
	public partial class FileLog : System.Web.UI.Page
	{
		public int rowIndex = 1;
		private DateTime date;
		private string severity;
		private string fileType;
		private EdiFileLogList sortedList;
		private string sortExpression;

		protected void Page_Load( object sender, EventArgs e )
		{
			try
			{
				SetValues();
			}
			catch( Exception ex )
			{
				lblMessage.Text = ex.Message;
			}
		}

		protected void gv_RowDataBound( object sender, GridViewRowEventArgs e )
		{
			e.Row.Cells[0].Visible = false;

			if( e.Row.RowType.Equals( DataControlRowType.DataRow ) )
			{
				string id = e.Row.Cells[0].Text;
				string fileGuid = e.Row.Cells[3].Text;

				e.Row.Cells[2].Text = CreateLink( fileGuid, severity );

				e.Row.Cells[4].Text = String.Concat( "<a title='View File' href='javascript:void(0)' onclick=\"showFile('", e.Row.Cells[3].Text, "')\">", e.Row.Cells[4].Text, "</a>" );

				e.Row.Cells[9].Text = EnumHelper.GetEnumDescription( (EdiFileType) Enum.Parse( typeof( EdiFileType ), e.Row.Cells[9].Text ) );
			}
		}

		protected void btnView_OnClick( object sender, EventArgs e )
		{
			IntializeState();
			ViewState["QueryType"] = "Logs";
			txtSearch.Text = "";
			BindData();
		}

		protected void btnSearch_OnClick( object sender, EventArgs e )
		{
			IntializeState();
			ViewState["QueryType"] = "Search";
			BindData();
		}

		protected void btnProcessSelected_OnClick( object sender, EventArgs e )
		{
			string guids = "";
			foreach( GridViewRow row in gv.Rows )
			{
				if( row.Cells[1].HasControls() )
				{
					CheckBox chk = (CheckBox) (row.Cells[1].Controls[0]);
					if( chk.Checked )
					{
						guids = String.Concat( guids, row.Cells[3].Text, "," );
					}
				}
			}
			ReprocessFiles( guids );
		}

		protected void btnProcessAll_OnClick( object sender, EventArgs e )
		{
			string guids = "";
			foreach( GridViewRow row in gv.Rows )
			{
				if( row.Cells[1].HasControls() )
					guids = String.Concat( guids, row.Cells[3].Text, "," );
			}
			ReprocessFiles( guids );
		}

		private void SetValues()
		{
			date = DateTime.Today;
			string noGuid = "00000000-0000-0000-0000-000000000000";
			severity = cboLogType.SelectedValue;
			fileType = cboFileType.SelectedValue;

			if( !IsPostBack )
			{
				ViewState["QueryType"] = "Logs";

				IntializeState();

				calDate.SelectedDate = DateTime.Today;

				BindData();
			}

			// clears account log page by passing a bogus file guid
			ClientScript.RegisterStartupScript( this.GetType(), "noguid", "viewAccountLog('" + noGuid + "');", true );

			lblMessage.Text = "";
		}

		private void ReprocessFiles( string guids )
		{
			try
			{
				if( guids.Length > 0 )
				{
					guids = guids.Substring( 0, guids.Length - 1 ); // remove last comma
					string[] fileGuids = guids.Split( Convert.ToChar( "," ) );

					FileController.ProcessFiles( fileGuids );
				}
				else
				{
					lblMessage.Text = ConfigurationManager.AppSettings["NoFilesSelected"];
					;
				}

				date = Convert.ToDateTime( txtDate.Text );
				IntializeState();

				BindData();
			}
			catch( Exception ex )
			{
				lblMessage.Text = "Error: " + ex.Message;
			}
		}

		protected void calDate_OnClick( object sender, EventArgs e )
		{
			string guids = "";
			foreach( GridViewRow row in gv.Rows )
			{
				if( row.Cells[1].HasControls() )
				{
					CheckBox chk = (CheckBox) (row.Cells[1].Controls[0]);
					if( chk.Checked )
					{
						guids = String.Concat( guids, row.Cells[3].Text, "," );
					}
				}
			}
			ReprocessFiles( guids );
		}

		private void IntializeState()
		{
			sortExpression = "TimeStamp";
			ViewState["SortExpression"] = sortExpression;
			ViewState["SortDirection"] = "ASC";
		}


		private string CreateLink( string id, string severity )
		{
			return "<a href='javascript:void(0)' onclick=viewAccountLog('" + id + "','" + severity + "') class='btn'>View Account Log</a>";
		}

		protected void gv_Sorting( object sender, GridViewSortEventArgs e )
		{
			sortExpression = e.SortExpression;
			BindData();
		}

		private void BindData()
		{
			EdiFileLogList list;

			if( ViewState["QueryType"].ToString().Equals( "Search" ) )
			{
				string field = cboSearch.SelectedValue;
				string searchText = txtSearch.Text.Trim();

				list = FileFactory.SearchEdiFileLogs( field, searchText );
			}
			else
			{
				if( txtDate.Text.Length > 0 )
				{
					date = Convert.ToDateTime( txtDate.Text );
					calDate.SelectedDate = date;
				}

				list = FileFactory.GetEdiFileLogs( date, severity, fileType );
			}

			switch( sortExpression )
			{
				case "ID":
					{
						var orderedList = list.OrderBy( log => log.ID );
						sortedList = new EdiFileLogList( orderedList );
						break;
					}
				case "FileGuid":
					{
						var orderedList = list.OrderBy( log => log.FileGuid );
						sortedList = new EdiFileLogList( orderedList );
						break;
					}
				case "FileName":
					{
						var orderedList = list.OrderBy( log => log.FileName );
						sortedList = new EdiFileLogList( orderedList );
						break;
					}
				case "UtilityCode":
					{
						var orderedList = list.OrderBy( log => log.UtilityCode );
						sortedList = new EdiFileLogList( orderedList );
						break;
					}
				case "Attempts":
					{
						var orderedList = list.OrderBy( log => log.Attempts );
						sortedList = new EdiFileLogList( orderedList );
						break;
					}
				case "Information":
					{
						var orderedList = list.OrderBy( log => log.Information );
						sortedList = new EdiFileLogList( orderedList );
						break;
					}
				case "TimeStamp":
					{
						var orderedList = list.OrderBy( log => log.TimeStamp );
						sortedList = new EdiFileLogList( orderedList );
						break;
					}
				case "EdiFileType":
					{
						var orderedList = list.OrderBy( log => log.EdiFileType);
						sortedList = new EdiFileLogList( orderedList );
						break;
					}
				default:
					{
						var orderedList = list.OrderBy( log => log.ID );
						sortedList = new EdiFileLogList( orderedList );
						break;
					}
			}
			SetSortingState( sortExpression );

			lblRecords.Text = sortedList.Count.ToString();

			gv.DataSource = sortedList;
			rowIndex = 1;
			gv.DataBind();
		}

		private void SetSortingState( string sortExpression )
		{
			if( ViewState["SortExpression"] != null )
			{
				// if sorting on same item, reverse the order
				if( sortExpression.Equals( ViewState["SortExpression"].ToString() ) )
				{
					if( ViewState["SortDirection"].ToString().Equals( "ASC" ) )
					{
						ViewState["SortDirection"] = "DESC";
						sortedList.Reverse();
					}
					else
						ViewState["SortDirection"] = "ASC";

				}
				else
					ViewState["SortDirection"] = "ASC";
			}
			else
				ViewState["SortDirection"] = "ASC";

			ViewState["SortExpression"] = sortExpression;
		}

		protected void gv_RowCreated( object sender, GridViewRowEventArgs e )
		{
			if( e.Row.RowType == DataControlRowType.DataRow )
			{
				e.Row.Attributes.Add( "onclick", "onGridViewRowSelected('" + rowIndex.ToString() + "')" );

				rowIndex++;
			}
		}
	}
}
