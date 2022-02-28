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
using DL;

namespace MainMenu
{
    public partial class ChangeInfo : Form
    {
        _Select_Source ss = new _Select_Source();
        public ChangeInfo(string id, string pass , string name)
        {
            InitializeComponent();
            txt_old.Text = pass;
            OldId = id;
            OldPass = pass;
            txt_Name.Text = name;
        }
        string OldPass = "";
        string OldId = ""; 
        private void ChangeInfo_Load(object sender, EventArgs e)
        {

        }
        

        private void button7_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void ckM_TextBox4_TextChanged_1(object sender, EventArgs e)
        {

        }

        private void btn_All_Click(object sender, EventArgs e)
        {
            if (ErrorCheck())
            {
                DialogResult dialogResult = MessageBox.Show("更新してもよろしいですか？", "確認", MessageBoxButtons.YesNo, MessageBoxIcon.Question, MessageBoxDefaultButton.Button2);
                if (dialogResult == DialogResult.Yes)
                {
                    if (txt_old.Text != OldPass)
                    {
                        txt_old.Focus();
                        MessageBox.Show("パスワードと一致しません", "エラー", MessageBoxButtons.OK, MessageBoxIcon.Error);
                        return;
                    }
                    if (txt_new.Text != txt_confirm.Text)
                    {
                        txt_new.Focus();
                        MessageBox.Show("新しいパスワードが一致していません", "エラー", MessageBoxButtons.OK, MessageBoxIcon.Error);
                        return;
                    }


                    var res = ss._changedPass( OldId, txt_confirm.Text );
                    if (res)
                    {
                        Base_BL bbl = new Base_BL();
                        var v = bbl.ShowMessage("I101");
                        txt_new.Text = txt_confirm.Text = "";
                        this.Close();
                        // return;
                    }
                    else
                        MessageBox.Show("更新に失敗しました", "エラー", MessageBoxButtons.OK, MessageBoxIcon.Error); 
                }
                else
                {
                    return;
                }
            }
            else
            {
                MessageBox.Show("更新に失敗しました", "エラー", MessageBoxButtons.OK, MessageBoxIcon.Error);
                //更新に失敗しました
            }

        }

        private bool ErrorCheck()
        {
            if (String.IsNullOrEmpty(txt_old.Text))
            {
                txt_old.Focus();
                return false;
            }
            if (String.IsNullOrEmpty(txt_new.Text))
            {
                txt_new.Focus();
                return false;
            }
            if (String.IsNullOrEmpty(txt_confirm.Text))
            {
                txt_confirm.Focus();
                return false;
            }

            return true;
        }

        private void ChangeInfo_KeyUp(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter )
            {
                UserControl sc = ActiveControl as UserControl;
             
                //if (sc != null)
                 ///   sc.SelectNextControl(ActiveControl, true, true, true, true);
                
                //this.SelectNextControl((Control)sender, false, true, true, true);

            }
        }

        private void ChangeInfo_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
            //UserControl sc = ActiveControl as UserControl;
            SelectNextControl(ActiveControl, true, true, true, true);
        }
    }
}
