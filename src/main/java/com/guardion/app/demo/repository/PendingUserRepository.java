package com.guardion.app.demo.repository;

import java.util.Optional;

import javax.swing.text.html.Option;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.guardion.app.demo.domain.PendingUser;

@Repository
public interface PendingUserRepository extends JpaRepository<PendingUser, Long> {
	Optional<PendingUser> findByEmail(String email);
	// boolean existsByEmail(String email);
}
