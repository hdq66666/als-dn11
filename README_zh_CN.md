[![docker image build](https://github.com/wikihost-opensource/als/actions/workflows/docker-image.yml/badge.svg)](https://github.com/wikihost-opensource/als/actions/workflows/docker-image.yml)

语言: [English](README.md) | 简体中文

# ALS - 另一个 Looking-glass 服务器

## 快速开始 (Docker 环境)
在项目根目录构建镜像并运行：
```bash
docker build -t als-dn11 .
docker run -d \
  --name looking-glass \
  --restart always \
  --network host \
  als-dn11
```

[演示站点](http://lg.hk1-bgp.hkg.50network.com/)

如果不想使用 Docker，可使用已经编译好的[服务器端程序](https://github.com/wikihost-opensource/als/releases)。

## 配置要求
- 内存：32MB 或更高

## 如何修改配置
在 `docker run` 时通过 `-e KEY=VALUE` 传入环境变量即可覆盖默认值。例：将监听端口改为 8080。
```bash
docker run -d \
  --name looking-glass \
  -e HTTP_PORT=8080 \
  --restart always \
  --network host \
  als-dn11
```

## 环境变量表
| Key                       | 示例                                                                | 默认                                                    | 描述                                                                             |
| ------------------------- | ---------------------------------------------------------------------- | ---------------------------------------------------------- | --------------------------------------------------------------------------------------- |
| LISTEN_IP                 | 127.0.0.1                                                              | (全部  IP)                                                   | 监听在哪一个 IP 上                                                     |
| HTTP_PORT                 | 80                                                                     | 80                                                         | 监听在哪一个端口上                                                              |
| SPEEDTEST_FILE_LIST       | 100MB 1GB                                                              | 1MB 10MB 100MB 1GB                                         | 静态文件大小列表, 使用空格隔开                                          |
| LOCATION                  | "this is location"                                                     | (请求 ipapi.co 获取) | 服务器位置的文本                                                                         |
| PUBLIC_IPV4               | 1.1.1.1                                                                | (从在线获取)                            | 服务器的 IPv4 地址                                                          |
| PUBLIC_IPV6               | fe80::1                                                                | (从在线获取)                            | 服务器的 IPv6 地址                                                          |
| DISPLAY_TRAFFIC           | true                                                                   | true                                                       | 实时流量开关                                                      |
| ENABLE_SPEEDTEST          | true                                                                   | true                                                       | 测速功能开关                                                            |
| UTILITIES_PING            | true                                                                   | true                                                       | Ping 功能开关                                                                 |
| UTILITIES_SPEEDTESTDOTNET | true                                                                   | true                                                       | Speedtest.net 功能开关                                                        |
| UTILITIES_FAKESHELL       | true                                                                   | true                                                       | Shell 功能开关                                                           |
| UTILITIES_IPERF3          | true                                                                   | true                                                       | iPerf3 服务器功能开关                                                               |
| UTILITIES_IPERF3_PORT_MIN | 30000                                                                  | 30000                                                      | iPerf3 服务器端口范围 - 开始                                                         |
| UTILITIES_IPERF3_PORT_MAX | 31000                                                                  | 31000                                                      | iPerf3 服务器端口范围 - 结束                                                           |
| SPONSOR_MESSAGE           | "Test message" or "/tmp/als_readme.md" or "http://some_host/114514.md" | ''                                                         | 显示节点赞助商信息 (支持 Markdown, 支持 URL/文字/文件 (文件需要映射到容器中, 使用映射后的路径)

## 运行说明
- 容器内提供 `ntr` 命令运行 NextTrace 的 DN42 模式，Fake Shell 中只暴露该命令。
- `geofeed.csv` 与 `ptr.csv` 每 30 分钟从内网镜像同步一次，`/opt/ntr/nt_config.yaml` 会自动保持正确路径。

## 功能
- [x] HTML 5 速度测试
- [x] Ping - IPv4 / IPv6
- [x] iPerf3 服务器控制
- [x] 实时网卡流量显示
- [x] Speedtest.net 客户端
- [x] 在线 shell 盒子 (限制命令)
- [x] [NextTrace](https://github.com/nxtrace/NTrace-core) 支持

## Thanks to
https://github.com/librespeed/speedtest

https://www.jetbrains.com/

## License

Code is licensed under MIT Public License.

* If you wish to support my efforts, keep the "Powered by WIKIHOST Opensource - ALS" link intact。

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=wikihost-opensource/als&type=Date)](https://star-history.com/#wikihost-opensource/als&Date)
