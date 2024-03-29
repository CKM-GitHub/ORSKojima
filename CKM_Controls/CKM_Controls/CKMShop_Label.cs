﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel;
using System.Windows.Forms;
using System.Drawing;

namespace CKM_Controls
{
    public class CKMShop_Label : Label
    {
        private CKM_Color TextColor { get; set; }

        private CKM_Color BackGroundColor { get; set; }

        private CKM_FontSize FontSize { get; set; }
        public enum CKM_Color
        {
            Default,
            White,
            Green,
            DarkGreen,
            Red,
            Blue,
            Black

        }
        [Browsable(true)]
        [Category("CKM Properties")]
        [Description("Select Text Color")]
        [DisplayName("Text Color")]
        public CKM_Color Text_Color
        {
            get { return TextColor; }
            set
            {
                TextColor = value;
                switch (TextColor)
                {
                    case CKM_Color.White:
                        this.ForeColor = Color.White;
                        break;
                    case CKM_Color.Default:
                        this.ForeColor = Color.Black;
                        break;
                    case CKM_Color.Green:
                        this.ForeColor = Color.FromArgb(84, 130, 53);
                        break;
                    case CKM_Color.DarkGreen:
                        this.ForeColor = Color.FromArgb(84, 130, 53);
                        break;
                    case CKM_Color.Red:
                        this.ForeColor = Color.Red;
                        break;
                    case CKM_Color.Blue:
                        this.ForeColor = Color.Blue;
                        break;
                    case CKM_Color.Black:
                        this.ForeColor = Color.Black;
                        break;
                }
            }
        }

        [Browsable(true)]
        [Category("CKM Properties")]
        [Description("Bold")]
        [DisplayName("FontBold")]
        public bool FontBold
        {
            get {return this.Font.Bold; }
            set
            {
                if (value == true) 
                    this.Font = new System.Drawing.Font(this.Font.Name, this.Font.Size, System.Drawing.FontStyle.Bold);
                else
                    this.Font = new System.Drawing.Font(this.Font.Name, this.Font.Size, System.Drawing.FontStyle.Regular);
            }
        }


        [Browsable(true)]
        [Category("CKM Properties")]
        [Description("Select BackGround Color")]
        [DisplayName("BackGround Color")]
        public CKM_Color Back_Color
        {
            get { return BackGroundColor; }
            set
            {
                BackGroundColor = value;
                switch (BackGroundColor)
                {
                    case CKM_Color.Default:
                        this.BackColor = Color.Transparent;
                        break;
                    case CKM_Color.Green:
                        this.BackColor = Color.FromArgb(169, 208, 142);
                        break;
                    case CKM_Color.White:
                        this.BackColor = Color.White;
                        break;
                    case CKM_Color.DarkGreen:
                        this.BackColor = Color.FromArgb(84, 130, 53);
                        break;
                }

            }
        }

        public enum CKM_FontSize
        {
            Normal,
            XSmall,
            Small,
            Medium,
            Large,
            XLarge,
            XXLarge,
            Medium0,
            Specified
        }

        [Browsable(true)]
        [Category("CKM Properties")]
        [Description("Select FontSize")]
        [DisplayName("Font Size")]
        public CKM_FontSize Font_Size
        {
            get { return FontSize; }
            set
            {
                FontSize = value;
                switch (FontSize)
                {
                    case CKM_FontSize.Normal:
                        this.Font = new System.Drawing.Font("MS Gothic", 26F, System.Drawing.FontStyle.Bold);
                        break;
                    case CKM_FontSize.XSmall:
                        this.Font = new System.Drawing.Font("MS Gothic", 22F, System.Drawing.FontStyle.Bold);
                        break;
                    case CKM_FontSize.Small:
                        this.Font = new System.Drawing.Font("MS Gothic", 24F, System.Drawing.FontStyle.Bold);
                        break;
                    case CKM_FontSize.Medium:
                        this.Font = new System.Drawing.Font("MS Gothic", 28F, System.Drawing.FontStyle.Bold);
                        break;
                    case CKM_FontSize.Large:
                        this.Font = new System.Drawing.Font("MS Gothic", 30F, System.Drawing.FontStyle.Bold);
                        break;
                    case CKM_FontSize.XLarge:
                        this.Font = new System.Drawing.Font("MS Gothic", 32F, System.Drawing.FontStyle.Bold);
                        break;
                    case CKM_FontSize.XXLarge:
                        this.Font = new System.Drawing.Font("MS Gothic", 37F, System.Drawing.FontStyle.Bold);
                        break;
                    case CKM_FontSize.Medium0:
                        this.Font = new System.Drawing.Font("MS Gothic", 26F, System.Drawing.FontStyle.Bold);
                        break;
                }
            }
        }
        
        public CKMShop_Label()
        {
            if (this.FontSize != CKM_FontSize.Specified)
            {
                this.Font = new System.Drawing.Font("MS Gothic", 16F, System.Drawing.FontStyle.Bold);
            }
            string myText = "Vertical text";

            //this.TextAlign = ContentAlignment.MiddleRight;
        }

    }
}
