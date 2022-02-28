using Base.Client;
using BL;
using CrystalDecisions.CrystalReports.Engine;
using DL;
using System;
using System.Data;
using System.Diagnostics;
using System.Drawing;
using System.Threading;
using System.Windows.Forms;
using static TempoRegiPoint.Coupon_DataSet;
using EPSON_TM30;

namespace TempoRegiPoint
{
    public partial class TempoRegiPoint : ShopBaseForm
    {
        /// <summary>
        /// コマンドライン参照
        /// </summary>
        private enum CommandLine
        {
            /// <summary>パス</summary>
            Path = 0,

            /// <summary>会社コード</summary>
            CompanyCD,

            /// <summary>オペレータコード</summary>
            OperatorCD,

            /// <summary>プログラムID</summary>
            PcID,

            /// <summary>会員番号</summary>
            CustomerCD,

            /// <summary>発行ポイント</summary>
            IssuePoint,
        }
        /// <summary>
        /// フォントの種類
        /// </summary>
        private const string FONT_TYPE = "ＭＳ ゴシック";

        /// <summary>
        /// BL
        /// </summary>
        TempoRegiPoint_BL bl = new TempoRegiPoint_BL();

        /// <summary>
        /// 発行枚数
        /// </summary>
        private int IssuedNumber = 0;

        /// <summary>
        /// 保持ポイント参照
        /// </summary>
        private int LastPoint
        {
            get
            {
                return int.Parse(TxtLastPoint.Text.Replace(",", ""));
            }
        }

        /// <summary>
        /// 発行ポイント参照
        /// </summary>
        private int IssuePoint
        {
            get
            {
                return int.Parse(TxtIssuePoint.Text.Replace(",", ""));
            }
        }

        private string PreviousInputCustomerCD = "";

        /// <summary>
        /// 店舗ポイント引換券印刷 コンストラクタ
        /// </summary>
        public TempoRegiPoint()
        {
            InitializeComponent();
        }

        private void TempoRegiPoint_Load(object sender, EventArgs e)
        {
        
            InProgramID = "TempoRegiPoint";
            string data = InOperatorCD;

            StartProgram();

            Text = "店舗ポイント引換券印刷";
            btnProcess.Text = "印　刷";

            SetRequireField();

            //コマンドライン引数を配列で取得する
            string[] cmds = Environment.GetCommandLineArgs();
            if (cmds.Length - 1 > (int)ECmdLine.PcID)
            {
                // 別プログラムからの呼び出し時

                // フォームを表示させないように最小化してタスクバーにも表示しない
                WindowState = FormWindowState.Minimized;
                ShowInTaskbar = false;

                TxtCustomerCD.Text = cmds[(int)CommandLine.CustomerCD];
                if (SearchCustomer(false))
                {
                    TxtIssuePoint.Text = cmds[(int)CommandLine.IssuePoint];
                    //印刷後そくクローズ
                    Print();
                }
                Close();
            }
        }

        /// <summary>
        /// オブジェクトの設定
        /// </summary>
        private void SetRequireField()
        {
            BtnSearchCustomer.BackgroundColor = CKM_Controls.CKM_Button.CKM_Color.Yellow;
            //btnSearchCustomer.Font_Size = CKM_Controls.CKM_Button.CKM_FontSize.Medium;

            TxtCustomerCD.Require(true);
            TxtCustomerCD.Clear();
            TxtCustomerCD.Focus();

            LblCustomerName.Text = string.Empty;

            TxtLastPoint.Text = "";
            SetLastPointColor();

            TxtIssuePoint.Require(true);
            TxtIssuePoint.Text = "";

            lblLastSalesDate.Text = "";
        }

        private void DisplayData()
        {
            BtnSearchCustomer.Focus();
            string data = InOperatorCD;
        }

