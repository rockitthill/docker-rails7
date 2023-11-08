FROM ruby:3.2.2-slim

# Set up directory structure
RUN mkdir /app
WORKDIR /app
ENV NODE_MAJOR 20

# Install everything
RUN apt-get update -qq \
&& apt-get install -qq --no-install-recommends build-essential curl git nano \
libmariadb-dev imagemagick ca-certificates gnupg \
&& mkdir -p /etc/apt/keyrings \
&& curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
&& echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_${NODE_MAJOR}.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list \
&& apt-get update -qq \
&& apt-get install -qq --no-install-recommends nodejs \
&& npm install -g yarn@1.22.19 npm@10.2.3 \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Bundler config
RUN bundle config set --global path '/bundle'
ENV PATH="/app/bin:/bundle/ruby/3.2.2/bin:/bundle/ruby/3.2.0/bin:${PATH}"

# Ensure binding is always 0.0.0.0 to access the server outside the container
ENV BINDING="0.0.0.0"
ENV PORT="3000"
ENV EDITOR=nano

# Expose the Rails port
EXPOSE 3000
