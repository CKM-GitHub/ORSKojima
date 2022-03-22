using System;
using System.Data;
using System.Diagnostics;
using System.IO;
using System.Windows.Forms;
using System.Linq;
using System.Text;
using BL;
using Entity;
using Base.Client;


namespace ExhibitHistory
{
    /// <summary>
    /// ExhibitHistory 出品履歴照会
    /// </summary>
    internal partial class ExhibitHistory : FrmMainForm
    {
        private const string ProID = "ExhibitHistory";
        private const string ProNm = "出品履歴照会";

        private enum EIndex : int
        {
            TokuisakiCD,
            BrandName,
            ItemName1,
            ItemName2,
            ItemCode1,
            ItemCode2,
            ItemCode3,
            ItemCode4,
            ItemCode5,
            GrossProfit,
            Discount,
        }

        private enum EColNo : int
        {
            CheckBox,     //
            Item_Code,
            Item_Name,
            List_Price,
            Price,
            Cost,
            GrossProfit,
            Discount,
            hiddenID,
            hiddenBrand_Name
        }

        private Control[] detailControls;

        private ExhibitInformation_BL eibl;
        private D_ShoppingCart_Entity dse;
        DataTable dtData;

        private System.Windows.Forms.Control previousCtrl; // ｶｰｿﾙの元の位置を待避        


        public ExhibitHistory()
        {
            InitializeComponent();
            dtData = new DataTable();
        }

        private void Form_Load(object sender, EventArgs e)
        {
            try
            {
                InProgramID = ProID;
                InProgramNM = ProNm;

                this.SetFunctionLabel(EProMode.OUTPUT);
                this.InitialControlArray();

                //起動時共通処理
                base.StartProgram();

                eibl = new ExhibitInformation_BL();
                Scr_Clr(0);

                detailControls[(int)EIndex.TokuisakiCD].Focus(); 
            }
            catch (Exception ex)
            {
                //エラー時共通処理
                MessageBox.Show(ex.Message);
                EndSec();

            }
        }

        private void InitialControlArray()
        {
            detailControls = new Control[] { TB_Tokuisaki, TB_BrandName, TB_ItemName1, TB_ItemName2, TB_ItemCode1, TB_ItemCode2, TB_ItemCode3, TB_ItemCode4, TB_ItemCode5, TB_GrossProfit, TB_Discount };

            //イベント付与
            foreach (Control ctl in detailControls)
            {
                ctl.KeyDown += new System.Windows.Forms.KeyEventHandler(DetailControl_KeyDown);
                ctl.Enter += new System.EventHandler(DetailControl_Enter);
            }
        }
        
        /// <summary>
        /// 入力コードチェック
        /// </summary>
        /// <param name="index"></param>
        /// <returns></returns>
        private bool CheckDetail(int index)
        {
            if (detailControls[index].GetType().Equals(typeof(CKM_Controls.CKM_TextBox)))
            {
                if (((CKM_Controls.CKM_TextBox)detailControls[index]).isMaxLengthErr)
                    return false;
            }

            switch (index)
            {
                case (int)EIndex.TokuisakiCD:
                    //必須入力項目(Entry required)
                    if (!RequireCheck(new Control[] { detailControls[index] }))
                        return false;

                    //得意先マスタINVチェック
                    if (!CheckMaster(index))
                        return false;

                    break;
            }

            return true;

        }

        /// <summary>
        /// 入力項目 マスタチェック
        /// </summary>
        /// <returns></returns>
        private bool CheckMaster(int index)
        {
            switch (index)
            {
                case (int)EIndex.TokuisakiCD:
                    //[M_Tokuisaki]INVCheck
                    M_Tokuisaki_Entity mte = new M_Tokuisaki_Entity
                    {
                        TokuisakiCD = detailControls[index].Text
                    };
                    Tokuisaki_BL bl = new Tokuisaki_BL();
                    bool ret = bl.M_Tokuisaki_Select(mte);
                    if (ret)
                    {
                        LB_Tokuisaki.Text = mte.TokuisakiName;
                    }
                    else
                    {
                        bbl.ShowMessage("E101");
                        return false;
                    }

                    break;
            }

            return true;
        }

        /// <summary>
        /// 全選択・全キャンセルボタン押下時処理
        /// </summary>
        /// <param name="check"></param>
        private void CheckOnOffDetail(bool check)
        {
            //ITEM 一時テーブル
            foreach (DataRow dr in dtData.Rows)
            {
                dr["CheckTaishou"] = check ? "1" : "0";
            }
        }

