import base64
import json
import os
from pathlib import Path

from cryptography.hazmat.primitives import serialization


def b64url_uint(val: int) -> str:
    return (
        base64.urlsafe_b64encode(val.to_bytes((val.bit_length() + 7) // 8, "big"))
        .rstrip(b"=")
        .decode("utf-8")
    )


def main() -> None:
    kid = os.environ.get("KID", "epic-test-key-1")
    alg = os.environ.get("ALG", "RS384")

    with open("public_key.pem", "rb") as f:
        pub = serialization.load_pem_public_key(f.read())

    numbers = pub.public_numbers()

    jwks = {
        "keys": [
            {
                "kty": "RSA",
                "use": "sig",
                "kid": kid,
                "alg": alg,
                "n": b64url_uint(numbers.n),
                "e": b64url_uint(numbers.e),
            }
        ]
    }

    out_path = Path("public/.well-known/jwks.json")
    out_path.parent.mkdir(parents=True, exist_ok=True)
    out_path.write_text(json.dumps(jwks, indent=2) + "\n", encoding="utf-8")

    print(f"Wrote {out_path}")


if __name__ == "__main__":
    main()
