param([int]$Port = 5050)

$webRoot = "C:\Users\husey\.gemini\antigravity\scratch\fitpulse\build\web"

if (-not (Test-Path $webRoot)) {
    Write-Host "Derlenmis web klasoru bulunamadi. Derleniyor..."
    $env:PATH = "C:\Users\husey\development\flutter\bin;C:\Users\husey\development\git\cmd;" + $env:PATH
    flutter build web --release
}

$listener = New-Object System.Net.HttpListener
$url = "http://localhost:$Port/"
$listener.Prefixes.Add($url)

try {
    $listener.Start()
} catch {
    $Port = $Port + 1
    $url = "http://localhost:$Port/"
    $listener = New-Object System.Net.HttpListener
    $listener.Prefixes.Add($url)
    $listener.Start()
}

Write-Host "=========================================================="
Write-Host "   FitPulse Flutter Web Sunucusu Calisiyor!"
Write-Host "   Adres: $url"
Write-Host "   (Kapatmak icin bu pencereyi veya Ctrl+C tusunu kapatin)"
Write-Host "=========================================================="

# Tarayicida ac
Start-Process $url

while ($listener.IsListening) {
    $context = $listener.GetContext()
    $request = $context.Request
    $response = $context.Response

    $path = $request.Url.LocalPath.TrimStart('/')
    if ([string]::IsNullOrEmpty($path)) { $path = "index.html" }

    $filePath = Join-Path $webRoot $path

    if (-not (Test-Path $filePath)) {
        # SPA routing destegi: bulunamayan istekleri index.html'e yonlendir
        $filePath = Join-Path $webRoot "index.html"
    }

    if (Test-Path $filePath) {
        $ext = [System.IO.Path]::GetExtension($filePath).ToLower()
        $contentType = switch ($ext) {
            ".html" { "text/html; charset=utf-8" }
            ".js"   { "application/javascript" }
            ".mjs"  { "application/javascript" }
            ".json" { "application/json" }
            ".css"  { "text/css" }
            ".wasm" { "application/wasm" }
            ".png"  { "image/png" }
            ".jpg"  { "image/jpeg" }
            ".jpeg" { "image/jpeg" }
            ".svg"  { "image/svg+xml" }
            ".ttf"  { "font/ttf" }
            ".otf"  { "font/otf" }
            ".ico"  { "image/x-icon" }
            default { "application/octet-stream" }
        }

        $bytes = [System.IO.File]::ReadAllBytes($filePath)
        $response.ContentType = $contentType
        $response.ContentLength64 = $bytes.Length
        $response.StatusCode = 200
        $response.OutputStream.Write($bytes, 0, $bytes.Length)
    } else {
        $response.StatusCode = 404
    }

    $response.Close()
}
