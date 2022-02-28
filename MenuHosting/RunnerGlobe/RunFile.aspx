<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RunFile.aspx.cs" Inherits="MenuHosting.RunnerGlobe.RunFile" EnableEventValidation="false" %> 
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1"   %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html"; charset="shift-jis"/>
    <meta charset="UTF-8" />
    <%--<globalization requestEncoding="utf-8" responseEncoding="utf-8" fileEncoding="utf-8" />--%>



<%--    <meta  http-equiv="Content-Type" content="text/html"; charset="utf-8"/>--%>
    <title> Runner</title>
    <style>
        .form-group {
            float: left;
        }

        .float-container {
            border: 3px solid #fff;
            padding: 20px;
        }

        .float-child {
            width: 100%;
            float: left;
            padding: 20px;
            border: 2px solid red;
        }
             td {
      padding-left: 70px;
    }
    </style> 

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-+0n0xVW2eSR5OomGNYDnhzAbDsOXxcvSN1TPprVMTNDbiYZCxYbOOl7+AMvyTG2x" crossorigin="anonymous">

<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">

  
</head>
<body>
     <form runat="server"> 
    <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
</cc1:ToolkitScriptManager>
          <asp:UpdatePanel ID="UpdatePanel4" runat="server">  
<ContentTemplate>  
                 <asp:Timer  Enabled="true" ID="Timer1" OnTick="Timer1_Tick" runat="server" Interval="5000" />
    </ContentTemplate>
              </asp:UpdatePanel>  
         <div runat="server" class="Container border border-primary" style="padding-top:7px;">

        <div class="col-12">
  <div class="form-inline">
      
 <%-- <a class="btn btn-primary" data-toggle="collapse" href="#collapseExample" role="button" aria-expanded="false" aria-controls="collapseExample">
    Link with href
  </a>--%>
    <%--   <button runat="server" id="RunText" onserverclick="Runtext" class="btn btn-primary" type="button" data-toggle="collapse" data-target="#collapseExample" aria-expanded="false" aria-controls="collapseExample">
    Batch Check
  </button>--%>
  <button class="btn btn-primary" type="button" data-toggle="collapse" data-target="#collapseExample" aria-expanded="false" aria-controls="collapseExample">
    Batch Destination
  </button>
      <div class="form-inline" style="padding-left:10px;width: 10%;">
  
<select class="custom-select my-1 mr-sm-2" id="sl_Project" onchange="GetDetails(this.value)"  runat="server"   > 
    <option value="SMS-Capital" selected>SMS-Capital</option>
    <option value="SMS-Haspo" >SMS-Haspo</option>
    <option value="SMS-Tennic">SMS-Tennic</option>
     <option value="Shinyoh-MM">Shinyoh-MM</option>
     <option value="Shinyoh-JP">Shinyoh-JP</option>
  </select>
</div>
    <div style="width:15%"></div>
         
      <a href="MainMenu.aspx?dltpe=mainmenu" style="text-decoration:underline ;padding:0 40px;"  target="_blank">  MainMenu </a>
      <a href="CapitalSport.aspx?dltpe=capitalsms" style="text-decoration:underline; padding:0 40px;"  target="_blank">  CapitalSMS </a> 
      <a href="Haspo.aspx?dltpe=hasposms" style="text-decoration:underline ;padding:0 40px;"  target="_blank">  HaspoSMS </a>
      <a href="Tennic.aspx?dltpe=tennicsms" style="text-decoration:underline;padding:0 40px;"  target="_blank">  TennicSMS</a>
      <a href="Shinyoh.aspx?dltpe=shinyoh" style="text-decoration:underline;padding:0 40px;"  target="_blank">  Shinyoh</a>
       
<%--          <a href=""  onserverclick="capitalDown"  download="capital_setup.exe" runat="server" style=" " id="cpt_ver"> CapitalSMS- </a>
          <div style=" "></div>
          <a href=""  onserverclick="haspoDown"  download="haspo_setup.exe" runat="server" style=" " id="hsp_ver"> HaspoSMS- </a>
          <div style=" "></div>
          <a href=""  onserverclick="tennicDown"  download="tennic_setup.exe" runat="server" style=" " id="tnc_ver"> TennicSMS- </a> --%>


</div>
<div class="collapse border-info" id="collapseExample">
   
   <%-- <form runat="server" class="form-inline">--%>
        <%-- <asp:ScriptManager ID="scriptmanager1" runat="server">  