        /// <summary>
        /// D_ShoppingCart 全削除処理
        /// </summary>
        protected override void ExecDelete()
        {
            try 
            {
                //画面条件に関わらず全データ削除
                if (bbl.ShowMessage("Q107") == DialogResult.Yes)
                {
                    //更新処理
                    bool ret = eibl.PRC_ExhibitInformation_Delete();

                    if (ret)
                        bbl.ShowMessage("I102");
                    else
                        bbl.ShowMessage("S001");

                    Scr_Clr(0);
                    detailControls[(int)EIndex.TokuisakiCD].Focus();
                }
                else
                {
                    detailControls[(int)EIndex.TokuisakiCD].Focus();
                }
            }
            catch (Exception ex)
            {
                //エラー時共通処理
                MessageBox.Show(ex.Message);
                //EndSec();
            }

        }

        /// <summary>
        /// 画面表示処理
        /// </summary>
        protected override void ExecDisp()
        {
            try
            {
                for (int i = 0; i < detailControls.Length; i++)
                if (CheckDetail(i) == false)
                {
                    detailControls[i].Focus();
                    return;
                }

                //画面表示処理
                dse = GetEntity();
                dtData = new DataTable();
                dtData = eibl.PRC_ExhibitInformation_SelectDataForDisp(dse);

                GvDetail.DataSource = dtData;

                if (dtData.Rows.Count > 0)
                {
                    GvDetail.Focus();
                }
                else
                {
                    bbl.ShowMessage("E128");
                    detailControls[(int)EIndex.TokuisakiCD].Focus();
                }
            }
            catch (Exception ex)
            {
                //エラー時共通処理
                MessageBox.Show(ex.Message);
                //EndSec();
            }

        }

        /// <summary>
        /// CSV出力・データ更新処理
        /// </summary>
        protected override void ExecOutput()
        {
            try
            {
                //入力項目のチェック(ヘッダー部はいつでも入力可な為)
                for (int i = 0; i < detailControls.Length; i++)
                    if (CheckDetail(i) == false)
                    {
                        detailControls[i].Focus();
                        return;
                    }


                //対象明細があるかチェック
                //チェックONのみ取得
                DataRow[] chkDt = dtData.AsEnumerable()
                        .Where(x => x["CheckTaishou"].ToString() == "1").ToArray();

                if (chkDt.Length == 0)
                {
                    //E216
                    bbl.ShowMessage("E216");
                    return;
                }

                //Q211	
                if (bbl.ShowMessage("Q211") != DialogResult.Yes)
                    return;

                //対象データをDataTable型に変換
                DataTable dtRegist = chkDt.CopyToDataTable();

                //CSV用データを取得
                DataTable dtCsv = eibl.PRC_ExhibitInformation_SelectDataForCSV(dse, dtRegist);

                //CSV出力処理
                if (this.OutputCSV(dtCsv))
                {
                    bool ret = true;

                    if (dtCsv.Rows.Count != 0)
                    { 
                        //出品履歴データ（D_ExhibitHistory）更新処理
                        //更新処理
                        ret = eibl.PRC_ExhibitInformation_Register(dse, dtRegist);
                    }
                    if (ret)
                        bbl.ShowMessage("I002");
                    else
                        bbl.ShowMessage("S002");
                    

                    this.Scr_Clr(0);
                    detailControls[(int)EIndex.TokuisakiCD].Focus();
                }

            }
            catch (Exception ex)
            {
                //エラー時共通処理
                MessageBox.Show(ex.Message);
            }
}

        /// <summary>
        /// 画面情報をセット
        /// </summary>
        /// <returns></returns>
        private D_ShoppingCart_Entity GetEntity()
        {
            dse = new D_ShoppingCart_Entity();

            dse.TokuisakiCD = detailControls[(int)EIndex.TokuisakiCD].Text;
            dse.Brand_Name = detailControls[(int)EIndex.BrandName].Text;
            dse.Item_Name1 = detailControls[(int)EIndex.ItemName1].Text;
            dse.Item_Name2 = detailControls[(int)EIndex.ItemName2].Text;
            dse.Item_Code1 = detailControls[(int)EIndex.ItemCode1].Text;
            dse.Item_Code2 = detailControls[(int)EIndex.ItemCode2].Text;
            dse.Item_Code3 = detailControls[(int)EIndex.ItemCode3].Text;
            dse.Item_Code4 = detailControls[(int)EIndex.ItemCode4].Text;
            dse.Item_Code5 = detailControls[(int)EIndex.ItemCode5].Text;
            dse.ArariRate = detailControls[(int)EIndex.GrossProfit].Text;
            dse.WaribikiRate = detailControls[(int)EIndex.Discount].Text;

            dse.Operator = InOperatorCD;
            dse.PC = InPcID;

            return dse;
        }