        /// <summary>
        /// エラーチェック
        /// </summary>
        /// <returns>true=エラーなし、false=エラーあり</returns>
        /// <remarks>領収書印字日付はコントロールにチェック処理あり</remarks>
        public bool ErrorCheck()
        {
            if (string.IsNullOrWhiteSpace(TxtCustomerCD.Text))
            {
                bl.ShowMessage("E102");
                TxtCustomerCD.Focus();
                return false;
            }
            else
            {
                if (!SearchCustomer(true))
                {
                    return false;
                }
            }

            if (IssuePoint == 0 || LastPoint < IssuePoint)
            {
                bl.ShowMessage("E117", "1", TxtLastPoint.Text);
                TxtIssuePoint.Focus();
                return false;
            }

            int ticketUnit = 0;

            var dt = bl.D_TicketUnitSelect(StoreCD);
            if (dt.Rows.Count > 0)
            {
                ticketUnit = Convert.ToInt32(dt.Rows[0]["TicketUnit"]);
            }

            if (ticketUnit == 0 || IssuePoint % ticketUnit != 0)
            {
                bl.ShowMessage("E198", "該当店舗の引換券発行単位の倍数以外", TxtLastPoint.Text);
                TxtIssuePoint.Focus();
                return false;
            }
            else
            {
                //発行枚数計算
                IssuedNumber = IssuePoint / ticketUnit;
            }

            return true;
        }

        /// <summary>
        /// 画面終了処理
        /// </summary>
        protected override void EndSec()
        {
            Close();
        }

        /// <summary>
        /// ファンクション処理
        /// </summary>
        /// <param name="index"></param>
        public override void FunctionProcess(int index)
        {
            switch (index + 1)
            {
                case 2:
                    // 印刷実行
                    if (!PosUtility.IsPOSInstalled(out string msg))
                    {
                        if (msg != "") bbl.ShowMessage(msg);
                        return;
                    }
                    Print();
                    break;
            }
        }

        /// <summary>
        /// 印刷実行
        /// </summary>
        private void Print()
        {
           
            if (ErrorCheck())
            {
                var coupon = bl.D_CouponSelect(StoreCD);
                if (coupon.Rows.Count > 0)
                {
                    if (Base_DL.iniEntity.IsDM_D30Used)
                    {
                        OutputCoupon(coupon);
                    }
                }
                else
                {
                    bl.ShowMessage("E128");
                }
            }
        }
      
        /// <summary>
        /// 商品引換券出力
        /// </summary>
        /// <param name="data">データ</param>
        private void OutputCoupon(DataTable data)
        {
            if (!PosUtility.IsPOSInstalled(out string msg))
            {
                if (msg != "") bbl.ShowMessage(msg);
                return;
            }

            var couponDataSet = CreateDataSet(data);
            var couponRow = couponDataSet.StorePointTable.Rows[0] as StorePointTableRow;

            // 出力
            var report = new TempoRegiPoint_Coupon();
            report.SetDataSource(couponDataSet);

            // フォント設定
            var objects = report.Section3.ReportObjects;
            ApplyFont(objects, "Print1", couponRow.Size1, couponRow.Bold1);      //  1行目
            ApplyFont(objects, "Print2", couponRow.Size2, couponRow.Bold2);      //  2行目
            ApplyFont(objects, "Print3", couponRow.Size3, couponRow.Bold3);      //  3行目
            ApplyFont(objects, "Print4", couponRow.Size4, couponRow.Bold4);      //  4行目
            ApplyFont(objects, "Print5", couponRow.Size5, couponRow.Bold5);      //  5行目
            ApplyFont(objects, "Print6", couponRow.Size6, couponRow.Bold6);      //  6行目
            ApplyFont(objects, "Print7", couponRow.Size7, couponRow.Bold7);      //  7行目
            ApplyFont(objects, "Print8", couponRow.Size8, couponRow.Bold8);      //  8行目
            ApplyFont(objects, "Print9", couponRow.Size9, couponRow.Bold9);      //  9行目
            ApplyFont(objects, "Print10", couponRow.Size10, couponRow.Bold10);   // 10行目
            ApplyFont(objects, "Print11", couponRow.Size11, couponRow.Bold11);   // 11行目
            ApplyFont(objects, "Print12", couponRow.Size12, couponRow.Bold12);   // 12行目

            report.Refresh();

            if (msg == "devMode")
            {
                Base.Client.Viewer vr = new Base.Client.Viewer();
                vr.CrystalReportViewer1.ReportSource = report;
                vr.ShowDialog();
            }
            else
            {
                report.PrintOptions.PrinterName = StorePrinterName;
                report.PrintToPrinter(0, false, 0, 0);
            }
            // 発行ポイント更新、ログ更新
            bl.M_UpdateLastPoint(TxtCustomerCD.Text, IssuePoint, InOperatorCD, InProgramID, InPcID);
        }

