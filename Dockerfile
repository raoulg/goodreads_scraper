FROM julia:1.8.5

RUN curl -Lo /usr/local/bin/aws-lambda-rie \
    https://github.com/aws/aws-lambda-runtime-interface-emulator/releases/latest/download/aws-lambda-rie \
    && chmod +x /usr/local/bin/aws-lambda-rie

COPY *.jl /app/
COPY *.toml /app/
COPY entrypoint.sh /app/
COPY bootstrap /app/

WORKDIR /app/

RUN julia -e 'using Pkg; \
             Pkg.activate("."); \
             Pkg.instantiate();'
RUN chmod +x /app/entrypoint.sh
RUN chmod +x /app/bootstrap

EXPOSE 8080

# ENTRYPOINT [ "julia" ]
ENTRYPOINT [ "/app/bootstrap" ]