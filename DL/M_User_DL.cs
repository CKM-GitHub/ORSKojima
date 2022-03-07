using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Entity;

namespace DL
{
    public class M_User_DL : Base_DL
    {
        /// <summary>
        /// Select User's info
        /// </summary>
        /// <param name="mue">user info</param>
        /// <returns></returns>
        /// 


        /// <summary>	
        ///  	共通処理　Operator 確認	
        /// </summary>	
        /// <param name="mse"></param>	
        /// <returns></returns>	
        public DataTable M_User_InitSelect(M_User_Entity mue)
        {
            string sp = "M_User_InitSelect";
            Dictionary<string, ValuePair> dic = new Dictionary<string, ValuePair>
            {
                { "@UserID", new ValuePair { value1 = SqlDbType.VarChar, value2 = mue.Login_ID } }
            };
            return SelectData(dic, sp);
        }


    }
}
