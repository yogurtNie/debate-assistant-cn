#!/usr/bin/env node

/**
 * Debate Agent Toolkit - 跨平台自动化安装脚本
 * 支持 npm install 和 npx 直接调用
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');
const os = require('os');

// ANSI 颜色
const colors = {
  reset: '\x1b[0m',
  cyan: '\x1b[36m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  red: '\x1b[31m',
  gray: '\x1b[90m'
};

function log(msg, color = 'reset') {
  console.log(colors[color] + msg + colors.reset);
}

function detectPlatform() {
  const homeDir = os.homedir();
  const claudeDir = path.join(homeDir, '.claude', 'skills');
  const cursorDir = path.join(homeDir, '.cursor');

  if (fs.existsSync(claudeDir)) {
    return 'claude-code';
  } else if (fs.existsSync(cursorDir)) {
    return 'cursor';
  }
  return 'generic';
}

function getToolkitHome() {
  if (process.env.DEBATE_TOOLKIT_HOME) {
    return process.env.DEBATE_TOOLKIT_HOME;
  }

  const homeDir = os.homedir();
  const platform = os.platform();

  if (platform === 'darwin') {
    return path.join(homeDir, 'Library', 'Application Support', 'debate-agent-toolkit');
  } else if (platform === 'win32') {
    return path.join(process.env.APPDATA || homeDir, 'debate-agent-toolkit');
  } else {
    return path.join(homeDir, '.local', 'share', 'debate-agent-toolkit');
  }
}

function copyRecursive(src, dest) {
  if (!fs.existsSync(src)) {
    return;
  }

  const stats = fs.statSync(src);
  if (stats.isDirectory()) {
    if (!fs.existsSync(dest)) {
      fs.mkdirSync(dest, { recursive: true });
    }
    const files = fs.readdirSync(src);
    files.forEach(file => {
      copyRecursive(path.join(src, file), path.join(dest, file));
    });
  } else {
    fs.copyFileSync(src, dest);
  }
}

function createSymlink(target, link) {
  try {
    if (fs.existsSync(link)) {
      fs.unlinkSync(link);
    }
    fs.symlinkSync(target, link, 'dir');
    return true;
  } catch (err) {
    // Windows可能需要管理员权限，fallback到junction
    try {
      if (os.platform() === 'win32') {
        execSync(`mklink /J "${link}" "${target}"`, { stdio: 'ignore' });
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }
}

async function install() {
  log('==================================', 'cyan');
  log('  Debate Agent Toolkit 安装程序', 'cyan');
  log('==================================', 'cyan');
  console.log();

  // 1. 检测平台
  log('[1/6] 检测平台...', 'yellow');
  const platform = detectPlatform();
  if (platform === 'claude-code') {
    log('  ✓ 检测到 Claude Code', 'green');
  } else if (platform === 'cursor') {
    log('  ✓ 检测到 Cursor', 'green');
  } else {
    log('  未检测到特定平台，使用通用模式', 'gray');
  }

  // 2. 确定安装位置
  const toolkitHome = getToolkitHome();
  log(`\n[2/6] 安装位置: ${toolkitHome}`, 'yellow');

  // 3. 创建目录
  log('\n[3/6] 创建目录结构...', 'yellow');
  const dirs = ['prompts', 'knowledge', 'profiles', '.cache'];
  dirs.forEach(dir => {
    const dirPath = path.join(toolkitHome, dir);
    if (!fs.existsSync(dirPath)) {
      fs.mkdirSync(dirPath, { recursive: true });
    }
  });
  log('  ✓ 目录创建完成', 'green');

  // 4. 复制文件
  log('\n[4/6] 复制文件...', 'yellow');
  const srcDir = __dirname;

  ['prompts', 'knowledge', 'profiles', 'docs', 'tests'].forEach(dir => {
    const src = path.join(srcDir, dir);
    const dest = path.join(toolkitHome, dir);
    if (fs.existsSync(src)) {
      copyRecursive(src, dest);
      log(`  ✓ 已复制 ${dir}/`, 'green');
    }
  });

  // 复制配置文件
  const configSrc = path.join(srcDir, 'config.yaml');
  const configDest = path.join(toolkitHome, 'config.yaml');
  if (fs.existsSync(configSrc) && !fs.existsSync(configDest)) {
    fs.copyFileSync(configSrc, configDest);
    log('  ✓ 已复制配置文件', 'green');
  }

  // 5. 平台特定配置
  log('\n[5/6] 平台适配...', 'yellow');
  if (platform === 'claude-code') {
    const skillsDir = path.join(os.homedir(), '.claude', 'skills');
    const prompts = ['prep', 'script-writer', 'material-pack', 'match-review', 'style-learner'];

    let successCount = 0;
    prompts.forEach(prompt => {
      const target = path.join(toolkitHome, 'prompts', `debate-${prompt}`);
      const link = path.join(skillsDir, `debate-${prompt}`);

      if (createSymlink(target, link)) {
        successCount++;
      }
    });

    if (successCount === prompts.length) {
      log(`  ✓ 已创建 ${successCount} 个软链接到 Claude Code`, 'green');
    } else {
      log(`  ⚠ 创建了 ${successCount}/${prompts.length} 个软链接`, 'yellow');
      log('    部分软链接创建失败，您可以手动创建', 'gray');
    }
  } else if (platform === 'cursor') {
    log('  Cursor 支持开发中，请手动配置', 'gray');
  }

  // 6. 验证
  log('\n[6/6] 验证安装...', 'yellow');
  const checkFiles = [
    'prompts/debate-prep/SKILL.md',
    'knowledge/topics-index.md',
    'profiles/example/README.md'
  ];

  let allOk = true;
  checkFiles.forEach(file => {
    const filePath = path.join(toolkitHome, file);
    if (!fs.existsSync(filePath)) {
      log(`  ✗ 缺少文件: ${file}`, 'red');
      allOk = false;
    }
  });

  console.log();
  if (allOk) {
    log('================================', 'green');
    log('  安装成功！', 'green');
    log('================================', 'green');
    console.log();
    log('安装位置: ' + toolkitHome, 'cyan');
    console.log();
    log('下一步:', 'cyan');
    if (platform === 'claude-code') {
      log('  1. 打开 Claude Code', 'gray');
      log('  2. 对话："我要准备辩题..."', 'gray');
    } else {
      log('  1. 查看 README.md 中的平台使用指南', 'gray');
      log('  2. 配置您的 AI Agent 加载提示词', 'gray');
    }
    console.log();
    log('详细文档: https://github.com/YOUR_USERNAME/debate-agent-toolkit', 'gray');
  } else {
    log('安装过程中出现错误，请检查', 'red');
    process.exit(1);
  }
}

// 执行安装
if (require.main === module) {
  install().catch(err => {
    console.error(colors.red + '安装失败: ' + err.message + colors.reset);
    process.exit(1);
  });
}

module.exports = { install };
