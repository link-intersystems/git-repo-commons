# Script Documentation

## [gradlew_gpg](gradlew_gpg)

Exports a gpg key and executes the `gradlew` in the parent directory.
Any arguments passed to `gradlew_gpg` will be passed to the `gradlew` in the parent directory.

### Use the key fingerpring

You can pass the signing key fingerprint as the first argument

```shell
./gradlew_gpg 1CEFE097A0DC0F8C2F92688 publish
```

### Fingerprint as environment variable

Set the singing key fingerprint as an environment variable. This environment var is then used to look up the key. 

```shell
export GPG_KEY_FINGERPRINT=1CEFE097A0DC0F8C2F92688

./gradlew_gpg publish
```


When the script executes it will ask you for the passphrase

```shell
$ ./gradlew_gpg publish
Enter passphrase: **************

> Configure project :
Signing publications
<-------------> 3% EXECUTING [7s]
> :initializeSonatypeStagingRepository
```

