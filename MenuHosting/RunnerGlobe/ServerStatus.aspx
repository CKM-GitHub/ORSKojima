<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ServerStatus.aspx.cs" Inherits="MenuHosting.RunnerGlobe.ServerStatus" EnableEventValidation="false" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1"   %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title> </title>
    <style>
        .custom-control-label::before , .custom-control-label::after {
            background-color:white;
            position:initial;
        }
        .form-check-inline .form-check-input 
        {
            margin-top: 5px !important;
        }
        #profile-container {
    width: 150px;
    height: 150px;
    overflow: hidden;
    -webkit-border-radius: 50%;
    -moz-border-radius: 50%;
    -ms-border-radius: 50%;
    -o-border-radius: 50%;
    border-radius: 50%;
}
        #profile-container img {
    width: 150px;
    height: 150px;
}
    </style>
      <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-+0n0xVW2eSR5OomGNYDnhzAbDsOXxcvSN1TPprVMTNDbiYZCxYbOOl7+AMvyTG2x" crossorigin="anonymous">

<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
    <link rel="icon" 
            type="image/png" 
            href="http://example.com/myicon.png" runat="server" id="pIcon" />
</head>
<body>
    <form id="form1" class="" runat="server"  style="padding-top: 50px;border: 0px solid #dee2e6!important; width:100%; "> 
      
<%--    <div class="row "     >--%>
        <%--<div style="padding-left: 2%;" aria-disabled="true" >
        <input class="form-check-input" type="radio" name="inlineRadioOptions" id="inlineRadio0" value="option1"/>
  <label class="form-check-label" for="inlineRadio1" runat="server" id="uad">1</label>
        
        <br />
              <input class="form-check-input" type="radio" name="inlineRadioOptions" id="inlineRadio1" value="option1"/> 
  <label class="form-check-label" for="inlineRadio1" runat="server" id="u1">1</label>
             
        <br />
              <input class="form-check-input" type="radio" name="inlineRadioOptions" id="inlineRadio2" value="option1"/>
  <label class="form-check-label" for="inlineRadio1" runat="server" id="u2">1</label>  
        <br />
            </div>--%>
          <span style="color:red;font-weight:bold;  " >All Changes would be reflected in "0-1 Minutes" after actions  . . . </span>
         <div class="form-check form-check-inline"  >

             <div class="form-check form-switch  " style="float:right; ">
        <input class="form-check-input" style="width: 5em !important; cursor:pointer" type="checkbox" id="flexSwitchCheckDefault" runat="server"    onclick ="changed(this)"   />
    
                <label class="form-check-label" for="flexSwitchCheckDefault" runat="server" id="lblAction">Action State</label>
                 </div>  &nbsp; &nbsp; &nbsp; &nbsp;
            <a  target="_blank" href="https://phyoe.ckmphpdev.tech/RunnerGlobe/RunFile.aspx">Compiler Log File </a>
             <%--<div id="profile-container">
   <%--<image id="profileImage"  style="visibility:hidden"  src="http://163.43.113.92/HR_Management/Photo/PG-138.jpg"  />--%>
