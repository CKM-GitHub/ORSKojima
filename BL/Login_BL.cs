using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Entity;
using DL;
using System.Data;
using System.Deployment;
using System.Diagnostics;
using EPSON_TM30;
using System.Data.SqlClient;
using System.IO;

namespace BL
{
    public class Login_BL : Base_BL
    {
        /// <summary>
        /// INIファイル名
        /// </summary>
        /// 
        private const string IniFileName = "ORS.ini";
        //  public static bool Islocalized =false;
        M_Staff_DL msdl;
        //M_Store_DL mstoredl;
        Menu_DL mdl;
        public const bool isd = false;
        public static bool Islocalized = false;
        public static string Ver = "";
        public static string SyncPath = "";
        public static string FtpPath = "";
        public static string ID = "";
        public static string IP = "";
        public static string Password = "";
        /// <summary>
        /// constructor
        /// </summary>
        public Login_BL()
        {
            msdl = new M_Staff_DL();
            //mstoredl = new M_Store_DL();
            mdl = new Menu_DL();
        }
        
        public DataTable CheckDefault(string mse,string SCD)
        {
            return mdl.CheckDefault(mse,SCD);
        }
        public bool GetState
        {
            get { return Debugger.IsAttached; }
        }
        // MH_Staff_LoginSelect
        public string StorePrinterName
        {
            get { return Base_DL.iniEntity.StorePrinterName; }
        }
        //Check_RegisteredMenu
        public DataTable Check_RegisteredMenu(M_Staff_Entity mse)
        {
            return msdl.Check_RegisteredMenu(mse);
        }
        public DataTable MH_Staff_LoginSelect(M_Staff_Entity mse)
        {
            return msdl.MH_Staff_LoginSelect(mse);
        }
        public M_Staff_Entity M_Staff_LoginSelect(M_Staff_Entity mse)
        {
            DataTable dtStaff = msdl.M_Staff_LoginSelect(mse);
            if (dtStaff.Rows.Count > 0)
            {
                mse.StaffName = dtStaff.Rows[0]["StaffName"].ToString();
                mse.StoreCD = dtStaff.Rows[0]["StoreCD"].ToString();
                mse.StaffKana = dtStaff.Rows[0]["StaffKana"].ToString();
                mse.BMNCD = dtStaff.Rows[0]["BMNCD"].ToString();
                mse.MenuCD = dtStaff.Rows[0]["MenuCD"].ToString();
                mse.KengenCD = dtStaff.Rows[0]["AuthorizationsCD"].ToString();
                mse.StoreAuthorizationsCD = dtStaff.Rows[0]["StoreAuthorizationsCD"].ToString();
                mse.PositionCD = dtStaff.Rows[0]["PositionCD"].ToString();

            }
            return mse;
        }

        /// <summary>
        /// 共通処理　Operator 確認
        /// </summary>
        /// <param name="mse"></param>
        /// <returns></returns>
        public M_Staff_Entity M_Staff_InitSelect(M_Staff_Entity mse)
        {
            DataTable dt = msdl.M_Staff_InitSelect(mse);
            if (dt.Rows.Count > 0)
            {
                mse.StaffName = dt.Rows[0]["User_Name"].ToString();
                mse.Login_ID= dt.Rows[0]["Login_ID"].ToString();
                mse.SysDate = dt.Rows[0]["sysDate"].ToString();
                //mse.StoreCD = dt.Rows[0]["StoreCD"].ToString();
                //Base_DL.iniEntity.DatabaseDate = mse.SysDate;
                //mse.StoreName = dt.Rows[0]["StoreName"].ToString(); ;
            }

            return mse;
        }

        //M_Store_InitSelect
        public M_Staff_Entity M_Store_InitSelect(M_Staff_Entity mpe)
        {
           // M_Program_DL dl = new M_Program_DL();
            DataTable dt = msdl.M_Store_InitSelect(mpe);
            if (dt.Rows.Count > 0)
            {
                mpe.StoreName = dt.Rows[0]["StoreName"].ToString();
                //mpe.Type = dt.Rows[0]["Type"].ToString();

           
            }
            return mpe;
        }
        /// <summary>
        /// For Default Souko Bind
        /// </summary>
        /// <param name="mse"></param>
        /// <returns></returns>
        public M_Staff_Entity M_Souko_InitSelect(M_Staff_Entity mse)
        {
            DataTable dt = msdl.M_Souko_InitSelect(mse);
            if (dt.Rows.Count > 0)
            {
                mse.SysDate = dt.Rows[0]["sysDate"].ToString();
                mse.SoukoCD = dt.Rows[0]["SoukoCD"].ToString();
                Base_DL.iniEntity.DatabaseDate = mse.SysDate;
            }

            return mse;
        }

