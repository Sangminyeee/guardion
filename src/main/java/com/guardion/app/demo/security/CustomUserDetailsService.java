package com.guardion.app.demo.security;

import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.guardion.app.demo.repository.UserRepository;
import com.guardion.app.demo.domain.Users;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class CustomUserDetailsService implements UserDetailsService {

	private final UserRepository userRepository;

	@Override
	public UserDetails loadUserByUsername(String username)
		throws UsernameNotFoundException {
		Users user = userRepository.findByUsername(username)
			.orElseThrow(() -> new UsernameNotFoundException("User not found"));
		return new CustomUserDetails(user);
	}
}
