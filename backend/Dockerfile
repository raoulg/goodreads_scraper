FROM julia:latest


RUN curl -Lo /usr/local/bin/aws-lambda-rie \
    https://github.com/aws/aws-lambda-runtime-interface-emulator/releases/latest/download/aws-lambda-rie \
    && chmod +x /usr/local/bin/aws-lambda-rie

COPY *.jl /app/
COPY *.toml /app/
COPY bootstrap /app/
COPY entrypoint.sh /app/

WORKDIR /app/

RUN julia -e 'using Pkg; \
             Pkg.activate("."); \
             Pkg.instantiate();'

RUN chmod +x /app/bootstrap
RUN chmod +x /app/entrypoint.sh

EXPOSE 8080

# ENTRYPOINT [ "julia" ]
# ENTRYPOINT [ "/app/bootstrap" ]
# ENTRYPOINT [ "/usr/local/bin/aws-lambda-rie", "/app/bootstrap" ]
ENTRYPOINT [ "/app/entrypoint.sh" ]
