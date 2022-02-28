using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Base.Client;
using Entity;
using BL;
using System.IO;
using ExcelDataReader;

namespace MasterTorikomi_SKUPrice
{
    public partial class MasterTorikomi_SKUPrice : FrmMainForm
    {
        Base_BL bbl;
        DataTable dtSKU = new DataTable();
        DataTable dtTankaCD = new DataTable();
        DataTable dtStoreCD = new DataTable();
        M_SKUPrice_Entity mskup;
        MasterTorikomi_SKUPrice_BL mskupbl; 
        SKU_BL sbl;
        string filePath = string.Empty;

        public MasterTorikomi_SKUPrice()
        {
            InitializeComponent();
            mskup = new M_SKUPrice_Entity();
            mskupbl = new MasterTorikomi_SKUPrice_BL();
            bbl = new Base_BL();
            sbl = new SKU_BL();
        }

        private void MasterTorikomi_SKUPrice_Load(object sender, EventArgs e)
        {
            InProgramID = "MasterTorikomi_SKUPrice";
            StartProgram();
            ModeVisible = false;
            Btn_F12.Text = "取込(F12)";
           
            dtSKU = sbl.M_SKU_SelectAll_FORSKU();
            dtTankaCD = mskupbl.M_TankaCD_SelectAll_NoPara();
            dtStoreCD = mskupbl.M_StoreCD_SelectAll_NoPara();
        }

        public override void FunctionProcess(int index)
        {

            switch (index + 1)
            {

                case 6:
                    if (bbl.ShowMessage("Q004") == DialogResult.Yes)
                    {
                        CleanData();
                    }
                    break;

                case 12:
                    F12();
                    break;
            }
        }

        private void F12()
        {
            try
            {
                if (bbl.ShowMessage("Q001", "取込処理") == DialogResult.Yes)
                {
                    Cursor = Cursors.WaitCursor;
                    if (String.IsNullOrEmpty(TB_FileName.Text))
                    {
                        bbl.ShowMessage("E121");
                        TB_FileName.Focus();
                        Cursor = Cursors.Default;
                        return;
                    }
                    //DataTable dt = ExcelToDatatable(filePath);
                    var dt = GV_SKUPrice.DataSource as DataTable;
                    if (dt == null)
                    {
                        //bbl.ShowMessage("E278");
                        bbl.ShowMessage("E281");
                        Cursor = Cursors.Default;
                        return;
                    }
                    if (CheckPartial(dt))
                    {
                        mskup = GetEntity(dt);
                        if (mskupbl.MasterTorikomi_SKUPrice_Insert_Update(mskup))
                        {
                            bbl.ShowMessage("I101");
                        }
                        else
                        {
                            bbl.ShowMessage("E283");  // MessageBox.Show("Failed to Import");   // Changed please
                        }
                    }
                    else
                    {
                        bbl.ShowMessage("E283");
                    }
                }
            }
            catch (Exception ex)
            {

                ex.ShowMessageBox();
                CleanData();
            }
            Cursor = Cursors.Default;
        }


