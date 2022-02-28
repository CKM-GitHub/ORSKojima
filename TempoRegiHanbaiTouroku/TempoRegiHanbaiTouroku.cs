using Base.Client;
using BL;
using DL;
using Entity;
using EPSON_TM30;
using Microsoft.VisualBasic;
using Search;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms;
using static Base.Client.FrmMainForm;

namespace TempoRegiHanbaiTouroku
{
    public partial class TempoRegiHanbaiTouroku : ShopBaseForm
    {
        private const string TempoRegiZaikoKakunin = "TempoRegiZaikoKakunin.exe";
        private EPSON_TM30.LineDisplayManager LineDisp = new EPSON_TM30.LineDisplayManager();

        private enum meCol : short
        {
            ALL
            , CUSTOMER
            , SALESNO
            , JANCD
            , TANKA
            , SURYO
        }
        private TempoRegiHanbaiTouroku_BL tprg_Hanbai_Bl = new TempoRegiHanbaiTouroku_BL();
        private DataTable dtSales;      //明細部データ
        private DataTable dtBottunDetails;
        private DataTable dtBottunGroup;
        private D_Sales_Entity dse;
        private D_StorePayment_Entity dspe;
        private Base.Client.FrmMainForm.EOperationMode OperationMode;
        private string mParStoreCD;
        private int mParSaleRate;
        private int mAge;
        private short mHaspoMode;
        private short mSaleMode;
        private string mCustomerDate;

        private string mJuchuuHontaiGaku;
        private string mProperTanka;
        private string mProperGaku;
        private int mZeiritsu;
        private int mTaxRateFLG;
        private int mSaleExcludedFlg;
        private string mPriceWithTax;
        private string mJANCD;
        private string mAdminNO;
        private string mSKUCD;
        private string mSKUName;
        private string mDiscountKBN;
        private decimal mSalesHontaiGaku0;
        private decimal mSalesHontaiGaku8;
        private decimal mSalesHontaiGaku10;
        private decimal mSalesTax8;
        private decimal mSalesTax10;
        private decimal mDiscount;
        private decimal mDiscount8;
        private decimal mDiscount10;
        private decimal mDiscountTax;
        private decimal mDiscountTax8;
        private decimal mDiscountTax10;
        private string mUnitPriceCustomerCD;
        private decimal mTeiseimaeSalesGaku;

        private List<CKM_Controls.CKMShop_Label> listGyoSelect;
        private List<CKM_Controls.CKMShop_Label> listGyo;
        private List<CKM_Controls.CKMShop_Label> listSKUName;
        private List<CKM_Controls.CKMShop_Label> listSKUName2nd;
        private List<CKM_Controls.CKMShop_Label> listColorSize;
        private List<CKM_Controls.CKMShop_Label> listTanka;
        private List<CKM_Controls.CKMShop_Label> listSu;
        private List<CKM_Controls.CKMShop_Label> listKingaku;
        private int mDetailCount = 0;
        private const int cBottunDetailCount = 7;
        private const int cBottunGroupCount = 7;


        private class StoreDefaultCustomer
        {
            public string IppanCD { get; set; }
            public string KaiinCD { get; set; }
            public string GaishoCD { get; set; }
            public string SaleCD { get; set; }
        }
        private StoreDefaultCustomer mStoreDefaultCustomer = new StoreDefaultCustomer();

        public TempoRegiHanbaiTouroku()
        {
            InitializeComponent();
            btnProcess2.Click += new System.EventHandler(base.Btn_Click);
            btnProcess2.MouseEnter += new System.EventHandler(base.btnClose_MouseEnter);

            listGyoSelect = new List<CKM_Controls.CKMShop_Label> { lblGyoSelect1, lblGyoSelect2, lblGyoSelect3, lblGyoSelect4, lblGyoSelect5, lblGyoSelect6 };
            listGyo = new List<CKM_Controls.CKMShop_Label> { lblDtGyo1, lblDtGyo2, lblDtGyo3, lblDtGyo4, lblDtGyo5, lblDtGyo6 };
            listSKUName = new List<CKM_Controls.CKMShop_Label> { lblDtSKUName1, lblDtSKUName2, lblDtSKUName3, lblDtSKUName4, lblDtSKUName5, lblDtSKUName6 };
            listSKUName2nd = new List<CKM_Controls.CKMShop_Label> { lblDtSKUName2nd1, lblDtSKUName2nd2, lblDtSKUName2nd3, lblDtSKUName2nd4, lblDtSKUName2nd5, lblDtSKUName2nd6 };
            listColorSize = new List<CKM_Controls.CKMShop_Label> { lblDtColorSize1, lblDtColorSize2, lblDtColorSize3, lblDtColorSize4, lblDtColorSize5, lblDtColorSize6 };
            listTanka = new List<CKM_Controls.CKMShop_Label> { lblDtTanka1, lblDtTanka2, lblDtTanka3, lblDtTanka4, lblDtTanka5, lblDtTanka6 };
            listSu = new List<CKM_Controls.CKMShop_Label> { lblDtSu1, lblDtSu2, lblDtSu3, lblDtSu4, lblDtSu5, lblDtSu6 };
            listKingaku = new List<CKM_Controls.CKMShop_Label> { lblDtKingaku1, lblDtKingaku2, lblDtKingaku3, lblDtKingaku4, lblDtKingaku5, lblDtKingaku6 };
            mDetailCount = listGyo.Count;
        }

        private void TempoRegiHanbaiTouroku_Load(object sender, EventArgs e)
        {
            try
            {
                InProgramID = "TempoRegiHanbaiTouroku";
                StartProgram();

                //btnProcess.Text = "入金へ";
                SetRequireField();
                AddHandler();
                lblSumSalesGaku.Font_Size = CKM_Controls.CKMShop_Label.CKM_FontSize.XXLarge;
                //コマンドライン引数を配列で取得する
                string[] cmds = System.Environment.GetCommandLineArgs();
                if (cmds.Length - 1 > (int)ECmdLine.PcID)
                {
                    mParStoreCD = cmds[(int)ECmdLine.PcID + 1];   //
                    //    if (cmds.Length - 1 > (int)ECmdLine.PcID+1)
                    //    {
                    //        //セール率。10％引きなら10、20％引きなら20．Haspo、1月20日の初売り対応。
                    //        mParSaleRate = cmds[(int)ECmdLine.PcID + 2];
                    //    }
                }
                else
                {
                    //M_StaffよりStoreCDを取得
                    mParStoreCD = StoreCD;
                }

                //ハスポモードか否か（0 or 1)
                M_Control_Entity mce = new M_Control_Entity();
                mce.MainKey = "1";
                mHaspoMode = Convert.ToInt16(tprg_Hanbai_Bl.GetHaspoMode(mce));

                //Saleモードの判断
                mSaleMode = 0;
                //HaspoMode＝1の場合
                if (mHaspoMode.Equals(1))
                {
                    //【M_MultiPorpose】
                    M_MultiPorpose_Entity me = new M_MultiPorpose_Entity();
                    MultiPorpose_BL bl = new MultiPorpose_BL();
                    bool ret = bl.M_MultiPorpose_SaleModeSelect(me);
                    if (ret)
                    {
                        //Select出来た場合、Saleモード＝１とする
                        mSaleMode = 1;
                    }
                }

                //初期表示用の会員番号を取得
                SelectDefaultCustomer();

                InitScr();

                if (Base_DL.iniEntity.IsDM_D30Used)
                {
                    if (!PosUtility.IsPOSInstalled(out string msg))
                    {
                        if (msg != "") bbl.ShowMessage(msg);
                    }

                    if (LineDisp.Open(out string errorMsg))
                    {
                        LineDisp.DisplayMarquee(Base_DL.iniEntity.DefaultMessage);
                    }
                }
            }
            catch (Exception ex)
            {
                //エラー時共通処理
                MessageBox.Show(ex.Message + ex.StackTrace);
                EndSec();
            }
        }

        private void TempoRegiHanbaiTouroku_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (Base_DL.iniEntity.IsDM_D30Used)
            {
                LineDisp.Dispose();
            }
        }

        private IEnumerable<Control> GetAllControls(Control root)
        {
            foreach (Control control in root.Controls)
            {
                foreach (Control child in GetAllControls(control))
                {
                    yield return child;
                }
            }
            yield return root;
        }

        private void Clear(Panel panel)
        {
            IEnumerable<Control> c = GetAllControls(panel);
            foreach (Control ctrl in c)
            {
                if (ctrl is Label)
                    ((Label)ctrl).Text = string.Empty;

                if (ctrl is Button)
                    ((Button)ctrl).Text = string.Empty;

                ctrl.Tag = "";
            }
        }

        private void SetRequireField()
        {
            txtCustomerNo.Require(true);
            txtJanCD.Require(true);
            txtJuchuuUnitPrice.Require(true);
            txtSu.Require(true);
        }

        private void SetEnabled(bool enabled, bool isOnlyCustomer = false)
        {
            txtCustomerNo.Enabled = enabled;
            btnCustomerNo.Enabled = enabled;
            btnKBNGenkin.Enabled = enabled;
            btnKBNKaiin.Enabled = enabled;
            btnKBNGaisho.Enabled = enabled;
            btnKBNSale.Enabled = enabled;
            btnMoveToCustomer.Enabled = enabled;
            if (isOnlyCustomer) return;

            txtJanCD.Enabled = enabled;
            btnSyohin.Enabled = enabled;
            txtJuchuuUnitPrice.Enabled = enabled;
            btnTanka.Enabled = enabled;
            txtSu.Enabled = enabled;
            tableLayoutPanel3.Enabled = enabled;
            tableLayoutPanel2.Enabled = enabled;
            btnOk.Enabled = enabled;
            btnHenpin.Enabled = enabled;
            btnMoveToJANCD.Enabled = enabled;
            btnMoveToTanka.Enabled = enabled;
            btnMoveToSu.Enabled = enabled;
        }

        private void AddHandler()
        {
            foreach (Control ctl in tableLayoutPanel2.Controls)
            {
                ctl.Click += new System.EventHandler(this.BtnGroup_Click);
            }
            foreach (Control ctl in tableLayoutPanel3.Controls)
            {
                ctl.Click += new System.EventHandler(this.BtnSyo_Click);
            }
        }

