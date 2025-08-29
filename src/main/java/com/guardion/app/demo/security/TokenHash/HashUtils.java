package com.guardion.app.demo.security.TokenHash;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public final class HashUtils {
	private HashUtils() {}
	public static byte[] sha256(String s) {
		try {
			MessageDigest md = MessageDigest.getInstance("SHA-256");
			return md.digest(s.getBytes(StandardCharsets.UTF_8));
		} catch (NoSuchAlgorithmException e) { throw new IllegalStateException(e); }
	}
}
