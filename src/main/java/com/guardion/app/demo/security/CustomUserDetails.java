package com.guardion.app.demo.security;

import java.util.Collection;
import java.util.List;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import com.guardion.app.demo.domain.User;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class CustomUserDetails implements UserDetails {

	private final User user;

	public String getUsername() { return user.getUsername(); }
	public String getPassword() { return user.getPassword(); }

	@Override
	public Collection<? extends GrantedAuthority> getAuthorities() {
		if (user.getRole() == null) {
			throw new IllegalStateException("User role must not be null or empty");
		}
		return List.of(new SimpleGrantedAuthority(user.getRole().name()));
	}

	@Override public boolean isAccountNonExpired() { return true; }
	@Override public boolean isAccountNonLocked() { return true; }
	@Override public boolean isCredentialsNonExpired() { return true; }
	@Override public boolean isEnabled() { return true; }
}
