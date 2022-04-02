ARG BUILDER_IMAGE="hexpm/elixir:1.13.3-erlang-24.3.2-debian-bullseye-20210902-slim"
ARG RUNNER_IMAGE="debian:bullseye-20210902-slim"

FROM ${BUILDER_IMAGE} as builder
WORKDIR /app
RUN apt-get update -y && apt-get install -y build-essential git &&\
  apt-get clean && rm -f /var/lib/apt/lists/*_* &&\
  mix local.hex --force &&\
  mix local.rebar --force

ENV MIX_ENV="prod"
COPY mix.exs mix.lock ./
RUN mkdir config
COPY config/config.exs config/${MIX_ENV}.exs config/
RUN mix deps.get --only $MIX_ENV && mix deps.compile
COPY priv priv
COPY lib lib
RUN mix compile
COPY config/runtime.exs config/
COPY rel rel
RUN mix release

FROM ${RUNNER_IMAGE}
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV ECTO_IPV6 true
ENV ERL_AFLAGS "-proto_dist inet6_tcp"
WORKDIR "/app"
RUN apt-get update -y &&\
  apt get upgrade &&\
  apt-get install -y libstdc++6 openssl libncurses5 locales &&\
  apt-get clean &&\
  rm -f /var/lib/apt/lists/*_* &&\
  sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

RUN chown nobody /app
COPY --from=builder --chown=nobody:root /app/_build/prod/rel/cre_api ./
USER nobody
CMD ["/app/bin/server"]