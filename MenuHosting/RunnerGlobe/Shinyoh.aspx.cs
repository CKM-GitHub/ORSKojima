using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.IO;

namespace MenuHosting.RunnerGlobe {
    public partial class Shinyoh : System.Web.UI.Page {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    try
                    {
                        var qId = Request.QueryString["dltpe"].ToString();
                        if (qId == "shinyoh")
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

                    shinyoh.InnerText = GetLast(Server.MapPath("~") + @"Shinyoh-Globe\Application Files");
                }
                catch
                {

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
                version = dr.Last().Split('\\').Last().Replace("ShinyohMenu_", "");
            }
            catch { }
            return version;
        }
    }
}