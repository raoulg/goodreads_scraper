FROM julia:latest

# Install RIE
RUN apt-get update && \
    apt-get install -y unzip && \
    curl -Lo aws-lambda-rie https://github.com/aws/aws-lambda-runtime-interface-emulator/releases/latest/download/aws-lambda-rie && \
    chmod +x aws-lambda-rie && \
    mv aws-lambda-rie /usr/local/bin/

# Copy the app files
COPY *.jl /app/
COPY *.toml /app/

# Set up the working directory
WORKDIR /app

# Install Julia dependencies
RUN julia -e 'using Pkg; \
             Pkg.activate("."); \
             Pkg.instantiate();'

# Set the entry point to use the RIE
ENTRYPOINT [ "/usr/local/bin/aws-lambda-rie", "julia", "--project", "app.jl" ]
