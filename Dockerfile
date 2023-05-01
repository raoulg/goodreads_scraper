FROM julia:1.8.5

COPY *.jl /app/
COPY *.toml /app/
WORKDIR /app/

RUN julia -e 'using Pkg; \
             Pkg.activate("."); \
             Pkg.instantiate();'

EXPOSE 8080

ENTRYPOINT [ "julia" ]