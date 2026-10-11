#!/usr/bin/env pwsh
# Debate Agent Toolkit 通用安装脚本 (Windows PowerShell)
# 版本：v0.1.0-refactor

$ErrorActionPreference = "Stop"

Write-Host "==================================" -ForegroundColor Cyan
Write-Host "  Debate Agent Toolkit 安装程序" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

# 检测安装位置
$TOOLKIT_HOME = $env:DEBATE_TOOLKIT_HOME
if (-not $TOOLKIT_HOME) {
    $TOOLKIT_HOME = "$env:APPDATA\debate-agent-toolkit"
    Write-Host "使用默认安装位置: $TOOLKIT_HOME" -ForegroundColor Gray
} else {
    Write-Host "使用自定义安装位置: $TOOLKIT_HOME" -ForegroundColor Gray
}

# 检测平台
Write-Host ""
Write-Host "[1/6] 检测平台..." -ForegroundColor Yellow
$CLAUDE_DIR = "$env:USERPROFILE\.claude"
$CURSOR_DIR = "$env:USERPROFILE\.cursor"
$PLATFORM = "generic"

if (Test-Path "$CLAUDE_DIR\skills") {
    $PLATFORM = "claude-code"
    Write-Host "  检测到 Claude Code" -ForegroundColor Green
} elseif (Test-Path $CURSOR_DIR) {
    $PLATFORM = "cursor"
    Write-Host "  检测到 Cursor" -ForegroundColor Green
} else {
    Write-Host "  未检测到特定平台，使用通用模式" -ForegroundColor Gray
}

# 创建目录
Write-Host ""
Write-Host "[2/6] 创建目录结构..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path "$TOOLKIT_HOME\prompts" | Out-Null
New-Item -ItemType Directory -Force -Path "$TOOLKIT_HOME\knowledge" | Out-Null
New-Item -ItemType Directory -Force -Path "$TOOLKIT_HOME\profiles" | Out-Null
New-Item -ItemType Directory -Force -Path "$TOOLKIT_HOME\.cache" | Out-Null
Write-Host "  已创建 $TOOLKIT_HOME" -ForegroundColor Green

# 安装 Prompts
Write-Host ""
Write-Host "[3/6] 安装 Prompts..." -ForegroundColor Yellow
$PROMPTS = @("prep", "script-writer", "material-pack", "match-review", "style-learner")

foreach ($prompt in $PROMPTS) {
    $src = "prompts\debate-$prompt"
    $dest = "$TOOLKIT_HOME\prompts\debate-$prompt"

    if (Test-Path $dest) {
        Write-Host "  debate-$prompt 已存在，是否覆盖？(y/n): " -NoNewline -ForegroundColor Yellow
        $answer = Read-Host
        if ($answer -ne "y") {
            Write-Host "  跳过 debate-$prompt" -ForegroundColor Gray
            continue
        }
        Remove-Item -Recurse -Force $dest
    }

    Copy-Item -Recurse $src $dest
    Write-Host "  已安装 debate-$prompt" -ForegroundColor Green
}

# 安装 Knowledge
Write-Host ""
Write-Host "[4/6] 安装 Knowledge..." -ForegroundColor Yellow
if (-not (Test-Path "$TOOLKIT_HOME\knowledge\topics-index.md")) {
    Copy-Item -Recurse "knowledge\*" "$TOOLKIT_HOME\knowledge\"
    Write-Host "  已安装 Knowledge 库" -ForegroundColor Green
} else {
    Write-Host "  Knowledge 已存在，跳过" -ForegroundColor Gray
}

# 安装示例 Profile
Write-Host ""
Write-Host "[5/6] 安装示例 Profile..." -ForegroundColor Yellow
if (-not (Test-Path "$TOOLKIT_HOME\profiles\example")) {
    Copy-Item -Recurse "profiles\example" "$TOOLKIT_HOME\profiles\"
    Write-Host "  已安装示例 Profile" -ForegroundColor Green
} else {
    Write-Host "  示例 Profile 已存在，跳过" -ForegroundColor Gray
}

# 复制配置文件
if (-not (Test-Path "$TOOLKIT_HOME\config.yaml")) {
    Copy-Item "config.yaml" "$TOOLKIT_HOME\config.yaml"
    Write-Host "  已安装配置文件" -ForegroundColor Green
}

# 平台特定配置
Write-Host ""
Write-Host "[6/6] 平台适配..." -ForegroundColor Yellow

if ($PLATFORM -eq "claude-code") {
    Write-Host "  检测到 Claude Code，是否创建软链接？(y/n): " -NoNewline -ForegroundColor Yellow
    $answer = Read-Host
    if ($answer -eq "y") {
        $SKILLS_DIR = "$CLAUDE_DIR\skills"
        foreach ($prompt in $PROMPTS) {
            $target = "$TOOLKIT_HOME\prompts\debate-$prompt"
            $link = "$SKILLS_DIR\debate-$prompt"

            if (Test-Path $link) {
                Remove-Item -Force $link
            }

            # Windows 软链接需要管理员权限，这里使用目录连接（junction）
            cmd /c mklink /J "$link" "$target" | Out-Null
            Write-Host "  已链接 debate-$prompt 到 Claude Code" -ForegroundColor Green
        }
    }
} elseif ($PLATFORM -eq "cursor") {
    Write-Host "  Cursor 支持开发中，请手动配置" -ForegroundColor Gray
}

Write-Host ""
Write-Host "================================" -ForegroundColor Green
Write-Host "  安装成功！" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Green
Write-Host ""
Write-Host "安装位置: $TOOLKIT_HOME" -ForegroundColor White
Write-Host ""
Write-Host "环境变量（可选）：" -ForegroundColor Cyan
Write-Host "  setx DEBATE_TOOLKIT_HOME `"$TOOLKIT_HOME`"" -ForegroundColor Gray
Write-Host ""
Write-Host "下一步：" -ForegroundColor Cyan
if ($PLATFORM -eq "claude-code") {
    Write-Host "  1. 打开 Claude Code" -ForegroundColor White
    Write-Host "  2. 对话：'我要准备辩题...'" -ForegroundColor White
} else {
    Write-Host "  1. 查看 README.md 中的平台使用指南" -ForegroundColor White
    Write-Host "  2. 配置您的 AI Agent 加载 $TOOLKIT_HOME\prompts" -ForegroundColor White
}
Write-Host ""
Write-Host "详细文档: README.md" -ForegroundColor Gray
