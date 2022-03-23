using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entity
{
    public class D_ShoppingCart_Entity : Base_Entity
    {
        public string TokuisakiCD { get; set; }
        public string ExhibitDate { get; set; }
        public string ID { get; set; }
        public string Item_Code { get; set; }
        public string Item_Name { get; set; }
        public string Brand_Name { get; set; }
        public string List_Price { get; set; }
        public string Sale_Price { get; set; }
        public string Cost { get; set; }
        public string ArariRate { get; set; }
        public string WaribikiRate { get; set; }
        public string Yobi1 { get; set; }
        public string Yobi2 { get; set; }
        public string Yobi3 { get; set; }
        public string Yobi4 { get; set; }
        public string Yobi5 { get; set; }
        public string Yobi6 { get; set; }
        public string Yobi7 { get; set; }
        public string Yobi8 { get; set; }
        public string Yobi9 { get; set; }

        // データ検索用
        public string ExhibitDate1 { get; set; }
        public string ExhibitDate2 { get; set; }
        public string Item_Name1 { get; set; }
        public string Item_Name2 { get; set; }
        public string Item_Code1 { get; set; }
        public string Item_Code2 { get; set; }
        public string Item_Code3 { get; set; }
        public string Item_Code4 { get; set; }
        public string Item_Code5 { get; set; }
    }
}
