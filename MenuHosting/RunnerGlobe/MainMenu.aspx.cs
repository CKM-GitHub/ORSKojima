using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.IO;

namespace MenuHosting.RunnerGlobe {
    public partial class MainMenu : System.Web.UI.Page {
        protected void Page_Load(object sender, EventArgs e)
        {
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
                        else
                            Response.Redirect("http://203.137.92.20/RunnerGlobe/error404.aspx", false);
                    }
                    catch
                    {
                        Response.Redirect("http://203.137.92.20/RunnerGlobe/error404.aspx", false);
                    }

                    mainmenu.InnerText = GetLast(Server.MapPath("~") + @"SMS-Globe\Application Files");

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
        protected string GetLast(string str)
        {
            var version = "";
            try
            {
                string[] dr = System.IO.Directory.GetDirectories(str);
                Array.Sort(dr);
                version = dr.Last().Split('\\').Last().Replace("MainMenu_", "");
            }
            catch { }
            return version;
        }
    }
}