# EexCompilerViewer

App that allows you to step through the compilation of an EEx template using the various EEx Engines.

- EEx.SmartEngine
- Phoenix.HTML.Engine
- Phoenix.LiveView.Engine
- Phoenix.LiveView.HTMLEngine
- 
![eex-viewer](https://user-images.githubusercontent.com/5523984/162604950-a682e940-2af2-4968-886b-7413f256020d.gif)

### Benchmarking Output

There is a livebook in here that benchmarks the output of the various engines, and a modified version of the SmartEngine (the "concatenation" scenario)

```
Operating System: macOS
CPU Information: Apple M1
Number of Available Cores: 8
Available memory: 8 GB
Elixir 1.13.3
Erlang 24.0.1

Benchmark suite executing with the following configuration:
warmup: 1 s
time: 5 s
memory time: 2 s
reduction time: 2 s
parallel: 1
inputs: none specified
Estimated total run time: 30 s

Benchmarking with_bitstring ...
Benchmarking with_concatenation ...
Benchmarking with_iolist ...

Name                         ips        average  deviation         median         99th %
with_concatenation         92.09       10.86 ms    ±21.12%       10.60 ms       14.60 ms
with_bitstring             91.72       10.90 ms    ±20.73%       10.61 ms       15.11 ms
with_iolist                42.52       23.52 ms    ±28.33%       22.32 ms       38.79 ms

Comparison: 
with_concatenation         92.09
with_bitstring             91.72 - 1.00x slower +0.0435 ms
with_iolist                42.52 - 2.17x slower +12.66 ms

Memory usage statistics:

Name                  Memory usage
with_concatenation         7.63 MB
with_bitstring             7.63 MB - 1.00x memory usage +0 MB
with_iolist               13.73 MB - 1.80x memory usage +6.11 MB

**All measurements for memory usage were the same**

Reduction count statistics:

Name                       average  deviation         median         99th %
with_concatenation        594.60 K     ±0.28%       594.20 K       601.37 K
with_bitstring            595.59 K     ±0.54%       594.78 K       611.22 K
with_iolist              1974.70 K     ±0.31%      1972.97 K      1989.79 K

Comparison: 
with_concatenation        594.20 K
with_bitstring            595.59 K - 1.00x reduction count +0.98 K
with_iolist              1974.70 K - 3.32x reduction count +1380.09 K
```
