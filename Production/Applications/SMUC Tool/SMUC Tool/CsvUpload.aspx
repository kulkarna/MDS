<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CsvUpload.aspx.cs" Inherits="SMUC_Tool.SMUCUpload" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Smuc Tool</title>
    <link href="Content/themes/main.css" rel="stylesheet" />

</head>
<body>
    <form id="form1" runat="server">
        <div>
            <div>
                <div class="outer">
                    <div class="Row">
                        <div class="col4">
                            <asp:FileUpload ID="csvFileUploader" runat="server" CssClass="file-upload" />
                        </div>
                    </div>
                    <div class="Row">
                        <div class="col4 text-center">
                            <asp:Button ID="btnUpload" Text="Upload" runat="server" OnClick="btnUpload_Click" CssClass="myButton" />
                            <asp:Button ID="btnDownload" runat="server" Text="Result Download" OnClick="btnDownload_Click" CssClass="myButton" Visible="false" />
                             <asp:Button ID="btnFileStatusDownload" runat="server" Text="Download File Response" OnClick="btnFileStatusDownload_Click" CssClass="myButton" Visible="false" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col4 text-center">
                            <asp:Label ID="lblMessage" runat="server" ForeColor="Red" />
                        </div>
                    </div>
                    <%--<div class="row" runat="server" visible="false" id="dvProgress">
                        <div class="col4 text-center">
                            <img src="Images/processing.gif" style="height: 100%" />
                        </div>
                    </div>--%>
                </div>
               
            </div>
        </div>
    </form>
</body>
</html>
