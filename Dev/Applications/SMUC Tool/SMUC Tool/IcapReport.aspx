<%@ Page Title="" Language="C#" MasterPageFile="~/MdsTool.Master" AutoEventWireup="true" CodeBehind="IcapReport.aspx.cs" Inherits="SMUC_Tool.IcapReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">




    <table>
        <tr>
            <td>Iso : </td>
            <td>
                <asp:DropDownList runat="server" ID="ddlIso" OnSelectedIndexChanged="ddlIso_SelectedIndexChanged1" AutoPostBack="true" ></asp:DropDownList></td>
            <td>Utility : </td>
            <td>
                <asp:DropDownList runat="server" ID="ddlUtility"></asp:DropDownList></td>

        </tr>
        <tr>
            <td>Account Number : </td>
            <td>
                <asp:TextBox ID="txtAccountNumber" runat="server"></asp:TextBox></td>
            <td>&nbsp:
            </td>
            <td>
                <asp:Button ID="btnViewReport" runat="server" Text="View Report" OnClick="btnViewReport_Click" />
            </td>
        </tr>

    </table>
    

</asp:Content>
