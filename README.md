[![docker image build](https://github.com/wikihost-opensource/als/actions/workflows/docker-image.yml/badge.svg)](https://github.com/wikihost-opensource/als/actions/workflows/docker-image.yml)

Language: English | [简体中文](README_zh_CN.md)

# ALS - Another Looking-glass Server

## Quick start
Build and run the container locally:
```bash
docker build -t als-dn11 .
docker run -d \
  --name looking-glass \
  --restart always \
  --network host \
  als-dn11
```

[DEMO](http://lg.hk1-bgp.hkg.50network.com/)

If you don't want to use Docker, you can use the [compiled server](https://github.com/wikihost-opensource/als/releases).

## Host Requirements
- RAM: 32MB or more

## How to change config
Pass environment variables during `docker run` to change defaults. Example: change the listen port to 8080.
```bash
docker run -d \
  --name looking-glass \
  -e HTTP_PORT=8080 \
  --restart always \
  --network host \
  als-dn11
```

## Environment variable table
| Key                       | Example                                                                | Default                                                    | Description                                                                             |
| ------------------------- | ---------------------------------------------------------------------- | ---------------------------------------------------------- | --------------------------------------------------------------------------------------- |
| LISTEN_IP                 | 127.0.0.1                                                              | (all ip)                                                   | which IP address will be listen use                                                     |
| HTTP_PORT                 | 80                                                                     | 80                                                         | which HTTP port should use                                                              |
| LOCATION                  | "this is location"                                                     | (request from http://ipapi.co) | location string                                                                         |
| PUBLIC_IPV4               | 1.1.1.1                                                                | (fetch from http://ifconfig.co)                            | The IPv4 address of the server                                                          |
| PUBLIC_IPV6               | fe80::1                                                                | (fetch from http://ifconfig.co)                            | The IPv6 address of the server                                                          |
| DISPLAY_TRAFFIC           | true                                                                   | true                                                       | Toggle the streaming traffic graph                                                      |
| ENABLE_SPEEDTEST          | true                                                                   | true                                                       | Toggle the speedtest feature                                                            |
| UTILITIES_PING            | true                                                                   | true                                                       | Toggle the ping feature                                                                 |
| UTILITIES_SPEEDTESTDOTNET | true                                                                   | true                                                       | Toggle the speedtest.net feature                                                        |
| UTILITIES_FAKESHELL       | true                                                                   | true                                                       | Toggle the HTML Shell feature                                                           |
| UTILITIES_IPERF3          | true                                                                   | true                                                       | Toggle the iperf3 feature                                                               |
| UTILITIES_IPERF3_PORT_MIN | 30000                                                                  | 30000                                                      | iperf3 listen port range - from                                                         |
| UTILITIES_IPERF3_PORT_MAX | 31000                                                                  | 31000                                                      | iperf3 listen port range - to                                                           |
| SPONSOR_MESSAGE           | "Test message" or "/tmp/als_readme.md" or "http://some_host/114514.md" | ''                                                         | Show server sponsor message (support markdown file, required mapping file to container) |

## Runtime notes
- `ntr` is provided as an alias for NextTrace DN42 mode. Fake shell sessions expose `ntr` and hide the raw `nexttrace` binary.
- `geofeed.csv` and `ptr.csv` are refreshed every 30 minutes from the internal mirror. Paths are kept in sync inside `nt_config.yaml` under `/opt/ntr`.
- File download speedtest has been removed from the UI; only HTML5/LibreSpeed measurements remain.

## Features
- [x] HTML 5 Speed Test
- [x] Ping - IPv4 / IPv6
- [x] iPerf3 server
- [x] Streaming traffic graph
- [x] Speedtest.net Client
- [x] Online shell box (limited commands)
- [x] [NextTrace](https://github.com/nxtrace/NTrace-core) Support

## Thanks to
https://github.com/librespeed/speedtest

https://www.jetbrains.com/

## License

Code is licensed under MIT Public License.

* If you wish to support my efforts, keep the "Powered by WIKIHOST Opensource - ALS" link intact.

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=wikihost-opensource/als&type=Date)](https://star-history.com/#wikihost-opensource/als&Date)
