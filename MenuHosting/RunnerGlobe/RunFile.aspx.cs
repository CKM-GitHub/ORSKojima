using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Diagnostics;
using Microsoft.Win32.TaskScheduler;
using System.Security;
using System.Text;
using System.Configuration;
using System.Web.UI.HtmlControls;
using System.Xml;
using System.Xml.Linq;
using System.Net;

namespace MenuHosting.RunnerGlobe
{
    public partial class RunFile : System.Web.UI.Page
    {
        string svrpst1 = "";
        string svrpst2 = "";
        string svrpst3 = "";
        string svrpst4 = "";
        string svrpst5 = "";
        Timer timer;
      
        protected void Page_Load(object sender, EventArgs e)
        {

            // File.ReadAllText("page.jsp");
            //   var read = File.ReadAllText(@"‪D:\P_\Haspo\setip.exe");
            //   XDocument xdoc = XDocument.Parse(File.ReadAllText(@"‪D:\P_\Haspo\HaspoSMS.application"));
            //   var q = (from myConfig in xdoc.Elements("assemblyIdentity")
            //            select myConfig.Attribute("version").Value)
            //.First();
            //var cust = xdoc.Descendants("assemblyIdentity")
            //                .First(rec => rec.Attribute("version").Value == "5");
            // return;
            // timer= new Timer();
            // timer.Interval = 1000;
            // timer.Enabled = true;
            //// timer.
            // timer.Tick += Timer1_Tick;
            svrpst1 = ConfigurationManager.AppSettings["pst1"].ToString();
            svrpst2 = ConfigurationManager.AppSettings["pst2"].ToString();
            svrpst3 = ConfigurationManager.AppSettings["pst3"].ToString();
            svrpst4 = ConfigurationManager.AppSettings["pst4"].ToString();
            svrpst5 = ConfigurationManager.AppSettings["pst5"].ToString();

            if (!IsPostBack)
            {
                SetDefaultValueSMS();

                #region Testing code by ETZ

                //Response.WriteFile(Server.MapPath("~") + @"\RunnerGlobe\test.log");
                //string exeAr = "";
                //var ln = System.IO.File.ReadAllLines(Server.MapPath("~") + @"\RunnerGlobe\test.log", Encoding.GetEncoding("Shift_Jis"));
                //foreach (var l in ln)
                //    exeAr += l + Environment.NewLine;// +// "\r\n";
                //if (!string.IsNullOrEmpty(exeAr))
                //    sqlLog.InnerHtml = GetString(exeAr);
                //else
                //    sqlLog.InnerHtml = "No Error * * *";
                #endregion

                //File.WriteAllBytes("F:\\file.txt", Encoding.UTF8.GetBytes(a.ToString()));

                ShowLog();/////Temp 
                SetLog();
            }
            try
            {
                // cpt_ver.HRef = Server.MapPath("~") + @"capital20211015\setup.exe";
                //cpt_ver.InnerText = cpt_ver.InnerText + GetLast(Server.MapPath("~") + @"capital20211015\Application Files");
                //// hsp_ver.HRef = Server.MapPath("~") + @"haspo20211015\setup.exe";
                //hsp_ver.InnerText = hsp_ver.InnerText + GetLast(Server.MapPath("~") + @"haspo20211015\Application Files");
                //// tnc_ver.HRef = Server.MapPath("~") + @"tennic20211015\setup.exe";
                //tnc_ver.InnerText = tnc_ver.InnerText + GetLast(Server.MapPath("~") + @"tennic20211015\Application Files");
            }
            catch
            {

            }
        }
        protected string GetLast(string str)
        {
            var version = "";
            try
            {
                string[] dr = System.IO.Directory.GetDirectories(str);
                Array.Sort(dr);
                version = dr.Last().Split('\\').Last().Replace("HaspoSMS_", "").Replace("TennicSMS_", "").Replace("CapitalSMS_", "").Replace("MainMenu_", "").Replace("ShinyohMenu_", "");
            }
            catch { }
            return version;
        }

