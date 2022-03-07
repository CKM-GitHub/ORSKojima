using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Entity;
using DL;
using System.Data;

namespace BL
{
    public class Tokuisaki_BL : Base_BL
    {
        M_Tokuisaki_DL mtdl;
        public Tokuisaki_BL()
        {
            mtdl = new M_Tokuisaki_DL();
        }

        public bool M_Tokuisaki_Select(M_Tokuisaki_Entity mte)
        {
            DataTable dt = mtdl.M_Tokuisaki_Select(mte);
            if (dt.Rows.Count > 0)
            {
                mte.TokuisakiCD = dt.Rows[0]["TokuisakiCD"].ToString();
                mte.TokuisakiName = dt.Rows[0]["TokuisakiName"].ToString();
                mte.ExportName = dt.Rows[0]["ExportName"].ToString();
                mte.TitleUmuKBN = dt.Rows[0]["TitleUmuKBN"].ToString();
                mte.OyaTokuisakiCD = dt.Rows[0]["OyaTokuisakiCD"].ToString();
                mte.Yobi1 = dt.Rows[0]["Yobi1"].ToString();
                mte.Yobi2 = dt.Rows[0]["Yobi2"].ToString();
                mte.Yobi3 = dt.Rows[0]["Yobi3"].ToString();
                mte.Yobi4 = dt.Rows[0]["Yobi4"].ToString();
                mte.Yobi5 = dt.Rows[0]["Yobi5"].ToString();
                mte.Yobi6 = dt.Rows[0]["Yobi6"].ToString();
                mte.Yobi7 = dt.Rows[0]["Yobi7"].ToString();
                mte.Yobi8 = dt.Rows[0]["Yobi8"].ToString();
                mte.Yobi9 = dt.Rows[0]["Yobi9"].ToString();

                return true;
            }
            else
                return false;
        }

    }
}