        /// <summary>
        /// クーポンデータセット作成
        /// </summary>
        /// <param name="data">データ</param>
        /// <returns>クーポンデータセット</returns>
        private Coupon_DataSet CreateDataSet(DataTable data)
        {
            var row = data.Rows[0];
            var couponDataSet = new Coupon_DataSet();
            var couponRow = couponDataSet.StorePointTable.NewStorePointTableRow();

            string oldValue1 = "YYYY/MM/DD";
            string newValue1 = DateTime.Now.ToString(DateTimeFormat.yyyyMMdd);

            // 引換券発行単位
            couponRow.TicketUnit = Convert.ToString(row["TicketUnit"]);

            // 1行目
            couponRow.Print1 = Convert.ToString(row["Print1"]).Replace(oldValue1, newValue1); // 文章
            couponRow.Bold1 = Convert.ToInt32(row["Bold1"]);        // 太字
            couponRow.Size1 = Convert.ToInt32(row["Size1"]);        // サイズ

            // 2行目
            couponRow.Print2 = Convert.ToString(row["Print2"]).Replace(oldValue1, newValue1); // 文章
            couponRow.Bold2 = Convert.ToInt32(row["Bold2"]);        // 太字
            couponRow.Size2 = Convert.ToInt32(row["Size2"]);        // サイズ

            // 3行目
            couponRow.Print3 = Convert.ToString(row["Print3"]).Replace(oldValue1, newValue1); // 文章
            couponRow.Bold3 = Convert.ToInt32(row["Bold3"]);        // 太字
            couponRow.Size3 = Convert.ToInt32(row["Size3"]);        // サイズ

            // 4行目
            couponRow.Print4 = Convert.ToString(row["Print4"]).Replace(oldValue1, newValue1); // 文章
            couponRow.Bold4 = Convert.ToInt32(row["Bold4"]);        // 太字
            couponRow.Size4 = Convert.ToInt32(row["Size4"]);        // サイズ

            // 5行目
            couponRow.Print5 = Convert.ToString(row["Print5"]).Replace(oldValue1, newValue1); // 文章
            couponRow.Bold5 = Convert.ToInt32(row["Bold5"]);        // 太字
            couponRow.Size5 = Convert.ToInt32(row["Size5"]);        // サイズ

            // 6行目
            couponRow.Print6 = Convert.ToString(row["Print6"]).Replace(oldValue1, newValue1); // 文章
            couponRow.Bold6 = Convert.ToInt32(row["Bold6"]);        // 太字
            couponRow.Size6 = Convert.ToInt32(row["Size6"]);        // サイズ

            // 7行目
            couponRow.Print7 = Convert.ToString(row["Print7"]).Replace(oldValue1, newValue1); // 文章
            couponRow.Bold7 = Convert.ToInt32(row["Bold7"]);        // 太字
            couponRow.Size7 = Convert.ToInt32(row["Size7"]);        // サイズ

            // 8行目
            couponRow.Print8 = Convert.ToString(row["Print8"]).Replace(oldValue1, newValue1); // 文章
            couponRow.Bold8 = Convert.ToInt32(row["Bold8"]);        // 太字
            couponRow.Size8 = Convert.ToInt32(row["Size8"]);        // サイズ

            // 9行目
            couponRow.Print9 = Convert.ToString(row["Print9"]).Replace(oldValue1, newValue1); // 文章
            couponRow.Bold9 = Convert.ToInt32(row["Bold9"]);        // 太字
            couponRow.Size9 = Convert.ToInt32(row["Size9"]);        // サイズ

            // 10行目
            couponRow.Print10 = Convert.ToString(row["Print10"]).Replace(oldValue1, newValue1); // 文章
            couponRow.Bold10 = Convert.ToInt32(row["Bold10"]);      // 太字
            couponRow.Size10 = Convert.ToInt32(row["Size10"]);      // サイズ

            // 11行目
            couponRow.Print11 = Convert.ToString(row["Print11"]).Replace(oldValue1, newValue1); // 文章
            couponRow.Bold11 = Convert.ToInt32(row["Bold11"]);      // 太字
            couponRow.Size11 = Convert.ToInt32(row["Size11"]);      // サイズ 

            // 12行目
            couponRow.Print12 = Convert.ToString(row["Print12"]).Replace(oldValue1, newValue1); // 文章
            couponRow.Bold12 = Convert.ToInt32(row["Bold12"]);      // 太字
            couponRow.Size12 = Convert.ToInt32(row["Size12"]);      // サイズ 

            // データセットに追加
            couponDataSet.StorePointTable.Rows.Add(couponRow);

            //発行枚数が2枚以上の場合
            for (var count = 1; count < IssuedNumber; count++)
            {
                var copyRow = couponDataSet.StorePointTable.NewStorePointTableRow();
                copyRow.ItemArray = couponRow.ItemArray;
                couponDataSet.StorePointTable.Rows.Add(copyRow);
            }

            return couponDataSet;
        }

