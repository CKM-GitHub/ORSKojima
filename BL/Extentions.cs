using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Globalization;

namespace BL
{
    /// <summary>
    /// Date format constants.
    /// </summary>
    public static class DateTimeFormat
    {
        /// <summary>
        /// yyyy/MM/dd HH:mm:ss
        /// </summary>
        public const string yyyyMMddHHmmss = "yyyy/MM/dd HH:mm:ss";
        /// <summary>
        /// yyyy/MM/dd
        /// </summary>
        public const string yyyyMMdd = "yyyy/MM/dd";
        /// <summary>
        /// HH:mm:ss
        /// </summary>
        public const string HHmmss = "HH:mm:ss";
        /// <summary>
        /// yyyy/MM/dd HH:mm:ss
        /// </summary>
        public const string yyyyMMddHHmmssNumber = "yyyyMMdd HHmmss";
        /// <summary>
        /// yyyy/MM/dd
        /// </summary>
        public const string yyyyMMddNumber = "yyyyMMdd";
        /// <summary>
        /// HH:mm:ss
        /// </summary>
        public const string HHmmssNumber = "HHmmss";
        /// <summary>
        /// dddd
        /// </summary>
        public const string DayOfWeekLong = "dddd";
        /// <summary>
        /// ddd
        /// </summary>
        public const string DayOfWeekShort = "ddd";
    }
    public static class Extentions
    {
        /// <summary>
        /// Convert object to Int16. If it cannot be converted, it returns defaultValue.
        /// </summary>
        /// <param name="o"></param>
        /// <param name="defaultValue">The value to return if the conversion failed.</param>
        /// <returns></returns>
        public static Int16 ToInt16(this object o, Int16 defaultValue = 0)
        {
            if (o == null)
            {
                return defaultValue;
            }
            else
            {
                return ToInt16(o.ToString());
            }
        }
        /// <summary>
        /// Convert string to Int16. If it cannot be converted, it returns defaultValue.
        /// </summary>
        /// <param name="s"></param>
        /// <param name="defaultValue">The value to return if the conversion failed.</param>
        /// <returns></returns>
        public static Int16 ToInt16(this string s, Int16 defaultValue = 0)
        {
            if (Int16.TryParse(s, NumberStyles.Number, CultureInfo.CurrentCulture, out var result))
            {
                return result;
            }
            else
            {
                return defaultValue;
            }
        }
        /// <summary>
        /// Convert object to Int32. If it cannot be converted, it returns defaultValue.
        /// </summary>
        /// <param name="o"></param>
        /// <param name="defaultValue">The value to return if the conversion failed.</param>
        /// <returns></returns>
        public static Int32 ToInt32(this object o, Int32 defaultValue = 0)
        {
            if (o == null)
            {
                return defaultValue;
            }
            else
            {
                return ToInt32(o.ToString());
            }
        }
        /// <summary>
        /// Convert string to Int32. If it cannot be converted, it returns defaultValue.
        /// </summary>
        /// <param name="s"></param>
        /// <param name="defaultValue">The value to return if the conversion failed.</param>
        /// <returns></returns>
        public static Int32 ToInt32(this string s, Int32 defaultValue = 0)
        {
            if (Int32.TryParse(s, NumberStyles.Number, CultureInfo.CurrentCulture, out var result))
            {
                return result;
            }
            else
            {
                return defaultValue;
            }
        }
        /// <summary>
        /// Convert object to decimal. If it cannot be converted, it returns defaultValue.
        /// </summary>
        /// <param name="o"></param>
        /// <param name="defaultValue">The value to return if the conversion failed.</param>
        /// <returns></returns>
        public static decimal ToDecimal(this object o, decimal defaultValue = 0)
        {
            if (o == null)
            {
                return defaultValue;
            }
            else
            {
                return ToDecimal(o.ToString());
            }
        }
        /// <summary>
        /// Convert string to decimal. If it cannot be converted, it returns defaultValue.
        /// </summary>
        /// <param name="s"></param>
        /// <param name="defaultValue">The value to return if the conversion failed.</param>
        /// <returns></returns>
        public static decimal ToDecimal(this string s, decimal defaultValue = 0)
        {
            if (decimal.TryParse(s, NumberStyles.Number, CultureInfo.CurrentCulture, out var result))
            {
                return result;
            }
            else
            {
                return defaultValue;
            }
        }
        /// <summary>
        /// Convert object to byte. If it cannot be converted, it returns defaultValue.
        /// </summary>
        /// <param name="o"></param>
        /// <param name="defaultValue">The value to return if the conversion failed.</param>
        /// <returns></returns>
        public static byte ToByte(this object o, byte defaultValue = 0)
        {
            if (o == null)
            {
                return defaultValue;
            }
            else
            {
                return ToByte(o.ToString());
            }
        }
        /// <summary>
        /// Convert string to byte. If it cannot be converted, it returns defaultValue.
        /// </summary>
        /// <param name="s"></param>
        /// <param name="defaultValue">The value to return if the conversion failed.</param>
        /// <returns></returns>
        public static byte ToByte(this string s, byte defaultValue = 0)
        {
            if (byte.TryParse(s, out var result))
            {
                return result;
            }
            else
            {
                return defaultValue;
            }
        }
        /// <summary>
        /// Convert object to string. If null or empty, it returns null.
        /// </summary>
        /// <param name="o"></param>
        /// <returns></returns>
        public static string ToStringOrNull(this object o)
        {
            if (o == null || o.ToString() == string.Empty)
            {
                return null;
            }
            else
            {
                return o.ToString();
            }
        }
        /// <summary>
        /// If null or empty, it returns null.
        /// </summary>
        /// <param name="s"></param>
        /// <returns></returns>
        public static string ToStringOrNull(this string s)
        {
            if (s == null || s == string.Empty)
            {
                return null;
            }
            else
            {
                return s;
            }
        }
        /// <summary>
        /// Convert object to string. If null or empty, it returns empty.
        /// </summary>
        /// <param name="o"></param>
        /// <returns></returns>
        public static string ToStringOrEmpty(this object o)
        {
            if (o == null)
            {
                return string.Empty;
            }
            else
            {
                return o.ToString();
            }
        }
        /// <summary>
        /// If null or empty, it returns empty.
        /// </summary>
        /// <param name="s"></param>
        /// <returns></returns>
        public static string ToStringOrEmpty(this string s)
        {
            if (s == null)
            {
                return string.Empty;
            }
            else
            {
                return s;
            }
        }
        public static string ToStringOrEmpty(this object o, string format = "")
        {
            if (o == null)
            {
                return string.Empty;
            }
            else
            {
                return string.Format("{0:" + format + "}", o);
            }
        }
        /// <summary>
        /// Convert string to DateTime. If it cannot be converted, it returns defaultValue.
        /// Convertible formats is "yyyyMMdd","yyyyMMdd HHmmss","yyyy/MM/dd","yyyy/MM/dd HH:m:ss","yyyy-MM-dd","yyyy-MM-dd HH:mm:ss"
        /// </summary>
        /// <param name="s"></param>
        /// <param name="defaultValue"></param>
        /// <param name="format"></param>
        /// <returns></returns>
        public static DateTime ToDateTime(this string s, DateTime defaultValue)
        {
            return ToDateTime(s) ?? defaultValue;
        }
        /// <summary>
        /// Convert string to DateTime. If it cannot be converted, it returns null.
        /// Convertible formats is "yyyyMMdd","yyyyMMdd HHmmss","yyyy/MM/dd","yyyy/MM/dd HH:m:ss","yyyy-MM-dd","yyyy-MM-dd HH:mm:ss"
        /// </summary>
        /// <param name="s"></param>
        /// <param name="format"></param>
        /// <returns></returns>
        public static DateTime? ToDateTime(this string s)
        {
            if (s == null)
            {
                return null as DateTime?;
            }
            if (s.Contains("/") || s.Contains("-"))
            {
                return DateTime.TryParse(s, out var dt) ? dt : null as DateTime?;
            }
            else
            {
                string format = s.Length > 8 ? DateTimeFormat.yyyyMMddHHmmssNumber : DateTimeFormat.yyyyMMddNumber;
                return DateTime.TryParseExact(s, format, CultureInfo.InvariantCulture, 
                    DateTimeStyles.AllowWhiteSpaces, out var dt) ? dt : null as DateTime?;
            }
        }
        /// <summary>
        /// Convert.ToBoolean(byte)
        /// </summary>
        /// <param name="b"></param>
        /// <returns></returns>
        public static Boolean ToBoolean(this byte b)
        {
            return Convert.ToBoolean(b);
        }
        /// <summary>
        /// Convert.ToBoolean(int)
        /// </summary>
        /// <param name="i"></param>
        /// <returns></returns>
        public static Boolean ToBoolean(this int i)
        {
            return Convert.ToBoolean(i);
        }
        /// <summary>
        /// Convert string to Boolean. "false"->false, "true"->true, Other characters->false, "0"->false, Other numbers->true
        /// </summary>
        /// <param name="s"></param>
        /// <returns></returns>
        public static Boolean ToBoolean(this string s)
        {
            if (Boolean.TryParse(s, out var result))
            {
                return result;
            }
            else
            {
                return Convert.ToBoolean(s.ToInt32(0));
            }
        }
        /// <summary>
        /// Cuts the string to the specified number of bytes.
        /// </summary>
        /// <param name="s"></param>
        /// <param name="size"></param>
        /// <returns></returns>
        public static string GetByteString(this string s, int length)
        {
            if (string.IsNullOrEmpty(s))
            {
                return string.Empty;
            }
            else
            {
                Encoding e = System.Text.Encoding.GetEncoding("Shift_JIS");
                return new String(s.TakeWhile((c, i) => e.GetByteCount(s.Substring(0, i + 1)) <= length).ToArray());
            }
        }
        public static string GetByteString(this string s, int startIndex, int length)
        {
            if (string.IsNullOrEmpty(s))
            {
                return string.Empty;
            }
            else
            {
                Encoding e = System.Text.Encoding.GetEncoding("Shift_JIS");
                var cutChars = s
                    .SkipWhile((x, i) => e.GetByteCount(s.Substring(0, i + 1)) <= startIndex)
                    .TakeWhile((x, i) => e.GetByteCount(s.Substring(0, i + 1)) <= length)
                    .ToArray();

                return new string(cutChars);
            }
        }
    }
}
