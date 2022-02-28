using System; 
using System.Data;
using System.Data.SqlClient; 
using System.Text; 
using Microsoft.PointOfService;
using System.Windows;
using System.Drawing;
using System.Management;
using Microsoft.PointOfService.Management;
using System.Runtime.InteropServices;
using System.Diagnostics;

namespace EPSON_TM30
{
    public class CashDrawerOpen 
    {
        
         public CashDrawer m_Drawer { get; set; } = null;
       /* PosExplorer posExplorer*/
        public CashDrawerOpen()
        {
            valueAll = "";
        }

        public string GetPropertyValue(PropertyData data)
        {
            if ((data == null) || (data.Value == null)) return "";
            return data.Value.ToString();
        }
        public void GetPort(string printername)
        {
            string query = "SELECT * FROM Win32_Printer WHERE Name='" + printername + "'";
            ManagementObjectSearcher searcher =
                new ManagementObjectSearcher(query);
            foreach (ManagementObject service in searcher.Get())
            {

            }
        }

        public string GetOnlineStatus(string pter)
        {
            ManagementObjectSearcher searcher = new ManagementObjectSearcher("SELECT * FROM Win32_Printer");

            foreach (ManagementObject printer in searcher.Get())
            {

                string printerName = printer["Name"].ToString().ToLower();
                if (printerName.Equals((pter).ToLower()))
                {

                    Console.WriteLine("Printer :" + printerName);
                    PrintProps(printer, "Caption");
                    PrintProps(printer, "ExtendedPrinterStatus");
                    PrintProps(printer, "Availability");
                    PrintProps(printer, "Default");
                    PrintProps(printer, "DetectedErrorState");//
                    PrintProps(printer, "ExtendedDetectedErrorState");//
                    PrintProps(printer, "ExtendedPrinterStatus");
                    PrintProps(printer, "LastErrorCode");
                    PrintProps(printer, "PrinterState");
                    PrintProps(printer, "PrinterStatus");
                    PrintProps(printer, "Status");
                    PrintProps(printer, "WorkOffline");
                    PrintProps(printer, "Local");
                    PrintProps(printer, "PortName");
                   // service.Properties["PortName"]
                    if ((printer["DetectedErrorState"].ToString() == "0") && (printer["ExtendedDetectedErrorState"].ToString() == "1"))
                    {
                        return "1";
                    }
                    else if ((printer["DetectedErrorState"].ToString() == "0") && (printer["ExtendedDetectedErrorState"].ToString() == "0"))
                    {
                        return "2";
                    }
                    else
                        return "3";
                }
                //else if ((printerName.ToLower().Contains("tm-m")))
                //{
                //    return "4";
                //}
            }
            return "";
        }
        string valueAll = "";
        void PrintProps(ManagementObject o, string prop)
        {
            try
            {
                valueAll = valueAll + prop + "|" + o[prop] + Environment.NewLine;
                //   Console.WriteLine(prop + "|" + o[prop]);
            }
            catch (Exception e) {  }
        }
        public string _path;
        [DllImport("kernel32")]
        private static extern long WritePrivateProfileString(string section,
       string key, string val, string filePath);
        [DllImport("kernel32")]
        private static extern int GetPrivateProfileString(string section,
                 string key, string def, StringBuilder retVal,
            int size, string filePath);
        public string IniReadValue(string Section, string Key)
        {
            StringBuilder temp = new StringBuilder(255);
            int i = GetPrivateProfileString(Section, Key, "", temp,
                                            255, this._path);
            return temp.ToString();

        }
        public void IniFile_DL(string INIPath)
        {
            _path = INIPath;
        }
        public bool isPOSInstalled(out string msg)
        {
            string filePath = "";
            if (Debugger.IsAttached)
            {
                System.Uri u = new System.Uri(System.Reflection.Assembly.GetExecutingAssembly().CodeBase);
                filePath = System.IO.Path.GetDirectoryName(u.LocalPath) + @"\" + "CKM.ini";
            }
            else
            {
                filePath = @"C:\\SMS\\AppData\\CKM.ini";
            }
            //   IniFile_DL idl = new IniFile_DL(filePath);

            msg = "";
            try
            {
                IniFile_DL(filePath);
               if ( IniReadValue("Database", "DeveloperMode") == "1")
                {
                    msg = "devMode";
                    return true;
                }
                string pter = "";
                try
                {
                    if (String.IsNullOrEmpty(IniReadValue("Printer", "StorePrinterName").TrimEnd()))
                    {
                        msg = "0";
                        return false;
                    }
                    pter = IniReadValue("Printer", "StorePrinterName");
                }
                catch
                {
                    msg = "0";
                    return false;
                }

                DeviceInfo deviceInfo = null;
                PosExplorer posExplorer = new PosExplorer();
                deviceInfo = posExplorer.GetDevice(DeviceType.PosPrinter, "PosPrinter");
                if (deviceInfo == null)    // 1=> POS not installed
                {
                    msg = "E284";// "Please install and register TM-M30 POS drivers or consult with vendor.";
                    return false;
                }
                if (GetOnlineStatus(pter) == "1")
                {
                    msg = "E285"; //"Please check TM-M30 POS driver update and try to reinstall or consult with vendor.";
                    return false;
                }
                if (GetOnlineStatus(pter) == "")
                {
                    msg = "E286"; //"Please register TM-M30 POS driver in utility or consult with vendor.";
                    return false;
                }
                if (GetOnlineStatus(pter) == "2")
                {
                    msg = "OK";
                    return true;
                }
                if (GetOnlineStatus(pter) == "3")
                {
                    msg = "E287";// "Please make ensure TM-M30 POS driver registration and printer USB connected or consult with vendor.";
                    return false;
                }
                if (GetOnlineStatus(pter) == "4")
                {
                    msg = "E288"; //"Please make ensure TM-M30 printer registration name correct with configuration file or consult with vendor.";
                    return false;
                }
            }
            catch
            {
                return false;
            }
            return true;
        }
        public void OpenCashDrawer(bool IsWaited = false,bool IsIdle = false, String vl = null )
        {
            if (isPOSInstalled(out string msg) && msg == "devMode")
            { 
                return;
            }
            //if (vl == null)
            //return;
            try
            {
                string strLogicalName = "CashDrawer";

                //PosExplorerを生成します。
                PosExplorer posExplorer = new PosExplorer();
                //var d = posExplorer.GetDevices("CashDrawer")[3];
                DeviceInfo deviceInfo = null;
                
                    deviceInfo = posExplorer.GetDevice(DeviceType.CashDrawer, strLogicalName);
               // vl= string.IsNullOrEmpty(deviceInfo) ? "NULL" : deviceInfo.Type; 
                m_Drawer = (CashDrawer)posExplorer.CreateInstance(deviceInfo);
                try
                {
                    // m_Drawer.DeviceEnabled = true;
                }
                catch(Exception ex) {
                    
                }
                m_Drawer.Open();

                m_Drawer.Claim(1000);

                //デバイスを使用可能（動作できる状態）にします。

                m_Drawer.DeviceEnabled = true;
            }
            catch (PosControlException ex)
            {
                //var msg = ex.Message;
            }
            try
            {
                m_Drawer.OpenDrawer();
            }
            catch (Exception ex
            ){
            }
            // ドロワーが開いている間、待ちます。

            try
            {
                while (m_Drawer.DrawerOpened == false)
                {
                    System.Threading.Thread.Sleep(100);
                }
                if (IsIdle)
                    return;

                if (IsWaited)
                    m_Drawer.WaitForDrawerClose(10000, 2000, 100, 1000);

                try
                {
                    CloseCashDrawer();
                }
                catch
                {
                    try
                    {
                        m_Drawer = null;
                    }
                    catch { }
                }
            }
            catch { }
        }
        public void CloseCashDrawer()
        {
            //<<<ステップ1>>>--Start
            if (m_Drawer != null)
            {
                try
                {
                    m_Drawer.Release();

                }
                catch (PosControlException)
                {

                }
                finally
                {
                    m_Drawer.Close();
                }
            }
        }
        public void RemoveDisplay(bool IsForced=false)
        {
            if (IsForced)
            {
                try
                {
                    ForcedToBeBlank();
                }
                catch { }
            }

            try
            {
               // m_Display.MarqueeType = DisplayMarqueeType.None;  // marquee close
                m_Display.DestroyWindow();                        // instance close we have created
                m_Display.ClearText();
                m_Display.DeviceEnabled = false;
                m_Display.Release();
                m_Display.Close();
            }
            catch (Exception ex)
            {
                try
                {
                    m_Display.DeviceEnabled = false;
                    m_Display.Release();
                    m_Display.Close();
                }
                catch
                {

                    try
                    {
                        m_Display.Release();
                        m_Display.Close();
                    }
                    catch
                    {
                        try
                        {
                            m_Display.Close();
                        }
                        catch { }
                    }
                }
            }
        }
        public void SetDisplay(bool IsMarquee, bool IsStartUp, string DefaultMessage = null, string Upval = null, string Downval = null)
        {
            try
            {
                int Wdh = 0;
                var valdown = "";
                if (IsStartUp)
                {

                    try { RemoveDisplay(); }
                    catch
                    { }
                    try
                    {
                        string strLogicalName = "LineDisplay";
                        PosExplorer posExplorer = null;
                        try
                        {
                            posExplorer = new PosExplorer();
                        }
                        catch (Exception ex)
                        {
                        }
                        deviceInfo = posExplorer.GetDevice(DeviceType.LineDisplay, strLogicalName);
                        m_Display = (LineDisplay)posExplorer.CreateInstance(deviceInfo);
                        m_Display.Open();
                        m_Display.Claim(10000);
                        m_Display.DeviceEnabled = true;
                    }

                    catch { }
                    valdown = DefaultMessage;
                    Wdh = Encoding.GetEncoding(932).GetByteCount(valdown);
                    m_Display.CharacterSet = 932;
                    m_Display.CreateWindow(1, 0, 1, 20, 1, Wdh);
                    if (!IsMarquee)
                    {
                        try
                        {
                            m_Display.MarqueeType = DisplayMarqueeType.None;
                        }
                        catch { }
                    }
                    else
                    {

                        m_Display.MarqueeFormat = DisplayMarqueeFormat.Walk;
                        m_Display.MarqueeType = DisplayMarqueeType.Init;
                        m_Display.MarqueeRepeatWait = 1000;
                        m_Display.MarqueeUnitWait = 100;
                        m_Display.DisplayText(valdown, DisplayTextMode.Normal);
                        m_Display.MarqueeType = DisplayMarqueeType.Left;
                    }
                }
                else
                {
                    Wdh = 20;
                    try
                    {
                        try
                        {
                            RemoveDisplay();
                        }
                        catch
                        { }
                        try
                        {
                            string strLogicalName = "LineDisplay";
                            PosExplorer posExplorer = null;
                            try
                            {
                                posExplorer = new PosExplorer();
                            }
                            catch (Exception ex)
                            {
                            }
                            deviceInfo = posExplorer.GetDevice(DeviceType.LineDisplay, strLogicalName);
                            m_Display = (LineDisplay)posExplorer.CreateInstance(deviceInfo);
                            m_Display.Open();
                            m_Display.Claim(10000);
                            m_Display.DeviceEnabled = true;
                        }
                        catch { }
                        m_Display.CharacterSet = 932;
                        var i = Encoding.GetEncoding(932).GetByteCount(Downval);
                        var j = Encoding.GetEncoding(932).GetByteCount(Upval);
                        m_Display.DisplayTextAt(0, (m_Display.Columns - j), Upval, DisplayTextMode.Normal);
                        m_Display.DisplayTextAt(1, (m_Display.Columns - i), Downval, DisplayTextMode.Normal);
                    }
                    catch
                    {
                    }
                }
            }
            catch (PosControlException pe)
            {
            }
        }
        private void PutSecond(int i, string Downval)
        {
            try
            {
                m_Display.DestroyWindow();
                m_Display.CreateWindow(1, 0, 1, 20, 1, 20);
                m_Display.DisplayTextAt(1, (m_Display.Columns - i), Downval, DisplayTextMode.Normal);
                
            }
            catch { }
        }
        private static void ForcedToBeBlank()
        {
            try
            {
                m_Display.CreateWindow(1, 0, 1, 20, 1, 20);
                m_Display.DestroyWindow();
                m_Display.ClearText();
            }
            catch { }
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
        //    Base_DL bdl = new Base_DL();
            var dt = new DataTable();
          //  var con = bdl.GetConnection();
             SqlConnection conn = new SqlConnection("Data Source=202.223.48.145;Initial Catalog=CapitalSMS;Persist Security Info=True;User ID=sa;Password=admin123456!");
            //SqlConnection conn = con;
            conn.Open();
            SqlCommand command = new SqlCommand("Select Char1, Char2, Char3, Char4,Char5 from [M_Multiporpose] where [Key]='1' and Id='326'", conn);
            SqlDataAdapter adapter = new SqlDataAdapter(command);
            adapter.Fill(dt);
            conn.Close();
            return dt;
        }
        public static LineDisplay m_Display  = null;
        public static DeviceInfo deviceInfo  = null;
        public object CDO_Main  = null;
    }
}
