using Entity;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DL
{
    public class MasterTorikomi_SKU_DL : Base_DL
    {
        public Boolean MasterTorikomi_SKU_Insert_Update(int type, M_SKU_Entity mE)
        {
            Dictionary<String, ValuePair> dic = new Dictionary<string, ValuePair>
            {
                { "@type", new ValuePair { value1 = SqlDbType.Int, value2 =type.ToString()  } },
                { "@xml", new ValuePair { value1 = SqlDbType.Xml, value2 = mE.xml1 } },
                { "@OperatorCD",new ValuePair { value1 = SqlDbType.VarChar, value2 = mE.Operator} },
                { "@ProgramID",new ValuePair { value1 = SqlDbType.VarChar, value2 = mE.ProgramID} },
                { "@PC",new ValuePair { value1 = SqlDbType.VarChar, value2 = mE.PC} },
                { "@KeyItem",new ValuePair { value1 = SqlDbType.VarChar, value2 = mE.Key} }

            };
            UseTransaction = true;
            return InsertUpdateDeleteData(dic, "MasterTorikomi_SKU_Insert_Update");
        }

        public DataTable M_SKUInitial_SelectAll()
        {
            Dictionary<String, ValuePair> dic = new Dictionary<string, ValuePair>
            { };

            return SelectData(dic, "M_SKUInitial_SelectAll");
        }

        public DataTable M_API_Select()
        {
            Dictionary<String, ValuePair> dic = new Dictionary<string, ValuePair>
            { };

            return SelectData(dic, "M_API_Select");
        }
        public DataTable M_MessageSelectAll()
        {
            Dictionary<String, ValuePair> dic = new Dictionary<string, ValuePair>
            { };

            return SelectData(dic, "M_Message_SelectAll");
        }
        public DataTable M_SKU_CheckSKUExists(M_SKU_Entity info)
        {
            Dictionary<String, ValuePair> dic = new Dictionary<string, ValuePair>
            {
                { "@AdminNO", new ValuePair { value1 = SqlDbType.Int, value2 =info.AdminNO  } },
                { "@SKUCD", new ValuePair { value1 = SqlDbType.VarChar, value2 = info.SKUCD } },
                { "@ChangeDate",new ValuePair { value1 = SqlDbType.Date, value2 = info.ChangeDate} }
            };
            return SelectData(dic, "MasterTorikomi_SKU_CheckSKUExists");
        }
        public DataTable M_SKU_CheckDuplicateSizeAndColor(M_SKU_Entity info)
        {
            Dictionary<String, ValuePair> dic = new Dictionary<string, ValuePair>
            {
                { "@AdminNO", new ValuePair { value1 = SqlDbType.Int, value2 =info.AdminNO } },
                { "@ITemCD", new ValuePair { value1 = SqlDbType.VarChar, value2 =info.ITemCD } },
                { "@SizeNO", new ValuePair { value1 = SqlDbType.Int, value2 = info.SizeNO } },
                { "@ColorNO", new ValuePair { value1 = SqlDbType.Int, value2 = info.ColorNO } },
                { "@ChangeDate",new ValuePair { value1 = SqlDbType.Date, value2 = info.ChangeDate} }
            };
            return SelectData(dic, "MasterTorikomi_SKU_CheckDuplicateSizeAndColor");
        }

        public DataTable M_SKU_CheckItemExists(M_SKU_Entity info)
        {
            Dictionary<String, ValuePair> dic = new Dictionary<string, ValuePair>
            {
                { "@ITemCD", new ValuePair { value1 = SqlDbType.VarChar, value2 =info.ITemCD } },
                { "@ChangeDate",new ValuePair { value1 = SqlDbType.Date, value2 = info.ChangeDate} }
            };
            return SelectData(dic, "MasterTorikomi_SKU_CheckItemExists");
        }
    }
}
