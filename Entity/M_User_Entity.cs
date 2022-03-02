using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entity
{
    public class M_User_Entity : Base_Entity
    {

        public string ID { get; set; }
        public string User_Name { get; set; }
        public string Login_ID { get; set; }
        public string Password { get; set; }
        public string Status { get; set; }
        public string Created_Date { get; set; }
        public string Updated_Date { get; set; }
        public string IsAdmin { get; set; }

    }
}
