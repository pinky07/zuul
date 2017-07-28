package com.gft.zuul.configuration;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;

/**
 * TODO Document this!
 *
 * @author Ruben Jimenez
 * @author Manuel Yepez
 */
@Configuration
public class ZuulConfiguration {

     @Bean
     public CorsFilter corsFilter() {
          UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
          CorsConfiguration config = new CorsConfiguration();
          config.setAllowCredentials(true);
          config.addAllowedOrigin("*");
          config.addAllowedHeader("*");
          config.addAllowedMethod("*");
          source.registerCorsConfiguration("/**", config);
          return new CorsFilter(source);
     }
}
