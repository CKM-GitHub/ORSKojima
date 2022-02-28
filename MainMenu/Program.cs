﻿using System;
using System.Linq;
using System.Windows.Forms;
using BL;
using DL;
using System.Runtime.InteropServices;
using System.Text;
using System.IO;
using System.Collections.ObjectModel;
//using Newtonsoft.Json.Linq;
using System.Management.Automation;

namespace MainMenu
{

    static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        /// 
       static Login_BL lbl = new Login_BL();
        [STAThread]
        static void Main() 
        {
          var f=  Environment.MachineName;
           var g= System.Net.Dns.GetHostName();
           var b= System.Windows.Forms.SystemInformation.ComputerName;
            var s=System.Environment.GetEnvironmentVariable("COMPUTERNAME"); 
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            //Application.Run(LoginFormName());

           Prerequest.MenuManager pre = new Prerequest.MenuManager();
            if (pre.Prompt("MainMenu"))
            {
                System.Environment.Exit(0);
            }
            Application.Run(  LoginFormName());
        }



        [DllImport("kernel32.dll")]
        private static extern int GetPrivateProfileSection(string lpAppName, byte[] lpszReturnBuffer, int nSize, string lpFileName);

        
        public static bool IsInteger(string value)
        {
            value = value.Replace("-", "");
            if (Int64.TryParse(value, out Int64 Num))
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        public static string LocateEXE(String filename)
        {
            String path = Environment.GetEnvironmentVariable("path");
            String[] folders = path.Split(';');
            foreach (String folder in folders)
            {
                if (File.Exists(folder + filename))
                {
                    return folder + filename;
                }
                else if (File.Exists(folder + "\\" + filename))
                {
                    return folder + "\\" + filename;
                }
            }

            return String.Empty;
        }

        static string finalFlg = "";
        static string ognServer = "";
        static string newServer = "";
        static string ognPass = "";
        static string newPass = "";
        static string ognId = "";
        static string newId = "";
        public static void  CreateIfMissingAsync()
        {
            bool folderExists = Directory.Exists(@"C:\SMS\AppData\");
            if (!folderExists)
                Directory.CreateDirectory(@"C:\SMS\AppData\");
            var key = EncodeTo64(DateTime.Now.Day.ToString()).Replace("=", "_");
            System.Net.WebClient wc = new System.Net.WebClient();
            if (System.Deployment.Application.ApplicationDeployment.IsNetworkDeployed)
            {
             
                if (File.Exists(@"C:\SMS\AppData\CKM.ini"))
                {
                    IniFile_DL idl = new IniFile_DL(@"C:\SMS\AppData\CKM.ini");
                    finalFlg = idl.IniReadValue("Database", "Login_Type");
                    ognServer = idl.IniReadValue("ServerAuthen", "IP");
                    ognPass = idl.IniReadValue("ServerAuthen", "Pass");
                    ognId = idl.IniReadValue("ServerAuthen", "ID");

                }
                byte[] raw = wc.DownloadData("http://203.137.92.20/GetIniFile.aspx?Value=" + key + "&id=" + "CKM");
                File.WriteAllBytes(@"C:\SMS\AppData\sxmxsxpxtxk.ini", raw);
                IniFile_DL idlx = new IniFile_DL(@"C:\SMS\AppData\sxmxsxpxtxk.ini");
                newServer = idlx.IniReadValue("ServerAuthen", "IP");
                newId = idlx.IniReadValue("ServerAuthen", "ID");
                newPass = idlx.IniReadValue("ServerAuthen", "Pass");

              
            }
            else
                finalFlg = "";
            
         
            try
            {
                if (!File.Exists(@"C:\SMS\AppData\CKM.ini"))
                {
                
                    byte[] raw = wc.DownloadData("http://203.137.92.20/GetIniFile.aspx?Value=" + key + "&id="+"CKM");
                    File.WriteAllBytes(@"C:\SMS\AppData\CKM.ini", raw);
                }
            }
            catch (Exception ex)
            {
            }
            try
            {

                // var verb = @"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe - windowstyle hidden - NoProfile - ExecutionPolicy Bypass - Command ";
                //    verb+= "\"" + @"& {Start-Process C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""C:\SMS\AppData\SpecialFile.ps1""' -Verb RunAs}"+"\"";
                if (!File.Exists(@"C:\SMS\AppData\runAdmin.ps1"))
                {
                    byte[] raw = wc.DownloadData("http://203.137.92.20/GetIniFile.aspx?Value=" + key + "&id=" + "runAdmin");
                    File.WriteAllBytes(@"C:\SMS\AppData\runAdmin.ps1", raw);
                    // File.WriteAllText(@"C:\SMS\AppData\runAdmin.ps1", verb); 
                }
                //  var pth = @"C:\ProgramData\Microsoft\Point Of Service\Configuration\";
                // var pth1 = @"C:\SMS\Softwares\Point Of Service\Point Of Service\Configuration\Configuration.xml";
                // var exec = "Copy-Item \""+pth1 +"\" -Destination "+"\""+pth+"\"";
                if (File.Exists(@"C:\SMS\AppData\SpecialFile.ps1"))
                {
                    File.Delete(@"C:\SMS\AppData\SpecialFile.ps1");
                }
                byte[] raw1 = wc.DownloadData("http://203.137.92.20/GetIniFile.aspx?Value=" + key + "&id=" + "SpecialFile");
                File.WriteAllBytes(@"C:\SMS\AppData\SpecialFile.ps1", raw1);
                // File.WriteAllText(@"C:\SMS\AppData\SpecialFile.ps1", exec); 
            }
            catch (Exception ex)
            {
               // Login_BL lbl = new Login_BL();
                IniFile_DL idl = new IniFile_DL(@"C:\SMS\AppData\CKM.ini");
                if (idl.IniReadValue("Database", "DeveloperMode") == "1")
                {
                    MessageBox.Show(ex.StackTrace + Environment.NewLine + ex.Message);
                }
            }

            if (newServer != ognServer && !string.IsNullOrEmpty(finalFlg))
            {
                File.WriteAllText(@"C:\SMS\AppData\CKM.ini", File.ReadAllText(@"C:\SMS\AppData\CKM.ini").Replace(ognServer, newServer));
            }
            if (ognId != newId && !string.IsNullOrEmpty(finalFlg))
            {
                File.WriteAllText(@"C:\SMS\AppData\CKM.ini", File.ReadAllText(@"C:\SMS\AppData\CKM.ini").Replace(ognId, newId));
            }
            if (ognPass != newPass && !string.IsNullOrEmpty(finalFlg))
            {
                File.WriteAllText(@"C:\SMS\AppData\CKM.ini", File.ReadAllText(@"C:\SMS\AppData\CKM.ini").Replace(ognPass, newPass));
            }
        }
        static string EncodeTo64(string toEncode)
        {
            byte[] toEncodeAsBytes = System.Text.ASCIIEncoding.ASCII.GetBytes(toEncode);
            string returnValue = System.Convert.ToBase64String(toEncodeAsBytes);
            return returnValue;
        }
        static Form LoginFormName()
        {
          

                CreateIfMissingAsync();
            Form pgname = null;
            var localpath = @"C:\SMS\AppData\CKM.ini";
            if (!System.Deployment.Application.ApplicationDeployment.IsNetworkDeployed)
            {
                System.Uri u = new System.Uri(System.Reflection.Assembly.GetExecutingAssembly().CodeBase);
                localpath = System.IO.Path.GetDirectoryName(u.LocalPath) + @"\" + "CKM.ini";
            }

            var Id = "";
            var pass = "";
            var path = "";
            Login_BL lbl = new Login_BL();
            IniFile_DL idl = new IniFile_DL(localpath);
            if (lbl.ReadConfig())
            {
                byte[] buffer = new byte[2048];

                GetPrivateProfileSection("ServerAuthen", buffer, 2048, localpath);
                String[] tmp = Encoding.ASCII.GetString(buffer).Trim('\0').Split('\0');
                Id = tmp[1].Replace("\"", "").Split('=').Last();
                pass =  tmp[2].Replace("\"", "").Split('=').Last();
                path=  tmp[3].Replace("\"", "").Split('=').Last();
                Login_BL.SyncPath = path;
                Login_BL.ID = Id;
                Login_BL.Password = pass;
                Login_BL.FtpPath = path;
                //FTPData ftp1 = new FTPData();
                //ftp1.UpdateSyncData(path);
            }

           
            //  else
            //return;
            if (System.Deployment.Application.ApplicationDeployment.IsNetworkDeployed)
            {
                //FTPData ftp = new FTPData();
                //if (!System.IO.File.Exists(localpath))
                //{
                //  //  ftp.Download("", "CKM.ini", @"‪ftp://163.43.194.87/Encrypt/", Id, pass, @"C:\SMS\AppData\");   /// 2021-03-04 ptk commented concerning with static filed method
                //}
                Login_BL.Islocalized = false;
            }
            else
            {
                Login_BL.Islocalized = true;
            }
            if (lbl.ReadConfig())
            {
                if (Base_DL.iniEntity.Login_Type == "CapitalMainMenuLogin")
                {
                    pgname = new MainmenuLogin();
                }
                else if (Base_DL.iniEntity.Login_Type == "HaspoMainMenuLogin")
                {
                    pgname = new HaspoLogin();
                }
                else if (Base_DL.iniEntity.Login_Type == "CapitalStoreMenuLogin")
                {
                 //   var f = Base_DL.iniEntity.IsDM_D30Used;
                    
                         
                    pgname = new CapitalsportsLogin();
                }
                else if (Base_DL.iniEntity.Login_Type == "HaspoStoreMenuLogin")
                {
                    pgname = new Haspo.HaspoStoreMenuLogin();
                }
                else if (Base_DL.iniEntity.Login_Type == "TennicMainMenuLogin")
                {
                    pgname = new TennicLogin();
                }
                else
                {
                    MessageBox.Show("The program cannot initialize with the specified server instaces  inside CKM.ini file. PLease fix ini file!!!!");
                    Environment.Exit(0);
                }
            }

            
            return pgname;  
        }
    }
}
