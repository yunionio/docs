## 导出成 word docx 文档

下面的步骤都在 docs/scripts 目录下运行

### 安装相关工具

```bash
# 安装 pandoc 转换 markdown 到 docx
$ brew install pandoc

# 安装 panflute python 包
$ pip3 install panflute

# 安装 wkhtmltopdf 负责把表格转图片
$ brew install wkhtmltopdf
```

### 导出步骤

1. 指定相关的导出 source 目录

```bash
# 清理 ./_output 目录结果
$ make clean

# 比如导出 ../content/zh/docs/faq 目录
$ ./collect-input.py ../content/zh/docs ./_output faq

# 如果要导出全部文档，命令如下
# $ ./collect-input.py ../content/zh/docs ./_output
```

2. 转换导出的目录为 word docx

```bash
$ make gen-docx
```

3. 查看结果

```bash
$ ls -alh ./_output/output.docx
```
