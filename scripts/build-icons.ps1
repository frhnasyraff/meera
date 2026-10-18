Add-Type -AssemblyName System.Drawing
$outputDirectory = Join-Path $PSScriptRoot '../icons'
[System.IO.Directory]::CreateDirectory($outputDirectory) | Out-Null
foreach ($size in @(180, 192, 512)) {
    $bitmap = [System.Drawing.Bitmap]::new($size, $size)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $graphics.ScaleTransform($size / 512.0, $size / 512.0)
    $graphics.Clear([System.Drawing.ColorTranslator]::FromHtml('#B26F54'))
    $paper = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml('#FBF9F5'))
    $muted = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml('#DCAB93'))
    $sage = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml('#73806B'))
    $pink = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml('#B26F54'))
    $graphics.TranslateTransform(256, 256)
    $graphics.RotateTransform(-12)
    $graphics.FillRectangle($muted, -151, -145, 265, 290)
    $graphics.RotateTransform(12)
    $graphics.FillRectangle($paper, -118, -135, 265, 290)
    $graphics.FillRectangle($sage, -98, -115, 225, 214)
    $mountains = [System.Drawing.PointF[]]@(
        [System.Drawing.PointF]::new(-98, 99),
        [System.Drawing.PointF]::new(-98, 55),
        [System.Drawing.PointF]::new(-24, -30),
        [System.Drawing.PointF]::new(35, 30),
        [System.Drawing.PointF]::new(77, -12),
        [System.Drawing.PointF]::new(127, 48),
        [System.Drawing.PointF]::new(127, 99)
    )
    $graphics.FillPolygon($paper, $mountains)
    $heart = [System.Drawing.Drawing2D.GraphicsPath]::new()
    $heart.AddBezier(60, -62, 22, -90, 31, -117, 52, -112)
    $heart.AddBezier(52, -112, 61, -110, 65, -105, 66, -99)
    $heart.AddBezier(66, -99, 84, -126, 111, -107, 99, -87)
    $heart.AddBezier(99, -87, 88, -72, 72, -65, 60, -62)
    $heart.CloseFigure()
    $graphics.FillPath($pink, $heart)
    $bitmap.Save((Join-Path $outputDirectory "gallery-$size.png"), [System.Drawing.Imaging.ImageFormat]::Png)
    $heart.Dispose()
    foreach ($brush in @($paper, $muted, $sage, $pink)) { $brush.Dispose() }
    $graphics.Dispose()
    $bitmap.Dispose()
}
