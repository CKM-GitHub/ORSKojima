using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.IO;

namespace MenuHosting.RunnerGlobe {
    public partial class Haspo : System.Web.UI.Page {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    try
                    {
                        var qId = Request.QueryString["dltpe"].ToString();
                        if (qId == "hasposms")
                        {
                            hdn_colm.Value = "3";
                        }
                        else
                            Response.Redirect("http://203.137.92.20/RunnerGlobe/error404.aspx", false);
                    }
                    catch
                    {
                        Response.Redirect("http://203.137.92.20/RunnerGlobe/error404.aspx", false);
                    }

                    lasthaspo.InnerText = GetLast(Server.MapPath("~") + @"haspo20211015\Application Files");

                }
                catch
                {

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
        protected void haspoDown()
        {
            try
            {
                // Server.MapPath("~") + @"capital20211015\setup.exe";
                Response.ContentType = "application/octet-stream";
                Response.AppendHeader("Content-Disposition", "attachment; filename=setup.exe");
                Response.TransmitFile(Server.MapPath("~") + @"haspo20211015\setup.exe");
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
                version = dr.Last().Split('\\').Last().Replace("HaspoSMS_", "");
            }
            catch { }
            return version;
        }
    }
}