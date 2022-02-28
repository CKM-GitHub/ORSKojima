using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entity
{
    public class M_CustomerUpdateEntity : Base_Entity
    {
        public string CustomerCD { get; set; }
        public string Lastpoint { get; set; }
        public string TotalPoint { get; set; }
        public string LastSalesDate { get; set; }
    }
}