        private void DispFromSalesNO(string salesNo = "")
        {
            //【Data Area】
            CheckData_M_StoreButtonDetailes();

            M_StoreBottunGroup_Entity msg = new M_StoreBottunGroup_Entity()
            {
                StoreCD = mParStoreCD,
                ProgramKBN = "1"
            };
            StoreBottunGroup_BL sgbl = new StoreBottunGroup_BL();
            dtBottunGroup = sgbl.M_StoreButtonGroup_SelectAll(msg);

            DispFromButtonGroupTable();

            //【D_Sales_Select】
            D_Sales_Entity dse2 = new D_Sales_Entity()
            {
                SalesNO = salesNo
            };

            //【D_StorePayment】
            dspe = new D_StorePayment_Entity()
            {
                StoreCD = mParStoreCD,
                SalesNO = txtSalesNO.Text
            };

            dtSales = tprg_Hanbai_Bl.D_Sales_SelectForRegi(dse2, (short)OperationMode);

            if (!string.IsNullOrWhiteSpace(salesNo))
            {
                if (dtSales.Rows.Count == 0)
                {
                    bbl.ShowMessage("E138", "売上番号");
                    return;
                }
                if (!string.IsNullOrWhiteSpace(dtSales.Rows[0]["DeleteDateTime"].ToString()))
                {
                    bbl.ShowMessage("E140", "売上番号");
                    return;
                }
                if (!dtSales.Rows[0]["StoreCD"].ToString().Equals(mParStoreCD))
                {
                    //違う店舗の場合、エラー
                    bbl.ShowMessage("E139", "売上番号");
                    return;
                }

                txtSalesNO.Tag = dtSales.Rows[0]["JuchuuNO"].ToString();

                txtSalesNO.Enabled = false;
                //btnClose.Text = "クリア";
                //btnClose.Tag = "2";

                //エラーでない場合、処理選択画面を表示
                FrmSelect frm = new FrmSelect();
                frm.ShowDialog();
                int select = frm.btnSelect;
                lblKeijobi.Text = frm.keijobi;

                switch (select)
                {
                    case 1:
                        //訂正ボタンの場合
                        //訂正モードとする
                        lblHenpin.Text = "訂正";
                        lblHenpin.Visible = true;
                        btnHenpin.Visible = false;
                        OperationMode = FrmMainForm.EOperationMode.UPDATE;
                        //顧客CDのみ変更不可、他の各項目の入力は可能
                        SetEnabled(false, true);

                        break;

                    case 2:
                        //取消ボタンの場合
                        //取消モードとする
                        lblHenpin.Text = "取消";
                        lblHenpin.Visible = true;
                        btnHenpin.Visible = false;
                        OperationMode = FrmMainForm.EOperationMode.DELETE;
                        //各項目の入力は不可
                        SetEnabled(false);

                        //第二画面の決定ボタンで、取消更新処理を実行
                        //btnProcess.Focus();
                        btnProcess2.Focus();
                        break;
                }

                txtCustomerNo.Text = dtSales.Rows[0]["CustomerCD"].ToString();
                mAge = Convert.ToInt16(dtSales.Rows[0]["Age"]);

                //[M_Customer_Select]
                M_Customer_Entity mce = new M_Customer_Entity
                {
                    CustomerCD = txtCustomerNo.Text,
                    ChangeDate = dtSales.Rows[0]["SalesDate"].ToString()
                };
                Customer_BL sbl = new Customer_BL();
                bool ret = sbl.M_Customer_Select(mce);
                if (ret)
                {
                    lblCusName.Text = mce.CustomerName;
                }
                else
                {
                    lblCusName.Text = "";
                }
                lblPoint.Text = bbl.Z_SetStr(mce.LastPoint);
                if (mce.CustomerKBN.Equals("2") || mce.PointFLG.Equals("0"))    //TaskNo3220 HET
                {
                    lblPoint.Text = "";
                }
                //TaskNo3279 S.Akao
                if (txtCustomerNo.Text == mStoreDefaultCustomer.IppanCD || txtCustomerNo.Text == mStoreDefaultCustomer.KaiinCD
                || txtCustomerNo.Text == mStoreDefaultCustomer.GaishoCD || txtCustomerNo.Text == mStoreDefaultCustomer.SaleCD)
                {
                    lblPoint.Text = "";
                }

                mCustomerDate = mce.ChangeDate;

                lblStoreTankaKBN.Text = GetStoreTankaKBNName(mce.StoreTankaKBN);

                //【D_StorePayment】
                ret = tprg_Hanbai_Bl.D_StorePayment_Select(dspe);

            }

            //【Data Area Detail】
            DispFromDataTable();

            //【Data Area】
            SetDataFromDataTable();

            CalcKin();

            //訂正前金額を保持
            if (OperationMode == EOperationMode.UPDATE)
            {
                mTeiseimaeSalesGaku = lblSumSalesGaku.Text.ToDecimal(0);
            }
        }

        private void DispFromDataTable(int gyoNo = 1)
        {
            if (dtSales.Rows.Count == gyoNo - 1)
            {
                if (gyoNo - mDetailCount > 0)
                    DispFromDataTable(gyoNo - mDetailCount);

                if (dtSales.Rows.Count == 0)
                    Clear(pnlDetails);

                return;
            }

            Clear(pnlDetails);

            for (int i = 0; i < mDetailCount; i++)
            {
                int index = gyoNo - 1 + i;

                if (dtSales.Rows.Count <= index)
                    break;

                DataRow row = dtSales.Rows[index];

                listGyo[i].Text = (index + 1).ToString();
                string skuName = row["SKUName"].ToString();
                listSKUName[i].Text = skuName.GetByteString(52);
                listSKUName2nd[i].Text = skuName.GetByteString(52, 52);
                listColorSize[i].Text = row["ColorSizeName"].ToString();
                listTanka[i].Text = "\\" + bbl.Z_SetStr(row["SalesUnitPrice"]);
                listSu[i].Text = bbl.Z_SetStr(row["SalesSU"]);
                listKingaku[i].Text = "\\" + bbl.Z_SetStr(row["SalesGaku"]);
            }
        }

        private void CalcKin()
        {
            string ymd = bbl.GetDate();

            //税抜販売額←入力された単価から税抜計算×数量	
            //Function_消費税計算.out税込単価
            var juchuuUnitPrice = bbl.Z_Set(txtJuchuuUnitPrice.Text);
            if (juchuuUnitPrice < 0)
            {
                mJuchuuHontaiGaku = bbl.Z_SetStr(bbl.GetZeinukiKingaku(Math.Abs(juchuuUnitPrice), mTaxRateFLG, ymd) * -1 * bbl.Z_Set(txtSu.Text));
            }
            else
            {
                mJuchuuHontaiGaku = bbl.Z_SetStr(bbl.GetZeinukiKingaku(juchuuUnitPrice, mTaxRateFLG, ymd) * bbl.Z_Set(txtSu.Text));
            }
            //if (mSaleExcludedFlg == 1)
            //{
            //}
            //else
            //{
            //    //入力された単価から税抜計算×数量×（100－Parameter.SaleRate）÷100
            //    mJuchuuHontaiGaku = bbl.Z_SetStr(GetResultWithHasuKbn((int)HASU_KBN.SISYAGONYU, bbl.Z_Set( mJuchuuHontaiGaku) * (100- bbl.Z_Set(mParSaleRate)) /100));
            //}
            //お買上額←入力された単価×数量
            lblSalesGaku.Text = string.Format("{0:#,##0}", bbl.Z_Set(txtJuchuuUnitPrice.Text) * bbl.Z_Set(txtSu.Text));

            //うち税額←お買上額－税抜販売額
            lblSalesTax.Text = bbl.Z_SetStr(bbl.Z_Set(lblSalesGaku.Text) - bbl.Z_Set(mJuchuuHontaiGaku));

            //本来額←	本来単価×	数量			
            mProperGaku = bbl.Z_SetStr(bbl.Z_Set(mProperTanka) * bbl.Z_Set(txtSu.Text));

            //画面右下のお買上額に、今回の商品のお買上額、うち税額を加算
            int rowNum = -1;
            decimal kin = 0;
            decimal zei = 0;
            int su = 0;

            foreach (DataRow row in dtSales.Rows)
            {
                ////一旦クリア
                row["Discount"] = 0;
                //row["Discount10"] = 0;
                //row["Discount8"] = 0;
                //row["Discount0"] = 0;
                //row["DiscountTax10"] = 0;
                //row["DiscountTax8"] = 0;
                //row["SalesHontaiGaku10"] = 0;
                //row["SalesHontaiGaku8"] = 0;
                //row["SalesHontaiGaku0"] = 0;
                //row["SalesTax10"] = 0;
                //row["SalesTax8"] = 0;

                int sign = 1;
                if (row["DiscountKBN"].ToString().Equals("1"))
                {
                    sign = -1;
                    row["Discount"] = sign * bbl.Z_Set(row["SalesGaku"]);
                }

                kin = kin + bbl.Z_Set(row["SalesGaku"]);
                zei = zei + bbl.Z_Set(row["SalesTax"]);
                su = su + row["SalesSU"].ToInt32(0);

                //switch (row["SalesTaxRitsu"])
                //{
                //    case 10:
                //        row["SalesHontaiGaku10"] = sign*( bbl.Z_Set(row["SalesGaku"]) - bbl.Z_Set(row["SalesTax"]));
                //        row["SalesTax10"] = sign * bbl.Z_Set(row["SalesTax"]);

                //        if (sign.Equals(-1))
                //        {
                //            row["Discount10"] = row["SalesHontaiGaku10"];
                //            row["DiscountTax10"] = row["SalesTax10"];
                //        }
                //        break;
                //    case 8:
                //        row["SalesHontaiGaku8"] = sign * (bbl.Z_Set(row["SalesGaku"]) - bbl.Z_Set(row["SalesTax"]));
                //        row["SalesTax8"] = sign * bbl.Z_Set(row["SalesTax"]);

                //        if (sign.Equals(-1))
                //        {
                //            row["Discount8"] = row["SalesHontaiGaku8"];
                //            row["DiscountTax8"] = row["SalesTax8"];
                //        }
                //        break;

                //    default:
                //        row["SalesHontaiGaku0"] = sign * (bbl.Z_Set(row["SalesGaku"]) - bbl.Z_Set(row["SalesTax"]));
                //        if (sign.Equals(-1))
                //        {
                //            row["Discount0"] = row["SalesHontaiGaku0"];
                //        }
                //        break;
                //}
            }

            if (string.IsNullOrWhiteSpace(txtJanCD.Tag.ToString()))
            {
                decimal wKin = bbl.Z_Set(lblSalesGaku.Text);
                decimal wZei = bbl.Z_Set(lblSalesTax.Text);
                //まだDataTableに追加していないデータ
                if (mDiscountKBN.Equals("1"))
                {
                    mDiscount += wKin;
                    mDiscountTax += wZei;

                    switch (mZeiritsu)
                    {
                        case 10:
                            mDiscount10 = wKin - wZei;
                            mDiscountTax10 += wZei;
                            break;
                        case 8:
                            mDiscount8 += wKin - wZei;
                            mDiscountTax8 = wZei;
                            break;

                        default:
                            mSalesHontaiGaku0 = wKin - wZei;
                            break;
                    }
                    wKin = -1 * wKin;
                    wZei = -1 * wZei;
                }

                kin += wKin;
                zei += wZei;
                su += txtSu.Text.ToInt32(0);

                switch (mZeiritsu)
                {
                    case 10:
                        mSalesHontaiGaku10 = wKin - wZei;
                        mSalesTax10 = wZei;
                        break;
                    case 8:
                        mSalesHontaiGaku8 = wKin - wZei;
                        mSalesTax8 = wZei;
                        break;

                    default:
                        mSalesHontaiGaku0 = wKin - wZei;
                        break;
                }
            }
            lblSumSalesGaku.Text = bbl.Z_SetStr(kin);
            lblSumSalesTax.Text = bbl.Z_SetStr(zei);
            lblSumSu.Text = bbl.Z_SetStr(su);
        }

