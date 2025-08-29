package com.guardion.app.demo.security.TokenHash;

import java.security.SecureRandom;
import java.util.Base64;

public final class TokenUtils {
	private static final SecureRandom RND = new SecureRandom();
	private TokenUtils() {}
	// 48바이트 난수 → URL-safe Base64
	public static String randomUrlSafeToken(int bytes) {
		byte[] buf = new byte[bytes];
		RND.nextBytes(buf);
		return Base64.getUrlEncoder().withoutPadding().encodeToString(buf);
	}
}
