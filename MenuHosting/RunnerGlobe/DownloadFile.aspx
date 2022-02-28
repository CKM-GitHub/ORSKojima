<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DownloadFile.aspx.cs" Inherits="MenuHosting.RunnerGlobe.DownloadFile" EnableEventValidation="false"  %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1"   %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">

    <title>Download!</title>
      <style>
           /*[@id="ctl01"]/div[3]/table/thead/tr*/
          .table-striped > tbody > tr:nth-child(odd) > td,
          .table-striped > tbody > tr:nth-child(odd) > th {
                 background-color:  white;/* Choose your own color here */
          }

           .table-striped > tbody > tr:nth-child(even) > td,
           .table-striped > thead > tr,
          .table-striped > tbody > tr:nth-child(even) > th {
                 background-color: lavender;/* Choose your own color here */
          }
          .cursorblock {
              cursor: not-allowed;
          }
          .cursorallow {
              cursor: pointer;
              color: blue;
              text-decoration:underline !important;
          }
              .cursorallow:hover {
                  color: green;
              }

      </style>
  </head>
  <body align="center" onload="loadImage()">
      <input type="hidden" value="0" runat="server" id="hdn_colm" />
      <form runat="server">
      <div   class="">
             <%--<a  class="btn btn-primary" href="" runat="server" onserverclick="Trigger" > Yes</a>--%>
           <h1 style="margin-left: 10%;">ダウンロード</h1>
          <p style="margin-left: 10%;"> 以下のリンクから最新バージョンをダウンロードしてください。</p>
        
          
<table class="table table-striped" style="width: 80%; margin-left: 10%;">
  <thead>
    <tr>
      <th scope="col">#</th>
      <th class="hideCln" scope="col">MainMenu</th>
      <th class="hideCln" scope="col">変更・修正内容</th> 
      <th class="hideCln" scope="col">Capital Sports</th>
      <th class="hideCln" scope="col">変更・修正内容</th> 
      <th class="hideCln" scope="col">Haspo</th>
      <th class="hideCln" scope="col">変更・修正内容</th> 
      <th class="hideCln" scope="col">Tennic</th>
      <th class="hideCln" scope="col">変更・修正内容</th> 
      <th class="hideCln" scope="col">Shinyoh</th>
      <th class="hideCln" scope="col">変更・修正内容</th> 
    </tr>
  </thead>
  <tbody>
   <%-- <tr>
      <th scope="row">1</th>  
        <td class="hideCln" > <a runat="server"  class="cursorblock"  style="color:blue;"> 1_0_0_0 </a> </td>
        <td class="hideCln" >   </td>
      <td class="hideCln" >   <a runat="server"  class="cursorblock"  style="color:blue;"> 1_0_0_0 </a> </td>
        <td class="hideCln" >   </td>
       <td class="hideCln" >  <a runat="server"  class="cursorblock"  style="color:blue;"> 1_0_0_0 </a> </td>
         <td class="hideCln" >  </td>
     
    </tr>--%>
    <tr>
      <th scope="row">1</th>
   <td class="hideCln" > <a runat="server"   id="mainmenu" onclick="hdnClick('mainmenu')"  data-toggle="modal" data-target="#exampleModal1" class="cursorallow"  style="color:blue;"> mainmenu </a></td>
         <td class="hideCln" > ログイン時のユーザー情報更新プロセスを追加しました  </td>
      <td class="hideCln" >  <a runat="server"   id="lastcapital" onclick="hdnClick('capital')" data-toggle="modal" data-target="#exampleModal2" class="cursorallow"  style="color:blue;" > capital </a> </td>
         <td class="hideCln" > ログイン時のユーザー情報更新プロセスを追加しました </td>
      <td class="hideCln" > <a runat="server"  id="lasthaspo" onclick="hdnClick('haspo')" data-toggle="modal" data-target="#exampleModal3" class="cursorallow" style="color:blue;"  > haspo </a></td>
         <td class="hideCln" > ログイン時のユーザー情報更新プロセスを追加しました </td>
      <td class="hideCln" > <a runat="server"   id="lasttennic" onclick="hdnClick('tennic')"  data-toggle="modal" data-target="#exampleModal4" class="cursorallow"  style="color:blue;"> tennic </a></td>
         <td class="hideCln" > ログイン時のユーザー情報更新プロセスを追加しました  </td>
      <td class="hideCln" > <a runat="server"   id="shinyoh" onclick="hdnClick('shinyoh')"  data-toggle="modal" data-target="#exampleModal5" class="cursorallow"  style="color:blue;"> shinyoh </a></td>
         <td class="hideCln" > ログイン時のユーザー情報更新プロセスを追加しました  </td>
    </tr>
 <%--   <tr>
      <th scope="row">3</th>
      <td>Larry</td>
      <td>the Bird</td>
      <td>@twitter</td>
    </tr>--%>
  </tbody>
