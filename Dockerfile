FROM ubuntu:22.04

# Timezone and locale
ENV TZ="UTC"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Base packages
RUN apt-get update && apt-get install -y \
    git wget curl tar sudo apt-utils software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# Build tools
RUN apt-get update && apt-get install -y \
    build-essential ninja-build cmake make pkg-config libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Java 17 (for Lingua Franca compiler)
RUN apt-get update && apt-get install -y openjdk-17-jdk \
    && rm -rf /var/lib/apt/lists/*
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

# Python 3
RUN apt-get update && apt-get install -y python3 python3-pip python3-venv \
    && rm -rf /var/lib/apt/lists/*

# Python dependencies for benchmarks
RUN pip3 install --no-cache-dir \
    paramiko==3.5.0 pandas==2.2.3 seaborn==0.13.2 imageio==2.36.0 matplotlib

# Python dependencies for EGS
RUN pip3 install --no-cache-dir \
    numpy==2.1.3 scipy==1.15.2 tensorflow==2.19.0

# Ruby (for WCET analysis tools)
RUN apt-get update && apt-get install -y ruby ruby-dev \
    && rm -rf /var/lib/apt/lists/*
RUN gem install bundler -v 2.4.22

# Verilator (for FlexPRET emulator)
RUN apt-get update && apt-get install -y verilator \
    && rm -rf /var/lib/apt/lists/*

# Scala/SBT (for FlexPRET build)
RUN apt-get update && apt-get install -y gnupg2 \
    && rm -rf /var/lib/apt/lists/*
RUN echo "deb https://repo.scala-sbt.org/scalasbt/debian all main" | tee /etc/apt/sources.list.d/sbt.list
RUN echo "deb https://repo.scala-sbt.org/scalasbt/debian /" | tee /etc/apt/sources.list.d/sbt_old.list
RUN curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | apt-key add
RUN apt-get update && apt-get install -y scala sbt \
    && rm -rf /var/lib/apt/lists/*

# RISC-V Toolchain (xPack)
ENV RISCV_VERSION=14.2.0-2
RUN mkdir -p /opt && cd /opt \
    && wget -q https://github.com/xpack-dev-tools/riscv-none-elf-gcc-xpack/releases/download/v${RISCV_VERSION}/xpack-riscv-none-elf-gcc-${RISCV_VERSION}-linux-x64.tar.gz \
    && tar -xzf xpack-riscv-none-elf-gcc-${RISCV_VERSION}-linux-x64.tar.gz \
    && rm xpack-riscv-none-elf-gcc-${RISCV_VERSION}-linux-x64.tar.gz
ENV RISCV_TOOL_PATH_PREFIX=/opt/xpack-riscv-none-elf-gcc-${RISCV_VERSION}
ENV PATH="${RISCV_TOOL_PATH_PREFIX}/bin:${PATH}"

# WCET analysis dependencies (from case-study)
RUN apt-get update && apt-get install -y \
    liblpsolve55-dev lp-solve \
    libc6-dev-i386 gcc-multilib \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

# Setup environment script
RUN echo '#!/bin/bash\n\
export RISCV_TOOL_PATH_PREFIX=/opt/xpack-riscv-none-elf-gcc-14.2.0-2\n\
export PATH="${RISCV_TOOL_PATH_PREFIX}/bin:${PATH}"\n\
if [ -d "/workspace/lingua-franca/build/install/lf-cli/bin" ]; then\n\
  export PATH="/workspace/lingua-franca/build/install/lf-cli/bin:${PATH}"\n\
  export LFC=/workspace/lingua-franca/build/install/lf-cli/bin/lfc\n\
fi\n\
if [ -f "/workspace/flexpret/env.bash" ]; then\n\
  source /workspace/flexpret/env.bash\n\
fi' > /setup_env.sh && chmod +x /setup_env.sh

RUN echo 'source /setup_env.sh' >> /root/.bashrc

ENTRYPOINT ["/bin/bash"]
