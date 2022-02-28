using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Entity;

namespace DL
{
    public class M_CustomerUpdate_DL:Base_DL
    {
        //public DataTable M_MultiPorpose_Select(M_MultiPorpose_Entity mme)
        //{
        //    string sp = "M_MultiPorpose_Select";
        //    Dictionary<string, ValuePair> dic = new Dictionary<string, ValuePair>
        //    {
        //        { "@ID", new ValuePair { value1 = SqlDbType.Int, value2 = mme.ID } },
        //        { "@Key", new ValuePair { value1 = SqlDbType.VarChar, value2 = mme.Key } }
        //    };
        //    return SelectData(dic, sp);
        //}
        public bool  M_CustomerUpdate(string updateData)
        {
            string sp = "Update_M_Customer";
            Dictionary<string, ValuePair> dic = new Dictionary<string, ValuePair>
            {
                { "@updateXml", new ValuePair { value1 = SqlDbType.VarChar, value2 = updateData } }
            };
            return InsertUpdateDeleteData(dic, sp);
        }
    }
}
