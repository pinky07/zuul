package com.gft.zuul;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.cloud.netflix.zuul.EnableZuulProxy;

/**
 * TODO Document this!
 *
 * @author Ruben Jimenez
 * @author Manuel Yepez
 */
@SpringBootApplication
@EnableZuulProxy
@EnableDiscoveryClient
public class ZuulReverseProxy {

	public static void main(String[] args) {
		SpringApplication.run(ZuulReverseProxy.class, args);
	}

}
