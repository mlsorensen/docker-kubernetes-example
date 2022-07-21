local new(name, selector, port, nodePort) = {
  apiVersion: 'v1',
  kind: 'Service',
  metadata: {
    name: name,
  },
  spec: {
    type: 'NodePort',
    selector: {
      app: selector,
    },
    ports: [
      {
        protocol: 'TCP',
        port: port,
        nodePort: nodePort,
      },
    ],
  },
};

{
  new:: new,
}
