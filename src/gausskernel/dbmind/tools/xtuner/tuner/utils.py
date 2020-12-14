"""
Copyright (c) 2020 Huawei Technologies Co.,Ltd.

openGauss is licensed under Mulan PSL v2.
You can use this software according to the terms and conditions of the Mulan PSL v2.
You may obtain a copy of Mulan PSL v2 at:

         http://license.coscl.org.cn/MulanPSL2

THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
See the Mulan PSL v2 for more details.
"""

import os

RED_FMT = "\033[31;1m{}\033[0m"
GREEN_FMT = "\033[32;1m{}\033[0m"
YELLOW_FMT = "\033[33;1m{}\033[0m"
WHITE_FMT = "\033[37;1m{}\033[0m"


class cached_property:
    def __init__(self, func):
        self.func = func

    def __get__(self, instance, owner):
        if instance is None:
            return self

        val = self.func(instance)
        setattr(owner, self.func.__name__, val)
        return val


def clip(val, lower, upper):
    val = max(lower, val, key=lambda x: float(x))
    val = min(upper, val, key=lambda x: float(x))
    return val


def construct_header(header='', padding='-'):
    try:
        term_width = os.get_terminal_size().columns
    except OSError:
        term_width = 120

    side_width = max(0, (term_width - len(header)) // 2 - 1)

    if header == '':
        return padding * term_width
    else:
        return padding * side_width + ' ' + header + ' ' + padding * side_width