        private void SetDataFromDataTable(int gyoNo = 1)
        {
            int index = gyoNo - 1;

            if (dtSales.Rows.Count <= index)
                return;

            DataRow row = dtSales.Rows[index];

            mAdminNO = row["AdminNO"].ToString();
            txtJanCD.Text = row["JanCD"].ToString();
            mJANCD = row["JanCD"].ToString();
            txtJanCD.Tag = index;   //選択行の行番号を退避
            mSKUCD = row["SKUCD"].ToString();
            mSKUName = row["SKUName"].ToString();
            ErrorCheck(meCol.JANCD, false);

            mDiscountKBN = row["DiscountKBN"].ToString();
            mSaleExcludedFlg = Convert.ToInt16(row["SaleExcludedFlg"]);

            txtJanCD.Tag = index;   //選択行の行番号を退避
            lblSKUName.Text = mSKUName.GetByteString(52);
            lblSKUName2.Text = mSKUName.GetByteString(52, 52);
            lblColorSize.Text = row["ColorSizeName"].ToString();
            txtJuchuuUnitPrice.Text = bbl.Z_SetStr(row["SalesUnitPrice"]);
            txtSu.Text = bbl.Z_SetStr(row["SalesSU"]);
            lblSalesGaku.Text = bbl.Z_SetStr(row["SalesGaku"]);
            lblSalesTax.Text = bbl.Z_SetStr(row["SalesTax"]);
            lblJuchuuTaxRitsu.Text = bbl.Z_SetStr(row["SalesTaxRitsu"]) + "%";
            mZeiritsu = Convert.ToInt16(row["SalesTaxRitsu"]);
            mProperTanka = bbl.Z_SetStr(bbl.Z_Set(row["ProperGaku"]) / bbl.Z_Set(row["SalesSU"]));
            mProperGaku = bbl.Z_SetStr(row["ProperGaku"]);
            mUnitPriceCustomerCD = row["CustomerCD"].ToString();
        }

        private void CheckData_M_StoreButtonDetailes(string GroupNO = "")
        {
            M_StoreBottunDetails_Entity msb = new M_StoreBottunDetails_Entity();
            msb.StoreCD = mParStoreCD;
            msb.ProgramKBN = "1";
            msb.GroupNO = GroupNO;

            StoreButtonDetails_BL sbl = new StoreButtonDetails_BL();
            dtBottunDetails = sbl.M_StoreButtonDetails_SelectAll(msb);

            DispFromButtonDetailsTable();
        }

        private void DispFromButtonDetailsTable(int stHorizontal = 1)
        {
            int maxVertical = stHorizontal + cBottunDetailCount;
            DataRow[] rows = dtBottunDetails.Select(" Horizontal >=" + stHorizontal + " AND Horizontal <" + maxVertical);

            Clear(tableLayoutPanel3);

            foreach (DataRow row in rows)
            {
                string Horizontal = row["Horizontal"].ToString();
                string Vertical = row["Vertical"].ToString();

                int index = Convert.ToInt16(Horizontal) - stHorizontal + 1;

                //btnSyoをさがす。子コントロールも検索する。
                Control[] cs = this.Controls.Find("btnSyo" + index.ToString() + Vertical, true);
                if (cs.Length > 0)
                {
                    cs[0].Text = row["BottunName"].ToString();

                    //会員選択時、MasterKBN<>2:顧客 の場合はクリックしても何も行わない
                    //商品選択時、MasterKBN<>1:JANCD の場合はクリックしても何も行わない
                    switch (row["MasterKBN"].ToString())
                    {
                        case "1":
                            cs[0].Tag = "1_" + row["JANCD"].ToString();
                            break;
                        case "2":
                            cs[0].Tag = "2_" + row["CustomerCD"].ToString();
                            break;
                        default:
                            cs[0].Tag = "";
                            break;
                    }
                }
            }
            btnSyoDown.Tag = stHorizontal;
        }

        private void DispFromButtonGroupTable(int stHorizontal = 1)
        {
            int maxGroupNO = stHorizontal + cBottunGroupCount;
            DataRow[] rows = dtBottunGroup.Select(" GroupNO >=" + stHorizontal + " AND GroupNO <" + maxGroupNO);

            //if (rows.Length == 0)
            //    return;

            Clear(tableLayoutPanel2);

            btnGrp1.Tag = stHorizontal;

            foreach (DataRow row in rows)
            {
                int GroupNO = Convert.ToInt16(row["GroupNO"]);
                int index = GroupNO - stHorizontal + 1;

                //btnGrpをさがす。子コントロールも検索する。
                Control[] cs = this.Controls.Find("btnGrp" + index.ToString(), true);
                if (cs.Length > 0)
                {
                    cs[0].Text = row["BottunName"].ToString();
                    cs[0].Tag = row["GroupNO"].ToString();
                }
            }

        }

        protected override void EndSec()
        {
            this.Close();
        }

        private void ExecOK(KeyEventArgs e = null)
        {
            if (OperationMode == EOperationMode.INSERT || OperationMode == EOperationMode.SHOW || OperationMode == EOperationMode.UPDATE)
            {
                if (!Save()) return;
            }
            else
            {

            }
            if (bbl.Z_Set(txtJuchuuUnitPrice.Text) == 0)
            {
                if (bbl.ShowMessage("Q326") != DialogResult.Yes)
                {
                    txtJuchuuUnitPrice.Focus();
                    return;
                }
            }

            //今の入力内容を画面右横のリストに表示。
            DataRow row;
            if (string.IsNullOrWhiteSpace(txtJanCD.Tag.ToString()))
            {
                if (bbl.Z_Set(txtSu.Text) == 0)
                {
                    txtSu.Focus();
                    return;
                }

                row = dtSales.NewRow();
                row["SalesRows"] = dtSales.Rows.Count + 1;

                if (bbl.Z_Set(lblDtGyo1.Text) + mDetailCount < dtSales.Rows.Count)
                {
                    lblDtGyo1.Text = (dtSales.Rows.Count + 1 - (mDetailCount - 1)).ToString();
                }
                else
                {
                    if (bbl.Z_Set(lblDtGyo1.Text) == 0)
                    {
                        lblDtGyo1.Text = "1";
                    }
                }
            }
            else
            {
                int index = Convert.ToInt16(txtJanCD.Tag);
                row = dtSales.Rows[index];
            }

            row["CustomerCD"] = txtCustomerNo.Text;
            row["JanCD"] = txtJanCD.Text;
            row["AdminNO"] = mAdminNO;
            row["SKUCD"] = mSKUCD;
            row["SKUName"] = mSKUName;
            row["ColorSizeName"] = lblColorSize.Text;
            row["SalesSU"] = bbl.Z_Set(txtSu.Text);
            row["SalesUnitPrice"] = bbl.Z_Set(txtJuchuuUnitPrice.Text);
            row["SalesGaku"] = bbl.Z_Set(lblSalesGaku.Text.Replace("\\", ""));
            row["SalesTax"] = bbl.Z_Set(lblSalesTax.Text.Replace("\\", ""));
            row["SalesHontaiGaku"] = bbl.Z_Set(row["SalesGaku"]) - bbl.Z_Set(row["SalesTax"]);
            row["SalesTaxRitsu"] = mZeiritsu;
            row["ProperGaku"] = mProperGaku;

            row["Discount"] = mDiscount;
            row["Discount10"] = mDiscount10;
            row["Discount8"] = mDiscount8;
            row["Discount0"] = mDiscount;
            row["DiscountTax10"] = mDiscountTax10;
            row["DiscountTax8"] = mDiscountTax8;
            row["SalesHontaiGaku10"] = mSalesHontaiGaku10;
            row["SalesHontaiGaku8"] = mSalesHontaiGaku8;
            row["SalesHontaiGaku0"] = mSalesHontaiGaku0;
            row["SalesTax10"] = mSalesTax10;
            row["SalesTax8"] = mSalesTax8;

            row["DiscountKBN"] = mDiscountKBN;
            row["SaleExcludedFlg"] = mSaleExcludedFlg;

            if (string.IsNullOrWhiteSpace(txtJanCD.Tag.ToString()))
            {
                dtSales.Rows.InsertAt(row, dtSales.Rows.Count);
            }
            else if (bbl.Z_Set(txtSu.Text) == 0)
            {
                int deleteRow = Convert.ToInt16(row["SalesRows"]);

                //削除した行以降のデータのSalesRowsを一つずつずらす
                DataRow[] dataRows = dtSales.Select("SalesRows > " + deleteRow.ToString(), "SalesRows");

                dtSales.Rows.Remove(row);

                int count = 0;
                foreach (DataRow dataRow in dataRows)
                {
                    dataRow["SalesRows"] = deleteRow + count;
                    count++;
                }
            }

            DispFromDataTable(Convert.ToInt16(lblDtGyo1.Text));

            string leftVal = txtJuchuuUnitPrice.Text;
            string rightVal = txtSu.Text;

            /// ptk
            //JANCD、数量、他の項目をクリア
            ClearScr();

            ClearBackColor(pnlDetails);

            //ディスプレイに、お買上計を表示（都度、表示）
            CalcKin();
            Show_Display(leftVal, rightVal);
            txtJanCD.Focus();

        }

        private void Show_Display(string leftVal, string rightVal)
        {
            if (Base_DL.iniEntity.IsDM_D30Used)
            {
                string upperLiteral = leftVal + "円" + " x " + rightVal;
                string lowerLiteral = "合計" + "     " + lblSumSalesGaku.Text + "円";

                LineDisp.DisplayText(upperLiteral, lowerLiteral);
            }
        }

