import System.Net
import System.IO

if argv.Length != 2:
    print "You must pass [prefix] [path] as parameters"
    return

prefix = argv[0]
path = argv[1]

if not Directory.Exists(path):
    print "Could not find $(path)"
    return

listener = HttpListener()
listener.Prefixes.Add(prefix)
listener.Start()

while true:
    context = listener.GetContext()
    file = Path.GetFileName(context.Request.RawUrl)
    fullPath = Path.Combine(path, file)
    if File.Exists(fullPath):
        context.Response.AddHeader("Content-Disposition", "attachment; filename=${file}")
        bytes = File.ReadAllBytes(fullPath)
        context.Response.OutputStream.Write(bytes, 0, bytes.Length)
        context.Response.OutputStream.Flush()
        context.Response.Close()
    else:
        context.Response.StatusCode = 404
        context.Response.Close()
