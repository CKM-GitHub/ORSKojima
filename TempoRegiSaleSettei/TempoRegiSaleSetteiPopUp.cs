using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Entity;
using BL;
using Base.Client;

namespace TempoRegiSaleSettei
{
    public partial class TempoRegiSaleSetteiPopUp : Form
    {
        M_Sale_Entity mse;
        Base_BL bbl;
        TempoRegiSaleSettei_BL sbl;
        string date;
        string StoreCD;
        DataTable dt = new DataTable();
        public TempoRegiSaleSetteiPopUp(DataTable dt1)
        {
            InitializeComponent();
            mse = new M_Sale_Entity();
            sbl = new TempoRegiSaleSettei_BL();
            bbl = new Base_BL();
            dt = dt1;
            //txtStartSaleDate.Text = message;
            //StoreCD = storeCD;
        }
        private void TempoRegiSaleSetteiPopUp_Load(object sender, EventArgs e)
        {
            ShowDetail();
        }
        private void ShowDetail()
        {
            //date = txtStartSaleDate.Text;
            //dt = sbl.M_Sale_SelectByStartDate(StoreCD, date);
            if (dt.Rows.Count > 0)
            {
                txtStartSaleDate.Text = dt.Rows[0]["StartDate"].ToString();
                txtEndSaleDate.Text = dt.Rows[0]["EndDate"].ToString();
                if (dt.Rows[0]["SaleFlg"].ToString() == "1")
                {
                    RadioButton1.Checked = true;
                }
                else if (dt.Rows[0]["SaleFlg"].ToString() == "2")
                {
                    RadioButton1.Checked = true;
                }
                else
                {
                    RadioButton1.Checked = true;
                }
                txtGeneralSaleRate.Text = dt.Rows[0]["GeneralSaleRate"].ToString();
                txtMemberSaleRate.Text = dt.Rows[0]["MemberSaleRate"].ToString();
                txtClientSaleRate.Text = dt.Rows[0]["ClientSaleRate"].ToString();
                if (dt.Rows[0]["GeneralSaleFraction"].ToString() == "1")
                {
                    RadioButton3.Checked = true;
                }
                else if (dt.Rows[0]["GeneralSaleFraction"].ToString() == "2")
                {
                    RadioButton4.Checked = true;
                }
                else if (dt.Rows[0]["GeneralSaleFraction"].ToString() == "3")
                {
                    RadioButton5.Checked = true;
                }
                else
                {
                    RadioButton3.Checked = true;
                }
            }
            else
            {
                bbl.ShowMessage("E128");
                txtStartSaleDate.Clear();
            }
        }
       
        private void ckM_Button1_Click(object sender, EventArgs e)
        {
            this.Close();
        }
    }
}
