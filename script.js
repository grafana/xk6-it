import { check } from "k6"
import { randomBytes } from "k6/crypto"
import { base32encode, base32decode, equal } from "k6/x/it"

export const options = {
    thresholds: {
        checks: ['rate==1'],
    },
};

export default function () {
    const bytes = randomBytes(20)
    const encoded = base32encode(bytes)

    check(encoded, {
        'it': (str) => equal(bytes, base32decode(str))
    })
}