        private bool CheckDecimalFraction(string value)
        {
            if (value.IndexOf(".") > 0)
            {
                bbl.ShowMessage("E118");
                return false;
            }
            return true;
        }

        private bool ErrorCheck(meCol kbn = meCol.ALL, bool set = false)
        {
            string ymd = bbl.GetDate();

            if (kbn == meCol.ALL || kbn == meCol.CUSTOMER)
            {
                if (mUnitPriceCustomerCD != txtCustomerNo.Text)
                {
                    mUnitPriceCustomerCD = "";
                }

                //会員番号
                //必須入力(Entry required)、入力なければエラー(If there is no input, an error)Ｅ１０２
                if (!RequireCheck(new Control[] { txtCustomerNo }))
                {
                    return false;
                }

                lblCusName.Text = "";
                lblPoint.Text = "";
                lblStoreTankaKBN.Text = "";

                //得意先マスター(M_Customer)に存在すること
                //[M_Customer_Select]
                M_Customer_Entity mce = new M_Customer_Entity
                {
                    CustomerCD = txtCustomerNo.Text,
                    ChangeDate = ymd
                };
                Customer_BL sbl = new Customer_BL();
                if (!sbl.M_Customer_Select(mce))
                {
                    bbl.ShowMessage("E101");
                    txtCustomerNo.Focus();
                    return false;
                }
                if (mce.DeleteFlg == "1")
                {
                    bbl.ShowMessage("E101");
                    txtCustomerNo.Focus();
                    return false;
                }

                lblCusName.Text = mce.CustomerName;
                lblPoint.Text = bbl.Z_SetStr(mce.LastPoint);
                if (mce.CustomerKBN.Equals("2") || mce.PointFLG.Equals("0"))    //TaskNo3220 HET
                {
                    lblPoint.Text = "";
                }
                //TaskNo3279 S.Akao
                if (txtCustomerNo.Text == mStoreDefaultCustomer.IppanCD || txtCustomerNo.Text == mStoreDefaultCustomer.KaiinCD
                || txtCustomerNo.Text == mStoreDefaultCustomer.GaishoCD || txtCustomerNo.Text == mStoreDefaultCustomer.SaleCD)
                {
                    lblPoint.Text = "";
                }

                mCustomerDate = mce.ChangeDate;

                lblStoreTankaKBN.Text = GetStoreTankaKBNName(mce.StoreTankaKBN);

                //単価取得処理（JANCDを入力した後に会員番号を入力した場合の対応）
                if (mUnitPriceCustomerCD != txtCustomerNo.Text)
                {
                    ReSetDetailUnitPrice();
                    if (mAdminNO.Length > 0 && txtJanCD.Text.Length > 0)
                    {
                        SetUnitPrice();
                    }
                    else
                    {
                        mUnitPriceCustomerCD = txtCustomerNo.Text;
                    }
                }
            }
            if (kbn == meCol.SALESNO)
            {
                //お買上番号
                //入力された場合
                if (string.IsNullOrWhiteSpace(txtSalesNO.Text))
                {
                    return true;
                }

                //画面転送表01 に沿って画面表示
                DispFromSalesNO(txtSalesNO.Text);
            }
            if (kbn == meCol.ALL || kbn == meCol.SURYO)
            {
                //数量
                //入力必須(Entry required)
                if (!RequireCheck(new Control[] { txtSu }))
                {
                    return false;
                }
                if (!CheckDecimalFraction(txtSu.Text))
                {
                    txtSu.Focus();
                    return false;
                }
                txtSu.Text = bbl.Z_SetStr(txtSu.Text);

                CalcKin();
            }

            if (kbn == meCol.ALL || kbn == meCol.TANKA)
            {
                //単価
                //必須入力(Entry required)、入力なければエラー(If there is no input, an error)Ｅ１０２
                if (!RequireCheck(new Control[] { txtJuchuuUnitPrice }))
                {
                    return false;
                }
                if (!CheckDecimalFraction(txtJuchuuUnitPrice.Text))
                {
                    txtJuchuuUnitPrice.Focus();
                    return false;
                }
                //お買上額等の計算を行う
                CalcKin();
            }

            if (kbn == meCol.ALL || kbn == meCol.JANCD)
            {
                //JANCD欄で会員バーコードを読み込んだときの対応
                if (txtCustomerNo.Enabled && txtJanCD.Text.Length > 0)
                {
                    //入力値が得意先マスター(M_Customer)に存在する場合はJANCDではなく会員番号と判断する
                    if (new Customer_BL().M_Customer_Select(new M_Customer_Entity() { CustomerCD = txtJanCD.Text, ChangeDate = ymd }))
                    {
                        txtCustomerNo.Text = txtJanCD.Text;
                        txtJanCD.Text = "";
                        txtCustomerNo.Focus();
                        SendKeys.Send("{ENTER}");
                        return false;
                    }
                }

                //JANCD 入力必須(Entry required)
                if (!RequireCheck(new Control[] { txtJanCD }))
                {
                    return false;
                }

                if (!CheckWidth(1))
                    return false;

                if (!CheckWidth(2))
                    return false;

                //JANCDが変更された場合はAdminNOをクリア
                if (!mJANCD.Equals(txtJanCD.Text))
                {
                    mAdminNO = "";
                    btnTanka.Enabled = true;
                }
                //入力がある場合、SKUマスターに存在すること
                //[M_SKU]
                M_SKU_Entity mse = new M_SKU_Entity
                {
                    JanCD = txtJanCD.Text,
                    AdminNO = mAdminNO,
                    SetKBN = "0",
                    ChangeDate = ymd
                };

                SKU_BL mbl = new SKU_BL();
                DataTable dt = mbl.M_SKU_SelectAll(mse);
                DataRow selectRow = null;

                if (dt.Rows.Count == 0)
                {
                    //Ｅ１０１
                    bbl.ShowMessage("E101");
                    return false;
                }
                else if (dt.Rows.Count == 1)
                {
                    selectRow = dt.Rows[0];
                }
                else
                {
                    //JANCDでSKUCDが複数存在する場合（If there is more than one）
                    using (TempoRegiSelect_SKU frmSKU = new TempoRegiSelect_SKU())
                    {
                        frmSKU.parJANCD = dt.Rows[0]["JanCD"].ToString();
                        frmSKU.parChangeDate = ymd;
                        frmSKU.ShowDialog();

                        if (!frmSKU.flgCancel)
                        {
                            selectRow = dt.Select(" AdminNO = " + frmSKU.parAdminNO)[0];
                        }
                    }

                }

                if (selectRow != null)
                {
                    mTaxRateFLG = Convert.ToInt16(selectRow["TaxRateFLG"].ToString());
                    mPriceWithTax = selectRow["PriceWithTax"].ToString();
                    mDiscountKBN = selectRow["DiscountKBN"].ToString();

                    //変更なしの場合は再セットしない
                    if (mAdminNO.Equals(selectRow["AdminNO"].ToString()) && set == false)
                        return true;

                    //JANCDでSKUCDが１つだけ存在する場合（If there is only one）
                    mAdminNO = selectRow["AdminNO"].ToString();
                    mJANCD = selectRow["JANCD"].ToString();
                    mSKUCD = selectRow["SKUCD"].ToString();
                    mSKUName = selectRow["SKUName"].ToString();
                    lblSKUName.Text = mSKUName.GetByteString(52);
                    lblSKUName2.Text = mSKUName.GetByteString(52, 52);
                    lblColorSize.Text = selectRow["ColorName"].ToString() + " " + selectRow["SizeName"].ToString();
                    mSaleExcludedFlg = Convert.ToInt16(selectRow["SaleExcludedFlg"]);

                    //decimal wSuu = bbl.Z_Set(txtSu.Text);
                    //すべての場合でJANCDを入力した時点で数量は１に
                    //if (wSuu.Equals(0))
                    //{
                    txtSu.Text = "1";
                    //wSuu = 1;
                    //}

                    //Function_単価取得
                    SetUnitPrice();

                    //Function_プレゼント品有無判断.詳細①
                    Fnc_Present_Entity fpe = new Fnc_Present_Entity();
                    fpe.AdminNO = mAdminNO;
                    fpe.StoreCD = mParStoreCD;
                    fpe.ChangeDate = ymd;
                    bbl.Fnc_Present(fpe);

                    lblSyohinChuijiko.Text = selectRow["CommentOutStore"].ToString() + " " + fpe.outPresentCD1 + fpe.outPresentCD2 + fpe.outPresentCD3
                                            + fpe.outPresentCD4 + fpe.outPresentCD5;

                    ////※商品情報≠Null の場合（＝M_SKU.WebAddress≠Null の場合）		
                    //if (!string.IsNullOrWhiteSpace(selectRow["WebAddress"].ToString()))
                    //{
                    //    //商品情報のボタンを利用可能にする
                    //    btnInfo.Enabled = true;
                    //    btnInfo.Tag = selectRow["WebAddress"].ToString();
                    //}
                    //else
                    //{
                    //    btnInfo.Enabled = false;
                    //    btnInfo.Tag = "";
                    //}
                }
            }
            return true;
        }

        private string GetStoreTankaKBNName(string storeTankaKBN)
        {
            switch (storeTankaKBN)
            {
                case "1":
                    return "会員";
                case "2":
                    return "一般";
                case "3":
                    return "外商";
                case "5":
                    return "ｾｰﾙ";
                default:
                    return "";
            }
        }

        private Fnc_UnitPrice_Entity GetUnitPrice(Fnc_UnitPrice_Entity fue = null)
        {
            if (fue == null)
            {
                fue = new Fnc_UnitPrice_Entity
                {
                    AdminNo = mAdminNO,
                    ChangeDate = bbl.GetDate(),
                    CustomerCD = txtCustomerNo.Text,
                    StoreCD = StoreCD,
                    SaleKbn = "0",
                    Suryo = txtSu.Text.ToInt32(0).ToString()
                };
            }

            if (bbl.Fnc_UnitPrice(fue))
            {
                return fue;
            }
            else
            {
                return null;
            }
        }

