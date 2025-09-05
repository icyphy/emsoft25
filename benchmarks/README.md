# Running Timing Benchmarks Automatically
Install python dependencies by running
```
pip install -r scripts/requirements.txt
```

This script also calls `sshpass`, which can be installed on macOS via
```
brew install sshpass
```

Then create a `credentials.py` in `scripts`
```python
IP_RPI4="<IP Address for the Raspberry Pi 4>"
UN_RPI4="<Username for the Raspberry Pi 4>"
PW_RPI4="<Password for the Raspberry Pi 4>"
IP_ODROID="<IP Address for the ODROID-XU4>"
UN_ODROID="<Username for the ODROID-XU4>"
PW_ODROID="<Password for the ODROID-XU4>"
```

Then simply run
```
python scripts/experiment_timing.py
```

More configuration options can be found in the script.

# Workflow for Updating Plots
Sometimes we have collected the data and just want to regenerate the graphs. In
this case, use the `--experiment-dir` flag. For example,
```
python scripts/experiment_timing.py --experiment-dir=2024-03-30_00-51-22-RPI4-LOAD_BALANCED_EGS-ALL
```
And then, go back to the root directory and run
```
sh scripts/update_pdf_diagrams.sh 2024-03-30_00-51-22-RPI4-LOAD_BALANCED_EGS-ALL
```
The new plots will be automatically added to `images/plots`.

# Running Timing Benchmarks Manually
To run a set of timing benchmarks using a particular scheduler and collect
tracing data back, first `cd` into the timing directory, then invoke a command
of the following form:
```
python ../script/run_benchmark.py -hn=<board-ip-address> -un=<board-username> -pwd="<board-password>" -f="<lfc-flag-1>" -f="<lfc-flag-2>" ...
```

For example, to run the benchmark suite using the STATIC scheduler:
```
python ../script/run_benchmark.py -hn=<Board-IP-Address> -un=<Board-Username> -pwd="<Board-Password>" -f="--scheduler=STATIC" -f="--static-scheduler=LOAD_BALANCED"
```

# Comments about the programs

LF programs which are ***not*** supported yet by the static scheduler are those with:
- logical/physical actions, 
- and deadlines (to be supported).
In addition, timers are needed in order to define the hyperperiods and check for
timing constraints.

Logical actions that behave like connections should be rewritten using connections.  

| LF prog.    | Inc |Timers | Deadline | After delay | Logical Action | Physical Action |
|-------------|-----|-------|----------|-------------|----------------|-----------------|
| ADASModel   | no  |  2    | yes      | yes         | yes            | yes             |
| AircraftDoor| no  |  0    | -        | -           | -              | -               |
| Alarm       | no  |  0    | -        | -           | yes            | -               |
| CoopSchedule| yes |  1    | -        | -           | -              | -               |
| Elelction   | no  |  0    | -        | -           | yes            | -               |
| Elelction2  | no  |  0    | -        | yes         | -              | -               |
| Elevator    | yes |  3    | -        | -           | yes            | -               |
| Factorial   | yes |  1    | -        | -           | yes            | -               |
| Fibonacci   | yes |  1    | -        | -           | yes            | -               |
| PingPong    | no  |  0    | -        | -           | yes            | -               |
| Pipe        | yes |  1    | -        | -           | yes            | -               |
| ProcessMsg  | yes |  1    | -        | -           | yes            | -               |
| ProcessSync | yes |  1    | -        | -           | -              | -               |
| Railroad    | yes |  1    | -        | -           | yes            | -               |
| Ring        | no  |  0    | -        | yes         | yes            | -               |
| RoadsideUnit| no  |  0    | -        | -           | yes            | -               |
| SafeSend    | no  |  0    | -        | yes         | yes            | -               |
| Subway      | no  |  0    | -        | -           | yes            | -               |
| Thermostat  | yes |  1    | -        | -           | yes            | -               |
| TrafficLight| yes |  2    | -        | -           | yes            | -               |
| TrainDoor   | no  |  0    | -        | yes         | -              | -               |
| UnsafeSend  | no  |  0    | -        | yes         | yes            | -               |
