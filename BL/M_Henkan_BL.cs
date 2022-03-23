using DL;
using Entity;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BL
{
   public class M_Henkan_BL:Base_BL
    {
        M_Henkan_DL mhdl;
        public M_Henkan_BL()
        {
            mhdl = new M_Henkan_DL();
        }

        public bool M_Henkan_Select(M_Henkan_Entity mhe)
        {
            DataTable dt = mhdl.M_Henkan_Select(mhe);
            if (dt.Rows.Count > 0)
            {
                mhe.TokuisakiCD = dt.Rows[0]["TokuisakiCD"].ToString();
                mhe.RCMItemName = dt.Rows[0]["RCMItemName"].ToString();
                mhe.RCMItemValue = dt.Rows[0]["RCMItemValue"].ToString();
                mhe.CsvOutputItemValue = dt.Rows[0]["CsvOutputItemValue"].ToString();
                mhe.CsvTitleName = dt.Rows[0]["CsvTitleName"].ToString();
                mhe.Yobi1 = dt.Rows[0]["Yobi1"].ToString();
                mhe.Yobi2 = dt.Rows[0]["Yobi2"].ToString();
                mhe.Yobi3 = dt.Rows[0]["Yobi3"].ToString();
                mhe.Yobi4 = dt.Rows[0]["Yobi4"].ToString();
                mhe.Yobi5 = dt.Rows[0]["Yobi5"].ToString();
                mhe.Yobi6 = dt.Rows[0]["Yobi6"].ToString();
                mhe.Yobi7 = dt.Rows[0]["Yobi7"].ToString();
                mhe.Yobi8 = dt.Rows[0]["Yobi8"].ToString();
                mhe.Yobi9 = dt.Rows[0]["Yobi9"].ToString();

                return true;
            }
            else
                return false;
        }
    }
}
