using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Data;
using System.Collections;
using Entity;
using System.Runtime.InteropServices;
using BL;

namespace Capital_Point_Update
{
    public  class Program
    {
        static DataTable dtPointUpdate = new DataTable();
        static DataTable dtMulti = new DataTable();
        string folderPath = string.Empty;
        static M_CustomerUpdate_BL mbl = new M_CustomerUpdate_BL();
        static M_MultiPorpose_Entity mpe = new M_MultiPorpose_Entity();
        static Login_BL lgbl = new Login_BL();
        public static void Main(string[] args)
        {
            Console.Title = "Capital_Point_Update";
            if (lgbl.ReadConfig() == true)
            {
                CreateDataTable();
                
                ArrayList arr = new ArrayList();
                mpe.ID = "238";
                mpe.Key = "1";
                dtMulti = mbl.M_MultiPorpose_SelectID(mpe);

                //【起動可否確認】
                //汎用マスター.	数字型１＝０なら、処理終了
                if (dtMulti.Rows[0]["Num1"].ToString().Equals("0"))
                    return;
                else
                {
                    mpe.Char1 = dtMulti.Rows[0]["Char1"].ToString();
                    //string folderPath = @"C:\Users\Shwe Eain San\Downloads\point\";
                    string folderPath = mpe.Char1;
                    DirectoryInfo dir = new DirectoryInfo(folderPath);
                    FileSystemInfo[] infos = dir.GetFileSystemInfos();
                    foreach (FileSystemInfo dr in infos)
                    {
                        string readFile = folderPath + dr.ToString();
                        string[] Files;
                        Files = Directory.GetFiles(folderPath, "*.*", System.IO.SearchOption.AllDirectories).ToArray();

                        foreach (string file in Files)
                        {
                            arr.Add(file);
                            string text = File.ReadAllText(file);
                            M_CustomerUpdateEntity mc = new M_CustomerUpdateEntity();
                            char[] separatingStrings = { ' ', '\n', '\r' };
                            string[] strlist = text.Split(separatingStrings, System.StringSplitOptions.RemoveEmptyEntries);
                            mc.CustomerCD = System.IO.Path.GetFileName(file);
                            mc.LastSalesDate = strlist[1];
                            mc.Lastpoint = strlist[3].Substring(0, strlist[3].Length - 8);
                            mc.TotalPoint = strlist[6];
                            DataRow workRow = dtPointUpdate.NewRow();
                            workRow[0] = mc.CustomerCD;
                            workRow[1] = mc.LastSalesDate;
                            workRow[2] = mc.Lastpoint;
                            workRow[3] = mc.TotalPoint;
                            dtPointUpdate.Rows.Add(workRow);
                        }
                    }
                    if (dtPointUpdate.Rows.Count > 0)
                    {
                        if (mbl.M_Customer_Update(dtPointUpdate))
                        {
                            Console.WriteLine("Now,the data is updated.");
                        }
                    }
                }
            }
        }
        public static void CreateDataTable()
        {
            dtPointUpdate.Columns.Add("CustomerCD");
            dtPointUpdate.Columns.Add("LastSalesDate");
            dtPointUpdate.Columns.Add("Lastpoint");
            dtPointUpdate.Columns.Add("TotalPoint");
        }
    }
}
