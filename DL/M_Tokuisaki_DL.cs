using Entity;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DL
{
    public class M_Tokuisaki_DL : Base_DL
    {
        public DataTable M_Tokuisaki_Select(M_Tokuisaki_Entity mte)
        {
            string sp = "M_Tokuisaki_Select";

            Dictionary<string, ValuePair> dic = new Dictionary<string, ValuePair>
            {
                { "@TokuisakiCD", new ValuePair { value1 = SqlDbType.NVarChar, value2 = mte.TokuisakiCD  } }
            };
            return SelectData(dic, sp);
        }

        public bool M_Tokuisaki_InsertUpdate(M_Tokuisaki_Entity mte,int mode)
        {
            Dictionary<string, ValuePair> dic = new Dictionary<string, ValuePair>
            {
                { "@TokuisakiCD", new ValuePair { value1 = SqlDbType.VarChar, value2 = mte.TokuisakiCD  } },
                { "@TokuisakiName", new ValuePair { value1 = SqlDbType.VarChar, value2 = mte.TokuisakiName  } },
                { "@ExportName", new ValuePair { value1 = SqlDbType.VarChar, value2 = mte.ExportName  } },
                { "@TitleUmuKBN", new ValuePair { value1 = SqlDbType.VarChar, value2 = mte.TitleUmuKBN  } },
                { "@OyaTokuisakiCD", new ValuePair { value1 = SqlDbType.VarChar, value2 = mte.OyaTokuisakiCD  } },
                { "@Yobi1", new ValuePair { value1 = SqlDbType.VarChar, value2 = mte.Yobi1  } },
                { "@Yobi2", new ValuePair { value1 = SqlDbType.VarChar, value2 = mte.Yobi2  } },
                { "@Yobi3", new ValuePair { value1 = SqlDbType.VarChar, value2 = mte.Yobi3  } },
                { "@Yobi4", new ValuePair { value1 = SqlDbType.VarChar, value2 = mte.Yobi4  } },
                { "@Yobi5", new ValuePair { value1 = SqlDbType.VarChar, value2 = mte.Yobi5  } },
                { "@Yobi6", new ValuePair { value1 = SqlDbType.VarChar, value2 = mte.Yobi6  } },
                { "@Yobi7", new ValuePair { value1 = SqlDbType.VarChar, value2 = mte.Yobi7  } },
                { "@Yobi8", new ValuePair { value1 = SqlDbType.VarChar, value2 = mte.Yobi8  } },
                { "@Yobi9", new ValuePair { value1 = SqlDbType.VarChar, value2 = mte.Yobi9  } },
                { "@Operator", new ValuePair { value1 = SqlDbType.VarChar, value2 = mte.InsertOperator } },
                { "@Mode", new ValuePair { value1 = SqlDbType.TinyInt, value2 = mode.ToString() } }
            };
            UseTransaction = true;
            return InsertUpdateDeleteData(dic, "M_Tokuisaki_Insert_Update");
        }

        public bool M_Tokuisaki_Delete(M_Tokuisaki_Entity mte)
        {
            Dictionary<string, ValuePair> dic = new Dictionary<string, ValuePair>
            {
                { "@TokuisakiCD", new ValuePair { value1 = SqlDbType.VarChar, value2 = mte.TokuisakiCD } },
            };
            UseTransaction = true;
            return InsertUpdateDeleteData(dic, "M_Tokuisaki_Delete");
        }

    }
}