<%--</div>--%>
</div>
        <div class="row">
        <div class="col-xs-6 col-md-6" style="margin-left: 1% !important;
    max-width: 48% !important;">
         
         <%--   <div class="form-check form-switch  " style="padding-left: 5% !important; float:right">
                <input class="form-check-input  style"width: 5em !important" type="checkbox" id="flexSwitchCheckDefault" />
                <label class="form-check-label" for="flexSwitchCheckDefault">Block All Scope</label>
            </div> --%>
                 <button disabled readonly href="#" class="btn btn-info btn-md" style="float:right; margin-bottom: 5px; cursor:not-allowed" onclick="window.location.reload();"><i class="glyphicon glyphicon-refresh"></i>
          <span class="glyphicon glyphicon-refresh"></span> Refresh
        </button>
            <div class="form-group">
                <label class="custom-control-label" style="    margin-top: 3%;"> Server  </label>
                <input class="form-control" runat="server" id="serverId" readonly/>
            </div>
            <div class="form-group">
                <label class="custom-control-label">Rule  </label>
                <input class="form-control" runat="server"  id="ruleName" readonly />
            </div>
            <div class="form-group">
                <label class="custom-control-label">Profile</label>
                <select class="form-control" readonly >
                    <option value="Any">Any</option>
                    <option value="Private">Private</option>
                    <option value="Public"> Public</option>
                    <option value="Domain"> Domain</option>
                </select>
            </div>
            <div class="form-group">
                <label   class="custom-control-label" > Protocol</label>
                <select class="form-control" readonly>
                    <option value="TCP"> TCP </option>
                    <option value="UDP"> UDP</option>
                </select>
            </div>
            <div class="form-group">
                <label for="exampleFormControlTextarea1">Scope</label>
                <textarea class="form-control" id="ipScope" rows="3"  style="height: 200px;" runat="server"></textarea>
            </div>
                <input type="button" runat="server"  class="btn btn-primary btn-info float-right" data-toggle="modal" data-target="#exampleModal" onclick="ChangeText('Are you sure to update scope?')" value="Update" /> 
          
        </div>
        
        <div class="col-xs-6 col-md-6"> 
                                                <asp:GridView ShowHeaderWhenEmpty="true" OnRowDataBound="rdtbound_up"  RowStyle-Height="30px" runat="server" ID="gvCostUnit" AutoGenerateColumns="false" CssClass="table table-striped table-bordered table-hover" HeaderStyle-BackColor="#69c3d1" HeaderStyle-ForeColor ="White"
                                  HeaderStyle-CssClass="ckmdiv"         >
                                        <Columns>
                                            <asp:TemplateField Visible="true" ItemStyle-HorizontalAlign="Right">
                                                <HeaderTemplate>
                                                    <asp:Label runat="server" ID="lblHeaderID" Text="ID"></asp:Label>
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <asp:Label runat="server" ID="lblID" Text='<%# Bind("ID") %>'></asp:Label>
                                                </ItemTemplate> 
                                            </asp:TemplateField>

                                               <asp:TemplateField Visible="true">
                                                <HeaderTemplate>
                                                    <asp:Label runat="server" ID="lblHeaderID" Text="User"></asp:Label>
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <asp:Label runat="server" ID="lblIDun" Text='<%# Bind("UserName") %>'></asp:Label>
                                                </ItemTemplate>  
                                            </asp:TemplateField>
                                            <asp:TemplateField Visible="true">
                                                <HeaderTemplate>
                                                    <asp:Label runat="server" ID="lblHeaderID" Text="Session"></asp:Label>
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <asp:Label runat="server" ID="lblIDss" Text='<%# Bind("Session") %>'></asp:Label>
                                                </ItemTemplate>  
                                            </asp:TemplateField>

                                               <asp:TemplateField Visible="true" >
                                                <HeaderTemplate>
                                                    <asp:Label runat="server" ID="lblHeaderID" Text="State"></asp:Label>
                                                </HeaderTemplate>
                                                <ItemTemplate >
                                                    <asp:Label runat="server" ID="spn_state" Text='<%# Bind("State") %>'></asp:Label>
                                                </ItemTemplate> 
                                            </asp:TemplateField>

                                                  <asp:TemplateField Visible="true" ItemStyle-HorizontalAlign="Center">
                                                <HeaderTemplate>
                                                    <asp:Label runat="server" ID="lblHeaderID" Text="IdleTime"></asp:Label>
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <asp:Label runat="server" ID="lblIDid" Text='<%# Bind("IdleTime") %>'></asp:Label>
                                                </ItemTemplate> 
                                            </asp:TemplateField>

                                                  <asp:TemplateField Visible="true" ItemStyle-HorizontalAlign="Center">
                                                <HeaderTemplate>
                                                    <asp:Label runat="server" ID="lblHeaderID" Text="LogonTime"></asp:Label>
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <asp:Label runat="server" ID="lblIDlo" Text='<%# Bind("LogonTime") %>'></asp:Label>
                                                </ItemTemplate> 
                                            </asp:TemplateField>
                                          
                                        </Columns>
                                    </asp:GridView>

            <asp:GridView   RowStyle-Height="30px" runat="server" ID="gv_Active" ShowHeaderWhenEmpty="true"  OnRowDataBound="rdtbound"  AutoGenerateColumns="false" CssClass="table table-striped table-bordered table-hover" HeaderStyle-BackColor="#69c3d1" HeaderStyle-ForeColor ="White"
                                  HeaderStyle-CssClass="ckmdiv" >
                                        <Columns>
                                            <asp:TemplateField Visible="true" ItemStyle-HorizontalAlign="Right">
                                                <HeaderTemplate>
                                                    <asp:Label runat="server" ID="lblHeaderID" Text="PortType"></asp:Label>
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <asp:Label runat="server" ID="lblIDpt" Text='<%# Bind("PortType") %>'></asp:Label>
                                                </ItemTemplate> 
                                            </asp:TemplateField>

                                               <asp:TemplateField Visible="true">
                                                <HeaderTemplate>
                                                    <asp:Label runat="server" ID="lblHeaderID" Text="Host"></asp:Label>
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <asp:Label runat="server" ID="lblIDhp" Text='<%# Bind("HostIP") %>'></asp:Label>
                                                </ItemTemplate>  
                                            </asp:TemplateField>
                                            <asp:TemplateField Visible="true">
                                                <HeaderTemplate>
                                                    <asp:Label runat="server" ID="lblHeaderID" Text="RemoteIP"></asp:Label>
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <asp:Label runat="server" ID="lblIDrp" Text='<%# Bind("RemoteIP") %>'></asp:Label>
                                                </ItemTemplate>  
                                            </asp:TemplateField>
                                                <asp:TemplateField Visible="true">
                                                <HeaderTemplate>
                                                    <asp:Label runat="server" ID="lblHeaderID" Text="Current Status"></asp:Label>
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <asp:Label runat="server" ID="spn_est" Text='<%# Bind("Status") %>'></asp:Label>
                                                </ItemTemplate>  
                                            </asp:TemplateField>
                                            </Columns>
                </asp:GridView>


        </div>
            </div>
    
        <div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
        
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">Comfirmation!</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <span class="active" id="spnMsg"> Are you sure to update scope?</span>
      </div>
      <div class="modal-footer form-inline" style="justify-content:space-between;">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
          <label class="col-form-label"  runat="server"> Key - </label>
    <input type="password" class="form-control" id="txtPass"  maxlength="10"  runat="server" style="width: 200px;"/>
  
