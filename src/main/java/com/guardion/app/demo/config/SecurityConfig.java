package com.guardion.app.demo.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.ProviderManager;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import com.guardion.app.demo.security.CustomUserDetailsService;
import com.guardion.app.demo.security.JwtProvider;
import com.guardion.app.demo.security.JwtTokenFilter;

import lombok.AllArgsConstructor;

@Configuration
@EnableMethodSecurity
@AllArgsConstructor
public class SecurityConfig {

	private final JwtProvider jwtProvider;
	private final CustomUserDetailsService userDetailsService;

	@Bean
	public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
		return http
			.csrf(csrf -> csrf.disable())
			.httpBasic(Customizer.withDefaults())
			.sessionManagement(session -> session
				.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
			.authorizeHttpRequests(auth -> auth
				.requestMatchers("/auth/**",
					"/signup",
					"/login",
					"/health",
					"/error",
					"/v3/api-docs/**",
					"/swagger-ui.html",
					"/swagger-ui/**",
					"/swagger-resources/**",
					"/api/mqtt/**").permitAll()
				.anyRequest().authenticated())
			.addFilterBefore(new JwtTokenFilter(jwtProvider, userDetailsService), UsernamePasswordAuthenticationFilter.class)
			.build();
	}

	@Bean
	public AuthenticationManager authenticationManager(UserDetailsService userDetailsService,
		PasswordEncoder passwordEncoder) {
		DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider();
		authProvider.setUserDetailsService(userDetailsService);
		authProvider.setPasswordEncoder(passwordEncoder);

		return new ProviderManager(authProvider);
	}

	@Bean
	public JwtTokenFilter jwtTokenFilter() {
		return new JwtTokenFilter(jwtProvider, userDetailsService);
	}
}
