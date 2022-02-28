using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entity
{
    public class M_Sale_Entity:Base_Entity
    {
        public string StoreCD { get; set; }
        public string StartDate { get; set; }
        public string EndDate { get; set; }
        public int SaleFlg { get; set; }
        public string GeneralSaleRate { get; set; }
        public int GeneralSaleFraction { get; set; }
        public string MemberSaleRate { get; set; }
        public int MemberSaleFraction { get; set; }
        public string ClientSaleRate { get; set; }
        public int ClientSaleFraction { get; set; }

    }
}
