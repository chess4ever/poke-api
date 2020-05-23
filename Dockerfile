FROM prima/elixir:1.10.3-1

COPY config ./config
COPY lib ./lib
COPY test ./test
COPY mix.exs .
COPY mix.lock .

RUN rm -Rf _build && \
    mix deps.get && \
    mix c

EXPOSE 5000

CMD [ "mix", "run", "--no-halt" ]