        private void SetUnitPrice()
        {
            Fnc_UnitPrice_Entity fue = GetUnitPrice();
            if (fue != null)
            {
                if (mSaleExcludedFlg == 0)
                {
                    mParSaleRate = 0;
                    //Saleモード＝１の場合							
                    if (mSaleMode.Equals(1))
                    {
                        //特別割引率選択
                        FrmSpecialWaribiki frm = new FrmSpecialWaribiki();
                        frm.ShowDialog();
                        switch (frm.btnSelect)
                        {
                            case 1:
                                mParSaleRate = 20;
                                break;
                            case 2:
                                mParSaleRate = 10;
                                break;
                        }
                    }
                    //Function_単価取得.out税込単価	×((100－Parameter.SaleRate)　÷100)←１円未満は四捨五入
                    //↑Haspoの初売りの時、全店一律割引セール mParSaleRate
                    fue.ZeikomiTanka = bbl.Z_SetStr(GetResultWithHasuKbn((int)HASU_KBN.SISYAGONYU, bbl.Z_Set(fue.ZeikomiTanka) * (100 - mParSaleRate) / 100));
                }

                decimal wSuu = fue.Suryo.ToDecimal(0);

                if (mDiscountKBN.Equals("1"))
                {
                    txtJuchuuUnitPrice.Text = string.Format("{0:#,##0}", -1 * bbl.Z_Set(fue.ZeikomiTanka));
                    mJuchuuHontaiGaku = string.Format("{0:#,##0}", -1 * bbl.Z_Set(fue.ZeinukiTanka) * wSuu);
                    lblSalesGaku.Text = string.Format("{0:#,##0}", -1 * bbl.Z_Set(fue.ZeikomiTanka) * wSuu);
                }
                else
                {
                    //販売単価=Function_単価取得.out税込単価		
                    txtJuchuuUnitPrice.Text = string.Format("{0:#,##0}", bbl.Z_Set(fue.ZeikomiTanka));
                    //税抜販売額＝Form.受注数≠Nullの場合	Function_単価取得.out税抜単価×Form.Detail.受注数
                    mJuchuuHontaiGaku = string.Format("{0:#,##0}", bbl.Z_Set(fue.ZeinukiTanka) * wSuu);
                    lblSalesGaku.Text = string.Format("{0:#,##0}", bbl.Z_Set(fue.ZeikomiTanka) * wSuu);
                }
                mProperTanka = txtJuchuuUnitPrice.Text;
                mProperGaku = lblSalesGaku.Text;
                lblSalesTax.Text = bbl.Z_SetStr(bbl.Z_Set(lblSalesGaku.Text) - bbl.Z_Set(mJuchuuHontaiGaku));
                mZeiritsu = Convert.ToInt16(fue.Zeiritsu);

                //税率=Function_単価取得.out税率
                if (mZeiritsu == 0)
                {
                    lblJuchuuTaxRitsu.Text = "";
                }
                else
                {
                    lblJuchuuTaxRitsu.Text = string.Format("{0:#,##0}", mZeiritsu) + "%";
                }

                mUnitPriceCustomerCD = txtCustomerNo.Text;
            }
        }

        private void ReSetDetailUnitPrice()
        {
            if (dtSales.Rows.Count == 0) return;

            foreach (var row in dtSales.AsEnumerable())
            {
                //顧客CDが変わっていない行は再セットしない
                if (row["CustomerCD"].ToString() == txtCustomerNo.Text) continue;

                int wDiscountKBN = row["DiscountKBN"].ToInt32(0);
                int wSaleExcludedFlg = row["SaleExcludedFlg"].ToInt32(0);
                int wSuu = row["SalesSU"].ToInt32(0);

                decimal wJuchuuUnitPrice = 0;
                decimal wJuchuuHontaiGaku = 0;
                decimal wSalesGaku = 0;
                decimal wSalesTax = 0;
                decimal wProperGaku = 0;
                decimal wZeiritsu = 0;
                decimal wDiscount = 0;
                decimal wDiscountTax = 0;
                decimal wDiscount10 = 0;
                decimal wDiscountTax10 = 0;
                decimal wDiscount8 = 0;
                decimal wDiscountTax8 = 0;
                decimal wSalesHontaiGaku0 = 0;
                decimal wSalesHontaiGaku10 = 0;
                decimal wSalesTax10 = 0;
                decimal wSalesHontaiGaku8 = 0;
                decimal wSalesTax8 = 0;

                //単価取得
                Fnc_UnitPrice_Entity fue = new Fnc_UnitPrice_Entity
                {
                    AdminNo = row["AdminNO"].ToString(),
                    ChangeDate = bbl.GetDate(),
                    CustomerCD = txtCustomerNo.Text,
                    StoreCD = StoreCD,
                    SaleKbn = "0",
                    Suryo = wSuu.ToString()
                };
                fue = GetUnitPrice(fue);

                //単価!=0場合のみ計算処理（出来なかった場合はそのまま）
                if (fue != null && fue.ZeikomiTanka.ToDecimal(0) != 0)
                {
                    #region SetUnitPriceの内容
                    //-------------------->
                    if (wSaleExcludedFlg == 0)
                    {
                        mParSaleRate = 0;
                        //Saleモード＝１の場合							
                        if (mSaleMode.Equals(1))
                        {
                            //特別割引率選択
                            FrmSpecialWaribiki frm = new FrmSpecialWaribiki();
                            frm.ShowDialog();
                            switch (frm.btnSelect)
                            {
                                case 1:
                                    mParSaleRate = 20;
                                    break;
                                case 2:
                                    mParSaleRate = 10;
                                    break;
                            }
                        }
                        //Function_単価取得.out税込単価	×((100－Parameter.SaleRate)　÷100)←１円未満は四捨五入
                        //↑Haspoの初売りの時、全店一律割引セール mParSaleRate
                        fue.ZeikomiTanka = bbl.Z_SetStr(GetResultWithHasuKbn((int)HASU_KBN.SISYAGONYU, bbl.Z_Set(fue.ZeikomiTanka) * (100 - mParSaleRate) / 100));
                    }

                    if (wDiscountKBN == 1)
                    {
                        wJuchuuUnitPrice = -1 * bbl.Z_Set(fue.ZeikomiTanka);
                        wJuchuuHontaiGaku = -1 * bbl.Z_Set(fue.ZeinukiTanka) * wSuu;
                    }
                    else
                    {
                        wJuchuuUnitPrice = bbl.Z_Set(fue.ZeikomiTanka);
                        wJuchuuHontaiGaku = bbl.Z_Set(fue.ZeinukiTanka) * wSuu;
                    }

                    wSalesGaku = wJuchuuUnitPrice * wSuu;
                    wSalesTax = wSalesGaku - wJuchuuHontaiGaku;

                    wProperGaku = wSalesGaku;
                    wZeiritsu = Convert.ToInt16(fue.Zeiritsu);
                    //<--------------------
                    #endregion

                    #region CalcKinの内容
                    //-------------------->
                    //不要？
                    decimal wKin = wSalesGaku;
                    decimal wZei = wSalesTax;

                    if (wDiscountKBN == 1)
                    {
                        wDiscount += wKin;
                        wDiscountTax += wZei;

                        switch (wZeiritsu)
                        {
                            case 10:
                                wDiscount10 = wKin - wZei;
                                wDiscountTax10 += wZei;
                                break;
                            case 8:
                                wDiscount8 += wKin - wZei;
                                wDiscountTax8 = wZei;
                                break;

                            default:
                                wSalesHontaiGaku0 = wKin - wZei;
                                break;
                        }
                        wKin = -1 * wKin;
                        wZei = -1 * wZei;
                    }

                    switch (wZeiritsu)
                    {
                        case 10:
                            wSalesHontaiGaku10 = wKin - wZei;
                            wSalesTax10 = wZei;
                            break;
                        case 8:
                            wSalesHontaiGaku8 = wKin - wZei;
                            wSalesTax8 = wZei;
                            break;

                        default:
                            wSalesHontaiGaku0 = wKin - wZei;
                            break;
                    }
                    //<--------------------
                    #endregion

                    #region ExecOKの内容
                    //-------------------->
                    //保存
                    row["SalesUnitPrice"] = wJuchuuUnitPrice;
                    row["SalesGaku"] = wSalesGaku;
                    row["SalesTax"] = wSalesTax;
                    row["SalesHontaiGaku"] = wJuchuuHontaiGaku;
                    row["SalesTaxRitsu"] = wZeiritsu;
                    row["ProperGaku"] = wProperGaku;
                    //不要？
                    //row["Discount"] = wDiscount;
                    //row["Discount10"] = wDiscount10;
                    //row["Discount8"] = wDiscount8;
                    //row["Discount0"] = wDiscount;
                    //row["DiscountTax10"] = wDiscountTax10;
                    //row["DiscountTax8"] = wDiscountTax8;
                    //row["SalesHontaiGaku10"] = wSalesHontaiGaku10;
                    //row["SalesHontaiGaku8"] = wSalesHontaiGaku8;
                    //row["SalesHontaiGaku0"] = wSalesHontaiGaku0;
                    //row["SalesTax10"] = wSalesTax10;
                    //row["SalesTax8"] = wSalesTax8;
                    //<--------------------
                    #endregion
                }

                //単価取得できた場合も、できなかった場合も、顧客CDは上書き
                row["CustomerCD"] = txtCustomerNo.Text;
            }

            DispFromDataTable();
            CalcKin();

            //ディスプレイ表示用
            var maxRow = dtSales.Rows[dtSales.Rows.Count - 1];
            string leftVal = string.Format("{0:#,##0}", maxRow["SalesUnitPrice"].ToDecimal(0));
            string rightVal = string.Format("{0:#,##0}", maxRow["SalesSU"].ToDecimal(0));
            Show_Display(leftVal, rightVal);
        }

        public override void FunctionProcess(int index)
        {
            switch (index + 1)
            {
                case 3:
                    if (!txtSalesNO.Enabled)
                    {
                        //Ｑ００４				
                        if (bbl.ShowMessage("Q004") != DialogResult.Yes)
                            return;

                        //クリア処理
                        InitScr();
                    }
                    break;
                case 2:
                    if (!string.IsNullOrWhiteSpace(txtJanCD.Text))
                    {
                        ExecOK();
                    }

                    //その日付で店舗精算データが存在する場合はエラーとする Ｅ２５２
                    D_StoreCalculation_Entity ds = new D_StoreCalculation_Entity();
                    ds.StoreCD = StoreCD;
                    ds.ChangeDate = tprg_Hanbai_Bl.GetDate();
                    if (tprg_Hanbai_Bl.D_StoreCalculation_Select(ds))
                    {
                        bbl.ShowMessage("E252");
                        txtJanCD.Focus();
                        return;
                    }

                    if (OperationMode == FrmMainForm.EOperationMode.INSERT || OperationMode == FrmMainForm.EOperationMode.SHOW)
                    {
                        if (!Save(meCol.CUSTOMER))
                        {
                            return;
                        }
                    }

                    if (dtSales.Rows.Count == 0)
                    {
                        //更新対象なし
                        bbl.ShowMessage("E102");
                        txtJanCD.Focus();
                        return;
                    }

                    //更新処理
                    GetGridEntity();

                    //第二画面（支払画面）表示
                    //第一画面は入力不可に。（第二画面を消して、第一画面に戻ると入力可能にする）
                    //第一画面の前に、第二画面を表示する（第二画面を後ろにできないようにする）
                    TempoRegiSiharaiTouroku frm = new TempoRegiSiharaiTouroku(OperationMode, dse, dspe, LineDisp);
                    frm.CompanyCD = InCompanyCD;
                    frm.OperatorCD = InOperatorCD;
                    frm.PcID = InPcID;
                    //frm.dt = dtUpdate;
                    frm.dt = dtSales;
                    frm.ParSaleRate = mParSaleRate;
                    frm.HaspoMode = mHaspoMode;
                    frm.TeiseimaeSalesGaku = mTeiseimaeSalesGaku;

                    frm.ShowDialog();

                    if (!frm.flgCancel)
                    {
                        //更新終了後は画面をクリア  >>>. Proceed by PTK
                        InitScr();
                    }


                    //else
                    //{

                    //}
                    break;
            }
        }

