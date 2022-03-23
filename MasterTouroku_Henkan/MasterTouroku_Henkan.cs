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
        MasterTouroku_Henkan_BL mhkbl;
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
            mhkbl = new MasterTouroku_Henkan_BL();
        }

        public override void FunctionProcess(int index)
        {
            switch (index + 1)
            {
                case 2:
                    ChangeMode(EOperationMode.INSERT);
                    break;
                case 3:
                    ChangeMode(EOperationMode.UPDATE);
                    break;
                case 4:
                    ChangeMode(EOperationMode.DELETE);
                    break;
                case 5:
                    ChangeMode(EOperationMode.SHOW);
                    break;
                case 6:
                    if (bbl.ShowMessage("Q004") == DialogResult.Yes)
                    {
                        ChangeMode(OperationMode);
                       
                    }
                    else
                        PreviousCtrl.Focus();
                    break;
                case 11:
                  
                    break;
                case 12:
                    F12();
                    break;
            }
        }
        private void ChangeMode(EOperationMode OperationMode)
        {
            base.OperationMode = OperationMode;
            switch (OperationMode)
            {
                case EOperationMode.INSERT:
                case EOperationMode.UPDATE:
                case EOperationMode.DELETE:
                case EOperationMode.SHOW:
                    Clear(panel3);
                    Clear(panel2);
                    LB_Tokuisaki.Text = "";
                    CsvTitleName.Enabled = false;
                    CsvOutputItemValue.Enabled = false;
                    break;
            }
            TokuisakiCD.Focus();
        }

        private void InitialControlArray()
        {
            detailControls = new Control[] { TokuisakiCD, RCMItemName, RCMItemValue, CsvOutputItemValue, CsvTitleName ,Btn_F12};

           
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
                    if (!ErrorCheck(index))
                        return false;

                    break;
                case (int)EIndex.CsvOutputItemValue:
                    CsvTitleName.Enabled = true;
                    detailControls[(int)EIndex.CsvTitleName].Focus();
                    break;
                case (int)EIndex.CsvTitleName:

                    Btn_F12.Focus();
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
                    M_Henkan_Entity mhe = new M_Henkan_Entity
                    {
                        TokuisakiCD = detailControls[(int)EIndex.TokuisakiCD].Text,
                        RCMItemName = detailControls[(int)EIndex.RCMItemName].Text,
                        RCMItemValue = detailControls[index].Text,
                    };
                    M_Henkan_BL mhbl = new M_Henkan_BL();
                    bool res = mhbl.M_Henkan_Select(mhe);
                    switch (OperationMode)
                    {
                        case EOperationMode.INSERT:
                         if (res)
                            {
                                bbl.ShowMessage("E107");
                                return false;
                            }
                            else
                            {
                                CsvOutputItemValue.Enabled = true;
                                CsvOutputItemValue.Focus();
                            }
                            
                            break;
                        case EOperationMode.UPDATE:
                            if (res)
                            {
                                CsvOutputItemValue.Text = mhe.CsvOutputItemValue;
                                CsvTitleName.Text = mhe.CsvTitleName;
                                CsvOutputItemValue.Enabled = true;
                                CsvOutputItemValue.Focus();
                            }
                            else
                            {
                                bbl.ShowMessage("E101");
                                return false;
                            }
                            break;
                        case EOperationMode.DELETE:
                            if (res)
                            {
                                CsvOutputItemValue.Text = mhe.CsvOutputItemValue;
                                CsvTitleName.Text = mhe.CsvTitleName;
                            }
                            else
                            {
                                bbl.ShowMessage("E101");
                                return false;
                            }
                            break;
                        case EOperationMode.SHOW:
                            if (res)
                            {
                                CsvOutputItemValue.Text = mhe.CsvOutputItemValue;
                                CsvTitleName.Text = mhe.CsvTitleName;
                            }
                            else
                            {
                                bbl.ShowMessage("E101");
                                return false;
                            }
                            break;
                    }
                  
                    break;


            }

            return true;
        }
        private void InsertUpdate(int mode)
        {
            M_Henkan_Entity mhe = new M_Henkan_Entity();
            if (mhkbl.MasterTouroku_Henkan_Insert_Update(mhe, mode))
            {
                mhkbl.ShowMessage("I101");
            }
            else
            {
                mhkbl.ShowMessage("S001");
            }
        }
        protected override void EndSec()
        {
            this.Close();
        }  

        private void F12()
        {
            M_Henkan_BL mhkbl = new M_Henkan_BL();
            if (ErrorCheck(12))
            {
                if (mhkbl.ShowMessage(OperationMode == EOperationMode.DELETE ? "Q102" : "Q101") == DialogResult.Yes)
                {
                    M_Henkan_Entity mhe = new M_Henkan_Entity
                    {
                        CsvOutputItemValue = detailControls[(int)EIndex.CsvOutputItemValue].Text,
                        CsvTitleName = detailControls[(int)EIndex.CsvTitleName].Text
                    };
                    switch (OperationMode)
                    {
                        case EOperationMode.INSERT:
                           
                            break;
                        case EOperationMode.UPDATE:
                           
                            break;
                        case EOperationMode.DELETE:
                           
                            break;
                    }
                }
                else
                    PreviousCtrl.Focus();
            }
        }
    }
}
