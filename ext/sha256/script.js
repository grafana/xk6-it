import { check } from "k6"
import { randomBytes } from "k6/crypto"
import { sum } from "k6/x/it/sha256"
import { sha256sum } from "k6/x/it"

export const options = {
    thresholds: {
        checks: ['rate==1'],
    },
};

export default function () {
    const bytes = randomBytes(128)

    check(sum(bytes), {'sha256': (s) => s == sha256sum(bytes)})
}
