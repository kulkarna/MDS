<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AccountLog.aspx.cs" Inherits="EdiFileProcess.AccountLog" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title></title>
<style type="text/css">
.msg {font-family:Verdana,Arial;font-size:10pt;color:#006699;padding-left:10px;}
</style>    
</head>
<body style="margin: 0px 0px 0px 0px">
    <form id="form1" runat="server">
    <div>
    <asp:Table ID="tblHeader" runat="server" Width="100%" BackColor="#006699">
        <asp:TableRow ID="TableRow1" runat="server">
            <asp:TableCell ID="TableCell1" runat="server" Width="100%" Height="30px" HorizontalAlign="Left" VerticalAlign="Middle" ForeColor="White" Font-Names="Verdana,Arial" Font-Size="9pt" Font-Bold="true" >EDI Account Log
            &nbsp;&nbsp;<asp:Label ID="lblLogId" runat="server" Visible="false" Text=""></asp:Label></asp:TableCell>
        </asp:TableRow>     
    </asp:Table>
        <asp:GridView ID="gv" runat="server" AllowPaging="False" AllowSorting="False" AutoGenerateColumns="false" 
            BackColor="White" BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px" 
            CellPadding="3" Font-Names="Verdana,Arial" Font-Size="8pt" 
            onrowdatabound="gv_RowDataBound" PageSize="1000" 
            Width="100%">
            <RowStyle ForeColor="#000066" />
            <FooterStyle BackColor="White" ForeColor="#000066" />
            <PagerStyle BackColor="White" ForeColor="#000066" HorizontalAlign="Left" />
            <SelectedRowStyle BackColor="#669999" Font-Bold="True" ForeColor="White" />
            <HeaderStyle BackColor="#006699" Font-Bold="True" ForeColor="White" />
            <Columns>
                <asp:BoundField DataField="AccountNumber" HeaderText="Account Number" />
                <asp:BoundField DataField="UtilityCode" HeaderText="Utility" />
                <asp:BoundField DataField="Information" HeaderText="Information" />
            </Columns>            
        </asp:GridView>  
        <br /> 
        <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="msg" Text="No account log data for selected file."></asp:Label> 
    </div>
    </form>
</body>
</html>
