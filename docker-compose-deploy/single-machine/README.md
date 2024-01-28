# 单机部署 redis-cluster 和 openresty ，验证[resty-redis-cluster](https://github.com/Kong/resty-redis-cluster)

![](snapshots/2024-01-28-14-43-14.png)

- [nginx.conf](./nginx.conf)

Docker redis 集群测试：

| \#  | 方案          | TPS   |
| --- | ------------- | ----- |
| 1   | redis-cluster | 5381  |
| 2   | direct        | 18071 |

```sh
$ berf :8100/ name==name3 -n1  
### 127.0.0.1:54056->127.0.0.1:8100 时间: 2024-01-28T23:25:05.081722+08:00 耗时: 1.879057ms  读/写: 378/168 字节
GET /?name=name3 HTTP/1.1
User-Agent: blow
Host: 127.0.0.1:8100
Content-Type: plain/text; charset=utf-8
Accept: application/json
Accept-Encoding: gzip, deflate


HTTP/1.1 200 OK
Server: openresty/1.21.4.3
Date: Sun, 28 Jan 2024 15:25:05 GMT
Content-Type: applicaiton/json;charset=utf8
Transfer-Encoding: chunked
Connection: keep-alive

{"value":"当你想要测试一块玻璃的硬度时，这块玻璃注定要碎。换句话说，怀疑一旦产生，罪名就已经成立了。\n\n——《蝉女》\n","arg":"name3"}


$ berf :8100/v2 name==name3 -n1
### 127.0.0.1:54073->127.0.0.1:8100 时间: 2024-01-28T23:25:07.334907+08:00 耗时: 1.343334ms  读/写: 378/170 字节
GET /v2?name=name3 HTTP/1.1
User-Agent: blow
Host: 127.0.0.1:8100
Content-Type: plain/text; charset=utf-8
Accept: application/json
Accept-Encoding: gzip, deflate


HTTP/1.1 200 OK
Server: openresty/1.21.4.3
Date: Sun, 28 Jan 2024 15:25:07 GMT
Content-Type: applicaiton/json;charset=utf8
Transfer-Encoding: chunked
Connection: keep-alive

{"arg":"name3","value":"当你想要测试一块玻璃的硬度时，这块玻璃注定要碎。换句话说，怀疑一旦产生，罪名就已经成立了。\n\n——《蝉女》\n"}

```

```sh
$ berf :8100 name==name3 -d1m -vv 
Log details to: /var/folders/6s/h7cl_shn1xn6psyn1rsv14kc0000gn/T/blow_20240128232102_2766238764.log
Berf  http://127.0.0.1:8100/ for 1m0s using 100 goroutine(s), 12 GoMaxProcs.
@Real-time charts is on http://127.0.0.1:28888

汇总:
  耗时                     1m0.009s
  总次/RPS          322943 5381.568
    200             322943 5381.568
  平均读写        16.274 7.233 Mbps
  总和读写  122070954 54254424 字节
  连接数                        400

统计         Min      Mean    StdDev      Max   
  Latency  7.008ms  18.531ms  5.698ms  152.625ms
  RPS      3794.61  5380.12   675.78    6803.83 

百分位延迟:
  P50         P75       P90       P95       P99     P99.9     P99.99  
  16.848ms  21.315ms  25.318ms  28.257ms  36.04ms  52.972ms  137.167ms

直方图延迟:
  16.111ms   218745  67.73%  ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
  22.508ms    89393  27.68%  ■■■■■■■■■■■■■■■■
  28.55ms     13167   4.08%  ■■
  35.805ms     1311   0.41%  
  52.93ms       227   0.07%  
  113.118ms       6   0.00%  
  134.627ms      92   0.03%  
  147.013ms       2   0.00%  
$ berf :8100/v2 name==name3 -d1m -vv
Log details to: /var/folders/6s/h7cl_shn1xn6psyn1rsv14kc0000gn/T/blow_20240128232259_1540497921.log
Berf  http://127.0.0.1:8100/v2 for 1m0s using 100 goroutine(s), 12 GoMaxProcs.
@Real-time charts is on http://127.0.0.1:28888

汇总:
  耗时                      1m0.008s
  总次/RPS         1084466 18071.969
    200            1084466 18071.969
  平均读写        54.649 24.578 Mbps
  总和读写  409923123 184359220 字节
  连接数                        1105

统计         Min      Mean    StdDev      Max   
  Latency   851µs   5.488ms   3.469ms  249.726ms
  RPS      6586.86  18072.09  2570.96  23529.79 

百分位延迟:
  P50       P75      P90      P95      P99      P99.9     P99.99  
  5.194ms  6.17ms  7.185ms  7.945ms  10.973ms  29.468ms  139.466ms

直方图延迟:
  3.96ms    248478  22.91%  ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
  4.746ms   284794  26.26%  ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
  5.642ms   285495  26.33%  ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
  6.976ms   217358  20.04%  ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
  9.079ms    45114   4.16%  ■■■■■■
  17.269ms    2978   0.27%  
  84.678ms     192   0.02%  
  195.09ms      57   0.01%

```