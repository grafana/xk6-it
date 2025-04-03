import { check } from "k6"
import { randomBytes } from "k6/crypto"
import { encode } from "k6/x/it/base32"
import { equal, base64decode as decode} from "k6/x/it"

export const options = {
    thresholds: {
        checks: ['rate==1'],
    },
};

export default function () {
    const bytes = randomBytes(40)

    check(encode(bytes), {'base64': (str) => equal(bytes, decode(str))})
}
