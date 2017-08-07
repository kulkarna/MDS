<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FileLog.aspx.cs" Inherits="EdiFileProcess.FileLog" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title> 
    <script type="text/javascript" language="javascript">
        function showFile(fileGuid) {
            window.open("FileViewer.aspx?fileGuid=" + fileGuid);
        }

        function viewAccountLog(fileGuid, severity) {
            top.frames['AccountLog'].location.href = "AccountLog.aspx?fileGuid=" + fileGuid + "&severity=" + severity;
        }    
    </script>
<script language="javascript" type="text/javascript">
    var gridViewCtlId = 'gv';
    var gridViewCtl = null;
    var curSelRow = null;
    function getGridViewControl() {
        if (null == gridViewCtl) {
            gridViewCtl = document.getElementById(gridViewCtlId);
        }
    }

    function onGridViewRowSelected(rowIdx) {
        var selRow = getSelectedRow(rowIdx);
        if (curSelRow != null) {
            curSelRow.style.backgroundColor = '#ffffff';
        }

        if (null != selRow) {
            curSelRow = selRow;
            curSelRow.style.backgroundColor = '#b3ff9c';
        }
    }

    function getSelectedRow(rowIdx) {
        getGridViewControl();
        if (null != gridViewCtl) {
            return gridViewCtl.rows[rowIdx];
        }
        return null;
    }
</script>        
<style type="text/css">
.btn {font-family:Verdana,Arial;font-size:8pt;width:180px}
.rad {font-family:Verdana,Arial;font-size:9pt;font-weight:normal;}
.cbo {font-family:Verdana,Arial;font-size:8pt;width:100px}
</style>
</head>
<body style="margin: 0px 0px 0px 0px">
    <form id="form1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>
    <div>
        <asp:Table ID="tblHeader" runat="server" Width="100%" BackColor="#006699" CellSpacing="0" CellPadding="0">
            <asp:TableRow runat="server">
                <asp:TableCell runat="server" Width="70%" Height="30px" HorizontalAlign="Left" VerticalAlign="Middle"
                    ForeColor="White" Font-Names="Verdana,Arial" Font-Size="9pt" Font-Bold="true" style="padding-left:10px">EDI Files
                    &nbsp;&nbsp;<span style="color:#FFFFFF;font-size:10pt;font-weight:normal;">View&nbsp;
                    <asp:DropDownList ID="cboLogType" runat="server" AutoPostBack="false" CssClass="cbo" Width="88px">
                    <asp:ListItem Text="Errors" Value="0"></asp:ListItem>
                    <asp:ListItem Text="Warnings" Value="1"></asp:ListItem>
                    <asp:ListItem Text="All" Value="0,1"></asp:ListItem>
                    </asp:DropDownList>&nbsp;for&nbsp;
                    <asp:DropDownList ID="cboFileType" runat="server" AutoPostBack="false" CssClass="cbo" Width="134px">
                    <asp:ListItem Text="867 Files" Value="1"></asp:ListItem>
                    <asp:ListItem Text="814 Files" Value="0"></asp:ListItem>
                    <asp:ListItem Text="814 & 867 Files" Value="0,1"></asp:ListItem>
                    <asp:ListItem Text="Status Update Files" Value="2"></asp:ListItem>
                    <asp:ListItem Text="All Files" Value="0,1,2"></asp:ListItem>
                    </asp:DropDownList>                                      
                    &nbsp;
                    From:&nbsp;<asp:TextBox ID="txtDate" runat="server" CssClass="btn" Width="80px">
                    </asp:TextBox><asp:Button ID="btnView" runat="server" Text="GO" Font-Names="Verdana,Arial" Font-Size="8pt" OnClick="btnView_OnClick" />
                    </span></asp:TableCell>
                <asp:TableCell ID="TableCell2" runat="server" Width="30%" Height="30px" HorizontalAlign="Right"
                    VerticalAlign="Middle" ForeColor="White" Font-Names="Verdana,Arial" Font-Size="9pt"
                    Font-Bold="true">
                    <asp:Button ID="btnProcessSelected" runat="server" Font-Names="Verdana,Arial" Font-Size="9pt"
                        Text="Re-process Selected Files" OnClick="btnProcessSelected_OnClick" CssClass="btn" /><br /><asp:Button
                            ID="btnProcessAll" runat="server" Font-Names="Verdana,Arial" Font-Size="9pt"
                            Text="Re-process All Files" OnClick="btnProcessAll_OnClick" CssClass="btn" /></asp:TableCell>
            </asp:TableRow>
            <asp:TableRow ID="TableRow1" runat="server">
                <asp:TableCell ID="TableCell3" runat="server" ColumnSpan="2" Width="100%" HorizontalAlign="Left" VerticalAlign="Middle"
                    ForeColor="White" Font-Names="Verdana,Arial" Font-Size="9pt" Font-Bold="true" style="padding-left:10px">
                    Find&nbsp;<asp:DropDownList ID="cboSearch" runat="server" AutoPostBack="false" CssClass="cbo">
                    <asp:ListItem Text="File Guid" Value="FileGuid"></asp:ListItem>
                    <asp:ListItem Text="File Name" Value="FileName"></asp:ListItem>
                    <asp:ListItem Text="File Log ID" Value="ID"></asp:ListItem>
                    </asp:DropDownList>&nbsp;<asp:TextBox ID="txtSearch" runat="server" CssClass="btn" Width="338px"></asp:TextBox>
                    <asp:Button ID="btnSearch" runat="server" Text="SEARCH" Font-Names="Verdana,Arial" Font-Size="8pt" OnClick="btnSearch_OnClick" /></asp:TableCell>
            </asp:TableRow>             
            <asp:TableRow ID="TableRow2" runat="server">
                <asp:TableCell ID="TableCell1" runat="server" Width="70%" HorizontalAlign="Left" VerticalAlign="Middle"
                    ForeColor="White" Font-Names="Verdana,Arial" Font-Size="9pt" Font-Bold="true">
                    <asp:Label ID="lblMessage" runat="server" Text="" Visible="true" Font-Names="Verdana,Arial"
            Font-Size="8pt" ForeColor="#F8FF85"></asp:Label></asp:TableCell>
                <asp:TableCell ID="TableCell4" runat="server" Width="30%" HorizontalAlign="Right" VerticalAlign="Middle"
                    ForeColor="White" Font-Names="Verdana,Arial" Font-Size="9pt" Font-Bold="true" style="padding-right:10px;padding-bottom:4px">
                    (<asp:Label ID="lblRecords" runat="server" Text="0"></asp:Label>) records</asp:TableCell>            
            </asp:TableRow>          
        </asp:Table>
        <asp:GridView ID="gv" runat="server" AllowPaging="False" AllowSorting="True" 
            BackColor="White" AutoGenerateColumns="false"
            BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px" CellPadding="3" Font-Names="Verdana,Arial"
            Font-Size="8pt" OnRowDataBound="gv_RowDataBound" PageSize="1000" 
            Width="100%" onsorting="gv_Sorting" onrowcreated="gv_RowCreated">
            <RowStyle ForeColor="#000066" />
            <FooterStyle BackColor="White" ForeColor="#000066" />
            <PagerStyle BackColor="White" ForeColor="#000066" HorizontalAlign="Left" />
            <SelectedRowStyle BackColor="#669999" Font-Bold="True" ForeColor="White" />
            <HeaderStyle BackColor="#006699" Font-Bold="True" ForeColor="White" />            
            <Columns>
                <asp:BoundField DataField="ID" HeaderText="Log ID" 
                    ItemStyle-HorizontalAlign="Right" SortExpression="ID" >
