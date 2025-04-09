import { check } from "k6";
import { randomBytes } from "k6/crypto";
import { checksum } from "k6/x/it/crc32";

export default function () {
  const bytes = randomBytes(20);

  console.log(checksum(bytes));
}
