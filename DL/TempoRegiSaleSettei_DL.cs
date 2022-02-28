using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Entity;

namespace DL
{
    public class TempoRegiSaleSettei_DL : Base_DL
    {
        public DataTable M_Sale_Select(string storeCD,string date)
        {
            string sp = "M_Sale_Select";
            Dictionary<string, ValuePair> dic = new Dictionary<string, ValuePair>
            {
                { "@StoreCD", new ValuePair { value1 = SqlDbType.VarChar, value2 = storeCD } },
                { "@ChangeDate", new ValuePair { value1 = SqlDbType.VarChar, value2 = date } },
            };
            return SelectData(dic, sp);
        }
        public DataTable M_Sale_SelectByStartDate(string storeCD, string date)
        {
            string sp = "M_Sale_SelectByStartDate";
            Dictionary<string, ValuePair> dic = new Dictionary<string, ValuePair>
            {
                { "@StoreCD", new ValuePair { value1 = SqlDbType.VarChar, value2 = storeCD } },
                { "@ChangeDate", new ValuePair { value1 = SqlDbType.VarChar, value2 = date } },
            };
            return SelectData(dic, sp);
        }
        public DataTable M_Sale_ErrorCheck(string storeCD, string date1)
        {
            string sp = "M_Sale_ErrorCheck";
            Dictionary<string, ValuePair> dic = new Dictionary<string, ValuePair>
            {
                { "@StoreCD", new ValuePair { value1 = SqlDbType.VarChar, value2 = storeCD } },
                { "@ChangeDate", new ValuePair { value1 = SqlDbType.VarChar, value2 = date1 } },
            };
            return SelectData(dic, sp);
        }
        public bool M_Sale_Insert_Update(M_Sale_Entity mse,string storeCD,string mode,string strDate)
        {
            Dictionary<string, ValuePair> dic = new Dictionary<string, ValuePair>
            {
                { "@StoreCD", new ValuePair { value1 = SqlDbType.VarChar, value2 = storeCD } },
                { "@StartDate", new ValuePair { value1 = SqlDbType.VarChar, value2 = mse.StartDate} },
                { "@strDate",new ValuePair { value1 = SqlDbType.VarChar, value2 = strDate} },
                { "@EndDate", new ValuePair { value1 = SqlDbType.VarChar, value2 = mse.EndDate } },
                { "@SaleFlg", new ValuePair { value1 = SqlDbType.TinyInt, value2 = mse.SaleFlg.ToString() } },
                { "@GeneralSaleRate", new ValuePair { value1 = SqlDbType.Decimal, value2 = mse.GeneralSaleRate } },
                { "@GFraction", new ValuePair { value1 = SqlDbType.TinyInt, value2 = mse.GeneralSaleFraction.ToString() } },
                { "@MemberSaleRate", new ValuePair { value1 = SqlDbType.Decimal, value2 =mse.MemberSaleRate } },
                { "@MFraction", new ValuePair { value1 = SqlDbType.TinyInt, value2 =mse.MemberSaleFraction.ToString() } },
                { "@ClientSaleRate", new ValuePair { value1 = SqlDbType.Decimal, value2 = mse.ClientSaleRate } },
                { "@CFraction", new ValuePair { value1 = SqlDbType.TinyInt, value2 = mse.ClientSaleFraction.ToString() } },
                { "@Operator", new ValuePair { value1 = SqlDbType.VarChar, value2 = mse.InsertOperator} },
                { "@Program", new ValuePair { value1 = SqlDbType.VarChar, value2 = mse.ProgramID} },
                { "@PC", new ValuePair { value1 = SqlDbType.VarChar, value2 = mse.PC } },
                { "@OperateMode", new ValuePair { value1 = SqlDbType.VarChar, value2 = mse.ProcessMode } },
                { "@KeyItem", new ValuePair { value1 = SqlDbType.VarChar, value2 = mse.Key } },
                { "@Mode", new ValuePair { value1 = SqlDbType.VarChar, value2 = mode } },
            };
            UseTransaction = true;
            return InsertUpdateDeleteData(dic, "M_Sale_Insert_Update");
        }
    }
}