        //public M_Store_Entity M_Store_InitSelect(M_Staff_Entity mse, M_Store_Entity mste)
        //{
        //    DataTable dt = mstoredl.M_Store_InitSelect(mse);
        //    if (dt.Rows.Count > 0)
        //    {
        //        mste.StoreName = dt.Rows[0]["StoreName"].ToString();
        //        mste.SysDate = dt.Rows[0]["sysDate"].ToString();
        //        mste.StoreCD = dt.Rows[0]["StoreCD"].ToString();
        //        Base_DL.iniEntity.DatabaseDate = mste.SysDate;
        //    }

        //    return mste;
        //}

        /// <summary>
        /// 共通処理　プログラム
        /// </summary>
        /// <param name="mpe"></param>
        /// <returns></returns>
        public bool M_Program_InitSelect(M_Program_Entity mpe)
        {
            M_Program_DL dl = new M_Program_DL();
            DataTable dt = dl.M_Program_Select(mpe);
            if (dt.Rows.Count > 0)
            {
                mpe.ProgramName = dt.Rows[0]["ProgramName"].ToString();
                mpe.Type = dt.Rows[0]["Type"].ToString();

                return true;
            }

            else
                return false;
        }
        /// <summary>
        /// INIファイルより情報取得
        /// </summary>
        /// <returns></returns>
        public bool ReadConfig()
        {
            try
            {
                this.GetInformationOfIniFile();
            }
            catch
            {
                return false;
            }
            return true;
        }
        public void GetInformationOfIniFile()
        {
            var filePath = "";
            if (Debugger.IsAttached)
            {
                System.Uri u = new System.Uri(System.Reflection.Assembly.GetExecutingAssembly().CodeBase);
                filePath = (System.IO.Path.GetDirectoryName(u.LocalPath) + @"\" + "ORS.ini").Replace("\\KojimaMenu","");
            }
            else
            {
                filePath = @"C:\ORS\AppData\ORS.ini";
            }
            IniFile_DL idl = new IniFile_DL(filePath);
            Base_DL.iniEntity.DatabaseServer = idl.IniReadValue("Database", "ORS").Split(',')[0];
            Base_DL.iniEntity.DatabaseName = idl.IniReadValue("Database", "ORS").Split(',')[1];
            Base_DL.iniEntity.DatabaseLoginID = idl.IniReadValue("Database", "ORS").Split(',')[2];
            Base_DL.iniEntity.DatabasePassword = idl.IniReadValue("Database", "ORS").Split(',')[3];
            Base_DL.iniEntity.Login_Type = "ORS";
            SyncPath=  idl.IniReadValue("ServerAuthen", "ftp");
            ID = idl.IniReadValue("ServerAuthen", "ID");
            IP = idl.IniReadValue("ServerAuthen", "IP");
            Password = idl.IniReadValue("ServerAuthen", "Pass");

        }

        protected string GetMessages()
        {
            var get = getd();
            var str = "";
            str += get.Rows[0]["Char1"] == null ? "" : get.Rows[0]["Char1"].ToString().Trim() + "     ";
            str += get.Rows[0]["Char2"] == null ? "" : get.Rows[0]["Char2"].ToString().Trim() + "     ";
            str += get.Rows[0]["Char3"] == null ? "" : get.Rows[0]["Char3"].ToString().Trim() + "     ";
            str += get.Rows[0]["Char4"] == null ? "" : get.Rows[0]["Char4"].ToString().Trim() + "     ";
            str += get.Rows[0]["Char5"] == null ? "" : get.Rows[0]["Char5"].ToString().Trim();
            int txt = Encoding.GetEncoding(932).GetByteCount(str);
            if (txt > 200)
            {
                str = str.Substring(0, 200);
            }
            return str;
        }
        protected DataTable getd()
        {
            Base_DL bdl = new Base_DL();
            var dt = new DataTable();
            var con = bdl.GetConnection();
            //SqlConnection conn = con;
            con.Open();
            SqlCommand command = new SqlCommand("Select Char1, Char2, Char3, Char4,Char5 from [M_Multiporpose] where [Key]='1' and Id='326'", con);
            SqlDataAdapter adapter = new SqlDataAdapter(command);
            adapter.Fill(dt);
            con.Close();
            return dt;
        }
        public void Display_Service_Update(bool Opened)
        {
            var val = (Opened) ? "1" : "0";
            Base_DL bdl = new Base_DL();
            using (SqlConnection con = bdl.GetConnection())
            {
                con.Open();
                using (SqlCommand command = new SqlCommand("Update M_Multiporpose set Num1 = '" + val + "' where[Key] = '1' and Id = '326'", con))
                {
                    command.ExecuteNonQuery();
                }
                con.Close();
            }
        }
        public void Display_Service_Enabled(bool Enabled, string val = null)
        {
            var pth = "";
            if (val == null)
                pth = @"C:\\SMS\\AppData\Display_Service.exe";
            else
                pth = @"C:\\SMS\\AppData\\" + val;
            if (Enabled)
            {
                try
                {
                    //   Kill(Path.GetFileNameWithoutExtension(pth));
                }
                catch { }
                try
                {
                    //System.Diagnostics.ProcessStartInfo start = new System.Diagnostics.ProcessStartInfo(pth);
                    //start.FileName = pth;
                    //start.WindowStyle = System.Diagnostics.ProcessWindowStyle.Hidden;
                    // Process pc = new Process();

                    Process[] processCollection = Process.GetProcessesByName(Path.GetFileNameWithoutExtension(pth));
                    if (processCollection.Count() == 0)
                    {
                        // Process p = new Process();
                        System.Diagnostics.ProcessStartInfo start = new System.Diagnostics.ProcessStartInfo(pth);
                        start.FileName = pth;
                        start.UseShellExecute = true;
                        start.WindowStyle = System.Diagnostics.ProcessWindowStyle.Hidden;
                        start.CreateNoWindow = false;
                        //start.WindowStyle = ProcessWindowStyle.
                        //Process pc = new Process();
                        Process.Start(pth);
                    }
                }
                catch (Exception ex)
                {
                }
            }
            else
            {
                try
                {
                    Kill(Path.GetFileNameWithoutExtension(pth));
                }
                catch { }
            }
        }
        protected void Kill(string pth)
        {
            Process[] processCollection = Process.GetProcessesByName(pth.Replace(".exe", ""));
            foreach (Process p in processCollection)
            {
                p.Kill();
            }

            Process[] processCollections = Process.GetProcessesByName(pth + ".exe");
            foreach (Process p in processCollections)
            {
                p.Kill();
            }
        }
        public string Display_Service_Status()  // 0 not display / 1 Display
        {
            Base_DL bdl = new Base_DL();
            var dt = new DataTable();
            var con = bdl.GetConnection();
            //   
            //SqlConnection conn = con;
            con.Open();
            SqlCommand command = new SqlCommand("Select Num1 from [M_Multiporpose] where [Key]='1' and Id='326'", con);
            SqlDataAdapter adapter = new SqlDataAdapter(command);
            adapter.Fill(dt);
            con.Close();
            return dt.Rows.Count > 0 ? dt.Rows[0]["Num1"].ToString() : "0";
        }

        public string GetInformationOfIniFileByKey(string key)
        {
            // INIﾌｧｲﾙ取得
            // 実行モジュールと同一フォルダのファイルを取得
            string filePath = "";
            //System.Diagnostics.Debug 
            if (Debugger.IsAttached)
            {
                System.Uri u = new System.Uri(System.Reflection.Assembly.GetExecutingAssembly().CodeBase);
                filePath = System.IO.Path.GetDirectoryName(u.LocalPath) + @"\" + IniFileName;
            }
            else
            {
                filePath = @"C:\\ORS\\AppData\\ORS.ini";
            }
            IniFile_DL idl = new IniFile_DL(filePath);
            return idl.IniReadValue("FilePath", key);
        }

        /// <summary>
        ///     ''' ホスト名を取得
        ///     ''' </summary>
        ///     ''' <returns>ローカルホスト名</returns>
        ///     ''' <remarks></remarks>
        public static string GetHostName()
        {
            string Ret = "";

            Ret = System.Net.Dns.GetHostName();

            return Ret;
        }
    }
}
