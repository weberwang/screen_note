[CmdletBinding()]
param(
    [switch]$SkipPubGet,
    [int]$DeviceWaitTimeoutSeconds = 120
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

<#
.SYNOPSIS
Android 调试启动脚本，负责设备选择、模拟器启动和 flutter run。
#>

function ConvertFrom-FlutterDevicesJson {
    <#
    .SYNOPSIS
    解析 flutter devices --machine 输出，并只保留 Android 设备。
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$Json
    )

    $items = ConvertFrom-Json -InputObject $Json
    foreach ($item in $items) {
        if (-not $item.isSupported) {
            continue
        }

        if (-not $item.targetPlatform.StartsWith('android')) {
            continue
        }

        $isEmulator = $false
        if ($item.PSObject.Properties.Name -contains 'emulator') {
            $isEmulator = [bool]$item.emulator
        }

        [pscustomobject]@{
            Name       = $item.name
            Id         = $item.id
            Platform   = $item.targetPlatform
            IsEmulator = $isEmulator
        }
    }
}

function ConvertFrom-FlutterEmulatorsText {
    <#
    .SYNOPSIS
    解析 flutter emulators 文本输出中的 Android 模拟器列表。
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$Text
    )

    $emulators = @()
    foreach ($line in ($Text -split "`r?`n")) {
        if (-not ($line -match '^\s*(?<id>[^\s•]+)\s+•\s+(?<name>.*?)\s+•\s+(?<manufacturer>.*?)\s+•\s+(?<platform>\w+)\s*$')) {
            continue
        }

        if ($Matches['platform'] -ne 'android') {
            continue
        }

        $emulators += [pscustomobject]@{
            Id           = $Matches['id'].Trim()
            Name         = $Matches['name'].Trim()
            Manufacturer = $Matches['manufacturer'].Trim()
            Platform     = $Matches['platform'].Trim()
        }
    }

    return $emulators
}

function ConvertFrom-AvdListText {
    <#
    .SYNOPSIS
    解析 emulator -list-avds 输出，并转换成脚本内部统一的模拟器结构。
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$Text
    )

    $emulators = @()
    foreach ($line in ($Text -split "`r?`n")) {
        $avdName = $line.Trim()
        if ([string]::IsNullOrWhiteSpace($avdName)) {
            continue
        }

        $displayName = ($avdName -replace '_', ' ').Trim()
        $emulators += [pscustomobject]@{
            Id           = $avdName
            Name         = $displayName
            Manufacturer = 'Unknown'
            Platform     = 'android'
        }
    }

    return $emulators
}

function Get-AndroidRunPlan {
    <#
    .SYNOPSIS
    根据当前设备和模拟器状态，决定是直接运行还是先启动模拟器。
    #>
    param(
        [Parameter(Mandatory = $true)]
        [AllowEmptyCollection()]
        [object[]]$ConnectedDevices,

        [Parameter(Mandatory = $true)]
        [AllowEmptyCollection()]
        [object[]]$AvailableEmulators
    )

    if ($ConnectedDevices.Count -eq 1) {
        return [pscustomobject]@{
            Mode              = 'UseConnectedDevice'
            DeviceId          = $ConnectedDevices[0].Id
            RequiresSelection = $false
        }
    }

    if ($ConnectedDevices.Count -gt 1) {
        return [pscustomobject]@{
            Mode              = 'SelectConnectedDevice'
            RequiresSelection = $true
        }
    }

    return [pscustomobject]@{
        Mode              = 'LaunchEmulator'
        RequiresSelection = $true
    }
}

function Test-FlutterCommand {
    <#
    .SYNOPSIS
    检查 flutter 是否可用，避免用户在中途才看到命令不存在。
    #>
    $null = Get-Command flutter -ErrorAction Stop
}

function Invoke-FlutterCommand {
    <#
    .SYNOPSIS
    统一执行 flutter 命令，并在失败时抛出错误。
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string[]]$Arguments
    )

    & flutter @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "flutter $($Arguments -join ' ') 执行失败，退出码：$LASTEXITCODE"
    }
}

function Test-ZipArchiveIntegrity {
    <#
    .SYNOPSIS
    使用 .NET 压缩库快速验证 APK 是否仍是可读取的 ZIP 包。
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    Add-Type -AssemblyName System.IO.Compression.FileSystem
    try {
        $zip = [System.IO.Compression.ZipFile]::OpenRead($Path)
        $zip.Dispose()
        return $true
    }
    catch {
        return $false
    }
}

function Remove-CorruptedFlutterApkIfExists {
    <#
    .SYNOPSIS
    当上一次构建中断留下损坏 APK 时，提前删除，避免 flutter run 误读旧坏包。
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$ProjectRoot
    )

    $apkPath = Join-Path $ProjectRoot 'build\app\outputs\flutter-apk\app-debug.apk'
    if (-not (Test-Path $apkPath)) {
        return $false
    }

    if (Test-ZipArchiveIntegrity -Path $apkPath) {
        return $false
    }

    Write-Host "检测到损坏的旧 APK，已删除：$apkPath" -ForegroundColor Yellow
    Remove-Item -LiteralPath $apkPath -Force
    return $true
}

