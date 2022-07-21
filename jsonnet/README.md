# Jsonnet

This is a data templating language. Can be useful for generating Kubernetes docs.
There are literally hundreds of ways to organize this.

see also https://jsonnet.org/learning/tutorial.html

## Example
As a simple example, I've modeled a pod and a service into Jsonnet functions in `lib`.
When these are called, they return a new object that looks like a pod/service and
subs in the values passed to the function.

Next, I've modeled an environment in `lib` as a Jsonnet function. This defines the 
adjustable per-environment values, and these will ultimately get fed into the pod and 
service functions to customize those. So any time I want a new environment, I provide 
the values to use in that environment.

Finally, in `main.jsonnet`, I import all of these, and have a function that you can
feed an enviroment object into and it will use it to generate a pod and a service
for that environment.  I also define environments `dev` and `prod`, and then process
these into a map for rendering to multiple files.

When jsonnet runs against `main.jsonnet` in multi-file mode, it takes the resulting
map output and creates `output/dev` and `output/prod`. You can see the difference
between these environments is the image version.

### Render YAML files
To render this as YAML files, we use the `-m` mode. This is really generating an object
with each key as filename and each value as the contents of the file, and `-m` tells it
to split this object and write it out as multiple files. `-S` treats the file contents
as a raw string, rather than escaping the YAML.

```
$ jsonnet -m output -S main.jsonnet
output/dev
output/prod
```

### Render raw
It can be illustrative to see what was really rendered by this `main.jsonnet` file
without the special treatment the flags above provide. This is particularly helpful
in debugging, in case your jsonnet is creating an array instead of an object, for example.

```
jsonnet main.jsonnet
```

