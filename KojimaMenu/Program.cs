using BL;
using DL;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace KojimaMenu
{
    static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            //CreateIfMissingAsync();
            Application.Run(new MainMenu.KojimaLogin(true));
        }
        public static void CreateIfMissingAsync()
        {

            string dir = @"C:\ORS\AppData";
            string fullpath = @"C:\ORS\AppData\ORS.ini";
            try
            {
                System.Net.WebClient wc = new System.Net.WebClient();
                var key = EncodeTo64(DateTime.Now.Day.ToString()).Replace("=", "_");
                bool folderExists = Directory.Exists(dir);
                if (!folderExists)
                    Directory.CreateDirectory(dir);
                if (System.Deployment.Application.ApplicationDeployment.IsNetworkDeployed)
                {

                    if (!File.Exists(fullpath))
                    {
                        byte[] raw = wc.DownloadData("http://203.137.92.20/GetIniFile.aspx?Value=" + key + "&id=" + "kojima");
                        File.WriteAllBytes(fullpath, raw);
                    }
                }
            }
            catch (Exception ex)
            {
                File.WriteAllText(@"C:\ORS\AppData\kojima.log", ex.StackTrace.ToString());
            }
        }
        static string EncodeTo64(string toEncode)
        {
            byte[] toEncodeAsBytes = System.Text.ASCIIEncoding.ASCII.GetBytes(toEncode);
            string returnValue = System.Convert.ToBase64String(toEncodeAsBytes);
            return returnValue;
        }
    }
}