</table>      <div class="modal fade" id="myModal" role="dialog">
    <div class="modal-dialog">
    
      <!-- Modal content-->
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal">&times;</button>
          <h4 class="modal-title">Modal Options</h4>
        </div>
        <div class="modal-body">
          <p>Modal content..</p>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        </div>
      </div>
      
    </div>
  </div>
               <div class="modal fade" id="exampleModal1" tabindex="-1" aria-labelledby="exampleModalLabel1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
        
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel1">確認！</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <span class="active"> MainMenu用のプログラムをダウンロードしますか？</span>      
          <input type="hidden" id="hdn_val1" runat="server" value="0"/>
      </div>
      <div class="modal-footer form-inline" style="justify-content:space-between;">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
          <label class="col-form-label"  runat="server"> Key - </label>
    <input type="password" class="form-control" id="txtPass1"  maxlength="10"  runat="server" style="width: 200px;"/>
           <button type="button"  class="btn btn-primary"  data-dismiss="modal"  runat="server" onserverclick="Trigger1" > Yes</button>
  <%--onserverclick="Trigger"--%>
<%--        <asp:UpdatePanel ID="UpdatePanel4" runat="server">  
<ContentTemplate> --%>
     
    <%--  </ContentTemplate>  
</asp:UpdatePanel>  --%>
      </div>
           
    </div>
  </div>
</div>

           <div class="modal fade" id="exampleModal2" tabindex="-1" aria-labelledby="exampleModalLabel2" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
        
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel2">確認！</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <span class="active"> Capital用のプログラムをダウンロードしますか？</span>      
          <input type="hidden" id="hdn_val2" runat="server" value="0"/>
      </div>
      <div class="modal-footer form-inline" style="justify-content:space-between;">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
          <label class="col-form-label"  runat="server"> Key - </label>
    <input type="password" class="form-control" id="txtPass2"  maxlength="10"  runat="server" style="width: 200px;"/>
           <button type="button"  class="btn btn-primary"  data-dismiss="modal"  runat="server" onserverclick="Trigger2" > Yes</button>
  <%--onserverclick="Trigger"--%>
<%--        <asp:UpdatePanel ID="UpdatePanel4" runat="server">  
<ContentTemplate> --%>
     
    <%--  </ContentTemplate>  
</asp:UpdatePanel>  --%>
      </div>
           
    </div>
  </div>
</div>

            <div class="modal fade" id="exampleModal3" tabindex="-1" aria-labelledby="exampleModalLabel3" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
        
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel3">確認！</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <span class="active"> Haspo用のプログラムをダウンロードしますか？</span>      
          <input type="hidden" id="hdn_val3" runat="server" value="0"/>
      </div>
      <div class="modal-footer form-inline" style="justify-content:space-between;">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
          <label class="col-form-label"  runat="server"> Key - </label>
    <input type="password" class="form-control" id="txtPass3"  maxlength="10"  runat="server" style="width: 200px;"/>
           <button type="button"  class="btn btn-primary"  data-dismiss="modal"  runat="server" onserverclick="Trigger3" > Yes</button>
  <%--onserverclick="Trigger"--%>
<%--        <asp:UpdatePanel ID="UpdatePanel4" runat="server">  
<ContentTemplate> --%>
     
    <%--  </ContentTemplate>  
</asp:UpdatePanel>  --%>
      </div>
           
    </div>
  </div>
</div>
              
           <div class="modal fade" id="exampleModal4" tabindex="-1" aria-labelledby="exampleModalLabel4" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
        
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel4">確認！</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <span class="active"> Tennic用のプログラムをダウンロードしますか？</span>      
          <input type="hidden" id="hdn_val4" runat="server" value="0"/>
      </div>
      <div class="modal-footer form-inline" style="justify-content:space-between;">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
          <label class="col-form-label"  runat="server"> Key - </label>
    <input type="password" class="form-control" id="txtPass4"  maxlength="10"  runat="server" style="width: 200px;"/>
           <button type="button"  class="btn btn-primary"  data-dismiss="modal"  runat="server" onserverclick="Trigger4" > Yes</button>
  <%--onserverclick="Trigger"--%>
<%--        <asp:UpdatePanel ID="UpdatePanel4" runat="server">  
<ContentTemplate> --%>
     
    <%--  </ContentTemplate>  
</asp:UpdatePanel>  --%>
      </div>
           
    </div>
  </div>
