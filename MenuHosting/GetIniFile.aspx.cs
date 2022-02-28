using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;
namespace MenuHosting
{
    public partial class GetIniFile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //  Request.para
            try
            {
                if (DecodeFrom64(Request.QueryString["Value"]) == (DateTime.Now.Day.ToString()) && !String.IsNullOrEmpty (Request.QueryString["id"].ToString()))
                {
                    var p = File.ReadAllLines(HttpContext.Current.Server.MapPath("CKM.ini"));
                    var value = Request.QueryString["id"].ToString();
                    if (value == "CKM")
                    {
                        Response.WriteFile(HttpContext.Current.Server.MapPath("CKM.ini"));
                    }
                    else if (value == "runAdmin")
                    {
                        Response.WriteFile(HttpContext.Current.Server.MapPath("runAdmin.ps1"));

                    }
                    else if (value == "SpecialFile")
                    {
                        Response.WriteFile(HttpContext.Current.Server.MapPath("SpecialFile.ps1")); 
                    }
                    else if (value == "Shinyoh")
                    {
                        Response.WriteFile(HttpContext.Current.Server.MapPath("DBConfig.ini"));
                    }
                }
            }
            catch { }
        }
        static public string EncodeTo64(string toEncode)

        {

            byte[] toEncodeAsBytes = System.Text.ASCIIEncoding.ASCII.GetBytes(toEncode);

            string returnValue= System.Convert.ToBase64String(toEncodeAsBytes);

            return returnValue;

        }
        static public string DecodeFrom64(string encodedData)

        {

            byte[] encodedDataAsBytes = System.Convert.FromBase64String(encodedData.Replace("_","="));

            string returnValue =System.Text.ASCIIEncoding.ASCII.GetString(encodedDataAsBytes);

            return returnValue;

        }
    }
}