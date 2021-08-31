#!/usr/bin/env python3

"""
Pandoc filter using panflute
"""


import os
import os.path
import panflute as pf
import yaml

from converter import OUTPUT_META_BASEFILE_KEY, IMAGE_DIR_NOT_PROVIDED

def prepare(doc):
    doc.header_level = int(doc.get_metadata("header_level", None))
    doc.input_file = doc.get_metadata("input_file", "")
    doc.meta_title = doc.get_metadata("meta_title", "")
    doc.description = doc.get_metadata("description", "")
    doc.images_path = doc.get_metadata("images_path", default=IMAGE_DIR_NOT_PROVIDED)
    # out_meta load out_meta.yaml from outside
    out_meta_file = os.environ.get(OUTPUT_META_BASEFILE_KEY, None)
    with open(out_meta_file) as f:
        out_meta = yaml.load(f, Loader=yaml.FullLoader)
        doc.out_meta = out_meta


def get_out_meta_images(doc):
    return doc.out_meta.get("images", {})


class Action(object):

    def __init__(self, doc):
        self.doc: pf.Doc = doc

    def do(self, elem):
        if isinstance(elem, pf.Header):
            return self.do_header(elem)
        if isinstance(elem, pf.Image):
            return self.do_image(elem)
        return elem

    def do_header(self, elem):
        elem.level = elem.level + self.doc.header_level
        return elem

    def find_image_dir(self, parts) -> str:
        parts = list(filter(lambda x: x not in [".", "..", ""], parts))
        if len(parts) == 1 and ("image" in parts[0]):
            return self.doc.images_path
        out_meta_images = get_out_meta_images(self.doc)
        for k in out_meta_images:
            realpath = out_meta_images[k]
            partstr = os.path.join(*parts)
            #raise Exception("realpath %s endswith %s : %s" % (realpath, partstr, realpath.endswith(partstr)))
            if realpath.endswith(partstr):
                return k
        return None

    def do_image(self, elem):
        old_url = elem.url
        basename = os.path.basename(old_url)
        dirname = os.path.dirname(old_url)
        parts = os.path.normpath(dirname).split(os.sep)
        first_seg = parts[0]
        if "http" in first_seg:
            return elem
        image_key = ""
        #  for ik in ["image", "images"]:
            #  if ik not in parts:
                #  continue
            #  image_key = ik
            #  break
        for part in parts:
            if part in ["image", "images"]:
                image_key = part
                break
        if image_key == "":
            return elem
        sep_idx = parts.index(image_key)+1
        find_parts = parts[:sep_idx]
        rest_parts = parts[sep_idx:]
        new_dir = self.find_image_dir(find_parts)
        if new_dir is None:
            return elem
        new_parts = [new_dir] + rest_parts + [basename]
        new_url = os.path.join(*new_parts)
        return pf.Image(pf.Str(elem.title), url=new_url)


def action(elem: pf.Block, doc: pf.Doc):
    return Action(doc).do(elem)


def finalize(doc: pf.Doc):
    #raise Exception("input file %s header_level %s" % (doc.input_file, doc.header_level))
    header = pf.Header(pf.Str(doc.meta_title), level=doc.header_level)
    doc.content.insert(0, header)
    doc.content.insert(1, pf.Para(pf.Str(doc.description)))
    del doc.header_level
    del doc.input_file
    del doc.meta_title
    del doc.description
    del doc.images_path
    del doc.out_meta


def main(doc=None):
    return pf.run_filter(
            action,
            prepare=prepare,
            finalize=finalize,
            doc=doc)


if __name__ == "__main__":
    main()
