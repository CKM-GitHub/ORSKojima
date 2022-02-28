using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.IO;

namespace MenuHosting.RunnerGlobe {
    public partial class CapitalSport : System.Web.UI.Page {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    try
                    {
                        var qId = Request.QueryString["dltpe"].ToString();
                        if (qId == "capitalsms")
                        {
                            hdn_colm.Value = "2";
                        }
                        else
                            Response.Redirect("http://203.137.92.20/RunnerGlobe/error404.aspx", false);
                    }
                    catch
                    {
                        Response.Redirect("http://203.137.92.20/RunnerGlobe/error404.aspx", false);
                    }

                    lastcapital.InnerText = GetLast(Server.MapPath("~") + @"capital20211015\Application Files");
                }
                catch
                {

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
                        if (main.Checked == true)
                            capitalDown();
                        else
                            capitalStoreDown();

                    }
                }
                else
                {
                    Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "Script1", "<script>alert('Please fill the correct secret password.')</script> ");
                }
            }

        }
        protected void capitalDown()
        {
            try
            {
                // Server.MapPath("~") + @"capital20211015\setup.exe";
                Response.ContentType = "application/octet-stream";
                Response.AppendHeader("Content-Disposition", "attachment; filename=setup.exe");
                Response.TransmitFile(Server.MapPath("~") + @"capital20211015\setup.exe");
                Response.End();
            }
            catch { }
        }
        protected void capitalStoreDown()
        {
            try
            {
                // Server.MapPath("~") + @"capital20211015\setup.exe";
                Response.ContentType = "application/octet-stream";
                Response.AppendHeader("Content-Disposition", "attachment; filename=setup.exe");
                Response.TransmitFile(Server.MapPath("~") + @"capitalStore20211015\setup.exe");
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
                version = dr.Last().Split('\\').Last().Replace("CapitalSMS_", "");
            }
            catch { }
            return version;
        }
    }
}