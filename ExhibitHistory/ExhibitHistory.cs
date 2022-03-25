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
            ExhibitDate1,
            ExhibitDate2,
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
            ExhibitDate,     //
            Item_Code,
            Item_Name,
            List_Price,
            Price,
            Cost,
            GrossProfit,
            Discount,
            TokuisakiName
        }

        private Control[] detailControls;

        private ExhibitHistory_BL ehbl;
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

                this.SetFunctionLabel(EProMode.SHOW);
                this.InitialControlArray();

                //起動時共通処理
                base.StartProgram();

                ehbl = new ExhibitHistory_BL();
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
            detailControls = new Control[] { TB_Tokuisaki, TB_ExhibitDate1, TB_ExhibitDate2, TB_BrandName, TB_ItemName1, TB_ItemName2, TB_ItemCode1, TB_ItemCode2, TB_ItemCode3, TB_ItemCode4, TB_ItemCode5, TB_GrossProfit, TB_Discount };

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

                case (int)EIndex.ExhibitDate1:
                case (int)EIndex.ExhibitDate2:
                    //入力必須項目(Entry required)
                    if (!RequireCheck(new Control[] { detailControls[index] }))
                        return false;

                    if (!CheckDate(index))
                    {
                        bbl.ShowMessage("E104");
                        detailControls[(int)EIndex.ExhibitDate2].Focus();
                        return false;
                    }

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
                        // 得意先名は30バイトで切る
                        LB_Tokuisaki.Text = ehbl.LeftB(mte.TokuisakiName,30);
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

        private bool CheckDate(int index)
        {
            switch (index)
            {
                case (int)EIndex.ExhibitDate1:
                    break;

                case (int)EIndex.ExhibitDate2:
                    //日付大小チェック
                    DateTime dt1 = Convert.ToDateTime(TB_ExhibitDate1.Text);
                    DateTime dt2 = Convert.ToDateTime(TB_ExhibitDate2.Text);

                    if (dt1 > dt2)
                        return false;

                    break;
            }

            return true;

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
                dtData = ehbl.PRC_ExhibitHistory_SelectDataForDisp(dse);

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
        /// 画面情報をセット
        /// </summary>
        /// <returns></returns>
        private D_ShoppingCart_Entity GetEntity()
        {
            dse = new D_ShoppingCart_Entity();

            dse.TokuisakiCD = detailControls[(int)EIndex.TokuisakiCD].Text;
            dse.ExhibitDate1 = detailControls[(int)EIndex.ExhibitDate1].Text;
            dse.ExhibitDate2 = detailControls[(int)EIndex.ExhibitDate2].Text;
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








