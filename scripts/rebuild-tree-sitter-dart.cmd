@echo off
REM 为 GitNexus 的 Dart 语法树绑定注入 VS C++ 构建环境，便于仓库内手动重建。
call "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat"
cd /d "%~dp0..\node_modules\gitnexus\vendor\tree-sitter-dart"
npx node-gyp rebuild
