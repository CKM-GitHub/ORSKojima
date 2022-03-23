using Entity;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;

namespace DL
{
    public class ExhibitHistory_DL : Base_DL
    {
        /// <summary>
        /// 画面表示用データ取得
        /// </summary>
        /// <param name="dse"></param>
        /// <returns></returns>
        public DataTable PRC_ExhibitHistory_SelectDataForDisp(D_ShoppingCart_Entity dse)
        {
            Dictionary<string, ValuePair> dic = new Dictionary<string, ValuePair>
            {
                { "@TokuisakiCD", new ValuePair { value1 = SqlDbType.VarChar, value2 = dse.TokuisakiCD } },
                { "@ExhibitDate1", new ValuePair { value1 = SqlDbType.VarChar, value2 = dse.ExhibitDate1 } },
                { "@ExhibitDate2", new ValuePair { value1 = SqlDbType.VarChar, value2 = dse.ExhibitDate2 } },
                { "@BrandName", new ValuePair { value1 = SqlDbType.VarChar, value2 = dse.Brand_Name } },
                { "@Item_Name1", new ValuePair { value1 = SqlDbType.VarChar, value2 = dse.Item_Name1 } },
                { "@Item_Name2", new ValuePair { value1 = SqlDbType.VarChar, value2 = dse.Item_Name2 } },
                { "@Item_Code1", new ValuePair { value1 = SqlDbType.VarChar, value2 = dse.Item_Code1 } },
                { "@Item_Code2", new ValuePair { value1 = SqlDbType.VarChar, value2 = dse.Item_Code2 } },
                { "@Item_Code3", new ValuePair { value1 = SqlDbType.VarChar, value2 = dse.Item_Code3 } },
                { "@Item_Code4", new ValuePair { value1 = SqlDbType.VarChar, value2 = dse.Item_Code4 } },
                { "@Item_Code5", new ValuePair { value1 = SqlDbType.VarChar, value2 = dse.Item_Code5 } },
                { "@GrossProfit", new ValuePair { value1 = SqlDbType.VarChar, value2 = dse.ArariRate } },
                { "@Discount", new ValuePair { value1 = SqlDbType.VarChar, value2 = dse.WaribikiRate } },
            };
            return SelectData(dic, "PRC_ExhibitHistory_SelectDataForDisp");
        }

    }
}
