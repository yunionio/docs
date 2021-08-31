import os

from utils import run_process


class Hugo(object):

    def __init__(self, content_dir):
        self._host = ''
        self._title = 'Cloudpods'
        self._content_dir = content_dir
        self._base_url_prefix = ''
        self._dest_dir = 'public'
        self._current_branch = ''
        self._current_version = ''
        self._versions = []

    def set_host(self, host):
        self._host = host
        return self

    def get_host(self):
        return self._host

    def get_title(self):
        return self._title

    def set_title(self, title):
        self._title = title
        return self

    def set_current_branch(self, cur_br):
        self._current_branch = cur_br
        return self

    def get_current_branch(self):
        return self._current_branch

    def set_current_version(self, ver):
        self._current_version = ver
        return self

    def get_current_version(self):
        return self._current_version

    def set_versions(self, versions):
        self._versions = versions
        return self

    def set_base_url_prefix(self, pre):
        self._base_url_prefix = pre
        return self

    def get_base_url_prefix(self):
        return self._base_url_prefix

    def set_dest_dir(self, dest):
        self._dest_dir = dest
        return self

    def get_dest_dir(self):
        return self._dest_dir

    def execute(self):
        env = {}
        env['CONTENT_DIR'] = self._content_dir

        if self.get_current_branch():
            env['CURRENT_BRANCH'] = self.get_current_branch()
        if self.get_current_version():
            env['CURRENT_VERSION'] = self.get_current_version()
        if self._versions:
            env['VERSIONS'] = ','.join(['v'+v for v in self._versions])

        ver_dir = ''
        ver_title = self.get_title()
        if self._versions:
            if not self.get_current_version():
                raise Exception("Current version not set when versions are %s" % self._versions)
            if self.get_current_version() != self._versions[0]:
                ver_dir = 'v' + self.get_current_version()
                ver_title = ver_title + ' ' + self.get_current_version()

        env['HUGO_TITLE'] = ver_title


        dest = self.get_dest_dir()
        base_url = self.get_host()
        base_url = os.path.join(base_url, self.get_base_url_prefix())
        if ver_dir:
            dest = os.path.join(dest, ver_dir)
            base_url = base_url + '/' + ver_dir

        cmd = ['hugo', '--minify',
               '--destination=%s' % dest,
               '--baseURL=%s' % base_url]
        run_process(['rm', '-rf', dest])
        run_process(cmd, env)
        print("=== Build result: %s" % dest)
