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
    public class M_CustomerUpdate_BL:Base_BL
    {
        M_CustomerUpdate_DL mdl;
        M_MultiPorpose_DL dl;
        public M_CustomerUpdate_BL()
        {
            mdl = new M_CustomerUpdate_DL();
            dl = new M_MultiPorpose_DL();
        }
        public DataTable M_MultiPorpose_SelectID(M_MultiPorpose_Entity mdl)
        {
            return dl.M_MultiPorpose_Select(mdl);
        } 
        public bool M_Customer_Update(DataTable dtPointUpdate)
        {
            string xmlupdateData = DataTableToXml(dtPointUpdate);
            return mdl.M_CustomerUpdate(xmlupdateData);
        }
    }
}
