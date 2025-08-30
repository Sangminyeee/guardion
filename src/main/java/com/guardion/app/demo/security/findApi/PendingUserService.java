package com.guardion.app.demo.security.findApi;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.guardion.app.demo.domain.PendingUser;
import com.guardion.app.demo.repository.PendingUserRepository;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class PendingUserService {

	private final PendingUserRepository pendingUserRepository;

	@Transactional(propagation = Propagation.REQUIRES_NEW)
	public void increaseAttempts(PendingUser pUser) {
		pUser.setAttempts(pUser.getAttempts() + 1);
		pendingUserRepository.save(pUser);
	}

	@Transactional(propagation = Propagation.REQUIRES_NEW)
	public void deletePendingUser(PendingUser pUser) {
		pendingUserRepository.delete(pUser);
	}
}