</asp:ScriptManager>  --%>

  <div class="form-group mb-2">
    <input type="text" readonly  class="form-control-plaintext" id="" value="Batch Path">
  </div>
  <div class="form-group mx-sm-3 mb-2">
    <input type="text"  readonly  class="form-control" id="bthPath" placeholder="C:\run.bat" runat="server" style="width: 500px;"/>
  </div>
        <asp:UpdatePanel ID="updatepnl" runat="server">  
<ContentTemplate>  
      <button type="submit" class="btn btn-primary mb-2" runat="server" onserverclick="UpdateClick"  style="cursor: not-allowed; opacity:0.6; "> Use Default Path </button>
     </ContentTemplate>  
</asp:UpdatePanel>  

    <div class="form-group mb-2">
    <input type="text" readonly class="form-control-plaintext" id="staticEmail2" value="Compiled Path">
  </div>
  <div class="form-group mx-sm-3 mb-2">
    <input type="text" class="form-control" id="cmpPath" readonly placeholder="C:\Errors.log" runat="server" style="width: 500px;"/>
  </div>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">  
<ContentTemplate>  
      <button type="submit" class="btn btn-primary mb-2" runat="server" onserverclick="UpdateClick"  style="cursor: not-allowed; opacity:0.6; "> Use Default Path </button>


    </ContentTemplate>  
</asp:UpdatePanel>  
           
    <div class="form-group mb-2">
    <input type="text" readonly class="form-control-plaintext" id="staticEmail2" value="Execution Path"/>
  </div>
  <div class="form-group mx-sm-3 mb-2">
    <input type="text" class="form-control" id="execuPath" readonly placeholder="C:\SP.log" runat="server" style="width: 500px;"/>
  </div>
        <asp:UpdatePanel ID="UpdatePanel2" runat="server">  
<ContentTemplate>  
      <button type="submit" class="btn btn-primary mb-2" runat="server" onserverclick="UpdateClick"  style="cursor: not-allowed; opacity:0.6; "> Use Default Path </button>


    </ContentTemplate>  
</asp:UpdatePanel>  

      <div class="form-group mb-2">
    <input type="text" readonly class="form-control-plaintext" id="staticEmail2" value="Status Path">
  </div>
  <div class="form-group mx-sm-3 mb-2">
    <input type="text" class="form-control" id="stPath" readonly placeholder="C:\Flg.log" runat="server" style="width: 500px;"/>
  </div>
        <asp:UpdatePanel ID="UpdatePanel3" runat="server">  
<ContentTemplate>  
      <button type="submit" class="btn btn-primary mb-2" runat="server" onserverclick="UpdateClick"  style="cursor: not-allowed; opacity:0.6; "> Use Default Path </button>


    </ContentTemplate>  
</asp:UpdatePanel>  
        <%-- </form>--%>
      </div>
</div>

    </div>
        <br />
       <div runat="server" class="Container border border-primary" style="padding-top:25px;">


        <div class="row" style="width: 100%; margin-left:0px !important;" >
  <div class="form-inline" > 
     <button type="button" class="btn btn-primary btn-danger" data-toggle="modal" onmouseover="MouseHover(this)" data-target="#exampleModal" id="tri" style="margin-left:30px">
  Triggerer
</button>
        <button class="btn btn-primary" type="button" style="margin-left:20px;" runat="server" id="btnDisplayLog" onserverclick="ShowAllLog">
    Current Log
  </button> 
   
    <asp:UpdatePanel ID="UpdatePanel5" runat="server">  
<ContentTemplate>  
    <div style="vertical-align:middle" class="form-inline">
      <label runat="server" id="status"  visible="false"  style="color:blue; font-weight:bolder; font-size:large; padding-left:10px;"> </label>
   <div class="spinner-border text-success" role="status" style="margin-left:10px;" runat="server" id="loader" visible="false">
</div></div>
    </ContentTemplate>
        </asp:UpdatePanel>
</div>   
          <div class="float-container" style="width: inherit;">
   <asp:UpdatePanel ID="UpdatePanel6" runat="server">  
