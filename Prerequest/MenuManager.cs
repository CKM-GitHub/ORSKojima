using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Prerequest
{
   public class MenuManager
    {
        public bool Prompt(string currentPjt)
        {
            string alreadyInstances = "MainMenu,CapitalSMS,CapitalStore,TennicSMS,HaspoSMS,HaspoStore";

            foreach (string val in alreadyInstances.Split(','))
            {
                if (val != currentPjt)
                {
                    Process[] localByName = Process.GetProcessesByName(val);
                    if (localByName.Count() > 0)
                    {
                        MessageBox.Show("PLease close the already running menu before running the new instance one.");
                        return true;
                    }
                }
            }
            return false;
        }
    }
}
