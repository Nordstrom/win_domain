# Encoding: utf-8
# Copyright 2015 Nordstrom, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#


name             'win_domain'
maintainer       'WSE Team, Nordstrom, Inc.'
license          'Apache v2.0'
description      'Installs/Configures windows server domain membership'
version          '1.1.0'

depends 'wse_powershell_helper', '~> 0.1'

source_url 'https://github.com/Nordstrom/win_domain'
issues_url 'https://github.com/Nordstrom/win_domain/issues'
