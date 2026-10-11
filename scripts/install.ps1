#!/usr/bin/env pwsh
# Debate Skills 安装脚本 (Windows PowerShell)
# 版本：v0.1.0

$ErrorActionPreference = "Stop"

Write-Host "==================================" -ForegroundColor Cyan
Write-Host "  Debate Skills v0.1.0 安装程序" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

# 检测 Claude skills 目录
$CLAUDE_DIR = "$env:USERPROFILE\.claude"
$SKILLS_DIR = "$CLAUDE_DIR\skills"
$PROFILES_DIR = "$CLAUDE_DIR\debate-profiles"
$KNOWLEDGE_DIR = "$CLAUDE_DIR\debate-knowledge"

# 创建目录
Write-Host "[1/5] 检查 Claude 目录..." -ForegroundColor Yellow
if (-not (Test-Path $CLAUDE_DIR)) {
    New-Item -ItemType Directory -Path $CLAUDE_DIR | Out-Null
    Write-Host "  已创建 $CLAUDE_DIR" -ForegroundColor Green
}
if (-not (Test-Path $SKILLS_DIR)) {
    New-Item -ItemType Directory -Path $SKILLS_DIR | Out-Null
    Write-Host "  已创建 $SKILLS_DIR" -ForegroundColor Green
}

Write-Host "[2/5] 安装 Skills..." -ForegroundColor Yellow
$SKILLS = @("debate-prep", "debate-script-writer", "debate-material-pack", "debate-match-review", "debate-style-learner")

foreach ($skill in $SKILLS) {
    $src = "skills\$skill"
    $dest = "$SKILLS_DIR\$skill"

    if (Test-Path $dest) {
        Write-Host "  $skill 已存在，是否覆盖？(y/n): " -NoNewline -ForegroundColor Yellow
        $answer = Read-Host
        if ($answer -ne "y") {
            Write-Host "  跳过 $skill" -ForegroundColor Gray
            continue
        }
        Remove-Item -Recurse -Force $dest
    }

    Copy-Item -Recurse $src $dest
    Write-Host "  已安装 $skill" -ForegroundColor Green
}

Write-Host "[3/5] 安装 Knowledge 库..." -ForegroundColor Yellow
if (-not (Test-Path $KNOWLEDGE_DIR)) {
    Copy-Item -Recurse "debate-knowledge" $KNOWLEDGE_DIR
    Write-Host "  已安装到 $KNOWLEDGE_DIR" -ForegroundColor Green
} else {
    Write-Host "  Knowledge 目录已存在，跳过" -ForegroundColor Gray
}

Write-Host "[4/5] 安装示例 Profile..." -ForegroundColor Yellow
if (-not (Test-Path $PROFILES_DIR)) {
    New-Item -ItemType Directory -Path $PROFILES_DIR | Out-Null
}
$example_dest = "$PROFILES_DIR\example"
if (-not (Test-Path $example_dest)) {
    Copy-Item -Recurse "debate-profiles\example" $example_dest
    Write-Host "  已安装示例 Profile" -ForegroundColor Green
} else {
    Write-Host "  示例 Profile 已存在，跳过" -ForegroundColor Gray
}

Write-Host "[5/5] 验证安装..." -ForegroundColor Yellow
$all_ok = $true
foreach ($skill in $SKILLS) {
    $skill_md = "$SKILLS_DIR\$skill\SKILL.md"
    if (-not (Test-Path $skill_md)) {
        Write-Host "  错误: $skill\SKILL.md 未找到" -ForegroundColor Red
        $all_ok = $false
    }
}

Write-Host ""
if ($all_ok) {
    Write-Host "================================" -ForegroundColor Green
    Write-Host "  安装成功！" -ForegroundColor Green
    Write-Host "================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "下一步：" -ForegroundColor Cyan
    Write-Host "  1. 打开 Claude Code" -ForegroundColor White
    Write-Host "  2. 对话：'我要准备辩题...'" -ForegroundColor White
    Write-Host ""
    Write-Host "可选配置：" -ForegroundColor Cyan
    Write-Host "  - Profile 位置: $PROFILES_DIR" -ForegroundColor White
    Write-Host "  - Knowledge 位置: $KNOWLEDGE_DIR" -ForegroundColor White
    Write-Host ""
    Write-Host "详细文档请查看 README.md" -ForegroundColor Gray
} else {
    Write-Host "安装过程中出现错误，请检查" -ForegroundColor Red
    exit 1
}
