namespace MasterTouroku_Henkan
{
    partial class MasterTouroku_Henkan
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
            this.panel1 = new System.Windows.Forms.Panel();
            this.panel3 = new System.Windows.Forms.Panel();
            this.TokuisakiCD = new CKM_Controls.CKM_TextBox();
            this.LB_Tokuisaki = new System.Windows.Forms.Label();
            this.ckM_Label6 = new CKM_Controls.CKM_Label();
            this.ckM_Label5 = new CKM_Controls.CKM_Label();
            this.ckM_Label4 = new CKM_Controls.CKM_Label();
            this.RCMItemValue = new CKM_Controls.CKM_TextBox();
            this.ckM_ComboBox1 = new CKM_Controls.CKM_ComboBox();
            this.panel2 = new System.Windows.Forms.Panel();
            this.ckM_Label8 = new CKM_Controls.CKM_Label();
            this.Label4 = new CKM_Controls.CKM_Label();
            this.RCMItemName = new CKM_Controls.CKM_TextBox();
            this.CsvOutputItemValue = new CKM_Controls.CKM_TextBox();
            this.CsvTitleName = new CKM_Controls.CKM_TextBox();
            this.PanelHeader.SuspendLayout();
            this.panel1.SuspendLayout();
            this.panel3.SuspendLayout();
            this.panel2.SuspendLayout();
            this.SuspendLayout();
            // 
            // PanelHeader
            // 
            this.PanelHeader.Controls.Add(this.panel1);
            this.PanelHeader.Size = new System.Drawing.Size(1711, 144);
            this.PanelHeader.Controls.SetChildIndex(this.panel1, 0);
            // 
            // PanelSearch
            // 
            this.PanelSearch.Location = new System.Drawing.Point(1177, 0);
            // 
            // btnChangeIkkatuHacchuuMode
            // 
            this.btnChangeIkkatuHacchuuMode.FlatAppearance.BorderColor = System.Drawing.Color.Black;
            // 
            // panel1
            // 
            this.panel1.BackColor = System.Drawing.Color.Transparent;
            this.panel1.Controls.Add(this.panel3);
            this.panel1.Location = new System.Drawing.Point(40, -20);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(1000, 160);
            this.panel1.TabIndex = 0;
            // 
            // panel3
            // 
            this.panel3.Controls.Add(this.RCMItemName);
            this.panel3.Controls.Add(this.TokuisakiCD);
            this.panel3.Controls.Add(this.LB_Tokuisaki);
            this.panel3.Controls.Add(this.ckM_Label6);
            this.panel3.Controls.Add(this.ckM_Label5);
            this.panel3.Controls.Add(this.ckM_Label4);
            this.panel3.Controls.Add(this.RCMItemValue);
            this.panel3.Controls.Add(this.ckM_ComboBox1);
            this.panel3.Location = new System.Drawing.Point(1, 21);
            this.panel3.Name = "panel3";
            this.panel3.Size = new System.Drawing.Size(998, 140);
            this.panel3.TabIndex = 0;
            // 
            // TokuisakiCD
            // 
            this.TokuisakiCD.AllowMinus = false;
            this.TokuisakiCD.Back_Color = CKM_Controls.CKM_TextBox.CKM_Color.White;
            this.TokuisakiCD.BackColor = System.Drawing.Color.White;
            this.TokuisakiCD.BorderColor = false;
            this.TokuisakiCD.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.TokuisakiCD.ClientColor = System.Drawing.SystemColors.Window;
            this.TokuisakiCD.Ctrl_Byte = CKM_Controls.CKM_TextBox.Bytes.半角;
            this.TokuisakiCD.Ctrl_Type = CKM_Controls.CKM_TextBox.Type.Normal;
            this.TokuisakiCD.DecimalPlace = 0;
            this.TokuisakiCD.EnabledInsertKeyModeOnMouseEnter = false;
            this.TokuisakiCD.Font = new System.Drawing.Font("MS Gothic", 9F);
            this.TokuisakiCD.ImeMode = System.Windows.Forms.ImeMode.Off;
            this.TokuisakiCD.InsertKeyMode = System.Windows.Forms.InsertKeyMode.Overwrite;
            this.TokuisakiCD.IntegerPart = 0;
            this.TokuisakiCD.IsCorrectDate = true;
            this.TokuisakiCD.isEnterKeyDown = false;
            this.TokuisakiCD.IsFirstTime = true;
            this.TokuisakiCD.isMaxLengthErr = false;
            this.TokuisakiCD.IsNumber = true;
            this.TokuisakiCD.IsShop = false;
            this.TokuisakiCD.IsTimemmss = false;
            this.TokuisakiCD.Length = 5;
            this.TokuisakiCD.Location = new System.Drawing.Point(232, 21);
            this.TokuisakiCD.MaxLength = 5;
            this.TokuisakiCD.MoveNext = true;
            this.TokuisakiCD.Name = "TokuisakiCD";
            this.TokuisakiCD.Size = new System.Drawing.Size(100, 19);
            this.TokuisakiCD.TabIndex = 0;
            this.TokuisakiCD.TextSize = CKM_Controls.CKM_TextBox.FontSize.Normal;
            this.TokuisakiCD.UseColorSizMode = false;
            // 
            // LB_Tokuisaki
            // 
            this.LB_Tokuisaki.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(105)))), ((int)(((byte)(184)))), ((int)(((byte)(231)))));
            this.LB_Tokuisaki.Font = new System.Drawing.Font("MS Gothic", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.LB_Tokuisaki.Location = new System.Drawing.Point(332, 20);
            this.LB_Tokuisaki.Name = "LB_Tokuisaki";
            this.LB_Tokuisaki.Size = new System.Drawing.Size(320, 19);
            this.LB_Tokuisaki.TabIndex = 735;
            this.LB_Tokuisaki.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // ckM_Label6
            // 
            this.ckM_Label6.Back_Color = CKM_Controls.CKM_Label.CKM_Color.Default;
            this.ckM_Label6.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(255)))), ((int)(((byte)(128)))), ((int)(((byte)(128)))));
            this.ckM_Label6.DefaultlabelSize = true;
            this.ckM_Label6.Font = new System.Drawing.Font("MS Gothic", 9F, System.Drawing.FontStyle.Bold);
            this.ckM_Label6.Font_Size = CKM_Controls.CKM_Label.CKM_FontSize.Normal;
            this.ckM_Label6.ForeColor = System.Drawing.Color.White;
            this.ckM_Label6.Location = new System.Drawing.Point(140, 74);
            this.ckM_Label6.Name = "ckM_Label6";
            this.ckM_Label6.Size = new System.Drawing.Size(92, 18);
            this.ckM_Label6.TabIndex = 734;
            this.ckM_Label6.Text = "RCM項目値";
            this.ckM_Label6.Text_Color = CKM_Controls.CKM_Label.CKM_Color.Default;
            this.ckM_Label6.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // ckM_Label5
            // 
            this.ckM_Label5.Back_Color = CKM_Controls.CKM_Label.CKM_Color.Default;
            this.ckM_Label5.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(255)))), ((int)(((byte)(128)))), ((int)(((byte)(128)))));
            this.ckM_Label5.DefaultlabelSize = true;
            this.ckM_Label5.Font = new System.Drawing.Font("MS Gothic", 9F, System.Drawing.FontStyle.Bold);
            this.ckM_Label5.Font_Size = CKM_Controls.CKM_Label.CKM_FontSize.Normal;
            this.ckM_Label5.ForeColor = System.Drawing.Color.White;
            this.ckM_Label5.Location = new System.Drawing.Point(140, 49);
            this.ckM_Label5.Name = "ckM_Label5";
            this.ckM_Label5.Size = new System.Drawing.Size(92, 18);
            this.ckM_Label5.TabIndex = 732;
            this.ckM_Label5.Text = "RCM項目名";
            this.ckM_Label5.Text_Color = CKM_Controls.CKM_Label.CKM_Color.Default;
            this.ckM_Label5.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // ckM_Label4
            // 
            this.ckM_Label4.Back_Color = CKM_Controls.CKM_Label.CKM_Color.Default;
            this.ckM_Label4.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(255)))), ((int)(((byte)(128)))), ((int)(((byte)(128)))));
            this.ckM_Label4.DefaultlabelSize = true;
            this.ckM_Label4.Font = new System.Drawing.Font("MS Gothic", 9F, System.Drawing.FontStyle.Bold);
            this.ckM_Label4.Font_Size = CKM_Controls.CKM_Label.CKM_FontSize.Normal;
            this.ckM_Label4.ForeColor = System.Drawing.Color.White;
            this.ckM_Label4.Location = new System.Drawing.Point(140, 22);
            this.ckM_Label4.Name = "ckM_Label4";
            this.ckM_Label4.Size = new System.Drawing.Size(92, 18);
            this.ckM_Label4.TabIndex = 730;
            this.ckM_Label4.Text = "得意先";
            this.ckM_Label4.Text_Color = CKM_Controls.CKM_Label.CKM_Color.Default;
            this.ckM_Label4.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // RCMItemValue
            // 
            this.RCMItemValue.AllowMinus = false;
            this.RCMItemValue.Back_Color = CKM_Controls.CKM_TextBox.CKM_Color.White;
            this.RCMItemValue.BackColor = System.Drawing.Color.White;
            this.RCMItemValue.BorderColor = false;
            this.RCMItemValue.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.RCMItemValue.ClientColor = System.Drawing.Color.White;
            this.RCMItemValue.Ctrl_Byte = CKM_Controls.CKM_TextBox.Bytes.半全角;
            this.RCMItemValue.Ctrl_Type = CKM_Controls.CKM_TextBox.Type.Normal;
            this.RCMItemValue.DecimalPlace = 0;
            this.RCMItemValue.EnabledInsertKeyModeOnMouseEnter = false;
            this.RCMItemValue.Font = new System.Drawing.Font("MS Gothic", 9F);
            this.RCMItemValue.ImeMode = System.Windows.Forms.ImeMode.Off;
            this.RCMItemValue.InsertKeyMode = System.Windows.Forms.InsertKeyMode.Overwrite;
            this.RCMItemValue.IntegerPart = 0;
            this.RCMItemValue.IsCorrectDate = true;
            this.RCMItemValue.isEnterKeyDown = false;
            this.RCMItemValue.IsFirstTime = true;
            this.RCMItemValue.isMaxLengthErr = false;
            this.RCMItemValue.IsNumber = true;
            this.RCMItemValue.IsShop = false;
            this.RCMItemValue.IsTimemmss = false;
            this.RCMItemValue.Length = 50;
            this.RCMItemValue.Location = new System.Drawing.Point(232, 73);
            this.RCMItemValue.MaxLength = 50;
            this.RCMItemValue.MoveNext = true;
            this.RCMItemValue.Name = "RCMItemValue";
            this.RCMItemValue.Size = new System.Drawing.Size(305, 19);
            this.RCMItemValue.TabIndex = 2;
            this.RCMItemValue.TextSize = CKM_Controls.CKM_TextBox.FontSize.Normal;
            this.RCMItemValue.UseColorSizMode = false;
            // 
            // ckM_ComboBox1
            // 
            this.ckM_ComboBox1.AutoCompleteMode = System.Windows.Forms.AutoCompleteMode.Append;
            this.ckM_ComboBox1.AutoCompleteSource = System.Windows.Forms.AutoCompleteSource.ListItems;
            this.ckM_ComboBox1.Cbo_Type = CKM_Controls.CKM_ComboBox.CboType.Default;
            this.ckM_ComboBox1.Ctrl_Byte = CKM_Controls.CKM_ComboBox.Bytes.半角;
            this.ckM_ComboBox1.Flag = 0;
            this.ckM_ComboBox1.FormattingEnabled = true;
            this.ckM_ComboBox1.Length = 10;
            this.ckM_ComboBox1.Location = new System.Drawing.Point(6, 20);
            this.ckM_ComboBox1.MaxLength = 10;
            this.ckM_ComboBox1.MoveNext = true;
            this.ckM_ComboBox1.Name = "ckM_ComboBox1";
            this.ckM_ComboBox1.Size = new System.Drawing.Size(100, 20);
            this.ckM_ComboBox1.TabIndex = 729;
            this.ckM_ComboBox1.Visible = false;
            // 
            // panel2
            // 
            this.panel2.Controls.Add(this.CsvTitleName);
            this.panel2.Controls.Add(this.ckM_Label8);
            this.panel2.Controls.Add(this.Label4);
            this.panel2.Controls.Add(this.CsvOutputItemValue);
            this.panel2.Location = new System.Drawing.Point(0, 200);
            this.panel2.Name = "panel2";
            this.panel2.Size = new System.Drawing.Size(1710, 650);
            this.panel2.TabIndex = 3;
            // 
            // ckM_Label8
            // 
            this.ckM_Label8.Back_Color = CKM_Controls.CKM_Label.CKM_Color.Default;
            this.ckM_Label8.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(255)))), ((int)(((byte)(255)))), ((int)(((byte)(128)))));
            this.ckM_Label8.DefaultlabelSize = true;
            this.ckM_Label8.Font = new System.Drawing.Font("MS Gothic", 9F, System.Drawing.FontStyle.Bold);
            this.ckM_Label8.Font_Size = CKM_Controls.CKM_Label.CKM_FontSize.Normal;
            this.ckM_Label8.ForeColor = System.Drawing.Color.Black;
            this.ckM_Label8.Location = new System.Drawing.Point(182, 53);
            this.ckM_Label8.Name = "ckM_Label8";
            this.ckM_Label8.Size = new System.Drawing.Size(92, 17);
            this.ckM_Label8.TabIndex = 107;
            this.ckM_Label8.Text = "CSVタイトル名";
            this.ckM_Label8.Text_Color = CKM_Controls.CKM_Label.CKM_Color.Default;
            this.ckM_Label8.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // Label4
            // 
            this.Label4.Back_Color = CKM_Controls.CKM_Label.CKM_Color.Default;
            this.Label4.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(255)))), ((int)(((byte)(255)))), ((int)(((byte)(128)))));
            this.Label4.DefaultlabelSize = true;
            this.Label4.Font = new System.Drawing.Font("MS Gothic", 9F, System.Drawing.FontStyle.Bold);
            this.Label4.Font_Size = CKM_Controls.CKM_Label.CKM_FontSize.Normal;
            this.Label4.ForeColor = System.Drawing.Color.Black;
            this.Label4.Location = new System.Drawing.Point(182, 20);
            this.Label4.Name = "Label4";
            this.Label4.Size = new System.Drawing.Size(92, 17);
            this.Label4.TabIndex = 106;
            this.Label4.Text = "CSV出力項目値";
            this.Label4.Text_Color = CKM_Controls.CKM_Label.CKM_Color.Default;
            this.Label4.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // RCMItemName
            // 
            this.RCMItemName.AllowMinus = false;
            this.RCMItemName.Back_Color = CKM_Controls.CKM_TextBox.CKM_Color.White;
            this.RCMItemName.BackColor = System.Drawing.Color.White;
            this.RCMItemName.BorderColor = false;
            this.RCMItemName.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.RCMItemName.ClientColor = System.Drawing.SystemColors.Window;
            this.RCMItemName.Ctrl_Byte = CKM_Controls.CKM_TextBox.Bytes.半全角;
            this.RCMItemName.Ctrl_Type = CKM_Controls.CKM_TextBox.Type.Normal;
            this.RCMItemName.DecimalPlace = 0;
            this.RCMItemName.EnabledInsertKeyModeOnMouseEnter = false;
            this.RCMItemName.Font = new System.Drawing.Font("MS Gothic", 9F);
            this.RCMItemName.ImeMode = System.Windows.Forms.ImeMode.On;
            this.RCMItemName.InsertKeyMode = System.Windows.Forms.InsertKeyMode.Overwrite;
            this.RCMItemName.IntegerPart = 0;
            this.RCMItemName.IsCorrectDate = true;
            this.RCMItemName.isEnterKeyDown = false;
            this.RCMItemName.IsFirstTime = true;
            this.RCMItemName.isMaxLengthErr = false;
            this.RCMItemName.IsNumber = true;
            this.RCMItemName.IsShop = false;
            this.RCMItemName.IsTimemmss = false;
            this.RCMItemName.Length = 50;
            this.RCMItemName.Location = new System.Drawing.Point(232, 48);
            this.RCMItemName.MaxLength = 50;
            this.RCMItemName.MoveNext = true;
            this.RCMItemName.Name = "RCMItemName";
            this.RCMItemName.Size = new System.Drawing.Size(305, 19);
            this.RCMItemName.TabIndex = 1;
            this.RCMItemName.TextSize = CKM_Controls.CKM_TextBox.FontSize.Normal;
            this.RCMItemName.UseColorSizMode = false;
            // 
            // CsvOutputItemValue
            // 
            this.CsvOutputItemValue.AllowMinus = false;
            this.CsvOutputItemValue.Back_Color = CKM_Controls.CKM_TextBox.CKM_Color.White;
            this.CsvOutputItemValue.BackColor = System.Drawing.Color.White;
            this.CsvOutputItemValue.BorderColor = false;
            this.CsvOutputItemValue.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.CsvOutputItemValue.ClientColor = System.Drawing.Color.White;
            this.CsvOutputItemValue.Ctrl_Byte = CKM_Controls.CKM_TextBox.Bytes.半全角;
            this.CsvOutputItemValue.Ctrl_Type = CKM_Controls.CKM_TextBox.Type.Normal;
            this.CsvOutputItemValue.DecimalPlace = 0;
            this.CsvOutputItemValue.Enabled = false;
            this.CsvOutputItemValue.EnabledInsertKeyModeOnMouseEnter = false;
            this.CsvOutputItemValue.Font = new System.Drawing.Font("MS Gothic", 9F);
            this.CsvOutputItemValue.ImeMode = System.Windows.Forms.ImeMode.Off;
            this.CsvOutputItemValue.InsertKeyMode = System.Windows.Forms.InsertKeyMode.Overwrite;
            this.CsvOutputItemValue.IntegerPart = 0;
            this.CsvOutputItemValue.IsCorrectDate = true;
            this.CsvOutputItemValue.isEnterKeyDown = false;
            this.CsvOutputItemValue.IsFirstTime = true;
            this.CsvOutputItemValue.isMaxLengthErr = false;
            this.CsvOutputItemValue.IsNumber = true;
            this.CsvOutputItemValue.IsShop = false;
            this.CsvOutputItemValue.IsTimemmss = false;
            this.CsvOutputItemValue.Length = 50;
            this.CsvOutputItemValue.Location = new System.Drawing.Point(274, 19);
            this.CsvOutputItemValue.MaxLength = 50;
            this.CsvOutputItemValue.MoveNext = true;
            this.CsvOutputItemValue.Name = "CsvOutputItemValue";
            this.CsvOutputItemValue.Size = new System.Drawing.Size(305, 19);
            this.CsvOutputItemValue.TabIndex = 0;
            this.CsvOutputItemValue.TextSize = CKM_Controls.CKM_TextBox.FontSize.Normal;
            this.CsvOutputItemValue.UseColorSizMode = false;
            // 
            // CsvTitleName
            // 
            this.CsvTitleName.AllowMinus = false;
            this.CsvTitleName.Back_Color = CKM_Controls.CKM_TextBox.CKM_Color.White;
            this.CsvTitleName.BackColor = System.Drawing.Color.White;
            this.CsvTitleName.BorderColor = false;
            this.CsvTitleName.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.CsvTitleName.ClientColor = System.Drawing.SystemColors.Window;
            this.CsvTitleName.Ctrl_Byte = CKM_Controls.CKM_TextBox.Bytes.半全角;
            this.CsvTitleName.Ctrl_Type = CKM_Controls.CKM_TextBox.Type.Normal;
            this.CsvTitleName.DecimalPlace = 0;
            this.CsvTitleName.EnabledInsertKeyModeOnMouseEnter = false;
            this.CsvTitleName.Font = new System.Drawing.Font("MS Gothic", 9F);
            this.CsvTitleName.ImeMode = System.Windows.Forms.ImeMode.On;
            this.CsvTitleName.InsertKeyMode = System.Windows.Forms.InsertKeyMode.Overwrite;
            this.CsvTitleName.IntegerPart = 0;
            this.CsvTitleName.IsCorrectDate = true;
            this.CsvTitleName.isEnterKeyDown = false;
            this.CsvTitleName.IsFirstTime = true;
            this.CsvTitleName.isMaxLengthErr = false;
            this.CsvTitleName.IsNumber = true;
            this.CsvTitleName.IsShop = false;
            this.CsvTitleName.IsTimemmss = false;
            this.CsvTitleName.Length = 50;
            this.CsvTitleName.Location = new System.Drawing.Point(274, 51);
            this.CsvTitleName.MaxLength = 50;
            this.CsvTitleName.MoveNext = true;
            this.CsvTitleName.Name = "CsvTitleName";
            this.CsvTitleName.Size = new System.Drawing.Size(305, 19);
            this.CsvTitleName.TabIndex = 1;
            this.CsvTitleName.TextSize = CKM_Controls.CKM_TextBox.FontSize.Normal;
            this.CsvTitleName.UseColorSizMode = false;
            // 
            // MasterTouroku_Henkan
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1713, 887);
            this.Controls.Add(this.panel2);
            this.F8Visible = false;
            this.Location = new System.Drawing.Point(0, 0);
            this.ModeVisible = true;
            this.Name = "MasterTouroku_Henkan";
            this.PanelHeaderHeight = 200;
            this.Text = "MasterTouroku_Henkan";
            this.Load += new System.EventHandler(this.MasterTouroku_Henkan_Load);
            this.Controls.SetChildIndex(this.panel2, 0);
            this.PanelHeader.ResumeLayout(false);
            this.panel1.ResumeLayout(false);
            this.panel3.ResumeLayout(false);
            this.panel3.PerformLayout();
            this.panel2.ResumeLayout(false);
            this.panel2.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.Panel panel2;
        private CKM_Controls.CKM_Label ckM_Label8;
        private CKM_Controls.CKM_Label Label4;
        private System.Windows.Forms.Panel panel3;
        private System.Windows.Forms.Label LB_Tokuisaki;
        private CKM_Controls.CKM_Label ckM_Label6;
        private CKM_Controls.CKM_Label ckM_Label5;
        private CKM_Controls.CKM_Label ckM_Label4;
        private CKM_Controls.CKM_TextBox RCMItemValue;
        private CKM_Controls.CKM_ComboBox ckM_ComboBox1;
        private CKM_Controls.CKM_TextBox TokuisakiCD;
        private CKM_Controls.CKM_TextBox RCMItemName;
        private CKM_Controls.CKM_TextBox CsvTitleName;
        private CKM_Controls.CKM_TextBox CsvOutputItemValue;
    }
}

