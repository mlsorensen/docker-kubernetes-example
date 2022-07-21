local pod = import 'lib/pod.libsonnet';
local service = import 'lib/service.libsonnet';
local environment = import 'lib/environment.libsonnet';

// load all environments
local environments = { 
    prod: environment.new(8080, "fancy", "robotron:v3", "atomic", 30080),
    dev: environment.new(8080, "fancy", "robotron:v4", "atomic", 30080),
};

// define what documents we want to render per environment
local renderEnvironmentDoc(env) = std.manifestYamlStream([
    pod.new( env.name, env.image, env.selector, env.httpPort),
    service.new(env.name, env.selector, env.httpPort, env.servicePort)
], quote_keys=false);

// for each environment, render the doc
std.mapWithKey(function(key, env) renderEnvironmentDoc(env), environments)