        private void InitScr()
        {
            ClearScr(1);

            DispFromSalesNO();
            ClearBackColor(pnlDetails);

            btnClose.Text = "終　了";
            btnClose.Tag = "0";
            btnProcess.Visible = false;

            lblHenpin.Text = "販売";
            lblHenpin.Visible = false;
            btnHenpin.Text = "返品";
            btnHenpin.Visible = true;
            OperationMode = FrmMainForm.EOperationMode.INSERT;

            if (Base_DL.iniEntity.IsDM_D30Used)
            {
                LineDisp.DisplayMarquee(Base_DL.iniEntity.DefaultMessage);
            }

            txtCustomerNo.Text = mStoreDefaultCustomer.IppanCD;
            if (!Save(meCol.CUSTOMER))
            {
                txtCustomerNo.Focus();
            }
            else
            {
                txtJanCD.Focus();
            }
        }

        /// <summary>
        /// 明細部金額計算
        /// </summary>
        private void SelectDefaultCustomer()
        {
            //一般用、会員用、外商用、セール用の顧客CDを取得
            M_MultiPorpose_Entity mme = new M_MultiPorpose_Entity()
            {
                ID = MultiPorpose_BL.ID_TempoGenkin,
                Char1 = StoreCD
            };
            DataTable dt = new MultiPorpose_BL().M_MultiPorpose_SelectByChar1(mme);

            if (dt.Rows.Count > 0)
            {
                var r = dt.Rows[0];
                mStoreDefaultCustomer.IppanCD = r["Char2"].ToString();
                mStoreDefaultCustomer.KaiinCD = r["Char3"].ToString();
                mStoreDefaultCustomer.GaishoCD = r["Char4"].ToString();
                mStoreDefaultCustomer.SaleCD = r["Char5"].ToString();
            }
        }

        private void GetGridEntity()
        {
            int rowNum = -1;
            decimal sumKin = 0;
            decimal sumZei = 0;

            decimal wSalesHontaiGaku = 0;
            decimal wSalesHontaiGaku0 = 0;
            decimal wSalesHontaiGaku8 = 0;
            decimal wSalesHontaiGaku10 = 0;
            decimal wSalesTax = 0;
            decimal wSalesTax8 = 0;
            decimal wSalesTax10 = 0;
            decimal wDiscount = 0;
            decimal wDiscount8 = 0;
            decimal wDiscount10 = 0;
            decimal wDiscountTax = 0;
            decimal wDiscountTax8 = 0;
            decimal wDiscountTax10 = 0;

            foreach (DataRow row in dtSales.Rows)
            {
                //一旦クリア      
                row["Discount"] = 0;
                row["Discount10"] = 0;
                row["Discount8"] = 0;
                row["Discount0"] = 0;
                row["DiscountTax10"] = 0;
                row["DiscountTax8"] = 0;
                row["SalesHontaiGaku10"] = 0;
                row["SalesHontaiGaku8"] = 0;
                row["SalesHontaiGaku0"] = 0;
                row["SalesTax10"] = 0;
                row["SalesTax8"] = 0;

                int sign = 1;
                if (row["DiscountKBN"].ToString().Equals("1"))
                {
                    sign = -1;
                    row["Discount"] = bbl.Z_Set(row["SalesGaku"]);
                    wDiscount += bbl.Z_Set(row["Discount"]);
                    wDiscountTax += bbl.Z_Set(row["SalesTax"]);
                }

                sumKin = sumKin + bbl.Z_Set(row["SalesGaku"]);
                sumZei = sumZei + bbl.Z_Set(row["SalesTax"]);

                row["SalesHontaiGaku"] = bbl.Z_Set(row["SalesGaku"]) - bbl.Z_Set(row["SalesTax"]);

                switch (row["SalesTaxRitsu"])
                {
                    case 10:
                        row["SalesHontaiGaku10"] = bbl.Z_Set(row["SalesGaku"]) - bbl.Z_Set(row["SalesTax"]);
                        row["SalesTax10"] = bbl.Z_Set(row["SalesTax"]);
                        wSalesHontaiGaku10 += bbl.Z_Set(row["SalesHontaiGaku10"]);
                        wSalesTax10 += bbl.Z_Set(row["SalesTax10"]);

                        if (sign.Equals(-1))
                        {
                            row["Discount10"] = row["SalesHontaiGaku10"];
                            row["DiscountTax10"] = row["SalesTax10"];

                            wDiscount10 += bbl.Z_Set(row["Discount10"]);
                            wDiscountTax10 += bbl.Z_Set(row["DiscountTax10"]);
                        }
                        break;
                    case 8:
                        row["SalesHontaiGaku8"] = bbl.Z_Set(row["SalesGaku"]) - bbl.Z_Set(row["SalesTax"]);
                        row["SalesTax8"] = bbl.Z_Set(row["SalesTax"]);
                        wSalesHontaiGaku8 += bbl.Z_Set(row["SalesHontaiGaku8"]);
                        wSalesTax8 += bbl.Z_Set(row["SalesTax8"]);

                        if (sign.Equals(-1))
                        {
                            row["Discount8"] = row["SalesHontaiGaku8"];
                            row["DiscountTax8"] = row["SalesTax8"];

                            wDiscount8 += bbl.Z_Set(row["Discount8"]);
                            wDiscountTax8 += bbl.Z_Set(row["DiscountTax8"]);
                        }
                        break;

                    default:
                        row["SalesHontaiGaku0"] = bbl.Z_Set(row["SalesGaku"]) - bbl.Z_Set(row["SalesTax"]);
                        wSalesHontaiGaku0 += bbl.Z_Set(row["SalesHontaiGaku0"]);

                        if (sign.Equals(-1))
                        {
                            row["Discount0"] = row["SalesHontaiGaku0"];

                        }
                        break;
                }
            }
            wSalesHontaiGaku = sumKin - sumZei; //お買上額－うち消費税
            wSalesTax = sumZei;

            dse = new D_Sales_Entity()
            {
                SalesHontaiGaku = wSalesHontaiGaku.ToString(),
                SalesHontaiGaku0 = wSalesHontaiGaku0.ToString(),
                SalesHontaiGaku8 = wSalesHontaiGaku8.ToString(),
                SalesHontaiGaku10 = wSalesHontaiGaku10.ToString(),
                //SalesTax = wSalesTax.ToString(),
                SalesTax8 = wSalesTax8.ToString(),
                SalesTax10 = wSalesTax10.ToString(),
                Discount = wDiscount.ToString(),

                Discount8 = wDiscount8.ToString(),
                Discount10 = wDiscount10.ToString(),
                DiscountTax = wDiscountTax.ToString(),
                DiscountTax8 = wDiscountTax8.ToString(),
                DiscountTax10 = wDiscountTax10.ToString(),

                SalesGaku = sumKin.ToString(),
                SalesTax = sumZei.ToString(),

                SalesNO = txtSalesNO.Text,
                JuchuuNO = txtSalesNO.Tag.ToString(),
                SalesDate = lblKeijobi.Text,
                StoreCD = mParStoreCD,
                CustomerCD = txtCustomerNo.Text,
                Age = mAge.ToString(),
                ChangeDate = mCustomerDate,
                LastPoint = bbl.Z_SetStr(lblPoint.Text),
                Operator = InOperatorCD,
                PC = InPcID
            };
        }

        private bool Save(meCol kbn = meCol.ALL)
        {
            if (ErrorCheck(kbn, false))
            {
                if (kbn == 0)
                {

                }

                return true;
            }
            return false;
        }

        private void ClearScr(int kbn = 0)
        {
            if (kbn == 1)
            {
                txtCustomerNo.Text = "";
                mAge = 0;
                mCustomerDate = "";
                lblCusName.Text = "";
                lblPoint.Text = "";
                lblStoreTankaKBN.Text = "";
                txtSalesNO.Text = "";
                txtSalesNO.Enabled = true;
                txtSalesNO.Tag = "";
                mTeiseimaeSalesGaku = 0;
                lblKeijobi.Text = "";
                //lblHenpin.Text = "";
                //lblHenpin.Visible = false;
                SetEnabled(true);
            }

            txtJanCD.Text = "";
            lblSKUName.Text = "";
            lblSKUName2.Text = "";
            lblColorSize.Text = "";
            txtJuchuuUnitPrice.Text = "";
            lblSalesGaku.Text = "";
            lblSalesTax.Text = "";
            lblJuchuuTaxRitsu.Text = "";
            txtSu.Text = "";
            lblSyohinChuijiko.Text = "";

            lblSumSalesGaku.Text = "";
            lblSumSalesTax.Text = "";
            lblSumSu.Text = "";
            txtJanCD.Tag = "";

            mDiscountKBN = "";
            mPriceWithTax = "";
            mJANCD = "";
            mAdminNO = "";
            mSKUCD = "";
            mSKUName = "";
            mUnitPriceCustomerCD = "";

            btnTanka.Enabled = true;
        }
 
        /// <summary>
        /// 明細部在庫ボタンクリック時処理
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void BTN_Zaiko_Click(object sender, EventArgs e)
        {
            try
            {
                // 実行モジュールと同一フォルダのファイルを取得
                System.Uri u = new System.Uri(System.Reflection.Assembly.GetExecutingAssembly().CodeBase);
                string filePath = System.IO.Path.GetDirectoryName(u.LocalPath) + @"\" + TempoRegiZaikoKakunin;
                if (System.IO.File.Exists(filePath))
                {
                    string cmdLine = InCompanyCD + " " + InOperatorCD + " " + InPcID + " " + txtJanCD.Text;
                    System.Diagnostics.Process.Start(filePath, cmdLine);
                }
                else
                {
                    //EXEが存在しない時ｴﾗｰ
                    return;
                }
            }
            catch (Exception ex)
            {
                //エラー時共通処理
                MessageBox.Show(ex.Message);
                //EndSec();
            }
        }

