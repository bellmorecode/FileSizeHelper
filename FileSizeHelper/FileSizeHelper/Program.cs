using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FileSizeHelper
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.Write("Title: ");
            var title = Console.ReadLine();

            Console.Write("Path: ");
            var path = Console.ReadLine();

            using (var db = new FileShareContainer())
            {
                var job = new Job();
                job.Title = title;
                job.SearchPath = path;
                job.RunDate = DateTime.Now;
                db.Jobs.Add(job);
                Console.WriteLine("Saving job to DB");
                db.SaveChanges();

                RecurseDirectory(path, job);

                Console.WriteLine("Flagging job as complete");
                job.IsCompleted = true;
                db.SaveChanges();
            }
        }

        private static void RecurseDirectory(string path, Job job)
        {
            Console.WriteLine("dir: {0}", path);
            Func<string, Job, FileLog> GetFileLog = (f, j) =>
            {
                
                var info = new FileLog();
                //info.Job = j;
                info.FullPath = f;
                info.Extension = Path.GetExtension(f);
                info.FileName = Path.GetFileName(f);
                info.Directory = Path.GetDirectoryName(f);
                try {
                    var file = new FileInfo(f);
                    info.Modified = file.LastWriteTime;
                    info.FileSize = file.Length;
                } catch(Exception ) {
                    info.Modified = DateTime.MinValue;
                    info.FileSize = -1;
                }
                
                return info;    
            };

            try
            {
                var files = Directory.GetFiles(path, "*", SearchOption.TopDirectoryOnly);

                var directories = Directory.GetDirectories(path, "*", SearchOption.TopDirectoryOnly);


                Console.WriteLine("adding {0} file(s)", files.Length);

                using (var db = new FileShareContainer())
                {
                    var j2 = db.Jobs.First(q => q.Id == job.Id);
                    files.Select(q => GetFileLog(q, job)).ToList()
                            .ForEach(q => j2.FileLogs.Add(q));

                    Console.WriteLine("Saving File Logs");
                    db.SaveChanges();
                }

                for (var i = 0; i < directories.Length; i++)
                {
                    RecurseDirectory(directories[0], job);
                }
            }
            catch (Exception ex) {
                Console.WriteLine("Exception! {0}", ex);
            }
        }
    }
}
