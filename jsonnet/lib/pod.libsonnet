local new(name, image, selector, port) = {
  apiVersion: 'v1',
  kind: 'Pod',
  metadata: {
    name: name,
    labels: {
      app: selector,
    },
  },
  spec: {
    containers: [
      {
        name: 'server',
        image: image,
        imagePullPolicy: 'Never',
        ports: [
          {
            containerPort: port,
          },
        ],
        resources: {
          limits: {
            cpu: 1,
            memory: '128Mi',
          },
          requests: {
            cpu: '500m',
            memory: '64Mi',
          },
        },
      },
    ],
  },
};

{
  new:: new,
}
