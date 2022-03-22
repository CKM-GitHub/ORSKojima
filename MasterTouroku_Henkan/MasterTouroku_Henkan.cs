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
using BL;
using Entity;

namespace MasterTouroku_Henkan
{
    public partial class MasterTouroku_Henkan : Base.Client.FrmMainForm
    {
        //MasterTouroku_Hanyou_BL mthbl;
        //M_Hanyou_Entity mhe;
        int type = 0; //1 = ID & Key, 2 = ID & CopyKey (for f11)

        private enum EIndex : int
        {
            TokuisakiCD,
            RCMItemName,
            RCMItemValue,
            CsvOutputItemValue,
            CsvTitleName,
        }
        private Control[] detailControls;
        private System.Windows.Forms.Control previousCtrl;
        public MasterTouroku_Henkan()
        {
            InitializeComponent();
        }

        private void MasterTouroku_Henkan_Load(object sender, EventArgs e)
        {
            InProgramID = "MasterTouroku_Henkan";
            this.InitialControlArray();
            SetFunctionLabel(EProMode.MENTE);
            StartProgram();
            ChangeMode(EOperationMode.INSERT);
            detailControls[(int)EIndex.TokuisakiCD].Focus();
        }
        private void ChangeMode(EOperationMode OperationMode)
        {
            base.OperationMode = OperationMode;
            switch (OperationMode)
            {
                case EOperationMode.INSERT:
                    //Clear(panel3);
                    //Clear(panelDetail);
                    //EnablePanel(panel3);
                    //DisablePanel(panelDetail);
                    //ScKey.SearchEnable = false;
                    //ScCopyKey.SearchEnable = false;
                    //F9Visible = false;
                    //F12Enable = true;
                    //BtnF11Show.Enabled = F11Enable = true;
                    break;
                case EOperationMode.UPDATE:
                case EOperationMode.DELETE:
                case EOperationMode.SHOW:
                    //Clear(panel3);
                    //Clear(panelDetail);
                    //EnablePanel(panel3);
                    //DisablePanel(panelDetail);
                    //ScKey.SearchEnable = true;
                    //ScCopyKey.Enabled = false;
                    //F12Enable = false;
                    //BtnF11Show.Enabled = F11Enable = true;
                    break;
            }
            TokuisakiCD.Focus();
        }

        private void InitialControlArray()
        {
            detailControls = new Control[] { TokuisakiCD, RCMItemName, RCMItemValue, CsvOutputItemValue, CsvTitleName };

           
            foreach (Control ctl in detailControls)
            {
                ctl.KeyDown += new System.Windows.Forms.KeyEventHandler(DetailControl_KeyDown);
                ctl.Enter += new System.EventHandler(DetailControl_Enter);
            }
        }
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
                    if (!ErrorCheck(index))
                        return false;

                    break;
                case (int)EIndex.RCMItemName:
                    //必須入力項目(Entry required)
                    if (!RequireCheck(new Control[] { detailControls[index] }))
                        return false;

                    break;
                case (int)EIndex.RCMItemValue:
                    //必須入力項目(Entry required)
                    if (!RequireCheck(new Control[] { detailControls[index] }))
                        return false;


                    break;
            }

            return true;

        }

        private bool ErrorCheck(int index)
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

                case (int)EIndex.RCMItemValue:
                    M_Henkan_Entity m_Henkan = new M_Henkan_Entity
                    {
                        TokuisakiCD = detailControls[(int)EIndex.TokuisakiCD].Text,
                        RCMItemName = detailControls[(int)EIndex.RCMItemName].Text,
                        RCMItemValue = detailControls[index].Text,
                    };


                    break;


            }

            return true;
        }

        protected override void EndSec()
        {
            this.Close();
        }
    }
}
