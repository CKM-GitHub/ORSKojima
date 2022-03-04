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
    public class ExhibitInformation_BL : Base_BL
    {
        ExhibitInformation_DL ExhibitInformationDL = new ExhibitInformation_DL();
        
        /// <summary>
        /// 
        /// </summary>
        public ExhibitInformation_BL()
        {
        }
        /// <summary>
        /// 明細部表示用
        /// </summary>
        /// <param name="dse"></param>
        /// <returns></returns>
        public DataTable PRC_ExhibitInformation_SelectDataForDisp(D_ShoppingCart_Entity dse)
        {
            return ExhibitInformationDL.PRC_ExhibitInformation_SelectDataForDisp(dse);
        }

        /// <summary>
        /// D_ShoppintCart削除処理
        /// </summary>
        /// <returns></returns>
        public bool PRC_ExhibitInformation_Delete()
        {
            return ExhibitInformationDL.PRC_ExhibitInformation_Delete();
        }
    
        /// <summary>
        /// 
        /// </summary>
        /// <param name="operationMode"></param>
        /// <param name="operatorID"></param>
        /// <param name="pc"></param>
        /// <param name="storeCD"></param>
        /// <param name="staffCD"></param>
        /// <param name="hacchuuDate"></param>
        /// <param name="dtTIkkatuHacchuuNyuuryoku"></param>
        /// <returns></returns>
        public bool PRC_IkkatuHacchuuNyuuryoku_Register(int operationMode, string operatorID, string pc, string storeCD, string staffCD, string hacchuuDate, string orderNO, string orderProcessNO, string ikkatuHacchuuMode, DataTable dtTIkkatuHacchuuNyuuryoku)
        {
            return ExhibitInformationDL.PRC_ExhibitInformation_Register(operationMode, operatorID, pc, storeCD, staffCD, hacchuuDate, orderNO, orderProcessNO, ikkatuHacchuuMode, dtTIkkatuHacchuuNyuuryoku);
        }

    }
}
