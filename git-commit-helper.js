#!/usr/bin/env node
const { execSync } = require('child_process');

try {
  execSync('git add -A', { stdio: 'inherit' });
  execSync('git commit -m "feat: 添加自动化安装支持\n\n支持AI Agent（Codex等）自动安装：\n\n新增文件：\n- install.js - Node.js跨平台安装脚本\n- package.json - npm/npx支持\n- skills.json - Skills元数据（AI可解析）\n\n功能：\n- ✅ npx debate-agent-toolkit install\n- ✅ npm install -g debate-agent-toolkit  \n- ✅ node install.js（手动）\n- ✅ AI自动化安装（告诉AI安装GitHub项目即可）\n\n特性：\n- 自动检测平台（Claude Code/Cursor/通用）\n- 自动创建软链接\n- 跨平台支持（Windows/macOS/Linux）\n- 验证安装完整性\n\n更新README：\n- 添加AI自动安装说明\n- 添加npx/npm安装方法\n- 更新常见问题"', { stdio: 'inherit' });
  console.log('✅ Git提交成功');
} catch (err) {
  console.error('❌ Git提交失败:', err.message);
  process.exit(1);
}
