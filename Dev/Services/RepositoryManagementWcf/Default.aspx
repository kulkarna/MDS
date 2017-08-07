<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="LibertyPower.RepositoryManagement.Web.Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:HyperLink ID="hlAccounts" runat="server" NavigateUrl="Accounts/v1">Accounts Service</asp:HyperLink>
        <br />
        Build:<asp:Label ID="lblBuild" runat="server" Text=""></asp:Label>
        <br/>
    </div>
    </form>
</body>
</html>