        /// <summary>
        /// 画面クリア(0:全項目、1:KEY部以外)
        /// </summary>
        /// <param name="Kbn"></param>
        private void Scr_Clr(short Kbn)
        {
            if (Kbn == 0)
            {
                foreach (Control ctl in detailControls)
                {
                    if (ctl.GetType().Equals(typeof(CKM_Controls.CKM_CheckBox)))
                    {
                        ((CheckBox)ctl).Checked = false;
                    }
                    else
                    {
                        ctl.Text = "";
                    }
                }
                LB_Tokuisaki.Text = "";

                GvDetail.DataSource = null;
                dtData.Clear();
            }
        }

        /// <summary>
        /// handle f1 to f12 click event
        /// implement base virtual function
        /// </summary>
        /// <param name="Index"></param>
        public override void FunctionProcess(int Index)
        {
            base.FunctionProcess(Index);

            switch (Index)
            {
                case 0:     //F1:終了
                case 1:     //F2:新規
                case 2:     //F3:変更
                case 3:     //F4:削除
                case 4:     //F5:照会
                    {
                        break;
                    }

                case 5: //F6:キャンセル
                    if (bbl.ShowMessage("Q004") == DialogResult.Yes)
                    {
                        Scr_Clr(0);
                    }
                    detailControls[(int)EIndex.TokuisakiCD].Focus();
                    break;


            }   //switch end

        }

        /// <summary>
        /// CSV出力処理
        /// </summary>
        /// <param name="dtRegist"></param>
        /// <returns></returns>
        private bool OutputCSV(DataTable dt)
        {

            bool ret = false;
            try
            {
                string strFullPath;

                using (SaveFileDialog saveFileDialog = new SaveFileDialog())
                {
                    // ファイルの種類リストを設定
                    saveFileDialog.FileName = ProNm + " " + DateTime.Now.ToString("yyyyMMdd_HHmmss") + " " + InOperatorCD;
                    saveFileDialog.Filter = "CSVファイル (*.CSV)|*.CSV";
                    saveFileDialog.RestoreDirectory = true;

                    // ダイアログを表示
                    DialogResult dialogResult = saveFileDialog.ShowDialog();
                    if (dialogResult == DialogResult.Cancel)
                    {
                        // キャンセルされたので終了
                        return ret;
                    }

                    // 選択されたファイル名 (ファイルパス) をテキストボックスに設定
                    strFullPath = saveFileDialog.FileName;
                }



                // CSV出力処理                        
                string field = string.Empty;

                // CSVファイルに書き込むときに使うEncoding
                System.Text.Encoding enc = System.Text.Encoding.GetEncoding("Shift_JIS");
                using (StreamWriter sw = new StreamWriter(strFullPath, false, enc))
                {

                    foreach (DataRow row in dt.Rows)
                    {
                        // 
                        for (int i = 0; i < dt.Columns.Count; i++)
                        {
                            if (i != 0)　　// 1つめの項目は行番号なので除外する
                            { 
                                field += EncloseDoubleQuotesIfNeed(row[i].ToString());
                                if (i < dt.Columns.Count - 1)
                                {
                                    field += ",";
                                }
                            }
                        };

                        sw.Write(field);
                        sw.Write("\r\n");
                        field = "";

                    }
                }
                ret = true;

 //               bbl.ShowMessage("I201");

                return ret;
            }

            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }

            return ret;

        }

        private string EncloseDoubleQuotesIfNeed(string field)
        {
            if (NeedEncloseDoubleQuotes(field))
            {
                return EncloseDoubleQuotes(field);
            }
            return field;
        }

        /// <summary>
        /// 文字列をダブルクォートで囲む
        /// </summary>
        private string EncloseDoubleQuotes(string field)
        {
            if (field.IndexOf('"') > -1)
            {
                //"を""とする
                field = field.Replace("\"", "\"\"");
            }
            return "\"" + field + "\"";
        }

