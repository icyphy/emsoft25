## Getting started

### WCET Analysis before Deadline Validation

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
    $ sudo docker run -ti -v ${PWD}/case-study/docker/:/root/rtas25/ -v ${PWD}/case-study/satellite-controller:/root/rtas25/satellite-controller -v ${PWD}/case-study/pretvm-instructions:/root/rtas25/pretvm-instructions einspaten/rtas25:v2
    $ ./analyse-all-instructions.sh
    $ ./analyse-satellite-controller.sh
```

The scripts would produce outputs like the following
```
- analysis-entry: multiply
  WCET(ns): 18320
- analysis-entry: _divide
  WCET(ns): 26320
- analysis-entry: divide
  WCET(ns): 26880
- analysis-entry: gyro_reaction
  WCET(ns): 20800
- analysis-entry: sensor_fusion_reaction
  WCET(ns): 142320
- analysis-entry: controller_run_reaction
  WCET(ns): 171920
- analysis-entry: controller_startup_reaction
  WCET(ns): 2560
- analysis-entry: controller_user_input_reaction
  WCET(ns): 560
- analysis-entry: motor_reaction
  WCET(ns): 80
- analysis-entry: user_input_startup
  WCET(ns): 560
```

These WCETs can later be specified in the LF program using the `@wcet` annotations.

---
Next, we will run the satellite attitude controller and record the traces.

### Requirements
- Linux environment, tested on Ubuntu 24.04
- Java 17, download [here](https://www.oracle.com/java/technologies/javase/jdk17-archive-downloads.html)

### Setup

1. Pull in submodules
```shell
git submodule update --init --recursive
```

2. Build the lingua franca compiler
```shell
cd lingua-franca
./gradlew assemble
```

3. Build the FlexPRET emulator using [these instructions](https://github.com/pretis/flexpret).

4. Compile the satellite attitude controller program.
```
lfc-dev SatelliteAttitudeController.lf
```

### Plot results
After running the program generating a `results.txt` (the one used in the paper is already checked into this repo) run
```
python3 scripts/plotSatellite.py results.txt .
```

### TODOs
- [ ] Bring EGS as a submodule here and document how to set it up using a virtual environment etc,
- [ ] Create a FlexPRET config used for the EMSOFT submission so others easily can build it  
