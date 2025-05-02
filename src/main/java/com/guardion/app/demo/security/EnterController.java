package com.guardion.app.demo.security;

import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.guardion.app.demo.UserRepository.UserRepository;
import com.guardion.app.demo.domain.Users;
import com.guardion.app.demo.security.dto.LoginRequest;
import com.guardion.app.demo.security.dto.SignupRequest;

import jakarta.validation.Valid;
import lombok.AllArgsConstructor;

@RestController
@AllArgsConstructor
public class EnterController {

	private final UserRepository userRepository;
	private final PasswordEncoder passwordEncoder;
	private final JwtProvider jwtProvider;

	@PostMapping("/signup")
	public ResponseEntity<?> register(@RequestBody @Valid SignupRequest request) {
		if (userRepository.existsByUsername(request.getUsername())) {
			return ResponseEntity.badRequest().body("Username already exists");
		}

		Users user = request.toEntity(passwordEncoder.encode(request.getPassword()));
		userRepository.save(user);
		return ResponseEntity.ok("User registered");
	}

	@PostMapping("/login")
	public ResponseEntity<?> login(@RequestBody @Valid LoginRequest request) {
		Users user = userRepository.findByUsername(request.getUsername())
			.orElseThrow(() -> new UsernameNotFoundException("Not found"));

		if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid credentials");
		}

		String token = jwtProvider.createToken(user.getUsername(), user.getRole());
		return ResponseEntity.ok(Map.of("token", token));
	}
}
