using System;
using System.Drawing;
using System.IO;

namespace WatchUs.Common.Utility
{
    public class ImageHelper
    {
        public static string CreateThumbnailImage(string fileName, string uploadPath)
        {
            int thumbnailWidth = 150;
            int thumbnailHeight;
            Image image = Image.FromFile(fileName);

            thumbnailHeight = thumbnailWidth * image.Height / image.Width;
            Image thumb = image.GetThumbnailImage(thumbnailWidth, thumbnailHeight, () => false, IntPtr.Zero);

            string pathForSaving = uploadPath;
            if (!Directory.Exists(pathForSaving))
            {
                Directory.CreateDirectory(pathForSaving);
            }

            string thumbfileName = string.Format("{0}.{1}{2}", Path.GetFileNameWithoutExtension(fileName), "thumb", Path.GetExtension(fileName));
            string thumbfileFullName = Path.Combine(pathForSaving, thumbfileName);

            thumb.Save(thumbfileFullName);
            return thumbfileFullName;
            //return string.Format("{0}/{1}/{2}", Request.ApplicationPath, "Uploads/thumbnails", thumbfileName);
        }
    }
}
