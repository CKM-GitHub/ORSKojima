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
    public class TempoRegiSaleSettei_BL : Base_BL
    {
        TempoRegiSaleSettei_DL saledl;
        public TempoRegiSaleSettei_BL()
        {
            saledl = new TempoRegiSaleSettei_DL();
        }
        public DataTable M_Sale_Select(string storeCD,string date)
        {
            return saledl.M_Sale_Select(storeCD, date);
        }
        public DataTable M_Sale_SelectByStartDate(string storeCD, string date)
        {
            return saledl.M_Sale_SelectByStartDate(storeCD, date);
        }
        public DataTable M_Sale_ErrorCheck(string storeCD, string date1)
        {
            return saledl.M_Sale_ErrorCheck(storeCD, date1);
        }
        public bool M_Sale_Insert_Update(M_Sale_Entity mse,string storeCD,string mode,string strDate)
        {
            return saledl.M_Sale_Insert_Update(mse,storeCD,mode, strDate);
        }
    }
}
