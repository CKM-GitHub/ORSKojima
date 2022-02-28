using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace BL
{
    public static class ExceptionExtentions
    {
        public static DialogResult ShowMessageBox(this Exception ex)
        {
            string caption = string.Empty;
            string stackTrace = string.Empty;

            if (System.Threading.Thread.CurrentThread.CurrentUICulture.Name == "ja-JP")
            {
                caption = ex.Source + " - アプリケーションエラー";
                stackTrace = "【スタックトレース】";
            }
            else
            {
                caption = ex.Source + " - Application Error";
                stackTrace = "StackTrace: ";
            }
            DialogResult ret = MessageBox.Show(ex.Message + "\n\n" + stackTrace + "\n" + ex.StackTrace, caption, MessageBoxButtons.OK, MessageBoxIcon.Error);
            return ret;
        }
    }
}
