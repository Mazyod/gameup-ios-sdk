Changelog
=========

### v0.6.0

* *BREAKING CHANGES:* Addition of GameUp Session Objects to differentiate between global game activity and per gamer activity
* Added support for `/v0/game/match` endpoint. Now you can build turn-based multiplayer matches much easier.


### v0.5.0

* *BREAKING CHANGES:* Migrating to the new Account Service. 
* *BREAKING CHANGES:* New ways to login anonymously or use passthrough OAuth Tokens
* *BREAKING CHANGES:* Caching API Keys in the GUGameUp client. No longer need to pass in for every operation.
* *BREAKING CHANGES:* Gamer data only has Name - not Given and Family name.

---

### v0.4.0

* Added support for `/v0/game/leaderboard` endpoint.
* Added support for `/v0/gamer/leaderboard` endpoint.

---

### v0.3.0

* *BREAKING CHANGES:* No longer supporting iOS5. Min supported version iOS 6.0
* *BREAKING CHANGES:* Updated AFNetworking to 2.5.0
* *BREAKING CHANGES:* Migrated to use Storyboards rather than views, and uses Size classes.
* Added Request Retry Handlers (with ability to define custom strategies)
* Added code documentation

---

### v0.2.0

* Added support for `/v0/server` endpoint.
* Added support for `/v0/game/achievement` endpoint.
* Added support for `/v0/gamer/achievement` endpoint.
* *BREAKING CHANGES:* (Minor) Renaming of the responder methods

---

### v0.1.0

* Initial release.
