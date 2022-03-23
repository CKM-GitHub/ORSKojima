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
    public class ExhibitHistory_BL : Base_BL
    {
        ExhibitHistory_DL ExhibitHistoryDL = new ExhibitHistory_DL();
        
        /// <summary>
        /// 
        /// </summary>
        public ExhibitHistory_BL()
        {
        }
        /// <summary>
        /// 明細部表示用
        /// </summary>
        /// <param name="dse"></param>
        /// <returns></returns>
        public DataTable PRC_ExhibitHistory_SelectDataForDisp(D_ShoppingCart_Entity dse)
        {
            return ExhibitHistoryDL.PRC_ExhibitHistory_SelectDataForDisp(dse);
        }

    }
}
