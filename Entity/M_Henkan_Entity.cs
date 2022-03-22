using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entity
{
   public class M_Henkan_Entity:Base_Entity
    {

        public string TokuisakiCD { get; set; }
        public string RCMItemName { get; set; }
        public string RCMItemValue { get; set; }
        public string CsvTitleName { get; set; }
        public string CsvOutputItemValue { get; set; }
    }
}
