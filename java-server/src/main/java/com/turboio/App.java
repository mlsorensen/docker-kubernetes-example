package com.turboio;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpServer;

import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.util.Map;

/**
 * Hello world!
 *
 */
public class App 
{
    public static void main(String[] args) throws Exception {
        HttpServer server = HttpServer.create(new InetSocketAddress(8080), 0);
        server.createContext("/", new MyHandler());
        server.setExecutor(null); // creates a default executor
        server.start();
    }

    static class MyHandler implements HttpHandler {
        Map<String, String> env = System.getenv();
        private static final String ENV_HOSTNAME = "HOSTNAME";
        private static final String ENV_SERVERNAME = "SERVERNAME";
        private static final String DEFAULT_SERVERNAME = "Frank";

        @Override
        public void handle(HttpExchange t) throws IOException {
            String response = String.format("Hello, my name is %s! I'm running from instance '%s'\n", env.getOrDefault(ENV_SERVERNAME, DEFAULT_SERVERNAME), env.getOrDefault(ENV_HOSTNAME, ""));
            t.sendResponseHeaders(200, response.length());
            OutputStream os = t.getResponseBody();
            os.write(response.getBytes());
            os.close();

            System.out.printf("Got a connection from %s\n", t.getRemoteAddress());
        }
    }
}
