param(
	[string]$Sample = "basic",
	[string]$OutputName = "",
	[string]$OutputRoot = "",
	[switch]$Run
)

$ErrorActionPreference = "Stop"

function Get-OdinRoot {
	$root = & odin root
	if (-not $root) {
		throw "Failed to resolve 'odin root'."
	}
	return $root.Trim()
}

function Copy-IfExists {
	param(
		[string]$Source,
		[string]$Destination
	)

	if (Test-Path -LiteralPath $Source) {
		New-Item -ItemType Directory -Force -Path (Split-Path -Parent $Destination) | Out-Null
		Copy-Item -LiteralPath $Source -Destination $Destination -Force
		return $true
	}

	return $false
}

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$odinDir = Split-Path -Parent $scriptDir
$samplesDir = Join-Path $odinDir "samples"
$sampleDir = Join-Path $samplesDir $Sample

if (-not (Test-Path -LiteralPath $sampleDir)) {
	throw "Sample not found: $sampleDir"
}

if ([string]::IsNullOrWhiteSpace($OutputRoot)) {
	$OutputRoot = Join-Path $odinDir "build"
}

if ([string]::IsNullOrWhiteSpace($OutputName)) {
	$OutputName = $Sample
}

$outputDir = Join-Path $OutputRoot $Sample
New-Item -ItemType Directory -Force -Path $outputDir | Out-Null

$exePath = Join-Path $outputDir ($OutputName + ".exe")

Write-Host "Building sample '$Sample'..."
& odin build $sampleDir "-out:$exePath"

$odinRoot = Get-OdinRoot
$sdlRuntime = Join-Path $odinRoot "vendor\sdl3\SDL3.dll"
$copiedRuntime = Copy-IfExists -Source $sdlRuntime -Destination (Join-Path $outputDir "SDL3.dll")
if (-not $copiedRuntime) {
	Write-Warning "SDL3.dll not found under '$sdlRuntime'. The executable may require SDL3.dll to be provided another way."
} else {
	Write-Host "Copied SDL3 runtime to '$outputDir'."
}

$shaderExtensions = @(".spv", ".dxil", ".msl")
$shaderFiles = @(Get-ChildItem -Path $odinDir -Recurse -File -ErrorAction SilentlyContinue | Where-Object { $shaderExtensions -contains $_.Extension })
foreach ($shaderFile in $shaderFiles) {
	$relativePath = $shaderFile.FullName.Substring($odinDir.Length).TrimStart('\', '/')
	$destination = Join-Path $outputDir $relativePath
	New-Item -ItemType Directory -Force -Path (Split-Path -Parent $destination) | Out-Null
	Copy-Item -LiteralPath $shaderFile.FullName -Destination $destination -Force
}

if ($shaderFiles.Count -gt 0) {
	Write-Host "Copied $($shaderFiles.Count) shader file(s) into '$outputDir'."
} else {
	Write-Host "No shader files found under '$odinDir'."
}

Write-Host "Build output: $exePath"

if ($Run) {
	Write-Host "Running sample '$Sample'..."
	& $exePath
}
