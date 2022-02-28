using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.IO;

namespace MenuHosting.RunnerGlobe {
    public partial class Tennic : System.Web.UI.Page {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    try
                    {
                        var qId = Request.QueryString["dltpe"].ToString();
                        if (qId == "tennicsms")
                        {
                            hdn_colm.Value = "4";
                        }
                        else
                            Response.Redirect("http://203.137.92.20/RunnerGlobe/error404.aspx", false);
                    }
                    catch
                    {
                        Response.Redirect("http://203.137.92.20/RunnerGlobe/error404.aspx", false);
                    }

                    lasttennic.InnerText = GetLast(Server.MapPath("~") + @"tennic20211015\Application Files");

                }
                catch
                {

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
        protected void tennicDown()
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
        protected string GetLast(string str)
        {
            var version = "";
            try
            {
                string[] dr = System.IO.Directory.GetDirectories(str);
                Array.Sort(dr);
                version = dr.Last().Split('\\').Last().Replace("TennicSMS_", "");
            }
            catch { }
            return version;
        }
    }
}