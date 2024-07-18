import json
import time
import jwt
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.backends import default_backend

# Load the private key from the file
with open("private_key.pem", "rb") as key_file:
    private_key = serialization.load_pem_private_key(
        key_file.read(),
        password=None,
        backend=default_backend()
    )

# Define the token payload
payload = {
    "iss": "terraform-github@jeffovertonsamples.iam.gserviceaccount.com",
    "sub": "terraform-github@jeffovertonsamples.iam.gserviceaccount.com",
    "aud": "https://oauth2.googleapis.com/token",
    "iat": int(time.time()),
    "exp": int(time.time()) + 3600,
}


# Generate the JWT
token = jwt.encode(
    payload,
    private_key,
    algorithm='RS256'
)

# Save the token to a file
with open('identity-token-file.json', 'w') as f:
    json.dump({"token": token}, f)

print("Generated JWT:", token)