using System;
using System.Text;
using Microsoft.PointOfService;
using System.Management;
using DL;

namespace EPSON_TM30
{
    public static class PosUtility
    {
        private static bool _isInstalledPrinterDevice = false;

        public static bool IsPOSInstalled(out string msg)
        {
            msg = "";

            if (Base_DL.iniEntity.IsDM_D30Used == false)
            {
                return false;
            }

            if (Base_DL.iniEntity.DeveloperMode == "1")
            {
                msg = "devMode";
                return true;
            }

            if (String.IsNullOrEmpty(Base_DL.iniEntity.StorePrinterName))
            {
                msg = "E288"; //"Please make ensure TM-M30 printer registration name correct with configuration file or consult with vendor.";
                return false;
            }

            if (!_isInstalledPrinterDevice)
            {
                using (PosPrinterManager posPrinter = new PosPrinterManager())
                {
                    _isInstalledPrinterDevice = posPrinter.CanGetDevice();
                }
            }

            if (!_isInstalledPrinterDevice)    // 1=> POS not installed
            {
                msg = "E284";// "Please install and register TM-M30 POS drivers or consult with vendor.";
                return false;
            }

            string onlineStatus = GetOnlineStatus(Base_DL.iniEntity.StorePrinterName);
            if (onlineStatus == "1")
            {
                msg = "E285"; //"Please check TM-M30 POS driver update and try to reinstall or consult with vendor.";
                return false;
            }
            else if (onlineStatus == "2")
            {
            }
            else if (onlineStatus == "3")
            {
                msg = "E287";// "Please make ensure TM-M30 POS driver registration and printer USB connected or consult with vendor.";
                return false;
            }
            else if (onlineStatus == "4")
            {
                msg = "E288"; //"Please make ensure TM-M30 printer registration name correct with configuration file or consult with vendor.";
                return false;
            }
            else if (onlineStatus == "")
            {
                msg = "E286"; //"Please register TM-M30 POS driver in utility or consult with vendor.";
                return false;
            }
            else
            {
                return false;
            }

            msg = "OK";
            return true;
        }



        private static string GetOnlineStatus(string pter)
        {
            ManagementObjectSearcher searcher = new ManagementObjectSearcher("SELECT * FROM Win32_Printer");

            foreach (ManagementObject printer in searcher.Get())
            {
                string printerName = printer["Name"].ToString().ToLower();
                if (printerName.Equals((pter).ToLower()))
                {
                    //Console.WriteLine("Printer :" + printerName);
                    //StringBuilder sb = new StringBuilder();
                    //sb.Append(PrintProps(printer, "Caption"));
                    //sb.Append(PrintProps(printer, "ExtendedPrinterStatus"));
                    //sb.Append(PrintProps(printer, "Availability"));
                    //sb.Append(PrintProps(printer, "Default"));
                    //sb.Append(PrintProps(printer, "DetectedErrorState"));
                    //sb.Append(PrintProps(printer, "ExtendedDetectedErrorState"));
                    //sb.Append(PrintProps(printer, "ExtendedPrinterStatus"));
                    //sb.Append(PrintProps(printer, "LastErrorCode"));
                    //sb.Append(PrintProps(printer, "PrinterState"));
                    //sb.Append(PrintProps(printer, "PrinterStatus"));
                    //sb.Append(PrintProps(printer, "Status"));
                    //sb.Append(PrintProps(printer, "WorkOffline"));
                    //sb.Append(PrintProps(printer, "Local"));

                    if ((printer["DetectedErrorState"].ToString() == "0") && (printer["ExtendedDetectedErrorState"].ToString() == "1"))
                    {
                        return "1";
                    }
                    else if ((printer["DetectedErrorState"].ToString() == "0") && (printer["ExtendedDetectedErrorState"].ToString() == "0"))
                    {
                        return "2";
                    }
                    else
                    {
                        return "3";
                    }
                }
                //else if ((printerName.Contains("tm-m")))
                //{
                //    return "4";
                //}
            }
            return "";
        }

        private static string PrintProps(ManagementObject o, string prop)
        {
            try
            {
                return prop + "|" + o[prop] + Environment.NewLine;
            }
            catch
            {
                return "";
            }
        }
    }
}