<%--        <asp:UpdatePanel ID="UpdatePanel4" runat="server">  
<ContentTemplate> --%>
        <button  type="button" class="btn btn-primary" runat="server" onserverclick="Trigger"  > Yes</button>
    <%--  </ContentTemplate>  
</asp:UpdatePanel>  --%>
      </div>
           
    </div>
  </div>
</div>

         <script type="text/javascript">  
             //function openModal() {
             //    $('#myModal').modal('show');
             //}

             function changed(e) {
                 if (e.checked) {
                     GetDetails('allow'); 
                    // document.getElementById("myIdReference").title = 'my tooltip text'

                     document.getElementById('flexSwitchCheckDefault').setAttribute('title', 'allowing state');
                     document.getElementById('flexSwitchCheckDefault').removeAttribute('title');
                     document.getElementById('flexSwitchCheckDefault').setAttribute('title', 'allowing state');

                  //   document.getElementById('lblAction').innerText = 'Activate All Action';title="Tooltip on top"
                 }
                 else
                     GetDetails('block');
                 
                     document.getElementById('flexSwitchCheckDefault').removeAttribute('title');
                     document.getElementById('flexSwitchCheckDefault').setAttribute('title', 'blocking state');
              //   document.getElementById('lblAction').innerText = 'Deactivate All Action'; 
             }
             function ChangeText(msg) {
                 document.getElementById('spnMsg').innerText = msg;

             }
             function GetDetails(Id) {
                 PageMethods.GetDetails(Id);
             }
              

</script>
        <asp:ScriptManager ID="smMain" runat="server" EnablePageMethods="true" /> 
        
    </form>
       <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>

</body>
</html>
