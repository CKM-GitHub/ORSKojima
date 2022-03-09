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
        /// 出品履歴データ(D_ExhibitHistory)更新処理
        /// </summary>
        /// <param name="dse"></param>
        /// <param name="dtRegist"></param>
        /// <returns></returns>
        public bool PRC_ExhibitInformation_Register(D_ShoppingCart_Entity dse, DataTable dtRegist)
        {
            return ExhibitInformationDL.PRC_ExhibitInformation_Register(dse, dtRegist);
        }

        /// <summary>
        /// CSV用データ取得
        /// </summary>
        /// <param name="dse"></param>
        /// <param name="dt"></param>
        /// <returns></returns>
        public DataTable PRC_ExhibitInformation_SelectDataForCSV(D_ShoppingCart_Entity dse, DataTable dt)
        {
            return ExhibitInformationDL.PRC_ExhibitInformation_SelectDataForCsv(dse, dt);
        }


    }
}
