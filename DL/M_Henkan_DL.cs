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
        public DataTable M_Henkan_Select(M_Henkan_Entity mhe)
        {
            string sp = "M_Henkan_Select";

            Dictionary<string, ValuePair> dic = new Dictionary<string, ValuePair>
            {
                { "@TokuisakiCD", new ValuePair { value1 = SqlDbType.VarChar, value2 = mhe.TokuisakiCD  } },
                { "@RCMItemName", new ValuePair { value1 = SqlDbType.VarChar, value2 = mhe.RCMItemName  } },
                { "@RCMItemValue", new ValuePair { value1 = SqlDbType.VarChar, value2 = mhe.RCMItemValue } }
            };
            return SelectData(dic, sp);
        }

        public bool MasterTouroku_Henkan_Insert_Update(M_Henkan_Entity mhe,int mode)
        {
            Dictionary<string, ValuePair> dic = new Dictionary<string, ValuePair>
            {
                { "@CsvOutputItemValue", new ValuePair { value1 = SqlDbType.VarChar, value2 = mhe.CsvOutputItemValue  } },
                { "@CsvTitleName", new ValuePair { value1 = SqlDbType.VarChar, value2 = mhe.CsvTitleName  } },
                { "@Mode", new ValuePair { value1 = SqlDbType.VarChar, value2 = mode.ToString()} }
            };
            UseTransaction = true;
            return InsertUpdateDeleteData(dic, "MasterTouroku_Henkan_Insert_Update");

            
        }
    }
}
