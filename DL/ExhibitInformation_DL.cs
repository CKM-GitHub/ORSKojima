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
    public class ExhibitInformation_DL : Base_DL
    {
        /// <summary>
        /// 画面表示用データ取得
        /// </summary>
        /// <param name="dse"></param>
        /// <returns></returns>
        public DataTable PRC_ExhibitInformation_SelectDataForDisp(D_ShoppingCart_Entity dse)
        {
            Dictionary<string, ValuePair> dic = new Dictionary<string, ValuePair>
            {
                { "@TokuisakiCD", new ValuePair { value1 = SqlDbType.VarChar, value2 = dse.TokuisakiCD } },
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
            return SelectData(dic, "PRC_ExhibitInformation_SelectDataForDisp");
        }

        /// <summary>
        /// D_ShoppintCart 削除処理
        /// </summary>
        /// <returns></returns>
        public bool PRC_ExhibitInformation_Delete()
        {
            Dictionary<string, ValuePair> dic = new Dictionary<string, ValuePair>()
            {
                //{ "@SoukoCD", new ValuePair { value1 = SqlDbType.VarChar, value2 = mse.SoukoCD } },
                //{ "@ChangeDate", new ValuePair { value1 = SqlDbType.Date, value2 = mse.ChangeDate } },
                //{ "@Operator", new ValuePair { value1 = SqlDbType.VarChar, value2 = mse.Operator } },
                //{ "@Program", new ValuePair { value1 = SqlDbType.VarChar, value2 = mse.ProgramID } },
                //{ "@PC", new ValuePair { value1 = SqlDbType.VarChar, value2 = mse.PC } },
                //{ "@OperateMode", new ValuePair { value1 = SqlDbType.VarChar, value2 = mse.ProcessMode } },
                //{ "@KeyItem", new ValuePair { value1 = SqlDbType.VarChar, value2 = mse.Key } }
            };

            //UseTransaction = true;
            return InsertUpdateDeleteData(dic, "prc_ExhibitInformation_Delete");
        }

        /// <summary>
        /// 出品履歴データ（D_ExhibitHistory）更新処理
        /// </summary>
        /// <param name="dse"></param>
        /// <param name="dtRegist"></param>
        /// <returns></returns>
        public bool PRC_ExhibitInformation_Register(D_ShoppingCart_Entity dse, DataTable dtRegist)
        {
            string sp = "PRC_ExhibitInformation_Register";

            command = new SqlCommand(sp, GetConnection());
            command.CommandType = CommandType.StoredProcedure;
            command.CommandTimeout = 0;

            AddParam(command, "@TokuisakiCD", SqlDbType.VarChar, dse.TokuisakiCD);
            AddParamForDataTable(command, "@TableRegist", SqlDbType.Structured, dtRegist);
            AddParam(command, "@Operator", SqlDbType.VarChar, dse.Operator);
            AddParam(command, "@PC", SqlDbType.VarChar, dse.PC);

            //OUTパラメータの追加
            string outPutParam = "@OutTokuisakiCD";
            command.Parameters.Add(outPutParam, SqlDbType.VarChar, 5);
            command.Parameters[outPutParam].Direction = ParameterDirection.Output;

            UseTransaction = true;

            bool ret = InsertUpdateDeleteData(sp, ref outPutParam);
            if (ret)
                dse.TokuisakiCD = outPutParam;

            return ret;
        }

    }
}