        protected void Timer1_Tick(object sender, EventArgs e)
        {

            //();
            // btnDisplayLog.ServerClick += ShowAllLog;
            //FlgOn(true, "Compilation processing, Please wait . . .", System.Drawing.Color.Red);
            //loader.Visible = true;

            //Page.Response.Redirect();
            // UpdatePanel5.Update();
            ShowLog();
            SetLog();
            //Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "Script1", "<script>document.getElementById(\"btnDisplayLog\").click()</script> ");
        }
        protected void mainmenuDown(Object sender, EventArgs e)
        {
            // Server.MapPath("~") + @"capital20211015\setup.exe";
            Response.ContentType = "application/octet-stream";
            Response.AppendHeader("Content-Disposition", "attachment; filename=setup.exe");
            Response.TransmitFile(Server.MapPath("~") + @"SMS-Globe\setup.exe");
            Response.End();
        }
        protected void capitalDown(Object sender, EventArgs e)
        {
           // Server.MapPath("~") + @"capital20211015\setup.exe";
            Response.ContentType = "application/octet-stream";
            Response.AppendHeader("Content-Disposition", "attachment; filename=setup.exe");
            Response.TransmitFile(Server.MapPath("~") + @"capital20211015\setup.exe");
            Response.End();
        }
        protected void haspoDown(Object sender, EventArgs e)
        {
            // Server.MapPath("~") + @"capital20211015\setup.exe";
            Response.ContentType = "application/octet-stream";
            Response.AppendHeader("Content-Disposition", "attachment; filename=setup.exe");
            Response.TransmitFile(Server.MapPath("~") + @"haspo20211015\setup.exe");
            Response.End();
        }
        protected void tennicDown(Object sender, EventArgs e)
        {
            // Server.MapPath("~") + @"capital20211015\setup.exe";
            Response.ContentType = "application/octet-stream";
            Response.AppendHeader("Content-Disposition", "attachment; filename=setup.exe");
            Response.TransmitFile(Server.MapPath("~") + @"tennic20211015\setup.exe");
            Response.End();
        }
        protected void shinyohDown(Object sender, EventArgs e)
        {
            // Server.MapPath("~") + @"capital20211015\setup.exe";
            Response.ContentType = "application/octet-stream";
            Response.AppendHeader("Content-Disposition", "attachment; filename=setup.exe");
            Response.TransmitFile(Server.MapPath("~") + @"Shinyoh-Globe\setup.exe");
            Response.End();
        }
        protected string GetString(string fp)
        {
            try
            {
                return Encoding.GetEncoding("Shift_Jis").GetString(Encoding.GetEncoding("Shift_Jis").GetBytes(fp)).Replace(Environment.NewLine, "<br>" + Environment.NewLine);
            }
            catch
            {
                
            }
            return "waiting . . . ";
        }
        protected void UpdateClick(object sender, EventArgs e)
        {

        }
        protected void Trigger1(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtPass1.Value))
            {
                //ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "openModal();", true);
                Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "Script1", "<script>alert('Please fill the secret password.')</script> ");
            }
            else
            {
                if (txtPass1.Value == svrpst1)
                {
                    SetLog(false, false, true);
                }
                else
                {
                    //ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "openModal();", true);
                    Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "Script1", "<script>alert('Please fill the correct secret password.')</script> ");
                }
            }
        }
        protected void Trigger2(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtPass2.Value))
            {
                //ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "openModal();", true);
                Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "Script1", "<script>alert('Please fill the secret password.')</script> ");
            }
            else
            {
                if (txtPass2.Value == svrpst2)
                {
                    SetLog(false, false, true);
                }
                else
                {
                    //ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "openModal();", true);
                    Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "Script1", "<script>alert('Please fill the correct secret password.')</script> ");
                }
            }
        }
        protected void Trigger3(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtPass3.Value))
            {
                //ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "openModal();", true);
                Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "Script1", "<script>alert('Please fill the secret password.')</script> ");
            }
            else
            {
                if (txtPass3.Value == svrpst3)
                {
                    SetLog(false, false, true);
                }
                else
                {
                    //ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "openModal();", true);
                    Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "Script1", "<script>alert('Please fill the correct secret password.')</script> ");
                }
            }
        }
        protected void Trigger4(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtPass4.Value))
            {
                //ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "openModal();", true);
                Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "Script1", "<script>alert('Please fill the secret password.')</script> ");
            }
            else
            {
                if (txtPass4.Value == svrpst4)
                {
                    SetLog(false, false, true);
                }
                else
                {
                    //ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "openModal();", true);
                    Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "Script1", "<script>alert('Please fill the correct secret password.')</script> ");
                }
            }
        }
        protected void Trigger5(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtPass5.Value))
            {
                //ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "openModal();", true);
                Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "Script1", "<script>alert('Please fill the secret password.')</script> ");
            }
            else
            {
                if (txtPass5.Value == svrpst5)
                {
                    SetLog(false, false, true);
                }
                else
                {
                    //ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "openModal();", true);
                    Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "Script1", "<script>alert('Please fill the correct secret password.')</script> ");
                }
            }
        }
        protected void ShowAllLog(object sender, EventArgs e)
        {
            if (sl_Project.Value.Contains("Shinyoh"))
            {
                SetDefaultValueShinyoh();
            }
            else
            {
                SetDefaultValueSMS();
            }
            //sl_Project.Value 
            SetLog(true);
        }
        protected void FlgOn(bool flg, string txt, System.Drawing.Color col)
        {
            if (System.Drawing.Color.Green == col)
            {
                loader.Visible = false;
            }
            else
            {
                loader.Visible = true;
            }
            status.Visible = flg;
            status.InnerText = txt;
            status.Style.Add(HtmlTextWriterStyle.Color, col.Name);
        }
        protected void RunBatch(string pth)
        {
            try
            {
                using (TaskService ts = new TaskService())
                {
                    if (!pth.Contains("Shin"))
                    {//‪C:\GetLatestVersion\SP_Execution\SMS_GetLatest(GitHub)_JP.bat
                     // Process.Start(@"‪C:\GetLatestVersion\SP_Execution\SMS_GetLatest(GitHub)_JP.bat");
                        var task = ts.GetTask("SMS");
                        task.Run();
                    }
                    else
                    {
                        Process.Start(@"C:\GetLatestVersion_Shinyoh\Shinbatch.bat");

                        ////var task = ts.GetTask("Shinyoh");
                        ////task.Run();
                    }
                }
            }
            catch
            {
                Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "Script1", "<script>alert('Cann't Run Batch . . . ')</script> ");
            }

        }
        protected void Runtext(object sender, EventArgs e)
        {
           // Process.Start(@"C:\GetLatestVersion\SMS_GetLatest(GitHub)_123.bat");
        }
        protected void SetLog(bool IsLogClick = false, bool IsPageLoad = false, bool IsTrigger=false)
        {
            if (CheckPathError())
            {
                compiledLog.InnerHtml = sqlLog.InnerHtml = "No Error * * *";
                try
                {
                    if (IsTrigger)
                    {
                        RunBatch(bthPath.Value);
                        System.Threading.Thread.Sleep(3000);
                    }
                
                    var pth = stPath.Value;//@"D:\Runner\Flg.log";
                        string[] text = System.IO.File.ReadAllLines(pth);
                        var first = text.First();
                        if (first == "IsRunning=Yes")
                        {
                            FlgOn(true, "コンパイル処理、お待ちください", System.Drawing.Color.Red);
                            if (!IsPageLoad)
                                compiledLog.InnerHtml = sqlLog.InnerHtml = "待っている . . .";
                        }
                        else
                        {
                     
                            FlgOn(true, "コンパイルは正常に完了しました。", System.Drawing.Color.Green);
                            ShowLog();
                        
                        }
                    //}
                }
                catch (Exception ex)
                {
                    var mse = ex.Message.ToString().Replace("'","").Replace("\\","\\\\");
                    mse = mse.Replace("path", "remote path");//.Replace("_", " ");
                    
                        Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "Script1", "<script>alert(' "+mse+ Environment.NewLine + ex.StackTrace+ "')</script> ");
                }
            }
            else
            {
                Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "Script1", "<script>alert('Please fill the correct path of execution destinations.')</script> ");
                // Show Error
            }
        }
        protected void ShowLog()
        {
            var prj = "";
            if (sl_Project.Value == "SMS-Capital")
            {
                prj = "";
                SMSLog(prj);
            }
            else if (sl_Project.Value == "SMS-Haspo")
            {
                prj = "Haspo";
                SMSLog(prj);
            }
            else if (sl_Project.Value == "SMS-Tennic")
            {
                prj = "Tennic";
                SMSLog(prj);
            }
            else if (sl_Project.Value.Contains("MM"))
            {
                try
                {
                    prj = @"C:\GetLatestVersion_Shinyoh\SP_Execution(" + DateTime.Now.ToString("yyyyMMdd") + ")_DEV_M.log";
                    Shinyoh();
                    string exeAr = "";
                    var ln = System.IO.File.ReadAllLines(prj, Encoding.GetEncoding("Shift_Jis"));
                    foreach (var l in ln)
                    {
                        if (!l.Contains("OpenQA") && !l.Contains("certificate") && !l.Contains("Menu") && !l.Contains("Prerequest"))
                        exeAr += l + Environment.NewLine;
                    }
                    if (!string.IsNullOrEmpty(exeAr.Trim()))
                    {
                        sqlLog.InnerHtml = GetString(exeAr); //Encoding.GetEncoding("Shift_Jis").GetString(Encoding.GetEncoding("Shift_Jis").GetBytes(exeAr));
                    }
                    else
                        sqlLog.InnerHtml = "No Error * * *";
                }
                catch
                {
                    sqlLog.InnerHtml = "Waiting * * *";
                }
            }
            else if (sl_Project.Value.Contains("JP"))
            {
                try { 
                prj = @"C:\GetLatestVersion_Shinyoh\SP_Execution(" + DateTime.Now.ToString("yyyyMMdd") + ")_DEV_J.log";
                Shinyoh();
                string exeAr = "";
                var ln = System.IO.File.ReadAllLines(prj, Encoding.GetEncoding("Shift_Jis"));
                foreach (var l in ln)
                        if (!l.Contains("OpenQA") && !l.Contains("certificate") && !l.Contains("Menu")&& !l.Contains("Prerequest") )
                            exeAr += l + Environment.NewLine;
                if (!string.IsNullOrEmpty(exeAr.Trim()))
                    sqlLog.InnerHtml = GetString(exeAr); //Encoding.GetEncoding("Shift_Jis").GetString(Encoding.GetEncoding("Shift_Jis").GetBytes(exeAr));
                else
                    sqlLog.InnerHtml = "No Error * * *";
                }
                catch
                {
                    sqlLog.InnerHtml = "Waiting * * *";
                }
            }
        }
        protected void Shinyoh()
        {
            try
            {
                var com = cmpPath.Value;
                string comAr = "";
                var ln = System.IO.File.ReadAllLines(com, Encoding.GetEncoding("Shift_Jis"));
                foreach (var l in ln)
                    if (!l.Contains("OpenQA") && !l.Contains("certificate") && !l.Contains("Menu") && !l.Contains("Prerequest"))

                        comAr += l + Environment.NewLine;
                if (!string.IsNullOrEmpty(comAr))
                    compiledLog.InnerHtml = GetString(comAr);// Encoding.GetEncoding("Shift_Jis").GetString(Encoding.GetEncoding("Shift_Jis").GetBytes(comAr));
                else
                    compiledLog.InnerHtml = "No Error * * *";
            }
            catch
            {
                compiledLog.InnerHtml = "Waiting * * *";
            }
        }
        protected void SMSLog(string prj)
        {
            //1Log
            Shinyoh();
            //var com = cmpPath.Value;
            //string comAr = "";
            //var ln = System.IO.File.ReadAllLines(com);
            //foreach (var l in ln)
            //    comAr += l + Environment.NewLine;
            //if (!string.IsNullOrEmpty(comAr))
            //    compiledLog.InnerText = Encoding.UTF8.GetString(Encoding.UTF8.GetBytes(comAr));
            //else
            //    compiledLog.InnerText = "No Error * * *";
            //2Log
            try
            {
                var exe = System.IO.Path.GetDirectoryName(execuPath.Value) + @"\SP_Execution" + prj + "(" + DateTime.Now.ToString("yyyyMMdd") + ").log";// @"D:\Runner\SP_Execution(" + DateTime.Now.ToString("yyyyMMdd") + ").log";
                string exeAr = "";
                var ln = System.IO.File.ReadAllLines(exe, Encoding.GetEncoding("Shift_Jis"));
                foreach (var l in ln)
                    if (!l.Contains("OpenQA") && !l.Contains("certificate") && !l.Contains("Menu") && !l.Contains("Prerequest"))

                        exeAr += l + Environment.NewLine;
                if (!string.IsNullOrEmpty(exeAr))
                    sqlLog.InnerHtml = GetString(exeAr); //Encoding.GetEncoding("Shift_Jis").GetString(Encoding.GetEncoding("Shift_Jis").GetBytes(exeAr));
                else
                    sqlLog.InnerHtml = "No Error * * *";
            }
            catch
            {
                sqlLog.InnerHtml = "Waiting * * *";
            }
        }
        protected void CheckStatus()
        {
            var pth = @"D:\Runner\Errors.txt";
           // var pth = bthPath.Value;
            string[] text = System.IO.File.ReadAllLines(pth, Encoding.GetEncoding("Shift_Jis"));
            var first = text.First();
            compiledLog.InnerHtml = first;
            var last = text.Last();
            sqlLog.InnerHtml = last;
        }
        protected bool CheckPathError()
        {
            if (String.IsNullOrEmpty(bthPath.Value))
            {
                return false;
            }
            if (String.IsNullOrEmpty(cmpPath.Value))
            {
                return false;
            }
            if (String.IsNullOrEmpty(execuPath.Value))
            {
                return false;
            }
            if (String.IsNullOrEmpty(stPath.Value))
            {
                return false;
            }
            return true;
        }
        protected void SetDefaultValueSMS()
        {
            bthPath.Value = @"C:\GetLatestVersion\SMS_GetLatest(GitHub)_JP.bat";     //C:\GetLatestVersion\SMS_GetLatest(GitHub)_JP.bat
            cmpPath.Value = @"C:\GetLatestVersion\errors.log";     //C:\GetLatestVersion\errors.log
            execuPath.Value = @"C:\GetLatestVersion\SP_Execution.log";   //C:\GetLatestVersion\SP_Execution.log
            stPath.Value = @"C:\GetLatestVersion\Flg.log";      //C:\GetLatestVersion\Flg.log
        }
        protected void SetDefaultValueShinyoh()
        {
            bthPath.Value = @"C:\GetLatestVersion_Shinyoh\Shinbatch.bat";     //C:\GetLatestVersion\SMS_GetLatest(GitHub)_JP.bat
            cmpPath.Value = @"C:\GetLatestVersion_Shinyoh\errors.log";     //C:\GetLatestVersion\errors.log
            execuPath.Value = @"C:\GetLatestVersion_Shinyoh\SP_Execution.log";   //C:\GetLatestVersion\SP_Execution.log
            stPath.Value = @"C:\GetLatestVersion_Shinyoh\Flg.log";      //C:\GetLatestVersion\Flg.log
        }

        [System.Web.Services.WebMethod]
        public static void GetDetails(string Id)
        {
            
        }

            //        using (TaskService tasksrvc = new TaskService(@"\\" + servername, username, domain, password, true))
            //{       
            //    Task task = tasksrvc.FindTask(taskSchedulerName);
            //    task.Run();
            //}   
            //Trigger
        }
}