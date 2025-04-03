import { check } from "k6"
import { randomBytes } from "k6/crypto"
import { checksum } from "k6/x/it/crc32"
import { crc32} from "k6/x/it"

export const options = {
    thresholds: {
        checks: ['rate==1'],
    },
};

export default function () {
    const bytes = randomBytes(20)

    check(checksum(bytes), {'crc3232': (sum) => sum == crc32(bytes)})
}