        private bool CheckWidth(int type)
        {
            switch (type)
            {
                case 1:
                    string str = Encoding.GetEncoding(932).GetByteCount(txtJanCD.Text).ToString();
                    if (Convert.ToInt32(str) > 13)
                    {
                        MessageBox.Show("Bytes Count is Over!!", "エラー", MessageBoxButtons.OK, MessageBoxIcon.Error);
                        this.Focus();
                        return false;
                    }
                    break;

                case 2:
                    int byteCount = Encoding.UTF8.GetByteCount(txtJanCD.Text);//FullWidth_Case
                    int onebyteCount = System.Text.ASCIIEncoding.ASCII.GetByteCount(txtJanCD.Text);//HalfWidth_Case
                    if (onebyteCount != byteCount)
                    {
                        MessageBox.Show("Bytes Count is Over!!", "エラー", MessageBoxButtons.OK, MessageBoxIcon.Error);
                        this.Focus();
                        return false;
                    }

                    break;
            }
            return true;
        }

        private void txtJanCD_KeyDown(object sender, KeyEventArgs e)
        {
            try
            {
                //Enterキー押下時処理
                //Returnキーが押されているか調べる
                //AltかCtrlキーが押されている時は、本来の動作をさせる
                if ((e.KeyCode == Keys.Return) &&
                    ((e.KeyCode & (Keys.Alt | Keys.Control)) == Keys.None))
                {
                    if (Save(meCol.JANCD))
                    {
                        //商品CDでEnter押してエラーがなければ、※の処理を一気に行う							
                        ExecOK(e);
                    }
                }
            }
            catch (Exception ex)
            {
                //エラー時共通処理
                MessageBox.Show(ex.Message + Environment.NewLine + ex.StackTrace);
            }
        }

        private void txtShippingSu_KeyDown(object sender, KeyEventArgs e)
        {
            try
            {
                //Enterキー押下時処理
                //Returnキーが押されているか調べる
                //AltかCtrlキーが押されている時は、本来の動作をさせる
                if ((e.KeyCode == Keys.Return) &&
                    ((e.KeyCode & (Keys.Alt | Keys.Control)) == Keys.None))
                {
                    if (Save(meCol.SURYO))
                        //あたかもTabキーが押されたかのようにする
                        //Shiftが押されている時は前のコントロールのフォーカスを移動
                        ProcessTabKey(!e.Shift);
                }
            }
            catch (Exception ex)
            {
                //エラー時共通処理
                MessageBox.Show(ex.Message);
            }
        }

