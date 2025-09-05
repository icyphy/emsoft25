# Quasi-Static Scheduling for Deterministic Timed Concurrent Models on Multi-Core Hardware

### Problem
Real-time embedded software aims to be predictable and efficient to run. To this end, _(quasi-)static scheduling_ has been applied extensively on a variety of concurrent models of computation, including [SDF](https://en.wikipedia.org/wiki/Synchronous_Data_Flow), [BDF](https://ptolemy.berkeley.edu/ptolemyclassic/almagest/docs/user/html/domains.doc5.html), [SADF](https://ieeexplore.ieee.org/document/6045491), and [LET](https://cs.uni-salzburg.at/~anas/papers/ARTS-chapter.pdf).
These existing techniques for generating schedules at compile time are strikingly similar across models.

In this paper, we ask the question — "Can these existing methods be _unified_ and _generalized_ for future models of computation?"

### Key Idea

The answer presented in this paper is **State Space Finite Automata (SSFA)**, an intermediate formalism bridging a model of computation and its underlying (quasi-)static schedules.

In a nutshell, an SSFA is a state machine where each state contains a DAG task set.
The SSFA should be derived from a high-level model of computation,
and we define deterministic timed concurrent models (DTCMs) to be a class of models that supports deriving SSFAs from models' semantics.

![ssfa](images/ssfa.png "Example of an SSFA")

Once an SSFA is constructed, a quasi-static schedule can be produced by partitioning each DAG task set based on the number of available cores.

### Demo

This repository shows how to apply the SSFA-based quasi-static scheduling technique to a synchronous subset of Lingua Franca (LF), which is an emerging programming model for cyber-physical systems.

This repository contains (i) code for the performance benchmark in the paper, and (ii) code for the satellite attitude control case study.

Below shows a satellite attitude controller modelled in Lingua Franca, whose SSFA is shown in the SSFA diagram above.

![satellite](images/SatelliteController2.svg "A satellite attitude controller in Lingua Franca")

## Getting started

### Requirements
- Linux environment, tested on Ubuntu 24.04
- Java 17, download [here](https://www.oracle.com/java/technologies/javase/jdk17-archive-downloads.html)


### Setup

1. Install dependencies
```shell
sudo apt install cmake verilator sbt 
```

2. Clone repo with submodule
```shell
git clone https://github.com/icyphy/pretvm-artifacts --recursive
```

3. Build the lingua franca compiler
```shell
cd lingua-franca
./gradlew assemble
```

4. Build the FlexPRET emulator

First download and install riscv-none-elf-gcc-14.2.0-2

```shell
  wget -q --show-progress https://github.com/xpack-dev-tools/riscv-none-elf-gcc-xpack/releases/download/v14.2.0-2/xpack-riscv-none-elf-gcc-14.2.0-2-linux-x64.tar.gz -O gcc.tar.gz
  tar xvf gcc.tar.gz --directory=/opt
```

Then source `env.bash` in the root of this artifact repo, it will add some environmental variables needed for the rest of the install and also when running programs

```shell
source env.bash
```

Then build the FlexPRET emulator and the FlexPRET SDK
```shell
cd flexpret
cmake -B build && cd build
make all install

cd sdk
cmake -B build && cd build
make
```

5. HelloWorld to verify installation
TODO: Add this step.


### WCET

You can either build the docker image yourself or pull it from dockerhub.

**Building it Yourself**
```bash
    $ sudo docker build ./docker -t einspaten/rtas25:v2
```

**Pulling it from Dockerhub**
```bash
    $ sudo docker pull einspaten/rtas25:v2
```

**Using the Docker Image**
```bash
    $ sudo docker run -ti -v ${PWD}/docker/:/root/rtas25/ -v ${PWD}/satellite-controller:/root/rtas25/satellite-controller -v ${PWD}/pretvm-instructions:/root/rtas25/pretvm-instructions einspaten/rtas25:v2
    $ ./analyse-all.sh
```

## TODOs
- [ ] Bring EGS as a submodule here and document how to set it up using a virtual environment etc,
- [ ] Create a FlexPRET config used for the EMSOFT submission so others easily can build it  
- [ ] Add the source links here and how to run the script to compile and do WCET analysis
