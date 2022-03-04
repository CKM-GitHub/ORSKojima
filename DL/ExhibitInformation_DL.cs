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
        /// 
        /// </summary>
        /// <param name="hacchuuDate"></param>
        /// <param name="vendorCD"></param>
        /// <param name="storeCD"></param>
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
        /// 
        /// </summary>
        /// <param name="operationMode"></param>
        /// <param name="operatorID"></param>
        /// <param name="pc"></param>
        /// <param name="storeCD"></param>
        /// <param name="staffCD"></param>
        /// <param name="hacchuuDate"></param>
        /// <param name="dtTIkkatuHacchuuNyuuryoku"></param>
        /// <returns></returns>
        public bool PRC_ExhibitInformation_Register(int operationMode,string operatorID,string pc,string storeCD,string staffCD, string orderDate, string orderNO, string orderProcessNO, string ikkatuHacchuuMode, DataTable dtTIkkatuHacchuuNyuuryoku)
        {
            Dictionary<string, ValuePair> dic = new Dictionary<string, ValuePair>
            {
                { "@p_OperateMode", new ValuePair { value1 = SqlDbType.Int, value2 = operationMode.ToString() } },
                { "@p_Operator", new ValuePair { value1 = SqlDbType.VarChar, value2 = operatorID } },
                { "@p_PC", new ValuePair { value1 = SqlDbType.VarChar, value2 = pc} },
                { "@p_StoreCD", new ValuePair { value1 = SqlDbType.VarChar, value2 = storeCD} },
                { "@p_StaffCD", new ValuePair { value1 = SqlDbType.VarChar, value2 = staffCD} },
                { "@p_OrderDate", new ValuePair { value1 = SqlDbType.Date, value2 = orderDate} },
                { "@p_OrderNO", new ValuePair { value1 = SqlDbType.VarChar, value2 = orderNO} },
                { "@p_IkkatuHacchuuMode", new ValuePair { value1 = SqlDbType.VarChar, value2 = ikkatuHacchuuMode} },
                { "@p_OrderProcessNO", new ValuePair { value1 = SqlDbType.VarChar, value2 = orderProcessNO} },
            };
            bool ret = true;
            string sp = "PRC_ExhibitInformation_Register";
            try
            {
                StartTransaction();
                command = new SqlCommand(sp, GetConnection(), transaction);
                command.CommandType = CommandType.StoredProcedure;
                foreach (KeyValuePair<string, ValuePair> pair in dic)
                {
                    ValuePair vp = pair.Value;
                    AddParam(command, pair.Key, vp.value1, vp.value2);
                }
                SqlParameter p = command.Parameters.AddWithValue("@p_TExhibitInformation", dtTIkkatuHacchuuNyuuryoku);
                p.SqlDbType = SqlDbType.Structured;

                command.ExecuteNonQuery();

                CommitTransaction();

                ret = true;
            }
            catch (Exception e)
            {
                RollBackTransaction();
                ret = false;
                throw e;
            }
            finally
            {
                command.Connection.Close();
            }
            return ret;
        }

    }
}