        private void InputExcel(OpenFileDialog file = null, bool IsClick = true)
        {
            string filePath = string.Empty;
            string fileExt = string.Empty;
            if (IsClick)
            {
                filePath = file.FileName;
                TB_FileName.Text = file.FileName;
                fileExt = Path.GetExtension(filePath);
                if (!(fileExt.CompareTo(".xls") == 0 || fileExt.CompareTo(".xlsx") == 0))
                {
                    bbl.ShowMessage("E137");
                    return;
                }
            }
            DataTable dt = ExcelToDatatable(filePath);
            if (dt != null)
            {
                dt.Columns.Add("JANCD");
                dt.Columns.Add("ColorName");
                dt.Columns.Add("SizeName");
                dt.Columns.Add("TankaName");
                dt.Columns.Add("StoreName");
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                
                    //forJanCD,ColorName,SizeName
                    if(String.IsNullOrEmpty(dt.Rows[i]["AdminNO"].ToString()))
                    {
                        dt.Rows[i]["JanCD"] = string.Empty;
                        dt.Rows[i]["ColorName"] = string.Empty;
                        dt.Rows[i]["SizeName"] = string.Empty;
                    }
                    else
                    {
                        DataRow[] result = dtSKU.Select("AdminNO = " + dt.Rows[i]["AdminNO"].ToString());
                        if (result.Count() > 0)
                        {
                            foreach (DataRow row in result)
                            {
                                //forJanCD
                                var a = row["JanCD"];
                                if(string.IsNullOrWhiteSpace(a.ToString()))
                                {
                                    dt.Rows[i]["JanCD"] = string.Empty;
                                }
                                else
                                {
                                    dt.Rows[i]["JanCD"] = a.ToString();
                                }

                                //forColorName
                                var c = row["ColorName"];
                                if (string.IsNullOrWhiteSpace(c.ToString()))
                                {
                                    dt.Rows[i]["ColorName"] = string.Empty;
                                }
                                else
                                {
                                    dt.Rows[i]["ColorName"] = c.ToString();
                                }

                                //forSizeName
                                var s = row["SizeName"];
                                if (string.IsNullOrWhiteSpace(s.ToString()))
                                {
                                    dt.Rows[i]["SizeName"] = string.Empty;
                                }
                                else
                                {
                                    dt.Rows[i]["SizeName"] = s.ToString();
                                }
                            }    
                        } 
                        else
                        {
                            dt.Rows[i]["JanCD"] = string.Empty;
                            dt.Rows[i]["ColorName"] = string.Empty;
                            dt.Rows[i]["SizeName"] = string.Empty;
                        }
                           
                    }

                    //forTankaName
                    if(String.IsNullOrWhiteSpace(dt.Rows[i]["単価設定CD"].ToString()))
                    {
                        dt.Rows[i]["TankaName"] = string.Empty;
                    }
                    else
                    {
                        DataRow[] tanka = dtTankaCD.Select("TankaCD = " + dt.Rows[i]["単価設定CD"].ToString());
                        if (tanka.Count() > 0)
                        {
                            foreach (DataRow row in tanka)
                            {
                                var t = row["TankaName"];
                                if (string.IsNullOrWhiteSpace(t.ToString()))
                                {
                                    dt.Rows[i]["TankaName"] = string.Empty;
                                }
                                else
                                {
                                    dt.Rows[i]["TankaName"] = t.ToString();
                                }
                            }
                        }
                        else
                        {
                            dt.Rows[i]["TankaName"] = string.Empty;
                        }
                    }


                    //forStoreName
                    if (String.IsNullOrWhiteSpace(dt.Rows[i]["店舗CD"].ToString()))
                    {
                        dt.Rows[i]["StoreName"] = string.Empty;
                    }
                    else if (dt.Rows[i]["店舗CD"].ToString() == "0000" )
                    {
                        dt.Rows[i]["StoreName"] = "全店";
                    }
                    else
                    {
                        DataRow[] store = dtStoreCD.Select("StoreCD = '" + dt.Rows[i]["店舗CD"].ToString() + "'");
                        if (store.Count() > 0)
                        {
                            foreach (DataRow row in store)
                            {
                                var st = row["StoreName"];
                                if (string.IsNullOrWhiteSpace(st.ToString()))
                                {
                                    dt.Rows[i]["StoreName"] = string.Empty;
                                }
                                else
                                {
                                    dt.Rows[i]["StoreName"] = st.ToString();
                                }
                            }
                        }
                        else
                        {
                            dt.Rows[i]["StoreName"] = string.Empty;
                        }
                    }


                }

                if (ErrorCheck(dt))
                {
                    ExcelErrorCheck(dt);
                    GV_SKUPrice.DataSource = null;
                    GV_SKUPrice.DataSource = dt;
                }
            }
            else
            {
                //bbl.ShowMessage("E278");
                Cursor = Cursors.Default;
                return;
            }
        }

        //private void InputExcel()
        //{
        //    if (String.IsNullOrEmpty(TB_FileName.Text))
        //    {
        //        bbl.ShowMessage("E121");
        //    }
        //    else
        //    {
        //        if (bbl.ShowMessage("Q001", "取込処理") == DialogResult.Yes)
        //        {
        //            DataTable dt = ExcelToDatatable(filePath);
        //            if (dt != null)
        //            {
        //                if (ErrorCheck(dt))
        //                {
        //                    ExcelErrorCheck(dt);
        //                    if (CheckPartial(dt))
        //                    {
        //                        mskup = GetEntity(dt);
        //                        if (mskupbl.MasterTorikomi_SKUPrice_Insert_Update(mskup))
        //                        {
        //                            bbl.ShowMessage("I101");
        //                        }
        //                    }
        //                    GV_SKUPrice.DataSource = null;
        //                    GV_SKUPrice.DataSource = dt;
        //                }
        //            }
        //            else
        //            {
        //                bbl.ShowMessage("E278");
        //                //MessageBox.Show("No row data was found or import excel is opening in different location");
        //            }
        //        }
        //    }
        //}