</div>
               <div class="modal fade" id="exampleModal5" tabindex="-1" aria-labelledby="exampleModalLabel5" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
        
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel5">確認！</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <span class="active"> Shinyoh用のプログラムをダウンロードしますか？</span>      
          <input type="hidden" id="hdn_val5" runat="server" value="0"/>
      </div>
      <div class="modal-footer form-inline" style="justify-content:space-between;">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
          <label class="col-form-label"  runat="server"> Key - </label>
    <input type="password" class="form-control" id="txtPass5"  maxlength="10"  runat="server" style="width: 200px;"/>
           <button type="button"  class="btn btn-primary"  data-dismiss="modal"  runat="server" onserverclick="Trigger5" > Yes</button>
  <%--onserverclick="Trigger"--%>
<%--        <asp:UpdatePanel ID="UpdatePanel4" runat="server">  
<ContentTemplate> --%>
     
    <%--  </ContentTemplate>  
</asp:UpdatePanel>  --%>
      </div>
           
    </div>
  </div>
</div>
              
             
      </div>
          </form>
      <%--<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>--%>

   <script>
       function openModal() {
           $('#myModal').modal('show');
       }
       function hdnClick(val) {
           document.getElementById('txtPass1').value = "";
           document.getElementById('txtPass2').value = "";
           document.getElementById('txtPass3').value = "";
           document.getElementById('txtPass4').value = "";
           document.getElementById('txtPass5').value = "";
           //alert(val)
           document.getElementById('hdn_val1').value = val;// = val;
           document.getElementById('hdn_val2').value = val;// = val;
           document.getElementById('hdn_val3').value = val;// = val;
           document.getElementById('hdn_val4').value = val;// = val;
           document.getElementById('hdn_val5').value = val;// = val;
       }

       function loadImage() {
           // alert(document.getElementById("hdn_colm").value)
           var res = document.getElementById("hdn_colm").value;//.split("_");
           // var count = res.length;

           if (res == "1") {
               for (var f = 1; f <= 8; f++) {
                   $("tr").each(function () {
                       try {
                           $(this).children("th:eq(" + (10 - f) + ")").remove();
                       }
                       catch {

                       }
                       try {
                           $(this).children("td:eq(" + (10 - f) + ")").remove();
                       }
                       catch { }
                   });
               }
           }
           else if (res == "2") {
               for (var f = 1; f <= 6; f++) {
                   $("tr").each(function () {
                       try {
                           $(this).children("th:eq(" + (10 - f) + ")").remove();
                       }
                       catch {

                       }
                       try {
                           $(this).children("td:eq(" + (10 - f) + ")").remove();
                       }
                       catch { }
                   });
               }

               for (var f = 1; f <= 2; f++) {
                   $("tr").each(function () {
                       try {
                           $(this).children("th:eq(" + 1 + ")").remove();
                       }
                       catch {
                       }
                       try {
                           $(this).children("td:eq(" + 0 + ")").remove();
                       }
                       catch { }

                   });
               }
           }
           else if (res == "3") {
               for (var f = 1; f <= 4; f++) {
                   $("tr").each(function () {
                       try {
                           $(this).children("th:eq(" + (10 - f) + ")").remove();
                       }
                       catch {

                       }
                       try {
                           $(this).children("td:eq(" + (10 - f) + ")").remove();
                       }
                       catch { }
                   });
               }
               for (var f = 1; f <= 4; f++) {
                   $("tr").each(function () {
                       try {
                           $(this).children("th:eq(" + 1 + ")").remove();
                       }
                       catch {
                       }
                       try {
                           $(this).children("td:eq(" + 0 + ")").remove();
                       }
                       catch { }

                   });
               }
           }
           else if (res == "4") {
               for (var f = 1; f <= 2; f++) {
                   $("tr").each(function () {
                       try {
                           $(this).children("th:eq(" + (10 - f) + ")").remove();
                       }
                       catch {

                       }
                       try {
                           $(this).children("td:eq(" + (10 - f) + ")").remove();
                       }
                       catch { }
                   });
               }
               for (var f = 1; f <= 6; f++) {
                   $("tr").each(function () {
                       try {
                           $(this).children("th:eq(" + 1 + ")").remove();
                       }
                       catch {
                       }
                       try {
                           $(this).children("td:eq(" + 0 + ")").remove();
                       }
                       catch { }

                   });
               }
           }
           else {
               for (var f = 1; f <= 8; f++) {
                   $("tr").each(function () {
                       try {
                           $(this).children("th:eq(" + 1 + ")").remove();
                       }
                       catch {
                       }
                       try {
                           $(this).children("td:eq(" + 0 + ")").remove();
                       }
                       catch { }

                   });
               }
           }

       }
    
   </script>

    <!-- Optional JavaScript -->
    <!-- jQuery first, then Popper.js, then Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.4.1.slim.min.js" integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
 
            </body>
</html>