        /// <summary>
        /// 文字列をダブルクォートで囲む必要があるか調べる
        /// </summary>
        private bool NeedEncloseDoubleQuotes(string field)
        {
            return field.IndexOf('"') > -1 ||
                field.IndexOf(',') > -1 ||
                field.IndexOf('\r') > -1 ||
                field.IndexOf('\n') > -1 ||
                field.StartsWith(" ") ||
                field.StartsWith("\t") ||
                field.EndsWith(" ") ||
                field.EndsWith("\t");


        }
        // ==================================================
        // 終了処理
        // ==================================================
        protected override void EndSec()
        {
            this.Close();
            //アプリケーションを終了する
            //Application.Exit();
            //System.Environment.Exit(0);
        }

        #region "内部イベント"

        private void DetailControl_KeyDown(object sender, KeyEventArgs e)
        {
            try
            {
                //Enterキー押下時処理
                //Returnキーが押されているか調べる
                //AltかCtrlキーが押されている時は、本来の動作をさせる
                if ((e.KeyCode == Keys.Return) &&
                        ((e.KeyCode & (Keys.Alt | Keys.Control)) == Keys.None))
                {
                    int index = Array.IndexOf(detailControls, sender);
                    bool ret = CheckDetail(index);

                    if (ret)
                    {
                        //detailControls[index + 1].Focus();
                        if (detailControls.Length - 1 > index)
                        {
                            if (detailControls[index + 1].CanFocus)
                                detailControls[index + 1].Focus();
                            else
                                //あたかもTabキーが押されたかのようにする
                                //Shiftが押されている時は前のコントロールのフォーカスを移動
                                ProcessTabKey(!e.Shift);
                        }
                        else
                        {
                            ProcessTabKey(!e.Shift);
                        }
                    }
                    else
                    {
                        ((Control)sender).Focus();
                    }
                }
            }

            catch (Exception ex)
            {
                //エラー時共通処理
                MessageBox.Show(ex.Message);
                //EndSec();
            }
        }

        private void DetailControl_Enter(object sender, EventArgs e)
        {
            try
            {
                previousCtrl = this.ActiveControl;
            }

            catch (Exception ex)
            {
                //エラー時共通処理
                MessageBox.Show(ex.Message);
            }
        }
       
        /// <summary>
        /// 表示ボタン押下時処理
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void BtnSubF8_Click(object sender, EventArgs e)
        {
            //表示ボタンClick時   
            try
            {
                base.FunctionProcess(FuncDisp - 1);

            }
            catch (Exception ex)
            {
                //エラー時共通処理
                MessageBox.Show(ex.Message);
                //EndSec();
            }
        }

        /// <summary>
        /// 全選択ボタン押下時処理
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void Btn_SelectAll_Click(object sender, EventArgs e)
        {
            try
            {
                //新規登録時のみ、使用可
                CheckOnOffDetail(true);
            }
            catch (Exception ex)
            {
                //エラー時共通処理
                MessageBox.Show(ex.Message);
            }
        }

        /// <summary>
        /// 全キャンセルボタン押下時処理
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void Btn_NoSelect_Click(object sender, EventArgs e)
        {
            try
            {
                //新規登録時のみ、使用可
                CheckOnOffDetail(false);
            }
            catch (Exception ex)
            {
                //エラー時共通処理
                MessageBox.Show(ex.Message);
            }
        }

        private void GvDetail_DataError(object sender, DataGridViewDataErrorEventArgs e)
        {
            try
            {

            }
            catch
            {
                e.Cancel = false;
            }
        }

        private void GvDetail_CurrentCellChanged(object sender, EventArgs e)
        {
            try
            {
                var dgv = (DataGridView)sender;
                if (dgv.IsCurrentCellDirty)
                {
                    dgv.CommitEdit(DataGridViewDataErrorContexts.Commit);
                }
            }
            catch (Exception ex)
            {
                //エラー時共通処理
                MessageBox.Show(ex.Message);
            }
        }


        private void GvDetail_CurrentCellDirtyStateChanged(object sender, EventArgs e)
        {
            if (GvDetail.CurrentCellAddress.X == 0 && GvDetail.IsCurrentCellDirty)
            {
                //コミットする
                GvDetail.CommitEdit(DataGridViewDataErrorContexts.Commit);
            }
        }

        #endregion
    }
}