        private M_SKUPrice_Entity GetEntity(DataTable dtT)
        {
            mskup = new M_SKUPrice_Entity
            {
                dt1 = dtT,
                Operator = InOperatorCD,
                ProgramID = InProgramID,
                Key = filePath,
                PC = InPcID,
            };
            return mskup;
        }

        private bool ErrorCheck(DataTable dt)
        {
            if (dt.Columns.Contains("EItem") && dt.Columns.Contains("Error"))
            {
                dt.Columns.Remove("EItem");
                dt.Columns.Remove("Error");
            }
            string[] colname = {"データ区分", "単価設定CD", "店舗CD", "AdminNO", "SKUCD","商品名", "改定日","適用終了日", "税込定価", "税抜定価","一般掛率", "税込一般単価", "税抜一般単価",
                "会員掛率","税込会員単価","税抜会員単価", "外商掛率", "税込外商単価", "税抜外商単価","Sale掛率", "税込Sale単価", "税抜Sale単価", "Web掛率","税込Web単価","税抜Web単価", "備考", "削除FLG",};
            if (!ColumnCheck(colname, dt))
            {
                bbl.ShowMessage("E137");
                return false;
            }
            return true;
        }

        private bool CheckPartial(DataTable dt)
        {
            var query = "Error <> ''";
            if (dt.Select(query).Count() > 0)
                return false;
            return true;
        }
        private void CleanData()
        {
            GV_SKUPrice.DataSource = null;
            TB_FileName.Text = "";

        }

        private DataTable ExcelToDatatable(string filePath)
        {
            try
            {
                FileStream stream = File.Open(filePath, FileMode.Open, FileAccess.Read);

                string ext = Path.GetExtension(filePath);
                IExcelDataReader excelReader;
                if (ext.Equals(".xls"))
                    //1. Reading from a binary Excel file ('97-2003 format; *.xls)
                    excelReader = ExcelReaderFactory.CreateBinaryReader(stream);
                else if (ext.Equals(".xlsx"))
                    //2. Reading from a OpenXml Excel file (2007 format; *.xlsx)
                    excelReader = ExcelReaderFactory.CreateOpenXmlReader(stream);
                else
                    //2. Reading from a OpenXml Excel file (2007 format; *.xlsx) 
                    excelReader = ExcelReaderFactory.CreateCsvReader(stream, null);

                //3. DataSet - The result of each spreadsheet will be created in the result.Tables
                bool useHeaderRow = true;

                DataSet result = excelReader.AsDataSet(new ExcelDataSetConfiguration()
                {
                    ConfigureDataTable = (_) => new ExcelDataTableConfiguration()
                    {
                        UseHeaderRow = useHeaderRow,
                    }
                });
                excelReader.Close();
                return result.Tables[0];
            }
            catch
            {
                // bbl.ShowMessage("E137");
                bbl.ShowMessage("E278");
                return null;
            }
        }

        private void BT_FileName_Click(object sender, EventArgs e)
        {
            GV_SKUPrice.DataSource = null;
            string fileExt = string.Empty;
           
            if (!System.IO.Directory.Exists("C:\\SMS\\MasterShutsuryoku_SKUPrice\\"))
            {
                System.IO.Directory.CreateDirectory("C:\\SMS\\MasterShutsuryoku_SKUPrice\\");
            }
            OpenFileDialog file = new OpenFileDialog();
            file.InitialDirectory = "C:\\SMS\\MasterShutsuryoku_SKUPrice\\";
            if (file.ShowDialog() == System.Windows.Forms.DialogResult.OK)
            {
                //filePath = file.FileName; //get the path of the file  
                //TB_FileName.Text = file.FileName;
                //fileExt = Path.GetExtension(filePath); //get the file extension  
                //if (!(fileExt.CompareTo(".xls") == 0 || fileExt.CompareTo(".xlsx") == 0))
                //{

                //    //MessageBox.Show("No row data was found or import excel is opening in different location");
                //    bbl.ShowMessage("E278");
                //    return;
                //}
                //GV_SKUPrice.DataSource = null;
                InputExcel(file);
            }
        }

        protected override void EndSec()
        {
            this.Close();
        }

        protected Boolean ColumnCheck(String[] colName, DataTable dtMain)
        {
            DataColumnCollection cols = dtMain.Columns;
            for (int i = 0; i < colName.Length; i++)
            {
                if (!cols.Contains(colName[i]))
                {
                    return false;
                }
            }
            return true;
        }

