// Railway start wrapper for the SkyWalking Horizon UI.
// Horizon reads its login users only as Argon2id hashes (HORIZON_AUTH_LOCAL_USERS).
// This hashes HORIZON_ADMIN_PASSWORD (a generated Railway secret) at boot, so the
// deployer never handles a hash and there is no default password.
import argon2 from 'argon2';

const env = process.env;
env.HORIZON_SERVER_PORT = env.PORT || env.HORIZON_SERVER_PORT || '8081';

if (!env.HORIZON_AUTH_LOCAL_USERS) {
  const username = (env.HORIZON_ADMIN_USERNAME || 'admin').trim();
  const password = env.HORIZON_ADMIN_PASSWORD || '';
  if (password.length < 12 || password.length > 64) {
    console.error('[railway] HORIZON_ADMIN_PASSWORD must be 12 to 64 characters. Refusing to start without a login.');
    process.exit(1);
  }
  if (!username || username.length > 64) {
    console.error('[railway] HORIZON_ADMIN_USERNAME must be 1 to 64 characters.');
    process.exit(1);
  }
  const passwordHash = await argon2.hash(password, { type: argon2.argon2id });
  env.HORIZON_AUTH_LOCAL_USERS = JSON.stringify([{ username, passwordHash, roles: ['admin'] }]);
  console.log(`[railway] Horizon login configured for user "${username}" (role admin).`);
}

await import('/app/server.js');