        private void btnUp_Click(object sender, EventArgs e)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(lblDtGyo1.Text))
                    return;

                int gyoNo = Convert.ToInt16(lblDtGyo1.Text);
                if (gyoNo - mDetailCount > 0)
                    DispFromDataTable(gyoNo - mDetailCount);
                else
                    DispFromDataTable();
            }
            catch (Exception ex)
            {
                //エラー時共通処理
                MessageBox.Show(ex.Message);
            }
        }

        private void btnDown_Click(object sender, EventArgs e)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(lblDtGyo1.Text))
                    return;

                int gyoNo = Convert.ToInt16(lblDtGyo1.Text);
                if (dtSales.Rows.Count >= gyoNo + mDetailCount)
                    DispFromDataTable(gyoNo + mDetailCount);
            }
            catch (Exception ex)
            {
                //エラー時共通処理
                MessageBox.Show(ex.Message);
            }
        }

        private void btnSyoUp_Click(object sender, EventArgs e)
        {
            try
            {
                int Horizontal = Convert.ToInt16(btnSyoDown.Tag);
                if (Horizontal - cBottunDetailCount > 0)
                    DispFromButtonDetailsTable(Horizontal - cBottunDetailCount);
                else
                    DispFromButtonDetailsTable();
            }
            catch (Exception ex)
            {
                //エラー時共通処理
                MessageBox.Show(ex.Message);
            }
        }

        private void btnSyoDown_Click(object sender, EventArgs e)
        {
            try
            {
                int Horizontal = Convert.ToInt16(btnSyoDown.Tag);
                DispFromButtonDetailsTable(Horizontal + cBottunDetailCount);
            }
            catch (Exception ex)
            {
                //エラー時共通処理
                MessageBox.Show(ex.Message);
            }
        }

        private void btnGroupUp_Click(object sender, EventArgs e)
        {
            try
            {
                int Horizontal = Convert.ToInt16(btnGrp1.Tag);
                if (Horizontal - cBottunGroupCount > 0)
                    DispFromButtonGroupTable(Horizontal - cBottunGroupCount);
                else
                    DispFromButtonGroupTable();
            }
            catch (Exception ex)
            {
                //エラー時共通処理
                MessageBox.Show(ex.Message);
            }
        }

        private void btnGroupDown_Click(object sender, EventArgs e)
        {
            try
            {
                int Horizontal = Convert.ToInt16(btnGrp1.Tag);
                DispFromButtonGroupTable(Horizontal + cBottunGroupCount);
            }
            catch (Exception ex)
            {
                //エラー時共通処理
                MessageBox.Show(ex.Message);
            }
        }

        private void btnOk_Click(object sender, EventArgs e)
        {
            try
            {
                ExecOK();
            }
            catch (Exception ex)
            {
                //エラー時共通処理
                MessageBox.Show(ex.Message);
            }
        }

        private void txtSalesNo_KeyDown(object sender, KeyEventArgs e)
        {
            try
            {
                //Enterキー押下時処理
                //Returnキーが押されているか調べる
                //AltかCtrlキーが押されている時は、本来の動作をさせる
                if ((e.KeyCode == Keys.Return) &&
                    ((e.KeyCode & (Keys.Alt | Keys.Control)) == Keys.None))
                {
                    bool upd = txtSalesNO.Modified;

                    if (Save(meCol.SALESNO))
                    {
                        if (string.IsNullOrWhiteSpace(txtSalesNO.Text))
                        {
                            txtCustomerNo.Focus();
                        }
                        else
                        {

                        }
                    }
                }

            }
            catch (Exception ex)
            {
                //エラー時共通処理
                MessageBox.Show(ex.Message);
            }
        }

        private void txtCustomerNo_KeyDown(object sender, KeyEventArgs e)
        {
            try
            {
                //Enterキー押下時処理
                //Returnキーが押されているか調べる
                //AltかCtrlキーが押されている時は、本来の動作をさせる
                if ((e.KeyCode == Keys.Return) &&
                    ((e.KeyCode & (Keys.Alt | Keys.Control)) == Keys.None))
                {
                    if (Save(meCol.CUSTOMER))
                    {
                        if (mJANCD == txtJanCD.Text && txtJanCD.Text.Length > 0)
                        {
                            //JANCD入力済みならOKボタンクリック処理
                            ExecOK(e);
                        }
                        else
                        {
                            txtJanCD.Focus();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                //エラー時共通処理
                MessageBox.Show(ex.Message);
            }
        }

        private void BtnGroup_Click(object sender, EventArgs e)
        {
            try
            {
                string GroupNO = ((Button)sender).Tag.ToString();

                if (!string.IsNullOrWhiteSpace(GroupNO))
                {
                    Clear(tableLayoutPanel3);
                    CheckData_M_StoreButtonDetailes(GroupNO);
                }
            }
            catch (Exception ex)
            {
                //エラー時共通処理
                MessageBox.Show(ex.Message);
            }
        }

        private void BtnSyo_Click(object sender, EventArgs e)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(((Button)sender).Tag.ToString()))
                {
                    return;
                }

                btnTanka.Enabled = true;

                switch (((Button)sender).Tag.ToString().Substring(0, 1))
                {
                    case "1":
                        string JANCD = ((Button)sender).Tag.ToString().Substring(2);

                        if (!string.IsNullOrWhiteSpace(JANCD))
                        {
                            txtJanCD.Text = JANCD;
                            mAdminNO = "";
                            if (Save(meCol.JANCD))
                            {
                                ExecOK();
                            }
                            else
                            {
                                txtJuchuuUnitPrice.Focus();
                            }
                        }
                        break;

                    case "2":
                        string CustomerCD = ((Button)sender).Tag.ToString().Substring(2);

                        if (!string.IsNullOrWhiteSpace(CustomerCD))
                        {
                            txtCustomerNo.Text = CustomerCD;
                            if (Save(meCol.CUSTOMER))
                                txtJanCD.Focus();
                        }
                        break;
                }
            }
            catch (Exception ex)
            {
                //エラー時共通処理
                MessageBox.Show(ex.Message);
            }
        }

        private void lblDtGyo_Click(object sender, EventArgs e, int index)
        {
            try
            {
                //リストの明細をクリック（またはノートPCで画面タッチ）された場合、その明細を左側の編集エリアに表示する
                Label lblsender = (Label)sender;
                if (string.IsNullOrWhiteSpace(lblsender.Text)) return;

                int rowIndex = Convert.ToInt16(lblsender.Text) - 1;

                SetDataFromDataTable(rowIndex + 1);

                ClearBackColor(pnlDetails);

                Color activeColor = Color.FromArgb(255, 242, 204);

                lblsender.BackColor = activeColor;

                listGyoSelect[index].BackColor = activeColor;
                listSKUName[index].BackColor = activeColor;
                listSKUName2nd[index].BackColor = activeColor;
                listColorSize[index].BackColor = activeColor;
                listTanka[index].BackColor = activeColor;
                listKingaku[index].BackColor = activeColor;
                listSu[index].BackColor = activeColor;

                txtJuchuuUnitPrice.Focus();
            }
            catch (Exception ex)
            {
                //エラー時共通処理
                MessageBox.Show(ex.Message);
            }
        }

        private void ClearBackColor(Panel panel)
        {
            IEnumerable<Control> c = GetAllControls(panel);
            foreach (Control ctrl in c)
            {
                if (ctrl is Label)
                    ((Label)ctrl).BackColor = Color.Transparent;
            }
        }

        private void lblGyoSelect1_Click(object sender, EventArgs e)
        {
            try
            {
                lblDtGyo_Click(lblDtGyo1, new EventArgs(), 0);
            }
            catch (Exception ex)
            {
                //エラー時共通処理
                MessageBox.Show(ex.Message);
            }
        }

        private void lblGyoSelect2_Click(object sender, EventArgs e)
        {
            try
            {
                lblDtGyo_Click(lblDtGyo2, new EventArgs(), 1);
            }
            catch (Exception ex)
            {
                //エラー時共通処理
                MessageBox.Show(ex.Message);
            }
        }

        private void lblGyoSelect3_Click(object sender, EventArgs e)
        {
            try
            {
                lblDtGyo_Click(lblDtGyo3, new EventArgs(), 2);
            }
            catch (Exception ex)
            {
                //エラー時共通処理
                MessageBox.Show(ex.Message);
            }
        }

        private void lblGyoSelect4_Click(object sender, EventArgs e)
        {
            try
            {
                lblDtGyo_Click(lblDtGyo4, new EventArgs(), 3);
            }
            catch (Exception ex)
            {
                //エラー時共通処理
                MessageBox.Show(ex.Message);
            }
        }

        private void lblGyoSelect5_Click(object sender, EventArgs e)
        {
            try
            {
                lblDtGyo_Click(lblDtGyo5, new EventArgs(), 4);
            }
            catch (Exception ex)
            {
                //エラー時共通処理
                MessageBox.Show(ex.Message);
            }
        }

        private void lblGyoSelect6_Click(object sender, EventArgs e)
        {
            try
            {
                lblDtGyo_Click(lblDtGyo6, new EventArgs(), 5);
            }
            catch (Exception ex)
            {
                //エラー時共通処理
                MessageBox.Show(ex.Message);
            }
        }

        private void btnHenpin_Click(object sender, EventArgs e)
        {
            try
            {
                if (btnHenpin.Text.Equals("返品"))
                {
                    lblHenpin.Text = "返品";
                    lblHenpin.Visible = true;
                    btnHenpin.Text = "販売";
                    OperationMode = FrmMainForm.EOperationMode.SHOW;    //このプログラムでは返品モードとする
                }
                else
                {
                    lblHenpin.Text = "販売";
                    lblHenpin.Visible = false;
                    btnHenpin.Text = "返品";
                    OperationMode = FrmMainForm.EOperationMode.INSERT;
                }
                txtJanCD.Focus();
            }
            catch (Exception ex)
            {
                //エラー時共通処理
                MessageBox.Show(ex.Message);
            }
        }

        //「商品情報」ボタン
        //private void btnInfo_Click(object sender, EventArgs e)
        //{
        //    try
        //    {
        //        //ボタンを押された場合、Internetブラウザを利用してそのアドレスのサイトを表示する
        //        //ブラウザの在り処は、iniファイルに設定する
        //        string url = btnInfo.Tag.ToString();
        //        if (!string.IsNullOrWhiteSpace(url))
        //        {
        //            //urlを標準のブラウザで開いて表示する
        //            System.Diagnostics.Process.Start(url);

        //            //System.Diagnostics.Process process1;
        //            //string ie = @"C:\Program Files\Internet Explorer\iexplore.exe";
        //            //process1 = System.Diagnostics.Process.Start(ie, url); // Windows 8
        //        }

        //    }
        //    catch (Exception ex)
        //    {
        //        //エラー時共通処理 
        //        MessageBox.Show(ex.Message);
        //    }
        //}

        private void txtJuchuuUnitPrice_TextChanged(object sender, EventArgs e)
        {
            if (txtJuchuuUnitPrice.Text.ToDecimal(0) < 0 && txtJuchuuUnitPrice.Text.Substring(0, 1) == "-")
            {
                txtJuchuuUnitPrice.ForeColor = Color.Red;
            }
            else
            {
                txtJuchuuUnitPrice.ForeColor = Color.Black;
            }
        }

        private void txtJuchuuUnitPrice_KeyDown(object sender, KeyEventArgs e)
        {
            try
            {
                //Enterキー押下時処理
                //Returnキーが押されているか調べる
                //AltかCtrlキーが押されている時は、本来の動作をさせる
                if ((e.KeyCode == Keys.Return) &&
                    ((e.KeyCode & (Keys.Alt | Keys.Control)) == Keys.None))
                {
                    if (Save(meCol.TANKA))
                    {
                        txtSu.Focus();
                    }
                }
            }
            catch (Exception ex)
            {
                //エラー時共通処理
                MessageBox.Show(ex.Message);
            }
        }

        private void btnTanka_Click(object sender, EventArgs e)
        {
            try
            {
                //単価ボタンを押された場合
                //割引率入力画面を表示
                FrmWaribikiritsu frm = new FrmWaribikiritsu();
                frm.JANCD = txtJanCD.Text;
                frm.SKUName = mSKUName;
                if (mHaspoMode != 1)
                {
                    frm.Teika = mPriceWithTax;
                }
                else
                {
                    //Function_消費税計算.out税込単価
                    //frm.Teika = bbl.Z_SetStr(bbl.GetZeinukiKingaku(bbl.Z_Set(txtJuchuuUnitPrice.Text), mTaxRateFLG, bbl.GetDate()) * bbl.Z_Set(txtSu.Text));
                    //frm.Teika = bbl.Z_SetStr(bbl.GetZeikomiKingaku(bbl.Z_Set(txtJuchuuUnitPrice.Text), mTaxRateFLG, out decimal zei, bbl.GetDate()));
                    frm.Teika = txtJuchuuUnitPrice.Text;
                }
                frm.HaspoMode = mHaspoMode;
                frm.SaleExcludedFlg = mSaleExcludedFlg;
                frm.SaleMode = mSaleMode;

                var fue = GetUnitPrice();
                frm.GenkaTanka = fue.GenkaTanka;
                frm.IppanZeikomiTanka = fue.IppanZeikomiTanka;
                frm.KaiinZeikomiTanka = fue.KaiinZeikomiTanka;
                frm.GaishoZeikomiTanka = fue.GaishoZeikomiTanka;
                frm.SaleTanka = fue.SaleTanka;

                frm.ShowDialog();

                int select = frm.btnSelect;
                switch (select)
                {
                    case 1:
                        //戻る		：	何もせず、元の画面に戻る	
                        break;

                    case 2:
                        //決定		：	単価を元の画面に反映する	
                        txtJuchuuUnitPrice.Text = bbl.Z_SetStr(frm.Tanka);
                        CalcKin();
                        txtSu.Focus();
                        if (mHaspoMode == 1)
                        {
                            btnTanka.Enabled = false;
                        }
                        break;
                }
            }
            catch (Exception ex)
            {
                //エラー時共通処理
                MessageBox.Show(ex.Message);
            }
        }

        private void btnCustomerNo_Click(object sender, EventArgs e)
        {
            try
            {
                TempoRegiKaiinKensaku form = new TempoRegiKaiinKensaku();
                form.ShowDialog();

                if (!string.IsNullOrWhiteSpace(form.CustomerCD))
                {
                    txtCustomerNo.Text = form.CustomerCD;
                    if (Save(meCol.CUSTOMER))
                        txtJanCD.Focus();
                }
            }
            catch (Exception ex)
            {
                //エラー時共通処理
                MessageBox.Show(ex.Message);
            }
        }

        private void btnSyohin_Click(object sender, EventArgs e)
        {
            try
            {
                //商品検索画面(TempoRegiShouhinKensaku_店舗商品検索)を起動
                TempoRegiShouhinKensaku form = new TempoRegiShouhinKensaku(InOperatorCD);
                form.ShowDialog();

                if (!string.IsNullOrWhiteSpace(form.AdminNO))
                {
                    mAdminNO = form.AdminNO;
                    txtJanCD.Text = form.JANCD;
                    mJANCD = txtJanCD.Text;

                    if (ErrorCheck(meCol.JANCD, true))
                    {
                        //商品CDでEnter押してエラーがなければ、※の処理を一気に行う							
                        ExecOK();
                    }
                }
            }
            catch (Exception ex)
            {
                //エラー時共通処理
                MessageBox.Show(ex.Message);
            }
        }

        private void btnClear_Click(object sender, EventArgs e)
        {
            InitScr();
        }

        private void btnMoveToCustomer_Click(object sender, EventArgs e)
        {
            if (txtCustomerNo.CanFocus) txtCustomerNo.Focus();
        }

        private void btnMoveToJANCD_Click(object sender, EventArgs e)
        {
            if (txtJanCD.CanFocus) txtJanCD.Focus();
        }

        private void btnMoveToTanka_Click(object sender, EventArgs e)
        {
            if (txtJuchuuUnitPrice.CanFocus) txtJuchuuUnitPrice.Focus();
        }

        private void btnMoveToSu_Click(object sender, EventArgs e)
        {
            if (txtSu.CanFocus) txtSu.Focus();
        }

        private void btnKBNGenkin_Click(object sender, EventArgs e)
        {
            try
            {
                //現金会員ボタンを押された場合（会員になっていない一見さんの場合に、一見さん用会員番号を自動セットする
                if (mStoreDefaultCustomer.IppanCD == "")
                {
                    //Ｅ１０１
                    bbl.ShowMessage("E101");
                    return;
                }
                else
                {
                    txtCustomerNo.Text = mStoreDefaultCustomer.IppanCD;
                    if (!Save(meCol.CUSTOMER))
                    {
                        txtCustomerNo.Focus();
                    }
                    txtJanCD.Focus();
                }

                ////その他入力
                //FrmOther frmOther = new FrmOther();
                //frmOther.Result = mAge;

                //frmOther.ShowDialog();

                //int select = frmOther.btnSelect;
                //switch (select)
                //{
                //    case 1:
                //        //戻る		：	何もせず、元の画面に戻る	
                //        break;

                //    case 2:
                //        //決定		：	単価を元の画面に反映する	
                //        mAge = frmOther.Result;
                //        break;
                //}
            }
            catch (Exception ex)
            {
                //エラー時共通処理
                MessageBox.Show(ex.Message);
            }
        }

        private void btnKBNKaiin_Click(object sender, EventArgs e)
        {
            if (mStoreDefaultCustomer.KaiinCD == "")
            {
                bbl.ShowMessage("E101");
                return;
            }
            else
            {
                txtCustomerNo.Text = mStoreDefaultCustomer.KaiinCD;
                if (!Save(meCol.CUSTOMER)) return;
                txtJanCD.Focus();
            }
        }

        private void btnKBNGaisho_Click(object sender, EventArgs e)
        {
            if (mStoreDefaultCustomer.GaishoCD == "")
            {
                bbl.ShowMessage("E101");
                return;
            }
            else
            {
                txtCustomerNo.Text = mStoreDefaultCustomer.GaishoCD;
                if (!Save(meCol.CUSTOMER)) return;
                txtJanCD.Focus();
            }
        }

        private void btnKBNSale_Click(object sender, EventArgs e)
        {
            if (mStoreDefaultCustomer.SaleCD == "")
            {
                bbl.ShowMessage("E101");
                return;
            }
            else
            {
                txtCustomerNo.Text = mStoreDefaultCustomer.SaleCD;
                if (!Save(meCol.CUSTOMER)) return;
                txtJanCD.Focus();
            }
        }
    }
}
