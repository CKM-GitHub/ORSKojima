using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MenuHosting.RunnerGlobe
{
    public partial class DownloadFile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //lastcapital.InnerText = "ptk";

            if (!IsPostBack)
            {
                try
                {
                    try
                    {
                        var qId = Request.QueryString["dltpe"].ToString();
                        if (qId == "mainmenu")
                        {
                            hdn_colm.Value = "1";
                        }
                        else if (qId == "capitalsms")
                        {
                            hdn_colm.Value = "2";
                        }
                        else if (qId == "hasposms")
                        {
                            hdn_colm.Value = "3";
                        }
                        else if (qId == "tennicsms")
                        {
                            hdn_colm.Value = "4";
                        }
                        else if (qId == "shinyoh")
                        {
                            hdn_colm.Value = "5";
                        }
                        else
                            Response.Redirect("http://203.137.92.20/RunnerGlobe/error404.aspx", false);
                    }
                    catch
                    {
                        Response.Redirect("http://203.137.92.20/RunnerGlobe/error404.aspx", false);
                    }

                    mainmenu.InnerText = GetLast(Server.MapPath("~") + @"SMS-Globe\Application Files");
                    lastcapital.InnerText = GetLast(Server.MapPath("~") + @"capital20211015\Application Files");
                    lasthaspo.InnerText = GetLast(Server.MapPath("~") + @"haspo20211015\Application Files");
                    lasttennic.InnerText = GetLast(Server.MapPath("~") + @"tennic20211015\Application Files");
                    shinyoh.InnerText = GetLast(Server.MapPath("~") + @"Shinyoh-Globe\Application Files");
                }
                catch
                {

                }
            }
        }
        protected void Trigger1(object sender, EventArgs e)
        {

            string svrpst1 = ConfigurationManager.AppSettings["pst1"].ToString();

            if (string.IsNullOrWhiteSpace(txtPass1.Value))
            {
                Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "Script1", "<script>alert('Please fill the secret password.')</script> ");
            }
            else
            {

                if (txtPass1.Value == svrpst1)
                {
                    var f1 = hdn_val1.Value;

                    if (f1.Contains("mainmenu"))
                    {
                        mainmenuDown();
                    }
                }
                else
                {
                    Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "Script1", "<script>alert('Please fill the correct secret password.')</script> ");
                }
            }

        }
        protected void Trigger2(object sender, EventArgs e)
        {

            string svrpst2 = ConfigurationManager.AppSettings["pst2"].ToString();

            if (string.IsNullOrWhiteSpace(txtPass2.Value))
            {
                Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "Script1", "<script>alert('Please fill the secret password.')</script> ");
            }
            else
            {

                if (txtPass2.Value == svrpst2)
                {
                    var f2 = hdn_val2.Value;

                    if (f2.Contains("capital"))
                    {
                        capitalDown();
                    }
                }
                else
                {
                    Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "Script1", "<script>alert('Please fill the correct secret password.')</script> ");
                }
            }

        }
        protected void Trigger3(object sender, EventArgs e)
        {

            string svrpst3 = ConfigurationManager.AppSettings["pst3"].ToString();

            if (string.IsNullOrWhiteSpace(txtPass3.Value))
            {
                Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "Script1", "<script>alert('Please fill the secret password.')</script> ");
            }
            else
            {

                if (txtPass3.Value == svrpst3)
                {
                    var f3 = hdn_val3.Value;

                    if (f3.Contains("haspo"))
                    {
                        haspoDown();
                    }
                }
                else
                {
                    Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "Script1", "<script>alert('Please fill the correct secret password.')</script> ");
                }
            }

        }
        protected void Trigger4(object sender, EventArgs e)
        {

            string svrpst4 = ConfigurationManager.AppSettings["pst4"].ToString();

            if (string.IsNullOrWhiteSpace(txtPass4.Value))
            {
                Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "Script1", "<script>alert('Please fill the secret password.')</script> ");
            }
            else
            {

                if (txtPass4.Value == svrpst4)
                {
                    var f4 = hdn_val4.Value;

                    if (f4.Contains("tennic"))
                    {
                        tennicDown();
                    }
                }
                else
                {
                    Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "Script1", "<script>alert('Please fill the correct secret password.')</script> ");
                }
            }

        }
        protected void Trigger5(object sender, EventArgs e)
        {

            string svrpst5 = ConfigurationManager.AppSettings["pst5"].ToString();

            if (string.IsNullOrWhiteSpace(txtPass5.Value))
            {
                Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "Script1", "<script>alert('Please fill the secret password.')</script> ");
            }
            else
            {

                if (txtPass5.Value == svrpst5)
                {
                    var f5 = hdn_val5.Value;

                    if (f5.Contains("shinyoh"))
                    {
                        shinyohDown();
                    }
                }
                else
                {
                    Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "Script1", "<script>alert('Please fill the correct secret password.')</script> ");
                }
            }

        }
        protected void mainmenuDown()
        {
            try
            {
                // Server.MapPath("~") + @"capital20211015\setup.exe";
                Response.ContentType = "application/octet-stream";
                Response.AppendHeader("Content-Disposition", "attachment; filename=setup.exe");
                Response.TransmitFile(Server.MapPath("~") + @"SMS-Globe\setup.exe");
                Response.End();
            }
            catch { }
        }
        protected void capitalDown( )
        {
            try { 
            // Server.MapPath("~") + @"capital20211015\setup.exe";
            Response.ContentType = "application/octet-stream";
            Response.AppendHeader("Content-Disposition", "attachment; filename=setup.exe");
            Response.TransmitFile(Server.MapPath("~") + @"capital20211015\setup.exe");
            Response.End();
            }
            catch { }
        }
        protected void haspoDown( )
        {
            try { 
            // Server.MapPath("~") + @"capital20211015\setup.exe";
            Response.ContentType = "application/octet-stream";
            Response.AppendHeader("Content-Disposition", "attachment; filename=setup.exe");
            Response.TransmitFile(Server.MapPath("~") + @"haspo20211015\setup.exe");
            Response.End();
            }
            catch { }
        }
        protected void tennicDown( )
        {
            // Server.MapPath("~") + @"capital20211015\setup.exe";
            try
            {
                Response.ContentType = "application/octet-stream";
                Response.AppendHeader("Content-Disposition", "attachment; filename=setup.exe");
                Response.TransmitFile(Server.MapPath("~") + @"tennic20211015\setup.exe");
                Response.End();
            }
            catch { }
        }
        protected void shinyohDown()
        {
            // Server.MapPath("~") + @"capital20211015\setup.exe";
            try
            {
                Response.ContentType = "application/octet-stream";
                Response.AppendHeader("Content-Disposition", "attachment; filename=setup.exe");
                Response.TransmitFile(Server.MapPath("~") + @"Shinyoh-Globe\setup.exe");
                Response.End();
            }
            catch { }
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
    }
}