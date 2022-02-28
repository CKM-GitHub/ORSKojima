namespace MainMenu
{
    partial class ChangeInfo
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
            this.txt_old = new CKM_Controls.CKM_TextBox();
            this.txt_new = new CKM_Controls.CKM_TextBox();
            this.txt_confirm = new CKM_Controls.CKM_TextBox();
            this.ckM_Label1 = new CKM_Controls.CKM_Label();
            this.ckM_Label2 = new CKM_Controls.CKM_Label();
            this.ckM_Label3 = new CKM_Controls.CKM_Label();
            this.ckM_Label4 = new CKM_Controls.CKM_Label();
            this.button7 = new System.Windows.Forms.Button();
            this.btn_All = new System.Windows.Forms.Button();
            this.ckM_Label5 = new CKM_Controls.CKM_Label();
            this.txt_Name = new CKM_Controls.CKM_TextBox();
            this.SuspendLayout();
            // 
            // txt_old
            // 
            this.txt_old.AllowMinus = false;
            this.txt_old.Back_Color = CKM_Controls.CKM_TextBox.CKM_Color.White;
            this.txt_old.BackColor = System.Drawing.Color.White;
            this.txt_old.BorderColor = false;
            this.txt_old.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.txt_old.ClientColor = System.Drawing.SystemColors.Window;
            this.txt_old.Ctrl_Byte = CKM_Controls.CKM_TextBox.Bytes.半角;
            this.txt_old.Ctrl_Type = CKM_Controls.CKM_TextBox.Type.Normal;
            this.txt_old.DecimalPlace = 0;
            this.txt_old.Enabled = false;
            this.txt_old.Font = new System.Drawing.Font("MS Gothic", 9F);
            this.txt_old.IntegerPart = 0;
            this.txt_old.IsCorrectDate = true;
            this.txt_old.isEnterKeyDown = false;
            this.txt_old.IsFirstTime = true;
            this.txt_old.isMaxLengthErr = false;
            this.txt_old.IsNumber = true;
            this.txt_old.IsShop = false;
            this.txt_old.IsTimemmss = false;
            this.txt_old.Length = 32767;
            this.txt_old.Location = new System.Drawing.Point(206, 125);
            this.txt_old.MoveNext = true;
            this.txt_old.Name = "txt_old";
            this.txt_old.PasswordChar = '*';
            this.txt_old.Size = new System.Drawing.Size(274, 19);
            this.txt_old.TabIndex = 1;
            this.txt_old.TextSize = CKM_Controls.CKM_TextBox.FontSize.Normal;
            this.txt_old.UseColorSizMode = false;
            // 
            // txt_new
            // 
            this.txt_new.AllowMinus = false;
            this.txt_new.Back_Color = CKM_Controls.CKM_TextBox.CKM_Color.White;
            this.txt_new.BackColor = System.Drawing.Color.White;
            this.txt_new.BorderColor = false;
            this.txt_new.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.txt_new.ClientColor = System.Drawing.SystemColors.Window;
            this.txt_new.Ctrl_Byte = CKM_Controls.CKM_TextBox.Bytes.半角;
            this.txt_new.Ctrl_Type = CKM_Controls.CKM_TextBox.Type.Normal;
            this.txt_new.DecimalPlace = 0;
            this.txt_new.Font = new System.Drawing.Font("MS Gothic", 9F);
            this.txt_new.IntegerPart = 0;
            this.txt_new.IsCorrectDate = true;
            this.txt_new.isEnterKeyDown = false;
            this.txt_new.IsFirstTime = true;
            this.txt_new.isMaxLengthErr = false;
            this.txt_new.IsNumber = true;
            this.txt_new.IsShop = false;
            this.txt_new.IsTimemmss = false;
            this.txt_new.Length = 10;
            this.txt_new.Location = new System.Drawing.Point(206, 171);
            this.txt_new.MaxLength = 10;
            this.txt_new.MoveNext = true;
            this.txt_new.Name = "txt_new";
            this.txt_new.PasswordChar = '*';
            this.txt_new.Size = new System.Drawing.Size(274, 19);
            this.txt_new.TabIndex = 2;
            this.txt_new.TextSize = CKM_Controls.CKM_TextBox.FontSize.Normal;
            this.txt_new.UseColorSizMode = false;
            // 
            // txt_confirm
            // 
            this.txt_confirm.AllowMinus = false;
            this.txt_confirm.Back_Color = CKM_Controls.CKM_TextBox.CKM_Color.White;
            this.txt_confirm.BackColor = System.Drawing.Color.White;
            this.txt_confirm.BorderColor = false;
            this.txt_confirm.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.txt_confirm.ClientColor = System.Drawing.SystemColors.Window;
            this.txt_confirm.Ctrl_Byte = CKM_Controls.CKM_TextBox.Bytes.半角;
            this.txt_confirm.Ctrl_Type = CKM_Controls.CKM_TextBox.Type.Normal;
            this.txt_confirm.DecimalPlace = 0;
            this.txt_confirm.Font = new System.Drawing.Font("MS Gothic", 9F);
            this.txt_confirm.IntegerPart = 0;
            this.txt_confirm.IsCorrectDate = true;
            this.txt_confirm.isEnterKeyDown = false;
            this.txt_confirm.IsFirstTime = true;
            this.txt_confirm.isMaxLengthErr = false;
            this.txt_confirm.IsNumber = true;
            this.txt_confirm.IsShop = false;
            this.txt_confirm.IsTimemmss = false;
            this.txt_confirm.Length = 10;
            this.txt_confirm.Location = new System.Drawing.Point(206, 217);
            this.txt_confirm.MaxLength = 10;
            this.txt_confirm.MoveNext = true;
            this.txt_confirm.Name = "txt_confirm";
            this.txt_confirm.PasswordChar = '*';
            this.txt_confirm.Size = new System.Drawing.Size(274, 19);
            this.txt_confirm.TabIndex = 3;
            this.txt_confirm.TextSize = CKM_Controls.CKM_TextBox.FontSize.Normal;
            this.txt_confirm.UseColorSizMode = false;
            // 
            // ckM_Label1
            // 
            this.ckM_Label1.AutoSize = true;
            this.ckM_Label1.Back_Color = CKM_Controls.CKM_Label.CKM_Color.Default;
            this.ckM_Label1.BackColor = System.Drawing.Color.Transparent;
            this.ckM_Label1.DefaultlabelSize = true;
            this.ckM_Label1.Font = new System.Drawing.Font("MS Gothic", 9F, System.Drawing.FontStyle.Bold);
            this.ckM_Label1.Font_Size = CKM_Controls.CKM_Label.CKM_FontSize.Normal;
            this.ckM_Label1.ForeColor = System.Drawing.Color.Black;
            this.ckM_Label1.Location = new System.Drawing.Point(81, 127);
            this.ckM_Label1.Name = "ckM_Label1";
            this.ckM_Label1.Size = new System.Drawing.Size(109, 12);
            this.ckM_Label1.TabIndex = 3;
            this.ckM_Label1.Text = "現在のパスワード";
            this.ckM_Label1.Text_Color = CKM_Controls.CKM_Label.CKM_Color.Default;
            this.ckM_Label1.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // ckM_Label2
            // 
            this.ckM_Label2.AutoSize = true;
            this.ckM_Label2.Back_Color = CKM_Controls.CKM_Label.CKM_Color.Default;
            this.ckM_Label2.BackColor = System.Drawing.Color.Transparent;
            this.ckM_Label2.DefaultlabelSize = true;
            this.ckM_Label2.Font = new System.Drawing.Font("MS Gothic", 9F, System.Drawing.FontStyle.Bold);
            this.ckM_Label2.Font_Size = CKM_Controls.CKM_Label.CKM_FontSize.Normal;
            this.ckM_Label2.ForeColor = System.Drawing.Color.Black;
            this.ckM_Label2.Location = new System.Drawing.Point(81, 175);
            this.ckM_Label2.Name = "ckM_Label2";
            this.ckM_Label2.Size = new System.Drawing.Size(109, 12);
            this.ckM_Label2.TabIndex = 4;
            this.ckM_Label2.Text = "新しいパスワード";
            this.ckM_Label2.Text_Color = CKM_Controls.CKM_Label.CKM_Color.Default;
            this.ckM_Label2.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // ckM_Label3
            // 
            this.ckM_Label3.AutoSize = true;
            this.ckM_Label3.Back_Color = CKM_Controls.CKM_Label.CKM_Color.Default;
            this.ckM_Label3.BackColor = System.Drawing.Color.Transparent;
            this.ckM_Label3.DefaultlabelSize = true;
            this.ckM_Label3.Font = new System.Drawing.Font("MS Gothic", 9F, System.Drawing.FontStyle.Bold);
            this.ckM_Label3.Font_Size = CKM_Controls.CKM_Label.CKM_FontSize.Normal;
            this.ckM_Label3.ForeColor = System.Drawing.Color.Black;
            this.ckM_Label3.Location = new System.Drawing.Point(8, 219);
            this.ckM_Label3.Name = "ckM_Label3";
            this.ckM_Label3.Size = new System.Drawing.Size(187, 12);
            this.ckM_Label3.TabIndex = 5;
            this.ckM_Label3.Text = "新しいパスワード（確認入力）";
            this.ckM_Label3.Text_Color = CKM_Controls.CKM_Label.CKM_Color.Default;
            this.ckM_Label3.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // ckM_Label4
            // 
            this.ckM_Label4.AutoSize = true;
            this.ckM_Label4.Back_Color = CKM_Controls.CKM_Label.CKM_Color.Default;
            this.ckM_Label4.BackColor = System.Drawing.Color.Transparent;
            this.ckM_Label4.DefaultlabelSize = true;
            this.ckM_Label4.Font = new System.Drawing.Font("MS Gothic", 14F, System.Drawing.FontStyle.Bold);
            this.ckM_Label4.Font_Size = CKM_Controls.CKM_Label.CKM_FontSize.Small;
            this.ckM_Label4.ForeColor = System.Drawing.Color.Black;
            this.ckM_Label4.Location = new System.Drawing.Point(67, 26);
            this.ckM_Label4.Name = "ckM_Label4";
            this.ckM_Label4.Size = new System.Drawing.Size(177, 19);
            this.ckM_Label4.TabIndex = 33;
            this.ckM_Label4.Text = "ユーザー情報変更";
            this.ckM_Label4.Text_Color = CKM_Controls.CKM_Label.CKM_Color.Default;
            this.ckM_Label4.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // button7
            // 
            this.button7.BackgroundImage = global::CapitalStore.Properties.Resources.bm_3;
            this.button7.Font = new System.Drawing.Font("MS Gothic", 14F, System.Drawing.FontStyle.Bold);
            this.button7.ForeColor = System.Drawing.Color.White;
            this.button7.Location = new System.Drawing.Point(57, 312);
            this.button7.Name = "button7";
            this.button7.Size = new System.Drawing.Size(138, 31);
            this.button7.TabIndex = 5;
            this.button7.Text = "閉じる";
            this.button7.UseVisualStyleBackColor = true;
            this.button7.Click += new System.EventHandler(this.button7_Click);
            // 
            // btn_All
            // 
            this.btn_All.BackgroundImage = global::CapitalStore.Properties.Resources.bm_3;
            this.btn_All.Font = new System.Drawing.Font("MS Gothic", 14F, System.Drawing.FontStyle.Bold);
            this.btn_All.ForeColor = System.Drawing.Color.White;
            this.btn_All.Location = new System.Drawing.Point(342, 312);
            this.btn_All.Name = "btn_All";
            this.btn_All.Size = new System.Drawing.Size(138, 31);
            this.btn_All.TabIndex = 4;
            this.btn_All.Text = "更新";
            this.btn_All.UseVisualStyleBackColor = true;
            this.btn_All.Click += new System.EventHandler(this.btn_All_Click);
            // 
            // ckM_Label5
            // 
            this.ckM_Label5.AutoSize = true;
            this.ckM_Label5.Back_Color = CKM_Controls.CKM_Label.CKM_Color.Default;
            this.ckM_Label5.BackColor = System.Drawing.Color.Transparent;
            this.ckM_Label5.DefaultlabelSize = true;
            this.ckM_Label5.Font = new System.Drawing.Font("MS Gothic", 9F, System.Drawing.FontStyle.Bold);
            this.ckM_Label5.Font_Size = CKM_Controls.CKM_Label.CKM_FontSize.Normal;
            this.ckM_Label5.ForeColor = System.Drawing.Color.Black;
            this.ckM_Label5.Location = new System.Drawing.Point(116, 79);
            this.ckM_Label5.Name = "ckM_Label5";
            this.ckM_Label5.Size = new System.Drawing.Size(70, 12);
            this.ckM_Label5.TabIndex = 35;
            this.ckM_Label5.Text = "スタッフ名";
            this.ckM_Label5.Text_Color = CKM_Controls.CKM_Label.CKM_Color.Default;
            this.ckM_Label5.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // txt_Name
            // 
            this.txt_Name.AllowMinus = false;
            this.txt_Name.Back_Color = CKM_Controls.CKM_TextBox.CKM_Color.White;
            this.txt_Name.BackColor = System.Drawing.Color.White;
            this.txt_Name.BorderColor = false;
            this.txt_Name.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.txt_Name.ClientColor = System.Drawing.SystemColors.Window;
            this.txt_Name.Ctrl_Byte = CKM_Controls.CKM_TextBox.Bytes.半角;
            this.txt_Name.Ctrl_Type = CKM_Controls.CKM_TextBox.Type.Normal;
            this.txt_Name.DecimalPlace = 0;
            this.txt_Name.Enabled = false;
            this.txt_Name.Font = new System.Drawing.Font("MS Gothic", 9F);
            this.txt_Name.IntegerPart = 0;
            this.txt_Name.IsCorrectDate = true;
            this.txt_Name.isEnterKeyDown = false;
            this.txt_Name.IsFirstTime = true;
            this.txt_Name.isMaxLengthErr = false;
            this.txt_Name.IsNumber = true;
            this.txt_Name.IsShop = false;
            this.txt_Name.IsTimemmss = false;
            this.txt_Name.Length = 32767;
            this.txt_Name.Location = new System.Drawing.Point(206, 77);
            this.txt_Name.MoveNext = true;
            this.txt_Name.Name = "txt_Name";
            this.txt_Name.Size = new System.Drawing.Size(274, 19);
            this.txt_Name.TabIndex = 0;
            this.txt_Name.TextSize = CKM_Controls.CKM_TextBox.FontSize.Normal;
            this.txt_Name.UseColorSizMode = false;
            this.txt_Name.TextChanged += new System.EventHandler(this.ckM_TextBox4_TextChanged_1);
            // 
            // ChangeInfo
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.White;
            this.ClientSize = new System.Drawing.Size(551, 372);
            this.Controls.Add(this.ckM_Label5);
            this.Controls.Add(this.txt_Name);
            this.Controls.Add(this.btn_All);
            this.Controls.Add(this.button7);
            this.Controls.Add(this.ckM_Label4);
            this.Controls.Add(this.ckM_Label3);
            this.Controls.Add(this.ckM_Label2);
            this.Controls.Add(this.ckM_Label1);
            this.Controls.Add(this.txt_confirm);
            this.Controls.Add(this.txt_new);
            this.Controls.Add(this.txt_old);
            this.KeyPreview = true;
            this.Name = "ChangeInfo";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "ユーザー情報";
            this.Load += new System.EventHandler(this.ChangeInfo_Load);
            this.KeyDown += new System.Windows.Forms.KeyEventHandler(this.ChangeInfo_KeyDown);
            this.KeyUp += new System.Windows.Forms.KeyEventHandler(this.ChangeInfo_KeyUp);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private CKM_Controls.CKM_TextBox txt_old;
        private CKM_Controls.CKM_TextBox txt_new;
        private CKM_Controls.CKM_TextBox txt_confirm;
        private CKM_Controls.CKM_Label ckM_Label1;
        private CKM_Controls.CKM_Label ckM_Label2;
        private CKM_Controls.CKM_Label ckM_Label3;
        private CKM_Controls.CKM_Label ckM_Label4;
        private System.Windows.Forms.Button button7;
        private System.Windows.Forms.Button btn_All;
        private CKM_Controls.CKM_Label ckM_Label5;
        private CKM_Controls.CKM_TextBox txt_Name;
    }
}