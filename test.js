import { randomBytes } from "k6/crypto"
import { base32encode, base32decode } from "k6/x/it"
import { expect } from "https://jslib.k6.io/k6-testing/0.6.1/index.js";


export default function () {
    const bytes = randomBytes(20)
    const encoded = base32encode(bytes)

    expect(bytes).toBe(base32decode(encoded))
}
