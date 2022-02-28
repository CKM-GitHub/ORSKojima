namespace TempoRegiRyousyuusyo
{
    partial class TempoRegiRyousyuusyo
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.panelDetail = new System.Windows.Forms.Panel();
            this.txtAmountOfMoney = new CKM_Controls.CKM_TextBox();
            this.ckmShop_Label1 = new CKM_Controls.CKMShop_Label();
            this.txtPrintDate = new CKM_Controls.CKM_TextBox();
            this.chkReceipt = new CKM_Controls.CKMShop_CheckBox();
            this.lblReceipt = new CKM_Controls.CKMShop_Label();
            this.chkRyousyuusho = new CKM_Controls.CKMShop_CheckBox();
            this.lblRyousyuusho = new CKM_Controls.CKMShop_Label();
            this.txtSalesNO = new CKM_Controls.CKM_TextBox();
            this.lblPrintDate = new CKM_Controls.CKMShop_Label();
            this.lblSalseNo = new CKM_Controls.CKMShop_Label();
            this.panelDetail.SuspendLayout();
            this.SuspendLayout();
            // 
            // panelDetail
            // 
            this.panelDetail.Controls.Add(this.txtAmountOfMoney);
            this.panelDetail.Controls.Add(this.ckmShop_Label1);
            this.panelDetail.Controls.Add(this.txtPrintDate);
            this.panelDetail.Controls.Add(this.chkReceipt);
            this.panelDetail.Controls.Add(this.lblReceipt);
            this.panelDetail.Controls.Add(this.chkRyousyuusho);
            this.panelDetail.Controls.Add(this.lblRyousyuusho);
            this.panelDetail.Controls.Add(this.txtSalesNO);
            this.panelDetail.Controls.Add(this.lblPrintDate);
            this.panelDetail.Controls.Add(this.lblSalseNo);
            this.panelDetail.Dock = System.Windows.Forms.DockStyle.Fill;
            this.panelDetail.Location = new System.Drawing.Point(0, 69);
            this.panelDetail.Name = "panelDetail";
            this.panelDetail.Size = new System.Drawing.Size(1904, 812);
            this.panelDetail.TabIndex = 14;
            // 
            // txtAmountOfMoney
            // 
            this.txtAmountOfMoney.AllowMinus = true;
            this.txtAmountOfMoney.Back_Color = CKM_Controls.CKM_TextBox.CKM_Color.Green;
            this.txtAmountOfMoney.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(226)))), ((int)(((byte)(239)))), ((int)(((byte)(218)))));
            this.txtAmountOfMoney.BorderColor = false;
            this.txtAmountOfMoney.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.txtAmountOfMoney.ClientColor = System.Drawing.Color.FromArgb(((int)(((byte)(226)))), ((int)(((byte)(239)))), ((int)(((byte)(218)))));
            this.txtAmountOfMoney.Ctrl_Byte = CKM_Controls.CKM_TextBox.Bytes.半全角;
            this.txtAmountOfMoney.Ctrl_Type = CKM_Controls.CKM_TextBox.Type.Price;
            this.txtAmountOfMoney.DecimalPlace = 0;
            this.txtAmountOfMoney.EnabledInsertKeyModeOnMouseEnter = false;
            this.txtAmountOfMoney.Font = new System.Drawing.Font("MS Gothic", 26F);
            this.txtAmountOfMoney.ImeMode = System.Windows.Forms.ImeMode.NoControl;
            this.txtAmountOfMoney.InsertKeyMode = System.Windows.Forms.InsertKeyMode.Overwrite;
            this.txtAmountOfMoney.IntegerPart = 8;
            this.txtAmountOfMoney.IsCorrectDate = true;
            this.txtAmountOfMoney.isEnterKeyDown = false;
            this.txtAmountOfMoney.IsFirstTime = true;
            this.txtAmountOfMoney.isMaxLengthErr = false;
            this.txtAmountOfMoney.IsNumber = true;
            this.txtAmountOfMoney.IsShop = false;
            this.txtAmountOfMoney.IsTimemmss = false;
            this.txtAmountOfMoney.Length = 9;
            this.txtAmountOfMoney.Location = new System.Drawing.Point(322, 336);
            this.txtAmountOfMoney.MaxLength = 9;
            this.txtAmountOfMoney.MoveNext = true;
            this.txtAmountOfMoney.Name = "txtAmountOfMoney";
            this.txtAmountOfMoney.Size = new System.Drawing.Size(184, 42);
            this.txtAmountOfMoney.TabIndex = 5;
            this.txtAmountOfMoney.Text = "99,999,999";
            this.txtAmountOfMoney.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            this.txtAmountOfMoney.TextSize = CKM_Controls.CKM_TextBox.FontSize.Medium;
            this.txtAmountOfMoney.UseColorSizMode = false;
            this.txtAmountOfMoney.KeyDown += new System.Windows.Forms.KeyEventHandler(this.txtAmountOfMoney_KeyDown);
            // 
            // ckmShop_Label1
            // 
            this.ckmShop_Label1.AutoSize = true;
            this.ckmShop_Label1.Back_Color = CKM_Controls.CKMShop_Label.CKM_Color.Default;
            this.ckmShop_Label1.BackColor = System.Drawing.Color.Transparent;
            this.ckmShop_Label1.Font = new System.Drawing.Font("MS Gothic", 26F, System.Drawing.FontStyle.Bold);
            this.ckmShop_Label1.Font_Size = CKM_Controls.CKMShop_Label.CKM_FontSize.Normal;
            this.ckmShop_Label1.FontBold = true;
            this.ckmShop_Label1.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(130)))), ((int)(((byte)(53)))));
            this.ckmShop_Label1.Location = new System.Drawing.Point(194, 339);
            this.ckmShop_Label1.Name = "ckmShop_Label1";
            this.ckmShop_Label1.Size = new System.Drawing.Size(126, 35);
            this.ckmShop_Label1.TabIndex = 26;
            this.ckmShop_Label1.Text = "金　額";
            this.ckmShop_Label1.Text_Color = CKM_Controls.CKMShop_Label.CKM_Color.Green;
            this.ckmShop_Label1.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // txtPrintDate
            // 
            this.txtPrintDate.AllowMinus = true;
            this.txtPrintDate.Back_Color = CKM_Controls.CKM_TextBox.CKM_Color.Green;
            this.txtPrintDate.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(226)))), ((int)(((byte)(239)))), ((int)(((byte)(218)))));
            this.txtPrintDate.BorderColor = false;
            this.txtPrintDate.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.txtPrintDate.ClientColor = System.Drawing.Color.FromArgb(((int)(((byte)(226)))), ((int)(((byte)(239)))), ((int)(((byte)(218)))));
            this.txtPrintDate.Ctrl_Byte = CKM_Controls.CKM_TextBox.Bytes.半全角;
            this.txtPrintDate.Ctrl_Type = CKM_Controls.CKM_TextBox.Type.Date;
            this.txtPrintDate.DecimalPlace = 0;
            this.txtPrintDate.EnabledInsertKeyModeOnMouseEnter = false;
            this.txtPrintDate.Font = new System.Drawing.Font("MS Gothic", 26F);
            this.txtPrintDate.InsertKeyMode = System.Windows.Forms.InsertKeyMode.Overwrite;
            this.txtPrintDate.IntegerPart = 8;
            this.txtPrintDate.IsCorrectDate = true;
            this.txtPrintDate.isEnterKeyDown = false;
            this.txtPrintDate.IsFirstTime = true;
            this.txtPrintDate.isMaxLengthErr = false;
            this.txtPrintDate.IsNumber = true;
            this.txtPrintDate.IsShop = false;
            this.txtPrintDate.IsTimemmss = false;
            this.txtPrintDate.Length = 10;
            this.txtPrintDate.Location = new System.Drawing.Point(322, 282);
            this.txtPrintDate.MaxLength = 10;
            this.txtPrintDate.MoveNext = true;
            this.txtPrintDate.Name = "txtPrintDate";
            this.txtPrintDate.Size = new System.Drawing.Size(184, 42);
            this.txtPrintDate.TabIndex = 4;
            this.txtPrintDate.Text = "9999/99/99";
            this.txtPrintDate.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            this.txtPrintDate.TextSize = CKM_Controls.CKM_TextBox.FontSize.Medium;
            this.txtPrintDate.UseColorSizMode = false;
            this.txtPrintDate.KeyDown += new System.Windows.Forms.KeyEventHandler(this.txtPrintDate_KeyDown);
            // 
            // chkReceipt
            // 
            this.chkReceipt.AccessibleRole = System.Windows.Forms.AccessibleRole.ScrollBar;
            this.chkReceipt.Font = new System.Drawing.Font("MS Gothic", 18F, System.Drawing.FontStyle.Bold);
            this.chkReceipt.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(130)))), ((int)(((byte)(53)))));
            this.chkReceipt.IsattachedCaption = false;
            this.chkReceipt.Location = new System.Drawing.Point(700, 195);
            this.chkReceipt.Name = "chkReceipt";
            this.chkReceipt.Size = new System.Drawing.Size(35, 35);
            this.chkReceipt.TabIndex = 3;
            this.chkReceipt.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.chkReceipt.UseVisualStyleBackColor = true;
            this.chkReceipt.KeyDown += new System.Windows.Forms.KeyEventHandler(this.chkReceipt_KeyDown);
            // 
            // lblReceipt
            // 
            this.lblReceipt.AutoSize = true;
            this.lblReceipt.Back_Color = CKM_Controls.CKMShop_Label.CKM_Color.Default;
            this.lblReceipt.BackColor = System.Drawing.Color.Transparent;
            this.lblReceipt.Font = new System.Drawing.Font("MS Gothic", 26F, System.Drawing.FontStyle.Bold);
            this.lblReceipt.Font_Size = CKM_Controls.CKMShop_Label.CKM_FontSize.Normal;
            this.lblReceipt.FontBold = true;
            this.lblReceipt.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(130)))), ((int)(((byte)(53)))));
            this.lblReceipt.Location = new System.Drawing.Point(534, 195);
            this.lblReceipt.Name = "lblReceipt";
            this.lblReceipt.Size = new System.Drawing.Size(163, 35);
            this.lblReceipt.TabIndex = 22;
            this.lblReceipt.Text = "レシート";
            this.lblReceipt.Text_Color = CKM_Controls.CKMShop_Label.CKM_Color.Green;
            this.lblReceipt.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // chkRyousyuusho
            // 
            this.chkRyousyuusho.AccessibleRole = System.Windows.Forms.AccessibleRole.ScrollBar;
            this.chkRyousyuusho.Checked = true;
            this.chkRyousyuusho.CheckState = System.Windows.Forms.CheckState.Checked;
            this.chkRyousyuusho.Font = new System.Drawing.Font("MS Gothic", 18F, System.Drawing.FontStyle.Bold);
            this.chkRyousyuusho.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(130)))), ((int)(((byte)(53)))));
            this.chkRyousyuusho.IsattachedCaption = false;
            this.chkRyousyuusho.Location = new System.Drawing.Point(700, 141);
            this.chkRyousyuusho.Name = "chkRyousyuusho";
            this.chkRyousyuusho.Size = new System.Drawing.Size(35, 35);
            this.chkRyousyuusho.TabIndex = 2;
            this.chkRyousyuusho.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.chkRyousyuusho.UseVisualStyleBackColor = true;
            this.chkRyousyuusho.KeyDown += new System.Windows.Forms.KeyEventHandler(this.chkRyousyuusho_KeyDown);
            // 
            // lblRyousyuusho
            // 
            this.lblRyousyuusho.AutoSize = true;
            this.lblRyousyuusho.Back_Color = CKM_Controls.CKMShop_Label.CKM_Color.Default;
            this.lblRyousyuusho.BackColor = System.Drawing.Color.Transparent;
            this.lblRyousyuusho.Font = new System.Drawing.Font("MS Gothic", 26F, System.Drawing.FontStyle.Bold);
            this.lblRyousyuusho.Font_Size = CKM_Controls.CKMShop_Label.CKM_FontSize.Normal;
            this.lblRyousyuusho.FontBold = true;
            this.lblRyousyuusho.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(130)))), ((int)(((byte)(53)))));
            this.lblRyousyuusho.Location = new System.Drawing.Point(571, 141);
            this.lblRyousyuusho.Name = "lblRyousyuusho";
            this.lblRyousyuusho.Size = new System.Drawing.Size(126, 35);
            this.lblRyousyuusho.TabIndex = 20;
            this.lblRyousyuusho.Text = "領収書";
            this.lblRyousyuusho.Text_Color = CKM_Controls.CKMShop_Label.CKM_Color.Green;
            this.lblRyousyuusho.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // txtSalesNO
            // 
            this.txtSalesNO.AllowMinus = true;
            this.txtSalesNO.Back_Color = CKM_Controls.CKM_TextBox.CKM_Color.Green;
            this.txtSalesNO.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(226)))), ((int)(((byte)(239)))), ((int)(((byte)(218)))));
            this.txtSalesNO.BorderColor = false;
            this.txtSalesNO.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.txtSalesNO.ClientColor = System.Drawing.Color.FromArgb(((int)(((byte)(226)))), ((int)(((byte)(239)))), ((int)(((byte)(218)))));
            this.txtSalesNO.Ctrl_Byte = CKM_Controls.CKM_TextBox.Bytes.半全角;
            this.txtSalesNO.Ctrl_Type = CKM_Controls.CKM_TextBox.Type.Normal;
            this.txtSalesNO.DecimalPlace = 0;
            this.txtSalesNO.EnabledInsertKeyModeOnMouseEnter = false;
            this.txtSalesNO.Font = new System.Drawing.Font("MS Gothic", 26F);
            this.txtSalesNO.InsertKeyMode = System.Windows.Forms.InsertKeyMode.Overwrite;
            this.txtSalesNO.IntegerPart = 8;
            this.txtSalesNO.IsCorrectDate = true;
            this.txtSalesNO.isEnterKeyDown = false;
            this.txtSalesNO.IsFirstTime = true;
            this.txtSalesNO.isMaxLengthErr = false;
            this.txtSalesNO.IsNumber = true;
            this.txtSalesNO.IsShop = false;
            this.txtSalesNO.IsTimemmss = false;
            this.txtSalesNO.Length = 11;
            this.txtSalesNO.Location = new System.Drawing.Point(322, 137);
            this.txtSalesNO.MaxLength = 11;
            this.txtSalesNO.MoveNext = true;
            this.txtSalesNO.Name = "txtSalesNO";
            this.txtSalesNO.Size = new System.Drawing.Size(202, 42);
            this.txtSalesNO.TabIndex = 1;
            this.txtSalesNO.Text = "99999999999";
            this.txtSalesNO.TextSize = CKM_Controls.CKM_TextBox.FontSize.Medium;
            this.txtSalesNO.UseColorSizMode = false;
            this.txtSalesNO.KeyDown += new System.Windows.Forms.KeyEventHandler(this.txtSalesNO_KeyDown);
            // 
            // lblPrintDate
            // 
            this.lblPrintDate.AutoSize = true;
            this.lblPrintDate.Back_Color = CKM_Controls.CKMShop_Label.CKM_Color.Default;
            this.lblPrintDate.BackColor = System.Drawing.Color.Transparent;
            this.lblPrintDate.Font = new System.Drawing.Font("MS Gothic", 26F, System.Drawing.FontStyle.Bold);
            this.lblPrintDate.Font_Size = CKM_Controls.CKMShop_Label.CKM_FontSize.Normal;
            this.lblPrintDate.FontBold = true;
            this.lblPrintDate.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(130)))), ((int)(((byte)(53)))));
            this.lblPrintDate.Location = new System.Drawing.Point(45, 285);
            this.lblPrintDate.Name = "lblPrintDate";
            this.lblPrintDate.Size = new System.Drawing.Size(274, 35);
            this.lblPrintDate.TabIndex = 18;
            this.lblPrintDate.Text = "領収書印字日付";
            this.lblPrintDate.Text_Color = CKM_Controls.CKMShop_Label.CKM_Color.Green;
            this.lblPrintDate.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // lblSalseNo
            // 
            this.lblSalseNo.AutoSize = true;
            this.lblSalseNo.Back_Color = CKM_Controls.CKMShop_Label.CKM_Color.Default;
            this.lblSalseNo.BackColor = System.Drawing.SystemColors.Window;
            this.lblSalseNo.Font = new System.Drawing.Font("MS Gothic", 26F, System.Drawing.FontStyle.Bold);
            this.lblSalseNo.Font_Size = CKM_Controls.CKMShop_Label.CKM_FontSize.Normal;
            this.lblSalseNo.FontBold = true;
            this.lblSalseNo.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(130)))), ((int)(((byte)(53)))));
            this.lblSalseNo.Location = new System.Drawing.Point(119, 140);
            this.lblSalseNo.Name = "lblSalseNo";
            this.lblSalseNo.Size = new System.Drawing.Size(200, 35);
            this.lblSalseNo.TabIndex = 17;
            this.lblSalseNo.Text = "お買上番号";
            this.lblSalseNo.Text_Color = CKM_Controls.CKMShop_Label.CKM_Color.Green;
            this.lblSalseNo.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // TempoRegiRyousyuusyo
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1904, 985);
            this.Controls.Add(this.panelDetail);
            this.Margin = new System.Windows.Forms.Padding(4, 3, 4, 3);
            this.Name = "TempoRegiRyousyuusyo";
            this.Text = "店舗領収書印刷";
            this.Load += new System.EventHandler(this.TempoRegiRyousyuusyo_Load);
            this.Controls.SetChildIndex(this.panelDetail, 0);
            this.panelDetail.ResumeLayout(false);
            this.panelDetail.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Panel panelDetail;
        private CKM_Controls.CKM_TextBox txtSalesNO;
        private CKM_Controls.CKMShop_Label lblPrintDate;
        private CKM_Controls.CKMShop_Label lblSalseNo;
        private CKM_Controls.CKMShop_CheckBox chkRyousyuusho;
        private CKM_Controls.CKMShop_Label lblRyousyuusho;
        private CKM_Controls.CKM_TextBox txtPrintDate;
        private CKM_Controls.CKMShop_CheckBox chkReceipt;
        private CKM_Controls.CKMShop_Label lblReceipt;
        private CKM_Controls.CKM_TextBox txtAmountOfMoney;
        private CKM_Controls.CKMShop_Label ckmShop_Label1;
    }
}