<ContentTemplate>  
  <div class="float-child">
      <p> Compilation Log</p>
      <hr />
    <div class="green">
        
     <p id="compiledLog" runat="server">
       


            </p>
    </div>
  </div>
  
  <div class="float-child">
      <p> Execution Log</p>
      <hr />
    <div class="blue">
        <p id="sqlLog" runat="server">
       
            </p>
    </div>
  </div>
  </ContentTemplate>
       </asp:UpdatePanel>
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
        <span class="active"> バッチコンパイラを実行してもよろしいですか？</span>
      </div>
      <div class="modal-footer form-inline" style="justify-content:space-between;">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
          <label class="col-form-label"  runat="server"> Key - </label>
    <input type="password" class="form-control" id="txtPass1"  maxlength="10"  runat="server" style="width: 200px;"/>
  
<%--        <asp:UpdatePanel ID="UpdatePanel4" runat="server">  
<ContentTemplate> --%>
        <button  type="button" class="btn btn-primary" runat="server" onserverclick="Trigger1"> Yes</button>
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
        <span class="active"> バッチコンパイラを実行してもよろしいですか？</span>
      </div>
      <div class="modal-footer form-inline" style="justify-content:space-between;">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
          <label class="col-form-label"  runat="server"> Key - </label>
    <input type="password" class="form-control" id="txtPass2"  maxlength="10"  runat="server" style="width: 200px;"/>
  
<%--        <asp:UpdatePanel ID="UpdatePanel4" runat="server">  
<ContentTemplate> --%>
        <button  type="button" class="btn btn-primary" runat="server" onserverclick="Trigger2"> Yes</button>
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
        <span class="active"> バッチコンパイラを実行してもよろしいですか？</span>
      </div>
      <div class="modal-footer form-inline" style="justify-content:space-between;">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
          <label class="col-form-label"  runat="server"> Key - </label>
    <input type="password" class="form-control" id="txtPass3"  maxlength="10"  runat="server" style="width: 200px;"/>
  
<%--        <asp:UpdatePanel ID="UpdatePanel4" runat="server">  
<ContentTemplate> --%>
        <button  type="button" class="btn btn-primary" runat="server" onserverclick="Trigger3"> Yes</button>
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
        <span class="active"> バッチコンパイラを実行してもよろしいですか？</span>
      </div>
      <div class="modal-footer form-inline" style="justify-content:space-between;">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
          <label class="col-form-label"  runat="server"> Key - </label>
    <input type="password" class="form-control" id="txtPass4"  maxlength="10"  runat="server" style="width: 200px;"/>
  
<%--        <asp:UpdatePanel ID="UpdatePanel4" runat="server">  
<ContentTemplate> --%>
        <button  type="button" class="btn btn-primary" runat="server" onserverclick="Trigger4"> Yes</button>
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
        <span class="active"> バッチコンパイラを実行してもよろしいですか？</span>
      </div>
      <div class="modal-footer form-inline" style="justify-content:space-between;">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
          <label class="col-form-label"  runat="server"> Key - </label>
    <input type="password" class="form-control" id="txtPass5"  maxlength="10"  runat="server" style="width: 200px;"/>
  
<%--        <asp:UpdatePanel ID="UpdatePanel4" runat="server">  
<ContentTemplate> --%>
        <button  type="button" class="btn btn-primary" runat="server" onserverclick="Trigger5"> Yes</button>
    <%--  </ContentTemplate>  
</asp:UpdatePanel>  --%>
      </div>
           
    </div>
  </div>
</div>
      <div class="modal fade" id="myModal" role="dialog">
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
          </form>
    <script type="text/javascript"> 
        var d = 0
        var myVar;
        window.onload = function () {
            //this.CheckTimer();
            //while (true) {
            //    setTimeout(() => {
            //        alert('ji');

            //    }, 5000);
        }


        //  this.CheckTimer();

        function CheckTimer() {
            myVar = setInterval(alertFunc, 5000);
        }

        function alertFunc() {
            alert("Hello!");
        }

        function MouseHover(e) {
            var ida = document.getElementById("loader");
            var element = document.getElementById("tri");
            if (ida.style.display === 'none' || ida.visibility != 'visible') {
                element.removeAttribute("disabled");
                element.disabled = true;

            }
            else {
                element.disabled = false;
                element.removeAttribute("disabled");
            }


        }
        function GetDetails(Id) {
            // alert('hi')
            document.getElementById("btnDisplayLog").click();
        }
        function openModal() {
            $('#myModal').modal('show');
        }

    </script>
    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
</body>
</html>