function Get-AndroidDevices {
    <#
    .SYNOPSIS
    获取当前已连接的 Android 设备列表。
    #>
    $json = & flutter devices --machine
    if ($LASTEXITCODE -ne 0) {
        throw '获取 Flutter 设备列表失败。'
    }

    return @(ConvertFrom-FlutterDevicesJson -Json ($json -join "`n"))
}

function Get-EmulatorExecutablePath {
    <#
    .SYNOPSIS
    定位 Android SDK 中的 emulator.exe，作为 flutter emulators 失效时的兜底入口。
    #>
    $candidates = @()
    if ($env:ANDROID_HOME) {
        $candidates += (Join-Path $env:ANDROID_HOME 'emulator\emulator.exe')
    }

    if ($env:ANDROID_SDK_ROOT) {
        $candidates += (Join-Path $env:ANDROID_SDK_ROOT 'emulator\emulator.exe')
    }

    $command = Get-Command emulator.exe -ErrorAction SilentlyContinue
    if ($command) {
        $candidates += $command.Source
    }

    foreach ($path in ($candidates | Select-Object -Unique)) {
        if ($path -and (Test-Path $path)) {
            return $path
        }
    }

    return $null
}

function Get-AndroidEmulatorsFromAvd {
    <#
    .SYNOPSIS
    通过 emulator.exe -list-avds 获取已安装 AVD，避免 flutter emulators 偶发漏报。
    #>
    $emulatorPath = Get-EmulatorExecutablePath
    if (-not $emulatorPath) {
        return @()
    }

    $text = & $emulatorPath -list-avds
    if ($LASTEXITCODE -ne 0) {
        return @()
    }

    return @(ConvertFrom-AvdListText -Text ($text -join "`n"))
}

function Get-AndroidEmulators {
    <#
    .SYNOPSIS
    获取当前可启动的 Android 模拟器列表。
    #>
    $text = & flutter emulators
    if ($LASTEXITCODE -ne 0) {
        throw '获取 Flutter 模拟器列表失败。'
    }

    $emulators = @(ConvertFrom-FlutterEmulatorsText -Text ($text -join "`n"))
    if ($emulators.Count -gt 0) {
        return $emulators
    }

    return @(Get-AndroidEmulatorsFromAvd)
}

function Read-SelectionIndex {
    <#
    .SYNOPSIS
    读取用户输入的序号，并保证选择落在有效范围内。
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$Prompt,

        [Parameter(Mandatory = $true)]
        [int]$Max
    )

    while ($true) {
        $raw = Read-Host $Prompt
        $value = 0
        if ([int]::TryParse($raw, [ref]$value) -and $value -ge 1 -and $value -le $Max) {
            return ($value - 1)
        }

        Write-Host "请输入 1 到 $Max 之间的序号。" -ForegroundColor Yellow
    }
}

function Select-ItemFromList {
    <#
    .SYNOPSIS
    以编号形式展示候选列表，供用户选择设备或模拟器。
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$Title,

        [Parameter(Mandatory = $true)]
        [object[]]$Items,

        [Parameter(Mandatory = $true)]
        [scriptblock]$LabelBuilder
    )

    Write-Host $Title -ForegroundColor Cyan
    for ($index = 0; $index -lt $Items.Count; $index++) {
        $label = & $LabelBuilder $Items[$index]
        Write-Host ("[{0}] {1}" -f ($index + 1), $label)
    }

    $selectedIndex = Read-SelectionIndex -Prompt '请输入序号' -Max $Items.Count
    return $Items[$selectedIndex]
}

function Wait-ForAndroidDevice {
    <#
    .SYNOPSIS
    等待指定 Android 设备上线，避免模拟器刚启动就直接 flutter run 失败。
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$DeviceId,

        [Parameter(Mandatory = $true)]
        [int]$TimeoutSeconds
    )

    $deadline = (Get-Date).AddSeconds($TimeoutSeconds)
    while ((Get-Date) -lt $deadline) {
        $device = @(Get-AndroidDevices | Where-Object { $_.Id -eq $DeviceId })
        if ($device.Count -gt 0) {
            return
        }

        Start-Sleep -Seconds 2
    }

    throw "等待 Android 设备 [$DeviceId] 超时，请确认模拟器是否成功启动。"
}

