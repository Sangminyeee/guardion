package com.guardion.app.demo.security.findApi;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.guardion.app.demo.domain.User;
import com.guardion.app.demo.repository.UserRepository;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class FindUsernameAssistService {

	private final UserRepository userRepository;

	@Transactional(propagation = Propagation.REQUIRES_NEW)
	public void increaseAttempts(User user) {
		user.setFindUsernameHashCodeAttempts(user.getFindUsernameHashCodeAttempts() + 1);
		userRepository.save(user);
	}

	@Transactional(propagation = Propagation.REQUIRES_NEW)
	public void invalidateFindUsernameHashCode(User user) {
		user.setFindUsernameHashCode(null);
		user.setFindUsernameHashCodeAttempts(0);
		user.setFindUsernameHashCodeExpiresAt(null);
		userRepository.save(user);
	}
}
