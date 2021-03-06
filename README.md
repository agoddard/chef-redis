# DESCRIPTION:

Install and configure [Redis](http://redis.io/).

# REQUIREMENTS:

This cookbook has only been tested on Ubuntu 10.04 and 11.04.

# ATTRIBUTES:

redis.config.listen_addr:: Address to listen on. Defaults to localhost.
redis.config.listen_port:: Port to listen on.
redis.config.appendonly:: Use the AOF file writing system.
redis.config.vm.enabled:: Use Redis' virtual memory.

Additional attributes are available for performance tuning, see attributes/default.rb for more information.

# USAGE:

The recipe redis::server will install and configure a Redis server.

# LICENSE & AUTHOR:
Author:: Miah Johnson (<miah@cx.com>)
Copyright:: 2012, CX, Inc
Author:: Noah Kantrowitz (<nkantrowitz@crypticstudios.com>)
Copyright:: 2010, Atari, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
