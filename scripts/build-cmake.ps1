param(
	[string]$BuildType = "Release",
	[string]$BuildDir = "build-cmake",
	[string]$Generator = "",
	[string]$QtPath = ""
)

$ErrorActionPreference = "Stop"

function Info($msg) { Write-Host "[INFO] $msg" -ForegroundColor Cyan }
function Warn($msg) { Write-Host "[WARN] $msg" -ForegroundColor Yellow }
function Fail($msg) { Write-Host "[FAIL] $msg" -ForegroundColor Red; exit 1 }

if (-not (Get-Command cmake -ErrorAction SilentlyContinue)) {
	Fail "未检测到 cmake，请先安装 CMake 并加入 PATH。"
}

if ($QtPath -and (Test-Path $QtPath)) {
	# 常见：C:\Qt\6.6.2\msvc2019_64
	$qtCMakeDir = Join-Path $QtPath "lib\cmake\Qt6"
	if (Test-Path $qtCMakeDir) {
		$env:Qt6_DIR = $qtCMakeDir
	}
	# CMAKE_PREFIX_PATH 也可指向 msvc*_64 目录
	if (-not $env:CMAKE_PREFIX_PATH) {
		$env:CMAKE_PREFIX_PATH = $QtPath
	} else {
		$env:CMAKE_PREFIX_PATH = "$($env:CMAKE_PREFIX_PATH);$QtPath"
	}
	Info "已设置 Qt6_DIR=$($env:Qt6_DIR)"
	Info "已设置 CMAKE_PREFIX_PATH=$($env:CMAKE_PREFIX_PATH)"
} else {
	Warn "未提供 -QtPath，假设系统已配置 Qt 的 CMake 包（Qt6_DIR 或 CMAKE_PREFIX_PATH）。"
}

if (-not (Test-Path $BuildDir)) {
	New-Item -ItemType Directory -Path $BuildDir | Out-Null
}

# 默认生成器：优先使用 Visual Studio 2022；留空则交由 CMake 自行选择
if (-not $Generator -or $Generator.Trim() -eq "") {
	$Generator = "Visual Studio 17 2022"
}

Info "配置项目（Generator=$Generator, BuildType=$BuildType, BuildDir=$BuildDir）..."
$configureArgs = @("-S", ".", "-B", $BuildDir, "-DCMAKE_BUILD_TYPE=$BuildType")
if ($Generator) {
	$configureArgs = @("-G", $Generator) + $configureArgs
}

& cmake @configureArgs
if ($LASTEXITCODE -ne 0) {
	Fail "CMake 配置失败，请确认 Qt 安装并正确设置 Qt6_DIR 或 CMAKE_PREFIX_PATH。"
}

Info "开始构建..."
& cmake --build $BuildDir --config $BuildType
if ($LASTEXITCODE -ne 0) {
	Fail "CMake 构建失败。"
}

Info "构建成功。可执行文件位于 $BuildDir。"