        /// <summary>
        /// レポートファイルの行オブジェクトにフォントを設定
        /// </summary>
        /// <param name="report">レポートファイルオブジェクト</param>
        /// <param name="name">行オブジェクト名</param>
        /// <param name="size">フォントサイズ</param>
        /// <param name="bold">ボールド指定(0:指定なし、1:指定あり)</param>
        /// <remarks>フォントサイズが0の場合は設定しない</remarks>
        private void ApplyFont(ReportObjects objects, string name, float size, int bold)
        {
            if (size > 0)
            {
                ((TextObject)objects[name]).ApplyFont(
                    new Font(FONT_TYPE, size, bold == 1 ? FontStyle.Bold : FontStyle.Regular)
                );
            }
        }

        /// <summary>
        /// 会員番号ボタン押下イベント
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void BtnSearchCustomer_Click(object sender, EventArgs e)
        {
            var search = new Search.TempoRegiKaiinKensaku();
            var result = search.ShowDialog();

            if (!string.IsNullOrEmpty(search.CustomerCD))
            {
                TxtCustomerCD.Text = search.CustomerCD;
                LblCustomerName.Text = search.CustomerName;

                SearchCustomer(false);
            }
        }

        /// <summary>
        /// 会員番号入力イベント
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void TxtCustomerCD_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
            {
                if (SearchCustomer(false))
                {
                    TxtIssuePoint.Focus();
                }
            }
            else
            {
                // 入力中
                ClearCustomerInfo();
            }
        }

        /// <summary>
        /// 保持ポイント入力変更イベント
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void TxtLastPoint_TextChanged(object sender, EventArgs e)
        {
            if (int.TryParse(TxtLastPoint.Text, out int value))
            {
                TxtLastPoint.Text = string.Format("{0:#,##0}", value);
            }
        }

