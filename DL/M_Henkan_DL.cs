using System;
using Entity;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DL
{
   public class M_Henkan_DL:Base_DL
    {
        public DataTable M_Henkan_Select(M_Henkan_Entity mte)
        {
            string sp = "M_Henkan_Select";

            Dictionary<string, ValuePair> dic = new Dictionary<string, ValuePair>
            {
                { "@TokuisakiCD", new ValuePair { value1 = SqlDbType.VarChar, value2 = mte.TokuisakiCD  } },
                { "@RCMItemName", new ValuePair { value1 = SqlDbType.VarChar, value2 = mte.RCMItemName  } },
                { "@RCMItemValue", new ValuePair { value1 = SqlDbType.VarChar, value2 = mte.RCMItemValue } }
            };
            return SelectData(dic, sp);
        }
    }
}