function Resolve-NewAndroidDeviceAfterLaunch {
    <#
    .SYNOPSIS
    根据启动前后设备列表，识别刚启动后新连接上的 Android 设备。
    #>
    param(
        [Parameter(Mandatory = $true)]
        [AllowEmptyCollection()]
        [object[]]$BeforeDevices,

        [Parameter(Mandatory = $true)]
        [AllowEmptyCollection()]
        [object[]]$AfterDevices,

        [Parameter(Mandatory = $true)]
        [string]$LaunchedEmulatorId
    )

    $matchedById = @($AfterDevices | Where-Object { $_.Id -eq $LaunchedEmulatorId })
    if ($matchedById.Count -gt 0) {
        return $matchedById[0]
    }

    $beforeIds = @($BeforeDevices | ForEach-Object { $_.Id })
    $newDevices = @(
        $AfterDevices | Where-Object {
            $beforeIds -notcontains $_.Id
        }
    )

    $newEmulators = @($newDevices | Where-Object { $_.IsEmulator })
    if ($newEmulators.Count -eq 1) {
        return $newEmulators[0]
    }

    if ($newDevices.Count -eq 1) {
        return $newDevices[0]
    }

    return $null
}

function Wait-ForLaunchedAndroidDevice {
    <#
    .SYNOPSIS
    等待新启动的模拟器真正连上，并兼容 AVD 名称与设备 ID 不一致的场景。
    #>
    param(
        [Parameter(Mandatory = $true)]
        [AllowEmptyCollection()]
        [object[]]$BeforeDevices,

        [Parameter(Mandatory = $true)]
        [string]$LaunchedEmulatorId,

        [Parameter(Mandatory = $true)]
        [int]$TimeoutSeconds
    )

    $deadline = (Get-Date).AddSeconds($TimeoutSeconds)
    while ((Get-Date) -lt $deadline) {
        $afterDevices = @(Get-AndroidDevices)
        $resolvedDevice = Resolve-NewAndroidDeviceAfterLaunch `
            -BeforeDevices $BeforeDevices `
            -AfterDevices $afterDevices `
            -LaunchedEmulatorId $LaunchedEmulatorId

        if ($null -ne $resolvedDevice) {
            return $resolvedDevice
        }

        Start-Sleep -Seconds 2
    }

    throw "等待模拟器 [$LaunchedEmulatorId] 连接超时，请确认模拟器是否成功启动。"
}

function Resolve-TargetAndroidDevice {
    <#
    .SYNOPSIS
    解析本次 flutter run 应该连接的 Android 设备。
    #>
    param(
        [Parameter(Mandatory = $true)]
        [int]$TimeoutSeconds
    )

    $devices = @(Get-AndroidDevices)
    $emulators = @(Get-AndroidEmulators)
    $plan = Get-AndroidRunPlan -ConnectedDevices $devices -AvailableEmulators $emulators

    switch ($plan.Mode) {
        'UseConnectedDevice' {
            Write-Host "检测到唯一 Android 设备：$($devices[0].Name) [$($devices[0].Id)]" -ForegroundColor Green
            return $devices[0]
        }

        'SelectConnectedDevice' {
            return Select-ItemFromList `
                -Title '检测到多个 Android 设备，请选择要调试的设备：' `
                -Items $devices `
                -LabelBuilder { param($item) "$($item.Name) [$($item.Id)] / $($item.Platform)" }
        }

        'LaunchEmulator' {
            if ($emulators.Count -eq 0) {
                throw '当前没有已连接的 Android 设备，也没有可用的 Android 模拟器。'
            }

            $selectedEmulator = Select-ItemFromList `
                -Title '未检测到 Android 设备，请选择要启动的模拟器：' `
                -Items $emulators `
                -LabelBuilder { param($item) "$($item.Name) [$($item.Id)] / $($item.Manufacturer)" }

            Invoke-FlutterCommand -Arguments @('emulators', '--launch', $selectedEmulator.Id)
            Write-Host "等待模拟器 [$($selectedEmulator.Id)] 连接..." -ForegroundColor Yellow
            return Wait-ForLaunchedAndroidDevice `
                -BeforeDevices $devices `
                -LaunchedEmulatorId $selectedEmulator.Id `
                -TimeoutSeconds $TimeoutSeconds
        }

        default {
            throw "未知运行模式：$($plan.Mode)"
        }
    }
}

function Start-AndroidDebugSession {
    <#
    .SYNOPSIS
    启动 Android 调试会话，必要时自动补齐依赖、启动模拟器并连接 flutter run。
    #>
    param(
        [Parameter(Mandatory = $true)]
        [bool]$ShouldSkipPubGet,

        [Parameter(Mandatory = $true)]
        [int]$TimeoutSeconds
    )

    Test-FlutterCommand

    if (-not $ShouldSkipPubGet) {
        Write-Host '执行 flutter pub get...' -ForegroundColor Cyan
        Invoke-FlutterCommand -Arguments @('pub', 'get')
    }

    Remove-CorruptedFlutterApkIfExists -ProjectRoot (Get-Location).Path | Out-Null

    $device = Resolve-TargetAndroidDevice -TimeoutSeconds $TimeoutSeconds
    Write-Host "开始在设备 [$($device.Name)] 上执行 flutter run..." -ForegroundColor Green
    Invoke-FlutterCommand -Arguments @('run', '-d', $device.Id)
}

if ($MyInvocation.InvocationName -ne '.') {
    Start-AndroidDebugSession -ShouldSkipPubGet:$SkipPubGet.IsPresent -TimeoutSeconds $DeviceWaitTimeoutSeconds
}
