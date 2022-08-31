import os


class OEM(object):

    def __init__(self):
        self.oem = os.environ.get("OEM", None)
        self.name = os.environ.get("OEM_NAME", None)
        self.version = os.environ.get("OEM_VERSION", None)

    def is_defined(self):
        return self.oem or self.name or self.version


def fetch_from_env():
    return OEM()
