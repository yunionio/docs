import os

MODE_ONLINE = 'online'
MODE_OFFLINE = 'offline'
MODE_OEM = 'oem'

DEFAULT_VERSION_ARRAY = [
    '3.10',
    '3.9',
    '3.8',
    '3.7',
    '3.6',
    '3.4',
    '3.3',
    '3.2'
]


def VERSION_ARRAY():
    # VERSIONS='3.9,3.8'
    versions = os.environ.get('VERSIONS', None)
    if versions:
        return versions.split(',')
    return DEFAULT_VERSION_ARRAY
