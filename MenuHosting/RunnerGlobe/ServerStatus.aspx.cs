using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Diagnostics;
using System.IO;
using System.Web.Services;
using System.Data;
using System.Runtime.InteropServices;
using System.DirectoryServices;
using System.Text;
using System.Configuration;
using System.Drawing;
using System.Threading.Tasks;

namespace MenuHosting.RunnerGlobe
{
    public partial class ServerStatus : System.Web.UI.Page
    {
        static string svr= "";
        static string rule = "";
        static string val = "";
        static string userId = "";
        static string  password = "";
        protected static string serverpath = "";
        protected void Grid()
        {
            

            DataTable dt = new DataTable();
            dt.Columns.Add("ID");
            dt.Columns.Add("UserName");
            dt.Columns.Add("Session");
            dt.Columns.Add("State");
            dt.Columns.Add("IdleTime");
            dt.Columns.Add("LogonTime");
            var val = ActiveUsers();
            if (val != null)
            { 
                foreach (var s in val)
                {
                    var enc = Encoding.UTF8.GetString(Encoding.Default.GetBytes(s));
                    if (!enc.ToLower().Contains("id") && !enc.ToLower().Contains("logon"))
                    {
                        
                        var id = "";
                        var name = "";
                        var session = "";
                        var state = "";
                        var idle = "";
                        var Logon = "";
                        try
                        {
                            name = enc.Substring(0, 22).Trim();
                            session = enc.Substring(22, 18).Trim();
                            id = enc.Substring(40, 4).Trim();
                            state = enc.Substring(44, 10).Trim();
                            var str = enc.Substring(45, enc.Length - 45).TrimStart().TrimEnd().Replace(state, "").TrimStart().TrimEnd().Split(' ');
                            idle = str.First();
                            Logon = enc.Substring(45, enc.Length - 45).TrimStart().TrimEnd().Replace(state, "").Replace(idle, "").Trim();
                            

                        }
                        catch (Exception ex)
                        {
                            
                        }
                        dt.Rows.Add(new object[] { id, name, session, state, idle, Logon });
                    }
                }
            }
            else
                SetAlert("Error on act binding . . .");
            gvCostUnit.DataSource = dt; ;
            gvCostUnit.DataBind(); 
            var act= Active();
            DataTable dtstatus = new DataTable();
            dtstatus.Columns.Add("PortType");
            dtstatus.Columns.Add("HostIP");
            dtstatus.Columns.Add("RemoteIP");
            dtstatus.Columns.Add("Status");
            if (act != null)
            {
                int ski = 0;
                foreach (var s in act)
                {
                    ski++;
                    if (ski > 4)
                        //if (!s.Contains("Proto"))
                        //{
                        if (!s.Contains("127.0.0.1") && !s.Contains("TIME_WAIT"))
                        {
                            var prt = "";
                            var hst = "";
                            var rmt = "";
                            var sts = "";
                            try
                            {
                                var enc = Encoding.UTF8.GetString(Encoding.Default.GetBytes(s));
                                prt = enc.Substring(0, 8);
                                hst = enc.Replace(prt, "").TrimStart().Split(' ').First(); //enc.Substring(8, 22);
                                rmt = enc.Replace(prt, "").Replace(hst, "").TrimStart().Split(' ').First(); //enc.Substring(22, 21);
                                sts = enc.TrimEnd().Split(' ').Last();  // prt.Replace(prt, "").Replace(hst, "").Replace(rmt, "").Trim();
                            }
                            catch
                            {
                                Response.Write("Error In reading");
                            }
                            dtstatus.Rows.Add(new object[] { prt, hst, rmt, sts });
                        }
                    //}
                }
            }
            else
                SetAlert("Error on est binding . . .");
            gv_Active.DataSource = dtstatus;
            gv_Active.DataBind(); 

        }
        protected void rdtbound_up(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                //If Salary is less than 10000 than set the Cell BackColor to Red and ForeColor to White  
                //if (e.Row.Cells[3].Text.ToUpper() == "ACTIVE")
                //{
                //    // if (Ips().Contains(e.Row.Cells[2].Text.ToString().Split(':').First()))
                //    e.Row.BackColor = Color.Cyan;
                //    //  e.Row.Cells[1].ForeColor = Color.White;
                //}


                Label lblID = e.Row.FindControl("spn_state") as Label;
                if (lblID.Text == "Active")
                {
                   e.Row.BackColor = Color.Cyan;
                }

            }
        }
        protected void rdtbound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                if (Ips().Contains(e.Row.Cells[2].Text.ToString().Split(':').First()))
                {
                    Label lblID = e.Row.FindControl("spn_est") as Label;
                    if (lblID.Text == "ESTABLISHED")
                    {
                        if ((e.Row.FindControl("lblIDhp") as Label).Text.Contains("5812"))
                        e.Row.BackColor = Color.Cyan;
                    }
                    else if   (  lblID.Text == "TIME_WAIT" )
                        {
                        
                        }
                    
                }
                //If Salary is less than 10000 than set the Cell BackColor to Red and ForeColor to White  
                //if (e.Row.Cells[3].Text.ToUpper() == "ESTABLISHED")
                //{
                //   if ( Ips().Contains(e.Row.Cells[2].Text.ToString().Split(':').First()))
                //         e.Row.BackColor = Color.Cyan;
                //}
            }
        }
        protected string[]  Active()
        {
            var pth = serverpath = Server.MapPath("~");
            string[] str = null;
            string targetDir = string.Format(pth + @"RunnerGlobe\");//PATH
            //Process proc = new Process();
            //proc.StartInfo.WorkingDirectory = targetDir;
            //proc.StartInfo.FileName = "scope4.bat";
            //proc.StartInfo.Arguments = string.Format("1");//argument
            //proc.StartInfo.CreateNoWindow = false;
            //proc.Start();
            //proc.WaitForExit();
            //if (proc.HasExited)
            //{
            //    //var ddd = proc.StandardOutput.ReadToEnd();
            //    str = File.ReadAllLines(targetDir + "users.log");
            //    if (str.Length == 0)
            //        str = null;
            //}
            str = File.ReadAllLines(targetDir + "users.log");
            if (str.Length == 0)
                str = null;
            return str;
        }

        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool Wow64DisableWow64FsRedirection(ref IntPtr ptr);

        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool Wow64RevertWow64FsRedirection(IntPtr ptr);
        
        public void TestMethod3()
        {
            var pth = serverpath = Server.MapPath("~");

            string targetDir = string.Format(pth + @"RunnerGlobe\");//PATH
            IntPtr ptr = new IntPtr();
            Wow64DisableWow64FsRedirection(ref ptr);
            ProcessStartInfo info = new ProcessStartInfo(targetDir+"scope6.cmd");
            Process proc = new Process();
            proc.StartInfo = info;
            proc.Start();
            Wow64RevertWow64FsRedirection(ptr);
        }
        protected string[] ActiveUsers()  // 4 for user // 5 for session
        {
           // TestMethod3();
            string[] str = null;
            try
            { 
                var pth = serverpath = Server.MapPath("~");

                //string targetDir = string.Format(pth + @"RunnerGlobe\");//PATH
                //Process proc = new Process();
                //proc.StartInfo.WorkingDirectory = targetDir;
                //proc.StartInfo.FileName = targetDir + "scope5.bat";
                //proc.StartInfo.Arguments = string.Format("1");//argument
                //                                              // proc.StartInfo.Verb = "runas";
                //proc.StartInfo.UseShellExecute = false;
                //proc.StartInfo.CreateNoWindow = false;
                //proc.StartInfo.RedirectStandardInput = true;
                //proc.Start();
                //proc.WaitForExit();
                //var pth = serverpath = Server.MapPath("~");

                //string targetDir = string.Format(pth) + @"RunnerGlobe\";//PATH
                //Process proc = new Process();
                //proc.StartInfo.FileName =targetDir +   "scope5.bat" ;
                //  proc.StartInfo.Arguments = string.Format("1");//argument 
                //Process.Start(@"D:\GIT\New_SMS\MenuHosting\RunnerGlobe\scope5.bat","1");
                //proc.WaitForExit();
                //if (proc.HasExited)
                //{
                    //var ddd = proc.StandardOutput.ReadToEnd();
                    str = File.ReadAllLines(pth +@"RunnerGlobe\"+ "session.log");
                    if (str.Length == 0)
                        str = null;
                //}
            }
            catch (Exception ex){
                var dd = ex.Message;
            }
            return str;
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            serverpath = Server.MapPath("~");
            svr = ConfigurationManager.AppSettings["svr"].ToString();
            rule = ConfigurationManager.AppSettings["rule"].ToString();
            Crypto cry = new Crypto(); 
            try
            {
              //   WriteFileIps();
               // return;
                
                if (!String.IsNullOrEmpty(Request.QueryString["ip"]))
                {
                    val = Request.QueryString["ip"].ToString();
                }
                if (!String.IsNullOrEmpty(Request.QueryString["usrId"]))
                {
                    userId = Request.QueryString["usrId"].ToString();
                }
                else
                    userId = "Server Status";
                if (!String.IsNullOrEmpty(Request.QueryString["psw"]))
                { 
                    try
                    {
                        password = cry.Decrypt(Request.QueryString["psw"].ToString().Replace("*", "="), "forever_arsenal");
                    }
                    catch { }
            
                }

                if (!Page.IsPostBack)
                {
                    if (val == "" || val != svr)
                    {
                        //SetAlert("You are not authethicated user!");
                        this.Page.Title = "Access Denied!";
                        pIcon.Href = "https://img.icons8.com/material-outlined/24/fa314a/cancel-2.png";
                        SetAlert("Access Denied!");
                        return;
                    } 
                    else
                    {
                        this.Page.Title = val;
                        pIcon.Href = "https://img.icons8.com/ios-filled/50/fa314a/individual-server.png";
                    }

                   Initial();
                }
                Grid();
            }
            catch (Exception ex)
            {

                SetAlert(ex.Message);
            }
        }

        protected void Trigger(object sender, EventArgs e)
        {
            // var f = ipScope.Value;
            if (string.IsNullOrWhiteSpace(txtPass.Value))
            {
                SetAlert("Please fill the secret password.");
            }
            else
            {
                if (txtPass.Value == password)   // pass
                {
                    WriteFileIps();
                   // UpdateIP();
                }
                else
                {
                    SetAlert("Please fill the correct secret password.");
                }
            }
        }

        protected void Checked(object sender, EventArgs e)
        {
        }
        protected void RunScript()
        {
            var pth = Server.MapPath("~");
            string targetDir = string.Format(pth + @"RunnerGlobe\");//PATH
            Process proc = new Process();
            proc.StartInfo.WorkingDirectory = targetDir;
            proc.StartInfo.FileName = "scope1.bat";
            proc.StartInfo.Arguments = string.Format("1");//argument
            proc.StartInfo.CreateNoWindow = false;
            
            proc.Start();
            proc.WaitForExit();
            var readLine = File.ReadAllLines(targetDir + "ptk.log");
            SetAlert(readLine.Last());
        }

        private void Proc_OutputDataReceived(object sender, DataReceivedEventArgs e)
        {

        }

        private void Process_OutputDataReceived(object sender, DataReceivedEventArgs e)
        {
            //Response.Write(e.Data.ToString());
        }

        protected void Initial()
        {
            //server
            var ip4 = Dns.GetHostEntry(Dns.GetHostName()).AddressList.First(x => x.AddressFamily == System.Net.Sockets.AddressFamily.InterNetwork).ToString();
            serverId.Value = Environment.MachineName + ("(" + ip4 + ")");

            //Rule
            ruleName.Value = "Remote Desktop-User Mode(TCP - In)";

            //Active state
            //uad.InnerText = "Administrator" + " ";
            //u1.InnerText = "capital1" + "   ";
            //u2.InnerText = "capital2" + "   ";

            //Set IP
            ipScope.Value = SetIP();

            System.Threading.Thread.Sleep(1000);
            //Set Action
            flexSwitchCheckDefault.Checked = GetAllowAllStatus().ToLower() == "allow";
            if (flexSwitchCheckDefault.Checked)
                //lblAction.InnerText = "Deactive All Action";
                flexSwitchCheckDefault.Attributes.Add("title", "allowing state");
            else
                flexSwitchCheckDefault.Attributes.Add("title", "blocking state");
            //lblAction.InnerText = "Activate All Action";

        }
        protected string SetIP()
        {
            var val = "";
            try
            {
                var pth= serverpath = Server.MapPath("~");

                string targetDir = string.Format(pth + @"RunnerGlobe\");//PATH
                //Process proc = new Process();
                //proc.StartInfo.WorkingDirectory = targetDir;
                //proc.StartInfo.FileName = "scope1.bat";
                //proc.StartInfo.Arguments = string.Format("1");//argument
                //proc.StartInfo.CreateNoWindow = false;
                //proc.StartInfo.Verb = "runas";
                //proc.Start();
                //proc.WaitForExit();
                //if (proc.HasExited)
                //{
                    var readLine = File.ReadAllLines(targetDir + "scopeip.log").Last();
                    if (!String.IsNullOrEmpty(readLine))
                    {
                        readLine = readLine.Replace("RemoteIP:", "").Trim();
                        foreach (var v in readLine.Split(','))
                        {
                            var a = "";
                            a = v.Split('/').FirstOrDefault();
                            val += a + Environment.NewLine;
                        }
                        return val;
                    }
                //}
            }
            catch (Exception ex)
            {
                val = ex.Message;
            }
            return val;
        }
        protected string Ips()
        {
            var txtarea = ipScope.Value;
            txtarea = txtarea.Trim().Replace(Environment.NewLine, ",");
            foreach (var c in txtarea.Split(','))
            {
                if (!String.IsNullOrWhiteSpace(c) && !String.IsNullOrEmpty(c))
                {
                    val += c + ",";
                }
            }
            if (val.Substring(val.Length - 1) == ",")
                val = val.Remove(val.Length - 1);

            return val;
           // val = val.Replace(",", "_");
        }
        protected void UpdateIP()
        {
            var val = "";
            try
            {
                var pth = Server.MapPath("~");
                string targetDir = string.Format(pth + @"RunnerGlobe\");//PATH
                //Process proc = new Process();
                //proc.StartInfo.WorkingDirectory = targetDir;
                //proc.StartInfo.FileName = "scope2.bat";
                var txtarea = ipScope.Value;
                txtarea = txtarea.Trim().Replace(Environment.NewLine, ",");
                foreach (var c in txtarea.Split(','))
                {
                    if (!String.IsNullOrWhiteSpace(c) && !String.IsNullOrEmpty(c))
                    {
                        val += c + ",";
                    }
                }
                if (val.Substring(val.Length - 1) == ",")
                    val = val.Remove(val.Length - 1);

                val = val.Replace(",", "_");
                //object[] args = new object[] { val };
                //proc.StartInfo.Arguments = string.Format(args[0].ToString());
                //proc.StartInfo.CreateNoWindow = false;
                //proc.StartInfo.Verb = "runas";
                //proc.Start();
                //proc.WaitForExit();
                //var readLine = File.ReadAllLines(targetDir + "ptk.log").Last();
                //if (!String.IsNullOrEmpty(readLine))
                //{
                //    if (readLine.Contains("ius") || readLine.Contains("remote"))
                //    {
                SetAlert("Scope was successfully updated!!!");
                //}
                //else {
                //    SetAlert("Scope update Failed!");
                //    }
                //}
            }
            catch (Exception ex)
            {
                val = ex.Message;
                SetAlert(val);
            }
        }
        public void WriteFileIps() // scope2
        {
            var val = "";
            var msg = "Action was successfully updated!!!";
            var pth = Server.MapPath("~");
            string targetDir = string.Format(pth + @"RunnerGlobe\");
            var txtarea = ipScope.Value;
            txtarea = txtarea.Trim().Replace(Environment.NewLine, ",");
            foreach (var c in txtarea.Split(','))
            {
                if (!String.IsNullOrWhiteSpace(c) && !String.IsNullOrEmpty(c))
                {
                    val += c + ",";
                }
            }
            try
            {
                if (val.Substring(val.Length - 1) == ",")
                    val = val.Remove(val.Length - 1);
            }
            catch { }
            var text = "netsh advfirewall firewall set rule name=\""+rule+"\" new remoteip="+val;
            try
            {
                File.WriteAllText(targetDir + "scope2.bat", text);
            }
            catch (Exception ex)
            {
                msg = ex.Message;
            }
            SetAlert(msg);
        }
        public static string  WriteFileAction(bool IsAllow)  // Scope3
        {
            var msg = "Action was successfully updated!!!";
            var pth = serverpath; //Server.MapPath("~");
            string targetDir = string.Format(pth + @"RunnerGlobe\");//PATH
            string val = "";
            if (IsAllow)
            {
                val = "netsh advfirewall firewall set rule name=\"" + rule + "\" new action=allow";
            }
            else
                val = "netsh advfirewall firewall set rule name=\"" + rule + "\" new action=block";
            try
            {
                File.WriteAllText(targetDir+"scope3.bat", val);
            }
            catch (Exception ex)
            {
                msg = ex.Message;
            }
            return msg;
        }
        protected  void SetAlert(string val)
        {
            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "Script1", "<script>alert('" + val + "')</script>");
        }
        [System.Web.Services.WebMethod]
        public static void GetDetails(string Id)
        { 
            try
            {
                
               WriteFileAction(Id=="allow");
               // SetAlert();
                //var pth = serverpath;
                //string targetDir = string.Format(pth + @"RunnerGlobe\");//PATH
                //Process proc = new Process();
                //proc.StartInfo.WorkingDirectory = targetDir;
                //proc.StartInfo.FileName = "scope3.bat";
                //object[] args = new object[] { Id };
                //proc.StartInfo.Arguments = string.Format(args[0].ToString()); 
                //proc.StartInfo.CreateNoWindow = false;
                //proc.StartInfo.Verb = "runas";
                //proc.Start();
                //proc.WaitForExit(); 
            }
            catch
            {

            }
        }
        protected string GetAllowAllStatus()
        {
            var val = "";
            try
            {
                var pth = serverpath = Server.MapPath("~");

                string targetDir = string.Format(pth + @"RunnerGlobe\");//PATH
              //  Process proc = new Process();
              //  proc.StartInfo.WorkingDirectory = targetDir;
              //  proc.StartInfo.FileName = "scope1.bat";
              //  proc.StartInfo.Arguments = string.Format("2");//argument
              //  proc.StartInfo.CreateNoWindow = true;
              ////  proc.StartInfo.Verb = "runas";
              //  proc.Start();
              //  proc.WaitForExit();
              //  if (proc.HasExited)
              //  {
                    var readLine = File.ReadAllLines(targetDir + "action.log").Last();
                    if (!String.IsNullOrEmpty(readLine))
                    {
                        if (readLine.Contains("Action"))
                        {
                            val = readLine.Replace("Action:", "").Trim();
                        }
                        return val;
                    }
                //}
            }
            catch (Exception ex)
            {
                val = ex.Message;
            }
            return val;
        }

    }
}