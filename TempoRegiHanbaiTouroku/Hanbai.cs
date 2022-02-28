using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using TempoRegiRyousyuusyo;
namespace TempoRegiHanbaiTouroku
{

    public class Hanbai
    {
        string txtSalesNO = "";
        bool chkRyousyuusho = false;
        bool chkReceipt = false;
        string txtPrintDate = "";
        //string[] cmds = new string[] { "C:\\", "01", "0001", "ptk", "0001", "A0321090024", "0", "1", "2021/09/30", "1" };
        private void PrintIni( )
        {
           

        }

        public Hanbai()
        {
            PrintIni();
        }
        public void PrintAll(string[] args)
        {
            TempoRegiRyousyuusyo.TempoRegiRyousyuusyo ryou = new TempoRegiRyousyuusyo.TempoRegiRyousyuusyo();
            ryou.WindowState = FormWindowState.Minimized;
            //ryou.Hide();
            ryou.ShowInTaskbar = false;
            ryou.Print(args);
            
        }

    }
}
