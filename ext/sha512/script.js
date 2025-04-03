import { check } from "k6"
import { randomBytes } from "k6/crypto"
import { sum } from "k6/x/it/sha512"
import { sha512sum } from "k6/x/it"

export const options = {
    thresholds: {
        checks: ['rate==1'],
    },
};

export default function () {
    const bytes = randomBytes(128)

    check(sum(bytes), {'sha512': (s) => s == sha512sum(bytes)})
}
