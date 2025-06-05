package com.guardion.app.demo.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import io.swagger.v3.oas.annotations.enums.SecuritySchemeType;
import io.swagger.v3.oas.annotations.security.SecurityScheme;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;

@Configuration
@SecurityScheme(
	name = "bearerAuth",
	type = SecuritySchemeType.HTTP,
	scheme = "bearer",
	bearerFormat = "JWT"
)
public class SwaggerConfig {
	@Bean
	public OpenAPI openAPI() {

		Info info = new Info()
			.version("v1.0.0")
			.title("Guardion API")
			.description("Guardion API 목록");

		return new OpenAPI()
			.info(info);
	}
}
