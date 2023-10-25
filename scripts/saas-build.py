#!/usr/bin/env python
# -*- coding: utf-8 -*-

import argparse
import textwrap

from converter.processor import ALL_SCOPES
from converter import processor


def is_oem_mode():
    return os.getenv("OEM", False) or os.getenv("OEM_NAME", False)


def copy_by_scope(input_dir, output_dir, req_scope,
                  edition=processor.EDITION_CE):
    p = processor.DirProcess(input_dir, output_dir)
    p.include_by_scope(req_scope). \
        include_by_oem(is_oem_mode()). \
        include_by_edition(edition). \
        start()

def parse_args():
    parser = argparse.ArgumentParser(
        description="Build SAAS documents.",
        formatter_class=argparse.RawTextHelpFormatter)

    parser.add_argument("source",
                        help="输入的来源文档内容，比如: ./content")
    parser.add_argument("output",
                        help="输出的文档内容",
                        default="./_output/saas_content")
    parser.add_argument("scope",
                        choices=ALL_SCOPES,
                        help=textwrap.dedent('''\
                            编译的文档级别
                                system: 编译管理视图可见的文档
                                domain: 编译域视图可见的文档
                                project: 编译项目视图可见的文档
                        '''))

    parser.add_argument("edition",
                        choices=[processor.EDITION_CE, processor.EDITION_EE],
                        default=processor.EDITION_CE,
                        help=textwrap.dedent('''\
                            编译的文档版本
                                ce: 开源版本
                                ee: 企业版本
                        '''))

    args = parser.parse_args()
    return args


if __name__ == '__main__':
    args = parse_args()
    copy_by_scope(args.source, args.output, args.scope, args.edition)