        private void ExcelErrorCheck(DataTable dt)
        {
            dt.Columns.Add("EItem");
            dt.Columns.Add("Error");

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                if (String.IsNullOrEmpty(dt.Rows[i]["データ区分"].ToString()))
                {
                    dt.Rows[i]["EItem"] = "データ区分";
                    dt.Rows[i]["Error"] = "該当の値を入力・選択してください。";
                }

                if (String.IsNullOrEmpty(dt.Rows[i]["単価設定CD"].ToString()))
                {
                    dt.Rows[i]["EItem"] = "単価設定CD";
                    dt.Rows[i]["Error"] = "該当の値を入力・選択してください。";
                }
                else
                {
                    String query = " TankaCD = '" + dt.Rows[i]["単価設定CD"].ToString() + "'";

                    var result = dtTankaCD.Select(query);
                    if (result.Count() == 0)
                    {
                        dt.Rows[i]["EItem"] = "単価設定CD";
                        dt.Rows[i]["Error"] = "登録されていないコードです。";
                    }
                }

                if (String.IsNullOrEmpty(dt.Rows[i]["店舗CD"].ToString()))
                {
                    dt.Rows[i]["EItem"] = "店舗CD";
                    dt.Rows[i]["Error"] = "該当の値を入力・選択してください。";
                }
                else
                {
                    String query = " StoreCD = '" + dt.Rows[i]["店舗CD"].ToString() + "'";

                    var result = dtStoreCD.Select(query);
                    if (result.Count() == 0)
                    {
                        dt.Rows[i]["EItem"] = "店舗CD";
                        dt.Rows[i]["Error"] = "登録されていないコードです。";
                    }
                }

                if (String.IsNullOrEmpty(dt.Rows[i]["AdminNO"].ToString()))
                {
                    dt.Rows[i]["EItem"] = "AdminNO";
                    dt.Rows[i]["Error"] = "該当の値を入力・選択してください。";
                }
                else
                {
                    String query = "AdminNO = " + dt.Rows[i]["AdminNO"].ToString() + "" +
                        " and SKUCD = '" + dt.Rows[i]["SKUCD"].ToString() + "'";

                    var result = dtSKU.Select(query);
                    if (result.Count() == 0)
                    {
                        dt.Rows[i]["EItem"] = "AdminNO";
                        dt.Rows[i]["Error"] = "登録されていないコードです。";
                    }
                }

                if (String.IsNullOrEmpty(dt.Rows[i]["SKUCD"].ToString()))
                {
                    dt.Rows[i]["EItem"] = "SKUCD";
                    dt.Rows[i]["Error"] = "該当の値を入力・選択してください。";
                }

                if (String.IsNullOrEmpty(dt.Rows[i]["改定日"].ToString()))
                {
                    dt.Rows[i]["EItem"] = "改定日";
                    dt.Rows[i]["Error"] = "該当の値を入力・選択してください。";
                }

                //if (String.IsNullOrEmpty(dt.Rows[i]["改定日"].ToString()))
                //{
                //    dt.Rows[i]["EItem"] = "改定日";
                //    dt.Rows[i]["Error"] = "E102";
                //}

                if (!String.IsNullOrEmpty(dt.Rows[i]["データ区分"].ToString()))
                {
                    string d = dt.Rows[i]["データ区分"].ToString();
                    if (dt.Rows[i]["データ区分"].ToString() != "1")
                    {
                        dt.Rows[i]["EItem"] = "データ区分";
                        dt.Rows[i]["Error"] = "入力された値が正しくありません。";
                    }
                }

                if (!String.IsNullOrEmpty(dt.Rows[i]["改定日"].ToString()))
                {
                    string date = bbl.FormatDate(dt.Rows[i]["改定日"].ToString());
                    if (!bbl.CheckDate(date))
                    {
                        dt.Rows[i]["EItem"] = "改定日";
                        dt.Rows[i]["Error"] = "日付の入力が正しくありません。";
                    }
                }

                if (!String.IsNullOrEmpty(dt.Rows[i]["適用終了日"].ToString()))
                {
                    string date = bbl.FormatDate(dt.Rows[i]["適用終了日"].ToString());
                    if (!bbl.CheckDate(date))
                    {
                        dt.Rows[i]["EItem"] = "適用終了日";
                        dt.Rows[i]["Error"] = "日付の入力が正しくありません。";
                    }
                }

            }
        }

        private void MasterTorikomi_SKU_KeyUp(object sender, KeyEventArgs e)
        {
            MoveNextControl(e);
        }

        private void BT_Torikomi_Click(object sender, EventArgs e)
        {
            //InputExcel(file);
            F12();
        }
    }
}
