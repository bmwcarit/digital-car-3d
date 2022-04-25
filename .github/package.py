#!/usr/bin/env python3

# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Ramses Composer
# (see https://github.com/bmwcarit/ramses-composer-docs).
#
# This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
# If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/.

from pathlib import Path
import shutil
import os
import sys
import subprocess
import re


def get_git_files(path):
    """Get all files known to git"""
    cmd = ['git', 'ls-files', '-z']
    files = [f.decode('utf-8') for f in subprocess.check_output(cmd, cwd=path).split(b'\0') if f]
    return files


def filter_includes_excludes(iterable, *, includes=['.*'], excludes=[]):
    key_fun = (lambda e: e)
    include_re = re.compile('|'.join([f'(?:{i})'for i in includes]))
    exclude_re = re.compile('|'.join([f'(?:{e})'for e in excludes]))

    res = []
    for e in iterable:
        k = key_fun(e)
        if includes and include_re.search(k) and not (excludes and exclude_re.search(k)):
            res.append(e)
    return res


def copy_files(source_root, destination_root, files):
    for f in files:
        source_path = Path(source_root) / f
        destination_path = Path(destination_root) / f
        destination_path.parent.mkdir(parents=True, exist_ok=True)
        if source_path.is_symlink():
            destination_path.unlink(missing_ok=True)
        shutil.copy(source_path, destination_path, follow_symlinks=False)


def main():
    output_folder = '.'
    if len(sys.argv) == 2:
        output_folder = sys.argv[1]

    script_dir = Path(os.path.realpath(os.path.dirname(__file__)))
    repo_root = (script_dir / '..').resolve()

    cars = [
        {
            'path': 'G05',
            'include': ['.*'],
            'exclude': [
                '^docs/'
            ]
        }
    ]

    for car in cars:
        car_root = repo_root / car['path']
        release = repo_root / 'release' / car['path']
        release.mkdir(parents=True)

        # gather project files
        car_files = get_git_files(car_root)
        car_files = filter_includes_excludes(car_files, includes=car['include'], excludes=car['exclude'])

        # copy source -> destination
        copy_files(car_root, release, car_files)

        # copy license file
        shutil.copy(repo_root / 'LICENSE.txt', release / 'LICENSE.txt')

        # Create zip archive
        shutil.make_archive(Path(output_folder) / car['path'], 'zip', release)

    return 0


if __name__ == "__main__":
    sys.exit(main())
