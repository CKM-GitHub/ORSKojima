using System;
using System.Collections.Generic;
using System.Linq;
using System.Management;
using System.Text;
using System.Threading.Tasks;

namespace Prerequest
{
    public class OverridePort
    {

        public string GetPropertyValue(PropertyData data)
        {
            if ((data == null) || (data.Value == null)) return "";
            return data.Value.ToString();
        }
        public void GetPort()
        {
            //string query = "SELECT * FROM Win32_Printer WHERE Name='" + cboPrinters.SelectedItem.ToString() + "'";
            //ManagementObjectSearcher searcher =
            //    new ManagementObjectSearcher(query);
            //foreach (ManagementObject service in searcher.Get())
            //{

            //}
        }
    }
}
