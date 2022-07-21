local new(httpPort, name, image, selector, servicePort) = {
    httpPort: httpPort,
    name: name,
    image: image,
    selector: selector,
    servicePort: servicePort,
};

{
  new:: new,
}
