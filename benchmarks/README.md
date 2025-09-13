# Performance Benchmarks

We provide instructions for running the performance benchmarks on a Raspberry Pi 4 running QNX 8.0. We assume that the Raspberry Pi 4 is connected to a host machine (e.g., your macOS laptop) via Ethernet and can be `ssh` into. The benchmark python script runs on the host machine and controls the Raspberry Pi 4 using `ssh`.

In [our setup](../images/rpi4-setup.jpg), we have the Raspberry Pi 4 connected to an Ubuntu machine.

## Prerequisites (Raspberry Pi 4)

The list of prerequisites continues, now onto the embedded platform, the Raspberry Pi 4.

### 1. Install QNX 8.0

Follow these official QNX tutorials to install QNX on your Raspberry Pi 4.
- [Quick start target image (QSTI)](https://www.qnx.com/developers/docs/qnxeverywhere/com.qnx.doc.qnxeverywhere/topic/qsti/intro.html)
- [Video: QNX Toolkit for Visual Studio Code + QNX OS 8.0 Deep Dive](https://www.youtube.com/watch?v=M02X6AqdK7M&t=2s)
- [GitLab: Raspberry Pi with QNX 8.0 Quick Start Project](https://gitlab.com/qnx/quick-start-images/raspberry-pi-qnx-8.0-quick-start-image)

After this step, you should also find a file located at `~/qnx800/qnxsdp-env.sh`. We will later use this when cross-compiling programs.


## Prerequisites (Host Machine)

### 2. C/C++ Utilities

Install [make](https://www.gnu.org/software/make/) and [CMake](https://cmake.org) on your host machine.

### 3. Python Dependencies
Install python dependencies by running
```
pip install -r benchmarks/scripts/requirements.txt
```

This script also calls `sshpass`, which can be installed on macOS via
```
brew install sshpass
```

Or if you are on Ubuntu
```
sudo apt-get update
sudo apt-get install sshpass
```

### 4. Lingua Franca (LF)

4.1: Update all submodules in the repo.
```
git submodule update --init --recursive
```

4.2: install [Java 17](https://openjdk.org/projects/jdk/17/) on your host machine.

4.3: Then `cd` into `lingua-franca`, run
```
./gradlew assemble
```

4.4: After this is done, add `lingua-franca/bin/lfc-dev` to your `PATH` variable.

## How to Run

Now we are ready to run the benchmarks.

### Source `qnxsdp-env.sh`

On your host machine, there should be a `~/qnx800/qnxsdp-env.sh`. Let's source it.
```
source ~/qnx800/qnxsdp-env.sh
```

### Add credentials for SSH

Copy `benchmarks/scripts/credentials.template.py` to `benchmarks/scripts/credentials.py`. Fill in credentials for the embedded device in `benchmarks/scripts/credentials.py`.
```
cd benchmarks/scripts/
cp credentials.template.py credentials.py
```

### Launch the script!
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
