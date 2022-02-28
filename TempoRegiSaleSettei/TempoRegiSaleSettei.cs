using Base.Client;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using BL;
using Entity;

namespace TempoRegiSaleSettei
{
    public partial class TempoRegiSaleSettei : ShopBaseForm
    {
        TempoRegiSaleSettei_BL salebl;
        M_Sale_Entity mse;
        DataTable dt;
        DataTable dtCopy;
        string date;
        string date1;
        string storeCD;
        string storeName;
        string strDate;
        public TempoRegiSaleSettei()
        {
            InitializeComponent();
            salebl = new TempoRegiSaleSettei_BL();
            dt = new DataTable();
            dtCopy = new DataTable();
        }
        private void TempoRegiSaleSettei_Load(object sender, EventArgs e)
        {
            InProgramID = "TempoRegiSaleSettei";
            this.Text = "店舗レジセール設定";
            StartProgram();
            storeName = StoreName;
            SetRequireField();
            DisplayData();
            txtStartSalePeriodDate.Focus();
        }
        private void SetRequireField()
        {
            txtStartSalePeriodDate.Require(true);
            txtEndSalePeriodDate.Require(true);
            txtStartSalePeriodDate.Clear();
            txtEndSalePeriodDate.Clear();
            txtGeneralSaleRate.Clear();
            txtMemberSaleRate.Clear();
            txtClientSaleRate.Clear();
        }
        private void DisplayData()
        {
            storeCD = StoreCD;
            date = ChangeDate;
            dt = salebl.M_Sale_Select(storeCD, date);
            dtCopy = dt.Copy();
            if(dt.Rows.Count>0)
            {
                txtStartSalePeriodDate.Text = dt.Rows[0]["StartDate"].ToString();
                txtEndSalePeriodDate.Text= dt.Rows[0]["EndDate"].ToString();
                if(dt.Rows[0]["SaleFlg"].ToString() == "1")
                {
                    rdobtn1.Checked = true;
                }
                else if (dt.Rows[0]["SaleFlg"].ToString() == "2")
                {
                    rdobtn2.Checked = true;
                }
                else
                {
                    rdobtn1.Checked = true;
                }
                txtGeneralSaleRate.Text= dt.Rows[0]["GeneralSaleRate"].ToString();
                txtMemberSaleRate.Text= dt.Rows[0]["MemberSaleRate"].ToString();
                txtClientSaleRate.Text = dt.Rows[0]["ClientSaleRate"].ToString();
                if (dt.Rows[0]["GeneralSaleFraction"].ToString() == "1")
                {
                    rdobtn3.Checked = true;
                }
                else if (dt.Rows[0]["GeneralSaleFraction"].ToString() == "2")
                {
                    rdobtn4.Checked = true;
                }
                else if (dt.Rows[0]["GeneralSaleFraction"].ToString() == "3")
                {
                    rdobtn5.Checked = true;
                }
                else
                {
                    rdobtn3.Checked = true;
                }
            }
        }
        protected override void EndSec()
        {
            this.Close();
        }
        private bool ErrorCheck()
        {
            if (!RequireCheck(new Control[] { txtStartSalePeriodDate, txtEndSalePeriodDate }))
                return false;
            if ((!bbl.CheckDate(txtStartSalePeriodDate.Text)))
            {
                bbl.ShowMessage("E103");
                txtStartSalePeriodDate.Focus();
                return false;
            }
            storeCD = StoreCD;
            date1 = txtStartSalePeriodDate.Text;
            DataTable dtErrorCheck = new DataTable();
            dtErrorCheck = salebl.M_Sale_ErrorCheck(storeCD, date1);
            if (dtErrorCheck.Rows.Count > 0)
            {
                bbl.ShowMessage("E292");
                txtStartSalePeriodDate.Focus();
                return false;
            }
            if ((!bbl.CheckDate(txtEndSalePeriodDate.Text)))
            {
                bbl.ShowMessage("E103");
                txtEndSalePeriodDate.Focus();
                return false;
            }
            if (!string.IsNullOrWhiteSpace(txtStartSalePeriodDate.Text) && !string.IsNullOrWhiteSpace(txtEndSalePeriodDate.Text))
            {
                if (string.Compare(txtStartSalePeriodDate.Text, txtEndSalePeriodDate.Text) == 1)
                {
                    bbl.ShowMessage("E104");
                    txtEndSalePeriodDate.Focus();
                    return false;
                }
            }
            date = ChangeDate;
            if (string.Compare(txtEndSalePeriodDate.Text, date) != 1)
            {
                bbl.ShowMessage("E123");
                txtEndSalePeriodDate.Focus();
                return false;
            }
            if (txtGeneralSaleRate.Text.Contains("-"))
            {
                bbl.ShowMessage("E109");
                txtGeneralSaleRate.Focus();
                return false;
            }
            if (txtMemberSaleRate.Text.Contains("-"))
            {
                bbl.ShowMessage("E109");
                txtMemberSaleRate.Focus();
                return false;
            }
            if (txtClientSaleRate.Text.Contains("-"))
            {
                bbl.ShowMessage("E109");
                txtClientSaleRate.Focus();
                return false;
            }
            return true;
        }
        public override void FunctionProcess(int index)
        {
            switch (index + 1)
            {
                case 2:
                    if (ErrorCheck())
                    {
                        if (!String.IsNullOrEmpty(strDate))
                        {
                            if (chkDelete.Checked == false)
                            {
                                mse = GetSaleEntity();
                                if (bbl.ShowMessage("Q101") == DialogResult.Yes)
                                {
                                    if (salebl.M_Sale_Insert_Update(mse, storeCD, "1",strDate))
                                    {
                                        salebl.ShowMessage("I101");
                                        CopyData();
                                        txtStartSalePeriodDate.Focus();
                                    }
                                }
                            }
                            else if (chkDelete.Checked == true)
                            {
                                mse = GetSaleEntity();
                                if (bbl.ShowMessage("Q102") == DialogResult.Yes)
                                {
                                    if (salebl.M_Sale_Insert_Update(mse, storeCD, "2",strDate))
                                    {
                                        salebl.ShowMessage("I102");
                                        CopyData();
                                        txtStartSalePeriodDate.Focus();
                                    }
                                }
                            }
                        }
                    }
                    break;
            }
        }
        private void CopyData()
        {
            dtCopy = dt.Copy();
            if (dtCopy.Rows.Count > 0)
            {
                txtStartSalePeriodDate.Text = dtCopy.Rows[0]["StartDate"].ToString();
                txtEndSalePeriodDate.Text = dtCopy.Rows[0]["EndDate"].ToString();
                if (dtCopy.Rows[0]["SaleFlg"].ToString() == "1")
                {
                    rdobtn1.Checked = true;
                }
                else if (dtCopy.Rows[0]["SaleFlg"].ToString() == "2")
                {
                    rdobtn2.Checked = true;
                }
                else
                {
                    rdobtn1.Checked = true;
                }
                txtGeneralSaleRate.Text = dtCopy.Rows[0]["GeneralSaleRate"].ToString();
                txtMemberSaleRate.Text = dtCopy.Rows[0]["MemberSaleRate"].ToString();
                txtClientSaleRate.Text = dtCopy.Rows[0]["ClientSaleRate"].ToString();
                if (dtCopy.Rows[0]["GeneralSaleFraction"].ToString() == "1")
                {
                    rdobtn3.Checked = true;
                }
                else if (dtCopy.Rows[0]["GeneralSaleFraction"].ToString() == "2")
                {
                    rdobtn4.Checked = true;
                }
                else if (dtCopy.Rows[0]["GeneralSaleFraction"].ToString() == "3")
                {
                    rdobtn5.Checked = true;
                }
                else
                {
                    rdobtn3.Checked = true;
                }
                chkDelete.Checked = true;
            }
        }
        public M_Sale_Entity GetSaleEntity()
        {
            mse = new M_Sale_Entity
            {
                StoreCD = StoreCD,
                StartDate = txtStartSalePeriodDate.Text.Replace("/", "-"),
                //StartDate=strDate,
                EndDate = txtEndSalePeriodDate.Text.Replace("/", "-"),
                SaleFlg= Check(),
                GeneralSaleRate = txtGeneralSaleRate.Text,
                MemberSaleRate = txtMemberSaleRate.Text,
                ClientSaleRate = txtClientSaleRate.Text,
                GeneralSaleFraction = CheckValue(),
                MemberSaleFraction = CheckValue(),
                ClientSaleFraction = CheckValue(),
                InsertOperator = InOperatorCD,
                ProgramID = InProgramID,
                Key = txtStartSalePeriodDate.Text + " " + txtEndSalePeriodDate.Text+" "+ storeName.ToString(),
                PC = InPcID,
            };
            return mse;
        }
        private int Check()
        {
             if (rdobtn1.Checked == true)
                 return 1;
            else if (rdobtn2.Checked == true)
                 return 2;

            return 0;
        }
        private int CheckValue()
        {
            if (rdobtn3.Checked == true)
                return 1;
            else if (rdobtn4.Checked == true)
                return 2;
            else if (rdobtn5.Checked == true)
                return 3;
            return 0;
        }
        private void TempoRegiSaleSettei_KeyUp(object sender, KeyEventArgs e)
        {
            MoveNextControl(e);
        }
        private void txtStartSalePeriodDate_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
            {
                storeCD = StoreCD;
                date = txtStartSalePeriodDate.Text;
                DataTable dtErrorCheck = new DataTable();
                dtErrorCheck = salebl.M_Sale_ErrorCheck(storeCD, date);
                if (dtErrorCheck.Rows.Count > 0)
                {
                    bbl.ShowMessage("E292");
                    txtStartSalePeriodDate.Focus();
                }
            }
        }
        private void txtEndSalePeriodDate_KeyDown(object sender, KeyEventArgs e)
        {
            if(e.KeyCode==Keys.Enter)
            {
                if (!string.IsNullOrWhiteSpace(txtStartSalePeriodDate.Text) && !string.IsNullOrWhiteSpace(txtEndSalePeriodDate.Text))
                {
                    if (string.Compare(txtStartSalePeriodDate.Text, txtEndSalePeriodDate.Text) == 1)
                    {
                        bbl.ShowMessage("E104");
                        txtEndSalePeriodDate.Focus();
                        return;
                    }
                }
                if (string.Compare(txtEndSalePeriodDate.Text, date) != 1)
                {
                    bbl.ShowMessage("E123");
                    txtEndSalePeriodDate.Focus();
                    return;
                }
                storeCD = StoreCD;
                date = ChangeDate;
                dt = salebl.M_Sale_Select(storeCD, date);
                if (dt.Rows.Count > 0)
                {
                   if (dt.Rows[0]["StartDate"].ToString() == txtStartSalePeriodDate.Text && dt.Rows[0]["EndDate"].ToString() == txtEndSalePeriodDate.Text)
                   {
                       chkDelete.Checked = false;
                   }
                }
            }
        }
        private void txtGeneralSaleRate_KeyDown(object sender, KeyEventArgs e)
        {
            if(e.KeyCode==Keys.Enter)
            {
                if (txtGeneralSaleRate.Text.Contains("-"))
                {
                    bbl.ShowMessage("E109");
                    txtGeneralSaleRate.Focus();
                }
            }
            
        }
        private void txtMemberSaleRate_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
            {
                if (txtMemberSaleRate.Text.Contains("-"))
                {
                    bbl.ShowMessage("E109");
                    txtMemberSaleRate.Focus();
                }
            }
        }
        private void txtClientSaleRate_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
            {
                if (txtClientSaleRate.Text.Contains("-"))
                {
                    bbl.ShowMessage("E109");
                    txtClientSaleRate.Focus();
                }
            }
        }
        public DataTable dt1
        {
            get
            {
                return dt1;
            }
        }
        private void ckM_Button1_Click(object sender, EventArgs e)
        {
            DataTable dt1 = new DataTable();
            date = txtStartSalePeriodDate.Text;
            dt1 = salebl.M_Sale_SelectByStartDate(StoreCD, date);
            if (dt1.Rows.Count>0)
            {
                strDate = dt1.Rows[0]["StartDate1"].ToString();
                TempoRegiSaleSetteiPopUp pop = new TempoRegiSaleSetteiPopUp(dt1);
                pop.ShowDialog();
            }
            else
            {
                bbl.ShowMessage("E128");
                txtStartSalePeriodDate.Focus();
            }
        }
        private void chkDelete_CheckedChanged(object sender, EventArgs e)
        {
            if(chkDelete.Checked==true)
            {
                CopyData();
                txtStartSalePeriodDate.Focus();
            }
        }
       
    }
}
