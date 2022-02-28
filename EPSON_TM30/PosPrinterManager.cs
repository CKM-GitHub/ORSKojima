using System;
using System.Text;
using Microsoft.PointOfService;
using System.Management;

namespace EPSON_TM30
{
    public class PosPrinterManager : IDisposable
    {
        //private static PosPrinter m_Printer = null;

        public void Dispose()
        {
        }

        public PosPrinterManager()
        {
        }

        public bool CanGetDevice()
        {
            string strLogicalName = "PosPrinter";
            PosExplorer posExplorer = new PosExplorer();
            DeviceInfo deviceInfo = null;
            try
            {
                deviceInfo = posExplorer.GetDevice(DeviceType.PosPrinter, strLogicalName);
            }
            catch (Exception)
            {
                return false;
            }
            return true;
        }
    }
}
