import { check } from "k6"
import { randomBytes } from "k6/crypto"
import { encode } from "k6/x/it/ascii85"
import { equal, ascii85decode as decode} from "k6/x/it"

export const options = {
    thresholds: {
        checks: ['rate==1'],
    },
};

export default function () {
    const bytes = randomBytes(20)

    check(encode(bytes), {'ascii85': (str) => equal(bytes, decode(str))})
}
