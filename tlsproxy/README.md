Import CA PEM in a keystore

```
keytool -importcert -keystore keystore.jks -storepass password -alias ca -file ca.pem -trustcacerts -noprompt
```
