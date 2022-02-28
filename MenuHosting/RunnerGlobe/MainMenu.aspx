<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MainMenu.aspx.cs" Inherits="MenuHosting.RunnerGlobe.MainMenu" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1"   %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
    <link rel="icon" href="https://upload.wikimedia.org/wikipedia/commons/thumb/f/fc/Icons8_flat_download.svg/1200px-Icons8_flat_download.svg.png">

    <title>ダウンロード</title>
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
  <body align="center">
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
    </tr>
  </thead>
  <tbody>
  
    <tr>
      <th scope="row">1</th>
   <td class="hideCln" > <a runat="server"   id="mainmenu" onclick="hdnClick('mainmenu')"  data-toggle="modal" data-target="#exampleModal1" class="cursorallow"  style="color:blue;"> mainmenu </a></td>
         <td class="hideCln" > ログイン時のユーザー情報更新プロセスを追加しました  </td>    
    </tr>
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
        <button type="button" class="btn btn-secondary" data-dismiss="modal">キャンセル</button>
          <label class="col-form-label"  runat="server"> キー  </label>
    <input type="password" class="form-control" id="txtPass1"  maxlength="10"  runat="server" style="width: 200px;"/>
           <button type="button"  class="btn btn-primary"  data-dismiss="modal"  runat="server" onserverclick="Trigger1" > はい</button>
      </div>
           
    </div>
  </div>
</div>          
      </div>
          </form>

   <script>
       function openModal() {
           $('#myModal').modal('show');
       }
       function hdnClick(val) {
           document.getElementById('txtPass1').value = "";
           //alert(val)
           document.getElementById('hdn_val1').value = val;// = val;
       }

   </script>

    <!-- Optional JavaScript -->
    <!-- jQuery first, then Popper.js, then Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.4.1.slim.min.js" integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
 
            </body>
</html>
