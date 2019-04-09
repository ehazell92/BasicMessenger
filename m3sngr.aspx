<%@ Page Language="VB" Debug="true" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Diagnostics.Process" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.net" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Web.Mail" %>
<%@ Import Namespace="MySql.Data.MySqlClient" %>
<%@ Import Namespace="System.Data.Sql" %>



<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />

    <link rel="Shortcut Icon" type="image/x-icon" href="favicon.ico" />

    <script runat="server">        

        Dim usr As String
		Dim Nusr As String
        Dim errs As String
		Dim lastVisit as String
        Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
			lastVisit = DateTime.Now.ToString("hh:mm:ss tt")
            usr = Request.QueryString("uid")
            If (usr = "s" Or usr = "S") Then
                usr = "user1"
				Nusr = "user2"
            Else
                usr = "user2"
				Nusr ="user1"
            End If			
			
            If Not IsPostBack Then
            End If
            convoBuild()
			lastSeen()
        End Sub
		Sub lastSeen()			
			Dim updte As String = ""
			Dim readText As String = File.ReadAllText(Server.MapPath("~/admin/files/exampleFileLastRead.txt"))
        	Dim tymeLog() As String = readText.Split("!")						
			
			For Each s As String In tymeLog
				If (s.Split("¿")(0).ToString = Nusr) Then
					updte = s.Split("¿")(1).ToString
				End If
			Next
		
			theUser.InnerHtml = " Hey " & usr & " what's up? " & "<br/>" & Nusr & " last visited the page at " & updte
			Dim appendText As String = "!" & usr & "¿" & lastVisit
        	File.AppendAllText(Server.MapPath("~/admin/files/exampleFileLastRead.txt"), appendText)
		End Sub
        Sub convoAdd(sender As Object, ea As EventArgs)
            Try
                Dim sendTo As String = ""
                Dim convConn As New SqlConnection("exampleConnectionStringHere")
                Dim convCom As New SqlCommand With {.Connection = convConn}

                convConn.Open()
                convCom.CommandText = "INSERT INTO messages (messFour, messSent, mess) VALUES (@sendTo, @dateSent, @message)"
                If (usr = "user1") Then
                    sendTo = "user2"
                Else
                    sendTo = "user1"
                End If
                convCom.Parameters.AddWithValue("@sendTo", sendTo)
                convCom.Parameters.AddWithValue("@dateSent", DateTime.Now())
                convCom.Parameters.AddWithValue("@message", responseTB.Text.ToString)
                convCom.ExecuteNonQuery()

                convConn.Close()
            Catch ex As Exception
                responseTB.Text = ex.ToString
            End Try
            responseTB.Text = ""
            convoBuild()
        End Sub
        Sub convoBuild()
            convoHolder.InnerHtml = ""
            'sender.InnerHtml = ""
            Dim convConn As New SqlConnection("exampleConnectionStringHere")
            Dim convCmd As New SqlCommand With {.Connection = convConn}
            convConn.Open()
            convCmd.CommandText = "SELECT * FROM messages ORDER BY ID ASC"

            Dim convRdr As SqlDataReader = convCmd.ExecuteReader

            If convRdr.HasRows Then
                While convRdr.Read
                    If convRdr.Item("messFour") = usr Then
                        convoHolder.InnerHtml += "<div class='receiver'><div><span>" & convRdr.Item("mess").ToString & "</span></div></div>"
                    Else
                        convoHolder.InnerHtml += "<div class='sender'><div><span>" & convRdr.Item("mess").ToString & "</span></div></div>"
                    End If
                End While
            Else
                convoHolder.InnerHtml = "<span style='color: red; font-size: 30px;'>Error Locating Conversation!</span>"
            End If


            convConn.Close()
        End Sub

    </script>


    <script src="../scripts/jquery-1.12.4.js" type="text/javascript"></script>
    <script src="../scripts/jquery-ui.js" type="text/javascript"></script>
    <script src="../scripts/jquery-ui.css" type="text/javascript"></script>
    <script src="../scripts/jquery.min.js" type="text/javascript"></script>
    <link href="../scripts/bootstrap.min.css" rel="Stylesheet" type="text/css" />
    <script src="../scripts/bootstrap.min.js" type="text/javascript"></script>

    <script type="text/javascript">
        var logInput = {};
        var logObj = {};
        $(document).ready(function () {
			var objDiv = document.getElementById("convoHolder");
			objDiv.scrollTop = objDiv.scrollHeight;
        })

        function subitAct() {

        }

    </script>


    <style type="text/css">
        * {
            margin: 0;
            padding: 0;
        }

        html {
            height: 100%;
        }

        body {
            background-position: top;
            background-position: bottom;
            height: 100%;
            min-height: 100%;
            min-width: 100%;
            padding: 0 0 0 0;
            margin: 0 0 0 0;
            background-color: #262626;
            background-image: url('images/city.jpg');
            background-repeat: no-repeat;
            background-size: cover;
        }

        @font-face {
            font-family: stenzy;
            font-weight: bold;
            src: url('fonts/A_Font_with_Serifs.ttf')
        }

        #dimJuan {
            background: black;
            opacity: 0.57;
            width: 100%;
            height: 100%;
            position: absolute;
        }

        #formJuan {
            height: 100%;
            width: 100%;
        }

        #divMF {
            position: fixed;
            margin-left: auto;
            margin-right: auto;
            background-color: rgba(255,255,255, .85);
            border-radius: 10px;
            box-shadow: 1px 1px 1px 1px silver;
            width: 55%;
            margin-top: 5%;
            height: 90%;
            left: 22.5%;
        }

        #convoHolder {
            position: relative;
            width: 75%;
            margin-left: auto;
            margin-right: auto;
            height: 80%;
            margin-top: 10%;
            border-radius: 5px;
            overflow-y: auto;
        }

        .receiver {
            position: relative;
            width: 50%;
        }

            .receiver div {
                background-color: cornflowerblue;
                border-radius: 15px;
                padding-left: 2%;
                padding-right: 2%;
                width: fit-content;
                height: fit-content;
                float: right;
                margin-bottom: 2%;
                font-weight: bold;
            }

        .sender {
            position: relative;
            width: 50%;
        }

            .sender div {
                background-color: indianred;
                border-radius: 15px;
                padding-left: 2%;
                padding-right: 2%;
                width: fit-content;
                height: fit-content;
                float: right;
                margin-bottom: 2%;
                font-weight: bold;
            }

        #responseTB {
            position: relative;
            margin-left: 12.5%;
            width: 75%;
            height: 8%;
            margin-top: 1%;
            background-color: rgba(102, 153, 153, .9);
            border: 0;
            border-radius: 5px;
            word-wrap: break-word;
            word-break: break-all;
        }

        #subit {
            margin-left: 1%;
            width: 10%;
            height: 5%;
            margin-top: 2.5%;
            position: absolute;
            background-color: indianred;
            border: 1px outset cyan;
        }
    </style>

    <title>Messenger</title>
</head>
<body>
    <form id="formJuan" runat="server">
        <div id="dimJuan" runat="server"></div>
        <div id="divMF" runat="server">
            <span id="theUser" runat="server" style="position: fixed; margin-left: 6.5%; color: black; text-shadow: 0.5px 0.5px 0.5px red; font-size: 24px;"></span>
            <div id="convoHolder" runat="server">
                <%--<div id="receiver" runat="server">
                </div>
                <div id="sender" runat="server">
                </div>--%>
            </div>
            <asp:TextBox runat="server" ID="responseTB" Placeholder="Enter response here" /><asp:Button ID="subit" runat="server" OnClick="convoAdd" Text="Click Me!" />
            <%--<input type="text" runat="server" id="Text1" placeholder="Enter response here" />--%><%--<input type="button" id="sasubit" runat="server" onclick="subitAct();" value="Click Me!" />--%>
        </div>
    </form>
</body>
</html>
