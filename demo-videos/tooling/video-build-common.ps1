function Get-DemoVideoPaths {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ScriptsRoot
    )

    $projectRoot = Split-Path -Parent $ScriptsRoot
    $projectsRoot = Split-Path -Parent $projectRoot
    $demoRoot = Split-Path -Parent $projectsRoot
    $footageRoot = Join-Path $demoRoot 'library\footage'
    $exportsRoot = Join-Path $projectRoot 'exports'

    [pscustomobject]@{
        DemoRoot        = $demoRoot
        RepoRoot        = Split-Path -Parent $demoRoot
        ProjectRoot     = $projectRoot
        AsmlFootage     = Join-Path $footageRoot 'asml'
        IndustryFootage = Join-Path $footageRoot 'industrial'
        Masters         = Join-Path $projectRoot 'source\masters'
        Narration       = Join-Path $projectRoot 'assets\narration'
        ProductFootage  = Join-Path $footageRoot 'mistral\studio'
        Outputs         = Join-Path $exportsRoot 'final'
        ArchivedOutputs = Join-Path $exportsRoot 'archive'
        RejectedOutputs = Join-Path $exportsRoot 'rejected'
        Overlays        = Join-Path $projectRoot 'assets\overlays'
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