<ItemStyle HorizontalAlign="Right"></ItemStyle>
                </asp:BoundField>
                <asp:TemplateField HeaderText="Select" SortExpression="ID" ItemStyle-HorizontalAlign="Left"><ItemTemplate><asp:CheckBox ID="chkBox" Text='<%# Bind("ID") %>'  runat="server" /></ItemTemplate>

<ItemStyle HorizontalAlign="Center"></ItemStyle>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="View Log" ItemStyle-HorizontalAlign="Center"><ItemTemplate></ItemTemplate>

<ItemStyle HorizontalAlign="Center"></ItemStyle>
                </asp:TemplateField>
                <asp:BoundField DataField="FileGuid" HeaderText="File Guid" SortExpression="FileGuid" />
                <asp:BoundField DataField="FileName" HeaderText="File Name" SortExpression="FileName" />
                <asp:BoundField DataField="UtilityCode" HeaderText="Utility" SortExpression="UtilityCode" />
                <asp:BoundField DataField="Attempts" HeaderText="Attempts" SortExpression="Attempts" 
                    ItemStyle-HorizontalAlign="Center" >
<ItemStyle HorizontalAlign="Center"></ItemStyle>
                </asp:BoundField>
                <asp:BoundField DataField="Information" HeaderText="Information" SortExpression="Information" />
                <asp:BoundField DataField="TimeStamp" HeaderText="Time Stamp" SortExpression="TimeStamp" />
                <asp:BoundField DataField="EdiFileType" HeaderText="File Type" SortExpression="EdiFileType" />
            </Columns>
        </asp:GridView>
    </div>   
        <cc1:CalendarExtender ID="calDate" runat="server" TargetControlID="txtDate" ></cc1:CalendarExtender>
    </form>
    </body>
</html>
