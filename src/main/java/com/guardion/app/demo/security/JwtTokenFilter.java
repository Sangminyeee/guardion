package com.guardion.app.demo.security;

import static org.aspectj.weaver.tools.cache.SimpleCacheFactory.*;

import java.io.IOException;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.filter.OncePerRequestFilter;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@AllArgsConstructor
public class JwtTokenFilter extends OncePerRequestFilter {

	private final JwtProvider jwtProvider;
	private final CustomUserDetailsService userDetailsService;

	@Override
	protected void doFilterInternal(HttpServletRequest request,
		HttpServletResponse response,
		FilterChain filterChain)
		throws ServletException, IOException {
		String token = resolveToken(request);
		log.debug("Extracted token: {}", token);
		if (token != null && jwtProvider.validateToken(token)) {
			String username = jwtProvider.getUsername(token);
			UserDetails userDetails = userDetailsService.loadUserByUsername(username);

			// tokenVersion 비교
			Integer tokenVersionInToken = jwtProvider.getTokenVersion(token);
			Integer tokenVersionInDb = ((CustomUserDetails) userDetails).getUser().getTokenVersion();
			if (!tokenVersionInToken.equals(tokenVersionInDb)) {
				log.warn("Token version mismatch for user: {}", username);
				throw new RuntimeException("Invalid token version. 만료된 토큰입니다.");
			}

			Authentication auth = new UsernamePasswordAuthenticationToken(
				userDetails, null, userDetails.getAuthorities());
			SecurityContextHolder.getContext().setAuthentication(auth);
			log.debug("Authentication set for user: {}", username);
		} else {
			log.warn("Invalid token: {}", token);
		}

		filterChain.doFilter(request, response);
	}

	private String resolveToken(HttpServletRequest request) {
		String bearer = request.getHeader("Authorization");
		log.debug("Authorization header: {}", bearer);
		return (bearer != null && bearer.startsWith("Bearer ")) ?
			bearer.substring(7) : null;
	}
}
