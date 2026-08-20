function Get-DemoVideoPaths {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ScriptsRoot
    )

    $demoRoot = Split-Path -Parent $ScriptsRoot

    [pscustomobject]@{
        DemoRoot        = $demoRoot
        RepoRoot        = Split-Path -Parent $demoRoot
        IndustryFootage = Join-Path $demoRoot 'source-footage\industry'
        Masters         = Join-Path $demoRoot 'source-footage\masters'
        Narration       = Join-Path $demoRoot 'assets\narration'
        ProductFootage  = Join-Path $demoRoot 'source-footage\mistral-studio'
        Outputs         = Join-Path $demoRoot 'outputs'
        Overlays        = Join-Path $demoRoot 'assets\overlays'
    }
}

function Resolve-FfmpegExecutable {
    [CmdletBinding()]
    param()

    $ffmpegCommand = Get-Command ffmpeg -ErrorAction SilentlyContinue
    if ($ffmpegCommand) {
        return $ffmpegCommand.Source
    }

    $wingetPackages = Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Packages'
    $ffmpegCandidate = Get-ChildItem -LiteralPath $wingetPackages -Directory -ErrorAction SilentlyContinue |
        Where-Object Name -Like 'Gyan.FFmpeg*' |
        ForEach-Object { Get-ChildItem -LiteralPath $_.FullName -Recurse -Filter ffmpeg.exe -ErrorAction SilentlyContinue } |
        Select-Object -First 1

    if (-not $ffmpegCandidate) {
        throw 'FFmpeg was not found. Install it with: winget install --id Gyan.FFmpeg --exact'
    }

    return $ffmpegCandidate.FullName
}

function Initialize-DemoOutputPath {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$OutputPath
    )

    $absoluteOutputPath = [System.IO.Path]::GetFullPath($OutputPath)
    $outputDirectory = Split-Path -Parent $absoluteOutputPath

    if (-not (Test-Path -LiteralPath $outputDirectory)) {
        New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null
    }

    return $absoluteOutputPath
}

function ConvertTo-FfmpegSubtitlePath {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Path
    )

    return $Path.Replace('\', '/').Replace(':', '\:').Replace("'", "\'")
}
