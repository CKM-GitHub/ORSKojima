using DL;
using Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BL
{
   public class MasterTouroku_Henkan_BL
    {

        M_Henkan_DL mhdl;
        public MasterTouroku_Henkan_BL()
        {
            mhdl = new M_Henkan_DL();
        }
        public bool MasterTouroku_Henkan_Insert_Update(M_Henkan_Entity mhe)
        {
            return mhdl.MasterTouroku_Henkan_Insert_Update(mhe);
        }
    }
}
