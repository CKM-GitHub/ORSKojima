using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DL
{
    public class _Select_Source :Base_DL
    {
        public DataTable _Select_Source_(string cd)
        {
            string sp = "_Select_Source";

            Dictionary<string, ValuePair> dic = new Dictionary<string, ValuePair>
            {
                { "@CD", new ValuePair { value1 = SqlDbType.VarChar, value2 =  cd } }, 
            };

            return SelectData(dic, sp);
        }
        public bool _changedPass(string cd, string pass)
        {
            string sp = "M_LoginChangedPass";

            Dictionary<string, ValuePair> dic = new Dictionary<string, ValuePair>
            {
                { "@CD", new ValuePair { value1 = SqlDbType.VarChar, value2 =  cd } },
                { "@pass", new ValuePair { value1 = SqlDbType.VarChar, value2 =  pass } },

            };

            return InsertUpdateDeleteData(dic, sp);
        }
    }
}