        /// <summary>
        /// 発行ポイント入力イベント
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void TxtIssuePoint_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
            {
                if (ErrorCheck())
                {
                    this.btnClose.Focus();
                }
            }
        }

        /// <summary>
        /// 発行ポイント入力フォーカス移動時イベント
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void TxtIssuePoint_Leave(object sender, EventArgs e)
        {
            if (int.TryParse(TxtIssuePoint.Text, out int value))
            {
                TxtIssuePoint.Text = string.Format("{0:#,##0}", value);
            }
        }

        /// <summary>
        /// 発行ポイントアクティブ時イベント
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void TxtIssuePoint_Enter(object sender, EventArgs e)
        {
            if (TxtIssuePoint.Text.Contains(","))
            {
                TxtIssuePoint.Text = TxtIssuePoint.Text.Replace(",", "");
            }
        }

        /// <summary>
        /// 会員を検索
        /// </summary>
        /// <returns>処理結果(true=有効な会員、false=無効な会員)</returns>
        private bool SearchCustomer(bool isCheckAll)
        {
            //M_StorePoint
            int expirationDate = 0;
            var storePointDt = bl.M_StorePoint_Select(StoreCD);
            if (storePointDt.Rows.Count > 0)
            {
                expirationDate = storePointDt.Rows[0]["ExpirationDate"].ToInt32(0);
            }

            //M_Customer
            var customerDt = bl.D_GetCustomer(TxtCustomerCD.Text);
            if (customerDt.Rows.Count == 0)
            {
                //該当なし
                bl.ShowMessage("E138");
                ClearCustomerInfo();
                TxtCustomerCD.Focus();
                return false;
            }

            var customerData = customerDt.Rows[0];

            if (customerData["DeleteFlg"].ToInt32(0) == 1)
            {
                //削除された会員
                bl.ShowMessage("E140", "顧客");
                ClearCustomerInfo();
                TxtCustomerCD.Focus();
                return false;
            }

            if (customerData["PointFLG"].ToInt32(0) == 0)
            {
                //ポイント付与対象外の会員です
                bl.ShowMessage("E291");
                ClearCustomerInfo();
                TxtCustomerCD.Focus();
                return false;
            }

            //有効な会員Print
            TxtCustomerCD.Text = customerData["CustomerCD"].ToString();
            LblCustomerName.Text = customerData["CustomerName"].ToString();
            lblLastSalesDate.Text = customerData["LastSalesDate"].ToStringOrEmpty(DateTimeFormat.yyyyMMdd);
            TxtLastPoint.Text = Convert.ToInt32(customerData["LastPoint"]).ToString();

            if (isCheckAll && PreviousInputCustomerCD == TxtCustomerCD.Text)
            {
                //印刷ボタンクリック時、会員CDが変わっていなければチェック不要
            }
            else
            {
                //expirationDate = 0は有効期限なし
                if (expirationDate > 0 && lblLastSalesDate.Text.Length > 0 && Convert.ToDateTime(lblLastSalesDate.Text).AddMonths(expirationDate) < DateTime.Now.Date)
                {
                    //最終売上日からポイント有効期間以上経っていますが、ポイント引換券を発行しますか？
                    if (bl.ShowMessage("Q331") != DialogResult.Yes)
                    {
                        ClearCustomerInfo();
                        TxtCustomerCD.Focus();
                        return false;
                    }
                }
            }

            PreviousInputCustomerCD = TxtCustomerCD.Text;

            return true;
        }

        private void ClearCustomerInfo()
        {
            LblCustomerName.Text = string.Empty;
            TxtLastPoint.Text = string.Empty;
            lblLastSalesDate.Text = string.Empty;
            PreviousInputCustomerCD = "";
        }

        /// <summary>
        /// 保持ポイント入力ボックスの色を設定
        /// </summary>
        private void SetLastPointColor()
        {
            TxtLastPoint.BackColor = Color.White;
            TxtLastPoint.ForeColor = Color.Black;
        }
    }
}
